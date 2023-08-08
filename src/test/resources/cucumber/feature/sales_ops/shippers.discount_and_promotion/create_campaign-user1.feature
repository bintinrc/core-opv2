@OperatorV2 @LaunchBrowser @DiscountAndPromotion @SalesOps @CreateCampaignUser1 @User1

Feature: Create Campaign

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create New Campaign - User Only Have View Access
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 50;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Access token verification failed: insufficient permissions (required scopes: INTERNAL_SERVICE, ALL_ACCESS, CAMPAIGN_ADMIN)" in Campaign Page