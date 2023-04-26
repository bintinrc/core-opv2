@Sort @AddressDownloadPart3
Feature: Address Download

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Download Address by Created Time on New Preset (uid:770e4323-f6d7-46f7-a33a-c427c28f31e7)
    Given API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {addressing-shipper-v4-client-id}     |
      | shipperV4ClientSecret | {addressing-shipper-v4-client-secret} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator input the new preset name
    And Operator adds "shipper_ids" filter to selected preset
    And Operator sets new shipper to selected preset as "DEFAULT"
    And Operator adds "created_at" filter to selected preset
    And Operator save the new preset data
    Then Operator verifies that there will be success preset creation toast shown
    And Operator selects preset "CREATED"
    And DB operator gets order details
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And Operator input the created order's creation time
    And Operator clicks on Load Address button
    Then Operator verifies that the Address Download Table Result contains all basic data
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file contains all correct data
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Download Address by Created Time on Existing Preset (uid:b3ecc8dd-f228-4607-bf43-57a3df033614)
    Given API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {addressing-shipper-v4-client-id}     |
      | shipperV4ClientSecret | {addressing-shipper-v4-client-secret} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "shipper_ids" filter
    Then Operator verifies that there will be success preset creation toast shown
    When Operator selects preset "CREATED"
    When Operator clicks on the ellipses
    When Operator clicks on "edit" Preset Option on the Address Download Page
    And Operator edits selected preset
    And Operator sets new shipper to selected preset as "DEFAULT"
    And Operator adds "created_at" filter to selected preset
    And Operator save the new preset data
    And DB operator gets order details
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And Operator input the created order's creation time
    And Operator clicks on Load Address button
    Then Operator verifies that the Address Download Table Result contains all basic data
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file contains all correct data
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Download Address by Created Time and Other Filters on New Preset (uid:2b0dbbcb-748f-42ec-b034-d2a0c682a6ed)
    Given API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {addressing-shipper-v4-client-id}     |
      | shipperV4ClientSecret | {addressing-shipper-v4-client-secret} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator input the new preset name
    And Operator adds "shipper_ids" filter to selected preset
    And Operator sets new shipper to selected preset as "DEFAULT"
    And Operator adds "rts_no" filter to selected preset
    And Operator adds "created_at" filter to selected preset
    And Operator save the new preset data
    Then Operator verifies that there will be success preset creation toast shown
    And Operator selects preset "CREATED"
    And DB operator gets order details
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And Operator input the created order's creation time
    And Operator clicks on Load Address button
    Then Operator verifies that the Address Download Table Result contains all basic data
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file contains all correct data
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Download Address by Created Time and Other Filters on Existing Preset (uid:c7d551f3-33c4-4325-ab3a-230a98aa25c4)
    Given API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {addressing-shipper-v4-client-id}     |
      | shipperV4ClientSecret | {addressing-shipper-v4-client-secret} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "shipper_ids" filter
    And Operator selects preset "CREATED"
    When Operator clicks on the ellipses
    And Operator clicks on "edit" Preset Option on the Address Download Page
    And Operator edits selected preset
    And Operator sets new shipper to selected preset as "DEFAULT"
    And Operator adds "rts_no" filter to selected preset
    And Operator adds "created_at" filter to selected preset
    And Operator save the new preset data
    And DB operator gets order details
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And Operator input the created order's creation time
    And Operator clicks on Load Address button
    Then Operator verifies that the Address Download Table Result contains all basic data
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file contains all correct data
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Download Address by Created Time on Existing Preset - Update Creation Time value (uid:1b799ba2-de9a-44d4-871c-26ad8a5350e8)
    When Operator go to menu Addressing -> Address Download
    Given Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator input the new preset name
    And Operator adds "shipper_ids" filter to selected preset
    And Operator sets new shipper to selected preset as "DEFAULT"
    And Operator adds "created_at" filter to selected preset
    And Operator save the new preset data
    Then Operator verifies that there will be success preset creation toast shown
    And Operator selects preset "CREATED"
    When Operator clicks on the ellipses
    And Operator clicks on "edit" Preset Option on the Address Download Page
    And Operator edits selected preset
    And Operator sets creation time filter to selected preset as "ALL_DAY"
    And Operator save the new preset data
    Then Operator verifies that there will be success preset edit toast shown
    And Operator verifies that the creation time filter is updated
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Create New Filter Preset With Source Filter Successfully (uid:f7a5cf09-6028-49c2-9c97-b51e43710e3f)
    Given Operator go to menu Addressing -> Address Download
    And Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "source" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op