class Sudoku
	def initialize(board_string)

		return "Wrong length" if board_string.length != 81

	  	@rows = Array.new(9) {(1..9).to_a}
	  	@cols = Array.new(9) {(1..9).to_a}
	  	@blocks = Array.new(9) {(1..9).to_a}
	  	@endflag=false

	  	@board=[]
	  	board_string.chars.each{|x| @board<< [x.to_i,[],[]]}
	  	@board = Array.new(9) {@board.shift(9)}

		@board.each_index{|i| @board[i].each_index{|j| @board[i][j][1]= ((i/3)*3)+(j/3)}}
	  	
	  	print_board
	  	row_possibles  	
	  	col_possibles
	  	block_possibles
	  	square_possibles
	end

	def print_board
		
		@endflag ? display = "Solution is: \n" : display = "Incomplete board is: \n"

		for i in 0..2
			for j in 0..2
				display<<@board[i][j][0].to_s
				display<<" "
			end
			display << "|"
			for j in 3..5
				display<<@board[i][j][0].to_s
				display<<" "
			end
			display << "|"
			for j in 6..8
				display<<@board[i][j][0].to_s
				display<<" "
			end
			display<< "\n"
		end
		display<< "------------------- \n"
		for i in 3..5
			for j in 0..2
				display<<@board[i][j][0].to_s
				display<<" "
			end
			display << "|"
			for j in 3..5
				display<<@board[i][j][0].to_s
				display<<" "
			end
			display << "|"
			for j in 6..8
				display<<@board[i][j][0].to_s
				display<<" "
			end
			display<< "\n"
		end
		display<< "------------------- \n"
		for i in 6..8
			for j in 0..2
				display<<@board[i][j][0].to_s
				display<<" "
			end
			display << "|"
			for j in 3..5
				display<<@board[i][j][0].to_s
				display<<" "
			end
			display << "|"
			for j in 6..8
				display<<@board[i][j][0].to_s
				display<<" "
			end
			display<< "\n"
		end

		puts display
		puts "\n"
	end

	def row_possibles
		@board.each_index{|i| @board[i].each_index{|j| @rows[i].delete(@board[i][j][0]) if @board[i][j][0]!=0}}
	end

	def col_possibles
		@board.each_index{|i| @board[i].each_index{|j| @cols[j].delete(@board[i][j][0]) if @board[i][j][0]!=0}}
	end

	def block_possibles		
		@board.each_index{|i| @board[i].each_index{|j| @blocks[@board[i][j][1]].delete(@board[i][j][0]) if @board[i][j][0]!=0}}
	end

	def square_possibles
		@board.each_index{|i| @board[i].each_index{|j| @board[i][j][2] = @rows[i] &	@cols[j] & @blocks[@board[i][j][1]]}}
		@board.each_index{|i| @board[i].each_index{|j| @board[i][j][2]=[] if @board[i][j][0]!=0}}	
	end

	def hidden_singles
		for i in 0...9
			for j in 0...9
				remainingrowposs = @board[i][j][2]
				remainingcolposs = @board[i][j][2]
				remainingblockposs = @board[i][j][2]
				block = @board[i][j][0]
				
				for k in (0...9).to_a-[j]
				remainingrowposs=remainingrowposs- @board[i][k][2]
				remainingblockposs=remainingblockposs- @board[i][k][2] if @board[i][k][0]==block
				end

				for k in (0...9).to_a-[i]
				remainingcolposs=remainingcolposs- @board[k][j][2]
				remainingblockposs=remainingblockposs- @board[k][j][2] if @board[k][j][0]==block
				end

				if remainingrowposs.length == 1 ; @board[i][j][0]=remainingrowposs[0] ; break; end
				if remainingcolposs.length == 1 ; @board[i][j][0]=remainingcolposs[0] ; break; end
				if remainingblockposs.length == 1 ; @board[i][j][0]=remainingblockposs[0] ; break; end
			end
		end
	end

	def guess
		originalboard=@board
		@board.each_index{ |i|
			@board[i].each_index { |j|
				if @board[i][j][2]!=[] then 
					@board=originalboard
					saveposs=@board[i][j][2]
					@board[i][j][2].each { |k|
						
						# @board[i][j][2] = saveposs
						@board[i][j][0] = k
						@board[i][j][2] = []
						
					  	row_possibles  	
					  	col_possibles
					  	block_possibles
					  	square_possibles

						solve!
						if @endflag==true
							@finalboard = @board
							puts "We correctly guessed square " + i.to_s + j.to_s + " is: " + k.to_s
							print_board
							break	
						end
						@board = originalboard
						@board[i][j][2] = saveposs
					}
				end
			}
		}
	end

	def fill_blanks
		@endflag=true
		@board.each_index{|i| @board[i].each_index{|j| @board[i][j][0] = @board[i][j][2][0] if @board[i][j][2].length==1}}
		@board.each_index{|i| @board[i].each_index{|j| @endflag = false if @board[i][j][2]!=[]}}
	end


	def solve!
		10.times do 
		fill_blanks
	  	row_possibles  	
	  	col_possibles
	  	block_possibles
	  	square_possibles
	  	hidden_singles	  
	  	# print_board
	  	end
	  	
	  	if @endflag==true
	  		print_board
	  	else 
	  		guess
	  	end


	end
end



# The file has newlines at the end of each line, so we call
# String#chomp to remove them.
board_string = File.readlines('board.txt')[1].chomp

game = Sudoku.new(board_string)

# Remember: this will just fill out what it can and not "guess"
game.solve!
