@OperatorV2Disabled @DpAdministrationV2
Feature: DP Administration

  @LaunchBrowser
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  Scenario: Operator should be able to create a new DP Partners on DP Administration page
#    Given Operator go to menu Distribution Points -> DP Administration
#    Given Operator add new DP Partner on DP Administration page with the following attributes:
#      | name         | GENERATED                            |
#      | pocName      | TEST                                 |
#      | pocTel       | GENERATED                            |
#      | pocEmail     | GENERATED                            |
#      | restrictions | Created for test automation purposes |
#    Then Operator verify new DP Partner params

  Scenario: Operator should be able to download and verify DP Partners CSV file on DP Administration page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator get all DP Partners params on DP Administration page
    When Operator get first 10 DP Partners params on DP Administration page
    When Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct PD Partners data


  @KillBrowser
  Scenario: Kill Browser
    Given no-op
