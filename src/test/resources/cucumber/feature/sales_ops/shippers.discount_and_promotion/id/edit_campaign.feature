@OperatorV2 @LaunchBrowser @DiscountAndPromotionID @SalesOpsID @EditCampaignID

Feature: Edit Campaign

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCampaign @PassRN
  Scenario: Edit Pending Campaign - Add Multiple Valid Rules to Campaign - Percentage Discount Value with 2 Decimal Places - ID
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Campaign Rule Add button
    Then Operator enter "2" campaign rule using data below:
      | serviceType | serviceLevel | discountValue |
      | Document;   | Standard;    | 11.25;        |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been updated successfully." in Campaign Page
    Then Operator verifies "2" the published campaign rule