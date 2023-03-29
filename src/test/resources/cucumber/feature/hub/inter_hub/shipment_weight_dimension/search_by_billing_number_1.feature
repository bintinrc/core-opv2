@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @SearchByBillingNumber1
Feature: Search by Billing Number 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments
  Scenario: Search Shipment by Valid MAWB
    Given API Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = {local-hub-1-id} to hub id = {local-hub-2-id}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verifies Shipment Weight Dimension page UI

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op