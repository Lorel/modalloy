require 'sexp_processor'
require 'sexp'
require 'ruby2ruby'
require 'active_support'
require 'active_support/inflector'

module Modalloy
	class ModelProcessor < SexpProcessor
		attr_accessor :relations, :polymorphics, :as #, :has_one, :has_many, :belongs_to, :has_and_belongs_to_many

		def initialize
			super
			@rubier = Ruby2Ruby.new # used to convert hash AST representations to Hash object
			@relations = {}
			@polymorphics
			@as = {}
		end

		def process_class(exp)
			until exp.empty? do
				sexp = exp.shift # exclude first node (:call)
				case 
					when sexp == :class # class name memorize
						klass = exp[0]
						@relations[klass] ||= {}

					when sexp.is_a?(Sexp) && [ :has_one, :has_many, :belongs_to, :has_and_belongs_to_many ].include?(sexp[2]) # looking for one of this relations

						pp sexp.clone
						
						# handle :as case
						if sexp[4] && sexp[4].include?( s(:lit, :as) )
							puts "AS"
							@as[sexp[4][sexp[4].find_index( s(:lit, :as) ) + 1][1]] = sexp[3][1].to_s.singularize.to_sym 
						end

						# handle :polymorphic case
						if sexp[4] && sexp[4].include?( s(:lit, :polymorphic) )
							puts "POLYMORPHIC"
						end

						begin
							options = eval( @rubier.process( sexp[4] || s(:hash) ) ) # get declared options on relation as a Hash

							# raise NameError or RuntimeError for uninitialized constant if Sexp contains :const element
							# For example, in file custom_field_pair, with
							# 	has_one :pair, :class_name => CustomFieldPair, :foreign_key => 'pair_id', :dependent => :destroy
							# converted as Sexp 
							# 	s(:hash, s(:lit, :class_name), s(:const, :CustomFieldPair), s(:lit, :foreign_key), s(:str, "pair_id"), s(:lit, :dependent), s(:lit, :destroy))
							# should return
							# 	"{ :class_name => (CustomFieldPair), :foreign_key => \"pair_id\", :dependent => :destroy }"
							# but raise NameError => uninitialized constant

						rescue NameError, RuntimeError => e
							# error ignored ATM, need to be fixed
							puts e.message  
							puts e.backtrace.inspect
							options = {}
						end
						add_relation(klass, sexp[2], sexp[3][1], options)
				end
			end

			exp # have to return Sexp for forwarding process
		end

		def add_relation(klass, relation, attribute, options)
			# add relation to hash @relations, structured as
			# { :class =>
			#   { :relation_type	=>
			#   	{ :attribute => { :options_hash },
			#       ...
			# 		},
			#     ...
			#   },
			#   ...
			# }

			((@relations[klass] ||= {})[relation] ||= {})[attribute] = options
		end
	end
end