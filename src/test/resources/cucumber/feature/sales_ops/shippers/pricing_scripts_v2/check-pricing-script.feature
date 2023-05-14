@OperatorV2 @LaunchBrowser @PricingScriptsV2 @SalesOps @CheckPricingScript
Feature: Check Pricing Script

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Check Script without From Zone and To Zone - SG (uid:593e727f-9d77-4da7-af91-36156852d73d)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id-all}"
    And Operator do Run Check on specific Active Script using this data below:
      | orderFields  | Legacy   |
      | deliveryType | Standard |
      | orderType    | Normal   |
      | timeslotType | None     |
      | isRts        | No       |
      | size         | S        |
      | weight       | 1.0      |
      | insuredValue | 0.00     |
      | codValue     | 0.00     |
    Then Operator verify error message
      | message  | Error Message: Latitude, Longitude and Billing Zones are not provided |
      | response | Status: 400 Unknown                                                   |


  Scenario: Check Script Successfully without Origin/Destination Pricing Zone - SG (uid:52e2ee8b-617f-44e5-8bb6-e9e82aeaef4d)
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id-all}"
    And Operator do Run Check on specific Active Script using this data below:
      | orderFields            | Legacy   |
      | deliveryType           | Standard |
      | orderType              | Normal   |
      | timeslotType           | None     |
      | isRts                  | No       |
      | size                   | S        |
      | weight                 | 1.0      |
      | insuredValue           | 0.00     |
      | codValue               | 0.00     |
      | fromZone               | WEST     |
      | toZone                 | EAST     |
      | originPricingZone      | empty    |
      | destinationPricingZone | empty    |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 11.34 |
      | gst          | 0.84  |
      | deliveryFee  | 10.5  |
      | insuranceFee | 0     |
      | codFee       | 0     |
      | handlingFee  | 0     |
      | rtsFee       | 0     |
      | comments     | OK    |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op