@Sort @Hubs @FacilitiesManagementPart2 @Saas
Feature: Facilities Management

  @LaunchBrowser @ShouldAlwaysRun @TAG
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedHubs
  Scenario: Update Hub Type to Station (uid:4aae1605-d328-4259-9fda-e0b742e9910d)
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
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}          |
      | facilityType      | Station                                          |
      | name              | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} [E]      |
      | displayName       | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} [E] |
      | city              | GENERATED                                        |
      | country           | GENERATED                                        |
      | latitude          | GENERATED                                        |
      | longitude         | GENERATED                                        |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_SORT_LIST_OF_UPDATED_HUBS.name}      |
      | facilityType | Station                                   |
      | region       | JKB                                       |
      | displayName  | {KEY_SORT_LIST_OF_UPDATED_HUBS.shortName} |
      | city         | {KEY_SORT_LIST_OF_UPDATED_HUBS.city}      |
      | country      | {KEY_SORT_LIST_OF_UPDATED_HUBS.country}   |
      | latitude     | {KEY_SORT_LIST_OF_UPDATED_HUBS.latitude}  |
      | longitude    | {KEY_SORT_LIST_OF_UPDATED_HUBS.longitude} |

  @DeleteCreatedHubs
  Scenario: Create New Hub-Crossdock Not As Sort Hub (uid:9fbaa3fa-8415-456e-acf1-f68dd496ed26)
    Given Operator go to menu Utilities -> QRCode Printing
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
      | name         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}      |
      | facilityType | Hub - Crossdock                              |
      | region       | JKB                                          |
      | displayName  | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} |
      | city         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].city}      |
      | country      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].country}   |
      | latitude     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].latitude}  |
      | longitude    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].longitude} |
      | sortHub      | false                                        |

  @DeleteCreatedHubs
  Scenario: Create New Hub-Crossdock As Sort Hub (uid:a2a0ab06-4a7a-42c1-8aed-eb29bf9c9f40)
    Given Operator go to menu Utilities -> QRCode Printing
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
      | sortHub      | TRUE            |
    Then Operator verifies that success react notification displayed:
      | top | Hub Created Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}      |
      | facilityType | Hub - Crossdock                              |
      | region       | JKB                                          |
      | displayName  | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} |
      | city         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].city}      |
      | country      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].country}   |
      | latitude     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].latitude}  |
      | longitude    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].longitude} |
      | sortHub      | true                                         |

  @DeleteCreatedHubs
  Scenario: Create New Station - Crossdock Hub (uid:ad68e27f-dca5-425b-8c7b-5a0e2a751981)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Hubs -> Facilities Management
    And Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED           |
      | displayName  | GENERATED           |
      | facilityType | Station - Crossdock |
      | region       | JKB                 |
      | city         | GENERATED           |
      | country      | GENERATED           |
      | latitude     | GENERATED           |
      | longitude    | GENERATED           |
    Then Operator verifies that success react notification displayed:
      | top | Hub Created Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}      |
      | facilityType | Station - Crossdock                          |
      | region       | JKB                                          |
      | displayName  | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} |
      | city         | {KEY_SORT_LIST_OF_CREATED_HUBS[1].city}      |
      | country      | {KEY_SORT_LIST_OF_CREATED_HUBS[1].country}   |
      | latitude     | {KEY_SORT_LIST_OF_CREATED_HUBS[1].latitude}  |
      | longitude    | {KEY_SORT_LIST_OF_CREATED_HUBS[1].longitude} |
      | sortHub      | false                                        |

  @DeleteCreatedHubs
  Scenario: Update to Hub-Crossdock but Not As Sort Hub (uid:1e8d997d-5cd9-4ec1-ac3d-1cd3fcdf7bdc)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Sort - Operator creates 1 new hubs with data below:
      | name         | GENERATED         |
      | displayName  | GENERATED         |
      | facilityType | CROSSDOCK_STATION |
      | region       | JKB               |
      | city         | GENERATED         |
      | country      | GENERATED         |
      | latitude     | GENERATED         |
      | longitude    | GENERATED         |
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}          |
      | name              | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} [E]      |
      | displayName       | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} [E] |
      | facilityType      | Hub - Crossdock                                  |
      | city              | GENERATED                                        |
      | country           | GENERATED                                        |
      | latitude          | 11                                               |
      | longitude         | 12                                               |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_SORT_LIST_OF_UPDATED_HUBS.name}      |
      | facilityType | Hub - Crossdock                           |
      | region       | JKB                                       |
      | displayName  | {KEY_SORT_LIST_OF_UPDATED_HUBS.shortName} |
      | city         | {KEY_SORT_LIST_OF_UPDATED_HUBS.city}      |
      | country      | {KEY_SORT_LIST_OF_UPDATED_HUBS.country}   |
      | latitude     | 11                                        |
      | longitude    | 12                                        |
      | sortHub      | false                                     |

  @DeleteCreatedHubs
  Scenario: Update to Hub-Crossdock As Sort Hub (uid:4795b7a6-2311-43de-9290-b1d41e31cdb7)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Sort - Operator creates 1 new hubs with data below:
      | name         | GENERATED         |
      | displayName  | GENERATED         |
      | facilityType | CROSSDOCK_STATION |
      | region       | JKB               |
      | city         | GENERATED         |
      | country      | GENERATED         |
      | latitude     | GENERATED         |
      | longitude    | GENERATED         |
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}          |
      | name              | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} [E]      |
      | displayName       | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} [E] |
      | facilityType      | Crossdock                                        |
      | sortHub           | TRUE                                             |
      | city              | GENERATED                                        |
      | country           | GENERATED                                        |
      | latitude          | 11                                               |
      | longitude         | 12                                               |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_SORT_LIST_OF_UPDATED_HUBS.name}      |
      | facilityType | Hub - Crossdock                           |
      | region       | JKB                                       |
      | displayName  | {KEY_SORT_LIST_OF_UPDATED_HUBS.shortName} |
      | city         | {KEY_SORT_LIST_OF_UPDATED_HUBS.city}      |
      | country      | {KEY_SORT_LIST_OF_UPDATED_HUBS.country}   |
      | latitude     | 11                                        |
      | longitude    | 12                                        |
      | sortHub      | true                                      |

  @DeleteCreatedHubs
  Scenario: Update to Station-Crossdock Hub (uid:155b7bc7-d031-4bdf-b0f5-2812f1a5737d)
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
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name}          |
      | name              | {KEY_SORT_LIST_OF_CREATED_HUBS[1].name} [E]      |
      | displayName       | {KEY_SORT_LIST_OF_CREATED_HUBS[1].shortName} [E] |
      | facilityType      | Station - Crossdock                              |
      | city              | GENERATED                                        |
      | country           | GENERATED                                        |
      | latitude          | 11                                               |
      | longitude         | 12                                               |
    Then Operator verifies that success react notification displayed:
      | top | Hub Updated Successfully |
    Then Operator verify hub parameters on Facilities Management page:
      | name         | {KEY_SORT_LIST_OF_UPDATED_HUBS.name}      |
      | facilityType | Station - Crossdock                       |
      | region       | JKB                                       |
      | displayName  | {KEY_SORT_LIST_OF_UPDATED_HUBS.shortName} |
      | city         | {KEY_SORT_LIST_OF_UPDATED_HUBS.city}      |
      | country      | {KEY_SORT_LIST_OF_UPDATED_HUBS.country}   |
      | latitude     | 11                                        |
      | longitude    | 12                                        |
      | sortHub      | false                                     |

  Scenario: User Unable to Disable active hub attached to Zone
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Hubs -> Facilities Management
    And Operator disable hub with name "{hub-with-zone}" on Facilities Management page
    Then Operator verifies that error react notification displayed:
      | top    | NOT_ALLOWED_TO_DELETE_HUB        |
      | bottom | There are sort tasks in this hub |

  Scenario: User Unable to Disable active hub attached to MiddleTierNode
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Hubs -> Facilities Management
    And Operator disable hub with name "{hub-with-middle-tier}" on Facilities Management page
    Then Operator verifies that error react notification displayed:
      | top    | NOT_ALLOWED_TO_DELETE_HUB        |
      | bottom | There are sort tasks in this hub |

  Scenario: User Unable to Disable active hub attached to Hub User
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Hubs -> Facilities Management
    And Operator disable hub with name "{hub-with-hub-user}" on Facilities Management page
    Then Operator verifies that error react notification displayed:
      | top    | NOT_ALLOWED_TO_DELETE_HUB              |
      | bottom | Hub has existing Sort App / OpV2 users |

  Scenario: User Unable to Disable active hub attached to SortApp User
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Hubs -> Facilities Management
    And Operator disable hub with name "{hub-with-sort-app-user}" on Facilities Management page
    Then Operator verifies that error react notification displayed:
      | top    | NOT_ALLOWED_TO_DELETE_HUB        |
      | bottom | Hub has existing Sort App / OpV2 users |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op