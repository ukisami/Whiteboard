Feature: Chatting Descriptions

As a user of a whiteBoard
I want to be able to chat with the owner and other collaborators
So they know what I am thinking about the current drawing

Scenario: owner can chat
	Given whiteboard 1 exists
	And I am on own whiteboard 1
	When I fill in "chatbody" with "hello"
	And I press "Chat"
	Then I should see "hello"
	And I should see "Base Layer"
	
Scenario: collaborator can chat
	Given whiteboard 1 exists
	And there is another collaborator for whiteboard 1
  When I go to collaborate on whiteboard 1
	And I fill in "chatbody" with "hello"
	And I press "Chat"
	Then I should see "hello"
	
Scenario: viewer can chat 
	Given whiteboard 1 exists
	And I am on view whiteboard 1
	When I fill in "chatbody" with "hello"
	And I press "Chat"
	Then I should see "hello"
	And I should see "viewer"
	
Scenario: anyone can see anyone's chat on the same board 
	Given whiteboard 1 exists
	And I am on own whiteboard 1
	When I fill in "chatbody" with "hello"
	And I press "Chat"
	And I am on view whiteboard 1
	Then I should see "hello"
	And I should see "Base Layer"





