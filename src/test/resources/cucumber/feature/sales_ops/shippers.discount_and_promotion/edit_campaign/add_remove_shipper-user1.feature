@OperatorV2 @LaunchBrowser @DiscountAndPromotion @SalesOps @EditCampaignUser1 @AddRemoveShippers @User1

Feature: Add Remove Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add Shippers - User Only Have View Access
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first "Pending" campaign
    And Operator verifies Campaign is Pending
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "id-911575" and select the created shipper
    Then Operator verifies error message is "Access token verification failed: insufficient permissions (required scopes: INTERNAL_SERVICE, ALL_ACCESS, SHIPPER_GET_SHIPPER)"

  Scenario: Remove Shippers - User Only Have View Access
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first "Pending" campaign
    And Operator verifies Campaign is Pending
    When Operator clicks on Shippers Remove button
    And Operator clicks on Search by Shipper tab
    Then Operator search using "id-911575" and select the created shipper
    And Operator verifies error message is "Access token verification failed: insufficient permissions (required scopes: INTERNAL_SERVICE, ALL_ACCESS, SHIPPER_GET_SHIPPER)"