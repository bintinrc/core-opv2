@OperatorV2 @LaunchBrowser @DiscountAndPromotion @SalesOps @EditCampaign

Feature: Add Remove Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Success Add Shippers - Select Shippers - Search by Shippers (uid:d3450b5b-d869-43b3-837b-0a5762f98161)
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page
    Given DB Operator verifies shipper is assigned to campaign successfully

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Success Add Shippers - Select Shippers - Bulk Upload (uid:653457ac-1edb-4b14-a10b-a00493d8a657)
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat Rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID}"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page
    Given DB Operator verifies shipper is assigned to campaign successfully