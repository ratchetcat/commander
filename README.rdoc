= Commander

== DESCRIPTION:

Commander combines the execution of system commands with logging. 

== FEATURES/PROBLEMS:

* Supports single or batched commands
* Provides exit status after command is run.
* Extends logger to capture output from STDOUT or STDERR, and flag errors

Commander uses the open4 gem and the ruby logger to accomplish these tasks.

== SYNOPSIS:

Commander was originally intended for use in rake tasks launching multiple system commands. Program flow was varied based on the exit status or source of the output from these commands and Commander includes some convenience methods for handling such situations.

Setup:
  
  require 'rubygems'
  require 'commander'

  log = Logger.new( STDOUT )
  log.level = Logger::Warn 
  c = Commander.new( log )

Commander accepts single commands:

  c = Commander.new( log )
  c.run( "df -h" )

Alternatively, you may add commands to an array for batch execution:

  c = Commander.new( log )
  c.commands << "df -h"
  c.commands << "ls -ltrh"
  c.run_commands()

Exit status of a single command is trivial to check (thanks to the open4 gem):

  c = Commander.new( log )
  c.run( "df -h" )
  p c.exit_status #=> 0

Commander adds a buffer to the ruby logger, which allows us to perform a simple check for errors over the whole log:

  c = Commander.new( log )
  c.run( "df -h" )
  p c.errors? #=> false

=Note

Please note: You must initialize Commander with a reference to a Logger object. Additionally, Commander requires the {Open4}[http://www.codeforpeople.com/lib/ruby/open4/] gem (by Ara T. Howard).

== REQUIREMENTS:

{Open4}[http://www.codeforpeople.com/lib/ruby/open4/]

== INSTALL:

<tt>sudo gem install commander</tt>

== LICENSE:

(The MIT License)

Copyright (c) 2008 Jon Fuller 

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
