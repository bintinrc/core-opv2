@Transactions @selenium
Feature: Transactions

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Add transaction to Route Group (uid:b6848852-12e6-4cba-bf7c-8444538596c1)
    #Notes: Shipper create sameday parcel with OC V2
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"Normal","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |

    #deprecated
#    Given op click navigation Route Group Templates in Routing
#    When op create new 'route group template' on 'Route Group Templates' using data below:
#      | generateName             | false                                                                                         |
#      | routeGroupTemplateFilter | SELECT t FROM Transaction t INNER JOIN FETCH t.order o WHERE o.trackingId = '{{tracking_id}}' |
#    Then new 'route group template' on 'Route Group Templates' created successfully

    Given op click navigation Route Groups in Routing
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | true |
    When op click navigation Route Groups in Routing
    Then new 'route group' on 'Route Groups' created successfully

    Given op click navigation Transactions V2 in Routing
    When Operator V2 add created Transaction to Route Group

    #deprecated
#    Given op click navigation Route Group Templates in Routing
#    Then Operator V2 clean up 'Route Group Templates'

    Given op click navigation Route Groups in Routing
    Then Operator V2 clean up 'Route Groups'

  @KillBrowser
  Scenario: Kill Browser
