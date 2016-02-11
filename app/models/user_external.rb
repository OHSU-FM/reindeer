class UserExternal < ActiveRecord::Base
    has_paper_trail

    belongs_to :user, :inverse_of=>:user_externals
    validates_presence_of :ident_type
    validates_presence_of :ident, :unless=>Proc.new{|ue|ue.use_email == true}
    attr_accessible :ident, :ident_type, :filter_all, :use_email

    rails_admin do
        navigation_label 'Permissions'
        field :user
        field :use_email
        field :ident do
            required false
        end
        field :ident_type
    end

    ##
    # RailsAdmin title
    def name
        return "#{ident_type}"
    end

    def filter_val
        use_email ? user.email : ident
    end

end

