@OperatorV2 @Recovery @ShipperBuckets
Feature: Shipper Buckets

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipperCommonV2
  Scenario Outline: Operator Create New Shipper - <Dataset_Name>
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    Then Operator fill Shipper Information Section with data:
      | Shipper Type         | Normal                |
      | Shipper Name         | test from automation  |
      | Shipper Phone Number | 4526589856            |
      | Shipper Email        | testemail@ninjavan.co |
      | Sales person         | LI-Lianne             |
    Then Operator fill Shipper Contact Details Section with data:
      | Liaison Address | test address |
    Then Operator fill Service Offerings Section with data:
      | Parcel Delivery           | Yes |
      | Return                    | Yes |
      | Marketplace               | No  |
      | International             | No  |
      | Marketplace International | No  |
      | Document                  | No  |
      | Corporate                 | No  |
      | Corporate Return          | No  |
      | Corporate Manual AWB      | No  |
      | Corporate Document        | No  |
    Then Operator fill Operational settings Section with data:
      | Prefix | RANDOM |
    Then Operator fill Failed Delivery Management Section with data:
      | Shipper Bucket              | <bucket_type> |
      | XB Fulfillment Setting      | Yes           |
      | No. of Free Storage Days    | 15            |
      | No. of Maximum Storage Days | 46            |
    Then Operator click in Pricing and Billing tab in shipper create edit page
    Then Operator fill Billing information in Pricing and Billing Section with data:
      | Billing Name      | test name    |
      | Billing Contact   | 5698569859   |
      | Billing Address   | test address |
      | Billing Post Code | 45685        |
    Then Operator Add new profile in Pricing and Billing Section with data:
      | End Date        | {gradle-next-3-day-yyyy-MM-dd} |
      | Pricing Scripts | 6 - 1234                       |
      | Comments        | test                           |
      | Discount Value  | 1                              |
    Then Operator save new shipper
    And DB Recovery - verify shipper "{KEY_CREATED_SHIPPER_ID}" is found in the bucket "<bucket_id>"
    And API Shipper - Operator fetch shipper id by legacy shipper id "{KEY_CREATED_SHIPPER_ID}"

    Examples:
      | Dataset_Name   | bucket_type                                       | bucket_id |
      | SG - Bucket 8  | SG (Default) - 3 max delivery attempts <Auto RTS> | 8         |
      | SG - Bucket 15 | Pending                                           | 15        |
      | SG - Bucket 23 | SG - 2 Max return attempts <Max PETS>             | 23        |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario Outline: Operator Update Shipper Bucket  - <Dataset_Name>
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    Then Operator fill Shipper Information Section with data:
      | Shipper Type         | Normal                |
      | Shipper Name         | test from automation  |
      | Shipper Phone Number | 4526589856            |
      | Shipper Email        | testemail@ninjavan.co |
      | Sales person         | LI-Lianne             |
    Then Operator fill Shipper Contact Details Section with data:
      | Liaison Address | test address |
    Then Operator fill Service Offerings Section with data:
      | Parcel Delivery           | Yes |
      | Return                    | Yes |
      | Marketplace               | No  |
      | International             | No  |
      | Marketplace International | No  |
      | Document                  | No  |
      | Corporate                 | No  |
      | Corporate Return          | No  |
      | Corporate Manual AWB      | No  |
      | Corporate Document        | No  |
    Then Operator fill Operational settings Section with data:
      | Prefix | RANDOM |
    Then Operator fill Failed Delivery Management Section with data:
      | Shipper Bucket              | SG (Default) - 3 max delivery attempts <Auto RTS> |
      | XB Fulfillment Setting      | Yes                                               |
      | No. of Free Storage Days    | 15                                                |
      | No. of Maximum Storage Days | 46                                                |
    Then Operator click in Pricing and Billing tab in shipper create edit page
    Then Operator fill Billing information in Pricing and Billing Section with data:
      | Billing Name      | test name    |
      | Billing Contact   | 5698569859   |
      | Billing Address   | test address |
      | Billing Post Code | 45685        |
    Then Operator Add new profile in Pricing and Billing Section with data:
      | End Date        | {gradle-next-3-day-yyyy-MM-dd} |
      | Pricing Scripts | 6 - 1234                       |
      | Comments        | test                           |
      | Discount Value  | 1                              |
    Then Operator save new shipper
    And DB Recovery - verify shipper "{KEY_CREATED_SHIPPER_ID}" is found in the bucket "8"
    When Operator fill Failed Delivery Management Section with data:
      | Shipper Bucket              | <bucket_type> |
      | XB Fulfillment Setting      | Yes           |
      | No. of Free Storage Days    | 15            |
      | No. of Maximum Storage Days | 46            |
    Then Operator save changes on Edit Shippers page
    And DB Recovery - verify shipper "{KEY_CREATED_SHIPPER_ID}" is found in the bucket "<bucket_id>"
    And API Shipper - Operator fetch shipper id by legacy shipper id "{KEY_CREATED_SHIPPER_ID}"

    Examples:
      | Dataset_Name   | bucket_type                           | bucket_id |
      | SG - Bucket 15 | Pending                               | 15        |
      | SG - Bucket 23 | SG - 2 Max return attempts <Max PETS> | 23        |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op