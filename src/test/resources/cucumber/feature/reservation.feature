@selenium @reservation
Feature: reservation

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page

  Scenario: add reservation
    Given op click navigation Reservations in Shipper Support
    When reservation, create input shipper "QA Account" and address "228 ORCHARD ROAD OG ORCHARD SG 238853 SG" with volume "Less than 10 Parcels"
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Reservations in Shipper Support
    When reservation, input shipper "QA Account" and address "228 ORCHARD ROAD OG ORCHARD SG 238853 SG"
    Then reservation, verify "new"

  Scenario: edit reservation
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Reservations in Shipper Support
    When reservation, input shipper "QA Account" and address "228 ORCHARD ROAD OG ORCHARD SG 238853 SG"
    When reservation, edit
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Reservations in Shipper Support
    When reservation, input shipper "QA Account" and address "228 ORCHARD ROAD OG ORCHARD SG 238853 SG"
    Then reservation, verify "edit"

  Scenario: delete reservation
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Reservations in Shipper Support
    When reservation, input shipper "QA Account" and address "228 ORCHARD ROAD OG ORCHARD SG 238853 SG"
    When reservation, delete
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Reservations in Shipper Support
    When reservation, input shipper "QA Account" and address "228 ORCHARD ROAD OG ORCHARD SG 238853 SG"
    Then reservation, verify "delete"

  @closeBrowser
  Scenario: close browser