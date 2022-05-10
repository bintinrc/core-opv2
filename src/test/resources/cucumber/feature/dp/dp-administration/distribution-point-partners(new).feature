@OperatorV2 @DpAdministration @DistributionPointPartnersReact @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Point Partners

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDpPartner
  Scenario: DP Administration - Download CSV DP Partners (uid:ccd24e58-8ae7-4410-8d20-831b6da979b1)
    Given Operator go to menu Distribution Points -> DP Administration (New)
    When Operator get first 10 DP Partners params on DP Administration page
    When Operator click on Download CSV File button on DP Administration React page
    Then Downloaded CSV file contains correct DP Partners data

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: DP Administration - Search DP partner
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration (New)
    And Operator Search with Some DP Partner Details :
      | searchDetails | id,name,pocName,pocTel,pocEmail,restrictions |