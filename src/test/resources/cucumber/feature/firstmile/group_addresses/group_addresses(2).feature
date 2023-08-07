@FirstMile @AddressesGrouping @SG
Feature: Shipper Address Configuration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Success Group Addresses
    Given Operator loads Group Addresses page
    When Operator search address "jalan kilang barat" on Group Addresses page

