@FailedDeliveryManagement @selenium
Feature: Failed Delivery Management

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ArchiveRoute
  Scenario Outline: Operator find failed delivery order on Failed Delivery orders list (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"<fromEmail>","from_name":"<fromName>","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"<toEmail>","to_name":"<toName>","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | {"scan":"{{order_tracking_id}}","type":"SORTING_HUB","hubId":1} |
    And Operator create new route using data below:
      | createRouteRequest | {"zoneId":{zone-id},"hubId":{hub-id},"vehicleId":{vehicle-id},"driverId":{ninja-driver-id},"date":"{{formatted_route_date}}","comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}}."} |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | {"trackingId":"{{order_tracking_id}}","type":"DD"} |
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Operator Van Inbound  parcel
    And Operator start the route
    And Driver failed the delivery for created parcel
    And op refresh page
    When op click navigation Failed Delivery Management in Shipper Support
    Then Operator verify the failed delivery order is listed on Failed Delivery orders list
    Examples:
      | Note   | hiptest-uid                              | orderType | fromName                         | fromEmail                                    | toName                           | toEmail                                      |
      | Normal | uid:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Normal    | S-N-{{tracking_ref_no}} Shipper  | shipper.normal.{{tracking_ref_no}}@test.com  | C-N-{{tracking_ref_no}} Customer | customer.normal.{{tracking_ref_no}}@test.com |
      | C2C    | uid:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | C2C       | S-C-{{tracking_ref_no}} Shipper  | shipper.c2c.{{tracking_ref_no}}@test.com     | C-C-{{tracking_ref_no}} Customer | customer.c2c.{{tracking_ref_no}}@test.com    |
      | Return | uid:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Return    | C-R-{{tracking_ref_no}} Customer | customer.return.{{tracking_ref_no}}@test.com | S-R-{{tracking_ref_no}} Shipper  | shipper.return.{{tracking_ref_no}}@test.com  |

  @KillBrowser
  Scenario: Kill Browser
