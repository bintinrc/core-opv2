@OperatorV2 @AllShippers
Feature: All Shippers

  @LaunchBrowser @EnableClearCache @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario Outline: Operator create new Shipper with basic settings (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | <isShipperActive>              |
      | shipperType                  | <shipperType>                  |
      | ocVersion                    | <ocVersion>                    |
      | services                     | <services>                     |
      | trackingType                 | <trackingType>                 |
      | isAllowCod                   | <isAllowCod>                   |
      | isAllowCashPickup            | <isAllowCashPickup>            |
      | isPrepaid                    | <isPrepaid>                    |
      | isAllowStagedOrders          | <isAllowStagedOrders>          |
      | isMultiParcelShipper         | <isMultiParcelShipper>         |
      | isDisableDriverAppReschedule | <isDisableDriverAppReschedule> |
      | pricingScriptName            | {pricing-script-name}          |
      | industryName                 | {industry-name}                |
      | salesPerson                  | {sales-person}                 |
    Then Operator verify the new Shipper is created successfully
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    Then Operator verify the shipper is deleted successfully
    Examples:
      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services                           | trackingType  | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
      | Shipper V2 | uid:d898b80d-2b26-487a-af42-a4583b5bdebc | true            | Normal      | v2        | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT | LegacyDynamic | true       | true              | false     | true                | true                 | false                        |
      | Shipper V3 | uid:1b9953fd-60e8-4599-a5c2-b66d6fb37fcd | true            | Normal      | v3        | 1DAY, 2DAY, 3DAY                   | Fixed         | true       | false             | false     | false               | false                | true                         |
      | Shipper V4 | uid:dfbe7350-2c9d-40d3-96c4-428f5842a511 | true            | Normal      | v4        | 3DAY                               | Fixed         | false      | true              | true      | false               | false                | false                        |

  Scenario Outline: Operator create new Shipper with basic settings and then update the basic settings (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | <isShipperActive>              |
      | shipperType                  | <shipperType>                  |
      | ocVersion                    | <ocVersion>                    |
      | services                     | <services>                     |
      | trackingType                 | <trackingType>                 |
      | isAllowCod                   | <isAllowCod>                   |
      | isAllowCashPickup            | <isAllowCashPickup>            |
      | isPrepaid                    | <isPrepaid>                    |
      | isAllowStagedOrders          | <isAllowStagedOrders>          |
      | isMultiParcelShipper         | <isMultiParcelShipper>         |
      | isDisableDriverAppReschedule | <isDisableDriverAppReschedule> |
      | pricingScriptName            | {pricing-script-name}          |
      | industryName                 | {industry-name}                |
      | salesPerson                  | {sales-person}                 |
    Then Operator verify the new Shipper is created successfully
    When Operator update Shipper's basic settings
    Then Operator verify Shipper's basic settings is updated successfully
    When DB Operator soft delete shipper by Legacy ID
    When API Operator reload shipper's cache
    Then Operator verify the shipper is deleted successfully
    Examples:
      | Note       | hiptest-uid                              | isShipperActive | shipperType | ocVersion | services                           | trackingType  | isAllowCod | isAllowCashPickup | isPrepaid | isAllowStagedOrders | isMultiParcelShipper | isDisableDriverAppReschedule |
      | Shipper V2 | uid:1312b967-27af-4454-908b-02021571d350 | true            | Normal      | v2        | 1DAY, 2DAY, 3DAY, SAMEDAY, FREIGHT | LegacyDynamic | true       | true              | false     | true                | true                 | false                        |
      | Shipper V3 | uid:fd5a8ad9-48ed-4d95-a6d9-c36daad021f1 | true            | Normal      | v3        | 1DAY, 2DAY, 3DAY                   | Fixed         | true       | false             | false     | false               | false                | true                         |
      | Shipper V4 | uid:7fc77afb-999d-4257-b20e-e1540aebf820 | true            | Normal      | v4        | 3DAY                               | Fixed         | false      | true              | true      | false               | false                | false                        |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
