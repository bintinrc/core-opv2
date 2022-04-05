@OperatorV2 @MiddleMile @Hub @FacilitiesManagement
Feature: Facilities Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario Outline: Disable Hub - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Hub with type "<type>" using data below:
      | name        | GENERATED |
      | displayName | GENERATED |
      | city        | GENERATED |
      | country     | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator reloads hubs cache
    Given Operator go to menu Hubs -> Facilities Management
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}                |
      | facilityType | {KEY_CREATED_HUB.facilityTypeDisplay} |
      | status       | Active                                |
    And Operator disable created hub on Facilities Management page
    Then Operator verifies that success react notification displayed:
      | top | Hub Disabled Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}                |
      | facilityType | {KEY_CREATED_HUB.facilityTypeDisplay} |
      | status       | Disabled                              |
    Examples:
      | type              | hiptest-uid                              | dataset_name      |
      | STATION           | uid:6f350889-3076-4293-992a-7b0443dac7d8 | Station           |
      | CROSSDOCK_STATION | uid:4d9e12db-b529-4b93-b7fc-776ac32bc7dc | Station Crossdock |
      | CROSSDOCK         | uid:846081f6-4fa4-4ecc-b3a4-2a2ee1e2b68e | Hub Crossdock     |

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario Outline: Disable Hub - DP/Recovery/Others - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Hub with type "<type>" using data below:
      | name        | GENERATED |
      | displayName | GENERATED |
      | city        | GENERATED |
      | country     | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator reloads hubs cache
    Given Operator go to menu Hubs -> Facilities Management
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}                |
      | facilityType | {KEY_CREATED_HUB.facilityTypeDisplay} |
      | status       | Active                                |
    And Operator disable created hub on Facilities Management page
    Then Operator verifies that success react notification displayed:
      | top | Hub Disabled Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}                |
      | facilityType | {KEY_CREATED_HUB.facilityTypeDisplay} |
      | status       | Disabled                              |
    Examples:
      | type     | hiptest-uid                              | dataset_name |
      | DP       | uid:39bef1c8-a345-4b6a-8be6-eca897b6e78c | DP           |
      | RECOVERY | uid:578bf271-1547-407f-8abb-00e42525e4c2 | Recovery     |
      | OTHERS   | uid:2de00e90-0f48-4617-90d5-355eb3e1045a | Others       |

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario Outline: Update Facility Type - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | <type>    |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | facilityType      | DP                     |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    And Operator refresh hubs cache on Facilities Management page
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | DP                            |
      | region       | {KEY_CREATED_HUB.region}      |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | {KEY_CREATED_HUB.latitude}    |
      | longitude    | {KEY_CREATED_HUB.longitude}   |
    Examples:
      | type              | hiptest-uid                              | dataset_name      |
      | STATION           | uid:2a62c480-b20c-40c4-b89e-3a9118b8878a | Station           |
      | CROSSDOCK         | uid:58bba508-9557-46b3-b863-10c6c9445961 | Hub Crossdock     |
      | CROSSDOCK_STATION | uid:580558a4-ea3d-4813-8770-36fc9c5c3a97 | Station Crossdock |

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario Outline: Update Facility Type - DP/Recovery/Others - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | <type>    |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | facilityType      | STATION                |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    And Operator refresh hubs cache on Facilities Management page
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | Station                       |
      | region       | {KEY_CREATED_HUB.region}      |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | {KEY_CREATED_HUB.latitude}    |
      | longitude    | {KEY_CREATED_HUB.longitude}   |
    Examples:
      | type     | hiptest-uid                              | dataset_name |
      | DP       | uid:0349459e-6e60-42cb-8440-0d6a34eb15ca | DP           |
      | RECOVERY | uid:a6c0f1b1-2e29-4cd4-b0ef-fc04ecb44198 | Recovery     |
      | OTHERS   | uid:7147944e-cffd-4292-a2e6-41dad805678c | Others       |

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario Outline: Update Lat/Long of Facility - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | <type>    |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | latitude          | 11                     |
      | longitude         | 12                     |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    And Operator refresh hubs cache on Facilities Management page
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}                |
      | facilityType | {KEY_CREATED_HUB.facilityTypeDisplay} |
      | region       | {KEY_CREATED_HUB.region}              |
      | displayName  | {KEY_CREATED_HUB.displayName}         |
      | city         | {KEY_CREATED_HUB.city}                |
      | country      | {KEY_CREATED_HUB.country}             |
      | latitude     | 11                                    |
      | longitude    | 12                                    |
    Examples:
      | type              | hiptest-uid                              | dataset_name      |
      | STATION           | uid:02bc0971-fc3a-4ce7-af48-5fe38fd7263a | Station           |
      | CROSSDOCK         | uid:8d07757e-b05d-4b85-8069-761105214f2a | Hub Crossdock     |
      | CROSSDOCK_STATION | uid:2e18f1fe-0e8c-45d7-a8d8-26d783312cbf | Station Crossdock |

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario Outline: Update Lat/Long of Facility - DP/Recovery/Others - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | <type>    |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | latitude          | 11                     |
      | longitude         | 12                     |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    And Operator refresh hubs cache on Facilities Management page
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}                |
      | facilityType | {KEY_CREATED_HUB.facilityTypeDisplay} |
      | region       | {KEY_CREATED_HUB.region}              |
      | displayName  | {KEY_CREATED_HUB.displayName}         |
      | city         | {KEY_CREATED_HUB.city}                |
      | country      | {KEY_CREATED_HUB.country}             |
      | latitude     | 11                                    |
      | longitude    | 12                                    |
    Examples:
      | type     | hiptest-uid                              | dataset_name |
      | DP       | uid:5018d57a-b166-4382-9330-f980ead437b1 | DP           |
      | RECOVERY | uid:da01bdee-c78a-40ca-809a-2a16dd518bd9 | Recovery     |
      | OTHERS   | uid:ddc729c8-15b5-4cec-b086-ed3ca0bb81e0 | Others       |

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario Outline: Update Lat/Long and Facility Type - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | <type>    |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | facilityType      | DP                     |
      | latitude          | 11                     |
      | longitude         | 12                     |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    And Operator refresh hubs cache on Facilities Management page
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | DP                            |
      | region       | {KEY_CREATED_HUB.region}      |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | 11                            |
      | longitude    | 12                            |
    Examples:
      | type              | hiptest-uid                              | dataset_name      |
      | STATION           | uid:0bb1b3ed-fc84-40ce-8b80-ab46cf80a024 | Station           |
      | CROSSDOCK         | uid:55dc4d29-3f3c-4c0e-aa49-994a832ca3e2 | Hub Crossdock     |
      | CROSSDOCK_STATION | uid:71919b9e-e0b3-466e-a187-882456f9b488 | Station Crossdock |

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario Outline: Update Lat/Long and Facility Type - DP/Recovery/Others - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | <type>    |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | facilityType      | Station                |
      | latitude          | 11                     |
      | longitude         | 12                     |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    And Operator refresh hubs cache on Facilities Management page
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_CREATED_HUB.name}        |
      | facilityType | Station                       |
      | region       | {KEY_CREATED_HUB.region}      |
      | displayName  | {KEY_CREATED_HUB.displayName} |
      | city         | {KEY_CREATED_HUB.city}        |
      | country      | {KEY_CREATED_HUB.country}     |
      | latitude     | 11                            |
      | longitude    | 12                            |
    Examples:
      | type     | hiptest-uid                              | dataset_name |
      | DP       | uid:9cdc23a3-ef15-4b10-8105-09d420faa2e5 | DP           |
      | RECOVERY | uid:64a1dd52-4fc1-4da6-8f62-b424e018721c | Recovery     |
      | OTHERS   | uid:385b986a-4dbf-45bf-b322-7174635aeb1b | Others       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op