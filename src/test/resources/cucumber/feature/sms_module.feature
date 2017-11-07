@SmsModule @selenium
Feature: SMS Module

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator send sms valid data (uid:553ecbc6-44b4-41b4-86b3-4a864a3fede5)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"Sim Sze Kiat","from_contact":"+6588698632","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"Normal","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    Given op click navigation Messaging Module in Mass Communications
    Then op upload sms campaign csv file
      | tracking_id | name         | email          | job |
      | _created_   | Sim Sze Kiat | qa@ninjavan.co | Dev |
    When op compose sms with data : Sim Sze Kiat, _created_
    Then op send sms

  Scenario: Operator send sms invalid data (uid:4601d827-7a33-4127-92e2-5774fed0c2b0)
    Given op click navigation Messaging Module in Mass Communications
    Then op upload sms campaign csv file
      | tracking_id       | name         | email          | job |
      | SOMERANDOMTRACKID | Sim Sze Kiat | qa@ninjavan.co |	Dev |
    Then op continue on invalid dialog
    Then op verify sms module page resetted

#  Scenario: Check sent sms history (uid:343d98d0-ce45-41da-8821-077af014a561)
#    Given Shipper create Order V2 Parcel using data below:
#      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"Sim Sze Kiat","from_contact":"+6588698632","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"Normal","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
#    Given op click navigation Messaging Module in Mass Communications
#    Then op upload sms campaign csv file
#        | tracking_id | name         | email          | job |
#        | _created_   | Sim Sze Kiat | qa@ninjavan.co |	Dev |
#    When op compose sms with data : Sim Sze Kiat, _created_
#    Then op send sms
#    Then op wait for sms to be processed
#    Then op verify that sms sent to phone number _created_ and tracking id +6588698632

  Scenario: Check sms history with invalid tracking id (uid:b9f8f867-c428-4d7a-96d9-b1c597571c60)
    Given op click navigation Messaging Module in Mass Communications
    Then op verify that tracking id SOMERANDOMTRACKINGID is invalid

  Scenario: Operator using url shortener on sms editor (uid:9ba5f071-f569-41d4-81e5-92316cc34bd3)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"shipper.normal.{{tracking_ref_no}}@test.com","from_name":"Sim Sze Kiat","from_contact":"+6588698632","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"customer.normal.{{tracking_ref_no}}@test.com","to_name":"C-N-{{tracking_ref_no}} Customer","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":0,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","shipper_customer_ref_no":"27","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"Normal","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    Given op click navigation Messaging Module in Mass Communications
    Then op upload sms campaign csv file
      | tracking_id | name         | email          | job |
      | _created_   | Sim Sze Kiat | qa@ninjavan.co | Dev |
    Then op compose sms using url shortener
    Then op verify sms preview using shortened url

  @KillBrowser
  Scenario: Kill Browser
