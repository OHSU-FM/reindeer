class User < ActiveRecord::Base
  has_paper_trail ignore: [:encrypted_password, :password, :password_confirmation]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :omniauthable
  devise :ldap_authenticatable, :database_authenticatable,
    :recoverable, :rememberable, :trackable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  serialize :roles, Array

  belongs_to :lime_user, foreign_key: :username, primary_key: :users_name
  belongs_to :permission_group, inverse_of: :users
  belongs_to :cohort

  has_many :charts, inverse_of: :user, dependent: :destroy
  has_many :dashboard_widgets, through: :dashboard
  has_many :permission_ls_groups, through: :permission_group
  has_many :question_widgets, dependent: :delete_all
  has_many :user_externals, dependent: :delete_all, inverse_of: :user
  has_many :goals, -> { order 'created_at DESC' }, class_name: 'Coaching::Goal',
    dependent: :destroy
  has_many :meetings, class_name: 'Coaching::Meeting', dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :room, as: :discussable

  has_one :dashboard, dependent: :destroy

  accepts_nested_attributes_for :user_externals, allow_destroy: true

  validates_presence_of :username, uniqueness: { case_sensitive: false }
  validates_presence_of :encrypted_password
  validates_presence_of :email, uniqueness: { case_sensitive: false }
  validates_presence_of :ls_list_state
  validates :ls_list_state, inclusion: {
    in: %w(dirty clean),
    message: "%{value} must be one of dirty or clean"
  }

  validate :ldap_cannot_update_password

  after_initialize :set_default_values

  def ldap_cannot_update_password
    if is_ldap? && encrypted_password_changed?
      errors.add :password, 'cannot be updated for LDAP users'
      return false
    end
  end

  # Assign roles to a user like this:
  # user = User.new
  # user.admin = true
  # user.can_chart = true
  ROLES = {
    # can view assignments that they belong to
    participant: 0,

    # Piecemeal permissions
    can_dashboard: 1,
    can_stats: 1,
    can_reports: 1,
    can_chart: 1,
    can_lime: 1,
    can_lime_all: 1,
    can_view_spreadsheet: 1,
    can_create_assignment_group: 1,

    # Role permissions
    admin: 25,
    superadmin: 50 }

  ROLES.each{|role, i|
    # setter
    define_method("#{role.to_s}=") do |val_str|
      # parse setter value to boolean
      val =  [1, true, '1'].include? val_str
      # Update roles
      if val && !self.roles.include?(role)
        self.roles.push role
      elsif !val && self.roles.include?(role)
        self.roles.delete role
      end
    end

    # ? style getter for ROLES
    define_method("#{role}?") do
      return self.roles.include? role
    end

    # ? _or_higher getter for ROLES
    define_method("#{role}_or_higher?") do
      self.roles.each do |role|
        # Does this role actually exist?
        # log error if not
        unless ROLES.include? role
          Rails.logger.error("<#{self.class} id:#{self.id} bad_role:#{role}>")
          next
        end
        return true if ROLES[role] >= i
      end
      return false
    end

    # getter for ROLES
    define_method(role) do
      self.roles.include? role
    end
  }

  def roles_enum
    ROLES.keys
  end

  COACHING_ROLES = {
    'dean': 30,
    'coach': 20,
    'student': 10
  }

  # define "#{role}?" style getters for coaching system
  COACHING_ROLES.each do |role, val|
    define_method("#{role.to_s}?") do
      coaching_type == role.to_s
    end

    define_method("#{role.to_s}_or_higher?") do
      return true if admin_or_higher?
      COACHING_ROLES[coaching_type.to_sym] >= val
    end
  end

  def title
    self[:full_name] || self[:email]
  end

  def display_name name=full_name
    comma_re = /^\s*(\w{1,20} *[^,]*)+,\s+(\w{1,20}\s*)+$/ # last, first
    if name.nil?
      username
    elsif comma_re === name
      name.split(", ").reverse.join(" ")
    else
      name
    end
  end

  def is_ldap?
    self.is_ldap
  end

  # Overwrite a method inserted by Devise
  #   This allows us to authenticate with either username or email during login
  #   https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(
        ["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]
      ).first
    else
      where(conditions).first
    end
  end

  # Generic setter for devise authentication, allow users to use email or login
  def login= login
    @login = login
  end

  # Generic getter for username or email
  def login
    @login || self.username || self.email
  end

  def get_ls_list_state
    ls_list_state
  end

  def dirty_ls_list
    self.ls_list_state = "dirty"
    save!
  end

  def has_dirty_ls_list?
    self.ls_list_state == "dirty"
  end

  def clean_ls_list
    self.ls_list_state = "clean"
    save!
  end

  def has_clean_ls_list?
    self.ls_list_state == "clean"
  end

  # Rails Admin config
  rails_admin do

    navigation_label 'Permissions'
    weight -5

    # Default group
    group :account do
      active false
      field :id do
        read_only true
      end
      field :institution do
        read_only true
      end
      field :lime_user do
        read_only true
      end
      field :email
      field :username
      field :full_name
      field :password
      field :password_confirmation
      field :is_ldap
      field :cohort
    end

    # Should be read only
    group :sign_in_details do
      active false
      [:current_sign_in_at, :sign_in_count, :reset_password_sent_at,
       :remember_created_at, :last_sign_in_at, :current_sign_in_ip,
       :last_sign_in_ip].each do |attr|
         field attr
       end
    end

    # should be read only
    group :forms do
      active false
      field :dashboard
      field :charts
    end

    group :site_permissions do
      active false
      ROLES.each{|key, val|
        field key, :boolean
      }
    end

    group :survey_access do
      active false
      field :permission_group, :belongs_to_association do
        inline_edit false
        inline_add false
      end

      field :user_externals, :has_many_association
      field :explain_survey_access do
        partial 'users/field_explain_survey_access'
      end
      field :ls_list_state, :enum do
        enum do
          ["dirty", "clean"]
        end
        default_value "dirty"
      end
      field :permission_ls_groups do
        read_only true
      end

    end

    edit do
      [
        :current_sign_in_at, :sign_in_count, :reset_password_sent_at,
        :remember_created_at, :last_sign_in_at, :current_sign_in_ip,
        :last_sign_in_ip, :charts, :roles_mask
      ].each do |attr|
        configure attr do
          read_only true
        end
      end
    end

    list do
      include_fields :id, :username, :email, :permission_group, :is_ldap, :can_dashboard, :can_chart,
        :admin, :superadmin
      exclude_fields :lime_user, :password, :password_confirmation, :explain_survey_access,
        :user_externals, :current_sign_in_at, :sign_in_count, :permission_ls_groups,
        :reset_password_sent_at, :dashboard, :charts, :remember_created_at,
        :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip,
        :participant, :can_stats, :can_reports, :can_lime, :can_view_spreadsheet, :can_lime_all
    end

    exclude_fields [:roles]

  end

  def role_aggregates
    return @role_aggregates if defined? @role_aggregates
    @role_aggregates = []
    if admin_or_higher?
      @role_aggregates = RoleAggregate.includes(:lime_survey=>[
        :lime_surveys_languagesettings,
        :lime_groups=>[:lime_questions]
      ]).select{|ra|ra.ready_for_use?}
    else
      @role_aggregates = permission_group.present? ? permission_group.role_aggregates_for(self) : []
    end
    return @role_aggregates
  end

  def explain_survey_access
    if admin_or_higher?
      details = 'Admin can see everything'
    elsif permission_group.present?
      details, ra = self.permission_group.explain_role_aggregates_for(self)
      details = details.map{|ra, detail| "#{ra.lime_survey.title}:#{detail}" }.join("<br/>")
    else
      details = 'No permission group set'
    end
    return details.html_safe
  end

  def lime_surveys
    if has_dirty_ls_list? or admin_or_higher? or Redis.current.smembers("user:#{id}:ls_p_list").empty?
      ls_list = role_aggregates.map{|ra| ra.lime_survey }
      unless ls_list.empty?
        Redis.current.sadd("user:#{id}:ls_p_list", ls_list.map{|ls| ls.sid })
      end
      self.clean_ls_list
      ls_list
    else
      sids = Redis.current.smembers("user:#{id}:ls_p_list")
      LimeSurvey.where(sid: sids)
    end
  end

  def lime_surveys_by_most_recent n = nil
    surveys = lime_surveys.sort_by { |s|
      next unless s.lime_data.column_names.include? "submitdate"
      ActiveRecord::Base.connection.execute(
        """
        SELECT submitdate FROM lime_survey_#{s.sid} WHERE submitdate IS NOT null;
        """
      ).max_by{|k, v| next unless v.present?; v.to_date}.values.first.to_date
    }.reverse!
    n.present? ? surveys.first(n) : surveys
  end

  def institution
    email.to_s.partition('@').last
  end

  def to_param
    username.to_s
  end

  def pinned_survey_groups
    permission_group.present? ? permission_group.pinned_survey_groups : []
  end

  def survey_groups
    permission_group.present? ? permission_group.survey_groups : []
  end

  def cohorts
    return @cohorts if defined? @cohorts
    @cohorts ||= admin_or_higher? ? Cohort.all : Cohort.where(owner: self)
    return @cohorts
  end

  private

  def set_default_values
    return unless room.nil?
    Room.create(discussable: self, identifier: "student_room_#{self.id}")
  end
end
