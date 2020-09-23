@MileZero @ShipperBilling @Saas
Feature: Shipper Billing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add amount for prepaid account copy (uid:be7090d5-ba09-4bd4-956d-d18858ac2610)
    Given Operator go to menu Shipper Support -> Shipper Billing
    When Operator add amount on Shipper Billing page using data below:
      | shipperId   | {shipper-v4-prepaid-legacy-id}                |
      | shipperName | {shipper-v4-prepaid-name}                     |
      | amount      | 10                                            |
      | reason      | Bank Transfer                                 |
      | comment     | Add Amount for testing purposes {{unique-id}} |
    Given API Ninja Dash init with username = "{shipper-v4-prepaid-email}" and password = "{shipper-v4-prepaid-password}"
    Then API Dash user verify created record in shipper billing history

  Scenario: Deduct amount for prepaid shipper (uid:522f50af-9d1b-4808-a0e3-3fe2e6b9e90b)
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
