@OperatorV2 @Recovery @FailedDeliveryManagementV2 @wip
Feature: Failed Delivery Management Page - Action Feature

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @ActionFeature
  Scenario: Operator - Find Failed Delivery Order - by some filters
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Recovery User - Search failed orders by shipperName = "{KEY_LIST_OF_CREATED_ORDERS[1].shipper.name}"
    And Operator verify failed delivery table on FDM page:
      | trackingId            | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | shipperName           | {KEY_LIST_OF_CREATED_ORDERS[1].shipper.name} |
      | failureReasonComments | {KEY_SELECTED_FAILURE_REASON.description}    |

  @ActionFeature
  Scenario: Operator - Select all shown - Failed Delivery Management page
    Given Operator go to menu Shipper Support -> Failed Delivery Management
    When Operator clicks "Select All Shown" button on Failed Delivery Management page
    And Operator verifies number of selected rows on Failed Delivery Management page

  @ActionFeature
  Scenario: Operator - Deselect all shown - Failed Delivery Management page
    Given Operator go to menu Shipper Support -> Failed Delivery Management
    When Operator clicks "Select All Shown" button on Failed Delivery Management page
    And Operator verifies number of selected rows on Failed Delivery Management page
    When Operator clicks "Deselect All Shown" button on Failed Delivery Management page
    Then Operator verify the number of selected Failed Delivery rows is "0"

  @ActionFeature
  Scenario: Operator - Select all shown - Failed Delivery Management page
    Given Operator go to menu Shipper Support -> Failed Delivery Management
    When Operator clicks "Select All Shown" button on Failed Delivery Management page
    And Operator verifies number of selected rows on Failed Delivery Management page
    When Operator clicks "Clear Current Selection" button on Failed Delivery Management page
    Then Operator verify the number of selected Failed Delivery rows is "0"

  @ActionFeature
  Scenario: Operator - Show only selection - Failed Delivery Management page
    Given Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Wait until Recovery Page loaded completely
    And  Operator selects 1 rows on Failed Delivery Management page
    When Operator clicks "Show Only Selected" button on Failed Delivery Management page
    Then Operator verify the number of selected Failed Delivery rows is "1"

  @ActionFeature
  Scenario: Operator - Download and Verify CSV File
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Recovery User - Search failed orders by trackingId = "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator selects 1 rows on Failed Delivery Management page
    And Recovery User - Download CSV file of failed delivery order on Failed Delivery orders list
    And Recovery User - verify CSV file of failed delivery order on Failed Delivery orders list downloaded successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op