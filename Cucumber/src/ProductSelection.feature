#Auto generated NGA revision tag
@TID33162REV0.1.0
Feature: Product selection

  Scenario: Selecting headphones
    Given I am on the site home page
    When I select "Headphones"
    Then I should see 3 items

  Scenario: Selecting mice
    Given I am on the site home page
    When I select "Mice"
    Then I should see 9 items