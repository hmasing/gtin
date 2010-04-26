# This will ultimately become a gem in its own right
# GTIN-12 (UPC-A): this is a 12-digit number used primarily in North America
# GTIN-8 (EAN/UCC-8): this is an 8-digit number used predominately outside of North America
# GTIN-13 (EAN/UCC-13): this is a 13-digit number used predominately outside of North America
# GTIN-14 (EAN/UCC-14 or ITF-14): this is a 14-digit number used to identify trade items at various packaging levels

class Integer
  def odd?
    self & 1 != 0
  end
   
  def even?
    self & 1 == 0
  end
end

module GTIN
  def ean?
    # self = self.to_s.gsub(/[\D]+/, "").split(//)
    return false if self.length != 13
    valid_checksum?
  end
  
  def upc?
    # self = self.to_s.gsub(/[\D]+/, "").split(//)
    return false if self.length != 12
    valid_checksum?
  end

  # FOR A UPC:
  # From the right to left, start with odd position, assign the odd/even position to each digit.
  # Sum all digits in odd position and multiply the result by 3.
  # Sum all digits in even position.
  # Sum the results of step 3 and step 4.
  # divide the result of step 4 by 10. The check digit is the number which adds the remainder to 10.

  # Determine if a gtin value has a valid checksum
  def valid_checksum?
    number = self.reverse
    odd = even = 0
    
    (1..number.length-1).each do |i|
      i.even? ? (even += number[i].chr.to_i) : (odd += number[i].chr.to_i)
    end
    
    number[0].chr.to_i == (10 - ((odd * 3) + even) % 10)
  end


  # GTIN-12 (UPC-A): this is a 12-digit number used primarily in North America
  def to_gtin_12
    to_gtin(12)
  end
  alias :to_upc   :to_gtin_12
  alias :to_upc_a :to_gtin_12
  
  
  # GTIN-8 (EAN/UCC-8): this is an 8-digit number used predominately outside of North America
  def to_gtin_8
    to_gtin(8)
  end
  alias :to_ean_8 :to_gtin_8
  alias :to_ucc_8 :to_gtin_8
  
  
  # GTIN-13 (EAN/UCC-13): this is a 13-digit number used predominately outside of North America
  def to_gtin_13
    to_gtin(13)
  end
  alias :to_ean_13 :to_gtin_13
  alias :to_ucc_13 :to_gtin_13
  alias :to_ean    :to_gtin_13


  # GTIN-14 (EAN/UCC-14 or ITF-14): this is a 14-digit number used to identify trade items at various packaging levels
  def to_gtin_14
    to_gtin(14)
  end
  alias :to_gtin :to_gtin_14
  
  def to_gtin(size=14)
    "%0#{size.to_i}d" % self.to_s.gsub(/[\D]+/, "").to_i
  end
end

# Extend String to include these methods
class String
  include GTIN
end
