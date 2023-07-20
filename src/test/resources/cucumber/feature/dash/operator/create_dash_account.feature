@MileZero
Feature: Create Dash Account

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Trigger create dash account (uid:7987167a-9c65-47eb-95f0-5c751f0e1cb9)
    Given API Operator create new 'normal' shipper
    When Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator creates dash account with 'Create Dash Account'
    And Operator save changes on Edit Shipper Page
    And Operator refresh page
    Then Operator go to menu Shipper -> All Shippers
    And Operator login to Ninja Dash as shipper "{KEY_CREATED_SHIPPER.name}" from All Shippers page

  @DeleteNewlyCreatedShipper @CloseNewWindows
  Scenario: Edit shipper email with already existing email to trigger create dash account - error (uid:2cb2e94e-7f50-4ee2-acbc-b7590a5bab19)
    Given API Operator create new 'normal' shipper
    When Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator fill shipper basic settings:
      | shipperEmail | {postpaid-normal-username} |
    And Operator creates dash account with 'Create Dash Account'
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                     |
      | bottom | ^.*An account has already been created with this email. Please try again with a different email address.* |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op