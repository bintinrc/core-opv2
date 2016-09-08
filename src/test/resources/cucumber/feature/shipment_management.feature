@selenium
Feature: shipment management

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in dp administration

  # create shipment
  Scenario: create shipment
    Given op click navigation Shipment Management
    When create shipment button is clicked
    When create Shipment with Start Hub 30JKB and End hub DOJO
    Then shipment created

  # edit shipment
  Scenario: edit shipment
    Given op click Load All Shipment
    When shipment Edit action button clicked
    When edit Shipment with Start Hub DOJO and End hub EASTGW
    Then shipment edited

  # force success shipment
  Scenario: force success shipment
    Given op click Load All Shipment
    When shipment Force action button clicked
    Then shipment status is Completed

  # cancel shipment
  Scenario: force success shipment
    Given op click Load All Shipment
    When shipment Edit action button clicked
    When cancel shipment button clicked
    Then shipment status is Cancelled

  # delete shipment
  Scenario: force success shipment
    Given op click Load All Shipment
    When shipment Delete action button clicked
    Then shipment deleted

  @closeBrowser
  Scenario: close browser