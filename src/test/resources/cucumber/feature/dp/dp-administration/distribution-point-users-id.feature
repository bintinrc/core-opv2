@OperatorV2 @DpAdministration @DistributionPointUsersReact @OperatorV2Part1 @DpAdministrationV2 @DP @CWF
Feature: DP Administration - Distribution Point Users

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
#    Given Operator change the country into "Indonesia"

  @DeleteDpManagementPartnerDpAndDpUser @RT
  Scenario: DP Administration - Delete Dp User - Wrong DP Partner (uid:16a7cf1b-6778-48de-b69e-7ef163edc71c)
    When API Operator whitelist email "{check-dp-user-email}"
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id" with value "{check-partner-id}"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id" with value "{check-dp-id}"
    Then Operator press view DP User Button
    Then The Dp page is displayed
    And Operator press add user Button
    When Operator Fill Dp User Details below :
      | firstName | lastName | contactNo | emailId               |
      | Diaz      | Ilyasa   | GENERATED | {check-dp-user-email} |
    Then Operator press submit user button
    And Operator fill the Dp User filter by "username"