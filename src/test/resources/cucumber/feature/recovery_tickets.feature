@RecoveryTickets @selenium
Feature: Recovery Tickets

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Create damage ticket on Recovery Tickets menu (uid:43d733f5-61e2-4877-82c2-ae1ac3220a2b)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"Normal","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    Given op click navigation Recovery Tickets in Recovery
    When op create new ticket on Recovery Tickets menu with this property below:
      | entrySource        | CUSTOMER COMPLAINT        |
      | investigatingParty | DISTRIBUTION POINTS       |
      | ticketType         | DAMAGED                   |
      | ticketSubType      | IMPROPER PACKAGING        |
      | parcelLocation     | DAMAGED RACK              |
      | liability          | NV DRIVER                 |
      | damageDescription  | Dummy damage description. |
      | ticketNotes        | Dummy ticket notes.       |
      | custZendeskId      | 1                         |
      | shipperZendeskId   | 1                         |
      | orderOutcome       | PENDING                   |
    Then verify ticket is created successfully

  Scenario: Create missing ticket on Recovery Tickets menu (uid:dc66d575-0700-44c8-a4bc-2787a5616e64)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"S-N-{{tracking_ref_no}} Shipper","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"Normal","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Recovery Tickets in Recovery
    When op create new ticket on Recovery Tickets menu with this property below:
      | entrySource        | CUSTOMER COMPLAINT        |
      | investigatingParty | DISTRIBUTION POINTS       |
      | ticketType         | MISSING                   |
      | parcelDescription  | Dummy parcel description. |
      | ticketNotes        | Dummy ticket notes.       |
      | custZendeskId      | 1                         |
      | shipperZendeskId   | 1                         |
    Then verify ticket is created successfully

  @KillBrowser
  Scenario: Kill Browser
