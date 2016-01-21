module UserAssignmentsHelper

  def hf_ua_button record, parent_id, opts={}
    opts = {
        class: "fa fa-arrow-circle-right btn btn-md btn-default",
      }.merge(opts)
    if record.assig.completed?
      content_tag(:i, '', class:'fa fa-check success')
    elsif record.as_inline?
      hf_ua_button_accordion(record, parent_id, opts)
    else
      opts[:target] = '_blank'
      link_to('', record.url, opts)
    end
  end

  def hf_ua_button_accordion record, parent_id, opts={}
    opts = {
        data: {toggle: :collapse, parent: "##{parent_id}", url: record.url, as_inline: record.as_inline?},
        aria: {expanded: false, controls: "collapse_ua_#{record.assig.id}"}
    }.merge(opts)
    link_to('', "#collapse_ua_#{record.assig.id}", opts)
  end

  def hf_ua_link_accordion record, parent_id, opts={}
    opts = {
        name: record.name,
        data: {toggle: :collapse, parent: "##{parent_id}", url: record.url, as_inline: record.as_inline?},
        aria: {expanded: false, controls: "collapse_ua_#{record.assig.id}"}
    }.merge(opts)
    name = opts.delete(:name).to_s
    link_to(name, "#collapse_ua_#{record.assig.id}", opts)
  end

  def hf_ua_link record, parent_id, opts={}
    opts[:class] =  "ua-iframe-link"
    if record.assig.completed?
      content_tag(:i, '', class:'fa fa-check success')
    elsif record.as_inline?
      hf_ua_link_accordion(record, parent_id, opts)
    else
      opts[:class] += ' fa fa-external-link'
      opts[:target] = '_blank'
      link_to(record.name, record.url, opts)
    end
  end

  ##
  # Proxy class for UserAssignment
  class AssigPart
    attr_reader :assig, :group, :name, :parser
    STATES = {
      'not started' => 'default',
      'started' => 'info',
      'edit' => 'primary',
      'new form' => 'default',
      'complete' => 'success'
    }

    def initialize group, assig, title
      @group = group
      @assig = assig
      @parser = LimeExt::LimeSurveyParser.new assig.response_data,
        assig.token_data, assig.lime_survey.token_attrs
      @name = parser.parse(title)
    end

    def url; assig.new_url; end
    def status_class; STATES[assig.status_str]; end
    def start_date; assig.token_attrs[:valid_from]; end
    def status; parser.parse(assig.status_str); end
    def id; assig.id; end
    def as_inline?; assig.survey_assignment.as_inline; end

    ##
    # Should we open a link for this assignment in an iframe?
    def iframe_css_class
      cls = assig.embedded_form ? 'ua-iframe-link' : ''
      cls += 'fa fa-external-link' unless as_inline?
    end
  end

  ##
  # Group Assignments
  class VirtualAssignmentGroup
    attr_reader :assignments

    def initialize assignments
      @assignments = assignments
    end

    def groups
      return @groups if defined? @groups
      @groups = {}
      assignments.each do |assig|
        group, title = assig.lime_survey.group_and_title_name
        @groups[group] = [] unless @groups.keys.include?(group)
        @groups[group].push AssigPart.new(group, assig, title)
      end
      @groups
    end

    private
      def method_missing(method, *args, &block)
        @assignments.send(method, *args, &block)
      end
  end
end
