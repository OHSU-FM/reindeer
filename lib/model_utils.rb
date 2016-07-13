module ModelUtils

  def strip_hash_values! hash
    hash.each do |k,v|
      case v
      when String
        v.strip!
      when Array
        v.each {|av| av.strip!}
      when Hash
        strip_hash_values! v
      end
    end
  end
end
