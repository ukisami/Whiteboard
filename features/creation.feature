Feature: Creation Descriptions

As a user
I want to be able to create white boards
So that I am able to draw and save and publish my drawing

Scenario: Creating a Whiteboard instance
  Given I am on the homepage
  When I follow  "New Whiteboard"
  Then I should see "Add viewer"

Scenario: Restoring ownership session
  Given whiteboard 1 exists 
  And I am on own whiteboard 1
  When I follow "owner permanent link"
  Then I should see "Add Collaborator"

