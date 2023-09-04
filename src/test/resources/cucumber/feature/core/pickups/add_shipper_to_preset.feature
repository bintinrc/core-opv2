@OperatorV2 @Core @PickUps @AddShipperToPreset
Feature: Add Shipper To Preset

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#    TODO There is no Shipper Pickups page anymore
#  @DeleteShipper @DeleteShipperPickupFilterTemplate @CloseNewWindows
#  Scenario: Operator Add New Shipper to Existing Shipper Pickup Preset Filters on Add Shipper to Preset Page - Single Address - All Shippers
#    Given API Operator creates new Shipper Pickup Filter Template using data below:
#      | name                      | TA_TEMPLATE_{gradle-current-date-yyyyMMddHHmmsss} |
#      | value.reservationTimeFrom | {gradle-current-date-yyyy-MM-dd}                  |
#      | value.reservationTimeTo   | {gradle-current-date-yyyy-MM-dd}                  |
#      | value.typeIds             | 0                                                 |
#      | value.waypointStatuses    | Pending,Routed                                    |
#    And Operator go to menu Shipper -> All Shippers
#    And Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                  |
#      | shipperType                  | Normal                |
#      | ocVersion                    | v4                    |
#      | services                     | STANDARD              |
#      | trackingType                 | Fixed                 |
#      | isAllowCod                   | false                 |
#      | isAllowCashPickup            | true                  |
#      | isPrepaid                    | true                  |
#      | isAllowStagedOrders          | false                 |
#      | isMultiParcelShipper         | false                 |
#      | isDisableDriverAppReschedule | false                 |
#      | pricingScriptName            | {pricing-script-name} |
#      | industryName                 | {industry-name}       |
#      | salesPerson                  | {sales-person}        |
#    And API Operator reload shipper's cache
#    And API Operator fetch id of the created shipper
#    And API Operator disable pickup appointment for Shipper with ID = "{KEY_CREATED_SHIPPER.legacyId}"
#    And API Operator create new shipper address V2 using data below:
#      | shipperId       | {KEY_CREATED_SHIPPER.id} |
#      | generateAddress | RANDOM                   |
#    And API Operator create V2 reservation using data below:
#      | reservationRequest | { "legacy_shipper_id":{KEY_CREATED_SHIPPER.legacyId}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
#    When Operator go to menu Pick Ups -> Add Shipper To Preset
#    And Add Shipper To Preset page is loaded
#    Then Operator validates filter values on Add Shipper To Preset page using data below:
#      | shipperCreationDateFrom | {gradle-current-date-dd/MM/yyyy} |
#      | shipperCreationDateTo   | {gradle-current-date-dd/MM/yyyy} |
#    When Operator clicks Load Selection on Add Shipper To Preset page
#    And Operator applies "UP" sorting to "Creation Date" column on Add Shipper To Preset page
#    Then Operator verify "UP" sorting is applied to "Creation Date" column on Add Shipper To Preset page
#    And Operator applies "DOWN" sorting to "Creation Date" column on Add Shipper To Preset page
#    Then Operator verify "DOWN" sorting is applied to "Creation Date" column on Add Shipper To Preset page
#    And Operator applies "UP" sorting to "Shipper Address" column on Add Shipper To Preset page
#    Then Operator verify "UP" sorting is applied to "Shipper Address" column on Add Shipper To Preset page
#    And Operator applies "DOWN" sorting to "Shipper Address" column on Add Shipper To Preset page
#    Then Operator verify "DOWN" sorting is applied to "Shipper Address" column on Add Shipper To Preset page
#    When Operator applies "UP" sorting to "Shipper Name" column on Add Shipper To Preset page
#    Then Operator verify "UP" sorting is applied to "Shipper Name" column on Add Shipper To Preset page
#    And Operator applies "DOWN" sorting to "Shipper Name" column on Add Shipper To Preset page
#    Then Operator verify "DOWN" sorting is applied to "Shipper Name" column on Add Shipper To Preset page
#    When Operator applies "UP" sorting to "Shipper Id" column on Add Shipper To Preset page
#    Then Operator verify "UP" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
#    And Operator applies "DOWN" sorting to "Shipper Id" column on Add Shipper To Preset page
#    Then Operator verify "DOWN" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
#    When Operator applies "{KEY_CREATED_SHIPPER.name}" filter to "Shipper Name" column on Add Shipper To Preset page
#    Then Operator verify records on Add Shipper To Preset page using data below:
#      | createdAt                        | name                       | legacyId                       |
#      | {gradle-current-date-yyyy-MM-dd} | {KEY_CREATED_SHIPPER.name} | {KEY_CREATED_SHIPPER.legacyId} |
#    When Operator adds shipper to preset on Add Shipper To Preset page using data below:
#      | shipperName | {KEY_CREATED_SHIPPER.name}                        |
#      | presetName  | {KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name} |
#    And Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator selects "{KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name}" Filter Preset on Shipper Pickups page
#    Then Operator verifies filter parameters on Shipper Pickups page using data below:
#      | shippers | {KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name} |

#    TODO There is no Shipper Pickups page anymore
#  @DeleteShipper @@DeleteFilterTemplate @CloseNewWindows
#  Scenario: Operator Add New Shipper to Existing Shipper Pickup Preset Filters on Add Shipper to Preset Page - Multiple Addresses - All Shippers
#    Given Operator go to menu Utilities -> QRCode Printing
#    And API Operator creates new Shipper Pickup Filter Template using data below:
#      | name                      | TA_TEMPLATE_{gradle-current-date-yyyyMMddHHmmsss} |
#      | value.reservationTimeFrom | {gradle-current-date-yyyy-MM-dd}                  |
#      | value.reservationTimeTo   | {gradle-current-date-yyyy-MM-dd}                  |
#      | value.typeIds             | 0                                                 |
#      | value.waypointStatuses    | Pending,Routed                                    |
#    And Operator go to menu Shipper -> All Shippers
#    And Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                  |
#      | shipperType                  | Normal                |
#      | ocVersion                    | v4                    |
#      | services                     | STANDARD              |
#      | trackingType                 | Fixed                 |
#      | isAllowCod                   | false                 |
#      | isAllowCashPickup            | true                  |
#      | isPrepaid                    | true                  |
#      | isAllowStagedOrders          | false                 |
#      | isMultiParcelShipper         | false                 |
#      | isDisableDriverAppReschedule | false                 |
#      | pricingScriptName            | {pricing-script-name} |
#      | industryName                 | {industry-name}       |
#      | salesPerson                  | {sales-person}        |
#    And API Operator reload shipper's cache
#    And API Operator fetch id of the created shipper
#    And API Operator disable pickup appointment for Shipper with ID = "{KEY_CREATED_SHIPPER.legacyId}"
#    And API Operator create multiple shipper addresses V2 using data below:
#      | numberOfAddresses | 2                        |
#      | shipperId         | {KEY_CREATED_SHIPPER.id} |
#      | generateAddress   | RANDOM                   |
#    And API Operator create multiple V2 reservations based on number of created addresses using data below:
#      | reservationRequest | { "legacy_shipper_id":{KEY_CREATED_SHIPPER.legacyId}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
#    When Operator go to menu Pick Ups -> Add Shipper To Preset
#    And Add Shipper To Preset page is loaded
#    When Operator clicks Load Selection on Add Shipper To Preset page
#    When Operator applies "{KEY_CREATED_SHIPPER.name}" filter to "Shipper Name" column on Add Shipper To Preset page
#    Then Operator verify records on Add Shipper To Preset page using data below:
#      | createdAt                        | name                       | legacyId                       |
#      | {gradle-current-date-yyyy-MM-dd} | {KEY_CREATED_SHIPPER.name} | {KEY_CREATED_SHIPPER.legacyId} |
#      | {gradle-current-date-yyyy-MM-dd} | {KEY_CREATED_SHIPPER.name} | {KEY_CREATED_SHIPPER.legacyId} |
#    When Operator adds shipper to preset on Add Shipper To Preset page using data below:
#      | shipperName | {KEY_CREATED_SHIPPER.name}                        |
#      | presetName  | {KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name} |
#    And Operator go to menu Pick Ups -> Shipper Pickups
#    When Operator selects "{KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name}" Filter Preset on Shipper Pickups page
#    Then Operator verifies filter parameters on Shipper Pickups page using data below:
#      | shippers | {KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name} |

  Scenario: Operator Failed to Select Shipper Creation Date more than 7 Days Range on Add Shipper to Preset Page
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    When Operator applies filters on Add Shipper To Preset page using data below:
      | shipperCreationDateFrom | {gradle-current-date-dd/MM/yyyy} |
      | shipperCreationDateTo   | {gradle-next-10-day-dd/MM/yyyy}  |
    Then Operator verifies wrong dates toast is shown on Add Shipper To Preset page

  Scenario: Check Shipper Selection in Add Shipper to Preset Page (uid:c8c488bd-b4fd-4ce3-abfc-d2fe5105ea97)
    Given Operator go to menu Utilities -> QRCode Printing
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
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    And Operator clicks Load Selection on Add Shipper To Preset page
    And Operator applies "UP" sorting to "Shipper Name" column on Add Shipper To Preset page
    And Operator saves displayed shipper results
    And Operator clicks Download CSV button on Add Shipper To Preset page
    Then Operator verify that CSV file contains all Shippers currently being shown on Add Shipper To Preset page

  @DeleteShipper @CloseNewWindows
  Scenario: Operator Downloads List of Shippers CSV file in Add Shipper to Preset Page - Download Only Filtered Shipper (uid:4790da95-8173-4c53-a208-ab77052ebaff)
    Given Operator go to menu Utilities -> QRCode Printing
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
    And API Operator disable pickup appointment for Shipper with ID = "{KEY_CREATED_SHIPPER.legacyId}"
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

  @DeleteShipper @CloseNewWindows
  Scenario: Operator Filter All Shippers on Add Shipper To Preset Page (uid:c1638de3-8bf4-410a-9f1e-762d42f4cbef)
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
    And API Operator disable pickup appointment for Shipper with ID = "{KEY_CREATED_SHIPPER.legacyId}"
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
    When Operator applies "{KEY_CREATED_ADDRESS.address1}" filter to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | address                                                 |
      | {KEY_CREATED_ADDRESS.to1LineAddressWithSpaceDelimiter2} |
    When Operator clear column filters on Add Shipper To Preset page
    And Operator applies "UP" sorting to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Address" column on Add Shipper To Preset page
    When Operator applies "{KEY_CREATED_SHIPPER.name}" filter to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | name                       |
      | {KEY_CREATED_SHIPPER.name} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Name" column on Add Shipper To Preset page
    When Operator applies "{KEY_CREATED_SHIPPER.legacyId}" filter to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | legacyId                       |
      | {KEY_CREATED_SHIPPER.legacyId} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
    When Operator applies "All" filter to "Is Active" column on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Is Active" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Is Active" column on Add Shipper To Preset page

  @DeleteShipper @CloseNewWindows
  Scenario: Operator Filter Active Shipper on Add Shipper To Preset Page (uid:c57cc075-f1cd-4aed-8c2d-b37159cea14a)
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
    And API Operator disable pickup appointment for Shipper with ID = "{KEY_CREATED_SHIPPER.legacyId}"
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
    When Operator applies "{KEY_CREATED_ADDRESS.address1}" filter to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | address                                                 |
      | {KEY_CREATED_ADDRESS.to1LineAddressWithSpaceDelimiter2} |
    When Operator clear column filters on Add Shipper To Preset page
    And Operator applies "UP" sorting to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Address" column on Add Shipper To Preset page
    When Operator applies "{KEY_CREATED_SHIPPER.name}" filter to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | name                       |
      | {KEY_CREATED_SHIPPER.name} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Name" column on Add Shipper To Preset page
    When Operator applies "{KEY_CREATED_SHIPPER.legacyId}" filter to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | legacyId                       |
      | {KEY_CREATED_SHIPPER.legacyId} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
    When Operator applies "Active" filter to "Is Active" column on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Is Active" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Is Active" column on Add Shipper To Preset page

  @DeleteShipper @CloseNewWindows
  Scenario: Operator Filter Inactive Shipper on Add Shipper To Preset Page (uid:2bfa8e88-fddd-4667-8962-a56b1fbe2299)
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | false                 |
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
    And API Operator disable pickup appointment for Shipper with ID = "{KEY_CREATED_SHIPPER.legacyId}"
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
    When Operator applies "{KEY_CREATED_ADDRESS.address1}" filter to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | address                                                 |
      | {KEY_CREATED_ADDRESS.to1LineAddressWithSpaceDelimiter2} |
    When Operator clear column filters on Add Shipper To Preset page
    And Operator applies "UP" sorting to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Address" column on Add Shipper To Preset page
    When Operator applies "{KEY_CREATED_SHIPPER.name}" filter to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | name                       |
      | {KEY_CREATED_SHIPPER.name} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Name" column on Add Shipper To Preset page
    When Operator applies "{KEY_CREATED_SHIPPER.legacyId}" filter to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | legacyId                       |
      | {KEY_CREATED_SHIPPER.legacyId} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
    When Operator applies "Inactive" filter to "Is Active" column on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Is Active" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Is Active" column on Add Shipper To Preset page

  @DeleteShipper
  Scenario: Operator Downloads List of Shippers CSV file in Add Shipper to Preset Page - Download Only Inactive Shipper (uid:037cbbf0-9f33-4044-866e-78367d2805c7)
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | false                 |
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
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    And Operator clicks Load Selection on Add Shipper To Preset page
    And Operator applies "Inactive" filter to "Is Active" column on Add Shipper To Preset page
    And Operator saves displayed shipper results
    And Operator clicks Download CSV button on Add Shipper To Preset page
    Then Operator verify that CSV file contains all Shippers currently being shown on Add Shipper To Preset page

  Scenario: Operator Downloads List of Shippers CSV file in Add Shipper to Preset Page - Download Only Active Shipper (uid:01b78e6c-06ad-4e4d-b49c-963d458f5c2f)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    And Operator clicks Load Selection on Add Shipper To Preset page
    And Operator applies "Active" filter to "Is Active" column on Add Shipper To Preset page
    And Operator saves displayed shipper results
    And Operator clicks Download CSV button on Add Shipper To Preset page
    Then Operator verify that CSV file contains all Shippers currently being shown on Add Shipper To Preset page

#    TODO There is no Shipper Pickups page anymore
#  @DeleteShipper @DeleteShipperPickupFilterTemplate @CloseNewWindows
#  Scenario: Operator Add New Shipper to Existing Shipper Pickup Preset Filters on Add Shipper to Preset Page - Single Address - Inactive Shipper (uid:958ed81a-3f3e-456d-ad3d-a6614269253e)
#    Given API Operator creates new Shipper Pickup Filter Template using data below:
#      | name                      | TA_TEMPLATE_{gradle-current-date-yyyyMMddHHmmsss} |
#      | value.reservationTimeFrom | {gradle-current-date-yyyy-MM-dd}                  |
#      | value.reservationTimeTo   | {gradle-current-date-yyyy-MM-dd}                  |
#      | value.typeIds             | 0                                                 |
#      | value.waypointStatuses    | Pending,Routed                                    |
#    And Operator go to menu Shipper -> All Shippers
#    And Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | false                 |
#      | shipperType                  | Normal                |
#      | ocVersion                    | v4                    |
#      | services                     | STANDARD              |
#      | trackingType                 | Fixed                 |
#      | isAllowCod                   | false                 |
#      | isAllowCashPickup            | true                  |
#      | isPrepaid                    | true                  |
#      | isAllowStagedOrders          | false                 |
#      | isMultiParcelShipper         | false                 |
#      | isDisableDriverAppReschedule | false                 |
#      | pricingScriptName            | {pricing-script-name} |
#      | industryName                 | {industry-name}       |
#      | salesPerson                  | {sales-person}        |
#    And API Operator reload shipper's cache
#    And API Operator fetch id of the created shipper
#    And API Operator disable pickup appointment for Shipper with ID = "{KEY_CREATED_SHIPPER.legacyId}"
#    And API Operator create new shipper address V2 using data below:
#      | shipperId       | {KEY_CREATED_SHIPPER.id} |
#      | generateAddress | RANDOM                   |
#    And API Operator create V2 reservation using data below:
#      | reservationRequest | { "legacy_shipper_id":{KEY_CREATED_SHIPPER.legacyId}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
#    When Operator go to menu Pick Ups -> Add Shipper To Preset
#    And Add Shipper To Preset page is loaded
#    Then Operator validates filter values on Add Shipper To Preset page using data below:
#      | shipperCreationDateFrom | {gradle-current-date-dd/MM/yyyy} |
#      | shipperCreationDateTo   | {gradle-current-date-dd/MM/yyyy} |
#    When Operator clicks Load Selection on Add Shipper To Preset page
#    And Operator applies "Inactive" filter to "Is Active" column on Add Shipper To Preset page
#    When Operator adds shipper to preset on Add Shipper To Preset page using data below:
#      | shipperName | {KEY_CREATED_SHIPPER.name}                        |
#      | presetName  | {KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name} |
#    And Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator selects "{KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name}" Filter Preset on Shipper Pickups page
#    Then Operator verifies filter parameters on Shipper Pickups page using data below:
#      | shippers | {KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name} |

#    TODO There is no Shipper Pickups page anymore
#  @DeleteShipper @DeleteShipperPickupFilterTemplate @CloseNewWindows
#  Scenario: Operator Add New Shipper to Existing Shipper Pickup Preset Filters on Add Shipper to Preset Page - Single Address - Active Shipper (uid:7c64e137-61c4-499d-9efe-5482542b3070)
#    Given API Operator creates new Shipper Pickup Filter Template using data below:
#      | name                      | TA_TEMPLATE_{gradle-current-date-yyyyMMddHHmmsss} |
#      | value.reservationTimeFrom | {gradle-current-date-yyyy-MM-dd}                  |
#      | value.reservationTimeTo   | {gradle-current-date-yyyy-MM-dd}                  |
#      | value.typeIds             | 0                                                 |
#      | value.waypointStatuses    | Pending,Routed                                    |
#    And Operator go to menu Shipper -> All Shippers
#    And Operator create new Shipper with basic settings using data below:
#      | isShipperActive              | true                  |
#      | shipperType                  | Normal                |
#      | ocVersion                    | v4                    |
#      | services                     | STANDARD              |
#      | trackingType                 | Fixed                 |
#      | isAllowCod                   | false                 |
#      | isAllowCashPickup            | true                  |
#      | isPrepaid                    | true                  |
#      | isAllowStagedOrders          | false                 |
#      | isMultiParcelShipper         | false                 |
#      | isDisableDriverAppReschedule | false                 |
#      | pricingScriptName            | {pricing-script-name} |
#      | industryName                 | {industry-name}       |
#      | salesPerson                  | {sales-person}        |
#    And API Operator reload shipper's cache
#    And API Operator fetch id of the created shipper
#    And API Operator disable pickup appointment for Shipper with ID = "{KEY_CREATED_SHIPPER.legacyId}"
#    And API Operator create new shipper address V2 using data below:
#      | shipperId       | {KEY_CREATED_SHIPPER.id} |
#      | generateAddress | RANDOM                   |
#    And API Operator create V2 reservation using data below:
#      | reservationRequest | { "legacy_shipper_id":{KEY_CREATED_SHIPPER.legacyId}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
#    When Operator go to menu Pick Ups -> Add Shipper To Preset
#    And Add Shipper To Preset page is loaded
#    Then Operator validates filter values on Add Shipper To Preset page using data below:
#      | shipperCreationDateFrom | {gradle-current-date-dd/MM/yyyy} |
#      | shipperCreationDateTo   | {gradle-current-date-dd/MM/yyyy} |
#    When Operator clicks Load Selection on Add Shipper To Preset page
#    And Operator applies "Active" filter to "Is Active" column on Add Shipper To Preset page
#    When Operator adds shipper to preset on Add Shipper To Preset page using data below:
#      | shipperName | {KEY_CREATED_SHIPPER.name}                        |
#      | presetName  | {KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name} |
#    And Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator selects "{KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name}" Filter Preset on Shipper Pickups page
#    Then Operator verifies filter parameters on Shipper Pickups page using data below:
#      | shippers | {KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name} |
