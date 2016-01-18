require 'active_support/concern'
module Assignment

  ##
  # Filter to prevent html and script injection attacks on markdown inputs
  # - Does allow simple html entities though, see:
  # http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html 
  module MarkdownFilter
    extend ActiveSupport::Concern

    included do
      include ActionView::Helpers
      before_save :sanitize_markdown 
    end
    
    class_methods do
      def markdown_columns *names
          self.const_set('MARKDOWN_COLS', names)
      end
    end

    private

    def sanitize_markdown
      self.class::MARKDOWN_COLS.each do |col|
        self[col] = sanitize(self[col]) if attr_changed?(col)
      end
    end

    def attr_changed? attr
      self.send "#{attr}_changed?"
    end

  end

end
