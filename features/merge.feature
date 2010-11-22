Feature: Merge Descriptions

As a owner
I want to be able to separate the work of my collaborators
So I can merge the content of my white board the way i want

Scenario: Viewing different layers
  Given I am the owner of the whiteboard
  When I press the checkbox of one layer
  Then I should see that layer
