# usage:
# irb> Solver.solve(8, 8, 3, 3)

class Solver

	def initialize(nums)
		@nums = nums
		@arity = nums.size
		@ops = initialize_functions
		@op_orders = (@ops.keys * (@arity - 1)).permutation(@arity - 1).to_a.uniq
		@solutions = []

		@SOLUTION = 24.0
		@MAX_SOLUTIONS = 10
	end

	def solve
		# iterate over all unique permutations of given numbers
		@nums.permutation.to_a.uniq do |ordered_nums|
			# iterate over all permutations of the operators
			@op_orders.each do |ops|
				procs = ops.map{|op_name| @ops[op_name][:proc]}
				symbols = ops.map{|op_name| @ops[op_name][:symbol]}
				# iterate over all possible orders of operations
				(0...ops.size).entries.permutation do |order_of_ops|
					ordered_nums_copy = ordered_nums.clone
					root = nil
					order_of_ops.each do |op_index|
						proc = procs[op_index]
						sym = symbols[op_index]
						tree = BinaryTree.new(proc, sym, ordered_nums_copy[op_index], ordered_nums_copy[op_index + 1])
						ordered_nums_copy[op_index] = tree
						ordered_nums_copy[op_index + 1] = tree
						root = tree
					end
					# puts root
					answer = root.calc
					if is_solution?(answer)
						@solutions << root.to_s
						if @solutions.size >= @MAX_SOLUTIONS
							return @solutions
						end
					end
				end
			end
		end

		return @solutions
	end

	private

	def initialize_functions
		add = Proc.new{|n, m| n + m}
		subtract = Proc.new{|n, m| n - m}
		multiply = Proc.new{|n, m| n * m}
		divide = Proc.new{|n, m| n.to_f / m}
		exponent = Proc.new{|n, m| n ** m}

		return {
			add: {
				proc: add,
				symbol: '+'
			},
			subtract: {
				proc: subtract,
				symbol: '-'
			},
			multiply: {
				proc: multiply,
				symbol: '*'
			},
			divide: {
				proc: divide,
				symbol: '/'
			}
			# exponent: {
			#   proc: exponent,
			#   symbol: '^'
			# }
		}
	end

	def is_solution?(solution)
		return (@SOLUTION - solution.to_f).abs < 0.000001
	rescue
		false
	end

	def self.solve(*nums)
		Solver.new(nums).solve
	end
end

class BinaryTree
	attr_accessor :left, :right, :proc, :sym
	def initialize(proc = nil, sym = nil, left = nil, right = nil)
		self.proc, self.sym, self.left, self.right = proc, sym, left, right
	end
	def calc
		left_operand = (left.is_a? BinaryTree) ? left.calc : left.to_f
		right_operand = (right.is_a? BinaryTree) ? right.calc : right.to_f
		return proc.call(left_operand, right_operand)
	end
	def to_s
		return "(#{left.to_s} #{sym} #{right.to_s})"
	end
end