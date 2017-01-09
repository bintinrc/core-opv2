@selenium @shipment
Feature: shipment management

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page
    Then op click navigation Shipment Management in Inter-Hub

  # create shipment
  Scenario: Create Shipment (uid:7a3373f0-67f1-4f1a-b6b2-6447a2621305)
    When create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    Given op click Load All Selection
    When shipment Delete action button clicked
    Then shipment deleted
    Then op click edit filter

  # edit shipment
  Scenario: Edit Shipment (uid:5fbdb7d5-0a54-42de-bd8e-960ad26ff43e)
    When create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    Given op click Load All Selection
    When shipment Edit action button clicked
    When edit Shipment with Start Hub DOJO, End hub EASTGW and comment Auto Comment Edited
    Then shipment edited
    When shipment Delete action button clicked
    Then shipment deleted
    Then op click edit filter

  # force success shipment
  Scenario: Force Success Shipment (uid:9e106cef-fac4-4283-9b40-634c50ad9413)
    When create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    Given op click Load All Selection
    When shipment Force action button clicked
    Then op click edit filter
    Then op click Load All Selection
    Then shipment status is Completed
    When shipment Delete action button clicked
    Then shipment deleted
    Then op click edit filter

  # cancel shipment
  Scenario: Cancel Shipment (uid:9618d764-8b09-49a3-9cec-07e7d726faee)
    When create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    Given op click Load All Selection
    When shipment Edit action button clicked
    When cancel shipment button clicked
    Then shipment status is Cancelled
    When shipment Delete action button clicked
    Then shipment deleted
    Then op click edit filter

  # delete shipment
  Scenario: Delete Shipment (uid:52e3a21d-29bb-4fd9-82bc-2e161a65565e)
    When create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    Given op click Load All Selection
    When shipment Delete action button clicked
    Then shipment deleted

  @closeBrowser
  Scenario: close browser