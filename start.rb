#!/usr/bin/env ruby
#start the game
end_game = false

def makearray(file)
	File.readlines(file).map {|line| line.chomp }
end

@wordlist = makearray "./data/wordlist.txt"
letterlist = @wordlist.join { |word|
	word.chomp
}.chars
alphabet_weights = Hash.new(0)
letterlist.each do |v|
	alphabet_weights[v] += 1
end
alphabet_weights.each { |k,v|
	alphabet_weights[k] = (alphabet_weights[k].to_f/letterlist.length*1000).to_i
}
@alphabet = []
("a" .. "z").to_a.each { |alpha|
	@alphabet << Array.new(alphabet_weights[alpha], alpha)
}
@alphabet.flatten!

while end_game == false do

	change_letters = false
	def getletters(n)

		ret = []
		for i in 0...n do
			ret << @alphabet.sample
		end
		ret

	end

	top10 = []

	def printranks(ranklist)
		puts
		ranklist.each_index { |idx|
			case idx
			when 9
				puts "\t\t> #{idx+1}\t#{ranklist[idx][0]} points (#{ranklist[idx][1].capitalize})"
			else
				puts "\t\t> 0#{idx+1}\t#{ranklist[idx][0]} points (#{ranklist[idx][1].capitalize})"
			end
		}
	end

	def banner()
		"+------------------------------------------------------------+\n|                       #{["a ", "n ", "a ", "g ", "r ", "a ", "m "].shuffle.join}                       |\n+------------------------------------------------------------+"
	end

	baseletters = getletters(15)

	def printletters(letters)
		copy = []
		letters.each { |l|
			copy << l.upcase
		}
		system "clear"
		puts banner
		puts
		puts "\t\t#{copy.join(" ")}\n"
	end

	while change_letters == false && end_game == false do

		score = 0
		msg = ""
		error = ""

		printletters(baseletters)

		puts "\n...\nEnter a word: "
		word = gets.chomp.downcase

		if word == ""
			msg += "There was no word!"
			@word_is_valid = false
		else
			@word_is_valid = true
		end

		if @word_is_valid

			letters = word.chars.sort

			letters.each { |letter|
				unless baseletters.include? letter
					# if a letter in the prposed word
					# is not in the list of available letters
					@word_is_valid = false
					error = letter.upcase
				end
			}
			msg += "'#{error}' not found." unless @word_is_valid
		end

		if @word_is_valid

			letters.each { |letter|
				# calculates the amount of each letter found in
				# the proposed word and in the list of available letters
				letters_copy = letters.dup
				baseletters_copy = baseletters.dup
				qty_letter = letters_copy.keep_if { |letter_copy| letter_copy == letter }.length
				qty_baseletter = baseletters_copy.keep_if { |baseletter_copy| baseletter_copy == letter }.length

				if qty_letter > qty_baseletter
					# then compares the amount between the proposed word
					# and the letters found from the list to see is there
					# is enough to make the word
					@word_is_valid = false
					error = letter.upcase
				end
			}

			msg += "You used too many '#{error}'." unless @word_is_valid
		end

		if @word_is_valid

			if (@wordlist.include? word)
				# when the word is found in the file
				# let's get its score
				score = word.size
			else
				# when the word is not found in the file
				@word_is_valid = false
			end

			msg += "'#{word.upcase}' unknown." unless @word_is_valid
		end

		if @word_is_valid

			top10.each { |topscore|
				if topscore[1] == word
					# if the word was proposed earlier
					@word_is_valid = false
					error = word.upcase
				end
			}

			msg += "'#{word.upcase}' already proposed." unless @word_is_valid
		end

		if @word_is_valid

			top10 << [score,word]
			top10.sort_by! { |rank| rank[0] } # sorting by score
			top10.reverse! # 1st place gets displayed on top
			top10 = top10.take(10) # keep only the 10 highest scores
		end

		if @word_is_valid
			puts
			puts "#{word.upcase} wins #{score} points.\n...\n"
		else
			puts "\nSorry: #{msg}\n...\n"
		end

		printranks top10 if top10.length > 0 # don't if it's empty

		puts "\nHit [RETURN] to try again or [N] for new letters. [Q] to quit."

		resp = gets.chomp
		case resp
		when "n", "N"
			change_letters = true
		when "q", "Q"
			end_game = true
		end # any other key will continue the game using the same set of base letters

	end

end

puts "Bye"
