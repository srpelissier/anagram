#!/usr/bin/env ruby
#start the game
endgame = false

def makearray(file)
	File.readlines(file).map {|line| line.chomp }
end

@wordlist = makearray "./data/wordlist.txt"

while endgame == false do

	newword = false
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
		puts
		ranklist.each_index { |idx|
			if idx == 9
				puts "Rank ##{idx+1} -> Score:#{ranklist[idx][0]} Word:#{ranklist[idx][1]}"
			else
				puts "Rank #0#{idx+1} -> Score:#{ranklist[idx][0]} Word:#{ranklist[idx][1]}"
			end
		}
	end

	baseletters = getletters(15)

	def printletters(letters)
		puts "\nLetters: #{letters.join(" ")}\n"
	end

	while newword == false do

		score = 0
		@check = true
		printletters(baseletters)
		puts "\nEnter a word: "
		word = gets.chomp.downcase

		letters = word.chars.sort

		letters.each { |letter|
			if !baseletters.include? letter.downcase
				@check = false
				puts "\n#{letter} not found."
			end
		}

		if @check == true
			letters_copy = letters.dup

			letters.each { |letter|
				baseletters_copy = baseletters.dup
				qty_letter = letters_copy.keep_if { |letter_copy| letter_copy == letter }.length
				qty_baseletter = baseletters_copy.keep_if { |baseletter_copy| baseletter_copy == letter }.length
				if qty_letter > qty_baseletter
					@check = false
				end
			}

			if @check == false
				puts "\nSome letter was used too many times."
			end
		end

		if (@wordlist.include? word) && (@check == true)
			score = word.size
		elsif @check == true
			@check = false
			puts "\n#{word} unknown."
		end

		if @check == true
			top10.each { |topscore|
				if topscore[1] == word
					puts "\n#{word} has been proposed."
				end
			}
		end

		if @check == true
			top10 << [score,word]
			top10.sort_by! { |rank| rank[0] }
			top10 = top10.uniq { |rank| rank[1] }
			top10.reverse!
			top10 = top10.take(10) if top10.length > 10
		end

		printranks top10

		puts "\nNew (A)ttempt) - New (L)etters?\n"

		resp = gets.chomp
		case resp
		when "A", "a"
			newword = false
		when "L", "l"
			newword = true
		else
			newword = true
			endgame = true
		end

	end

end

puts "Bye"
