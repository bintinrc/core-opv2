@OperatorV2 @Core @Order @OrderTagManagement @OrderTagManagementPart2
Feature: Order Tag Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Orders on the Order Tag Management Page by RTS Filter - Show RTS Orders
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created orders:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> Order Tag Management
    Then Operator verifies selected value of RTS filter is "Hide" on Order Tag Management page
    When Operator clicks 'Clear All Selection' button on Order Tag Management page
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | rts | Show |
    Then Operator searches and selects orders created on Order Tag Management page

  Scenario: Search Orders on the Order Tag Management Page by Shipper Filter
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName | {filter-shipper-name} |
    Then Operator searches and selects orders created on Order Tag Management page

  Scenario: Search Orders on the Order Tag Management Page by Master Shipper Filter
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    And API Shipper create multiple V4 orders using data below:
      | v4OrderRequest | {"service_type": "Marketplace","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": true,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}} |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | masterShipperName | {shipper-v4-marketplace-name} |
    Then Operator searches and selects orders created on Order Tag Management page

  Scenario: Search Orders on the Order Tag Management Page by Status & Granular Status Filter
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    Then Operator searches and selects orders created on Order Tag Management page

  Scenario: Search Orders on the Order Tag Management Page by CSV File
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator searches and selects orders created on Order Tag Management page

  @DeleteOrArchiveRoute
  Scenario: Add Order Tag To Route
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And Operator searches and selects orders created on Order Tag Management page
    And Operator tags order with:
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE TAGS                                                                                                                                                                                                   |
      | description | ^Tags updated from none To ({order-tag-name}\|{order-tag-name-2}\|{order-tag-name-3}), ({order-tag-name}\|{order-tag-name-2}\|{order-tag-name-3}), ({order-tag-name}\|{order-tag-name-2}\|{order-tag-name-3}) |
    And Operator verify order event on Edit order page using data below:
      | name | ADD TO ROUTE |
    And DB Operator verifies tags of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order:
      | {order-tag-id}   |
      | {order-tag-id-2} |
      | {order-tag-id-3} |
    And DB Operator verifies order_tags_search record of "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order:
      | orderTagIds | {order-tag-id},{order-tag-id-2},{order-tag-id-3} |
      | routeId     | {KEY_CREATED_ROUTE_ID}                           |
      | driverId    | {KEY_NINJA_DRIVER_ID}                            |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify the tags shown on Edit Order page
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE TAGS                                                                                                                                                                                                   |
      | description | ^Tags updated from none To ({order-tag-name}\|{order-tag-name-2}\|{order-tag-name-3}), ({order-tag-name}\|{order-tag-name-2}\|{order-tag-name-3}), ({order-tag-name}\|{order-tag-name-2}\|{order-tag-name-3}) |
    And Operator verify order event on Edit order page using data below:
      | name | ADD TO ROUTE |
    And DB Operator verifies tags of "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" order:
      | {order-tag-id}   |
      | {order-tag-id-2} |
      | {order-tag-id-3} |
    And DB Operator verifies order_tags_search record of "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" order:
      | orderTagIds | {order-tag-id},{order-tag-id-2},{order-tag-id-3} |
      | routeId     | {KEY_CREATED_ROUTE_ID}                           |
      | driverId    | {KEY_NINJA_DRIVER_ID}                            |

  @KillBrowser
  Scenario: Kill Browser
    Given no-op