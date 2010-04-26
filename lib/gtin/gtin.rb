# GTIN-12 (UPC-A): this is a 12-digit number used primarily in North America
# GTIN-8 (EAN/UCC-8): this is an 8-digit number used predominately outside of North America
# GTIN-13 (EAN/UCC-13): this is a 13-digit number used predominately outside of North America
# GTIN-14 (EAN/UCC-14 or ITF-14): this is a 14-digit number used to identify trade items at various packaging levels

module GTIN
  def generate_check_digit
    numbers = self.to_s.gsub(/[\D]+/, "").split(//)

    checksum = 0
    case numbers.length
    when 7
      0.upto(numbers.length-1) do |i| checksum += numbers[i].to_i * ((i-1)%2*3 +i%2) end
    when 11
      0.upto(numbers.length-1) do |i| checksum += numbers[i].to_i * ((i-1)%2*3 +i%2) end
    when 12
      0.upto(numbers.length-1) do |i| checksum += numbers[i].to_i * (i%2*3 +(i-1)%2) end
    when 13
      0.upto(numbers.length-1) do |i| checksum += numbers[i].to_i * ((i-1)%2*3 +i%2) end
    else
      0
    end

    return ((10 - checksum % 10)%10).to_s
  end

  def ean?
    numbers = self.to_s.gsub(/[\D]+/, "").split(//)

    checksum = 0
    case numbers.length
    when 8
      0.upto(numbers.length-2) do |i| checksum += numbers[i].to_i * ((i-1)%2*3 +i%2) end
    when 13
      0.upto(numbers.length-2) do |i| checksum += numbers[i].to_i * (i%2*3 +(i-1)%2) end
    when 14
      0.upto(numbers.length-2) do |i| checksum += numbers[i].to_i * ((i-1)%2*3 +i%2) end
    else
      return false
    end

    return numbers[-1].to_i == (10 - checksum % 10)%10
  end
  
  def upc?
    value = self.to_s.gsub(/[\D]+/, "").split(//)
    return false if value.length != 12
    valid_checksum? value
  end

  # Determine if a gtin value has a valid checksum
  def valid_checksum?(value)
    checksum = 0
    0.upto(value.length-2) do |i| 
      value%2 == 0 ? 
        (checksum += value[i].to_i * ((i-1)%2*3 +i%2)) :
        (checksum += numbers[i].to_i * (i%2*3 +(i-1)%2))
    end
    value[-1].to_i == (10 - checksum % 10)%10    
  end


  # GTIN-12 (UPC-A): this is a 12-digit number used primarily in North America
  def to_gtin_12(number)
    to_gtin(number, 12)
  end
  alias :to_upc   :to_gtin_12
  alias :to_upc_a :to_gtin_12
  
  
  # GTIN-8 (EAN/UCC-8): this is an 8-digit number used predominately outside of North America
  def to_gtin_8(number)
    to_gtin(number, 8)
  end
  alias :to_ean_8 :to_gtin_8
  alias :to_ucc_8 :to_gtin_8
  
  
  # GTIN-13 (EAN/UCC-13): this is a 13-digit number used predominately outside of North America
  def to_gtin_13(number)
    to_gtin(number, 13)
  end
  alias :to_ean_13 :to_gtin_13
  alias :to_ucc_13 :to_gtin_13
  alias :to_ean    :to_gtin_13


  # GTIN-14 (EAN/UCC-14 or ITF-14): this is a 14-digit number used to identify trade items at various packaging levels
  def to_gtin_14(number)
    to_gtin(number, 14)
  end
  alias :to_gtin :to_gtin_14
  
  def to_gtin(number, size)
    "%0#{size}d" % number.to_s.gsub(/[\D]+/, "")
  end
end

# Extend String to include these methods
class String
  include GTIN
end

# Extend Numberic to include these methods
class Numeric
  include GTIN
end