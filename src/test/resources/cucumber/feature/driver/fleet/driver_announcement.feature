@OperatorV2 @Driver @Fleet @DriverStrengthV2
Feature: Driver Strength

  @RunThis @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @RunThis
  Scenario: Operator Open an Announcement on Driver Announcement page
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Announcement
    And Operator select the first row on Driver Announcement page


