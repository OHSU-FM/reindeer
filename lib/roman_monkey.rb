class Integer

  # recursive
  def to_roman(number = self, result = "")
    return result if number == 0
    roman_mapping.keys.each do |divisor|
      quotient, modulus = number.divmod(divisor)
      result << roman_mapping[divisor] * quotient
      return to_roman(modulus, result) if quotient > 0
    end
  end

  # iterative
  def to_roman
    result = ""
    number = self
    roman_mapping.keys.each do |divisor|
      quotient, modulus = number.divmod(divisor)
      result << roman_mapping[divisor] * quotient
      number = modulus
    end
    result
  end

  private

  def roman_mapping
    {
      1000 => "M",
      900 => "CM",
      500 => "D",
      400 => "CD",
      100 => "C",
      90 => "XC",
      50 => "L",
      40 => "XL",
      10 => "X",
      9 => "IX",
      5 => "V",
      4 => "IV",
      1 => "I"
    }
  end

end
