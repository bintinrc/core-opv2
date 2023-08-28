@OperatorV2 @LaunchBrowser @DiscountAndPromotion @SalesOps @ViewListOfCampaignUser1 @User1

Feature: Discount and Promotion

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View List of Campaign - All Campaign - User only have view access
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator verifies columns in Discounts & Promotion Page
    And Operator verifies Create new campaign button is not disabled in Campaign page
    And Operator verifies campaign count present in Discounts & Promotion Page
    When Operator click Create new campaign button in Discounts & Promotion Page
#    Step 11-14 skipped as we don't verify color