Feature: Publishing/Gallery Descriptions

As a owner 
I want to be able to publish my drawing board
So that everyone can see my work

Scenario: Viewing the gallery of a whiteBoard
	Given whiteboard 1 exists 
	And gallery 1 exists
  When I go to view gallery page
  Then I should see "whiteboard 1"
  
Scenario: No Gallery for a unpublished whiteBoard
	Given whiteboard 1 exists
	When I go to view gallery page
	Then I should not see "whiteboard 1"
	
Scenario: participants can post comments on gallery (anonymously)
	Given gallery 1 exists
	When I go to view gallery 1
	And I fill in "comment_content_1" with "hello"
	And I press "Submit"
	Then I should see "hello"
	
Scenario: cannot supply empty comment
	Given gallery 1 exists
	When I go to view gallery 1
	And I fill in "comment_content_1" with " "
	And I press "Submit"
	Then I should see "can't be blank"

Scenario: can see the next six available galleries if there's any 
	Given gallery 1 exists
	And gallery 2 exists
	And gallery 3 exists
	And gallery 4 exists
	And gallery 5 exists
	And gallery 6 exists
	And gallery 7 exists
	When I go to view gallery page 
	And I follow "Next page"
	Then I should see "whiteboard 1"
	And I should not see "Whiteboard 2"
	And I should not see "Whiteboard 5"
	And I should not see "Whiteboard 7"
	And I should not see "Next page"

Scenario: can see the previous six galleries
	Given gallery 1 exists
	And gallery 2 exists
	And gallery 3 exists
	And gallery 4 exists
	And gallery 5 exists
	And gallery 6 exists
	And gallery 7 exists
	When I go to view next gallery page 
	And I follow "Previous page"
	Then I should not see "Previous page"
	And I should see "whiteboard 1"
			
Scenario: can do basic search by the names of galleries 
	Given gallery 1 exists
	And gallery 2 exists
	And gallery 3 exists
	And gallery 4 exists
	And gallery 5 exists
	And gallery 6 exists
	And gallery 7 exists
	When I go to view gallery page 
	And I fill in "search" with "whiteboard 1"
	And I press "search"
	Then I should see "whiteboard 1"
	
	
Scenario: can do sort by date (Most Recent)
	Given gallery 1 exists
	And gallery 2 exists
	And gallery 3 exists
	And gallery 4 exists
	And gallery 5 exists
	And gallery 6 exists
	And gallery 7 exists
	When I go to view gallery page
	Then I should not see "whiteboard 1"
	
Scenario: can do sort by total views (highest views first)
	Given gallery 1 exists
	And gallery 2 exists
	And gallery 3 exists
	And gallery 4 exists
	And gallery 5 exists
	And gallery 6 exists
	And gallery 7 exists
	When I go to view gallery page
	And I follow "Next page"
	And I follow "whiteboard 1"
	And I follow "Back"
	And I follow "Total Views"
	Then I should see "whiteboard 1"
	
Scenario: can do sort by Recommendation
	Given gallery 1 exists
	And gallery 2 exists
	And gallery 3 exists
	And gallery 4 exists
	And gallery 5 exists
	And gallery 6 exists
	And gallery 7 exists
	When I go to view gallery page
	And I follow "Next page"
	And I follow "whiteboard 1"
	And I follow "Like"
	And I follow "Back"
	And I follow "Recommendation"
	Then I should see "whiteboard 1"
	
Scenario: Total view of a gallery increment by one for every visit 
	Given gallery 1 exists
	When I go to view gallery page
	And I follow "whiteboard 1"
	And I follow "Back"
	And I follow "whiteboard 1"
	Then I should see "2"
	
Scenario: A user can only like once
	Given I already liked Gallery 1
	When I go to view gallery page 
	And I follow "whiteboard 1"
	Then "#likeP2" exists
	And I should see "You"
	
