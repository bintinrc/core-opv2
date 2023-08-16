@MileZero @CorporateHQ @WithSg
Feature: Prevent Corporate account linking

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2 go to menu all shipper
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipper
  Scenario: Create Corporate HQ using the existing email - same country (uid:63b495b8-40fc-4cb3-9f8f-dcf1494a3b6a)
    Given Operator go to menu Shipper -> All Shippers
    When Operator fail create new Shipper with basic settings using data below:
      | isShipperActive              | true                                |
      | shipperType                  | Corporate HQ                        |
      | email                        | {operator-b2b-master-shipper-email} |
      | ocVersion                    | v4                                  |
      | services                     | STANDARD                            |
      | trackingType                 | Fixed                               |
      | isAllowCod                   | false                               |
      | isAllowCashPickup            | true                                |
      | isPrepaid                    | true                                |
      | isAllowStagedOrders          | false                               |
      | isMultiParcelShipper         | false                               |
      | isDisableDriverAppReschedule | false                               |
      | isCorporate                  | true                                |
      | pricingScriptName            | {pricing-script-name}               |
      | industryName                 | {industry-name}                     |
      | salesPerson                  | {sales-person}                      |
    Then Operator verifies toast "Shipper Email (Basic Settings)" displayed on edit shipper page

  Scenario: Create Corporate branch using the existing email - same parent (uid:21df8bba-04b1-41ff-b146-1b559c043c04)
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    And Operator verifies corporate sub shipper is created
    And Operator create corporate sub shipper with data below:
      | branchId | generated                              |
      | name     | generated                              |
      | email    | {KEY_LIST_SUB_SHIPPER_SELLER_EMAIL[1]} |
    Then Operator verifies corporate sub shipper is created
    And Operator click Ninja Dash Login button for "{KEY_LIST_SUB_SHIPPER_SELLER_ID[2]}" corporate sub shipper
    And Operator verifies that error toast displayed:
      | top    | Network Request Error                     |
      | bottom | ^.*Error Message: shipper \d* not found.* |

  Scenario: Create Corporate branch using the existing email - different country (uid:6afd2b69-7e59-47bd-bc5e-9c745c600982)
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shipper with data below:
      | branchId | generated          |
      | name     | generated          |
      | email    | {my-shipper-email} |
    And Operator verifies success notification "New sub-shipper(s) created successfully" is displayed on Corporate sub shippers tab
    And Operator verifies corporate sub shipper is created
    And Operator click Ninja Dash Login button for "{KEY_LIST_SUB_SHIPPER_SELLER_ID[1]}" corporate sub shipper
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                     |
      | bottom | ^.*Error Message: shipper \d* not found.* |

  @DeleteShipper
  Scenario: Create Corporate HQ using the existing email - different country (uid:49c02312-b8f3-4ad9-9aaf-aa7195c22b7e)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Corporate HQ          |
      | email                        | {my-shipper-email}    |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | isCorporate                  | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully

  @DeleteShipper
  Scenario: Create Corporate branch using the existing email - different parent (uid:21177dd1-23a8-4f21-b801-fd7f0a303493)
    When Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Corporate HQ          |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | isCorporateManualAWB         | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    When Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    And Operator verifies corporate sub shipper is created
    And Operator save changes on Edit Shipper Page
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Corporate HQ          |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | isCorporateManualAWB         | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated                              |
      | name     | generated                              |
      | email    | {KEY_LIST_SUB_SHIPPER_SELLER_EMAIL[1]} |
    Then Operator verifies success notification "New sub-shipper(s) created successfully" is displayed on Corporate sub shippers tab
    And Operator click Ninja Dash Login button for "{KEY_LIST_SUB_SHIPPER_SELLER_ID[2]}" corporate sub shipper
    And Operator verifies that error toast displayed:
      | top    | Network Request Error                     |
      | bottom | ^.*Error Message: shipper \d* not found.* |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
