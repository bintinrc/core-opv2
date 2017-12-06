@01Sample @Dummy
Feature: Sample 02

  @ShouldAlwaysRun
  Scenario: Launch Browser
    Given step "SUCCESS"

  Scenario: Scenario 1 on Sample 2 <orderType>
    Given random step

  Scenario: Scenario 2 on Sample 2 <orderType>
    Given random step

  Scenario: Scenario 3 on Sample 2 <orderType>
    Given random step

  @ShouldAlwaysRun
  Scenario: Kill Browser
    Given step "SUCCESS"