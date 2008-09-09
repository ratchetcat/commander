require File.dirname(__FILE__) + '/test_helper.rb'

class TestCommander < Test::Unit::TestCase

  def setup
    require 'logger'
    logger = Logger.new( STDOUT )
    @c = Commander.new( logger )
  end
  
  def test_simple_command_log_size    
    @c.run('echo test')
    assert_equal( 2, @c.log.buffer.size, "Commander log should contain two lines: The original command and the simple command result." )
  end

  def test_simple_passing_command_exit_status
    @c.run('echo test')
    assert_equal( 0, @c.exit_status, "Commander exit status should contain 0 for successful command.")
  end
  
  def test_simple_passing_command_error_check
    @c.run('echo test')
    assert_equal( false, @c.errors?, "No errors should be recorded for successful commands.")
  end
  
  def test_simple_failing_command_exit_status
    @c.run('thisisabadcommand')
    assert_equal( 1, @c.exit_status, "Commander exit status should contain 1 for failing command.")
  end
  
  def test_simple_failing_command_error_check
    @c.run('thisisabadcommand')
    assert_equal( true, @c.errors?, "Errors should be recorded for failing commands.")
  end
  
  def test_multiple_command_exit_status
    @c.run('thisisabadcommand')
    @c.run('echo test')
    assert_equal( 0, @c.exit_status, "Commander exit status should contain 0.")
  end
  
  def test_command_buffer
    @c.commands << 'echo test'
    @c.commands << 'echo test'
    @c.run_commands()
    assert_equal( 4, @c.log.buffer.size, "Commander log should contain four lines." )
  end
  
end
