@02Sample @Dummy
Feature: Sample 02

  @LaunchBrowserDummy @ShouldAlwaysRun
  Scenario: Launch Browser
    Given step "SUCCESS"

  @02Sample#01
  Scenario: Scenario 1 on Sample 2
    Given random step

  @02Sample#02
  Scenario: Scenario 2 on Sample 2
    Given random step

  @02Sample#03
  Scenario: Scenario 3 on Sample 2
    Given random step

  @KillBrowserDummy @ShouldAlwaysRun
  Scenario: Kill Browser
    Given step "SUCCESS"
