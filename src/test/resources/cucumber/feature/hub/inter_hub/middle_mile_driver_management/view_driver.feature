@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @ViewDriver
Feature: Middle Mile Driver Management - View Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteMiddleMileDriver
  Scenario: View Driver (uid:23112b2d-8f62-4c9d-a354-ff51da408b8f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true} |
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    Then Operator searches by "id" with value "{KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].driverId}"
    When Operator clicks view button on the middle mile driver page
    Then Operator verifies details of driver "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]" is correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op