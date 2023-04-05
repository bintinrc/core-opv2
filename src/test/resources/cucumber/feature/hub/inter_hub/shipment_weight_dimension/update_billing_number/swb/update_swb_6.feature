@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateSWB6
Feature: Update SWB 6 - PH

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for PH with format 5 Digits number
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = "{hub-id-ph-2}" to hub id = "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | RANDOM-5-DIGITS                |
      | seahaulVendor      | {local-seahaul-vendor-name-ph} |
      | originSeahaul      | {local-seaport-1-code-ph}      |
      | destinationSeahaul | {local-seaport-2-code-ph}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | RANDOM-5-DIGITS                |
      | seahaulVendor      | {local-seahaul-vendor-name-ph} |
      | originSeahaul      | {local-seaport-1-code-ph}      |
      | destinationSeahaul | {local-seaport-2-code-ph}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for PH with format 6 Digits number
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = "{hub-id-ph-2}" to hub id = "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | RANDOM                         |
      | seahaulVendor      | {local-seahaul-vendor-name-ph} |
      | originSeahaul      | {local-seaport-1-code-ph}      |
      | destinationSeahaul | {local-seaport-2-code-ph}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | RANDOM                         |
      | seahaulVendor      | {local-seahaul-vendor-name-ph} |
      | originSeahaul      | {local-seaport-1-code-ph}      |
      | destinationSeahaul | {local-seaport-2-code-ph}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for PH with format KMMT + 3 Digits uppercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = "{hub-id-ph-2}" to hub id = "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | RANDOM                         |
      | seahaulVendor      | {local-seahaul-vendor-name-ph} |
      | originSeahaul      | {local-seaport-1-code-ph}      |
      | destinationSeahaul | {local-seaport-2-code-ph}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | KMMT-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-ph} |
      | originSeahaul      | {local-seaport-1-code-ph}      |
      | destinationSeahaul | {local-seaport-2-code-ph}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for PH with format KMMT + 3 Digits mixcase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = "{hub-id-ph-2}" to hub id = "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | RANDOM                         |
      | seahaulVendor      | {local-seahaul-vendor-name-ph} |
      | originSeahaul      | {local-seaport-1-code-ph}      |
      | destinationSeahaul | {local-seaport-2-code-ph}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | KMMT-MIX-RANDOM                |
      | seahaulVendor      | {local-seahaul-vendor-name-ph} |
      | originSeahaul      | {local-seaport-1-code-ph}      |
      | destinationSeahaul | {local-seaport-2-code-ph}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for PH with format KMMT + 3 Digits lowercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Philippines"
    Given API MM - Operator create multiple 2 new shipment with type "AIR_HAUL" from hub id = "{hub-id-ph-2}" to hub id = "{hub-id-ph-3}"
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state | initial |
    When Operator search "MULTIPLE" on Shipment Weight Dimension search by SID text
    Then Operator verify Shipment Weight Dimension Load Shipment page UI
      | state             | search_valid |
      | numberOfShipments | 2            |
    When Operator click search button on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Dimension Table page is shown
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | RANDOM                         |
      | seahaulVendor      | {local-seahaul-vendor-name-ph} |
      | originSeahaul      | {local-seaport-1-code-ph}      |
      | destinationSeahaul | {local-seaport-2-code-ph}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with first shipment value
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | KMMT-LOWER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-ph} |
      | originSeahaul      | {local-seaport-1-code-ph}      |
      | destinationSeahaul | {local-seaport-2-code-ph}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op