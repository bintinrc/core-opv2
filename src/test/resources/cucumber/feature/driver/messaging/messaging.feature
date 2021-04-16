@OperatorV2 @Driver @Messaging
Feature: Messaging

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Driver by First Name (uid:f87966e7-8c79-4770-81a0-53157b0a15dc)
    And DB Operator find drivers by "Driver" first name
    And API Operator find drivers by "Driver" first name
    Then Drivers found by first name using API and DB are the same
    When Operator opens Messaging panel
    And Operator enters "Driver" into Add Driver field on Messaging panel
    Then Drivers found on Messaging panel and in DB are the same

  Scenario: Search Driver by Driver Type Given Less Than 100 Drivers Listed Use Same Type (uid:f31378ea-f465-4de6-96bf-f4f0cb795e80)
    Given Operator refresh page
    And DB Operator find drivers by "{driver-type-name-2}" driver type name
    When Operator opens Messaging panel
    And Operator selects "{driver-type-name-2}" drivers group on Messaging panel
    Then Count of selected drivers is less than 100 on Messaging panel
    And All selected drivers belongs to selected group

  Scenario: Search Driver by Driver Type Given More Than 100 Drivers Listed Use Same Type (uid:dc3045fa-6807-4f19-a603-ea5a4429d88e)
    Given Operator refresh page
    And DB Operator find drivers by "{driver-type-name}" driver type name
    When Operator opens Messaging panel
    And Operator selects "{driver-type-name}" drivers group on Messaging panel
    Then Count of selected drivers is greater than 100 on Messaging panel
    And All selected drivers belongs to selected group

  @DeleteOrArchiveRoute
  Scenario: Send Message To Driver With Unread Status (uid:5d139cac-4663-405f-af77-aa2bee1951df)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    Then Go to order details button is displayed in Chat With Driver dialog
    And Date of "{KEY_CREATED_ORDER_TRACKING_ID}" order is "Today" in Chat With Driver dialog
    When Operator send "test message {gradle-current-date-yyyyMMddHHmmsss}" message to driver in Chat With Driver dialog
    Then message "{KEY_CHAT_MESSAGE}" is displayed in Chat With Driver dialog
    And chat date is "Today" in Chat With Driver dialog
    And Operator close Chat With Driver dialog
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    Then Read label is not displayed Chat With Driver dialog

  @DeleteOrArchiveRoute
  Scenario: Send Message To Driver With Read Status (uid:8b254055-6244-4c13-bc17-dc9c2f23cc96)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    Then Go to order details button is displayed in Chat With Driver dialog
    And Date of "{KEY_CREATED_ORDER_TRACKING_ID}" order is "Today" in Chat With Driver dialog
    When Operator send "test message {gradle-current-date-yyyyMMddHHmmsss}" message to driver in Chat With Driver dialog
    Then message "{KEY_CHAT_MESSAGE}" is displayed in Chat With Driver dialog
    And chat date is "Today" in Chat With Driver dialog
    When DB Driver read "{KEY_CHAT_MESSAGE_ID}" chat message
    And Operator close Chat With Driver dialog
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    Then Read label is displayed Chat With Driver dialog

  @DeleteOrArchiveRoute
  Scenario: Operator Receive And Read Message From Driver (uid:265cec49-c734-48f6-9d41-8acc28551e79)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    When Operator send "test message {gradle-current-date-yyyyMMddHHmmsss}" message to driver in Chat With Driver dialog
    Then message "{KEY_CHAT_MESSAGE}" is displayed in Chat With Driver dialog
    When Operator close Chat With Driver dialog
    And DB Driver replays to chat message "{KEY_CHAT_MESSAGE_ID}" with text "test replay from driver {gradle-current-date-yyyyMMddHHmmsss}"
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    Then Number of replays for "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog is 1
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    Then message "{KEY_CHAT_MESSAGE_FROM_DRIVER}" is displayed in Chat With Driver dialog

  @DeleteOrArchiveRoute
  Scenario: Operator Receive And Reply Message From Driver With Unread Status (uid:98da92c5-4d5e-4af6-a871-4a5fd336b3dd)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    When Operator send "test message {gradle-current-date-yyyyMMddHHmmsss}" message to driver in Chat With Driver dialog
    Then message "{KEY_CHAT_MESSAGE}" is displayed in Chat With Driver dialog
    When Operator close Chat With Driver dialog
    And DB Driver replays to chat message "{KEY_CHAT_MESSAGE_ID}" with text "test replay from driver {gradle-current-date-yyyyMMddHHmmsss}"
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    Then Number of replays for "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog is 1
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    Then message "{KEY_CHAT_MESSAGE_FROM_DRIVER}" is displayed in Chat With Driver dialog
    When Operator send "test message 2 {gradle-current-date-yyyyMMddHHmmsss}" message to driver in Chat With Driver dialog
    Then message "{KEY_CHAT_MESSAGE}" is displayed in Chat With Driver dialog
    And chat date is "Today" in Chat With Driver dialog
    And Operator close Chat With Driver dialog
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    Then Read label is not displayed Chat With Driver dialog

  @DeleteOrArchiveRoute
  Scenario: Operator Receive And Reply Message From Driver With Read Status (uid:24750a4e-01ae-4b00-9b9a-aeae01b293ce)
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    When Operator send "test message {gradle-current-date-yyyyMMddHHmmsss}" message to driver in Chat With Driver dialog
    Then message "{KEY_CHAT_MESSAGE}" is displayed in Chat With Driver dialog
    When Operator close Chat With Driver dialog
    And DB Driver replays to chat message "{KEY_CHAT_MESSAGE_ID}" with text "test replay from driver {gradle-current-date-yyyyMMddHHmmsss}"
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    Then Number of replays for "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog is 1
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    Then message "{KEY_CHAT_MESSAGE_FROM_DRIVER}" is displayed in Chat With Driver dialog
    When Operator send "test message 2 {gradle-current-date-yyyyMMddHHmmsss}" message to driver in Chat With Driver dialog
    Then message "{KEY_CHAT_MESSAGE}" is displayed in Chat With Driver dialog
    And chat date is "Today" in Chat With Driver dialog
    When Operator close Chat With Driver dialog
    And DB Driver read "{KEY_CHAT_MESSAGE_ID}" chat message
    And Operator click Chat With Driver on Edit Order page
    Then Chat With Driver dialog is displayed on Edit Order page
    When Operator click on "{KEY_CREATED_ORDER_TRACKING_ID}" tracking ID in Chat With Driver dialog
    Then Read label is displayed Chat With Driver dialog

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
