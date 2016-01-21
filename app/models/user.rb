class User < ActiveRecord::Base
    has_paper_trail :ignore=>[:encrypted_password, :password, :password_confirmation]

    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :ldap_authenticatable, :database_authenticatable, :lockable,
           :recoverable, :rememberable, :trackable, :timeoutable

    # Setup accessible (or protected) attributes for your model
    attr_accessible :email, :is_ldap,
        :password, :password_confirmation,
        :remember_me, :username,
        :user_externals_attributes, :permission_group_id

    attr_accessor :login
    serialize :roles, Array
    belongs_to :lime_user, :foreign_key=>:username, :primary_key=>:users_name
    belongs_to :permission_group, :inverse_of=>:users
    has_many :charts, :inverse_of=>:user, :dependent=>:destroy
    has_many :dashboard_widgets, :through=>:dashboard
    has_many :permission_ls_groups, :through=>:permission_group
    has_many :question_widgets, :dependent=>:delete_all
    has_many :user_externals, :dependent=>:delete_all, :inverse_of=>:user
    has_many :assignment_group_templates, through: :permission_group
    has_one :dashboard, :dependent=>:destroy

    include EdnaConsole::UserHasAssignments

    accepts_nested_attributes_for :user_externals, :allow_destroy=>true

    validates :username,
        :uniqueness => {
            :case_sensitive => false
        },
        :presence => true

    validates :email,
        :uniqueness => {
            :case_sensitive => false
        },
        :presence => true
    ##
    # Assign roles to a user like this:
    # user = User.new
    # user.admin = true
    # user.can_chart = true
    ROLES = {
        :participant=>0,

        # Piecemeal permissions
        :can_dashboard=>1,
        :can_stats=>1,
        :can_reports=>1,
        :can_chart=>1,
        :can_lime=>1,
        :can_lime_all=>1,
        :can_view_spreadsheet=>1,

        # Role permissions
        :admin=>25,
        :superadmin=>50
    }

    ROLES.each{|role, i|
        # setter
        define_method("#{role.to_s}=") do |val_str|
            # parse setter value to boolean
            val =  [1, true, '1'].include?(val_str)
            # Update roles
            if val && !self.roles.include?(role)
                self.roles.push(role)
            elsif !val && self.roles.include?(role)
                self.roles.delete( role )
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
                unless ROLES.include?(role)
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
        attr_accessible role
    }

    def roles_enum
        ROLES.keys
    end

    def title
      self[:full_name] || self[:email]
    end

    def is_ldap?
        self.is_ldap
    end

    ##
    # Overwrite a method inserted by Devise
    #   This allows us to authenticate with either username or email during login
    #   https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
    def self.find_for_database_authentication(warden_conditions)
        conditions = warden_conditions.dup
        if login = conditions.delete(:login)
            where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
        else
            where(conditions).first
        end
    end

    ##
    # Generic setter for devise authentication, allow users to use email or login
    def login=(login)
        @login = login
    end
    ##
    # Generic getter for username or email
    def login
        @login || self.username || self.email
    end

    ##
    # Rails Admin config
    rails_admin do

        navigation_label 'Permissions'
        weight -5

        ##
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
            field :password
            field :password_confirmation
            field :is_ldap
        end

        ##
        # Should be read only
        group :sign_in_details do
            active false
            [:current_sign_in_at, :sign_in_count, :reset_password_sent_at,
            :remember_created_at, :last_sign_in_at, :current_sign_in_ip,
            :last_sign_in_ip].each do |attr|
                field attr
            end
        end

        ##
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
        if self.admin_or_higher?
            @role_aggregates = RoleAggregate.includes(:lime_survey=>[
                :lime_surveys_languagesettings,
                :lime_groups=>[:lime_questions]
            ])
        else
            @role_aggregates = self.permission_group.present? ? self.permission_group.role_aggregates_for(self) : []
        end
        return @role_aggregates.select{|ra|ra.ready_for_use?}
    end

    def explain_survey_access
        if self.admin_or_higher?
            details = ['Admin can see everything']
        elsif permission_group.present?
            details, ra = self.permission_group.explain_role_aggregates_for(self)
            details = details.map{|ra, detail| "#{ra.lime_survey.title}:#{detail}"}.join("<br/>")
        else
            details = ['No permission group set']
        end
        return details.html_safe
    end

    def lime_surveys
        @lime_surveys ||= role_aggregates.map{|ra|ra.lime_survey}
    end

    def institution
        email.to_s.partition('@').last
    end

    def to_param
        username.parameterize
    end
end
