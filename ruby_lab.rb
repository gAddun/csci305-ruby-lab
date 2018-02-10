
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <Giovany> <Addun>
# <giovany.m.addun@gmail.com>
#
###############################################################

# The $bigram global variable stores the frequency of every consecutive word-pair
# within a set of (filtered) song titles.
# It is a nested hash of the structure
# $bigrams[word_n][word_n=+1] == frequency
$bigrams = Hash.new
$name = "<Giovany> <Addun>"

=begin
The bigramate modifies the bigram
=end
def bigramate(title)
	words = title.split(" ")
	previous = ""
  count = 0
	words.each do |next_gram|
		if count > 0
			if $bigrams[previous] == nil
				$bigrams[previous]= {"#{next_gram}" => 1}
      elsif $bigrams[previous][next_gram] == nil
        $bigrams[previous][next_gram]=1
      else
        num = $bigrams[previous][next_gram]
        num = num+1
        $bigrams[previous][next_gram] = num
			end
    end
		count = count + 1
		previous = "#{next_gram}"
  end

end

def cleanup_title(line)
	title = line.gsub(/(.)+<SEP>/, "")
	title=title.gsub(/\n/, "")
	title = title.gsub(/\s(\((.+)\)|\[(.+)\]|{(.+)}|\\(.+)|\/(.+)|_(.+)|-(.+)|:(.+)|"(.+)"|`(.+)|\+(.+)|=(.+)|\*(.+)|(feat\.(.+)))/, "")
	if title =~/^([[:ascii:]]+)$/
		$count+=1
		title = title.downcase.gsub(/[[:punct:]]/, '')
		bigramate(title)
  end
end

def mcw(verb)
	word = ""
	greatest = 0
  for key in ($bigrams[word]).keys
		if $bigrams[word][key]>greatest
			greatest = $bigrams[word][key]
			word = key
		end
	end
	word
end

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		IO.foreach(file_name, encoding: "utf-8") do |line|
			cleanup_title(line)
		end

		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])
	p $count
	# Get user input
  mcw("happy")
end

if __FILE__==$0
	main_loop()
end
