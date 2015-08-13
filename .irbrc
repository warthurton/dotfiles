IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:AUTO_INDENT]  = true

require 'rubygems'
require 'irb/completion'
require 'irbtools' rescue nil
require 'interactive_editor' rescue nil

begin
  require 'hirb'
  Hirb.enable
rescue
end

class Object
  def interesting_methods
    case self.class
    when Class
      self.public_methods.sort - Object.public_methods
    when Module
      self.public_methods.sort - Module.public_methods
    else
      self.public_methods.sort - Object.new.public_methods
    end
  end
end
