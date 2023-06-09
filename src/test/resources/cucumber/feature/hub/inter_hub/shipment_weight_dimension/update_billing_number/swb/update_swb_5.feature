@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @UpdateSWB5
Feature: Update SWB 5 - MY

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format K14B + 7 digits uppercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format K14B + 7 digits mixcase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-MIX-RANDOM                |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format K14B + 7 digits lowercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-LOWER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format K14B + 8 digits uppercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-UPPER-8-RANDOM            |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format K14B + 8 digits mixcase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-MIX-8-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format K14B + 8 digits lowercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-LOWER-8-RANDOM            |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format R11B + 7 digits uppercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format R11B + 7 digits mixcase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-MIX-RANDOM                |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format R11B + 7 digits lowercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K14B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-LOWER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format R11B + 8 digits uppercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-8-RANDOM            |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format R11B + 8 digits mixcase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-MIX-8-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format R11B + 8 digits lowercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-LOWER-8-RANDOM            |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format K28B + 8 digits uppercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K28B-UPPER-8-RANDOM            |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format K28B + 8 digits mixcase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K28B-MIX-8-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @DeleteCreatedShipments @DeleteCreatedSWBs
  Scenario: Update SWB for MY with format K28B + 8 digits lowercase
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator change the country to "Malaysia"
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id-my-1}" to "{hub-id-my-2}"
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
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | R11B-UPPER-RANDOM              |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"
    When Operator filter Shipment Weight Dimension Table by "billing_number" column with shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" - migrated
      | expectedNumOfRows | 2 |
    And Operator select all data on Shipment Weight Dimension Table
    When Operator click Update Billing Number "SWB" on Shipment Weight Dimension page
    Then Operator verify Shipment Weight Update Billing Number "SWB" page UI
    When Operator update billing number "SWB" information on Shipment Weight Dimension page with following data:
      | swb                | K28B-LOWER-8-RANDOM            |
      | seahaulVendor      | {local-seahaul-vendor-name-my} |
      | originSeahaul      | {local-seaport-1-code-my}      |
      | destinationSeahaul | {local-seaport-2-code-my}      |
    Then Operator click update button on shipment weight update mawb page
    And Operator verify Update Billing Number "SWB" has updated with new value "{KEY_MM_SHIPMENT_SWB}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op