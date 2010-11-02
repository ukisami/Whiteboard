require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^whiteboard (\d+) exists$/ do |arg1|
	Board.create(:id => arg1, :title => 'whiteboard ' + arg1)
end

Then /^whiteboard (\d+) should have (\d+) layers$/ do |arg1, arg2|
	Board.find(arg1).layers.length.should equal arg2.to_i
end

Given /^there is another collaborator for whiteboard (\d+)$/ do |arg1|
	board = Board.find(arg1)
	board.layers << Layer.new
	board.save
end

