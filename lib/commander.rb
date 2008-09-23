require 'rubygems'
require 'open4'
require 'logger'

class Commander

  module VERSION #:nodoc:
    MAJOR = 1
    MINOR = 0
    TINY  = 5 

    STRING = [MAJOR, MINOR, TINY].join('.')
  end

  # The LoggerBuffer module extends the standard logger with a buffer -- useful for tracking error conditions.
  module LoggerBuffer
    attr_accessor :buffer
    
    def self.extended( base )
      base.instance_eval 'alias :_add :add'
      base.extend( Commander::LoggerBuffer::Methods )
      base.instance_variable_set( "@buffer", [] )
    end
    
    module Methods
      def add(severity, message = nil, progname = nil, &block)
        severity ||= UNKNOWN
        if @logdev.nil? or severity < @level
          return true
        end
        progname ||= @progname
        if message.nil?
          if block_given?
            message = yield
          else
            message = progname
            progname = @progname
          end
        end
        
        msg = format_message(format_severity(severity), Time.now, progname, message)
        @buffer << msg
        @logdev.write(msg)
        true
      end
    end
  end

  class MockStatus
    def exitstatus
      1
    end
  end

  attr_accessor :commands, :exit_status, :log

  def initialize( logger )
    raise ArgumentError.new("A reference to a valid logger must be provided.") if logger.nil? || !logger.respond_to?(:info) || !logger.respond_to?(:error)
    @log = logger
    @log.extend( Commander::LoggerBuffer )

    @exit_status = 0
    @commands = []
  end
  
  # run a single command
  # set override to true in order to suppress warnings from STDERR
  def run( cmd, override = false )
    @log.info "Command: #{ cmd }"

    # switched to popen4 for support of exitstatus and ease-of-use
    begin
      pid, stdin, stdout, stderr = Open4::popen4 cmd    
      ignored, status = Process::waitpid2 pid
    
      stdout_array = stdout.readlines
      stderr_array  = stderr.readlines
    rescue Exception => err
      # set status.exitstatus to 1 due to failure
      status = MockStatus.new()
      stdout_array = []
      stderr_array = [ err ]
    end

    stdout_array.each do | line |
      @log.info line
    end
    
    stderr_array.each do | line |
      if override
        @log.info line
      else
        @log.error line
      end
    end

    @exit_status = status.exitstatus
  end
  
  # run commands in commands array sequentially
  def run_commands()
    @commands.each do | command |
      self.run( command )
    end
  end
  
  # returns true if logging facility has recorded warnings
  def errors?
    return true if @log.buffer.join().match(/WARN|ERROR|FATAL|UNKNOWN/i)
    return false
  end
  
end
