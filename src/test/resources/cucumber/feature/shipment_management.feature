@OperatorV2Disabled @ShipmentManagement
Feature: Shipment Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Shipment (uid:7a3373f0-67f1-4f1a-b6b2-6447a2621305)
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentManagement.
    When Operator click "Load All Selection" on Shipment Management page
    When Operator click Delete button on Shipment Management page
    Then Operator verify the Shipment is deleted successfully

  Scenario: Edit Shipment (uid:5fbdb7d5-0a54-42de-bd8e-960ad26ff43e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentManagement.
    When Operator click "Load All Selection" on Shipment Management page
    When Operator click Edit button on Shipment Management page
    When Operator edit Shipment with Start Hub DOJO, End hub EASTGW and comment Modified by feature @ShipmentManagement.
    Then Operator verify the shipment is edited successfully
    When Operator click Delete button on Shipment Management page
    Then Operator verify the Shipment is deleted successfully

  Scenario: Force Success Shipment (uid:9e106cef-fac4-4283-9b40-634c50ad9413)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentManagement.
    When Operator click "Load All Selection" on Shipment Management page
    When Operator click Force button on Shipment Management page
    Then Operator click Edit filter on Shipment Management page
    Then Operator click "Load All Selection" on Shipment Management page
    Then Operator verify the shipment status is Completed
    When Operator click Delete button on Shipment Management page
    Then Operator verify the Shipment is deleted successfully

  Scenario: Cancel Shipment (uid:9618d764-8b09-49a3-9cec-07e7d726faee)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentManagement.
    When Operator click "Load All Selection" on Shipment Management page
    When Operator click Edit button on Shipment Management page
    When Operator click "Cancel Shipment" button on Shipment Management page
    Then Operator verify the shipment status is Cancelled
    When Operator click Delete button on Shipment Management page
    Then Operator verify the Shipment is deleted successfully

  Scenario: Delete Shipment (uid:52e3a21d-29bb-4fd9-82bc-2e161a65565e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentManagement.
    Given Operator click "Load All Selection" on Shipment Management page
    When Operator click Delete button on Shipment Management page
    Then Operator verify the Shipment is deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
