@Sort @Hubs @FacilitiesManagementPart1 @Saas
Feature: Facilities Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaDb
  Scenario: Create Hub (uid:c40d8354-a4cb-463c-a220-39f56e91eb71)
    When Operator go to menu Hubs -> Facilities Management
    And Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Then Operator verifies that success react notification displayed:
      | top | Hub Created Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}                |
      | facilityType | {KEY_CREATED_HUB.facilityTypeDisplay} |
      | region       | {KEY_CREATED_HUB.region}              |
      | displayName  | {KEY_CREATED_HUB.displayName}         |
      | city         | {KEY_CREATED_HUB.city}                |
      | country      | {KEY_CREATED_HUB.country}             |
      | latitude     | {KEY_CREATED_HUB.latitude}            |
      | longitude    | {KEY_CREATED_HUB.longitude}           |

  @DeleteHubsViaDb
  Scenario: Update Hub (uid:16ec1eac-f4f4-495a-8b71-4f8a9d846e54)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name}          |
      | name              | {KEY_CREATED_HUB.name} [E]      |
      | displayName       | {KEY_CREATED_HUB.shortName} [E] |
      | city              | GENERATED                       |
      | country           | GENERATED                       |
      | latitude          | 11                              |
      | longitude         | 12                              |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}                |
      | facilityType | {KEY_CREATED_HUB.facilityTypeDisplay} |
      | region       | {KEY_CREATED_HUB.region}              |
      | displayName  | {KEY_CREATED_HUB.displayName}         |
      | city         | {KEY_CREATED_HUB.city}                |
      | country      | {KEY_CREATED_HUB.country}             |
      | latitude     | 11                                    |
      | longitude    | 12                                    |

  @DeleteHubsViaDb
  Scenario: Search Hub (uid:449beef4-34f3-42ad-8c08-026938ae42db)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Hubs -> Facilities Management
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}                |
      | facilityType | {KEY_CREATED_HUB.facilityTypeDisplay} |
      | region       | {KEY_CREATED_HUB.region}              |
      | displayName  | {KEY_CREATED_HUB.displayName}         |
      | city         | {KEY_CREATED_HUB.city}                |
      | country      | {KEY_CREATED_HUB.country}             |
      | latitude     | {KEY_CREATED_HUB.latitude}            |
      | longitude    | {KEY_CREATED_HUB.longitude}           |

  @DeleteHubsViaDb
  Scenario: Download CSV hubs (uid:382e0a13-8725-42ae-995c-e6f524961fa7)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Hubs -> Facilities Management
    When Operator download Hub CSV file on Facilities Management page
    Then Operator verifies that success react notification displayed:
      | top    | Report is being prepared         |
      | bottom | It will be in your inbox shortly |
    And Operator verify Hub CSV file is downloaded successfully on Facilities Management page and contains correct info

  @DeleteHubsViaDb
  Scenario: Disable active hub (uid:667d6ff4-6483-490e-a4ea-0513741d00ad)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator activate created hub
    When Operator go to menu Hubs -> Facilities Management
    And Operator disable created hub on Facilities Management page
    Then Operator verifies that success react notification displayed:
      | top | Hub Disabled Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name   | {KEY_CREATED_HUB.name} |
      | status | Disabled               |

  @DeleteHubsViaDb
  Scenario: Activate disabled hub (uid:60f0c3fc-649b-4018-9952-23bd208b4374)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator disable created hub
    When Operator go to menu Hubs -> Facilities Management
    And Operator activate created hub on Facilities Management page
    Then Operator verifies that success react notification displayed:
      | top | Hub Activated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name   | {KEY_CREATED_HUB.name} |
      | status | Active                 |

  @DeleteHubsViaDb
  Scenario: Create New Station Hub (uid:8f0ca3bd-c928-4bc9-b759-5fcdfeb9ea98)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Hubs -> Facilities Management
    And Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | displayName  | GENERATED |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Then Operator verifies that success react notification displayed:
      | top | Hub Created Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | STATION                       |
      | region       | JKB                           |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | {KEY_CREATED_HUB.latitude}    |
      | longitude    | {KEY_CREATED_HUB.longitude}   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op