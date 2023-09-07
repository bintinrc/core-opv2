@OperatorV2 @Core @NewFeatures @UpdateDeliveryAddressWithCSV @UpdateDeliveryAddressWithCSVPart1
Feature: Update Delivery Address with CSV

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path
  Scenario: Bulk Update Order Delivery Address with CSV - Valid Order Status
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                            | toAddressAddress1 | toAddressAddress2 | toAddressPostcode | toAddressCity | toAddressCountry | toAddressState | toAddressDistrict | toAddressLatitude | toAddressLongitude |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | 9 TUA KONG GREEN  | addr 2            | 455384            | SG            | SG               | Singapore      | district          | 1.3184395712682   | 103.925311276846   |
    Then Operator verify updated addresses on Update Delivery Address with CSV page
    When Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator verify addresses were updated successfully on Update Delivery Address with CSV page
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator unmask Delivery details on Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | address | {KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES[1].buildString} |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | toAddress1 | 9 TUA KONG GREEN                   |
      | toAddress2 | addr 2                             |
      | toPostcode | 455384                             |
      | toCity     | SG                                 |
      | toCountry  | SG                                 |
      | toState    | Singapore                          |
      | toDistrict | district                           |
    Then DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | type       | DD                                                         |
      | address1   | 9 TUA KONG GREEN                                           |
      | address2   | addr 2 Singapore district                                  |
      | postcode   | 455384                                                     |
      | city       | SG                                                         |
      | country    | SG                                                         |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1      | 9 TUA KONG GREEN                                           |
      | address2      | addr 2 Singapore district                                  |
      | postcode      | 455384                                                     |
      | city          | SG                                                         |
      | country       | SG                                                         |
      | latitude      | 1.3184395712682                                            |
      | longitude     | 103.925311276846                                           |
      | routingZoneId | 22861                                                      |
    Then Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE CONTACT INFORMATION |
    When Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                                                                                   |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 9 TUA KONG GREEN addr 2\|Singapore\|SG\|district\|455384 Address Type: ADDRESS_TYPE_DELIVERY Zone ID: 22861 Destination Hub ID: 387 Lat, Long: 1.3184395712682, 103.925311276846 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |

  Scenario: Bulk Update Order Delivery Address with CSV - Empty File
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses of with empty CSV file:
    Then Operator verifies that error react notification displayed:
      | top | Invalid data in the csv file |

  Scenario: Bulk Update Order Delivery Address with CSV - Invalid Order/Format
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses of given orders on Update Delivery Address with CSV page:
      | SOMEINVALIDTRACKINGID |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId            | status              |
      | SOMEINVALIDTRACKINGID | Invalid tracking Id |

  Scenario: Bulk Update Order Delivery Address with CSV - Partial
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses of given orders on Update Delivery Address with CSV page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | SOMEINVALIDTRACKINGID                 |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                            | status              |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Pass                |
      | SOMEINVALIDTRACKINGID                 | Invalid tracking Id |

  Scenario: Bulk Update Order Delivery Address with CSV - Empty Compulsory Fields
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                            | toName | toEmail | toPhoneNumber | toAddressAddress1 | toAddressAddress2 | toAddressPostcode | toAddressCity | toAddressCountry | toAddressState | toAddressDistrict |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | empty  | empty   | empty         | empty             | empty             | empty             | empty         | empty            | empty          | empty             |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                            | status                                                                                                                                                                                           |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Require to fill in to.name, to.email, to.phone_number, to.address.address1, to.address.address2, to.address.postcode, to.address.city, to.address.country, to.address.state, to.address.district |

  Scenario Outline: Bulk Update Order Delivery Address with CSV - With Technical Issues
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                            | toName  | toEmail | toPhoneNumber | toAddressAddress1 | toAddressAddress2 | toAddressPostcode | toAddressCity | toAddressCountry | toAddressState | toAddressDistrict |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | <value> | <value> | <value>       | <value>           | <value>           | <value>           | <value>       | <value>          | <value>        | <value>           |
    And Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator closes the modal for unsuccessful update
    Examples:
      | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | [sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample] |
