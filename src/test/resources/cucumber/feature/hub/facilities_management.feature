@OperatorV2 @MiddleMile @Hub @FacilitiesManagement
Feature: Facilities Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaDb
  Scenario Outline: Disable Hub - <type> - (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates new Hub with type "<type>" using data below:
      | name        | GENERATED |
      | displayName | GENERATED |
      | city        | GENERATED |
      | country     | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator reloads hubs cache
    And Operator refresh page
    Given Operator go to menu Hubs -> Facilities Management
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify Hub is found on Facilities Management page and contains correct info
    And Operator verify Hub "facility type" is "<type>"
    And Operator disable created hub on Facilities Management page
    Then Operator verify Hub is updated successfully on Facilities Management page
    Examples:
      | type    | hiptest-uid                              |
      | Station | uid:6f350889-3076-4293-992a-7b0443dac7d8 |
#      | Station - Crossdock | uid:4d9e12db-b529-4b93-b7fc-776ac32bc7dc |
#      | Hub - Crossdock     | uid:846081f6-4fa4-4ecc-b3a4-2a2ee1e2b68e |

  @DeleteHubsViaDb
  Scenario Outline: Disable Hub - DP/Recovery/Others - <type> - (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates new Hub with type "<type>" using data below:
      | name        | GENERATED |
      | displayName | GENERATED |
      | city        | GENERATED |
      | country     | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    And API Operator reloads hubs cache
    And Operator refresh page
    Given Operator go to menu Hubs -> Facilities Management
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify Hub is found on Facilities Management page and contains correct info
    And Operator verify Hub "facility type" is "<type>"
    And Operator disable created hub on Facilities Management page
    Then Operator verify Hub is updated successfully on Facilities Management page
    Examples:
      | type     | hiptest-uid                              |
      | DP       | uid:39bef1c8-a345-4b6a-8be6-eca897b6e78c |
      | Recovery | uid:578bf271-1547-407f-8abb-00e42525e4c2 |
      | Others   | uid:2de00e90-0f48-4617-90d5-355eb3e1045a |

  @DeleteHubsViaDb
  Scenario Outline: Update Facility Type (<hiptest-uid>)
    Given no-op
    Examples:
      | type                | hiptest-uid                              |
      | Station             | uid:2a62c480-b20c-40c4-b89e-3a9118b8878a |
      | Hub - Crossdock     | uid:58bba508-9557-46b3-b863-10c6c9445961 |
      | Station - Crossdock | uid:580558a4-ea3d-4813-8770-36fc9c5c3a97 |

  @DeleteHubsViaDb
  Scenario Outline: Update Facility Type - DP/Recovery/Others (<hiptest-uid>)
    Given no-op
    Examples:
      | type     | hiptest-uid                              |
      | DP       | uid:0349459e-6e60-42cb-8440-0d6a34eb15ca |
      | Recovery | uid:a6c0f1b1-2e29-4cd4-b0ef-fc04ecb44198 |
      | Others   | uid:7147944e-cffd-4292-a2e6-41dad805678c |

  @DeleteHubsViaDb
  Scenario Outline: Update Lat/Long of Facility (<hiptest-uid>)
    Given no-op
    Examples:
      | type                | hiptest-uid                              |
      | Station             | uid:02bc0971-fc3a-4ce7-af48-5fe38fd7263a |
      | Hub - Crossdock     | uid:8d07757e-b05d-4b85-8069-761105214f2a |
      | Station - Crossdock | uid:2e18f1fe-0e8c-45d7-a8d8-26d783312cbf |

  @DeleteHubsViaDb
  Scenario Outline: Update Lat/Long of Facility - DP/Recovery/Others (<hiptest-uid>)
    Given no-op
    Examples:
      | type     | hiptest-uid                              |
      | DP       | uid:5018d57a-b166-4382-9330-f980ead437b1 |
      | Recovery | uid:da01bdee-c78a-40ca-809a-2a16dd518bd9 |
      | Others   | uid:ddc729c8-15b5-4cec-b086-ed3ca0bb81e0 |

  @DeleteHubsViaDb
  Scenario Outline: Update Lat/Long and Facility Type (<hiptest-uid>)
    Given no-op
    Examples:
      | type                | hiptest-uid                              |
      | Station             | uid:0bb1b3ed-fc84-40ce-8b80-ab46cf80a024 |
      | Hub - Crossdock     | uid:55dc4d29-3f3c-4c0e-aa49-994a832ca3e2 |
      | Station - Crossdock | uid:71919b9e-e0b3-466e-a187-882456f9b488 |

  @DeleteHubsViaDb
  Scenario Outline: Update Lat/Long and Facility Type - DP/Recovery/Others (<hiptest-uid>)
    Given no-op
    Examples:
      | type     | hiptest-uid                              |
      | DP       | uid:9cdc23a3-ef15-4b10-8105-09d420faa2e5 |
      | Recovery | uid:64a1dd52-4fc1-4da6-8f62-b424e018721c |
      | Others   | uid:385b986a-4dbf-45bf-b322-7174635aeb1b |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op