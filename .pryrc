require 'rubygems'

Pry.editor = 'vim'
Pry.config.color = true
Pry.color = true

_pry_things = {
  :preferred_gems => %w(bond pry-byebug pry-clipboard pry-doc pry-docmore pry-coolline pry-editline pry-git pry-highlight pry-stack_explorer pry-vterm_aliases),
  :missing_gems => []
}

_pry_things[:preferred_gems].each do |gem|
  begin
    require gem
  rescue LoadError
    _pry_things[:missing_gems] << gem
  end
end
warn "Pry might be better with:\ngem install #{_pry_things[:missing_gems].join(' ')}" if _pry_things[:missing_gems].size > 0

default_command_set = Pry::CommandSet.new do
  command "caller_method" do |depth|
    depth = depth.to_i || 1
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(depth + 1).first
      file   = Regexp.last_match[1]
      line   = Regexp.last_match[2].to_i
      method = Regexp.last_match[3]
      output.puts [file, line, method]
    end
  end
end
Pry.config.commands.import default_command_set

class Object
  def interesting_methods
    case self.class
    when Class
      public_methods.sort - Object.public_methods
    when Module
      public_methods.sort - Module.public_methods
    else
      public_methods.sort - Object.new.public_methods
    end
  end
end
