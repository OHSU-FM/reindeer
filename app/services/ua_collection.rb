# array class for holding user_assignments
class UACollection < Array

  def initialize items=nil, opts={}
    @filter = *opts[:filter]
    items = *items
    items.each { |item| push(item) if in_filter?(item) }
  end

  def in_filter? item
    @filter.empty? || @filter.include?(item.title)
  end

  def survey_types_enum
    map {|ua| ua.survey_type }.uniq.reject{|st| st.empty? }
  end

  def hash_with_survey_type_keys
    survey_types_enum.reduce({}){|a, v| a[v] = []; a}
  end

end

