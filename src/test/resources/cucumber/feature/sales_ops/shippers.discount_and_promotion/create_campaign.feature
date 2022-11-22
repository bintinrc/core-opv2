@OperatorV2 @LaunchBrowser @DiscountAndPromotion @SalesOps @CreateCampaign

Feature: Create Campaign

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCampaign
  Scenario: Success Create New Campaign - No Description (uid:6bd9c606-8caf-465c-9152-df7f6a188392)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page

  @DeleteCampaign
  Scenario: Success Create New Campaign - Input one rule (uid:b9c4cda4-a08b-4967-b422-ff6558219934)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page

  @DeleteCampaign
  Scenario: Success Create New Campaign - Input Discount Decimal (uid:170ee9ff-49c0-4a18-9b2e-c45d750f5e79)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 10.5;         |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page

  @DeleteCampaign
  Scenario: Success Create New Campaign - Multiple rules - All Possible Rules (uid:ab940861-b55f-4667-b298-bf18b8bd23d1)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType                                                     | serviceLevel                                                          | discountValue             |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;Parcel;Parcel;Parcel;Document;Document;Document;Document | Standard;Express;Same Day;Next Day;Standard;Express;Same Day;Next Day | 5;1.2;3.2;2;3.1;4;1.9;2.2 |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
