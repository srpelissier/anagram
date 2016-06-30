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

		ranklist.each_index { |idx|
			if idx == 9
				p "Rank ##{idx+1} -> Score:#{ranklist[idx][0]} Word:#{ranklist[idx][1]}"
			else
				p "Rank #0#{idx+1} -> Score:#{ranklist[idx][0]} Word:#{ranklist[idx][1]}"
			end
		}
	end

	baseletters = getletters(15)

	def printletters(letters)
		p "Letters: #{letters.join(" ")}"
	end

	while newword == false do

		score = 0
		@check = true
		printletters(baseletters)
		puts "Enter a word"
		word = gets.chomp

		word.each_char { |letter|
			if !baseletters.include? letter
				@check = false
				p "#{letter} not found."
			end
		}

		if @check == true
			letters = word.chars.sort
			baseletters_copy = baseletters.dup
			letters.each { |letter|
				baseletters_copy.delete_at(baseletters.index(letter))
			}
		end

		if (@wordlist.include? word) && (@check == true)
			score = word.size
		elsif @check == true
			@check = false
			p "Not in dic"
		end

		if @check == true
			top10 << [score,word]
			p top10
			top10.sort_by! { |rank| rank[0] }
			p top10
			top10 = top10.uniq { |rank| rank[1] }
			top10.reverse!
			top10 = top10.take(10) if top10.length > 10
		end

		printranks top10

		puts "(C)ontinue/(n)ew word?"

		resp = gets.chomp
		case resp
		when "C", "c"
			newword = false
		when "N", "n"
			newword = true
		else
			newword = true
			endgame = true
		end

	end

end

puts "Bye"
