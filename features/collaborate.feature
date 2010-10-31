Feature: Collaborate Descriptions

As viewer of a white board
I want to be able to draw
So I can collaborate with the owner

Scenario: Happy Path
  Given I am collaborating on a whiteboard
  When I draw a line
  Then the whiteboard should be updated
  
Scenario: Controls as owner
  Given whiteboard 1 exists
  When I go to own whiteboard 1
  Then I should see "Add viewer" 
  And I should see "Add collaborator"
  
Scenario: Controls as viewer
  Given whiteboard 1 exists
  When I go to view whiteboard 1
  Then I should not see "Add collaborator"
  And I should see "Add viewer"
  
Scenario: Controls as collaborator
  Given whiteboard 1 exists
  And there is another collaborator for whiteboard 1
  When I go to collaborate on whiteboard 1
  Then I should not see "Add collaborator"
  And I should see "Add viewer"

Scenario: Effect of adding collaborator
  Given whiteboard 1 exists
  When I go to collaborate on whiteboard 1
  Then whiteboard 1 should have 2 layers
  

