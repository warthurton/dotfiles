require 'rubygems'

Pry.editor = 'vim'
Pry.config.color = true
Pry.color = true

# %w[pry-byebug pry-doc did_you_mean did_you_mean/experimental looksee].map { |gem| require gem rescue nil }

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

Pry::Commands.command(/^\.$/, 'repeat last command') do
  _pry_.run_command Pry.history.to_a.last
end

Pry.config.commands.import Pry::CommandSet.new do
  command 'caller_method' do |depth|
    depth = depth.to_i || 1
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(depth + 1).first
      file   = Regexp.last_match[1]
      line   = Regexp.last_match[2].to_i
      method = Regexp.last_match[3]
      output.puts [file, line, method]
    end
  end
end
