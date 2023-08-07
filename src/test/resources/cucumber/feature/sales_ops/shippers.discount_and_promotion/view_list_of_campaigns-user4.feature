@OperatorV2 @LaunchBrowser @DiscountAndPromotion @SalesOps @ViewListOfCampaignUser4 @user4

Feature: Discount and Promotion

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View List of Campaign - All Campaign - User have no access
    Given Operator go to menu Shipper -> Discount & Promotions
    Then Operator verifies error message is "Access token verification failed: insufficient permissions (required scopes: INTERNAL_SERVICE, ALL_ACCESS, SHIPPER_GET_SHIPPER, SHIPPER_ADMIN)"