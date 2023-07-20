@OperatorV2 @Recovery @AutoMissingCreationSettings @ClearCache @ClearCookies
Feature: Auto Missing Creation Settings

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @SG
  Scenario: The New Hub Created is available on the Hub Missing Investigation Page
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Recovery -> Auto Missing Creation Settings
    When Operator Search created hub by hub id = "{KEY_CREATED_HUB.id}" in Auto Missing Creation Settings page
    Then Operator verifies new hub is available in Hub Missing Investigation Mapping table with correct details
      | id   | {KEY_CREATED_HUB.id}   |
      | name | {KEY_CREATED_HUB.name} |

  @DeleteHubsViaAPI @SG
  Scenario: Operator Added Hub Missing Investigation Mapping [All Country]
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Recovery -> Auto Missing Creation Settings
    When Operator Search created hub by hub id = "{KEY_CREATED_HUB.id}" in Auto Missing Creation Settings page
    And Operator edit Hub Missing Investigation for specific hub
    Then Operator verifies Edit Hub Missing Investigation Mapping dialog
      | id   | {KEY_CREATED_HUB.id}   |
      | name | {KEY_CREATED_HUB.name} |
    When Operator select Assignee and Investigation dept in Edit Hub Missing Investigation Mapping dialog
    Then Operator verifies that success notification displayed
      | message | Updated missing mapping for hub |
    And DB Recovery - verify assignee rule
      | hubId             | {KEY_CREATED_HUB.id} |
      | investigatingDept | Recovery             |
      | assigneeEmail     | AUTOMATION           |
      | systemId          | SG                   |
      | scanEventTrigger  |                      |

  @DeleteHubsViaAPI @ID
  Scenario: Operator Add and Update Hub Missing Investigation Mapping [ID]
    Given Operator change the country to "Indonesia"
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | WEST JAVA |
      | city         | GENERATED |
      | country      | ID        |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Recovery -> Auto Missing Creation Settings
    When Operator Search created hub by hub id = "{KEY_CREATED_HUB.id}" in Auto Missing Creation Settings page
    And Operator edit Hub Missing Investigation for specific hub
    Then Operator verifies Edit Hub Missing Investigation Mapping dialog
      | id   | {KEY_CREATED_HUB.id}   |
      | name | {KEY_CREATED_HUB.name} |
    When Operator select Assignee in Edit Hub Missing Investigation Mapping dialog - ID
    Then Operator verifies that success notification displayed
      | message | Updated missing mapping for hub |
    Then DB Recovery - verify multiple scan_type for a hub
      | hubIds            | {KEY_CREATED_HUB.id}                                                                                                                                               |
      | investigatingDept | Fleet (Last Mile),Fleet (First Mile),Sort (Warehouse),Sort (Warehouse),Sort (Warehouse),Sort (Warehouse),Fleet (Last Mile),Fleet (Last Mile),Freight (Middle Mile) |
      | assigneeEmail     | AUTOMATION                                                                                                                                                         |
      | scanEvents        | DRIVER_INBOUND_SCAN,DRIVER_PICKUP_SCAN,HUB_INBOUND_SCAN,OUTBOUND_SCAN,PARCEL_ROUTING_SCAN,RECOVERY_SCAN,ROUTE_INBOUND_SCAN,ROUTE_TRANSFER_SCAN,SHIPMENT_COMPLETED  |
      | systemId          | ID                                                                                                                                                                 |

  @SG
  Scenario: Default Mapping Hub For Missing Investigation Mapping
    Given DB Recovery - verify default assignee rule "SG"
    When Operator go to menu Recovery -> Auto Missing Creation Settings
    When Operator Search created hub by hub id = "0" in Auto Missing Creation Settings page
    Then Operator verifies new hub is available in Hub Missing Investigation Mapping table with correct details
      | id   | 0               |
      | name | Default mapping |

  @DeleteHubsViaAPI @SG
  Scenario: Disabled Hub is not shown in Auto Missing Creation Settings page
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator disable hub with ID "{KEY_CREATED_HUB.id}"
    And API Operator reloads hubs cache
    When Operator go to menu Recovery -> Auto Missing Creation Settings
    When Operator Search created hub by hub id = "{KEY_CREATED_HUB.id}" in Auto Missing Creation Settings page
    Then Operator verifies the disabled hub not found

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op