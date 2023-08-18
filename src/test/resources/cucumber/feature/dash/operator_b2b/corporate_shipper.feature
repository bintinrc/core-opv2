@MileZero @CorporateHQ @WithSg
Feature: Corporate Shipper

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2 go to menu all shipper
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCorporateSubShipper
  Scenario: View master shipper settings (uid:86b71c08-dc9a-45e8-8d25-8acc9b3c4de5)
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    And Operator verifies shipper type is "Corporate HQ" on Edit Shipper page
    And Operator go to "More Settings" tab on Edit Shipper page
    And Operator go to "Integrations" tab on Edit Shipper page
    And Operator go to "Sub shippers Default Setting" tab on Edit Shipper page
    And Operator go to "Marketplace Sellers (Sub Shippers)" tab on Edit Shipper page
    Then hint "Page disabled for normal and marketplace seller shipper types." is displayed on Edit Shipper page
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created

  @CloseNewWindows
  Scenario: View sub shippers settings (uid:c4bfb504-6eef-4809-8d47-c2d819264e6f)
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And API Operator delete corporate sub shippers
    And Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    When Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    And Operator verifies corporate sub shipper is created
    And Operator click edit action button for first corporate sub shipper
    And Operator verifies corporate sub shipper details page is displayed
    And Operator verifies shipper type is "Corporate Branch" on Edit Shipper page
    And Operator go to "Sub shippers Default Setting" tab on Edit Shipper page
    Then hint "No Settings required for normal and Corporate Branch shipper types." is displayed on Edit Shipper page
    And Operator go to "Marketplace Sellers (Sub Shippers)" tab on Edit Shipper page
    And hint "Page disabled for normal and marketplace seller shipper types." is displayed on Edit Shipper page
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And hint "Page available for Corporate HQ shipper only." is displayed on Edit Shipper page

  Scenario: Create more than 1 sub shipper on shipper settings (uid:fa95a3b5-88e9-4d80-b87f-f25b7739f362)
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And API Operator delete corporate sub shippers
    And Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    When Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shippers with data below:
      | branchId  | name      | email     |
      | generated | generated | generated |
      | generated | generated | generated |
    Then Operator verifies corporate sub shippers are created

  Scenario: Create more than 1 sub shipper with the same branch ID on shipper settings (uid:fc5fe78f-520d-4ddd-ab78-dcdf0e9375d2)
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shippers with data below:
      | branchId | name      | email     |
      | 12345    | generated | generated |
      | 12345    | generated | generated |
    Then Operator verifies error message "Branch ID already exists." is displayed on b2b management page

  @DeleteCorporateSubShipper
  Scenario: Create bulk subshippers (uid:eb4d7527-cd0a-4683-a714-e5f14500f9d4)
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator bulk create corporate sub shippers with data below:
      | branchId  | name      | email     |
      | generated | generated | generated |
      | generated | generated | generated |
    And API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    Then Operator verifies corporate sub shippers are created

  @DeleteCorporateSubShipper
  Scenario: Create bulk subshippers with error file upload (uid:260bf624-3938-4d3c-adc4-d1bfe9309837)
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator upload incorrect bulk create corporate sub shippers file
    Then Operator verifies file upload error messages are displayed on b2b management page:
      | 1. Headers in the CSV file should be "Branch ID (External Ref)", "Name", "Email", appearing in that order in the file. |
      | 2. Only Branch ID (External Ref), Name and Email should be provided as data; there may be too much or too little data. |

  @DeleteCorporateSubShipper
  Scenario: Create bulk subshippers with existing branch ID (uid:4dabc93b-59f2-4e8f-be26-d6ca987d7f9c)
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shippers with data below:
      | branchId  | name      | email     |
      | generated | generated | generated |
    And Operator verifies corporate sub shippers are created
    And Operator bulk create corporate sub shippers with data below:
      | branchId                    | name      | email     |
      | {KEY_SUB_SHIPPER_SELLER_ID} | generated | generated |
      | generated                   | generated | generated |
    And API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    Then Operator verifies file upload warning messages are displayed on b2b management page:
      | We've only created 1 out of the 2 sub-shipper(s) submitted. There seems to be problems with some shipper data in the file. Please download the error log, correct the data and upload the CSV file to create the remaining sub-shippers. |
    And Operator clicks Go Back button on b2b management page
    And Before You Go modal is displayed with "We've detected an error log from your last upload. If you choose to navigate away, your email log and any uncreated sub-shippers will be discarded." message on b2b management page
    And Operator clicks Cancel button on Before You Go modal on b2b management page
    And Operator downloads error log on b2b management page
    And bulk shipper creation error log file contains data:
      | branchId                            | name                                  | email                                  |
      | {KEY_LIST_SUB_SHIPPER_SELLER_ID[2]} | {KEY_LIST_SUB_SHIPPER_SELLER_NAME[2]} | {KEY_LIST_SUB_SHIPPER_SELLER_EMAIL[2]} |

  @DeleteCorporateSubShipper
  Scenario: Create bulk subshippers using same email as master shipper (uid:42532079-ef3c-474f-96a1-926a9b6f1f10)
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{postpaid-corporate-hq-legacy-id}"
    And Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator bulk create corporate sub shippers with data below:
      | branchId  | name      | email                            |
      | generated | generated | {postpaid-corporate-hq-username} |
      | generated | generated | generated                        |
    And API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    And Operator verifies file upload warning messages are displayed on b2b management page:
      | We've only created 1 out of the 2 sub-shipper(s) submitted. There seems to be problems with some shipper data in the file. Please download the error log, correct the data and upload the CSV file to create the remaining sub-shippers. |
    And Operator clicks Go Back button on b2b management page
    And Before You Go modal is displayed with "We've detected an error log from your last upload. If you choose to navigate away, your email log and any uncreated sub-shippers will be discarded." message on b2b management page
    And Operator clicks Cancel button on Before You Go modal on b2b management page
    And Operator downloads error log on b2b management page
    Then bulk shipper creation error log file contains data:
      | branchId                            | name                                  | email                                  |
      | {KEY_LIST_SUB_SHIPPER_SELLER_ID[1]} | {KEY_LIST_SUB_SHIPPER_SELLER_NAME[1]} | {KEY_LIST_SUB_SHIPPER_SELLER_EMAIL[1]} |

  @DeleteShipper
  Scenario: Create corporate shipper with corporate service type toggled on (uid:c3126c0e-bbcb-4df7-98b2-5ffcad4a1d95)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
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
      | isCorporate                  | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And DB Shipper verifies available service types for created shipper contains "Corporate"

  @DeleteShipper
  Scenario: Create corporate shipper with corporate service type toggled off (uid:42b7a12d-74ed-4bf9-98be-10b06934ce53)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
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
      | isCorporate                  | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And DB Shipper verifies available service types for created shipper not contains "Corporate"

  Scenario: Create non corporate shipper with corporate service type toggled on (uid:42f93a75-1dbc-4cbc-a134-605acd956fca)
    Given Operator go to menu Shipper -> All Shippers
    When Operator fail create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
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
    Then Operator verifies toast "Only corporate shippers are allowed to have Corporate as their service type" displayed on edit shipper page

  @DeleteShipper
  Scenario: Create non corporate shipper with corporate service type toggled on (uid:42f93a75-1dbc-4cbc-a134-605acd956fca)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
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
      | isCorporate                  | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And DB Shipper verifies available service types for created shipper contains "Corporate"
    When Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator set service type "Corporate" to "No" on edit shipper page
    And DB Shipper verifies available service types for created shipper not contains "Corporate"
    Then Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator set service type "Corporate" to "Yes" on edit shipper page
    And DB Shipper verifies available service types for created shipper contains "Corporate"

  Scenario: Toggled on corporate service type for the existing non-corporate shipper (uid:8a8b1b97-598f-42de-bdc2-024aa6f12ff4)
    Given Operator edits shipper "{prepaid-legacy-id}"
    When Operator set service type "Corporate" to "Yes" on edit shipper page
    Then Operator verifies toast "Only corporate shippers are allowed to have Corporate as their service type" displayed on edit shipper page
    And DB Shipper verifies available service types for shipper id "{prepaid-id}" not contains "Corporate"

  @DeleteShipper
  Scenario: Create corporate shipper with corporate awb service type toggled on (uid:49d05bf1-90ba-403d-8852-ceaa734b8441)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
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
      | isCorporateManualAWB         | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And DB Shipper verifies available service types for created shipper contains "Corporate AWB"

  @DeleteShipper
  Scenario: Create corporate shipper with corporate awb service type toggled off (uid:dbcc7943-449f-4d7f-b92b-c37b6cfc820b)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
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
    And DB Shipper verifies available service types for created shipper not contains "Corporate AWB"

  Scenario: Toggled on corporate awb service type for existing non corporate shipper (uid:f6cefc84-d729-45f2-8e8e-db58b0a8afc5)
    Given Operator edits shipper "{prepaid-legacy-id}"
    When Operator set service type "Corporate Manual AWB" to "Yes" on edit shipper page
    Then Operator verifies toast "Only corporate shippers are allowed to have Corporate Manual AWB as their service type" displayed on edit shipper page
    And DB Shipper verifies available service types for shipper id "{prepaid-id}" not contains "Corporate AWB"

  Scenario: Create non corporate shipper with corporate awb service type toggled on (uid:38f9ce4b-c66a-4424-a8af-a028fc567a33)
    Given Operator go to menu Shipper -> All Shippers
    When Operator fail create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | isCorporateManualAWB         | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    Then Operator verifies toast "Only corporate shippers are allowed to have Corporate Manual AWB as their service type" displayed on edit shipper page

  @DeleteShipper
  Scenario: Modify corporate awb service type for corporate shipper (uid:c26df37e-110d-44c4-a1cb-6d755092493e)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
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
      | isCorporateManualAWB         | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And DB Shipper verifies available service types for created shipper contains "Corporate AWB"
    And Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator set service type "Corporate Manual AWB" to "No" on edit shipper page
    And DB Shipper verifies available service types for created shipper not contains "Corporate AWB"
    Then Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator set service type "Corporate Manual AWB" to "Yes" on edit shipper page
    And DB Shipper verifies available service types for created shipper contains "Corporate AWB"

  @DeleteShipper @DeleteCorporateSubShipper
  Scenario: Create subshippers with corporate awb toggle off in subshipper default settings (uid:c502aae4-1f29-4cc2-a2da-70735368ac10)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
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
      | isCorporateManualAWB         | true                  |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And DB Shipper verifies available service types for created shipper contains "Corporate AWB"
    When Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator set service type "Corporate Manual AWB" to "No" on edit shipper page
    And DB Shipper verifies available marketplace service types for created shipper not contains "Corporate AWB"
    And Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created
    And API Operator fetch id of the created shipper
    And API Operator get b2b sub shippers for master shipper id "{KEY_CREATED_SHIPPER.id}"
    And DB Shipper verifies available service types for shipper id "{KEY_LIST_OF_B2B_SUB_SHIPPER[1].id}" not contains "Corporate AWB"

  @DeleteShipper @DeleteCorporateSubShipper
  Scenario: Create subshippers with corporate awb toggle on in subshipper default settings (uid:6f0d4090-7f61-42b8-8a06-b452ee9875dd)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
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
    And DB Shipper verifies available service types for created shipper not contains "Corporate AWB"
    When Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator set service type "Corporate Manual AWB" to "Yes" on edit shipper page
    Then DB Shipper verifies available service types for created shipper contains "Corporate AWB"
    And Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created
    And API Operator fetch id of the created shipper
    And API Operator get b2b sub shippers for master shipper id "{KEY_CREATED_SHIPPER.id}"
    And DB Shipper verifies available service types for shipper id "{KEY_LIST_OF_B2B_SUB_SHIPPER[1].id}" contains "Corporate AWB"

  @DeleteShipper
  Scenario: Create master shipper (uid:3867e373-e888-4d3b-a459-18e7e351cf79)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
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
      | isCorporate                  | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And Operator clear browser cache and reload All Shipper page
    Then Operator verify the new Shipper is created successfully

  @DeleteShipper @DeleteCorporateSubShipper @CloseNewWindows
  Scenario: Inherit corporate shipper setting to sub shipper (uid:a723c74f-acd1-49d0-8ffb-34fdc3552d48)
    Given Operator go to menu Shipper -> All Shippers
    When Operator create new Shipper with basic settings using data below:
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
    And DB Shipper verifies available service types for created shipper not contains "Corporate AWB"
    When Operator edits shipper "{KEY_CREATED_SHIPPER.legacyId}"
    And Operator update Sub Shippers Default settings:
      | servicesAvailable      | 1DAY,2DAY         |
      | availableServiceLevels | Same Day, Express |
      | billingName            | ason              |
      | billingContact         | 081319111110      |
      | billingAddress         | kilang barat      |
      | billingPostcode        | 596363            |
      | corporateReturn        | true              |
      | bulky                  | true              |
    And Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    And Operator verifies corporate sub shipper is created
    And API Operator fetch id of the created shipper
    And API Operator get b2b sub shippers for master shipper id "{KEY_CREATED_SHIPPER.id}"
    And Operator edits shipper "{KEY_LIST_OF_B2B_SUB_SHIPPER[1].legacyId}"
    Then Operator verifies Basic Settings on Edit Shipper page:
      | availableServiceLevels | Same Day, Express |
      | corporateReturn        | true              |
      | bulky                  | true              |
    And Operator verifies Pricing And Billing Settings on Edit Shipper page:
      | billingName     | ason         |
      | billingContact  | 081319111110 |
      | billingAddress  | kilang barat |
      | billingPostcode | 596363       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
