require 'rubygems'

IRB.conf[:SAVE_HISTORY] = 10_000
IRB.conf[:AUTO_INDENT]  = true

%w[
  irb/completion
  irbtools
  irbtools/more
  did_you_mean
  did_you_mean/experimental
  looksee
  wirb
].each do |gem|
  begin
    require gem
  rescue LoadError
    puts "#{gem} not found"
  end
end
