class Solver

	def initialize(nums)
		@nums = nums
		@arity = nums.size
		@ops = initialize_functions
		@op_orders = (@ops.keys * (@arity - 1)).permutation(@arity - 1).to_a.uniq
		@solutions = []
	end

	def solve
		@nums.permutation do |ordered_nums|
			# n1, n2, n3, n4 = ordered_nums
			@op_orders.each do |op_order|
				procs = op_order.map{|op_name| @ops[op_name][:proc]}
				symbols = op_order.map{|op_name| @ops[op_name][:symbol]}
				# puts "evaluating: #{n1} #{s1} #{n2} #{s2} #{n3} #{s3} #{n4}"

				#TODO iterate over all possible orders of operations
				answer1 = o3.call(o2.call(o1.call(n1, n2), n3), n4) # (((3 * 3) + 3) * 2)
				@solutions << ['(((', n1, s1, n2, ')', s2, n3, ')', s3, n4, ')'].join if is_solution(answer1)
				answer2 = o2.call(o1.call(n1, n2), o3.call(n3, n4)) # ((3 + 3) * (2 + 2))
				@solutions << ['((', n1, s1, n2, ')', s2, '(', n3, s3, n4, '))'].join if is_solution(answer2)
				answer3 = o1.call(n1, o2.call(n2, o3.call(n3, n4))) # (8 / (3 - (8 / 3)))
				@solutions << ['(', n1, s1, '(', n2, s2, '(', n3, s3, n4, ')))'].join if is_solution(answer3)
			end
		end

		puts @solutions.uniq
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

	def is_solution(solution)
		return (24.0 - solution.to_f).abs < 0.000001
	rescue
		false
	end
end
