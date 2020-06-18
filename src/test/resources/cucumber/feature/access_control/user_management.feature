@OperatorV2 @AccessControl @OperatorV2Part1 @UserManagement @Saas
Feature: User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @SoftDeleteOauthClientByEmailAddress
  Scenario: Operator adding new user on User Management page (uid:f8eae1ec-35d2-4c99-929e-837aa8c0912e)
    Given Operator go to menu Access Control -> User Management
    When Operator create new user on User Management page
    Then Operator verify the new user on User Management page

  @SoftDeleteOauthClientByEmailAddress
  Scenario: Operator editing user on User Management page (uid:e4ec4c61-46d3-4eae-96bb-c1a903987054)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> User Management
    When Operator create new user on User Management page
    Then Operator verify the new user on User Management page
    When Operator edit a user on User Management page
    Then Operator verify the edited user on User Management page is existed

  @SoftDeleteOauthClientByEmailAddress
  Scenario: Operator search user on User Management page (uid:5d065612-3643-4450-8d54-d364cda9baae)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> User Management
    When Operator create new user on User Management page
    Then Operator verify the new user on User Management page

  Scenario: Operator filtering user using Grant Types Filter on User Management Page (uid:ccc9b048-0d28-4d3f-9667-a2ca6a74d491)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> User Management
    When Operator filling the Grant Type Field with value "Google" on User Management page and load the data
    Then Operator verify the result on the table has the same Grant Type that has been input

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
