module ApplicationHelper

    # Link wrapped in li for use in the nav bar 
    def nav_link_to text, link, opts={}
        content_tag :li, link_to(text, link, opts), class: (nav_link_active?(link) ? 'active' : '')
    end

    def nav_link_active? link
        request.path == link
    end

    # Flash message css classes for use with bootstrap
    def flash_class(level)
        case level
            when 'notice' then "info"
            when 'success' then "success"
            when 'error' then "danger"
            when 'alert' then "warning"
            else level.to_s
        end
    end

    def public_file_path(source)
      "#{root_path}#{source}"
    end

    # very useful methods, improves caching efficiency and allows division of controller specific CSS/JS
    def controller_stylesheet_link_tag
      stylesheet = "#{params[:controller]}.css" #e.g. home_controller =>assets/stylesheets/home.css
      #if stylesheet asset exists include it
      unless Rails.application.assets.find_asset(stylesheet).nil?
        stylesheet_link_tag stylesheet
      end
    end

    def controller_javascript_include_tag
      javascript = "#{params[:controller]}.js" #e.g. home_controller =>assets/javascripts/home.js
      unless Rails.application.assets.find_asset(javascript).nil?
        javascript_include_tag javascript
      end
    end

    ##
    # Full name of controller with dashes separating modules
    def controller_full_name
        controller.class.name.sub('Controller','').gsub('::','/').underscore
    end

    def navbar_css_class
        Rails.env.production? ? 'navbar-default' : 'navbar-inverse'
    end
    
    # very useful methods, improves caching efficiency and allows division of controller specific CSS/JS
    def custom_stylesheet_link_tag
      stylesheet = "custom/style.css" #e.g. home_controller =>assets/stylesheets/home.css
      #if stylesheet asset exists include it
      unless Rails.application.assets.find_asset(stylesheet).nil?
        stylesheet_link_tag stylesheet
      end
    end

    def custom_javascript_include_tag
      javascript = "custom/style.js" #e.g. home_controller =>assets/javascripts/home.js
      unless Rails.application.assets.find_asset(javascript).nil?
        javascript_include_tag javascript
      end
    end

    def current_user_theme
      dash = current_user.dashboard || Dashboard.new
      dash.theme
    end
end
