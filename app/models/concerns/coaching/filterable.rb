# https://www.justinweiss.com/articles/search-and-filter-rails-models-without-bloating-your-controller/

module Coaching::Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filterable filtering_params
      results = self.where nil # start with an empty scope
      filtering_params.each do |key, param|
        results.public_send(key, value) if value.present?
      end

      results
    end
  end
end
