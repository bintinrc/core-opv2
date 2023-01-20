@OperatorV2 @LaunchBrowser @DiscountAndPromotionVN @SalesOpsVN @CreateCampaignVN

Feature: Create Campaign

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCampaign
  Scenario: Success Create New Campaign - Input one rule - VN (uid:476ea561-a350-42a4-954a-3cfe915bf2f0)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page