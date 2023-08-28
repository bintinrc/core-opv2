@OperatorV2 @LaunchBrowser @DiscountAndPromotion @SalesOps @EditCampaign @AddRemoveShippers

Feature: Add Remove Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Success Add Shippers - Select Shippers - Search by Shippers (uid:d3450b5b-d869-43b3-837b-0a5762f98161)
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "Name" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Success Add Shippers - Select Shippers - Bulk Upload (uid:653457ac-1edb-4b14-a10b-a00493d8a657)
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID}"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Add Shippers - Select Shippers - Search by Shippers - Invalid Shipper ID
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "Invalid Shipper ID" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "No shipper was selected." in Campaign Page
    Then Operator verifies Shipper count is "0 Shippers"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Add Shippers - Select Shippers - Search by Shippers - Search Shipper by Name - Remove Selected Shipper
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "Name" and select the created shipper
    And Operator removes selected shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "No shipper was selected." in Campaign Page
    Then Operator verifies Shipper count is "0 Shippers"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Add Shippers - Select Shippers - Search by Shippers - Select Shipper that Already Added
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "Name" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page
    Given DB Operator verifies shipper is assigned to campaign successfully
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "Name" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies error message is "Error Message: Cannot add shipper(s): duplicate entries for this campaign or already exists in another campaign with overlapping date"

  @DeleteCampaign
  Scenario: Add Shippers - Select Shippers - Bulk Upload - Upload Invalid Shipper ID
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    Then Operator verifies 'Add Shipper' modal is displayed
    And Operator verifies "Bulk upload" is default selected tab
    And Operator verifies Browse button is not disabled
    And Operator verifies Cancel button is not disabled
    And Operator verifies Upload button is not disabled
    When Operator uploads csv file with "9999999"
    When Operator clicks on upload button
    Then Operator verifies toast message "No shipper was selected." in Campaign Page
    Then Operator verifies Shipper count is "0 Shippers"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Remove Shippers - Select Shippers - Bulk Upload - Upload CSV File that Contains Shipper ID That Not Added to The Campaign
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Remove button
    Then Operator verifies "Remove shipper" modal is displayed
    And Operator verifies "Bulk upload" is default selected tab
    And Operator verifies Browse button is not disabled
    And Operator verifies Cancel button is not disabled
    And Operator verifies Upload button is not disabled
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID}"
    When Operator clicks on upload button
    Then Operator verifies error message is "Error Message: unable to delete shipper(s) from campaign: invalid shipper(s)"
    Then Operator verifies Shipper count is "0 Shippers"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Success Remove Shippers - Select Shippers - Search by Shippers
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "Name" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page
    Then Operator verifies Shipper count is "1 Shippers"
    When Operator clicks on Shippers Remove button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "Name" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully removed." in Campaign Page
    Then Operator verifies Shipper count is "0 Shippers"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Success Remove Shippers - Select Shippers - Bulk Upload
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID}"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page
    Then Operator verifies Shipper count is "1 Shippers"
    When Operator clicks on Shippers Remove button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID}"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully removed." in Campaign Page
    Then Operator verifies Shipper count is "0 Shippers"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Success Remove Shippers - Select Shippers - Bulk Upload - CSV file contains valid and invalid shipper
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID}"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page
    Then Operator verifies Shipper count is "1 Shippers"
    When Operator clicks on Shippers Remove button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID};9999999"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully removed." in Campaign Page
    Then Operator verifies Shipper count is "0 Shippers"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Success Add Shippers - Select Shippers - Bulk Upload - CSV file contains valid and invalid shipper
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID};9999999"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page
    Then Operator verifies Shipper count is "1 Shippers"

  @DeleteNewlyCreatedShipper
  Scenario: Success Add Shippers when Campaign status is active - Select Shippers - Bulk Upload
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first "Active" campaign
    When Operator clicks on Shippers Add button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID}"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page

  @DeleteNewlyCreatedShipper
  Scenario: Success Add Shippers when Campaign status is active - Select Shippers - Bulk Upload - CSV file contains valid and invalid shipper
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first "Active" campaign
    When Operator clicks on Shippers Add button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID};9999999"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page

  @DeleteNewlyCreatedShipper
  Scenario: Success Add Shippers when Campaign status is active - Select Shippers - Search by Shippers
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first "Active" campaign
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "Name" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page

  @DeleteNewlyCreatedShipper
  Scenario: Success Add Shippers when Campaign status is active - Select Shippers - Search by Shippers - Shipper Already in Another Archive Campaign - Overlapped Start Date and End Date
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first "Active" campaign
    And Operator verifies Campaign is Active
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "value-20230815231624276" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page

  @DeleteCampaign
  Scenario: Add Shippers - Select Shippers - Search by Shippers - Shipper Already in Another Active Campaign - Overlapped Start Date and End Date
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "value-20230731171436342" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies error message is "Error Message: Cannot add shipper(s): duplicate entries for this campaign or already exists in another campaign with overlapping date"

  @DeleteCampaign
  Scenario: Success Add Shippers - Select Shippers - Search by Shippers - Shipper Already in Another Pending Campaign - Start Date and End Date Not Overlapped
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "value-20230815221154023" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page

  @DeleteCampaign
  Scenario: Success Add Shippers - Select Shippers - Search by Shippers - Shipper Already in Expired Campaign
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "value-20230815223419482" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page

  @DeleteCampaign
  Scenario: Success Add Shippers - Select Shippers - Search by Shippers - Shipper Already in Another Archive Campaign - Overlapped Start Date and End Date
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "value-20230815231624276" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Partial Success Remove Shippers - Select Shippers - Bulk Upload
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID}"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page
    Then Operator verifies Shipper count is "1 Shippers"
    When Operator clicks on Shippers Remove button
    When Operator uploads csv file with "977921;{KEY_LEGACY_SHIPPER_ID}"
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully removed. Error removing 1 shippers." in Campaign Page
    Then Operator verifies Shipper count is "0 Shippers"

  @DeleteCampaign @DeleteNewlyCreatedShipper
  Scenario: Partial Success Add Shippers - Select Shippers - Bulk Upload
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    When Operator click Create new campaign button in Discounts & Promotion Page
    Then Operator enter campaign details using data below:
      | campaignName                                                             | campaignDescription | startDate                      | endDate                        | discountOperator | serviceType | serviceLevel | discountValue | discountUsageQuantityPerShipper | discountUsagePeriod  |
      | Dummy Campaign {gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |                     | {gradle-next-1-day-yyyy-MM-dd} | {gradle-next-2-day-yyyy-MM-dd} | Flat rate        | Parcel;     | Standard;    | 10;           | Unlimited                       | Till end of campaign |
    When Operator clicks on publish button
    Then Operator verifies toast message "Campaign has been created. Please add shippers into the campaign." in Campaign Page
    Then Operator verifies the published campaign page
    When Operator clicks on Shippers Add button
    When Operator uploads csv file with "977921;{KEY_LEGACY_SHIPPER_ID}"
    When Operator clicks on upload button
    Then Operator verifies toast message "Error when adding 5653430: cannot add shipper: already exist in another campaign with overlapping date" in Campaign Page
    Then Operator verifies toast message "1 shippers have been successfully added. Error adding 1 shippers." in Campaign Page

  @DeleteNewlyCreatedShipper
  Scenario: Partial Success Add Shippers when Campaign is active - Select Shippers - Bulk Upload
    Given API Operator create new 'normal' shipper
    Given Operator go to menu Shipper -> Discount & Promotions
    Given Operator go to this URL "{QA-SO-Automation-Campaign-Active-URL}"
    And Operator refresh page
    And Operator verifies Campaign is Active
    When Operator clicks on Shippers Add button
    When Operator uploads csv file with "{KEY_LEGACY_SHIPPER_ID};977921"
    When Operator clicks on upload button
    Then Operator verifies toast message "Error when adding 5653430: cannot add shipper: already exist in another campaign with overlapping date" in Campaign Page
    Then Operator verifies toast message "1 shippers have been successfully added. Error adding 1 shippers." in Campaign Page


  Scenario: Success Add Shippers when Campaign status is active - Select Shippers - Search by Shippers - Shipper Already in Another Pending Campaign - Start Date and End Date Not Overlapped
    Given Operator go to menu Shipper -> Discount & Promotions
    And Operator clicks on first "Active" campaign
    And Operator verifies Campaign is Active
    When Operator clicks on Shippers Add button
    When Operator clicks on Search by Shipper tab
    Then Operator search using "value-20230815221154023" and select the created shipper
    When Operator clicks on upload button
    Then Operator verifies toast message "1 shippers have been successfully added." in Campaign Page