require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When /^I enter "([^"]*)" into "([^"]*)"$/ do |arg1, arg2|
  fill_in arg2, :with=>arg1
end


Given /^whiteboard (\d+) exists$/ do |arg1|
	Board.create(:id => arg1, :title => 'whiteboard ' + arg1)
end

Then /^whiteboard (\d+) should have (\d+) layers$/ do |arg1, arg2|
	Board.find(arg1).layers.length.should equal arg2.to_i
end

Given /^gallery (\d+) exists$/ do |arg1|
	board = Board.create(:id=> arg1, :title => 'whiteboard '+ arg1 )
  board.galleries.create(:id=>arg1)
end

Given /^there is another collaborator for whiteboard (\d+)$/ do |arg1|
	board = Board.find(arg1)
	board.layers << Layer.new
	board.save
end

Given /^I already liked Gallery (\d+)$/ do |arg1|
  board = Board.create(:id=> arg1, :title => 'whiteboard '+ arg1 )
  board.galleries.create(:id=>arg1)
  gallery=Gallery.find(arg1)
  like = gallery.likes.new()
  like.ip = "127.0.0.1"
  like.save
end


Then /^"([^"]*)" exists$/ do |id|
  response.should have_selector(id)
end

Then /^"([^"]*)" does not exist$/ do |id|
  response.should_not have_selector(id)
end

