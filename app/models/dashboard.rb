class Dashboard < ActiveRecord::Base

  class WidgetExpired < Exception; end

  has_paper_trail

  belongs_to :user
  has_many :dashboard_widgets, :inverse_of=>:dashboard, :dependent=>:destroy
  accepts_nested_attributes_for :dashboard_widgets, :allow_destroy=>true
  validates_presence_of :user

  rails_admin do
    navigation_label 'User Content'
    field :user do
      read_only true
    end
    field :theme, :enum
    field :dashboard_widgets
  end

  THEMES = [
    'theme-waterfront-fog',
    'theme-oregon-coast',
    'theme-ncg-2070',
    'theme-tillikum',
    'theme-bokeh',
    'theme-sunset',
    'theme-glass',
    'theme-fog',
    'theme-blue-swirl',
    'theme-grid',
    'theme-blue-sky',
    'theme-black']

  DEFAULT_THEME = THEMES[0]

  def title
    "Dashboard: #{id} User:#{user.username}"
  end

  def theme_enum
    THEMES
  end

  def theme
    self[:theme] || DEFAULT_THEME
  end

  def first_empty_col
    dashboard_widgets.present? ? dashboard_widgets.map {|w| w.position }.max % 6 + 1 : 1
  end

  def first_empty_row
    dashboard_widgets.present? ? (dashboard_widgets.map {|w| w.position }.max - 1)/ 5 + 1 : 2
  end

  def validate_widget_positions
    @widget_positions = []
    detector = EdnaConsole::DashboardLib::CollisionDetector.new :max_cols=>5
    dashboard_widgets.sort_by{|widget|widget.position}.each_with_index do |widget, index|
      begin
        indecies = detector.register_rectangle widget.position, widget.sizex, widget.sizey, index
        new_pos = indecies.min
        widget.position = new_pos
        widget.col, widget.row = detector.pos_to_coord(new_pos)
      rescue EdnaConsole::DashboardLib::Errors::ExhaustedError => e
        widget.errors.add :position, "Unable to place widget on dashboard"
      rescue EdnaConsole::DashboardLib::Errors::CollisionError => e
        widget.errors.add :position, "Widget overlaps with other objects on the dashboard"
      rescue EdnaConsole::DashboardLib::Errors::WidgetTooWideError => e
        widget.errors.add :sizex, "Widget is too large"
      end
    end
  end

end

