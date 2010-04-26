$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "gtin/version"
require "gtin/gtin"

module GTIN
  VERSION = '0.1.2'
end