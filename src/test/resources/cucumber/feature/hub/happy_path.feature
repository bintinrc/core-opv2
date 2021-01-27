@OperatorV2 @MiddleMile @Hub @HappyPath
Feature: Happy Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Create Shipment with Create Another Shipment (uid:3e44bd1b-5bbf-4eb3-b51c-300c21005f86)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given Operator intends to create a new Shipment directly from the Shipment Toast
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created multiple shipment on Shipment Management page

  @DeleteShipment
  Scenario: Create Shipment without Create Another Shipment (uid:20aadc4d-b1f8-4adf-9c45-6eb0b636c5bb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  Scenario: Edit Shipment - Start Hub (uid:e171e86e-2295-4016-b257-a7645768bfc1)
    Given no-op

  Scenario: Edit Shipment - End Hub (uid:0714fd17-4ddc-4a0e-ada6-b1ff199ce12a)
    Given no-op

  Scenario: Edit Shipment with Edit MAWB (uid:82c9ee5a-4f7e-41f8-b4f5-88ccb5193c5a)
    Given no-op

  Scenario: Upload Bulk Orders to Shipment with Valid Tracking ID Data (uid:bbe26bb4-8a11-49e0-9c01-f39008b27399)
    Given no-op

  Scenario: Upload Bulk Orders to Shipment with Duplicate Tracking ID Data (uid:844fed49-f618-4443-a85e-66dff1fec3c8)
    Given no-op

  Scenario: Upload Bulk Orders to Shipment with Invalid Tracking ID Data (uid:0d5917c8-528e-47da-9210-3317d4b549a8)
    Given no-op

  Scenario: Bulk Update Shipment - Update MAWB (uid:b96ac0f0-05e8-42a3-91de-c4df2a16b616)
    Given no-op

  Scenario: Bulk Update Shipment - Update Multiple Fields (uid:d8fae297-b77a-4c4f-b104-e0a8dea17a12)
    Given no-op

  Scenario: Cancel Shipment with Pending Status (uid:4281e860-d180-4f26-9435-7e2588fd82c2)
    Given no-op

  Scenario: Cancel Shipment with Completed Status (uid:141dbb2c-9a73-46a2-9c0d-8fbfb7bc5e59)
    Given no-op

  Scenario: Re-open Single Shipment (uid:7b08a458-bde7-4ee2-946c-c4fb7323c6db)
    Given no-op

  Scenario: Re-open Multiple Shipments (uid:186571a8-ec55-461e-ba77-4ed9e2892658)
    Given no-op

  Scenario: Force Success Shipment by Action Button (uid:01f3b1fc-b9ce-46c7-92d5-044d5e71a5bf)
    Given no-op

  Scenario: Search Shipment by Filter - MAWB (uid:e0db5d50-ebcc-4e0e-9179-550e49c45e54)
    Given no-op

  Scenario: Search Shipment by Filter - End Hub (uid:21fbac4f-372b-427e-be82-c49c1be439ae)
    Given no-op

  Scenario: Search Shipment by Filter - Shipment Status (uid:2b6e7569-727c-47b2-a32e-907e848179f7)
    Given no-op

  Scenario: Search Shipment by Filter - Start Hub (uid:9d91500a-c139-402a-a13a-f9e449041e80)
    Given no-op

  Scenario: Search Shipment by ID - Search <= 30 Shipments without Duplicate (uid:fbdf60e9-a047-4e54-b78b-da1c23f55efd)
    Given no-op

  Scenario: Search Shipment by ID - Search > 30 Shipments without Duplicate (uid:d7913466-1c85-466d-baf5-1fe260bb1653)
    Given no-op

  Scenario: Shipment Details (uid:e18b2c67-8dc0-4627-99f0-2845e2f39c0b)
    Given no-op

  Scenario: Print Single Shipment Label (uid:cec6d445-2a88-479c-b9be-452445066dad)
    Given no-op

  Scenario: Print Multiple Shipments Label (uid:875141f3-3ba3-48d9-833c-6050ebfcb3db)
    Given no-op

  Scenario: Add Parcel to Shipment (uid:ec01c5c8-9088-4da5-ae29-436e75637568)
    Given no-op

  Scenario: Add Multiple Parcels to Shipment (uid:44bfcc1b-35e8-460b-ac98-f43af0cff49c)
    Given no-op

  Scenario: Add Parcel with Tag to Shipment (uid:0a2f74ee-4810-493d-bd72-fc951a709943)
    Given no-op

  Scenario: Add On Hold with Missing Type to Shipment (uid:81fd47a8-9dd1-4851-861e-4ce58a141ff4)
    Given no-op

  Scenario: Remove Parcel In Shipment from Action Toggle (uid:10201e78-b282-4eee-a1fb-f32e6c31f9e5)
    Given no-op

  Scenario: Remove Parcel In Shipment from Remove Field (uid:bcea2152-bbb9-4963-b418-8949ea22f2a4)
    Given no-op

  Scenario: Close Shipment (uid:c543c8e9-cd7d-434f-9670-49f2e2462c57)
    Given no-op

  Scenario: Load All Drivers (uid:fa3e21f0-971c-4462-bbd9-f41afab8b7ce)
    Given no-op

  Scenario: Load Driver by Filter - Hub (uid:4ac4ea89-688a-4d62-9192-6f59dc8d292c)
    Given no-op

  Scenario: Search Driver on Search Field ID (uid:6a4af29f-1e7c-41ed-a1f6-8257ef10a5fd)
    Given no-op

  Scenario: Search Driver on Search Field Username (uid:04aa3299-829d-417c-8496-848a8720d89a)
    Given no-op

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
