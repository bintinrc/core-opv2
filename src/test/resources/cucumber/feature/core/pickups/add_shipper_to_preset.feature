@OperatorV2 @Core @PickUps @AddShipperToPreset @current
Feature: Add Shipper To Preset

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Operator Failed to Select Shipper Creation Date more than 7 Days Range on Add Shipper to Preset Page
    Given Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    When Operator applies filters on Add Shipper To Preset page using data below:
      | shipperCreationDateFrom | {date: 0 days next, dd/MM/yyyy} |
      | shipperCreationDateTo   | {gradle-next-10-day-dd/MM/yyyy} |
    Then Operator verifies wrong dates toast is shown on Add Shipper To Preset page


  @MediumPriority
  Scenario: Check Shipper Selection in Add Shipper to Preset Page
    Given Operator go to menu Pick Ups -> Add Shipper To Preset
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


  @MediumPriority
  Scenario: Operator Downloads List of Shippers CSV file in Add Shipper to Preset Page - Download All Shown
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    And Operator clicks Load Selection on Add Shipper To Preset page
    And Operator clicks Download CSV button on Add Shipper To Preset page
    Then Operator verify that CSV file have same line count as shown rows on Add Shipper To Preset page

  @CloseNewWindows @MediumPriority
  Scenario: Operator Downloads List of Shippers CSV file in Add Shipper to Preset Page - Download Only Filtered Shipper
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    And Operator clicks Load Selection on Add Shipper To Preset page
    And Operator applies "DUMMY SHIPPER" filter to "Shipper Name" column on Add Shipper To Preset page
    And Operator clicks Download CSV button on Add Shipper To Preset page
    Then Operator verify that CSV file have same line count as shown rows on Add Shipper To Preset page

  @DeleteShipper @CloseNewWindows @MediumPriority
  Scenario: Operator Filter All Shippers on Add Shipper To Preset Page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                             |
      | generateAddress       | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | shipperAddressRequest | {"name":"{shipper-v4-name}","contact":"{shipper-v4-contact}","email":"{shipper-v4-email}","address1":"address1","address2":"address2","country":"SG","latitude":1.27,"longitude":103.27,"postcode":"159363","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
    ###
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    Then Operator applies filters on Add Shipper To Preset page using data below:
      | shipperCreationDateFrom | {shipper-v4-creation-date-from} |
      | shipperCreationDateTo   | {shipper-v4-creation-date-to}   |
    And Operator applies "UP" sorting to "Creation Date" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Creation Date" column on Add Shipper To Preset page
    When Operator applies "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" filter to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | address                                                              |
      | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithSpaceDelimiter2} |
    When Operator clear column filters on Add Shipper To Preset page
    And Operator applies "UP" sorting to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Address" column on Add Shipper To Preset page
    When Operator applies "{shipper-v4-name}" filter to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | name              |
      | {shipper-v4-name} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Name" column on Add Shipper To Preset page
    When Operator applies "{shipper-v4-legacy-id}" filter to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | legacyId               |
      | {shipper-v4-legacy-id} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
    When Operator applies "All" filter to "Is Active" column on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Is Active" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Is Active" column on Add Shipper To Preset page

  @DeleteShipper @CloseNewWindows @MediumPriority
  Scenario: Operator Filter Active Shipper on Add Shipper To Preset Page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {shipper-v4-id}                                                                                                                                                                                                                                                                                                                             |
      | generateAddress       | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | shipperAddressRequest | {"name":"{shipper-v4-name}","contact":"{shipper-v4-contact}","email":"{shipper-v4-email}","address1":"address1","address2":"address2","country":"SG","latitude":1.27,"longitude":103.27,"postcode":"159363","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
    ###
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    Then Operator applies filters on Add Shipper To Preset page using data below:
      | shipperCreationDateFrom | {shipper-v4-creation-date-from} |
      | shipperCreationDateTo   | {shipper-v4-creation-date-to}   |
    And Operator applies "UP" sorting to "Creation Date" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Creation Date" column on Add Shipper To Preset page
    When Operator applies "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" filter to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | address                                                              |
      | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithSpaceDelimiter2} |
    When Operator clear column filters on Add Shipper To Preset page
    And Operator applies "UP" sorting to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Address" column on Add Shipper To Preset page
    When Operator applies "{shipper-v4-name}" filter to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | name              |
      | {shipper-v4-name} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Name" column on Add Shipper To Preset page
    When Operator applies "{shipper-v4-legacy-id}" filter to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | legacyId               |
      | {shipper-v4-legacy-id} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
    When Operator applies "Active" filter to "Is Active" column on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Is Active" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Is Active" column on Add Shipper To Preset page

  @DeleteShipper @CloseNewWindows @MediumPriority
  Scenario: Operator Filter Inactive Shipper on Add Shipper To Preset Page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {inactive-shipper-id}                                                                                                                                                                                                                                                                                                                       |
      | generateAddress       | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | shipperAddressRequest | {"name":"{shipper-v4-name}","contact":"{shipper-v4-contact}","email":"{shipper-v4-email}","address1":"address1","address2":"address2","country":"SG","latitude":1.27,"longitude":103.27,"postcode":"159363","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{inactive-shipper-legacy-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
    ###
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    Then Operator applies filters on Add Shipper To Preset page using data below:
      | shipperCreationDateFrom | {inactive-shipper-creation-date-from} |
      | shipperCreationDateTo   | {inactive-shipper-creation-date-to}   |
    And Operator applies "UP" sorting to "Creation Date" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Creation Date" column on Add Shipper To Preset page
    When Operator applies "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" filter to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | address                                                              |
      | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineAddressWithSpaceDelimiter2} |
    When Operator clear column filters on Add Shipper To Preset page
    And Operator applies "UP" sorting to "Shipper Address" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Address" column on Add Shipper To Preset page
    When Operator applies "{inactive-shipper-name}" filter to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | name                    |
      | {inactive-shipper-name} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Name" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Name" column on Add Shipper To Preset page
    When Operator applies "{inactive-shipper-legacy-id}" filter to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify records on Add Shipper To Preset page using data below:
      | legacyId                     |
      | {inactive-shipper-legacy-id} |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
    When Operator applies "Inactive" filter to "Is Active" column on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Is Active" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Is Active" column on Add Shipper To Preset page

  @DeleteShipper @MediumPriority
  Scenario: Operator Downloads List of Shippers CSV file in Add Shipper to Preset Page - Download Only Inactive Shipper
    When Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    Then Operator applies filters on Add Shipper To Preset page using data below:
      | shipperCreationDateFrom | {inactive-shipper-creation-date-from} |
      | shipperCreationDateTo   | {inactive-shipper-creation-date-to}   |
    When Operator clear column filters on Add Shipper To Preset page
    When Operator applies "UP" sorting to "Shipper Id" column on Add Shipper To Preset page
    Then Operator verify "UP" sorting is applied to "Shipper Id" column on Add Shipper To Preset page
    When Operator applies "Inactive" filter to "Is Active" column on Add Shipper To Preset page
    And Operator saves displayed shipper results
    And Operator clicks Download CSV button on Add Shipper To Preset page
    Then Operator verify that CSV file have same line count as shown rows on Add Shipper To Preset page

  
  @MediumPriority
  Scenario: Operator Downloads List of Shippers CSV file in Add Shipper to Preset Page - Download Only Active Shipper
    Given Operator go to menu Pick Ups -> Add Shipper To Preset
    And Add Shipper To Preset page is loaded
    And Operator clicks Load Selection on Add Shipper To Preset page
    And Operator applies "Active" filter to "Is Active" column on Add Shipper To Preset page
    And Operator clicks Download CSV button on Add Shipper To Preset page
    Then Operator verify that CSV file have same line count as shown rows on Add Shipper To Preset page

#    TODO There is no Shipper Pickups page anymore
  @wip
  @DeleteShipper @DeleteShipperPickupFilterTemplate @CloseNewWindows @HighPriority
  Scenario: Operator Add New Shipper to Existing Shipper Pickup Preset Filters on Add Shipper to Preset Page - Single Address - Inactive Shipper (uid:958ed81a-3f3e-456d-ad3d-a6614269253e)
    Given API Operator creates new Shipper Pickup Filter Template using data below:
      | name                      | TA_TEMPLATE_{gradle-current-date-yyyyMMddHHmmsss} |
      | value.reservationTimeFrom | {gradle-current-date-yyyy-MM-dd}                  |
      | value.reservationTimeTo   | {gradle-current-date-yyyy-MM-dd}                  |
      | value.typeIds             | 0                                                 |
      | value.waypointStatuses    | Pending,Routed                                    |
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
      | shipperCreationDateFrom | {date: 0 days next, dd/MM/yyyy} |
      | shipperCreationDateTo   | {date: 0 days next, dd/MM/yyyy} |
    When Operator clicks Load Selection on Add Shipper To Preset page
    And Operator applies "Inactive" filter to "Is Active" column on Add Shipper To Preset page
    When Operator adds shipper to preset on Add Shipper To Preset page using data below:
      | shipperName | {KEY_CREATED_SHIPPER.name}                        |
      | presetName  | {KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name} |
#    And Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator selects "{KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name}" Filter Preset on Shipper Pickups page
#    Then Operator verifies filter parameters on Shipper Pickups page using data below:
#      | shippers | {KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name} |

#    TODO There is no Shipper Pickups page anymore
#  @DeleteShipper @DeleteShipperPickupFilterTemplate @CloseNewWindows @HighPriority
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
#      | shipperCreationDateFrom | {date: 0 days next, dd/MM/yyyy} |
#      | shipperCreationDateTo   | {date: 0 days next, dd/MM/yyyy} |
#    When Operator clicks Load Selection on Add Shipper To Preset page
#    And Operator applies "Active" filter to "Is Active" column on Add Shipper To Preset page
#    When Operator adds shipper to preset on Add Shipper To Preset page using data below:
#      | shipperName | {KEY_CREATED_SHIPPER.name}                        |
#      | presetName  | {KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name} |
#    And Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator selects "{KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE.name}" Filter Preset on Shipper Pickups page
#    Then Operator verifies filter parameters on Shipper Pickups page using data below:
#      | shippers | {KEY_CREATED_SHIPPER.legacyId}-{KEY_CREATED_SHIPPER.name} |

#  TODO There is no Shipper Pickups page anymore
#  @DeleteShipper @DeleteShipperPickupFilterTemplate @CloseNewWindows @HighPriority
#  Scenario: Operator Add New Shipper to Existing Shipper Pickup Preset Filters on Add Shipper to Preset Page - Single Address - All Shippers
#    Given API Lighthouse - Create Preset Filter For Pickup Appointment Job with data below:
#      | createPresetFiltersRequest | {"name":"PAJ_TEMPLATE_{date: 0 days next, yyyyMMddHHmmss}","value":{"priority":{"value":"All","label":"All"},"shippers":[],"master_shippers":[],"zones":[],"job_status":[{"value":"ready-for-routing","label":"Ready for Routing"},{"value":"routed","label":"Routed"}],"service_level":[],"service_type":[{"value":"Scheduled","label":"Scheduled"}]}} |
#    Given API Shipper - Operator create new shipper using data below:
#      | shipperType | Normal |
#    And API Shipper - Operator wait until shipper available to search using data below:
#      | searchShipperRequest | {"search_field":{"match_type":"default","fields":["id"],"value":{KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}}} |
#    And API Shipper - Operator edit shipper value of pickup appointment using below data:
#      | shipperId | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].id} |
#      | status    | False                                |
#    And API Shipper - Operator update shipper setting using data below:
#      | shipperId               | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}                                                                                                                                                                                                                                                                                        |
#      | shipperSettingNamespace | pickup                                                                                                                                                                                                                                                                                                                      |
#      | shipperSettingRequest   | {"address_limit":10,"allow_premium_pickup_on_sunday":true,"allow_standard_pickup_on_sunday":true,"premium_pickup_daily_limit":100,"milk_run_pickup_limit":10,"default_start_time":"09:00","default_end_time":"22:00","service_type_level":[{"type":"Scheduled","level":"Standard"},{"type":"Scheduled","level":"Premium"}]} |
#    Given API Shipper - Operator create new shipper address using data below:
#      | shipperId             | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}                                                                                                                                                                                                                                                                                                                                                                       |
#      | generateAddress       | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                     |
#      | shipperAddressRequest | {"name":"{KEY_SHIPPER_LIST_OF_SHIPPERS[1].name}","contact":"{KEY_SHIPPER_LIST_OF_SHIPPERS[1].contact}","email":"{KEY_SHIPPER_LIST_OF_SHIPPERS[1].email}","address1":"address1","address2":"address2","country":"SG","latitude":1.27,"longitude":103.27,"postcode":"159363","milkrun_settings":[{"start_time":"09:00","end_time":"12:00","days":[1,2,3,4,5,6,7],"no_of_reservation":1}],"is_milk_run":true} |
#    And API Shipper - Operator fetch shipper id by legacy shipper id "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}"
#    And API Shipper - Operator get all shipper addresses by shipper global id "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].id}"
#    And API Core - Operator create reservation using data below:
#      | reservationRequest | {"legacy_shipper_id":{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}, "pickup_address_id":{KEY_SHIPPER_LIST_OF_SHIPPER_ADDRESSES[1].id}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T09:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T12:00:00{gradle-timezone-XXX}" } |
#    ####
#    When Operator go to menu Pick Ups -> Add Shipper To Preset
#    And Add Shipper To Preset page is loaded
#    Then Operator validates filter values on Add Shipper To Preset page using data below:
#      | shipperCreationDateFrom | {date: 0 days next, dd/MM/yyyy} |
#      | shipperCreationDateTo   | {date: 0 days next, dd/MM/yyyy} |
#    When Operator clicks Load Selection on Add Shipper To Preset page
#    When Operator applies "{KEY_SHIPPER_LIST_OF_SHIPPERS[1].name}" filter to "Shipper Name" column on Add Shipper To Preset page
#    Then Operator verify records on Add Shipper To Preset page using data below:
#      | createdAt                       | name                                   | legacyId                                   |
#      | {date: 0 days next, yyyy-MM-dd} | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].name} | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId} |
#    When Operator adds shipper to preset on Add Shipper To Preset page using data below:
#      | shipperName | {KEY_SHIPPER_LIST_OF_SHIPPERS[1].name}              |
#      | presetName  | {KEY_LIGHTHOUSE_CREATED_PRESET_PAJOBS[1].data.name} |
#    And Operator goes to Pickup Jobs Page
#    And Operator select Preset with name = "{KEY_LIGHTHOUSE_CREATED_PRESET_PAJOBS[1].data.name}" in pickup appointment
#    And Operator verifies selected filters on Pickup Jobs page:
#      | shippers | [{KEY_SHIPPER_LIST_OF_SHIPPERS[1].legacyId}-{KEY_SHIPPER_LIST_OF_SHIPPERS[1].name}] |

#    TODO There is no Shipper Pickups page anymore
#  @DeleteShipper @@DeleteFilterTemplate @CloseNewWindows @HighPriority
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

