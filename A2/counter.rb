#! /usr/bin/env ruby

require 'rubygems'
require 'net/sftp'
require 'mail'


HOST="turing.cse.iitk.ac.in"
USER='pankajm'
PASS='busted'


def send_mail(flag)
  if flag == "r"
    mail = Mail.new do
        from "admin@counter.com"
        to "pankajmore@gmail.com"
        subject "File corrupted but recovered"
    end
  else 
    mail = Mail.new do
        from "admin@counter.com"
        to "pankajmore@gmail.com"
        subject "File corrupted , starting from zero!"
    end
  end
  begin 
    mail.deliver!
  rescue
    puts "Unable to deliver"
  end
end

i = 0

# When process starts in the beginning it checks if the file is deleted, it creates the file.
# If the file was deleted or corrupted , reading would give 0
# nil.to_i = 0
# "non_integer".to_i = 0
Net::SFTP.start(HOST, USER, :password => PASS) do |sftp|
  sftp.file.open("/users/mti/pankajm/counter.txt", "a+") do |f|
    f.pos= 0
    x = f.read.to_i 
    if x == 0
      send_mail("nr")
      i += 1
    else
      i = x+1
    end
    f.pos= 0
    f.puts i
  end
end
      
loop do
  Net::SFTP.start(HOST, USER, :password => PASS) do |sftp|
    sftp.file.open("/users/mti/pankajm/counter.txt", "a+") do |f|
      f.pos= 0
      check = f.read.to_i
      send_mail("r") unless i == check
      i += 1
      f.pos= 0
      f.write i
    end
  end
  sleep 1
end


