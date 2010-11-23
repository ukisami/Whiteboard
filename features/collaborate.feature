Feature: Collaborate Descriptions

As viewer of a white board
I want to be able to draw
So I can collaborate with the owner

Scenario: Controls as owner
  Given whiteboard 1 exists
  When I go to own whiteboard 1
  Then I should see "New layer..."
  And I should see "Publish"
  And toolbar exists

Scenario: Controls as viewer
  Given whiteboard 1 exists
  When I go to view whiteboard 1
  Then I should not see "New layer..."
  And I should not see "Publish"
  And toolbar does not exist

Scenario: Controls as collaborator
  Given whiteboard 1 exists
  And there is another collaborator for whiteboard 1
  When I go to collaborate on whiteboard 1
  Then I should not see "New layer"
  And I should not see "Publish"
  And toolbar exists

Scenario: Effect of adding collaborator
  Given whiteboard 1 exists
  And I am on own whiteboard 1
  When I follow "New layer"
  And I fill in "Name" with "wh"
  And I press "Create"
  Then whiteboard 1 should have 2 layers
  
Scenario: Redirect to owner page after adding collaborator
	Given whiteboard 1 exists
	And I am on own whiteboard 1
	When I follow "New layer"
	And I fill in "Name" with "wh"
	And I press "Create"
	Then I should see "New layer"


