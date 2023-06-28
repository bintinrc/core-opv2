@MileZero
Feature: Discount & Promotions Page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Create New Campaign - Flat (uid:b699dc63-978f-43c0-944e-075395d85d82)
    Given API Operator create new 'normal' shipper
    And Operator go to menu Shipper -> Discount & Promotions
    And Operator click Create new campaign button in Discounts & Promotion Page
    And Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    And Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    And Operator verifies the published campaign page
    And Operator clicks on Shippers Add button
    And Operator clicks on Search by Shipper tab
    Then Operator search and select the created shipper
    And Operator clicks on upload button
    And Operator verifies toast message "1 shippers have been successfully added." in Campaign Page
    And DB Operator verifies shipper is assigned to campaign successfully

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Create New Campaign - Percentage (uid:4f14143d-6552-49a4-8be8-61d82266756e)
    Given Operator refresh page
    Given API Operator create new 'normal' shipper
    And Operator go to menu Shipper -> Discount & Promotions
    And Operator click Create new campaign button in Discounts & Promotion Page
    And Operator enter campaign details using data below:
      | campaignName                                         | campaignDescription | startDate                      | endDate                         | discountOperator | serviceType | serviceLevel | discountValue |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-10-day-yyyy-MM-dd} | Percentage       | Parcel;     | Standard;    | 10;           |
    When Operator clicks on publish button
    And Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    And Operator verifies the published campaign page
    And Operator clicks on Shippers Add button
    And Operator clicks on Search by Shipper tab
    Then Operator search and select the created shipper
    And Operator clicks on upload button
    And Operator verifies toast message "1 shippers have been successfully added." in Campaign Page
    And DB Operator verifies shipper is assigned to campaign successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op