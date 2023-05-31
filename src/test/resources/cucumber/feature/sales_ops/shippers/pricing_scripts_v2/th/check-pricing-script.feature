@OperatorV2 @LaunchBrowser @PricingScriptsV2TH @SalesOpsTH @CheckPricingScriptTH
Feature: Check Pricing Script

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Check Script Successfully - TH
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id-all}"
    And Operator do Run Check on specific Active Script using this data below:
      | codValue     | 500     |
      | insuredValue | 100     |
      | weight       | 1       |
      | size         | S       |
      | fromZone     | BKK     |
      | toZone       | CENTRAL |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 22.84 |
      | gst          | 0.84  |
      | deliveryFee  | 9     |
      | insuranceFee | 2     |
      | codFee       | 10    |
      | handlingFee  | 1     |
      | rtsFee       | 0     |
      | comments     | OK    |

  Scenario: Check Script Successfully - Pricing Script Has Legacy Params and Dimensions Calculation - Send L+W+H - TH
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id-legacy-dim-threshold}"
    And Operator do Run Check on specific Active Script using this data below:
      | orderFields  | New      |
      | serviceLevel | Next Day |
      | serviceType  | Parcel   |
      | weight       | 1        |
      | length       | 45       |
      | width        | 70       |
      | height       | 45       |
      | fromZone     | BKK      |
      | toZone       | BKK      |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 376 |
      | gst          | 0   |
      | deliveryFee  | 376 |
      | insuranceFee | 0   |
      | codFee       | 0   |
      | handlingFee  | 0   |
      | rtsFee       | 0   |
      | comments     | OK  |

  Scenario: Check Script Successfully - Pricing Script Has Legacy Params and Dimensions Calculation - Not Send L+W+H - TH
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id-legacy-dim-threshold}"
    And Operator do Run Check on specific Active Script using this data below:
      | orderFields  | New      |
      | serviceLevel | Next Day |
      | serviceType  | Parcel   |
      | weight       | 10       |
      | length       | 0        |
      | width        | 0        |
      | height       | 0        |
      | fromZone     | BKK      |
      | toZone       | CENTRAL  |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 176 |
      | gst          | 0   |
      | deliveryFee  | 176 |
      | insuranceFee | 0   |
      | codFee       | 0   |
      | handlingFee  | 0   |
      | rtsFee       | 0   |
      | comments     | OK  |

  Scenario: Check Script Successfully - Pricing Script Has Legacy Params and Dimensions Calculation - Only Send Width and Height - TH
    Given Operator go to menu Shipper -> Pricing Scripts V2
    And Operator search custom script id "{pricing-script-id-legacy-dim-threshold}"
    And Operator do Run Check on specific Active Script using this data below:
      | orderFields  | New      |
      | serviceLevel | Next Day |
      | serviceType  | Parcel   |
      | weight       | 10       |
      | length       | 0        |
      | width        | 50       |
      | height       | 80       |
      | fromZone     | BKK      |
      | toZone       | CENTRAL  |
    Then Operator verify the Run Check Result is correct using data below:
      | grandTotal   | 269 |
      | gst          | 0   |
      | deliveryFee  | 269 |
      | insuranceFee | 0   |
      | codFee       | 0   |
      | handlingFee  | 0   |
      | rtsFee       | 0   |
      | comments     | OK  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op