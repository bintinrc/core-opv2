@OperatorV2 @LaunchBrowser @DiscountAndPromotion @SalesOps @EditCampaign @CWF

Feature: Edit Campaign

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  
  Scenario: View Detail Campaign - Status Active
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first Active campaign
    And Operator verifies Campaign is Active
    And Operator verifies Archive this campaign button is not disabled
    And Operator verifies Campaign name input field is not clickable
    And Operator verifies Campaign ID input field is not clickable
    And Operator verifies Campaign Description input field is not clickable
    And Operator verifies Promotion type select field is not clickable
    And Operator verifies Discount event counter select field is not clickable
    And Operator verifies Discount fee type select field is not clickable
    And Operator verifies Disbursement event counter select field is not clickable
    And Operator verifies Start date picker field is not clickable
    And Operator verifies End date picker field is not clickable
    And Operator verifies Discount operator select field is not clickable
    And Operator verifies Service type select field is not clickable
    And Operator verifies Service level select field is not clickable
    And Operator verifies Discount value picker field is not clickable
    And Operator verifies Add button is disabled
    And Operator verifies Download button is disabled
    And Operator verifies Add button is not disabled
    And Operator verifies Remove button is disabled
    And Operator verifies shippers count is present

  
  Scenario: View Detail Campaign - Status Pending
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first Pending campaign
    And Operator verifies Campaign is Pending
    And Operator verifies Campaign name input field is clickable
    And Operator verifies Campaign ID input field is not clickable
    And Operator verifies Campaign Description input field is clickable
    And Operator verifies Promotion type select field is not clickable
    And Operator verifies Discount event counter select field is not clickable
    And Operator verifies Discount fee type select field is not clickable
    And Operator verifies Disbursement event counter select field is not clickable
    And Operator verifies Start date picker field is clickable
    And Operator verifies End date picker field is clickable
    And Operator verifies Discount operator select field is clickable
    And Operator verifies Service type select field is clickable
    And Operator verifies Service level select field is clickable
    And Operator verifies Discount value picker field is clickable
    And Operator verifies Add button is not disabled
    And Operator verifies Download button is disabled
    And Operator verifies Add button is not disabled
    And Operator verifies Remove button is not disabled
    And Operator verifies shippers count is present

  
  Scenario: View Detail Campaign - Status Archive
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first Archived campaign
    And Operator verifies Campaign is Archived
    And Operator verifies Campaign name input field is not clickable
    And Operator verifies Campaign ID input field is not clickable
    And Operator verifies Campaign Description input field is not clickable
    And Operator verifies Promotion type select field is not clickable
    And Operator verifies Discount event counter select field is not clickable
    And Operator verifies Discount fee type select field is not clickable
    And Operator verifies Disbursement event counter select field is not clickable
    And Operator verifies Start date picker field is not clickable
    And Operator verifies End date picker field is not clickable
    And Operator verifies Discount operator select field is not clickable
    And Operator verifies Service type select field is not clickable
    And Operator verifies Service level select field is not clickable
    And Operator verifies Discount value picker field is not clickable
    And Operator verifies Add button is disabled
    And Operator verifies Download button is disabled
    And Operator verifies Add button is disabled
    And Operator verifies Remove button is disabled
    And Operator verifies shippers count is present

  
  Scenario: View Detail Campaign - Status Expired
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first Expired campaign
    And Operator verifies Campaign is Expired
    And Operator verifies Campaign name input field is not clickable
    And Operator verifies Campaign ID input field is not clickable
    And Operator verifies Campaign Description input field is not clickable
    And Operator verifies Promotion type select field is not clickable
    And Operator verifies Discount event counter select field is not clickable
    And Operator verifies Discount fee type select field is not clickable
    And Operator verifies Disbursement event counter select field is not clickable
    And Operator verifies Start date picker field is not clickable
    And Operator verifies End date picker field is not clickable
    And Operator verifies Discount operator select field is not clickable
    And Operator verifies Service type select field is not clickable
    And Operator verifies Service level select field is not clickable
    And Operator verifies Discount value picker field is not clickable
    And Operator verifies Add button is disabled
    And Operator verifies Download button is disabled
    And Operator verifies Add button is disabled
    And Operator verifies Remove button is disabled
    And Operator verifies shippers count is present

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Add New Rules Fields - Verifies New Rules Fields is Mandatory
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Campaign Rule Add button
    Then Operator verifies new row of Service type, Service level, and Discount value box fields
    When Operator clicks on publish button
    Then Operator verifies validation error message for "campaign-service-type-empty"
    And Operator verifies validation error message for "campaign-service-level-empty"
    And Operator verifies validation error message for "campaign-discount-value-empty"

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Add Multiple Valid Rules to Campaign - Flat Discount Value with 2 Decimal Places
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

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Add Valid Rules to Campaign - Flat Discount Value with > 2 Decimal Places
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
      | Document;   | Standard;    | 11.258;       |
    When Operator clicks on publish button
    And Operator verifies validation error message for "campaign-discount-value-more_than-2-decimal-points"

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Add Same Rules As The Existing Rules
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
      | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    And Operator verifies validation error message for "campaign-same-rule"

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Update Existing Rules Service Level
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    Then Operator enter "1" campaign rule using data below:
      | serviceType | serviceLevel | discountValue |
      | Parcel;     | Express;     | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been updated successfully." in Campaign Page
    Then Operator verifies "1" the published campaign rule

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Update Existing Rules Service Type
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    Then Operator enter "1" campaign rule using data below:
      | serviceType | serviceLevel | discountValue |
      | Document;   | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been updated successfully." in Campaign Page
    Then Operator verifies "1" the published campaign rule

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Update Existing Rules Discount Value
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    Then Operator enter "1" campaign rule using data below:
      | serviceType | serviceLevel | discountValue |
      | Parcel;     | Standard;    | 11.23;        |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been updated successfully." in Campaign Page
    Then Operator verifies "1" the published campaign rule

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Update Existing Rules Discount Value to More Than 100%
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Percentage       | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    Then Operator enter "1" campaign rule using data below:
      | serviceType | serviceLevel | discountValue |
      | Parcel;     | Standard;    | 123;          |
    When Operator clicks on publish button
    And Operator verifies validation error message for "campaign-discount-value-more-than-100%"

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Remove One Rule from Campaign - Campaign Has Multiple Rules
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType    | serviceLevel      | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;Parcel; | Standard;Express; | 10;12;        |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on remove button for "2" Campaign rule
    Then Operator clicks on publish button
    And Operator verifies total Campaign Rule rows should be 1

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Remove All Rules from Campaign - Campaign Has Multiple Rules
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType    | serviceLevel      | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;Parcel; | Standard;Express; | 10;12;        |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on remove button for "2" Campaign rule
    When Operator verify remove button for "1" Campaign rule
    Then Operator clicks on publish button
    And Operator verifies total Campaign Rule rows should be 1

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Update Campaign Name
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType    | serviceLevel      | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;Parcel; | Standard;Express; | 10;12;        |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator waits for 5 seconds
    Then Operator enter campaign details using data below:
      | campaignName                                                |
      | Dummy Campaign Update {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been updated successfully." in Campaign Page
    Then Operator verifies campaign name is updated on campaign page

  @DeleteCampaign
  Scenario: Edit Pending Campaign - Update Campaign Name With The Same Name As Existing Campaign
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType    | serviceLevel      | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;Parcel; | Standard;Express; | 10;12;        |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator waits for 5 seconds
    Then Operator enter campaign details using data below:
      | campaignName                          |
      | QA-Automation-Campaign-16896054118894 |
    When Operator clicks on publish button
    Then Operator verifies toast message "failed to update campaign QA-Automation-Campaign-16896054118894: name already exists" in Campaign Page

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Remove Campaign Name
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType    | serviceLevel      | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;Parcel; | Standard;Express; | 10;12;        |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator waits for 5 seconds
    Then Operator enter campaign details using data below:
      | campaignName |
      | blank        |
    And Operator verifies validation error message for "campaign-name-empty"

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Update Campaign Description
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator waits for 5 seconds
    Then Operator enter campaign details using data below:
      | campaignDescription |
      | Test Description    |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been updated successfully." in Campaign Page
    Then Operator verifies campaign description is updated on campaign page

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Remove Campaign Description
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} | Test Description    | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator waits for 5 seconds
    Then Operator enter campaign details using data below:
      | campaignDescription |
      | blank               |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been updated successfully." in Campaign Page
    Then Operator verifies campaign description is updated on campaign page

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Update Campaign Start Date
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator waits for 5 seconds
    Then Operator enter campaign details using data below:
      | startDate                      |
      | {gradle-next-2-day-yyyy-MM-dd} |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been updated successfully." in Campaign Page
    Then Operator verifies start date is updated on campaign page

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Update Campaign Start Date > End Date Date
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-3-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator waits for 5 seconds
    Then Operator enter campaign details using data below:
      | startDate                       |
      | {gradle-next-10-day-yyyy-MM-dd} |
    When Operator clicks on publish button
    And Operator verifies validation error message for "campaign-end-date-is-before-start-date"

  @DeleteCampaign 
  Scenario: Edit Pending Campaign - Update Campaign End Date
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-3-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator waits for 5 seconds
    Then Operator enter campaign details using data below:
      | endDate                         |
      | {gradle-next-10-day-yyyy-MM-dd} |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been updated successfully." in Campaign Page
    Then Operator verifies end date is updated on campaign page