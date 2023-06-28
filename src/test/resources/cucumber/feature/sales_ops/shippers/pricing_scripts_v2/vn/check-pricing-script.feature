@OperatorV2 @LaunchBrowser @PricingScriptsV2VN @SalesOpsVN @CheckPricingScriptVN
Feature: Check Pricing Script

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Check Script - VN Shopee Script - <datasetName>
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id-Shopee-VN}"
    And Operator do Run Check on specific Active Script using this data below:
      | weight   | <weight>   |
      | fromZone | <fromZone> |
      | toZone   | <toZone>   |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | <grandTotal>  |
      | gst          | <gst>         |
      | deliveryFee  | <deliveryFee> |
      | insuranceFee | 0             |
      | codFee       | 0             |
      | handlingFee  | 0             |
      | rtsFee       | 0             |
      | comments     | OK            |

    Examples:
      | fromZone             | toZone             | weight | grandTotal | gst | deliveryFee | datasetName                 |
      | S-HCMSUB2-CAN-GIO    | S-HCMMETRO-D1      | 0.25   | 11000      | 0   | 11000       | Urban Intra Metro Next Day  |
      | C-DNGMETRO-THANH-KHE | N-CABSUB2-HA-QUANG | 8.4    | 137266     | 0   | 137266      | Sub2 Cross Central Next Day |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op