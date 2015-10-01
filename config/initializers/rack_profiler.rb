if Rails.env.development? && ENV['RACK_PROFILE'] == '1'
    require 'rack-mini-profiler'
    Rack::MiniProfilerRails.initialize!(Rails.application)
end
