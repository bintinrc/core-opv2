@OperatorV2 @Reservation @ShouldAlwaysRun
Feature: Reservation

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: add reservation (uid:b2a5084c-16f9-42ce-9203-131574e5f3d2)
    Given Operator go to menu Shipper Support -> Reservations
    When reservation, create input shipper "QA Account" and address "7F CRESCENT ROAD SG" with volume "Less than 10 Parcels"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Reservations
    When reservation, input shipper "QA Account" and address "7F CRESCENT ROAD SG"
    Then reservation, verify "new"

  Scenario: edit reservation (uid:a7b7630f-5723-45c4-9575-1b9ed572be17)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Reservations
    When reservation, input shipper "QA Account" and address "7F CRESCENT ROAD SG"
    When reservation, edit
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Reservations
    When reservation, input shipper "QA Account" and address "7F CRESCENT ROAD SG"
    Then reservation, verify "edit"

  Scenario: delete reservation (uid:4d256cf6-cada-491d-855f-900e7f01c8d6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Reservations
    When reservation, input shipper "QA Account" and address "7F CRESCENT ROAD SG"
    When reservation, delete
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Reservations
    When reservation, input shipper "QA Account" and address "7F CRESCENT ROAD SG"
    Then reservation, verify "delete"

  @KillBrowser
  Scenario: Kill Browser
