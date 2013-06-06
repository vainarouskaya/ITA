 #!/usr/bin/env ruby
 
#Count all the files in your home directory
puts "Your home directory contains: #{Dir["/Users/irynaV/*"].length} files"

#Count all "txt" files in given (QA) directory
puts "Your home directory contains: #{Dir["/Users/irynaV/QA/*.txt"].length} files"