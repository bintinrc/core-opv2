@Sort @AddressDownload
Feature: Address Download

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder
  Scenario: Successfully Load Valid Tracking IDs (uid:a5e2eac1-f24e-4ccf-8464-65d034fd875f)
    Given Operator go to menu Addressing -> Address Download
    Given Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator clicks on Load Tracking IDs Button
    And Operator fills the "valid" Tracking ID textbox with "new_line" separation
    And Operator clicks on Next Button on Address Download Load Tracking ID modal
    Then Operator verifies that the Address Download Table Result is shown up
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file details of Address Download is right

  @ForceSuccessOrder
  Scenario: Succesfully Load Multiple Valid Tracking IDs Separated By Commas (uid:420276d9-29d3-43ab-a440-e72cb03d0ee8)
    Given Operator go to menu Addressing -> Address Download
    Given Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator clicks on Load Tracking IDs Button
    And Operator fills the "valid" Tracking ID textbox with "comma" separation
    And Operator clicks on Next Button on Address Download Load Tracking ID modal
    Then Operator verifies that the Address Download Table Result is shown up
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file details of Address Download is right

  @ForceSuccessOrder
  Scenario: Load Multiple Invalid and Valid Tracking IDs Successfully (uid:3194cdf4-7627-45fd-b10d-e8ad17e0bd66)
    Given Operator go to menu Addressing -> Address Download
    Given Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator clicks on Load Tracking IDs Button
    And Operator fills the "half" Tracking ID textbox with "new_line" separation
    And Operator clicks on Next Button on Address Download Load Tracking ID modal
    Then Operator verifies there will be error dialog shown and clicks on next button
    And Operator verifies that the Address Download Table Result is shown up
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file details of Address Download is right

  @ForceSuccessOrder
  Scenario: Succesfully Load Multiple Valid Tracking IDs Separated By Space (uid:1c7830b6-56ae-4e99-b679-5a6bfd8b68a4)
    Given Operator go to menu Addressing -> Address Download
    Given Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator clicks on Load Tracking IDs Button
    And Operator fills the "valid" Tracking ID textbox with "space" separation
    And Operator clicks on Next Button on Address Download Load Tracking ID modal
    Then Operator verifies that the Address Download Table Result is shown up
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file details of Address Download is right

  @ForceSuccessOrder
  Scenario: Succesfully Load Multiple Valid Tracking IDs Separated By New Lines (uid:fb00a761-c7e7-46c3-a51d-64514c8527f1)
    Given Operator go to menu Addressing -> Address Download
    Given Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator clicks on Load Tracking IDs Button
    And Operator fills the "valid" Tracking ID textbox with "new_line" separation
    And Operator clicks on Next Button on Address Download Load Tracking ID modal
    Then Operator verifies that the Address Download Table Result is shown up
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file details of Address Download is right

  # For specific this Scenario, ideally, please create orders with number of 2n + 1
  @ForceSuccessOrder
  Scenario: Succesfully Load Multiple Valid Tracking IDs Separated By Combination Of Commas, Space and New Line (uid:a9635341-30bb-4067-b842-464346c97246)
    Given Operator go to menu Addressing -> Address Download
    Given Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator clicks on Load Tracking IDs Button
    And Operator fills the "valid" Tracking ID textbox with "mixed" separation
    And Operator clicks on Next Button on Address Download Load Tracking ID modal
    Then Operator verifies that the Address Download Table Result is shown up
    When Operator clicks on download csv button on Address Download Page
    Then Operator verifies that the downloaded csv file details of Address Download is right

  @ForceSuccessOrder
  Scenario: Successfully Load RTS and Non RTS Tracking IDs (uid:5e838353-f1a5-4f12-9711-818207d62d48)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Parcel is damaged","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Addressing -> Address Download
    Given Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When Operator clicks on Load Tracking IDs Button
    And Operator fills the "valid" Tracking ID textbox with "new_line" separation
    And Operator clicks on Next Button on Address Download Load Tracking ID modal
    When API Operator get multiple order details by saved Order ID
    Then Operator verifies that the Address Download Table Result is shown up
    And Operator verifies that the RTS order is identified

  Scenario: Successfully Load 100 Valid Tracking IDs (uid:ff4e6e2f-0c5f-42dc-a5f4-f6d740115fd1)
    Given Operator go to menu Addressing -> Address Download
    Given Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When DB Operator searched "100" Orders with "Pending" Status and "Pending Pickup" Granular Status
    When Operator clicks on Load Tracking IDs Button
    And Operator fills the "valid" Tracking ID textbox with "new_line" separation
    And Operator clicks on Next Button on Address Download Load Tracking ID modal
    Then Operator verifies that the Address Download Table Result for bulk tracking ids is shown up

  Scenario: Entering More Than 100 Tracking IDs will be restricted (uid:bbabea60-61aa-4e43-9d43-26a741895bdf)
    Given Operator go to menu Addressing -> Address Download
    Given Operator refresh page v1
    Then Operator verifies that the page is fully loaded
    When DB Operator searched "100" Orders with "Pending" Status and "Pending Pickup" Granular Status
    When Operator clicks on Load Tracking IDs Button
    And Operator fills the "valid" Tracking ID textbox with "comma" separation
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator verifies that newly created order is not written in the textbox

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
