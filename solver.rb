# usage:
# irb> Solver.solve(8, 8, 3, 3)

require 'set'

class Solver

	def initialize(nums)
		@nums = nums
		@arity = nums.size
		@ops = initialize_functions
		@op_orders = op_orders(@ops.keys, @arity - 1)
		@solutions = Set.new

		@SOLUTION = 24.0
		@MAX_SOLUTIONS = 10
		@TOLERANCE = 0.000001
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
						old_ref1, ordered_nums_copy[op_index] = ordered_nums_copy[op_index], tree
						old_ref2, ordered_nums_copy[op_index + 1] = ordered_nums_copy[op_index + 1], tree
						ordered_nums_copy.each_with_index do |ref, index|
							if (ref.is_a? BinaryTree) && [old_ref1, old_ref2].include?(ref)
								ordered_nums_copy[index] = tree
							end
						end
						root = tree
					end
					answer = root.calc
					if is_solution?(answer)
						# puts "solution: #{root}"
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
		return (@SOLUTION - solution.to_f).abs < @TOLERANCE
	rescue
		false
	end

	def op_orders(ops, num_to_choose)
		results = []
		radix = ops.size
		min = 0
		max = ((ops.size - 1).to_s * num_to_choose).to_i(radix)
		(min..max).each do |num|
			results << ("0" * num_to_choose + num.to_s(radix)).slice(num_to_choose * -1, num_to_choose).split('').map{|i| ops[i.to_i]}
		end
		return results
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