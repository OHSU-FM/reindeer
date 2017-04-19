class LimeExt::SyncTrigger < ActiveRecord::Base
  MAX_COL_COUNT = 15
  self.table_name = :pg_trigger
  self.primary_key = :tgrelid

  default_scope {
    where(['tgname LIKE ? AND tgname LIKE ?', "tr_#{rule_prefix}%", "%cleaner"]) }

  attr_accessible :sid_src, :sid_dest, :cols, :map_src, :map_dest
  attr_accessor :sid_src, :sid_dest, :cols, :map_src, :map_dest

  validates_presence_of :sid_src, :sid_dest, :cols, :map_src, :map_dest
  validates_presence_of :lime_survey_src, :lime_survey_dest
  validates_length_of :cols, minimum: 1, maximum: MAX_COL_COUNT, allow_blank: false

  def strip_tags(val)
    ActionView::Base.full_sanitizer.sanitize(val)
  end

  ##
  # LimeSurveys that actually have response tables
  def self.available_surveys
    LimeSurvey.where(['sid in (?)', available_sids])
  end

  ##
  # name prefix for
  def self.rule_prefix; @rule_prefix ||= "lsrule"; end
  def lime_survey_dest; @lime_survey_dest ||= get_survey(sid_dest); end
  def lime_survey_src; @lime_survey_src ||= get_survey(sid_src); end
  def get_survey(sid); sid.present? ? LimeSurvey.find(sid) : nil; end
  def parser; @parser ||= LimeExt::SyncTriggerParser.new self.tgname; end
  def sid_src; @sid_src ||= parser.sid_src; end
  def sid_dest; @sid_dest ||= parser.sid_dest; end
  def map_src; @map_src ||= parser.map_src; end
  def map_dest; @map_dest ||= parser.map_dest; end
  def cols; @cols ||= parser.cols; end
  def rulename; @rulename ||= new_record? ? '' : self[:rulename]; end
  def name; tgrelid; end
  def src_table; "#{LimeExt.table_prefix}_survey_#{sid_src}"; end
  def dest_table; "#{LimeExt.table_prefix}_tokens_#{sid_dest}"; end
  def surveys_table; "#{LimeExt.table_prefix}_surveys"; end
  def suffix; "#{self.class.rule_prefix}_sync_#{sid_src}_#{sid_dest}"; end
  ##
  # Do we have too many keys in the columns hash?
  def too_many_cols?; cols.count >= MAX_COL_COUNT; end
  ##
  # Are we ready to start using the cols enum?
  def cols_enum_ready?; sid_src.present? && sid_dest.present?; end

  ##
  # Should we allow building a new column?
  def allow_more_cols?
    !cols_enum_empty? && cols_enum_ready? && !(cols.values.include?('') || cols.values.include?(nil)) && cols.values.count < MAX_COL_COUNT
  end

  ##
  #
  def gen_rulename
    @rulename = "#{self.class.rule_prefix}_#{sid_src}_#{sid_dest}"
  end

  ##
  # Enumerator for sid_sources
  def sid_src_enum
    @sid_src_enum ||= LimeSurvey.all.
      select{|ls|ls.lime_data.column_names.include?('token') && ls.sid.to_s != self.sid_dest.to_s  }.
      map{|ls|[strip_tags(ls.title), ls.sid]}
  end

  ##
  # Enumerator for sid_destinations
  def sid_dest_enum
    return @sid_dest_enum if defined? @sid_dest_enum
    @sid_dest_enum ||= LimeSurvey.all.select{|ls|
        ls.token_attrs.count > 0 && ls.sid.to_s != self.sid_src.to_s
      }.map{|ls|[strip_tags(ls.title), ls.sid]}
  end

  ##
  # Enumerator for col hash keys
  def cols_src_enum except_id=nil
    cols_enum_filter(sid_src, cols.keys, except_id) do |sid|
      LimeQuestion.where(sid: sid).map{|lq| ["#{lq.title} (qid:#{lq.qid})", lq.my_column_name]}
    end
  end

  ##
  # Enumerator for col hash values
  def cols_dest_enum except_id=nil
    cols_enum_filter(sid_dest, cols.values, except_id) do |sid|
      cols = lime_survey_dest.token_attrs.map{|k, hv|["#{hv['description']} (#{k})", k]}
      Hash[cols]
    end
  end

  ##
  # Is either one of the two enums empty?
  def cols_enum_empty?
    cols_enum_ready? && (cols_dest_enum.empty? || cols_src_enum.empty?)
  end

  ##
  # List all available values that are not already used
  def cols_enum_filter(sid, vals, except_id)
    return [] unless cols_enum_ready?
    @cols_enum_filter = {} unless defined? @cols_enum_filter
    sid = sid.to_s
    unless @cols_enum_filter.keys.include?(sid)
      @cols_enum_filter[sid] = yield(sid)
    end
    result = @cols_enum_filter[sid]
    # select all qids that have not been selected or are self
    vals.delete(except_id.to_s) if except_id.present?
    return result.select{|qtext, qid| !vals.include?(qid.to_s)}
  end

  def map_src_enum
    [[:token, :token]] + cols_src_enum(map_src)
  end

  def map_dest_enum
    cols_dest_enum(map_dest)
  end

  ##
  # Query used to create rule
  def create_queries
    gen_rulename
    ["
      -- FN for sync updates
      CREATE FUNCTION fn_#{suffix}()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS $function$
        BEGIN
          UPDATE #{dest_table}
          SET #{ cols.map{|src, dest| "\"#{dest}\" = NEW.\"#{src}\"" }.join(', ') }
          WHERE \"#{map_dest}\" = NEW.\"#{map_src}\";
          RETURN NULL;
        END;
      $function$;",
      "
      -- TR for sync updates
      CREATE TRIGGER tr_#{suffix}
        AFTER INSERT OR UPDATE ON #{src_table}
        FOR EACH ROW EXECUTE PROCEDURE fn_#{suffix}();",
      "
      -- FN for cleaner
      CREATE FUNCTION fn_#{suffix}_cleaner()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS $function$
        BEGIN
          IF OLD.sid = #{sid_src} OR OLD.sid = #{sid_dest} THEN
            #{delete_queries.join(' ')}
          END IF;
          RETURN NULL;
        END;
      $function$;",
    "
    -- TR for cleaner
    CREATE TRIGGER tr_#{suffix}_cleaner
      AFTER DELETE ON #{surveys_table}
      FOR EACH ROW EXECUTE PROCEDURE fn_#{suffix}_cleaner();
    "]
  end

  ##
  # Query used to delete rule
  def delete_queries
    [ "DROP FUNCTION fn_#{suffix}() CASCADE;",
      "DROP FUNCTION fn_#{suffix}_cleaner() CASCADE;"]
  end

  ##
  #
  def tr_delete tr
    "DROP TRIGGER #{tr} ON (
      SELECT relname
      FROM pg_trigger pgt
      JOIN pg_class pgc
        ON pgc.oid = pgt.tgrelid
      WHERE tgname = '#{tr}'
      LIMIT 1);"
  end

  def delete_query
    delete_queries.join("\n")
  end

  ##
  # destroy action
  def destroy
    ActiveRecord::Base.transaction do
      delete_queries.each do |q|
        ActiveRecord::Base.connection.execute(q)
      end
    end
  end

  def delete; destroy; end

  ##
  # save action
  def save

    if cols.count == 0
      errors.add(:cols, 'should be greater than zero')
      return false
    end
    ActiveRecord::Base.transaction do
      unless new_record?
        destroy
      end
      create_queries.each do |create_q|
        ActiveRecord::Base.connection.execute(create_q)
      end
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:tgname, e.message)
    false
  end

  def save!
    raise ActiveRecord::RecordInvalid.new(self) unless save
  end

  ##
  # Updates not allowed
  def update
    raise NotImplementedError.new()
  end

  private
  ##
  # Return array of sids that are available
  # - Token table exists
  # - Responses table exists
  def self.available_sids
    r_prefix = "#{LimeSurvey.table_name.singularize}_"
    t_prefix = "#{LimeExt.table_prefix}_tokens_"
    query = "
    SELECT responses.sid
      FROM (
        SELECT replace(table_name, '#{r_prefix}', '')::integer as sid
          FROM information_schema.tables
          WHERE table_name ~ '^#{r_prefix}\\d+$'
          ) as responses
      JOIN (
        SELECT replace(table_name, '#{t_prefix}', '')::integer as sid
          FROM information_schema.tables
          WHERE table_name ~ '^#{t_prefix}\\d+$'
      ) as tokens
        ON tokens.sid = responses.sid
    "
    ActiveRecord::Base.connection.select_values(sanitize_sql(query)).collect(&:to_i)
  end
end
