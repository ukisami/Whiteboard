Feature: Creation Descriptions

As a user
I want to be able to create white boards
So that I am able to draw and save and publish my drawing

Scenario: Creating a whiteBoard instance
  Given I am on the new board page
  When I fill in "Title" with "wb1"
  And I press "Create"
  Then I should see "New layer"

Scenario: Restoring ownership session
  Given whiteboard 1 exists 
  And I am on own whiteboard 1
  When I am on restore whiteboard 1
  Then I should see "New layer"
  And I should see "Publish"
