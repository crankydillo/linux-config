#!/usr/bin/env ruby

# Convert the standard out of Scala Specs into wiki markup.

print 'File to wikifiy: '
ans = gets.chomp
 

out = File.new("wikified.txt", "w")
File.open(ans).each do |line|
  # not perfect on the sub but should be sufficient
  if (line =~ /Specification "\w+"/) then
    out.puts '<h3>' + line.sub(/\[\w*\]/, '') + '</h3>'
  else
    out.puts line.sub(/\[\w*\]/, '') + '<br>'
  end
end

out.close


