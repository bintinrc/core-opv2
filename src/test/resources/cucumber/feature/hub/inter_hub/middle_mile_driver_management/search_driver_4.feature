@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @SearchDriver4
Feature: Middle Mile Driver Management - Search Driver 4

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Sort Driver on Username column - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
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
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
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
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
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
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
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
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
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
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    And Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click "<sort>" in "License Status" column on Middle Mile Driver Page
    Then Make sure All data in Middle Mile Driver tables is "<result>" shown based on "License Status"

    Examples:
      | sort       | result     | hiptest-uid                              | dataset_name    |
      | Ascending  | Ascending  | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Ascending  |
      | Descending | Descending | uid:2c68bebf-d4b1-400f-8b9c-a8a40c98fd68 | Sort Descending |

  @DeleteDriver
  Scenario: Load Driver by Filter - Click back/forward button(uid:8a8df869-aa86-438d-9ad9-7e0ae0497d1b)
#    Given API Driver gets all the driver
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    And Operator verifies middle mile driver management page is loaded
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given Operator get info of hub details id "{hub-id-2}"
    And API Driver get all middle mile driver using hub filter with value "{hub-id-2}"
    And Operator selects the hub on the Middle Mile Drivers Page
    When Operator selects the "License Status" with the value of "Active" on Middle Mile Driver Page
    When Operator selects the "Employment Status" with the value of "Active" on Middle Mile Driver Page
    And Operator clicks on Load Driver Button on the Middle Mile Driver Page
    When Operator click on Browser back button
    Then Operator verifies the Employment Status is "Active" and License Status is "Active"
    When Operator click on Browser Forward button
    Then Operator verifies that list of middle mile drivers is shown
    And Operator verifies that the GUI elements are shown on the Middle Mile Driver Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op