
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
$count = 0
$name = "<Giovany> <Addun>"

=begin
The bigramate method updates the bigram model ($bigrams)
for each of the filtered song titles
The method is called on each song title in the cleanup_title method

This method separates the input title into an array of strings
Consecutive string pairs are iterated over this array
and values in the bigram model ($bigrams) is updated  with each iteration
=end
def bigramate(title)
  stop_words = ["a", "an", "and", "by", "for", "from", "in", "of", "on", "or", "out", "the", "to", "with"]
	words = title.split(" ") # title represented as an array of strings
  words -= stop_words # remove any stopwords from array of words
  previous = ""
  skip = true #iterator control flag
	words.each do |next_gram|
    #Skip the first iteration over title since we are looking for word PAIRS
		if skip == false
      #If no entry in $bigrams[word_n] exists
			if $bigrams[previous] == nil
				$bigrams[previous]= {"#{next_gram}" => 1} # Create entry $bigrams[word_n][word_n+1] == 1
      #If an entry was erroneously created with no value
      elsif $bigrams[previous][next_gram] == nil #initialize to 1
        $bigrams[previous][next_gram]=1
      #Else increment the value $bigrams[word_n][word_n+1] += 1
      else
        num = $bigrams[previous][next_gram]
        num = num+1
        $bigrams[previous][next_gram] = num
			end
    end
		skip = false
		previous = "#{next_gram}"
  end
end

=begin
The cleanup title method takes a string containing a song title and strips all superfluous data
It does this by matching the input string on a series of regular expressions
=end
def cleanup_title(line)
	title = line.gsub(/(.)+<SEP>/, "") # Remove all data preceeding song title
	title=title.gsub(/\n/, "") # Remove any newline characters
  #Replace various punctuation characters with whitespace
	title = title.gsub(/\s(\((.+)\)|\[(.+)\]|{(.+)}|\\(.+)|\/(.+)|_(.+)|-(.+)|:(.+)|"(.+)"|`(.+)|\+(.+)|=(.+)|\*(.+)|(feat\.(.+)))/, "")
  # Only accept titles with English alphabet
	if title =~/^([[:ascii:]]+)$/
		$count+=1
    # Change title to all lower case
		title = title.downcase.gsub(/[[:punct:]]/, '')
		bigramate(title)
  end
end

=begin
The mcw method takes a word as input and retrieves the most common word
that proceeds the input word
=end
def mcw(verb)
  word = verb
  greatest = 0 # variable for keeping track of greatest frequency
  temp = $bigrams[word] #retrieve the hash of the corresponding word
  #Iterate through each key value pair to find the pair with greatest freq value
  begin
    temp.keys.each do |key|
      #key.strip()
      val = temp[key]
      #when the greatest frequency so far is found, update variables
      if val>greatest
        greatest = val
        word = key
      end
    end

  # In case a given word does not exist within the hash
  # do nothing
  rescue
    nil
  end
  word
end

=begin
The create_title method takes a single word as input and builds a song title
by stringing together the most common consecutive words

The title is limited to 20 words by the count variable
=end
def create_title(verb)
  cur_word = verb
  title = verb
  count = 0
  while count < 19 do
    cur_word = mcw(cur_word)
    if cur_word == nil
      count = 21
    else
      count +=1
      title += (" "+cur_word)
    end
  end
  title
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
  temp = mcw("happy")
  p temp

  # Loop with user input
  quit_flag = false
  while quit_flag == false
    puts "Enter a word [Enter 'q' to quit]:"
    usr_inp = STDIN.gets.chomp
    if usr_inp == "q"
      quit_flag = true
    else
      title =create_title(usr_inp)
      p title
    end
  end

end

if __FILE__==$0
	main_loop()
end
