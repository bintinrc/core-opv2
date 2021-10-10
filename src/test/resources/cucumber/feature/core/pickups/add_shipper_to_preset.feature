@OperatorV2 @Core @PickUps @AddShipperToPreset
Feature: Add Shipper To Preset

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipper @DeleteShipperPickupFilterTemplate @CloseNewWindows
  Scenario: Operator Add New Shipper to Existing Shipper Pickup Preset Filters on Add Shipper to Preset Page - Single Address (uid:c5345ae2-e212-42c7-866a-59d5f1a80e42)
    Given API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | TA_TEMPLATE_{gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-current-date-yyyy-MM-dd}                  |
      | value.reservationTimeTo   | {gradle-current-date-yyyy-MM-dd}                  |
      | value.typeIds             | 0                                                 |
      | value.waypointStatuses    | Pending,Routed                                    |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
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
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {KEY_CREATED_SHIPPER.id} |
      | generateAddress | RANDOM                   |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{KEY_CREATED_SHIPPER.legacyId}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    Then Operator validates filter values on Add Shipper To Preset page using data below:
      | shipperCreationDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | shipperCreationDateTo   | {gradle-current-date-dd/MM/yyyy} |
    When Operator clicks Load Selection on Add Shipper To Preset page
    And Operator applies "UP" sorting to "Creation Date" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Creation Date" column on Add Shipper To Preset page
    And Operator applies "DOWN" sorting to "Creation Date" column on Add Shipper To Preset page
    Then Operator verify "DOWN" sorting is applied to "Creation Date" column on Add Shipper To Preset page
    And Operator applies "UP" sorting to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Address" column on Add Shipper To Preset page
    And Operator applies "DOWN" sorting to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify "DOWN" sorting is applied to "Shipper Address" column on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Name" column on Add Shipper To Preset page
    And Operator applies "DOWN" sorting to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify "DOWN" sorting is applied to "Shipper Name" column on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
    And Operator applies "DOWN" sorting to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify "DOWN" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
    When Operator applies "{KEY_CREATED_SHIPPER.name}" filter to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | createdAt                        | name                       | legacyId                       |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_CREATED_SHIPPER.name} | {KEY_CREATED_SHIPPER.legacyId} |
    When Operator adds shipper to preset on Add Shipper To Preset page using data below:
      | shipperName | {KEY_CREATED_SHIPPER.name}                        |
      | presetName  | {KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name} |
    And Operator go to menu Pick Ups -> Shipper Pickups
    And Operator select "{KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name}" filters preset on Shipment Management page
    Then Operator verifies filter parameters on Shipper Pickups page using data below:
      | shippers | {KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name} |

  @DeleteShipper @@DeleteFilterTemplate @CloseNewWindows
  Scenario: Operator Add New Shipper to Existing Shipper Pickup Preset Filters on Add Shipper to Preset Page - Multiple Addresses (uid:fd702085-61cd-4aab-9f18-e8a556f45544)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | TA_TEMPLATE_{gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-current-date-yyyy-MM-dd}                  |
      | value.reservationTimeTo   | {gradle-current-date-yyyy-MM-dd}                  |
      | value.typeIds             | 0                                                 |
      | value.waypointStatuses    | Pending,Routed                                    |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
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
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2                        |
      | shipperId         | {KEY_CREATED_SHIPPER.id} |
      | generateAddress   | RANDOM                   |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{KEY_CREATED_SHIPPER.legacyId}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    When Operator clicks Load Selection on Add Shipper To Preset page
    When Operator applies "{KEY_CREATED_SHIPPER.name}" filter to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | createdAt                        | name                       | legacyId                       |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_CREATED_SHIPPER.name} | {KEY_CREATED_SHIPPER.legacyId} |
      | {gradle-current-date-yyyy-MM-dd} | {KEY_CREATED_SHIPPER.name} | {KEY_CREATED_SHIPPER.legacyId} |
    When Operator adds shipper to preset on Add Shipper To Preset page using data below:
      | shipperName | {KEY_CREATED_SHIPPER.name}                        |
      | presetName  | {KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name} |
    And Operator go to menu Pick Ups -> Shipper Pickups
    And Operator select "{KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name}" filters preset on Shipment Management page
    Then Operator verifies filter parameters on Shipper Pickups page using data below:
      | shippers | {KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name} |

  Scenario: Operator Failed to Select Shipper Creation Date more than 7 Days Range on Add Shipper to Preset Page (uid:14437f95-98fd-4888-bea7-751d6baa540b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    When Operator applies filters on Add Shipper To Preset page using data below:
      | shipperCreationDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | shipperCreationDateTo   | {gradle-next-10-day-dd/MM/yyyy}  |
    Then Operator verifies wrong dates toast is shown on Add Shipper To Preset page

  Scenario: Check Shipper Selection in Add Shipper to Preset Page (uid:c8c488bd-b4fd-4ce3-abfc-d2fe5105ea97)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    When Operator clicks Load Selection on Add Shipper To Preset page
    And Operator clicks Select All Shown on Add Shipper To Preset page
    Then Operator verify all rows are selected on Add Shipper To Preset page
    When Operator clicks Deselect All Shown on Add Shipper To Preset page
    Then Operator verify all rows are unselected on Add Shipper To Preset page
    When Operator selects row 1 on Add Shipper To Preset page
    And Operator checks Show Only Selected on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | createdAt                             | address                             | name                             | legacyId                             |
      | {KEY_SELECTED_SHIPPER_INFO.createdAt} | {KEY_SELECTED_SHIPPER_INFO.address} | {KEY_SELECTED_SHIPPER_INFO.name} | {KEY_SELECTED_SHIPPER_INFO.legacyId} |
    When Operator unchecks Show Only Selected on Add Shipper To Preset page
    And Operator clicks Clear Current Selection on Add Shipper To Preset page
    Then Operator verify all rows are unselected on Add Shipper To Preset page

  Scenario: Operator Downloads List of Shippers CSV file in Add Shipper to Preset Page - Download All Shown (uid:908ad032-fa7f-4f63-ac4b-39729d1c4754)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    And Operator clicks Load Selection on Add Shipper To Preset page
    And Operator applies "UP" sorting to "Shipper Name" column on Add Shipper To Preset page
    And Operator saves displayed shipper results
    And Operator clicks Download CSV button on Add Shipper To Preset page
    Then Operator verify that CSV file contains all Shippers currently being shown on Add Shipper To Preset page

  @DeleteShipper @CloseNewWindows
  Scenario: Operator Downloads List of Shippers CSV file in Add Shipper to Preset Page - Download Only Filtered Shipper (uid:4790da95-8173-4c53-a208-ab77052ebaff)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
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
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 2                        |
      | shipperId         | {KEY_CREATED_SHIPPER.id} |
      | generateAddress   | RANDOM                   |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{KEY_CREATED_SHIPPER.legacyId}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    And Operator clicks Load Selection on Add Shipper To Preset page
    And Operator applies "{KEY_CREATED_SHIPPER.name}" filter to "Shipper Name" column on Add Shipper To Preset page
    And Operator saves displayed shipper results
    And Operator clicks Download CSV button on Add Shipper To Preset page
    Then Operator verify that CSV file contains all Shippers currently being shown on Add Shipper To Preset page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op