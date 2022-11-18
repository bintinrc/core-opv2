Feature: Station Routing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver
  Scenario: Operator Search Order to Assigned Driver on Station Routing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password1","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password1","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-routing"
    And Operator selects "{hub-name}" hub on Station Routing page
    And Operator uploads CSV file on Station Routing page:
      | trackingId                                 | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    Then Operator verifies orders info on Station Routing page:
      | trackingId                                 | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    When Operator clicks Next button on Station Routing page
    Then Operator verifies driver count is 2 on Station Routing page
    Then Operator verifies parcel count is 2 on Station Routing page
    And Operator verifies assignments records on Station Routing page:
      | trackingId                                 | address                                | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER[1].toA1A2C} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_ORDER[2].toA1A2C} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    When Operator filter assignments table on Station Routing page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator verifies assignments records on Station Routing page:
      | trackingId                                 | address                                | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER[1].toA1A2C} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
    When Operator filter assignments table on Station Routing page:
      | address | {KEY_LIST_OF_CREATED_ORDER[2].toA1A2C} |
    And Operator verifies assignments records on Station Routing page:
      | trackingId                                 | address                                | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_ORDER[2].toA1A2C} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    When Operator filter assignments table on Station Routing page:
      | driverId | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
    And Operator verifies assignments records on Station Routing page:
      | trackingId                                 | address                                | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER[1].toA1A2C} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |

  @DeleteDriver
  Scenario: Operator Shows List of Remove Order to Assigned Driver on Station Routing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password1","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password1","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-routing"
    And Operator selects "{hub-name}" hub on Station Routing page
    And Operator uploads CSV file on Station Routing page:
      | trackingId                                 | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    Then Operator verifies orders info on Station Routing page:
      | trackingId                                 | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    When Operator clicks Next button on Station Routing page
    Then Operator verifies driver count is 2 on Station Routing page
    Then Operator verifies parcel count is 2 on Station Routing page
    When Operator clicks Remove button for "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" parcel on Station Routing page
    Then Operator verifies "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" parcel marked as removed on Station Routing page
    When Operator clear filters of assignments table on Station Routing page
    When Operator selects "Removed" action on Station Routing page
    And Operator verifies assignments records on Station Routing page:
      | trackingId                                 | address                                | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_ORDER[1].toA1A2C} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |

  @DeleteDriver
  Scenario: Operator Shows List of Kept Order to Assigned Driver on Station Routing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password1","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password1","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-routing"
    And Operator selects "{hub-name}" hub on Station Routing page
    And Operator uploads CSV file on Station Routing page:
      | trackingId                                 | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    Then Operator verifies orders info on Station Routing page:
      | trackingId                                 | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    When Operator clicks Next button on Station Routing page
    Then Operator verifies driver count is 2 on Station Routing page
    Then Operator verifies parcel count is 2 on Station Routing page
    When Operator clicks Remove button for "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" parcel on Station Routing page
    Then Operator verifies "{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}" parcel marked as removed on Station Routing page
    When Operator clear filters of assignments table on Station Routing page
    When Operator selects "Kept" action on Station Routing page
    And Operator verifies assignments records on Station Routing page:
      | trackingId                                 | address                                | driverId                            |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_LIST_OF_CREATED_ORDER[2].toA1A2C} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op