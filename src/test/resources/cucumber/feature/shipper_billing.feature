@OperatorV2 @OperatorV2Part1 @ShipperBilling @Saas
Feature: Shipper Billing

  @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add Amount For Prepaid Account (uid:08faffa1-be91-4f18-9d9d-f1926ac7df5d)
    Given Operator go to menu Shipper Support -> Shipper Billing
    When Operator add amount on Shipper Billing page using data below:
      | shipperId   | {shipper-v4-prepaid-legacy-id}                |
      | shipperName | {shipper-v4-prepaid-name}                     |
      | amount      | 10                                            |
      | reason      | Bank Transfer                                 |
      | comment     | Add Amount for testing purposes {{unique-id}} |
    Given API Ninja Dash init with username = "{shipper-v4-prepaid-email}" and password = "{shipper-v4-prepaid-password}"
    Then API Dash user verify created record in shipper billing history

  Scenario: Deduct Amount For Prepaid Shipper (uid:2d72f9c0-3ec1-47bb-848a-98b73912d439)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Shipper Billing
    When Operator deduct amount on Shipper Billing page using data below:
      | shipperId   | {shipper-v4-prepaid-legacy-id}                   |
      | shipperName | {shipper-v4-prepaid-name}                        |
      | amount      | 10                                               |
      | reason      | Bank Transfer                                    |
      | comment     | Deduct Amount for testing purposes {{unique-id}} |
    Given API Ninja Dash init with username = "{shipper-v4-prepaid-email}" and password = "{shipper-v4-prepaid-password}"
    Then API Dash user verify created record in shipper billing history

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
