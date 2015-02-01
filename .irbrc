IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:AUTO_INDENT]  = true

require 'irb/completion'
require 'rubygems' rescue nil
require 'irbtools' rescue nil
require 'awesome_print' rescue nil
AwesomePrint.irb! rescue nil

