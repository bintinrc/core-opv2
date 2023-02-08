@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileHomepage2 @ShipmentsInMyHub
Feature: Middle Mile Homepage - Shipments in My Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View Closed Shipment in 24 - 48h
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {mm-homepage-current-hub-id} to hub id = {hub-id-2}
    Given API Operator reloads hubs cache
    Given DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {mm-homepage-current-hub-name} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage
    Then Operator verifies total shipment count in Shipments in My Hub section is correct
    When DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}" Ordered by Column "shipments_24h_48h_count"
    Then Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-homepage/shipments-in-my-hub/{mm-homepage-current-hub-id}"
    Then Operator verifies can sort data in Middle Mile Homepage by column "shipments_24h_48h_count"

  Scenario: View Closed Shipment in Over 48h
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {mm-homepage-current-hub-id} to hub id = {hub-id-2}
    Given API Operator reloads hubs cache
    Given DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {mm-homepage-current-hub-name} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage
    Then Operator verifies total shipment count in Shipments in My Hub section is correct
    When DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}" Ordered by Column "shipments_over_48h_count"
    Then Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-homepage/shipments-in-my-hub/{mm-homepage-current-hub-id}"
    Then Operator verifies can sort data in Middle Mile Homepage by column "shipments_over_48h_count"

  Scenario: View Van Inbound Shipment in 24 - 48h
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {mm-homepage-current-hub-id} to hub id = {hub-id-2}
    Then API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_CREATED_SHIPMENT_ID}    |
      | scanType  | shipment_van_inbound         |
      | hubId     | {mm-homepage-current-hub-id} |
    Given API Operator reloads hubs cache
    Given DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {mm-homepage-current-hub-name} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage
    Then Operator verifies total shipment count in Shipments in My Hub section is correct
    When DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}" Ordered by Column "shipments_24h_48h_count"
    Then Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-homepage/shipments-in-my-hub/{mm-homepage-current-hub-id}"
    Then Operator verifies can sort data in Middle Mile Homepage by column "shipments_24h_48h_count"

  Scenario: View Van Inbound Shipment in Over 48h
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {mm-homepage-current-hub-id} to hub id = {hub-id-2}
    Then API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_CREATED_SHIPMENT_ID}    |
      | scanType  | shipment_van_inbound         |
      | hubId     | {mm-homepage-current-hub-id} |
    Given API Operator reloads hubs cache
    Given DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {mm-homepage-current-hub-name} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage
    Then Operator verifies total shipment count in Shipments in My Hub section is correct
    When DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}" Ordered by Column "shipments_over_48h_count"
    Then Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-homepage/shipments-in-my-hub/{mm-homepage-current-hub-id}"
    Then Operator verifies can sort data in Middle Mile Homepage by column "shipments_over_48h_count"

  Scenario: View At transit Hub Shipment in 24 - 48h
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {mm-homepage-current-hub-id} to hub id = {hub-id-2}
    Then API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_CREATED_SHIPMENT_ID}    |
      | scanType  | shipment_van_inbound         |
      | hubId     | {mm-homepage-current-hub-id} |
    Then API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_CREATED_SHIPMENT_ID} |
      | scanType  | shipment_hub_inbound      |
      | hubId     | {hub-id-2}                |
    Given API Operator reloads hubs cache
    Given DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {mm-homepage-current-hub-name} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage
    Then Operator verifies total shipment count in Shipments in My Hub section is correct
    When DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}" Ordered by Column "shipments_24h_48h_count"
    Then Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-homepage/shipments-in-my-hub/{mm-homepage-current-hub-id}"
    Then Operator verifies can sort data in Middle Mile Homepage by column "shipments_24h_48h_count"

  Scenario: View At transit Hub Shipment in Over 48h
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {mm-homepage-current-hub-id} to hub id = {hub-id-2}
    Then API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_CREATED_SHIPMENT_ID}    |
      | scanType  | shipment_van_inbound         |
      | hubId     | {mm-homepage-current-hub-id} |
    Then API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_CREATED_SHIPMENT_ID} |
      | scanType  | shipment_hub_inbound      |
      | hubId     | {hub-id-2}                |
    Given API Operator reloads hubs cache
    Given DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {mm-homepage-current-hub-name} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage
    Then Operator verifies total shipment count in Shipments in My Hub section is correct
    When DB Hub - Get Hub Shipment Summaries by Current Hub Id "{mm-homepage-current-hub-id}" Ordered by Column "shipments_over_48h_count"
    Then Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-homepage/shipments-in-my-hub/{mm-homepage-current-hub-id}"
    Then Operator verifies can sort data in Middle Mile Homepage by column "shipments_over_48h_count"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op