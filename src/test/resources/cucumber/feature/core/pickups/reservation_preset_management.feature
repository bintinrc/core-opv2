@OperatorV2 @Core @PickUps @ReservationPresetManagement
Feature: Reservation Preset Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteReservationGroup
  Scenario: Operator Create New Group to Assign Driver on Reservation Preset Management Page (uid:5e413315-ed96-4c3a-92b6-9b58b2d34a25)
    Given Operator go to menu Pick Ups -> Reservation Preset Management
    When Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED           |
      | driver | {ninja-driver-name} |
      | hub    | {hub-name}          |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params

  @DeleteReservationGroup
  Scenario: Operator Edit Reservation Group on Reservation Preset Management Page (uid:c4721621-2712-410e-b8c7-561e2999361e)
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
  Scenario: Operator Delete Reservation Group on Reservation Preset Management Page (uid:3c303ac8-8409-4337-b854-786a22b50f62)
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
