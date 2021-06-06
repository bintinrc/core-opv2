@OperatorV2Disabled @Shipper @OperatorV2Part2Disabled @LaunchBrowser @ShouldAlwaysRun @PricingScriptsV2 @SalesOps
Feature: Check Pricing Script

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Check Script without From Zone and To Zone - SG (uid:593e727f-9d77-4da7-af91-36156852d73d)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id-3}"
    And Operator do Run Check on specific Draft Script using this data below:
      | orderFields    | Legacy   |
      | deliveryType   | STANDARD |
      | orderType      | NORMAL   |
      | timeslotType   | NONE     |
      | isRts          | No       |
      | size           | S        |
      | weight         | 1.0      |
      | insuredValue   | 0.00     |
      | codValue       | 0.00     |
      | isActiveScript | Yes      |
      | fromZone       |          |
      | toZone         |          |
    Then Operator verify error message
      | message  | Latitude and Longitude does not fall in a polygon |
      | response | 400 Unknown                                       |

  Scenario: Check Script without From Zone and To Zone - SG (uid:593e727f-9d77-4da7-af91-36156852d73d)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id-3}"
    And Operator do Run Check on specific Draft Script using this data below:
      | orderFields              | Legacy   |
      | deliveryType             | STANDARD |
      | orderType                | NORMAL   |
      | timeslotType             | NONE     |
      | isRts                    | No       |
      | size                     | S        |
      | weight                   | 1.0      |
      | insuredValue             | 0.00     |
      | codValue                 | 0.00     |
      | isActiveScript           | Yes      |
      | fromZone                 | WEST     |
      | toZone                   | EAST     |
      | originPricingScript      |          |
      | destinationPricingScript |          |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 11.235 |
      | gst          | 0.735  |
      | deliveryFee  | 10.5   |
      | insuranceFee | 0      |
      | codFee       | 0      |
      | handlingFee  | 0      |
      | comments     | OK     |