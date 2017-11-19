@Reservation @selenium @Reservation#01
Feature: Reservation

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: add reservation (uid:b2a5084c-16f9-42ce-9203-131574e5f3d2)
    Given op click navigation Reservations in Shipper Support
    When reservation, create input shipper "QA Account" and address "7F CRESCENT ROAD SG" with volume "Less than 10 Parcels"
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Reservations in Shipper Support
    When reservation, input shipper "QA Account" and address "7F CRESCENT ROAD SG"
    Then reservation, verify "new"

  Scenario: edit reservation (uid:a7b7630f-5723-45c4-9575-1b9ed572be17)
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Reservations in Shipper Support
    When reservation, input shipper "QA Account" and address "7F CRESCENT ROAD SG"
    When reservation, edit
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Reservations in Shipper Support
    When reservation, input shipper "QA Account" and address "7F CRESCENT ROAD SG"
    Then reservation, verify "edit"

  Scenario: delete reservation (uid:4d256cf6-cada-491d-855f-900e7f01c8d6)
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Reservations in Shipper Support
    When reservation, input shipper "QA Account" and address "7F CRESCENT ROAD SG"
    When reservation, delete
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Reservations in Shipper Support
    When reservation, input shipper "QA Account" and address "7F CRESCENT ROAD SG"
    Then reservation, verify "delete"

  @KillBrowser
  Scenario: Kill Browser
