#!/usr/bin/env ruby

require 'net/ftp'
trading_dir = "/mnt/trading/"
eod_executable_dir = "/opt/eod_ems/exec/"
execute_international_files = "upload_international_files.sh"
date = Time.now.strftime("%Y%m%d")
search_files = "#{date}*Executions*"
ftp = Net::FTP.new('ftp.itginc.com')
ftp.login('gzm_ftp','RYf5SkHs')
files = ftp.nlst(search_files)
puts files
if files.empty?
  ftp.close() 
  puts "There were no international files to download"
else 
  puts "Store the files into the database"
  files.each{ |file|
    #Just download the international files
    if file =~ /#{date}.Executions_[^US]/
      puts "Downloading file: #{file}"
      ftp.gettextfile(file, "#{trading_dir}#{file}")
    end
  }
  ftp.close()
  puts "About to upload the files to the RDBS"
  execute_groovy = exec(eod_executable_dir + execute_international_files)
end


puts "Finished download for all possible international files"