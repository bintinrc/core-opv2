@selenium @reservation
Feature: reservation

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page

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

  @closeBrowser
  Scenario: close browser