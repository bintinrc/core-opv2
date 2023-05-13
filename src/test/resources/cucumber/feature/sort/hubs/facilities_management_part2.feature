@Sort @Hubs @FacilitiesManagementPart2 @Saas
Feature: Facilities Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaDb
  Scenario: Update Hub Type to Station (uid:4aae1605-d328-4259-9fda-e0b742e9910d)
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
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | facilityType      | Station                |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | STATION                       |
      | region       | JKB                           |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | {KEY_CREATED_HUB.latitude}    |
      | longitude    | {KEY_CREATED_HUB.longitude}   |

  @DeleteHubsViaDb
  Scenario: Create New Hub-Crossdock Not As Sort Hub (uid:9fbaa3fa-8415-456e-acf1-f68dd496ed26)
    Given Operator go to menu Utilities -> QRCode Printing
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
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | Hub - Crossdock               |
      | region       | JKB                           |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | {KEY_CREATED_HUB.latitude}    |
      | longitude    | {KEY_CREATED_HUB.longitude}   |
      | sortHub      | false                         |
    And DB Operator verify a new hub is created in sort.hubs using data below:
      | hubName      | {KEY_CREATED_HUB.name} |
      | facilityType | CROSSDOCK              |
      | sortHub      | false                  |

  @DeleteHubsViaDb
  Scenario: Create New Hub-Crossdock As Sort Hub (uid:a2a0ab06-4a7a-42c1-8aed-eb29bf9c9f40)
    Given Operator go to menu Utilities -> QRCode Printing
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
      | sortHub      | YES       |
    Then Operator verifies that success react notification displayed:
      | top | Hub Created Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | Hub - Crossdock               |
      | region       | JKB                           |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | {KEY_CREATED_HUB.latitude}    |
      | longitude    | {KEY_CREATED_HUB.longitude}   |
      | sortHub      | true                          |
    And DB Operator verify a new hub is created in sort.hubs using data below:
      | hubName      | {KEY_CREATED_HUB.name} |
      | facilityType | CROSSDOCK              |
      | sortHub      | true                   |

  @DeleteHubsViaDb
  Scenario: Create New Station - Crossdock Hub (uid:ad68e27f-dca5-425b-8c7b-5a0e2a751981)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Hubs -> Facilities Management
    And Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED         |
      | displayName  | GENERATED         |
      | facilityType | CROSSDOCK_STATION |
      | region       | JKB               |
      | city         | GENERATED         |
      | country      | GENERATED         |
      | latitude     | GENERATED         |
      | longitude    | GENERATED         |
    Then Operator verifies that success react notification displayed:
      | top | Hub Created Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | Station - Crossdock           |
      | region       | JKB                           |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | {KEY_CREATED_HUB.latitude}    |
      | longitude    | {KEY_CREATED_HUB.longitude}   |
      | sortHub      | false                         |
    And DB Operator verify a new hub is created in sort.hubs using data below:
      | hubName      | {KEY_CREATED_HUB.name} |
      | facilityType | CROSSDOCK_STATION      |
      | sortHub      | false                  |

  @DeleteHubsViaDb
  Scenario: Update to Hub-Crossdock but Not As Sort Hub (uid:1e8d997d-5cd9-4ec1-ac3d-1cd3fcdf7bdc)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED         |
      | displayName  | GENERATED         |
      | facilityType | CROSSDOCK_STATION |
      | region       | JKB               |
      | city         | GENERATED         |
      | country      | GENERATED         |
      | latitude     | GENERATED         |
      | longitude    | GENERATED         |
    And API Operator reloads hubs cache
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name}          |
      | name              | {KEY_CREATED_HUB.name} [E]      |
      | displayName       | {KEY_CREATED_HUB.shortName} [E] |
      | facilityType      | CROSSDOCK                       |
      | city              | GENERATED                       |
      | country           | GENERATED                       |
      | latitude          | 11                              |
      | longitude         | 12                              |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | Hub - Crossdock               |
      | region       | JKB                           |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | 11                            |
      | longitude    | 12                            |
      | sortHub      | false                         |
    And DB Operator verify a new hub is created in sort.hubs using data below:
      | hubName      | {KEY_CREATED_HUB.name} |
      | facilityType | CROSSDOCK              |
      | sortHub      | false                  |

  @DeleteHubsViaDb
  Scenario: Update to Hub-Crossdock As Sort Hub (uid:4795b7a6-2311-43de-9290-b1d41e31cdb7)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED         |
      | displayName  | GENERATED         |
      | facilityType | CROSSDOCK_STATION |
      | region       | JKB               |
      | city         | GENERATED         |
      | country      | GENERATED         |
      | latitude     | GENERATED         |
      | longitude    | GENERATED         |
    And API Operator reloads hubs cache
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name}          |
      | name              | {KEY_CREATED_HUB.name} [E]      |
      | displayName       | {KEY_CREATED_HUB.shortName} [E] |
      | facilityType      | CROSSDOCK                       |
      | sortHub           | YES                             |
      | city              | GENERATED                       |
      | country           | GENERATED                       |
      | latitude          | 11                              |
      | longitude         | 12                              |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | Hub - Crossdock               |
      | region       | JKB                           |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | 11                            |
      | longitude    | 12                            |
      | sortHub      | true                          |
    And DB Operator verify a new hub is created in sort.hubs using data below:
      | hubName      | {KEY_CREATED_HUB.name} |
      | facilityType | CROSSDOCK              |
      | sortHub      | true                   |

  @DeleteHubsViaDb
  Scenario: Update to Station-Crossdock Hub (uid:155b7bc7-d031-4bdf-b0f5-2812f1a5737d)
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
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name}          |
      | name              | {KEY_CREATED_HUB.name} [E]      |
      | displayName       | {KEY_CREATED_HUB.shortName} [E] |
      | facilityType      | CROSSDOCK_STATION               |
      | city              | GENERATED                       |
      | country           | GENERATED                       |
      | latitude          | 11                              |
      | longitude         | 12                              |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | Station - Crossdock           |
      | region       | JKB                           |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | 11                            |
      | longitude    | 12                            |
      | sortHub      | false                         |
    And DB Operator verify a new hub is created in sort.hubs using data below:
      | hubName      | {KEY_CREATED_HUB.name} |
      | facilityType | CROSSDOCK_STATION      |
      | sortHub      | false                  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op