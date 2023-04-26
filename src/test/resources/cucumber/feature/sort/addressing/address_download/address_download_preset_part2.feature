@Sort @AddressDownloadPart2
Feature: Address Download

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create New Filter Preset With RTS Filter Successfully - RTS No (uid:2d0c6714-6451-4d5e-b92b-33b03489742e)
    Given Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "rts_no" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Create New Filter Preset With RTS Filter Successfully - RTS Yes (uid:3cafa693-247b-49c5-91dc-b3b0e25f3664)
    Given Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "rts_yes" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Search Filter Preset (uid:b00356ed-c52a-4279-9850-00a4c779c0da)
    Given Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "address_status_verified" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Update Filter Successfully (uid:e6828599-7d51-4702-9994-488275d2047f)
    Given Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "address_status_verified" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator clicks on the ellipses
    And Operator clicks on "edit" Preset Option on the Address Download Page
    And Operator edits the created preset
    Then Operator verifies that there will be success preset edit toast shown
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Delete Filter Successfully (uid:12a4de1c-9954-4d13-afcf-194405309dd8)
    Given Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "address_status_verified" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Load Addresses (uid:1d7f5dab-36aa-48a0-861b-22213dc1b491)
    Given API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {addressing-shipper-v4-client-id}     |
      | shipperV4ClientSecret | {addressing-shipper-v4-client-secret} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    And Operator verifies that the page is fully loaded
    When Operator selects preset "DEFAULT"
    And DB operator gets order details
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And Operator input the created order's creation time
    And Operator clicks on Load Address button
    Then Operator verifies that the Address Download Table Result contains all basic data
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file contains all correct data

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op