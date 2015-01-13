# require 'active_record'
require 'pp'

module Modalloy

	extend self

	def load
		Dir[File.expand_path File.dirname(__FILE__) + '/datas/models/**/*.rb'].each do |path|
			pp path
		end
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
end