@AddParcelToRoute @selenium
Feature: Add Parcel To Route

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ArchiveRoute
  Scenario: Add Parcel To Route (uid:f0213ffe-ff22-43cd-89e3-9f3abbe581e6)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"Normal","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    Given op click navigation 2. Route Group Management in Routing
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When op click navigation 2. Route Group Management in Routing
    Then new 'route group' on 'Route Groups' created successfully
    Given op click navigation 1. Create Route Groups in Routing
    Given Operator V2 add created Transaction to Route Group
    Given Operator create new route using data below:
      | createRouteRequest | {"zoneId":16, "hubId":1, "vehicleId":880, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"(Add Parcel to Route) This route is created for testing purpose only. Ignore this route. Created at {{created_date}}."} |
    #Note: Tag ZZZ = 250
    Given Operator set route tags [250]
    Given op click navigation 4. Route Engine - Bulk Add to Route in Routing
    When Operator V2 choose route group, select tag "ZZZ" and submit
    Then verify parcel added to route
    Given op click navigation 2. Route Group Management in Routing
    Then Operator V2 clean up 'Route Groups'

  @KillBrowser
  Scenario: Kill Browser
