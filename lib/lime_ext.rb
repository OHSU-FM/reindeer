module LimeExt
  @@table_prefix = 'lime'
  if Rails.env == "test"
    @@schema = 'transform'
  else
    @@schema = 'public'
  end

  def self.table_prefix
    @@table_prefix
  end

  def self.schema
    @@schema
  end
end

require 'lime_ext/lime_survey_group'
require 'lime_ext/errors'
require 'lime_ext/response_loaders'
require 'lime_ext/lime_stat'
require 'lime_ext/sync_trigger_parser'
require 'lime_ext/models/poly_table_model'
require 'lime_ext/models/lime_tokens'
require 'lime_ext/models/lime_data'
require 'lime_ext/models/sync_trigger.rb'
require 'lime_ext/sync_trigger_parser.rb'
