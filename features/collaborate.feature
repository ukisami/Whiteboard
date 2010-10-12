Feature: Collaborate Descriptions

As viewer of a white board
I want to be able to draw
So I can collaborate with the owner

Scenario: Happy Path
  Given I am collaborating on a whiteboard
  When I draw a line
  Then the whiteboard should be updated

