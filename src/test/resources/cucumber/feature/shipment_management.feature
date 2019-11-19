@OperatorV2 @OperatorV2Part2 @ShipmentManagement @Shipment
Feature: Shipment Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Create Shipment (uid:7a3373f0-67f1-4f1a-b6b2-6447a2621305)
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Create Shipment with New Flow - With Create Another (uid:fe26bb22-0fef-4036-b3fe-a4975ca058e8)
    Given Operator go to menu Inter-Hub -> Shipment Management
    Given Operator intends to create a new Shipment directly from the Shipment Toast
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created multiple shipment on Shipment Management page

  @DeleteShipment
  Scenario: Edit Shipment (uid:5fbdb7d5-0a54-42de-bd8e-960ad26ff43e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page using data below:
      | destHubName | {hub-name-2}                                                         |
      | origHubName | {hub-name}                                                           |
      | comments    | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Then Operator verify parameters of the created shipment on Shipment Management page

  @DeleteShipment
  Scenario: Open Shipment Details (uid:d4072972-d4f1-446f-aaed-62a5c43ab03d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Given API Operator put created parcel to shipment
    When Operator click "Load All Selection" on Shipment Management page
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment

  @DeleteShipment
  Scenario: Force Success Shipment (uid:9e106cef-fac4-4283-9b40-634c50ad9413)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator force success the created shipment on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Completed |

  @DeleteShipment
  Scenario: Print Master AWB (uid:6edf77ea-9bd7-49f5-a9e5-d520fd5d1a73)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Given API Operator put created parcel to shipment
    When Operator click "Load All Selection" on Shipment Management page
    And Operator open the Master AWB of the created shipment on Shipment Management Page
    Then Operator verify the the master AWB is opened
    Given API Operator download the Shipment AWB PDF
    Then Operator verify that the data consist is correct

  @DeleteShipment
  Scenario: Cancel Shipment (uid:9618d764-8b09-49a3-9cec-07e7d726faee)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    And Operator click "Load All Selection" on Shipment Management page
    And Operator cancel the created shipment on Shipment Management page
    Then Operator verify the following parameters of the created shipment on Shipment Management page:
      | status | Cancelled |

  @DeleteShipment
  Scenario Outline: Shipment Searching by Filters - <scenarioName> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    When Operator filter <filterName> = <filterValue> on Shipment Management page
    And Operator click "Load All Selection" on Shipment Management page
    Then Operator verify parameters of the created shipment on Shipment Management page
    Examples:
      | Note                                            | scenarioName                                     | hiptest-uid                              | filterName      | filterValue  |
      | Searching Shipment by Start Hub                 | Searching Shipment by Start Hub                  | uid:54a19c29-6f50-41b6-a248-2565513bf3d4 | Start Hub       | {hub-name}   |
      | Searching Shipment by End Hub                   | Searching Shipment by End Hub                    | uid:359d17e1-60e8-45cd-a7d4-5380c2814cfe | End Hub         | {hub-name-2} |
      | Searching Shipment by Shipment Type             | Searching Shipment by Shipment Type              | uid:7e524790-c0f5-4f99-a36b-51a0a6428013 | Shipment Type   | Air Haul     |
      | Searching Shipment by Shipment Status - PENDING | Searching Shipment by Shipment Status - PENDING  | uid:48d0c501-d985-469d-bf08-77da6b623b05 | Shipment Status | Pending      |

  @DeleteFilersPreset
  Scenario: Save Shipment filters as preset (uid:1c96e7a3-8636-4ece-ad4f-722baaa6d4ea)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Pending on Shipment Management page
    And Operator filter Start Hub = {hub-name} on Shipment Management page
    And Operator filter End Hub = {hub-name-2} on Shipment Management page
    And Operator filter Shipment Type = Air Haul on Shipment Management page
    And Operator save current filters as preset on Shipment Management page
    And Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Inter-Hub -> Shipment Management
    Then Operator select created filters preset on Shipment Management page
    And Operator verify parameters of selected filters preset on Shipment Management page

  @DeleteFilersPreset
  Scenario: Delete Shipment filters as preset (uid:e4cc014b-ce6a-47d3-bd00-a1b27fd5a60f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Pending on Shipment Management page
    And Operator save current filters as preset on Shipment Management page
    And Operator delete created filters preset on Shipment Management page
    And Operator refresh page
    Then Operator verify filters preset was deleted

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
