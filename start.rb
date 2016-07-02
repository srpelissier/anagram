#!/usr/bin/env ruby
#start the game
end_game = false

def makearray(file)
	File.readlines(file).map {|line| line.chomp }
end

@wordlist = makearray "./data/wordlist.txt"

while end_game == false do

	change_letters = false
	def getletters(n)
		alphabet = ("a" .. "z").to_a
		ret = []
		for i in 0...n do
			ret << alphabet.sample
		end
		ret.sort
	end

	top10 = []

	def printranks(ranklist)
		puts "\nScores:"
		ranklist.each_index { |idx|
			if idx == 9
				puts "##{idx+1} -> #{ranklist[idx][0]} points (#{ranklist[idx][1]})"
			else
				puts "#0#{idx+1} -> #{ranklist[idx][0]} points (#{ranklist[idx][1]})"
			end
		}
	end

	baseletters = getletters(15)

	def printletters(letters)
		puts "\nLetters: #{letters.join(" ")}\n"
	end

	while change_letters == false && end_game == false do

		@word_is_valid = true
		printletters(baseletters)
		puts "\nEnter a word: "
		word = gets.chomp.downcase

		score = 0
		msg = ""

		letters = word.chars.sort

		letters.each { |letter|
			if !baseletters.include? letter
				@word_is_valid = false
				msg += "\n#{letter} not found."
			end
		}

		if @word_is_valid == true

			letters.each { |letter|
				letters_copy = letters.dup
				baseletters_copy = baseletters.dup
				qty_letter = letters_copy.keep_if { |letter_copy| letter_copy == letter }.length
				qty_baseletter = baseletters_copy.keep_if { |baseletter_copy| baseletter_copy == letter }.length
				if qty_letter > qty_baseletter
					@word_is_valid = false

				end
			}

			msg += "\nYou used too many '#{letter}'." if @word_is_valid == false

		end

		if (@wordlist.include? word) && (@word_is_valid == true)
			score = word.size
		elsif @word_is_valid == true
			@word_is_valid = false
			msg += "\n#{word} unknown."
		end

		if @word_is_valid == true
			top10.each { |topscore|
				if topscore[1] == word
					@word_is_valid = false
					msg += "\n#{word} has been proposed."
				end
			}
		end

		if @word_is_valid == true
			top10 << [score,word]
			top10.sort_by! { |rank| rank[0] }
			top10 = top10.uniq { |rank| rank[1] }
			top10.reverse!
			top10 = top10.take(10)
		end

		puts "\n#{word} wins #{score} points.#{msg}"

		printranks top10

		puts "\nNew (A)ttempt) - New (L)etters?\n"

		resp = gets.chomp
		case resp
		when "A", "a"
			change_letters = false
		when "L", "l"
			change_letters = true
		else
			end_game = true
		end

	end

end

puts "Bye"
