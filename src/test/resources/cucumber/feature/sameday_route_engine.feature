@SamedayRouteEngine @selenium
Feature: Sameday Route Engine

  @LaunchBrowser @SamedayRouteEngine#01 @SamedayRouteEngine#02 @SamedayRouteEngine#03 @SamedayRouteEngine#04 @SamedayRouteEngine#05
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @SamedayRouteEngine#01
  Scenario: Add sameday parcel to route (uid:24baa07a-b688-4586-8a90-e5154031b1f1)
    #Notes: Shipper create sameday parcel with OC V2
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"Normal","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    Given op click navigation 2. Route Group Management in Routing
    Then op wait until 'Route Group' page is loaded
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When op click navigation 2. Route Group Management in Routing
    Then op wait until 'Route Group' page is loaded
    Then new 'route group' on 'Route Groups' created successfully
    Given op click navigation 1. Create Route Groups in Routing
    Given Operator V2 add created Transaction to Route Group
    Given op click navigation 5. Route Engine - Same-Day Route Engine in Routing
    When op 'Run Route Engine' on Same-Day Route Engine menu using data below:
      | hub                             | 30JKB                    |
      | routingAlgorithm                | Same Day Pickup/Delivery |
      | fleetType1OperatingHoursStart   | 0900 hrs                 |
      | fleetType1OperatingHoursEnd     | 2300 hrs                 |
      | fleetType1BreakingDurationStart | 1200 hrs                 |
      | fleetType1BreakingDurationEnd   | 1300 hrs                 |
    Then  op create the suggested route
    Given op click navigation 2. Route Group Management in Routing
    Then Operator V2 clean up 'Route Groups'

  @SamedayRouteEngine#02
  Scenario: Add bulky parcel to route (uid:477e2e7a-76e7-40e7-8355-866783b2faaa)
    Given op refresh page
    #Notes: Shipper create c2c bulky parcel with OC V2
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"C2C","parcels":[{"parcel_size_id":0,"volume":1,"weight":4,"bulky_job":{"installation_required":true,"flight_of_stairs":1,"sku":"AUTOMATA1"}}]} |
    Given op click navigation 2. Route Group Management in Routing
    Then op wait until 'Route Group' page is loaded
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When op click navigation 2. Route Group Management in Routing
    Then op wait until 'Route Group' page is loaded
    Then new 'route group' on 'Route Groups' created successfully
    Given op click navigation 1. Create Route Groups in Routing
    Given Operator V2 add created Transaction to Route Group
    Given op click navigation 5. Route Engine - Same-Day Route Engine in Routing
    When op 'Run Route Engine' on Same-Day Route Engine menu using data below:
      | hub                             | 30JKB                    |
      | routingAlgorithm                | Bulky Pickup/Delivery    |
      | fleetType1OperatingHoursStart   | 0900 hrs                 |
      | fleetType1OperatingHoursEnd     | 2300 hrs                 |
      | fleetType1BreakingDurationStart | 1200 hrs                 |
      | fleetType1BreakingDurationEnd   | 1300 hrs                 |
      | fleetType1Capacity              | 1000000                  |
    Then op create the suggested route
    Given op click navigation 2. Route Group Management in Routing
    Then Operator V2 clean up 'Route Groups'

  @SamedayRouteEngine#03
  Scenario: Download same day route engine csv export (uid:5247e84e-d36d-4ddd-96db-63b5fddfee77)
    Given op refresh page
    #Notes: Shipper create c2c bulky parcel with OC V2
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"C2C","parcels":[{"parcel_size_id":0,"volume":1,"weight":4,"bulky_job":{"installation_required":true,"flight_of_stairs":1,"sku":"AUTOMATA1"}}]} |
    #create another order that outside the operating hour
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 23:15:00","delivery_reach_by":"{{cur_date}} 23:30:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"C2C","parcels":[{"parcel_size_id":0,"volume":1,"weight":4,"bulky_job":{"installation_required":true,"flight_of_stairs":1,"sku":"AUTOMATA1"}}]} |
    Given op click navigation 2. Route Group Management in Routing
    Then op wait until 'Route Group' page is loaded
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When op click navigation 2. Route Group Management in Routing
    Then op wait until 'Route Group' page is loaded
    Then new 'route group' on 'Route Groups' created successfully
    Given op click navigation 1. Create Route Groups in Routing
    Given Operator V2 add created Transactions to Route Group
    Given op click navigation 5. Route Engine - Same-Day Route Engine in Routing
    When op 'Run Route Engine' on Same-Day Route Engine menu using data below:
      | hub                             | 30JKB                    |
      | routingAlgorithm                | Bulky Pickup/Delivery    |
      | fleetType1OperatingHoursStart   | 0900 hrs                 |
      | fleetType1OperatingHoursEnd     | 2300 hrs                 |
      | fleetType1BreakingDurationStart | 1200 hrs                 |
      | fleetType1BreakingDurationEnd   | 1300 hrs                 |
      | fleetType1Capacity              | 1000000                  |
    Then op open same day route engine waypoint detail dialog
    Then op download same day route engine waypoint detail dialog
    Then Operator V2 clean up 'Route Groups'

  @SamedayRouteEngine#04
  Scenario: Check unrouted detail (uid:6b5fa949-deba-41c1-b9e1-0c77e605832b)
    Given op refresh page
    #Notes: Shipper create c2c bulky parcel with OC V2
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"C2C","parcels":[{"parcel_size_id":0,"volume":1,"weight":4,"bulky_job":{"installation_required":true,"flight_of_stairs":1,"sku":"AUTOMATA1"}}]} |
    #create another order that outside the operating hour
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 23:15:00","delivery_reach_by":"{{cur_date}} 23:30:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"C2C","parcels":[{"parcel_size_id":0,"volume":1,"weight":4,"bulky_job":{"installation_required":true,"flight_of_stairs":1,"sku":"AUTOMATA1"}}]} |
    Given op click navigation 2. Route Group Management in Routing
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When op click navigation 2. Route Group Management in Routing
    Then op wait until 'Route Group' page is loaded
    Then new 'route group' on 'Route Groups' created successfully
    Given op click navigation 1. Create Route Groups in Routing
    Given Operator V2 add created Transactions to Route Group
    Given op click navigation 5. Route Engine - Same-Day Route Engine in Routing
    When op 'Run Route Engine' on Same-Day Route Engine menu using data below:
      | hub                             | 30JKB                    |
      | routingAlgorithm                | Bulky Pickup/Delivery    |
      | fleetType1OperatingHoursStart   | 0900 hrs                 |
      | fleetType1OperatingHoursEnd     | 1500 hrs                 |
      | fleetType1Capacity              | 10000                    |
    When op open unrouted detail dialog
    Then op verify the unrouted detail dialog
    Then Operator V2 clean up 'Route Groups'

  @SamedayRouteEngine#05
  Scenario: Update timeslot for bulky parcels (uid:154a1482-33e2-4fff-9a99-ed6a96b289be)
    Given op refresh page
    #Notes: Shipper create c2c bulky parcel with OC V2
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"C2C","parcels":[{"parcel_size_id":0,"volume":1,"weight":4,"bulky_job":{"installation_required":true,"flight_of_stairs":1,"sku":"AUTOMATA1"}}]} |
    Given op click navigation 2. Route Group Management in Routing
    Then op wait until 'Route Group' page is loaded
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When op click navigation 2. Route Group Management in Routing
    Then op wait until 'Route Group' page is loaded
    Then new 'route group' on 'Route Groups' created successfully
    Given op click navigation 1. Create Route Groups in Routing
    Given Operator V2 add created Transactions to Route Group
    Given op click navigation 5. Route Engine - Same-Day Route Engine in Routing
    When op 'Run Route Engine' on Same-Day Route Engine menu using data below:
      | hub                             | 30JKB                    |
      | routingAlgorithm                | Bulky Pickup/Delivery    |
      | fleetType1OperatingHoursStart   | 0900 hrs                 |
      | fleetType1OperatingHoursEnd     | 2300 hrs                 |
      | fleetType1BreakingDurationStart | 1200 hrs                 |
      | fleetType1BreakingDurationEnd   | 1300 hrs                 |
      | fleetType1Capacity              | 1000000                  |
    Then op open same day route engine waypoint detail dialog
    When op update timeslot on same day route engine
    Then op verify the updated timeslot
    Then Operator V2 clean up 'Route Groups'

  @KillBrowser @SamedayRouteEngine#01 @SamedayRouteEngine#02 @SamedayRouteEngine#03 @SamedayRouteEngine#04 @SamedayRouteEngine#05
  Scenario: Kill Browser
