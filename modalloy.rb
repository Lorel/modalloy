require 'pp'
require 'arby/arby'
require 'arby/arby_dsl'
require 'active_support'
require 'active_support/inflector'

module Modalloy

	extend self

	def load
		Dir[File.expand_path File.dirname(__FILE__) + '/' +  ( ARGV.shift || 'datas/models' ) + '/**/*.rb'] #.each do |path|
		# 	pp path
		# end
	end

	def models
		load
		Module.constants.select do |constant_name|
			constant = eval constant_name.to_s
			if not constant.nil? and constant.is_a? Class and constant.superclass == ActiveRecord::Base
				constant
			end
		end
	end

	def h_model_attributes
		Hash[ models.map{|m| [m,Kernel.const_get(m).new.attributes] } ]
	end

	def h_model_validators
		Hash[ models.map{|m| [m,Kernel.const_get(m).validators] } ]
	end


	module ArbyModel
		extend self
		extend Arby::Dsl

		def translate_relation relation
			{
				has_one: 									"lone",
				has_many: 								"set",
				belongs_to: 							"one",
				has_and_belongs_to_many: 	"set"
			}[relation]
		end

		def translate_model(specifications, aliases)
			declaration = ""

			specifications.each do |klass,relations|
				declaration +=
					"sig " +
					klass.to_s +
					#relations[:belongs]
					" [ " +
					relations.keys.map{ |relation|
						relations[relation].keys.map{ |attribute| 
							attribute.to_s +
							": (" +
							translate_relation(relation) +
							" " +
							(relations[relation][attribute][:class_name] || attribute).to_s.singularize.capitalize.camelize +
							")"
						}.join(", ")
					}.join(", ") +
					"]\n"
			end

			aliases.each{ |as,klass| declaration += "sig " + as.to_s.singularize.capitalize.camelize + " extends " + klass.to_s.singularize.capitalize.camelize + "\n" }

			puts declaration

			alloy :Rails_model do
				eval declaration

				# run
			end
		end
	end
end


# example of specifications struct
# {:User=>
#   {:has_one=>{:avatar=>{:as=>:entity, :dependent=>:destroy}},
#    :has_many=>
#     {:avatars=>{},
#      :comments=>{:as=>:commentable},
#      :accounts=>{},
#      :campaigns=>{},
#      :leads=>{},
#      :contacts=>{},
#      :opportunities=>{},
#      :assigned_opportunities=>
#       {:class_name=>"Opportunity", :foreign_key=>"assigned_to"},
#      :permissions=>{:dependent=>:destroy},
#      :preferences=>{:dependent=>:destroy},
#      :lists=>{}},
#    :has_and_belongs_to_many=>{:groups=>{}}}}


