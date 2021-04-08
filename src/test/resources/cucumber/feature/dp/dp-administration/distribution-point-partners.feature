@OperatorV2 @DpAdministration @DistributionPointPartners @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Point Partners

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDpPartner
  Scenario: DP Administration - Create DP Partner (uid:b12cc97d-4764-4870-ac54-781e7c7970e5)
    Given Operator go to menu Distribution Points -> DP Administration
    Given Operator add new DP Partner on DP Administration page with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Then Operator verify new DP Partner params

  @DeleteDpPartner
  Scenario: DP Administration - Update DP Partner (uid:cb1ca5de-be07-4a3b-903e-955bf19dd2b1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator update created DP Partner on DP Administration page with the following attributes:
      | pocName      | UPDATED-TEST                                 |
      | pocTel       | GENERATED                                    |
      | pocEmail     | GENERATED                                    |
      | restrictions | UPDATED Created for test automation purposes |
    Then Operator verify new DP Partner params

  @DeleteDpPartner
  Scenario: DP Administration - Download CSV DP Partners (uid:ccd24e58-8ae7-4410-8d20-831b6da979b1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator get first 10 DP Partners params on DP Administration page
    When Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct DP Partners data

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
