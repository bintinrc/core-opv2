@Sort @Hubs @FacilitiesManagementPart1 @Saas
Feature: Facilities Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedHubs
  Scenario: Create Hub (uid:c40d8354-a4cb-463c-a220-39f56e91eb71)
    When Operator go to menu Hubs -> Facilities Management
    And Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED       |
      | displayName  | GENERATED       |
      | facilityType | Hub - Crossdock |
      | region       | JKB             |
      | city         | GENERATED       |
      | country      | GENERATED       |
      | latitude     | GENERATED       |
      | longitude    | GENERATED       |
    Then Operator verifies that success react notification displayed:
      | top | Hub Created Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}         |
      | facilityType | {KEY_SORT_LIST_OF_CREATED_HUBS[1].facilityType} |
      | region       | {KEY_SORT_LIST_OF_CREATED_HUBS[1].region}       |
      | displayName  | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName}    |
      | city         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].city}         |
      | country      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].country}      |
      | latitude     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].latitude}     |
      | longitude    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].longitude}    |

  @DeleteCreatedHubs
  Scenario: Update Hub (uid:16ec1eac-f4f4-495a-8b71-4f8a9d846e54)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Sort - Operator creates 1 new hubs with data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}          |
      | name              | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} [E]      |
      | displayName       | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} [E] |
      | city              | GENERATED                                        |
      | country           | GENERATED                                        |
      | latitude          | GENERATED                                        |
      | longitude         | GENERATED                                        |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name        | {KEY_SORT_LIST_OF_UPDATED_HUBS.name}      |
      | displayName | {KEY_SORT_LIST_OF_UPDATED_HUBS.shortName} |
      | city        | {KEY_SORT_LIST_OF_UPDATED_HUBS.city}      |
      | country     | {KEY_SORT_LIST_OF_UPDATED_HUBS.country}   |
      | latitude    | {KEY_SORT_LIST_OF_UPDATED_HUBS.latitude}  |
      | longitude   | {KEY_SORT_LIST_OF_UPDATED_HUBS.longitude} |

  @DeleteCreatedHubs
  Scenario: Search Hub (uid:449beef4-34f3-42ad-8c08-026938ae42db)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Sort - Operator creates 1 new hubs with data below:
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
      | name         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}      |
      | facilityType | Hub - Crossdock                              |
      | region       | {KEY_SORT_LIST_OF_CREATED_HUBS[1].region}    |
      | displayName  | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} |
      | city         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].city}      |
      | country      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].country}   |
      | latitude     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].latitude}  |
      | longitude    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].longitude} |

  @DeleteCreatedHubs
  Scenario: Download CSV hubs (uid:382e0a13-8725-42ae-995c-e6f524961fa7)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Sort - Operator creates 1 new hubs with data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Hubs -> Facilities Management
    When Operator download Hub CSV file on Facilities Management page
    Then Operator verifies that success react notification displayed:
      | top    | Report is being prepared         |
      | bottom | It will be in your inbox shortly |
    And Operator verify Hub CSV file is downloaded successfully on Facilities Management page and contains correct info
      | name         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}      |
      | facilityType | Hub - Crossdock                              |
      | region       | {KEY_SORT_LIST_OF_CREATED_HUBS[1].region}    |
      | displayName  | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} |
      | city         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].city}      |
      | country      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].country}   |
      | latitude     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].latitude}  |
      | longitude    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].longitude} |

  @DeleteCreatedHubs
  Scenario: Disable active hub (uid:667d6ff4-6483-490e-a4ea-0513741d00ad)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Sort - Operator creates 1 new hubs with data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Hubs -> Facilities Management
    And Operator disable hub with name "{KEY_SORT_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    Then Operator verifies that success react notification displayed:
      | top | Hub Disabled Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name   | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
      | status | Disabled               |

  @DeleteCreatedHubs
  Scenario: Activate disabled hub (uid:60f0c3fc-649b-4018-9952-23bd208b4374)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Sort - Operator creates 1 new hubs with data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Sort - Operator disable hub with "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" hub id
    When Operator go to menu Hubs -> Facilities Management
    And Operator activate hub with name "{KEY_SORT_LIST_OF_CREATED_HUBS[1].name}" on Facilities Management page
    Then Operator verifies that success react notification displayed:
      | top | Hub Activated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name   | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} |
      | status | Active                                  |

  @DeleteCreatedHubs
  Scenario: Create New Station Hub (uid:8f0ca3bd-c928-4bc9-b759-5fcdfeb9ea98)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Hubs -> Facilities Management
    And Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED |
      | facilityType | Station   |
      | region       | JKB       |
      | displayName  | GENERATED |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Then Operator verifies that success react notification displayed:
      | top | Hub Created Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}      |
      | facilityType | Station                                      |
      | region       | JKB                                          |
      | displayName  | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} |
      | city         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].city}      |
      | country      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].country}   |
      | latitude     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].latitude}  |
      | longitude    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].longitude} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op