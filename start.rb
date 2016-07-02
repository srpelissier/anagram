#!/usr/bin/env ruby
#start the game
end_game = false

def makearray(file)
	File.readlines(file).map {|line| line.chomp }
end

@wordlist = makearray "./data/wordlist.txt"
@alphabet = @wordlist.join { |word|
	word.chomp
}.chars
alphabet_weights = Hash.new(0)
@alphabet.each do |v|
	alphabet_weights[v] += 1
end
alphabet_weights.each { |k,v|
	alphabet_weights[k] = (alphabet_weights[k].to_f/@alphabet.length*1000).to_i
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
		ret#.sort

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
		copy = []
		letters.each { |l|
			copy << l.upcase
		}
		puts "\nLetters: #{copy.join(" ")}\n"
	end

	while change_letters == false && end_game == false do

		@word_is_valid = true
		printletters(baseletters)
		puts "\nEnter a word: "
		word = gets.chomp.downcase

		score = 0
		msg = ""

		letters = word.chars.sort

		error = ""
		letters.each { |letter|
			if !baseletters.include? letter
				@word_is_valid = false
				error = letter
			end
		}
		msg += "\n'#{error}' not found." unless @word_is_valid

		if @word_is_valid
			letters.each { |letter|
				letters_copy = letters.dup
				baseletters_copy = baseletters.dup
				qty_letter = letters_copy.keep_if { |letter_copy| letter_copy == letter }.length
				qty_baseletter = baseletters_copy.keep_if { |baseletter_copy| baseletter_copy == letter }.length
				if qty_letter > qty_baseletter
					@word_is_valid = false
					error = letter
				end
			}
			msg += "\nYou used too many '#{error}'." unless @word_is_valid

		end

		if (@wordlist.include? word) && @word_is_valid
			score = word.size
		elsif @word_is_valid
			@word_is_valid = false
			msg += "\n'#{word}' unknown."
		end

		if @word_is_valid
			top10.each { |topscore|
				if topscore[1] == word
					@word_is_valid = false
					msg += "\n'#{word}' has been proposed."
				end
			}
		end

		if @word_is_valid
			top10 << [score,word]
			top10.sort_by! { |rank| rank[0] }
			top10 = top10.uniq { |rank| rank[1] }
			top10.reverse!
			top10 = top10.take(10)
		end

		puts "\n#{word} wins #{score} points.#{msg}"

		printranks top10 if top10.length > 0

		puts "\nHit [RETURN] to try again or [N] for new letters. [Q] to quit."

		resp = gets.chomp
		case resp
		when "n", "N"
			change_letters = true
		when "q", "Q"
			end_game = true
		end

	end

end

puts "Bye"
