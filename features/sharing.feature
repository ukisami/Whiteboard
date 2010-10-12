Feature: Sharing Descriptions

As creator of a white board
I want to be able to share my white board
So other users can watch me draw

Scenario: Happy Path
  Given there is a whiteboard with id 1
  When I go to whiteboard 1 as a viewer
  Then I should see "whiteboard 1"
  
