@FailedPickupManagement @selenium
Feature: Failed Pickup Management

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ArchiveRoute
  Scenario Outline: Operator find failed pickup C2C/Return order on Failed Pickup orders list (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"<fromEmail>","from_name":"<fromName>","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"<toEmail>","to_name":"<toName>","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id},"hubId":{hub-id},"vehicleId":{vehicle-id},"driverId":{ninja-driver-id},"date":"{{formatted_route_date}}","comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}}."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}","type":"PP"} |
    And Operator start the route
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Driver failed the C2C/Return order pickup
    And op refresh page
    When op click navigation Failed Pickup Management in Shipper Support
    Then Operator verify the failed pickup C2C/Return order is listed on Failed Pickup orders list
    Examples:
      | Note   | hiptest-uid                              | orderType | fromName                         | fromEmail                                    | toName                           | toEmail                                     |
      | C2C    | uid:8e27fdff-334b-4fc3-b0b6-a2826ba284c0 | C2C       | S-C-{{tracking_ref_no}} Shipper  | shipper.c2c.{{tracking_ref_no}}@test.com     | C-C-{{tracking_ref_no}} Customer | customer.c2c.{{tracking_ref_no}}@test.com   |
      | Return | uid:fa0d5e83-ac12-4629-a416-c76577f683b3 | Return    | C-R-{{tracking_ref_no}} Customer | customer.return.{{tracking_ref_no}}@test.com | S-R-{{tracking_ref_no}} Shipper  | shipper.return.{{tracking_ref_no}}@test.com |

  @ArchiveRoute
  Scenario Outline: Operator download and verify CSV file of failed pickup C2C/Return order on Failed Pickup orders list (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"<fromEmail>","from_name":"<fromName>","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"<toEmail>","to_name":"<toName>","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id},"hubId":{hub-id},"vehicleId":{vehicle-id},"driverId":{ninja-driver-id},"date":"{{formatted_route_date}}","comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}}."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}","type":"PP"} |
    And Operator start the route
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Driver failed the C2C/Return order pickup
    And op refresh page
    When op click navigation Failed Pickup Management in Shipper Support
    And Operator download CSV file of failed pickup C2C/Return order on Failed Pickup orders list
    Then Operator verify CSV file of failed pickup C2C/Return order on Failed Pickup orders list downloaded successfully
    Examples:
      | Note   | hiptest-uid                              | orderType | fromName                         | fromEmail                                    | toName                           | toEmail                                     |
      | C2C    | uid:821b30e9-26a2-4e52-a6fd-d5f426599751 | C2C       | S-C-{{tracking_ref_no}} Shipper  | shipper.c2c.{{tracking_ref_no}}@test.com     | C-C-{{tracking_ref_no}} Customer | customer.c2c.{{tracking_ref_no}}@test.com   |
      | Return | uid:047a8650-493c-4da3-a80e-f3efa0b08cd5 | Return    | C-R-{{tracking_ref_no}} Customer | customer.return.{{tracking_ref_no}}@test.com | S-R-{{tracking_ref_no}} Shipper  | shipper.return.{{tracking_ref_no}}@test.com |

  @ArchiveRoute
  Scenario Outline: Operator reschedule failed pickup C2C/Return order on next day (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"<fromEmail>","from_name":"<fromName>","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"<toEmail>","to_name":"<toName>","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id},"hubId":{hub-id},"vehicleId":{vehicle-id},"driverId":{ninja-driver-id},"date":"{{formatted_route_date}}","comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}}."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}","type":"PP"} |
    And Operator start the route
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Driver failed the C2C/Return order pickup
    And op refresh page
    When op click navigation Failed Pickup Management in Shipper Support
    And Operator reschedule failed pickup C2C/Return order on next day
    Then Operator verify failed pickup C2C/Return order rescheduled on next day successfully
    And Operator verify order info after failed pickup C2C/Return order rescheduled on next day
    Examples:
      | Note   | hiptest-uid                              | orderType | fromName                         | fromEmail                                    | toName                           | toEmail                                     |
      | C2C    | uid:815e700a-68f7-4b89-a9a0-ffbd8c5cbcdb | C2C       | S-C-{{tracking_ref_no}} Shipper  | shipper.c2c.{{tracking_ref_no}}@test.com     | C-C-{{tracking_ref_no}} Customer | customer.c2c.{{tracking_ref_no}}@test.com   |
      | Return | uid:5d699f49-f393-402b-92f9-8b676ebce0fb | Return    | C-R-{{tracking_ref_no}} Customer | customer.return.{{tracking_ref_no}}@test.com | S-R-{{tracking_ref_no}} Shipper  | shipper.return.{{tracking_ref_no}}@test.com |

  @ArchiveRoute
  Scenario Outline: Operator reschedule failed pickup C2C/Return order on specific date (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"<fromEmail>","from_name":"<fromName>","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"<toEmail>","to_name":"<toName>","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id},"hubId":{hub-id},"vehicleId":{vehicle-id},"driverId":{ninja-driver-id},"date":"{{formatted_route_date}}","comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}}."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}","type":"PP"} |
    And Operator start the route
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Driver failed the C2C/Return order pickup
    And op refresh page
    When op click navigation Failed Pickup Management in Shipper Support
    And Operator reschedule failed pickup C2C/Return order on next 2 days
    Then Operator verify failed pickup C2C/Return order rescheduled on next 2 days successfully
    And Operator verify order info after failed pickup C2C/Return order rescheduled on next 2 days
    Examples:
      | Note   | hiptest-uid                              | orderType | fromName                         | fromEmail                                    | toName                           | toEmail                                     |
      | C2C    | uid:bec16db3-4ee0-4334-8a2f-d090a4f681cd | C2C       | S-C-{{tracking_ref_no}} Shipper  | shipper.c2c.{{tracking_ref_no}}@test.com     | C-C-{{tracking_ref_no}} Customer | customer.c2c.{{tracking_ref_no}}@test.com   |
      | Return | uid:97126afe-c6ab-4aff-9dca-fc19ba021727 | Return    | C-R-{{tracking_ref_no}} Customer | customer.return.{{tracking_ref_no}}@test.com | S-R-{{tracking_ref_no}} Shipper  | shipper.return.{{tracking_ref_no}}@test.com |

  @KillBrowser
  Scenario: Kill Browser
