@OperatorV2 @LaunchBrowser @PricingScriptsV2ID @SalesOpsID
Feature: Check Pricing Script

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Check Script Successfully - ID (uid:4ae78f1e-a1e1-4bc6-acff-33c458f5b37e)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id}"
    And Operator do Run Check on specific Active Script using this data below:
      | orderFields            | Legacy       |
      | deliveryType           | STANDARD     |
      | orderType              | NORMAL       |
      | timeslotType           | NONE         |
      | isRts                  | No           |
      | size                   | S            |
      | weight                 | 1.0          |
      | insuredValue           | 0.00         |
      | codValue               | 0.00         |
      | originPricingZone      | ID_A00007_01 |
      | destinationPricingZone | ID_B00001_01 |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 66000 |
      | gst          | 660   |
      | deliveryFee  | 66000 |
      | insuranceFee | 0     |
      | codFee       | 0     |
      | handlingFee  | 0     |
      | comments     | OK    |

  Scenario: Check Scripts without Origin/Destination Pricing Zone - ID (uid:2ee37454-e70a-498d-befa-7349e187d819)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id}"
    And Operator do Run Check on specific Active Script using this data below:
      | orderFields            | Legacy   |
      | deliveryType           | STANDARD |
      | orderType              | NORMAL   |
      | timeslotType           | NONE     |
      | isRts                  | No       |
      | size                   | S        |
      | weight                 | 1.0      |
      | insuredValue           | 0.00     |
      | codValue               | 0.00     |
      | originPricingZone      | empty    |
      | destinationPricingZone | empty    |
    Then Operator verify error message
      | message  | Latitude and Longitude does not fall in a polygon |
      | response | 400 Unknown                                       |

  Scenario: Check Script with Invalid Origin Pricing Zone - ID (uid:9d79aed0-d6de-4928-a7ee-e3e4b5546c60)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id}"
    And Operator do Run Check on specific Active Script using this data below:
      | orderFields            | Legacy       |
      | deliveryType           | STANDARD     |
      | orderType              | NORMAL       |
      | timeslotType           | NONE         |
      | isRts                  | No           |
      | size                   | S            |
      | weight                 | 1.0          |
      | insuredValue           | 0.00         |
      | codValue               | 0.00         |
      | originPricingZone      | TEST         |
      | destinationPricingZone | ID_B00001_01 |
    Then Operator verify error message
      | message  | Pricing Script and Billing Zones are present, but there's no existing OD pair |
      | response | 404 Unknown                                                                   |

  Scenario: Check Script with Invalid Destination Pricing Zone - ID (uid:26be83da-3955-453c-b803-37e4708116ab)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id}"
    And Operator do Run Check on specific Active Script using this data below:
      | orderFields            | Legacy       |
      | deliveryType           | STANDARD     |
      | orderType              | NORMAL       |
      | timeslotType           | NONE         |
      | isRts                  | No           |
      | size                   | S            |
      | weight                 | 1.0          |
      | insuredValue           | 0.00         |
      | codValue               | 0.00         |
      | originPricingZone      | ID_A00007_01 |
      | destinationPricingZone | TEST         |
    Then Operator verify error message
      | message  | Pricing Script and Billing Zones are present, but there's no existing OD pair |
      | response | 404 Unknown                                                                   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op