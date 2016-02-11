class DashboardWidget < ActiveRecord::Base
    has_paper_trail

    belongs_to :widget, :polymorphic=>true
    belongs_to :dashboard, :inverse_of=>:dashboard_widgets
    attr_accessible :position, :widget_id, :widget_type, :sizex, :sizey, :widget, :widget_title
    attr_accessor :status

    # Always require a dashboard
    validates_presence_of :dashboard
    # Only require existence of widget if one was added
    validates_presence_of :widget, :if=> Proc.new { |o| !(o.widget_type.nil? || o.widget_id.nil?) }
    #
    before_save :set_status
    after_save :set_status
    before_destroy :optionally_delete_widget

    # Limit widget to only these types
    WIDGET_ALLOWABLE_TYPES = ['Chart', 'QuestionWidget', 'Page']
    DEPENDENT_DESTROY_TYPES = ['QuestionWidget']
    EDITABLE_WIDGETS = ['Chart']
    validates :widget_type, :inclusion=> { :in => WIDGET_ALLOWABLE_TYPES }, :allow_blank=>true

    rails_admin do
        include_all_fields
        navigation_label 'User Content'

        field :dashboard do
            read_only true
        end
        field :widget_id, :enum do
            label 'Widget Id'
        end
        field :widget_type, :enum
        field :widget do
            read_only true
        end
        field :sizex
        field :sizey
        field :position
        field :resizeable
        field :editable_widget? do
            read_only true
        end
    end

    def widget_type_enum
        {'Chart'=>'Chart'}
    end

    def widget_id_enum
        return [] unless widget_type_enum.keys.include? widget_type
        widget_type.constantize.where(:user_id=>dashboard.user_id).map do |record|
            title = record.title.strip.empty? ? "Untitled" : record.title
            [title, record.id]
        end
    end

    # set default position to 1
    def position
        self[:position] || 1
    end

    def set_status
        if widget_id_changed? || widget_type_changed?
            status.push 'refresh-widget'
        elsif status.include? 'new-record'
            status.delete 'new-record'
            status.push 'freshly-created'
        end
    end

    def status
        @status ||=[]
        if new_record?
            @status.push 'new-record'
        end
        @status.uniq!
        @status
    end

    def content

    end

    def editable_widget?
        # Should we allow this widget to be edited?
        return true if self.widget_type.to_s == ""          # Editable if nothing is set
        return EDITABLE_WIDGETS.include?(self.widget_type)  # Editable if in editable types
    end

    ##
    # Dump widget to json
    def as_json(options=nil)
        super({:include =>{:widget=>{:methods=>:content}}}.merge(options || {}))
    end

    def optionally_delete_widget
        return unless widget
        widget.destroy if DEPENDENT_DESTROY_TYPES.include? widget_type
    end

    deprecate :content
end
