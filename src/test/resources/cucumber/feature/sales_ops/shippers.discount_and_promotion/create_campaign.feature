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

  Scenario: Create New Campaign - Cancel when Create Campaign
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on cancel button
    Then Operator verifies campaign is not created

  Scenario: Create New Campaign - Input Long Campaign Name - More than 50 Characters
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                            | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | {campaign-name-more-than-50-characters} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    Then Operator verifies campaign name is not exceeded 50

  Scenario: Create New Campaign - Input Long Description - More than 255 Characters
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription                             | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | {campaign-description-more-than-255-characters} | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    Then Operator verifies campaign description is not exceeded 255

  Scenario: Create New Campaign - Empty Campaign Name
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      |              | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-name-empty"

  @DeleteCampaign
  Scenario: Create New Campaign - Campaign Name Already Existed
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    And Operator clicks on cancel button
    And Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                            | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | {KEY_CAMPAIGN_NAME_OF_CREATED_CAMPAIGN} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies toast error for duplicate campaigns

  Scenario: Create New Campaign - Not Select Start Date
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   |           | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-start-date-empty"

  Scenario: Create New Campaign - Not Select End Date
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} |         | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-end-date-empty"

  Scenario: Create New Campaign - End date < Start date
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                       | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-10-day-yyyy-MM-dd} | {gradle-next-1-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-end-date-is-before-start-date"

  Scenario: Create New Campaign - Not Select Service Type
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} |             | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-service-type-empty"

  Scenario: Create New Campaign - Not Select Service Level
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     |              | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-service-level-empty"

  Scenario: Create New Campaign - Not Input Discount
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    |               |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-empty"

  Scenario: Create New Campaign - Input Discount > 2 Decimal Places
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 1.111;        |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-more_than-2-decimal-points"

  Scenario:Create New Campaign - Discount - Input 0
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | 0;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-0"

  Scenario:Create New Campaign - Discount - Input Characters
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | -;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-characters"

  Scenario:Create New Campaign - Discount - Input Alphabets
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | e;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-alphabets"

  Scenario:Create New Campaign - Discount - Input Negative Value
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Parcel;     | Standard;    | -1;           |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-negative"

  Scenario:Create New Campaign - Discount - Input > 100% Percentage
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Percentage       | Parcel;     | Standard;    | 101;          |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-more-than-100%"

  Scenario:Create New Campaign - Not input any campaign rules
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} |             |              |               |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-service-type-empty"
    And Operator verifies validation error message for "campaign-service-level-empty"
    And Operator verifies validation error message for "campaign-discount-value-empty"