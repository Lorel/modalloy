require 'ruby_parser'

load "modalloy.rb"
load "model_processor.rb"

class App
	attr_accessor :parser, :processor

	def initialize
		@parser = RubyParser.new
		@processor = Modalloy::ModelProcessor.new
	end

	def test
		Modalloy::load.each { |f| @processor.process @parser.parse(File.read f) }
	end

	def test2
		@processor.process_class @parser.parse("class User < ActiveRecord::Base
	  attr_protected :admin, :suspended_at

	  before_create  :check_if_needs_approval
	  before_destroy :check_if_current_user, :check_if_has_related_assets

	  has_one     :avatar, :as => :entity, :dependent => :destroy  # Personal avatar.
	  has_many    :avatars                                         # As owner who uploaded it, ex. Contact avatar.
	  has_many    :comments, :as => :commentable                   # As owner who created a comment.
	  has_many    :accounts
	  has_many    :campaigns
	  has_many    :leads
	  has_many    :contacts
	  has_many    :opportunities
	  has_many    :assigned_opportunities, :class_name => 'Opportunity', :foreign_key => 'assigned_to'
	  has_many    :permissions, :dependent => :destroy
	  has_many    :preferences, :dependent => :destroy
	  has_many    :lists
	  has_and_belongs_to_many :groups
		end")
	end
end



# load "app.rb"
# a = App.new
# a.test
# Modalloy::ArbyModel::translate_model(a.processor.relations, a.processor.as)