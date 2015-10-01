class LimeExt::LimeSurveyParser
  attr_reader :response_row, :token_row, :token_attrs 

  FINDER = /\{([^\}]*)\}/
  def initialize response_row, token_row, token_attrs
    @response_row = hwia(response_row)
    @token_row = hwia(token_row)
    @token_attrs = hwia(token_attrs)
  end

  def parse line
    line.gsub(FINDER) {|key| sub_key(key)}
  end

  private 
    def sub_key key
      key.gsub!(/\{|\}/, '')
      token_key?(key) ? sub_token(key) : sub_response(key)
    end
    
    def token_key? key
      key.upcase.starts_with? 'TOKEN:'
    end
    
    def sub_token key
      key.sub!('TOKEN:', '').downcase!
      token_row.has_key?(key) ? token_row[key] : "{TOKEN:#{key}}"
    end

    def sub_response key
      response_row.has_key?(key) ? response_row[key] : "{#{key}}"
    end

    def hwia h
      HashWithIndifferentAccess.new h
    end
    
end
