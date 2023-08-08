@OperatorV2 @LaunchBrowser @DiscountAndPromotion @SalesOps @EditCampaignUser1 @User1

Feature: Edit Campaign

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-client-id}" and password = "{operator-client-secret}"

  @DeleteCampaign
  Scenario: Edit Pending Campaign - User Only Have View Access
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first Pending campaign
    And Operator verifies Campaign is Pending
    Then Operator enter campaign details using data below:
      | endDate                         |
      | {gradle-next-10-day-yyyy-MM-dd} |
    When Operator clicks on publish button
    Then Operator verifies toast message "Access token verification failed: insufficient permissions (required scopes: INTERNAL_SERVICE, ALL_ACCESS, CAMPAIGN_ADMIN)" in Campaign Page

  @FailingDownloadButtonDisabled
  Scenario: Generate Shipper CSV - User Only Have View Access
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on campaign with name QA-Automation-Campaign-16896918867762
    And Operator verifies Campaign name input field is clickable
    And Operator verifies Campaign ID input field is not clickable
    And Operator verifies Campaign Description input field is clickable
    And Operator verifies Promotion type select field is not clickable
    And Operator verifies Discount event counter select field is not clickable
    And Operator verifies Discount fee type select field is not clickable
    And Operator verifies Disbursement event counter select field is not clickable
    And Operator verifies Start date picker field is clickable
    And Operator verifies End date picker field is clickable
    And Operator verifies Discount operator select field is clickable
    And Operator verifies Service type select field is clickable
    And Operator verifies Service level select field is clickable
    And Operator verifies Discount value picker field is clickable
    And Operator verifies Add button is not disabled
    And Operator verifies Download button is not disabled
    And Operator verifies Add button is not disabled
    And Operator verifies Remove button is not disabled
    And Operator verifies shippers count is present
    And Operator clicks on download button on Campaign Page
    And Operator verifies downloaded shippers CSV file on Campaign Page