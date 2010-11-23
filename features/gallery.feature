Feature: Publishing/Gallery Descriptions

As a owner 
I want to be able to publish my drawing board
So that everyone can see my work

Scenario: Viewing the gallery of a whiteBoard
	Given whiteboard 1 exists and published
  When I click "Gallery"
  Then I should see "whiteboard 1"
  
Scenario: No Gallery for a unpublished whiteBoard
	Given whiteboard 1 exists
	And whiteboard 1 is not published
	When I click "Gallery"
	Then I should not see "whiteboard 1"
	
Scenario: participants can post comments on gallery (anonymously)
	Given gallery 1 exists
	When I go to view gallery 1
	And I fill in "Comment" with "hello"
	And I press "Submit"
	Then I should see "hello"
	And comment field is empty
	
Scenario: cannot supply empty comment
	Give gallery 1 exists
	When I go to view gallery 1
	And I fill in "Comment" with " "
	And I press "Submit"
	Then I should see "can't be blank"
