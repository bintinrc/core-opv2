@OperatorV2 @OperatorV2Part2 @ReservationPresetManagement @CWF @SIT
Feature: Reservation Preset Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteReservationGroup
  Scenario: Operator add new Reservation Group on page Reservation Preset Management (uid:2f701775-293e-47cd-86e7-70b2c0957686)
    Given Operator go to menu Pick Ups -> Reservation Preset Management
    When Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED           |
      | driver | {ninja-driver-name} |
      | hub    | {hub-name}          |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params

  @DeleteReservationGroup
  Scenario: Operator edit new Reservation Group on page Reservation Preset Management (uid:a1894bcc-03e3-4e9a-b163-ebeb38a39805)
    Given Operator go to menu Pick Ups -> Reservation Preset Management
    When Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED           |
      | driver | {ninja-driver-name} |
      | hub    | {hub-name}          |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params
    When Operator edit created Reservation Group on Reservation Preset Management page using data below:
      | name | GENERATED    |
      | hub  | {hub-name-2} |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page

  @DeleteReservationGroup
  Scenario: Operator delete new Reservation Group on page Reservation Preset Management (uid:dba33834-9036-4c5b-a12a-5b530b1a7638)
    Given Operator go to menu Pick Ups -> Reservation Preset Management
    When Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED           |
      | driver | {ninja-driver-name} |
      | hub    | {hub-name}          |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params
    When Operator delete created Reservation Group on Reservation Preset Management page
    And Operator refresh page
    Then Operator verify created Reservation Group was deleted successfully on Reservation Preset Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
