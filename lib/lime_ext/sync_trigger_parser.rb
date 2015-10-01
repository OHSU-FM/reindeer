module LimeExt
  class SyncTriggerParser

    attr_accessor :sid_src, :sid_dest, :map_src, :map_dest, :cols

    def initialize tgname
      @tgname = tgname
    end


    def sid_src
      return nil unless @tgname.present?
      @tgname.split('_')[3]
    end
    
    def sid_dest
      return nil unless @tgname.present?
      @tgname.split('_')[4]
    end
    
    def map_src
      @map_src ||= map_parser[0] || nil
    end
    
    def map_dest
      @map_dest ||= map_parser[1] || nil
    end

    def map_parser
      
      line = src.lines.find{|ln|ln.include?('WHERE ')}
      return [nil, nil] unless line
      line.gsub(/NEW |"|;|WHERE /,'').split(' = ')
    end

    def cols
      isdefined = defined?(@cols)
      @cols ||= {}
      return @cols if isdefined

      return unless src.present?
      src[/SET(.*?)WHERE/m, 1].split(',').map do |ln|
        key_pair = ln.sub('SET ','').gsub(/"|;/,'').sub('NEW.','').split(' = ')
        @cols[key_pair[0]] = key_pair[1]
      end
      @cols
    end

    def src
      return '' unless @tgname.present?
      qarr = ["SELECT prosrc FROM pg_proc WHERE proname = ?", tg_base_name]
      query = ActiveRecord::Base.send(:sanitize_sql_array, qarr) 
      @src ||= ActiveRecord::Base.connection.execute(query)[0]['prosrc']
    end

    def tg_base_name
      @tgname.to_s.sub('_cleaner','').sub(/^tr_/, 'fn_')
    end

    def fn_detail
      qarr = ["SELECT proname, prosrc FROM pg_proc WHERE proname LIKE ?", "%#{sid_src}_#{sid_dest}%"]
      query = ActiveRecord::Base.send(:sanitize_sql_array, qarr)
      @fn_detail ||= ActiveRecord::Base.connection.execute(query).map{|rec|[rec['proname'], rec['prosrc']]}
    end

  end
end
