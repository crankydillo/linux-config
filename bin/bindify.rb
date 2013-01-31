#!/usr/bin/env jruby

files =
  if (ARGV.size == 0 && ARGV[0] == '*')
    Dir.entries('.')
  else
    ARGV
  end

command = 'java -jar /opt/java/biz.aQute.bnd.jar wrap -output '

if File.exists? 'out'
  puts 'Output directory, out, exists so halting.'
  exit
end

Dir::mkdir 'out'

files.each_with_index do |e,idx|
  if ((e.reverse =~ /raj\./) == 0)
    puts "Invoking #{command} on #{e}..."
    system("#{command} out/#{e} -properties props #{e}")
    #system("#{command} out/#{idx}.jar #{e}")
  else
    puts "#{e} does not end in .jar.  Skipping."
  end
end
