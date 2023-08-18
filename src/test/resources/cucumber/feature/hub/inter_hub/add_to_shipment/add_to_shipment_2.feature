@OperatorV2 @MiddleMile @Hub @InterHub @AddToShipment2
Feature: Add To Shipment 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteShipment @ForceSuccessOrder
  Scenario: Add Multiple Parcels to Shipment (uid:2b1021d1-828f-437c-a095-baebbae1d8c7)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator add order to shipment in hub "{hub-name}" to hub "{hub-name-2}"
    And Operator close the shipment which has been created

  @HappyPath @DeleteShipment @ForceSuccessOrder
  Scenario: Remove Parcel In Shipment from Action Toggle (uid:ffad1735-0cb1-43ac-a6f2-2fe32cfcfadf)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator add order to shipment in hub "{hub-name}" to hub "{hub-name-2}"
    And Operator removes all the parcel from the shipment
    Then Operator verifies that the parcel shown is zero

  @DeleteShipment @DeleteOrArchiveRoute
  Scenario: Add Arrived at Distribution Point Parcel to Shipment (uid:af227045-0411-4130-a054-124ac1b6edb8)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{dpms-id}"
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator pulled out parcel "DELIVERY" from route
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    Given API Operator get order details
    Given DB Operator get DP job id
    And API Operator do the DP Success for From Driver Flow
    Given API Driver "2.2" success dp drop off
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB}
    And Operator close the shipment which has been created

  @HappyPath @DeleteShipment @ForceSuccessOrder
  Scenario: Add Parcel to Shipment with Alert (uid:21ff371d-e507-453a-9d4a-f37c18037aa7)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    And Set temporary order:
      | constantOrder  | {indonesia-default-order} |
    Then Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
    And Operator verifies that the row of the added order is red highlighted

  @DeleteShipment @ForceSuccessOrder
  Scenario: Add Pending Pickup Parcel to Shipment (uid:8588eec2-d295-4ea2-9760-7aca19564882)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB}
    And Operator close the shipment which has been created

  @DeleteShipment
  Scenario: Add Pending Pickup at Distribution Point Parcel to Shipment (uid:d2181800-29d5-4f12-a344-7198446b0599)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB}
    And Operator verifies that the row of the added order is red highlighted
    And Operator close the shipment which has been created

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
