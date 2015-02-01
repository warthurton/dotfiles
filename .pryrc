require 'rubygems'
# require 'interactive_editor'
#require 'gist' rescue nil
# require 'pry-clipboard' rescue nil
require 'awesome_print' rescue nil

Pry.editor = 'vim'
Pry.config.color = true
# Pry.config.print = proc { |output, value| output.puts value.ai }

# default_command_set = Pry::CommandSet.new do
#   command "copy", "Copy argument to the clip-board" do |str|
#      IO.popen('pbcopy', 'w') { |f| f << str.to_s }
#   end
#
#   command "sql", "Send sql over AR." do |query|
#     if ENV['RAILS_ENV'] || defined?(Rails)
#       ap ActiveRecord::Base.connection.select_all(query)
#     else
#       ap "No rails env defined"
#     end
#   end
#
#   command "caller_method" do |depth|
#     depth = depth.to_i || 1
#     if /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(depth+1).first
#       file   = Regexp.last_match[1]
#       line   = Regexp.last_match[2].to_i
#       method = Regexp.last_match[3]
#       output.puts [file, line, method]
#     end
#   end
# end
# Pry.config.commands.import default_command_set

