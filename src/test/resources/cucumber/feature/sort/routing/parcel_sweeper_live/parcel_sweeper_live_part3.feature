@Sort @Routing @ParcelSweeperLive @ParcelSweeperLivePart3
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - Invalid Tracking ID (uid:1b281bb2-7722-4b80-ab50-22268f366aa2)
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | invalid    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-invalid} |
      | routeId               | Recovery           |
      | routeInfoColor        | {white-hex-color}  |
      | driverName            | Invalid            |
      | routeDescriptionColor | {white-hex-color}  |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Van enroute to pickup (uid:c69dde9c-d01a-439f-94d1-de932d7e84a6)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | {"service_type":"Return","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"{country}","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | PICKUP |
    And API Operator start the route
    When Operator go to menu Routing -> Parcel Sweeper Live
    And Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-not-inbounded} |
      | routeId               | Error                    |
      | routeInfoColor        | {white-hex-color}        |
      | driverName            | Not Inbounded            |
      | routeDescriptionColor | {white-hex-color}        |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van en-route to pickup" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Pickup Fail (uid:1815fa85-51da-45d8-8595-fd33b0df081f)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Return","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | PICKUP |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-not-inbounded} |
      | routeId               | Error                    |
      | routeInfoColor        | {white-hex-color}        |
      | driverName            | Not Inbounded            |
      | routeDescriptionColor | {white-hex-color}        |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Pickup fail" on Edit Order page
    And Operator verify order granular status is "Pickup Fail" on Edit Order page

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - Cancelled (uid:90c01f74-aa3a-451d-82b2-d60c9455f62f)
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    When API Operator cancel created order
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-invalid} |
      | routeId               | Recovery           |
      | routeInfoColor        | {white-hex-color}  |
      | driverName            | Cancelled          |
      | routeDescriptionColor | {white-hex-color}  |
    And DB Operator verifies warehouse_sweeps record
      | trackingId | CREATED  |
      | hubId      | {hub-id} |
    And DB Operator verify order_events record for the created order:
      | type | 27 |
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - should show error when parcel sweep with more than 50 characters
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                                          |
      | trackingId | 123456789111315171921232527293133353739414345474951 |
    Then Operator verifies error toast with "Exception" message is shown

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - should show error when parcel sweep with invalid characters
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name} |
      | trackingId | /          |
    Then Operator verifies error toast with "Exception" message is shown

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op