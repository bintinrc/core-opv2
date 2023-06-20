@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @SearchDriver4
Feature: Middle Mile Driver Management - Search Driver 4

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Sort Driver on Username column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&hubIds={hub-id}&licenseStatus=active |
      | Hub | {hub-name}                                                                 |
      | Employment Status | Active                                                                                                  |
      | License Status    | Active                                                                                                  |
    When Operator click "<sort>" in "Username" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Username"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on Hub column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&licenseStatus=active |
      | Employment Status | Active                                                                                                  |
      | License Status    | Active                                                                                                  |
    When Operator click "<sort>" in "Hub" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Hub"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on Employment Type column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&hubIds={hub-id}&licenseStatus=active |
      | Hub | {hub-name}                                                                 |
      | Employment Status | Active                                                                                                  |
      | License Status    | Active                                                                                                  |
    When Operator click "<sort>" in "Employment Type" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Employment Type"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on Employment Status column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?hubIds={hub-id}&licenseStatus=active |
      | Hub | {hub-name}                                                                 |
      | License Status    | Active                                                                                                  |
    When Operator click "<sort>" in "Employment Status" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Employment Status"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on License Type column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&hubIds={hub-id}&licenseStatus=active |
      | Hub | {hub-name}                                                                 |
      | Employment Status | Active                                                                                                  |
      | License Status    | Active                                                                                                  |
    When Operator click "<sort>" in "License Type" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "License Type"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on License Status column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&hubIds={hub-id} |
      | Hub | {hub-name}                                                                 |
      | Employment Status | Active                                                                                                  |
    When Operator click "<sort>" in "License Status" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "License Status"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  Scenario Outline: Sort Driver on Vendor's Name column - <dataset_name>
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&hubIds={hub-id}&licenseStatus=active |
      | Hub | {hub-name}                                                                 |
      | Employment Status | Active                                                                                                  |
      | License Status | Active                                                                                                  |
    When Operator click "<sort>" in "Vendor's Name" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "Vendor's Name"

    Examples:
      | sort       | result     | dataset_name    |
      | Ascending  | Ascending  | Sort Ascending  |
      | Descending | Descending | Sort Descending |

  @DeleteMiddleMileDriver
  Scenario: Load Driver by Filter - Click back/forward button(uid:8a8df869-aa86-438d-9ad9-7e0ae0497d1b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contact":{"active":true,"details":"{default-phone}","type":"Mobile Phone"},"contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"{default-driver-vendor-type}","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Generated by Common-MM","availability":true,"vendor_id":{default-driver-vendor-id}} |
    Then Operator verifies UI elements in Middle Mile Driver Page with data below
      | url               | https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers?employmentStatus=active&licenseStatus=active |
      | Employment Status | Active                                                                                                  |
      | License Status    | Active                                                                                                  |
    When Operator click on Browser back button
    Then Operator verifies the Employment Status is "Active" and License Status is "Active"
    When Operator click on Browser Forward button
    Then Operator verifies driver "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]" is shown in Middle Mile Driver page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op