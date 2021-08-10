@Sort @SortBeltManager
Feature: Sort Belt Manager

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedSortBeltConfig
  Scenario: Create Shipment (uid:d854e586-6b9d-4287-970d-3c43a1cc5c99)
    Given API Operator creates new configuration for sort belt with device id "{config-device-id}"
      | numberOfConfig | 2        |
      | destinationHub | {hub-id} |
      | shipmentType   | AIR_HAUL |
    And API Operator activates the newly created configuration with device id "{config-device-id}"
    When Operator go to menu Sort -> Sort Belt Shipments
    And Operator switches to iframe
    And Operator selects "{sort-belt-shipment-hub}" "hub" on Sort Belt Shipment Page
    And Operator selects "{sort-belt-shipment-device}" "device" on Sort Belt Shipment Page
    And Operator clicks on Create Shipment Button
    And Operator fills all the data correctly in Create Shipments Dialog on Sort Belt Shipment
      | numberOfArms      | 2 |
      | numberOfShipments | 2 |
    Then Operator verifies that the shipment is created on Sort Belt Shipment Page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verifies that the details of created shipments are correct

  @DeleteNewlyCreatedSortBeltConfig
  Scenario: Create Shipment Shipments per output More Than Max Limit (uid:9de43a16-f58d-481a-b980-20e95a541a49)
    Given API Operator creates new configuration for sort belt with device id "{config-device-id}"
      | numberOfConfig | 2        |
      | destinationHub | {hub-id} |
      | shipmentType   | AIR_HAUL |
    And API Operator activates the newly created configuration with device id "{config-device-id}"
    When Operator go to menu Sort -> Sort Belt Shipments
    And Operator switches to iframe
    And Operator selects "{sort-belt-shipment-hub}" "hub" on Sort Belt Shipment Page
    And Operator selects "{sort-belt-shipment-device}" "device" on Sort Belt Shipment Page
    And Operator clicks on Create Shipment Button
    And Operator fills invalid data exceeding limit of shipment number  on Sort Belt Shipment Page
      | numberOfArms      | 2  |
      | numberOfShipments | 50 |
    Then Operator verifies that the shipment is created on Sort Belt Shipment Page
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verifies that the details of created shipments are correct

  Scenario: Create Shipment With Empty Compulsory Field (uid:2fe48046-947d-4442-ad95-a4ff43041415)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Belt Shipments
    And Operator switches to iframe
    And Operator selects "{sort-belt-shipment-hub}" "hub" on Sort Belt Shipment Page
    And Operator selects "{sort-belt-shipment-device}" "device" on Sort Belt Shipment Page
    And Operator clicks on Create Shipment Button
    And Operator left mandatory field empty in Shipment Creation Dialog on Sort Belt Shipment
    Then Operator verifies there will be empty field error notification shown

  @DeleteNewlyCreatedSortBeltConfig
  Scenario: View Shipments Details (uid:1f0b69c6-c270-414f-8623-836518f6be32)
    Given API Operator creates new configuration for sort belt with device id "{config-device-id}"
      | numberOfConfig | 2        |
      | destinationHub | {hub-id} |
      | shipmentType   | AIR_HAUL |
    And API Operator activates the newly created configuration with device id "{config-device-id}"
    When Operator go to menu Sort -> Sort Belt Shipments
    And Operator switches to iframe
    And Operator selects "{sort-belt-shipment-hub}" "hub" on Sort Belt Shipment Page
    And Operator selects "{sort-belt-shipment-device}" "device" on Sort Belt Shipment Page
    And Operator clicks on Create Shipment Button
    And Operator fills all the data correctly in Create Shipments Dialog on Sort Belt Shipment
      | numberOfArms      | 2 |
      | numberOfShipments | 2 |
    Then Operator verifies that the shipment is created on Sort Belt Shipment Page
    When Operator clicks on back button on Sort Belt Shipment Page
    Then Operator will be redirected to the table stats page
    When Operator selects sort belt shipment and clicks on view shipments
    Then Operator verifies the shipments details are right

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op