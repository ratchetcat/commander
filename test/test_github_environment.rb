require File.dirname(__FILE__) + '/test_helper.rb'

class TestGithubEnvironment < Test::Unit::TestCase
  
  def setup
    require 'rubygems/specification'
    @data = File.read( File.dirname(__FILE__) + '/../commander.gemspec' )
    @spec = nil
  end
  
  def test_spec
    Thread.new { @spec = eval("$SAFE = 3\n#{ @data }") }.join 
    assert_not_nil( @spec )
  end

end