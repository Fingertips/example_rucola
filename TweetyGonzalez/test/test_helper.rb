ENV['RUBYCOCOA_ENV'] = 'test'
ENV['RUBYCOCOA_ROOT'] = File.expand_path('../../', __FILE__)

require 'rubygems'
require 'test/unit'
require 'test/spec'
require 'mocha'
require 'rucola'
require 'rucola/test_helper'
require 'rucola/test_case'

require File.expand_path('../../config/boot', __FILE__)

FIXTURES = File.expand_path("../fixtures", __FILE__)

class Test::Unit::TestCase
  private
  
  def fixture(name)
    File.join(FIXTURES, name)
  end
end