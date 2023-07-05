@OperatorV2 @MiddleMile @Hub @InterHub @MovementTrip @AssignDriver
Feature: Movement Trip - Assign Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Assign Single Driver to Movement Trips (uid:4cf35840-44dd-4573-bdb1-a51ac7f58984)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    And Operator sets movement trips filter with data below:
      | tab       | Departure                          |
      | originHub | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    And Operator clicks on "assign_driver" icon on the action column
    And Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" to created movement trip
    Then Operator verifies toast with message "1 driver(s) successfully assigned to the trip" is shown on movement page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Assign Multiple Drivers to Movement Trips (uid:86a95c5c-3388-4d14-b86c-ecd555e3bd1a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    And Operator sets movement trips filter with data below:
      | tab       | Departure                          |
      | originHub | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    And Operator clicks on "assign_driver" icon on the action column
    And Operator assign following drivers to created movement trip:
      | primaryDriver    | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} |
      | additionalDriver | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username} |
    Then Operator verifies toast with message "2 driver(s) successfully assigned to the trip" is shown on movement page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Assign Single Driver to Movement Schedules (uid:81f0d3b3-b58d-47a8-8905-c2ed2d4b9bac)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destinationHub | {hub-relation-destination-hub-name} |
    And Operator clicks on assign_driver icon on the action column in movement schedule page
    And Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" to created movement schedule
    Then Operator verifies toast with message "1 driver(s) successfully assigned to the schedule" is shown on movement page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Assign Multiple Drivers to Movement Schedules (uid:885d2bf7-d835-4229-b941-2758fa385163)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destinationHub | {hub-relation-destination-hub-name} |
    And Operator clicks on assign_driver icon on the action column in movement schedule page
    And Operator assign following drivers to created movement trip:
      | primaryDriver    | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} |
      | additionalDriver | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username} |
    Then Operator verifies toast with message "2 driver(s) successfully assigned to the schedule" is shown on movement page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Re-assign Single Driver to Movement Trips (uid:ad5ca7e3-786a-46c9-93df-9df5688a13aa)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    And Operator sets movement trips filter with data below:
      | tab       | Departure                          |
      | originHub | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    And Operator clicks on "assign_driver" icon on the action column
    And Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" to created movement trip
    Then Operator verifies toast with message "1 driver(s) successfully assigned to the trip" is shown on movement page
    And Operator clicks on "assign_driver" icon on the action column
    And Operator clear all assigned driver in created movement
    Then Operator verifies toast with message "0 driver(s) successfully assigned to the trip" is shown on movement page
    And Operator clicks on "assign_driver" icon on the action column
    And Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" to created movement trip
    Then Operator verifies toast with message "1 driver(s) successfully assigned to the trip" is shown on movement page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Re-assign Multiple Drivers to Movement Trips (uid:75e4b643-7e89-4eec-9fd4-078b46be01d4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    And Operator sets movement trips filter with data below:
      | tab       | Departure                          |
      | originHub | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    And Operator clicks on "assign_driver" icon on the action column
    And Operator assign following drivers to created movement trip:
      | primaryDriver    | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} |
      | additionalDriver | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username} |
    Then Operator verifies toast with message "2 driver(s) successfully assigned to the trip" is shown on movement page
    And Operator clicks on "assign_driver" icon on the action column
    And Operator clear all assigned driver in created movement
    Then Operator verifies toast with message "0 driver(s) successfully assigned to the trip" is shown on movement page
    And Operator clicks on "assign_driver" icon on the action column
    And Operator assign following drivers to created movement trip:
      | primaryDriver    | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} |
      | additionalDriver | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username} |
    Then Operator verifies toast with message "2 driver(s) successfully assigned to the trip" is shown on movement page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Re-assign Single Driver to Movement Schedules (uid:07835418-c030-4c5d-9402-cc2f2c739df3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destinationHub | {hub-relation-destination-hub-name} |
    And Operator clicks on assign_driver icon on the action column in movement schedule page
    And Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" to created movement schedule
    Then Operator verifies toast with message "1 driver(s) successfully assigned to the schedule" is shown on movement page
    And Operator clicks on assign_driver icon on the action column in movement schedule page
    And Operator clear all assigned driver in created movement
    Then Operator verifies toast with message "0 driver(s) successfully assigned to the schedule" is shown on movement page
    And Operator clicks on assign_driver icon on the action column in movement schedule page
    And Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" to created movement schedule
    Then Operator verifies toast with message "1 driver(s) successfully assigned to the schedule" is shown on movement page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Re-assign Multiple Drivers to Movement Schedules (uid:bc5b0feb-ddfd-4914-bb99-cf4d484b8627)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator refresh page
    And Movement Management page is loaded
    And Operator load schedules on Movement Management page with retry using data below:
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}  |
      | destinationHub | {hub-relation-destination-hub-name} |
    And Operator clicks on assign_driver icon on the action column in movement schedule page
    And Operator assign following drivers to created movement trip:
      | primaryDriver    | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} |
      | additionalDriver | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username} |
    Then Operator verifies toast with message "2 driver(s) successfully assigned to the schedule" is shown on movement page
    And Operator clicks on assign_driver icon on the action column in movement schedule page
    And Operator clear all assigned driver in created movement
    Then Operator verifies toast with message "0 driver(s) successfully assigned to the schedule" is shown on movement page
    And Operator clicks on assign_driver icon on the action column in movement schedule page
    And Operator assign following drivers to created movement trip:
      | primaryDriver    | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} |
      | additionalDriver | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username} |
    Then Operator verifies toast with message "2 driver(s) successfully assigned to the schedule" is shown on movement page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Assign Single Driver via Trip Details (uid:62aff257-4369-483e-8c1b-f5227fca880b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    And Operator sets movement trips filter with data below:
      | tab       | Departure                          |
      | originHub | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened
    And Operator click on Assign Driver button on Department page
    And Operator assign driver "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username}" to created movement trip
    Then Operator verifies toast with message "1 driver(s) successfully assigned to the trip" is shown on movement page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Assign Multiple Drivers via Trip Details (uid:8905af42-5177-46a7-8c0b-a01e7510574b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    And Operator sets movement trips filter with data below:
      | tab       | Departure                          |
      | originHub | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened
    And Operator click on Assign Driver button on Department page
    And Operator assign following drivers to created movement trip:
      | primaryDriver    | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} |
      | additionalDriver | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username} |
    Then Operator verifies toast with message "2 driver(s) successfully assigned to the trip" is shown on movement page

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Unassign Multiple Drivers via Trip Details (uid:768c441b-1cb3-468c-a7f5-002e6c4b2ece)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    And Operator sets movement trips filter with data below:
      | tab       | Departure                          |
      | originHub | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened
    And Operator click on Assign Driver button on Department page
    And Operator assign following drivers to created movement trip:
      | primaryDriver    | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} |
      | additionalDriver | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username} |
    Then Operator verifies toast with message "2 driver(s) successfully assigned to the trip" is shown on movement page
    And Operator click on Assign Driver button on Department page
    And Operator click on Unassign All driver button on Assign Driver page
    Then Operator verifies toast with message "0 driver(s) successfully assigned to the trip" is shown on movement page

# need to fix this scenario to cater for common v2
  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Cannot Assign Driver via Trip Details (uid:c4f15381-7b15-469a-80ec-27aae044ca87)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 2 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
      | drivers  | KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1] |
#    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_SORT_LIST_OF_CREATED_HUBS[2].id}"
#    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API MM - Operator "depart" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
    And API MM - Operator "arrive" movement trip "KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1]"
#    And API Operator depart trip with data below:
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#    And API Operator arrival trip with data below:
#      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
#      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
#    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}"
    And DB Hub - Shift Movement Trip with Id "{KEY_MM_LIST_OF_CREATED_MOVEMENT_TRIPS[1].id}" Expected Start Time to -24 Hours Relative to Now
#    And DB Operator change first trip to yesterday date
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    And Operator sets movement trips filter with data below:
      | tab            | Archive                            |
      | originHub      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_SORT_LIST_OF_CREATED_HUBS[2].name} |
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    And API MM - Operator searches Movement Trips with movement type with data below:
      | action       | depart                                   |
      | movementType | LAND_HAUL                                |
      | from         | {date: 0 days next, yyyy-MM-dd} 00:00:00 |
      | to           | {date: 0 days next, yyyy-MM-dd} 23:59:59 |
      | hubId        | {KEY_SORT_LIST_OF_CREATED_HUBS[1].id}    |
    Then Operator verifies trips shown on "departure" tab of Movement Trip page are the same as "KEY_MM_LIST_OF_SEARCHED_MOVEMENT_TRIPS"
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened
    And Pencil icon button on Assign driver is not visible

  @DeleteCreatedHubs @DeleteMiddleMileDriver
  Scenario: Unassign Multiple Drivers via Movement Trips (uid:3d8fff3b-f453-4670-8f3c-adb513984f3f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator creates 1 new generated "CROSSDOCK" hubs
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 seconds next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    When API MM - Create "LAND_HAUL" Movement Schedule from "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" to "{hub-relation-destination-hub-id}" with data below:
      | startTime | {date: 10 minutes next, yyyy-MM-dd HH:mm:ss} |
      | duration | 00:00:10 |
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    And Operator sets movement trips filter with data below:
      | tab       | Departure                          |
      | originHub | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    And Operator clicks on "assign_driver" icon on the action column
    And Operator verify Items display on Assign Driver Page
    And Operator assign following drivers to created movement trip:
      | primaryDriver    | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} |
      | additionalDriver | {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[2].username} |
    Then Operator verifies toast with message "2 driver(s) successfully assigned to the trip" is shown on movement page
    And Operator clicks on "assign_driver" icon on the action column
    And Operator click on Unassign All driver button on Assign Driver page
    Then Operator verifies toast with message "0 driver(s) successfully assigned to the trip" is shown on movement page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op