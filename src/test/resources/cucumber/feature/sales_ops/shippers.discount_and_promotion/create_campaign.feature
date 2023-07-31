@OperatorV2 @LaunchBrowser @DiscountAndPromotion @SalesOps @CreateCampaign

Feature: Create Campaign

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCampaign
  Scenario: Success Create New Campaign - No Description (uid:6bd9c606-8caf-465c-9152-df7f6a188392)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page

  @DeleteCampaign
  Scenario: Success Create New Campaign - Input one rule (uid:b9c4cda4-a08b-4967-b422-ff6558219934)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page

  @DeleteCampaign
  Scenario: Success Create New Campaign - Input Discount Decimal (uid:170ee9ff-49c0-4a18-9b2e-c45d750f5e79)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10.5;         |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page

  @DeleteCampaign
  Scenario: Success Create New Campaign - Multiple rules - All Possible Rules (uid:ab940861-b55f-4667-b298-bf18b8bd23d1)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType                                                     | serviceLevel                                                          | discountValue             |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;Parcel;Parcel;Parcel;Document;Document;Document;Document | Standard;Express;Same Day;Next Day;Standard;Express;Same Day;Next Day | 5;1.2;3.2;2;3.1;4;1.9;2.2 |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page

  Scenario: Create New Campaign - Cancel when Create Campaign (uid:92aa7d4a-9039-4164-97bb-bcb53273fd37)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on cancel button
    Then Operator verifies campaign is not created

  Scenario: Create New Campaign - Input Long Campaign Name - More than 50 Characters (uid:2765d2a9-4df3-472b-b64e-9c2d9f27a86c)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                            | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | {campaign-name-more-than-50-characters} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    Then Operator verifies campaign name is not exceeded 50

  Scenario: Create New Campaign - Input Long Description - More than 255 Characters (uid:56eca15a-4644-44fc-b8c1-e7e3e5086403)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription                             | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | {campaign-description-more-than-255-characters} | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    Then Operator verifies campaign description is not exceeded 255

  Scenario: Create New Campaign - Empty Campaign Name (uid:1dd4d130-d4ba-41e5-b991-57b80c19e2f8)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      |              | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-name-empty"

  @DeleteCampaign
  Scenario: Create New Campaign - Campaign Name Already Existed (uid:0c114584-3441-4f56-a6a9-fa96bd54ac01)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    And Operator clicks on cancel button
    And Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                            | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | {KEY_CAMPAIGN_NAME_OF_CREATED_CAMPAIGN} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies toast error for duplicate campaigns

  Scenario: Create New Campaign - Not Select Start Date (uid:d471135c-961e-4501-aa0f-76f2f7063a35)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   |           | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-start-date-empty"

  Scenario: Create New Campaign - Not Select End Date (uid:7c0e548c-44d6-4370-b347-185d539358e8)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} |         | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-end-date-empty"

  Scenario: Create New Campaign - End date < Start date (uid:f7fc9ca0-522a-4231-9cc0-f6aa474a3d0f)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-2-day-yyyy-MM-dd} | {gradle-next-1-day-yyyy-MM-dd} | Parcel;     | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-end-date-is-before-start-date"

  Scenario: Create New Campaign - Not Select Service Type (uid:26e8c187-d2bc-41dd-b315-02af203e77ea)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} |             | Standard;    | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-service-type-empty"

  Scenario: Create New Campaign - Not Select Service Level (uid:09ecf593-c77a-4c57-b4e5-63d7151d198a)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     |              | 5;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-service-level-empty"

  Scenario: Create New Campaign - Not Input Discount (uid:8c79e321-78fe-4f5a-bfe3-76d00864e713)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    |               |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-empty"

  Scenario: Create New Campaign - Input Discount > 2 Decimal Places (uid:cef46388-0eb0-4649-b414-f291d7d016d9)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | 1.111;        |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-more_than-2-decimal-points"

  Scenario: Create New Campaign - Discount - Input 0 (uid:0c7a2d59-bca7-495c-bfad-cac621c4f29e)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | 0;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-0"

  Scenario: Create New Campaign - Discount - Input Characters (uid:ed24ef9e-bf8e-400f-be0a-39c4c14b5229)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | -;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-characters"

  Scenario: Create New Campaign - Discount - Input Alphabets (uid:c2ea4d7c-6968-4791-86e7-df082d5b2246)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | e;            |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-alphabets"

  Scenario: Create New Campaign - Discount - Input Negative Value (uid:e74f28e6-fb1d-4e2a-95e9-a708afeee3a7)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;     | Standard;    | -1;           |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-negative"

  Scenario: Create New Campaign - Discount - Input > 100% Percentage (uid:502af0aa-0dad-4e73-b162-8055c07e566e)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Percentage       | Parcel;     | Standard;    | 101;          |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-discount-value-more-than-100%"

  Scenario: Create New Campaign - Not input any campaign rules (uid:7833c376-9adc-4e27-89d9-d86289308148)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} |             |              |               |
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-service-type-empty"
    And Operator verifies validation error message for "campaign-service-level-empty"
    And Operator verifies validation error message for "campaign-discount-value-empty"

  Scenario: Create New Campaign - Input Same Service Type and Service Level in One Campaign (uid:ed6041c0-48b3-4f5e-ad73-5d5437f99ee7)
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | serviceType   | serviceLevel      | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | dummy description   | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Parcel;Parcel | Standard;Standard | 10;10         |
    When Operator clicks on publish button
    And Operator verifies validation error message for "campaign-same-rule"
