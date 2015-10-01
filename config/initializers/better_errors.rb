begin
    if defined?(BetterErrors) && Rails.env.development?
        BetterErrors.editor = proc { |full_path, line|
            "vim://#{full_path}?line=#{line}"
        }
    end
end
