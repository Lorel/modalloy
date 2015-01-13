require 'sexp_processor'
require 'sexp'

class ModelProcessor < SexpProcessor
	attr_accessor :has_one, :has_many, :belongs_to, :has_and_belongs_to_many

	def initialize
		super
		@has_one = []
		@has_many = []
		@belongs_to = []
		@has_and_belongs_to_many = []
	end

	def process_class(exp)
		puts exp.clone
		# exp.shift 										# pop :call
		# if sexp = exp.shift						# case when second element is a sexp for const or lvar
		# 	until exp.empty? do
		# 		exp.shift
		# 	end
		# else													# case when second element in sexp is nil
		exp2 = exp.clone
		puts "YEAH !!!!" + exp.size.to_s
			until exp.empty? do
				sexp = exp.shift
				case 
					when sexp == :class
						puts "YEAH !!!!"# + exp.size.to_s
						klass = exp[0]
						puts klass
						#pp exp.clone
					when sexp.is_a?(Sexp) && sexp[2] == :has_one
						puts "HAS ONE !!!!"
						# exp = exp.shift
						@has_one << [klass,sexp[2],sexp[3][1]]
						pp sexp
					when sexp.is_a?(Sexp) && sexp[2] == :has_many
						# exp = exp.shift
						@has_many << [klass,sexp[2],sexp[3][1]]
						pp sexp
					when sexp.is_a?(Sexp) && sexp[2] == :belongs_to
						# exp = exp.shift
						@belongs_to << [klass,sexp[2],sexp[3][1]]
						pp sexp
					when sexp.is_a?(Sexp) && sexp[2] == :has_and_belongs_to_many
						# exp = exp.shift
						@has_and_belongs_to_many << [klass,sexp[2],sexp[3][1]]
						pp sexp
				end
			end
		# end
		# pp exp2
		exp2
	end
end