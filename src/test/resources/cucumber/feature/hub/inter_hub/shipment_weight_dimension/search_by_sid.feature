@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @SearchBySID @CWF
Feature: Search by SID

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @RT
  Scenario: Search by SID with Single Valid Shipment ID
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "{KEY_CREATED_SHIPMENT_ID}" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | search_valid |
    When Operator click search button on Shipment Weight Dimension page


  @KillBrowser
  Scenario: Kill Browser
    Given no-op
