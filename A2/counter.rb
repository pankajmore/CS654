require 'net/sftp'

HOST="turing.cse.iitk.ac.in"
USER='pankajm'
PASS='busted'

i = 0
loop do
  Net::SFTP.start(HOST, USER, :password => PASS) do |sftp|
    sftp.file.open("/users/mti/pankajm/counter.txt", "r+") do |f|
      i = f.gets.to_i + 1
      f.pos= 0
      f.puts i
    end
  end
  sleep 1
end
