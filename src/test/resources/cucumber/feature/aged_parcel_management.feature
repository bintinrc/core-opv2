@AgedParcelManagement @selenium
Feature: Aged Parcel Management

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario Outline: Operator find aged parcel on Aged Parcels list (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"<fromEmail>","from_name":"<fromName>","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"<toEmail>","to_name":"<toName>","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | {"scan":"{{order_tracking_id}}","type":"SORTING_HUB","hubId":1} |
    Then Operator verify order info after Global Inbound
    When op refresh page
    And op click navigation Aged Parcel Management in Shipper Support
    And operator load selection on page Aged Parcel Management
    Then Operator verify the aged parcel order is listed on Aged Parcels list
    Examples:
      | Note   | hiptest-uid                              | orderType | fromName                         | fromEmail                                    | toName                           | toEmail                                      |
      | Normal | uid:8a1ccb26-2942-414e-b95c-9af308fce884 | Normal    | S-N-{{tracking_ref_no}} Shipper  | shipper.normal.{{tracking_ref_no}}@test.com  | C-N-{{tracking_ref_no}} Customer | customer.normal.{{tracking_ref_no}}@test.com |
      | C2C    | uid:161bd183-ed16-4a6a-96dc-b436ac03b68a | C2C       | S-C-{{tracking_ref_no}} Shipper  | shipper.c2c.{{tracking_ref_no}}@test.com     | C-C-{{tracking_ref_no}} Customer | customer.c2c.{{tracking_ref_no}}@test.com    |
      | Return | uid:06ff2483-15ab-4943-8935-ce18e11d78c8 | Return    | C-R-{{tracking_ref_no}} Customer | customer.return.{{tracking_ref_no}}@test.com | S-R-{{tracking_ref_no}} Shipper  | shipper.return.{{tracking_ref_no}}@test.com  |

  Scenario Outline: Operator download and verify CSV file of aged parcel on Aged Parcels list (<hiptest-uid>)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | {"from_postcode":"159363","from_address1":"30 Jalan Kilang Barat","from_address2":"Ninja Van HQ","from_city":"SG","from_state":"SG","from_country":"SG","from_email":"<fromEmail>","from_name":"<fromName>","from_contact":"91234567","to_postcode":"318993","to_address1":"998 Toa Payoh North","to_address2":"#01-10","to_city":"SG","to_state":"SG","to_country":"SG","to_email":"<toEmail>","to_name":"<toName>","to_contact":"98765432","delivery_date":"{{cur_date}}","pickup_date":"{{cur_date}}","pickup_reach_by":"{{cur_date}} 15:00:00","delivery_reach_by":"{{cur_date}} 17:00:00","weekend":true,"staging":false,"pickup_timewindow_id":1,"delivery_timewindow_id":2,"max_delivery_days":1,"cod_goods":null,"cod_shipping":null,"instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}}.","tracking_ref_no":"{{tracking_ref_no}}","shipper_order_ref_no":"{{tracking_ref_no}}","type":"<orderType>","parcels":[{"parcel_size_id":0,"volume":1,"weight":4}]} |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | {"scan":"{{order_tracking_id}}","type":"SORTING_HUB","hubId":1} |
    Then Operator verify order info after Global Inbound
    When op refresh page
    And op click navigation Aged Parcel Management in Shipper Support
    And operator load selection on page Aged Parcel Management
    And Operator download CSV file of aged parcel on Aged Parcels list
    Then Operator verify CSV file of aged parcel on Aged Parcels list downloaded successfully
    Examples:
      | Note   | hiptest-uid                              | orderType | fromName                         | fromEmail                                    | toName                           | toEmail                                      |
      | Normal | uid:e373ff7a-82a6-4aa8-af5c-d2f6f33ffe4f | Normal    | S-N-{{tracking_ref_no}} Shipper  | shipper.normal.{{tracking_ref_no}}@test.com  | C-N-{{tracking_ref_no}} Customer | customer.normal.{{tracking_ref_no}}@test.com |
      | C2C    | uid:99caafe0-64c9-4193-9612-735ed3a7603f | C2C       | S-C-{{tracking_ref_no}} Shipper  | shipper.c2c.{{tracking_ref_no}}@test.com     | C-C-{{tracking_ref_no}} Customer | customer.c2c.{{tracking_ref_no}}@test.com    |
      | Return | uid:2d953665-c7e7-4227-87ff-c7be43bb8516 | Return    | C-R-{{tracking_ref_no}} Customer | customer.return.{{tracking_ref_no}}@test.com | S-R-{{tracking_ref_no}} Shipper  | shipper.return.{{tracking_ref_no}}@test.com  |

  @KillBrowser
  Scenario: Kill Browser
