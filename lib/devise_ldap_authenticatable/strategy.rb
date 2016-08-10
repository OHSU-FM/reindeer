require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable

      def authenticate!
        ##
        # We have modified the devise system to allow database logins with either a username or email address
        # This means that we also have to modify the ldap authentication as well
        # - because the virtual "login" field does not exist, database throws an error
        xlogin = authentication_hash[:login]
        resource = User.where(['username = ? OR email = ?', xlogin, xlogin]).first
        return fail(:invalid) unless resource
        return false unless resource.is_ldap?

        success!(resource)

      end
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)

