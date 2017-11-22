@FailedDeliveryManagement @selenium
Feature: Failed Delivery Management

  @LaunchBrowser @FailedDeliveryManagement#01 @FailedDeliveryManagement#02 @FailedDeliveryManagement#03 @FailedDeliveryManagement#04 @FailedDeliveryManagement#05 @FailedDeliveryManagement#06
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ArchiveRoute @FailedDeliveryManagement#01
  Scenario Outline: Operator find failed delivery order on Failed Delivery orders list (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}} by feature @FailedDeliveryManagement.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | {"scan":"{{order_tracking_id}}", "type":"SORTING_HUB", "hubId":{hub-id}} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}} by feature @FailedDeliveryManagement."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}", "type":"DD"} |
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Operator Van Inbound  parcel
    And Operator start the route
    And Driver failed the delivery for created parcel
    And Operator refresh page
    When Operator go to menu Shipper Support -> Failed Delivery Management
    Then Operator verify the failed delivery order is listed on Failed Delivery orders list
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:01c6c399-c7b8-417b-bbc1-4f716b7b5f67 | Normal    |
      | C2C    | uid:e814f4c6-51fa-4173-bcdd-2367374ca992 | C2C       |
      | Return | uid:8d0c07a5-1801-409d-a454-487c32481cd0 | Return    |

  @ArchiveRoute @FailedDeliveryManagement#02
  Scenario Outline: Operator download and verify CSV file of failed delivery order on Failed Delivery orders list (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}} by feature @FailedDeliveryManagement.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | {"scan":"{{order_tracking_id}}", "type":"SORTING_HUB", "hubId":{hub-id}} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}} by feature @FailedDeliveryManagement."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}", "type":"DD"} |
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Operator Van Inbound  parcel
    And Operator start the route
    And Driver failed the delivery for created parcel
    And Operator refresh page
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator download CSV file of failed delivery order on Failed Delivery orders list
    Then Operator verify CSV file of failed delivery order on Failed Delivery orders list downloaded successfully
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:a70d0a54-5ce8-4c4e-b892-2074476c8131 | Normal    |
      | C2C    | uid:8b9dfe3a-9f70-47e4-82b9-ab596f207ad1 | C2C       |
      | Return | uid:e5dba9b6-059e-4701-9981-0a8e02da35c0 | Return    |

  @ArchiveRoute @FailedDeliveryManagement#03
  Scenario Outline: Operator reschedule failed delivery order on next day (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}} by feature @FailedDeliveryManagement.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | {"scan":"{{order_tracking_id}}", "type":"SORTING_HUB", "hubId":{hub-id}} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}} by feature @FailedDeliveryManagement."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}", "type":"DD"} |
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Operator Van Inbound  parcel
    And Operator start the route
    And Driver failed the delivery for created parcel
    And Operator refresh page
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator reschedule failed delivery order on next day
    Then Operator verify failed delivery order rescheduled on next day successfully
    And Operator verify order info after failed delivery order rescheduled on next day
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:24a27638-888c-4283-8110-dbb04b8b8abd | Normal    |
      | C2C    | uid:64319e55-cd97-44d4-bed7-5ff3486e9744 | C2C       |
      | Return | uid:214ce346-60d9-41bd-a657-6e79b7f7f35b | Return    |

  @ArchiveRoute @FailedDeliveryManagement#04
  Scenario Outline: Operator reschedule failed delivery order on specific date (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}} by feature @FailedDeliveryManagement.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | {"scan":"{{order_tracking_id}}", "type":"SORTING_HUB", "hubId":{hub-id}} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}} by feature @FailedDeliveryManagement."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}", "type":"DD"} |
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Operator Van Inbound  parcel
    And Operator start the route
    And Driver failed the delivery for created parcel
    And Operator refresh page
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator reschedule failed delivery order on next 2 days
    Then Operator verify failed delivery order rescheduled on next 2 days successfully
    And Operator verify order info after failed delivery order rescheduled on next 2 days
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:88e1c317-20e4-4ef5-9ed5-905888f35b69 | Normal    |
      | C2C    | uid:29039bb4-431e-4af2-b5c8-14c94771433d | C2C       |
      | Return | uid:e5c1e60c-24d1-4b98-9454-db3efe876006 | Return    |

  @ArchiveRoute @FailedDeliveryManagement#05
  Scenario Outline: Operator RTS failed delivery order on next day (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}} by feature @FailedDeliveryManagement.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | {"scan":"{{order_tracking_id}}", "type":"SORTING_HUB","hubId":{hub-id}} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}} by feature @FailedDeliveryManagement."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}", "type":"DD"} |
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Operator Van Inbound  parcel
    And Operator start the route
    And Driver failed the delivery for created parcel
    And Operator refresh page
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator RTS failed delivery order on next day
    Then Operator verify failed delivery order RTS-ed successfully
    And Operator verify order info after failed delivery order RTS-ed on next day
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:3e01ecc1-4e17-4b26-bc30-65711dd73133 | Normal    |
      | C2C    | uid:a9db815b-1187-4cee-81fd-c5f4ccec8d56 | C2C       |
      | Return | uid:f298d342-ebb3-4a49-ab04-0b7f13c004d3 | Return    |

  @ArchiveRoute @FailedDeliveryManagement#06
  Scenario Outline: Operator RTS selected failed delivery order on next day (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}} by feature @FailedDeliveryManagement.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | {"scan":"{{order_tracking_id}}", "type":"SORTING_HUB", "hubId":{hub-id}} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}} by feature @FailedDeliveryManagement."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}", "type":"DD"} |
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Operator Van Inbound  parcel
    And Operator start the route
    And Driver failed the delivery for created parcel
    And Operator refresh page
    When Operator go to menu Shipper Support -> Failed Delivery Management
    And Operator RTS selected failed delivery order on next day
    Then Operator verify failed delivery order RTS-ed successfully
    And Operator verify order info after failed delivery order RTS-ed on next day
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:247a00f4-ddfd-408f-b3be-bb524997c5b7 | Normal    |
      | C2C    | uid:d58e4b07-fe50-43ac-8816-7aa53203bab3 | C2C       |
      | Return | uid:fe1c3969-5bf0-4cad-b94e-a9363fe8e3fa | Return    |

  @KillBrowser @FailedDeliveryManagement#01 @FailedDeliveryManagement#02 @FailedDeliveryManagement#03 @FailedDeliveryManagement#04 @FailedDeliveryManagement#05 @FailedDeliveryManagement#06
  Scenario: Kill Browser
