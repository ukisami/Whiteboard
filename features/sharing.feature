Feature: Sharing Descriptions

As creator of a white board
I want to be able to share my white board
So other users can watch me draw

Scenario: Viewers can see the intended whiteboard
  Given whiteboard 1 exists
  When I go to view whiteboard 1
  Then I should see "whiteboard 1"
  
