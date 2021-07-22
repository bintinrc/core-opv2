@OperatorV2 @Core @NewFeatures @UpdateDeliveryAddressWithCSV @current
Feature: Update Delivery Address with CSV

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk Update Order Delivery Address with CSV - Valid Order Status (uid:f8c8e933-017b-44c4-b47d-aa607f97afa7)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery address of created orders on Update Delivery Address with CSV page
    Then Operator verify updated addresses on Update Delivery Address with CSV page
    When Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator verify addresses were updated successfully on Update Delivery Address with CSV page
    And API Operator get order details
    And Operator verify created orders info after address update
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE CONTACT INFORMATION |

  Scenario: Bulk Update Order Delivery Address with CSV - Empty File (uid:612068d5-7668-4c0c-a86d-9914477885a1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery address of created orders on Update Delivery Address with CSV page
    Then Toast "No valid orders found, please check your file" is displayed

  Scenario: Bulk Update Order Delivery Address with CSV - Invalid Order/Format (uid:41d98368-903b-4e17-b366-e1bf64c3b04e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses of given orders on Update Delivery Address with CSV page:
      | SOMEINVALIDTRACKINGID |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId            | status              |
      | SOMEINVALIDTRACKINGID | Invalid tracking Id |

  Scenario: Bulk Update Order Delivery Address with CSV - Partial (uid:502ecf18-eb43-44f7-9ff5-31c32a59834b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses of given orders on Update Delivery Address with CSV page:
      | {KEY_CREATED_ORDER_TRACKING_ID} |
      | SOMEINVALIDTRACKINGID           |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                      | status              |
      | {KEY_CREATED_ORDER_TRACKING_ID} | Pass                |
      | SOMEINVALIDTRACKINGID           | Invalid tracking Id |

  Scenario: Bulk Update Order Delivery Address with CSV - Empty Compulsory Fields (uid:4037aece-2a03-4fc2-a6dc-aaec873e2852)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                      | toName | toEmail | toPhoneNumber | toAddressAddress1 | toAddressAddress2 | toAddressPostcode | toAddressCity | toAddressCountry | toAddressState | toAddressDistrict |
      | {KEY_CREATED_ORDER_TRACKING_ID} | empty  | empty   | empty         | empty             | empty             | empty             | empty         | empty            | empty          | empty             |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                      | status                                                                                                                                                                                           |
      | {KEY_CREATED_ORDER_TRACKING_ID} | Require to fill in to.name, to.email, to.phone_number, to.address.address1, to.address.address2, to.address.postcode, to.address.city, to.address.country, to.address.state, to.address.district |

  Scenario Outline: Bulk Update Order Delivery Address with CSV - With Technical Issues (uid:37c5b5a7-d8ff-4401-a596-746daed36f23)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                      | toName  | toEmail | toPhoneNumber | toAddressAddress1 | toAddressAddress2 | toAddressPostcode | toAddressCity | toAddressCountry | toAddressState | toAddressDistrict |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <value> | <value> | <value>       | <value>           | <value>           | <value>           | <value>       | <value>          | <value>        | <value>           |
    And Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator closes the modal for unsuccessful update
    Examples:
      | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | [sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample] |

  Scenario Outline: Bulk Update Order Delivery Address with CSV - With Technical Issues and Valid Orders (uid:f10d6916-15d9-4543-837b-49c6a7ba4618)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                                 | toName  | toEmail | toPhoneNumber | toAddressAddress1 | toAddressAddress2 | toAddressPostcode | toAddressCity | toAddressCountry | toAddressState | toAddressDistrict |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | <value> | <value> | <value>       | <value>           | <value>           | <value>           | <value>       | <value>          | <value>        | <value>           |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         |         |               |                   |                   |                   |               |                  |                |                   |
    And Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator closes the modal for unsuccessful update
    And API Operator get order details
    And Operator verify orders info after address update:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Examples:
      | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | [sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample][sample] name [sample] |

  Scenario: Bulk Update Order Delivery Address with CSV - Invalid Lat Long Format & Empty Compulsory Fields (uid:f80c8457-eefe-4505-b319-708cdad7d9ef)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                      | toAddressLatitude | toAddressLongitude | toPhoneNumber | toAddressAddress2 |
      | {KEY_CREATED_ORDER_TRACKING_ID} | empty             | 1.2860-17          | empty         | empty             |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                      | status                                                                                                                                                |
      | {KEY_CREATED_ORDER_TRACKING_ID} | Require to fill in to.phone_number, to.address.address2, Invalid entry '1.2860-17' for to.address.longitude, Invalid entry '' for to.address.latitude |

  Scenario Outline: Bulk Update Order Delivery Address with CSV - Fail to Update Lat Long - <note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                      | toAddressLatitude | toAddressLongitude |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <lat>             | <long>             |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                      | status   |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <status> |
    Examples:
      | note                | lat          | long          | status                                                                                                       | hiptest-uid                              |
      | Lat Long Has String | 1.317219a344 | 103.925993?32 | Invalid entry '103.925993?32' for to.address.longitude, Invalid entry '1.317219a344' for to.address.latitude | uid:ca983071-6b37-4cae-92ba-4949bafd7bee |
      | Lat Long Has Dash   | -            | -             | Invalid entry '-' for to.address.longitude, Invalid entry '-' for to.address.latitude                        | uid:fa23656c-a43e-4630-be61-f6c436695687 |
      | Lat Is Empty        | empty        | 103.886438    | Invalid entry '' for to.address.latitude                                                                     | uid:6e986036-aeb6-4b42-823e-6b6fa5289404 |
      | Long Is Empty       | 1.369953     | empty         | Invalid entry '' for to.address.longitude                                                                    | uid:4a2f13c5-5211-4a2f-a007-38515781e406 |

  Scenario: Bulk Update Order Delivery Address with CSV - Lat Long is Empty (uid:6fe802a1-4ada-4680-a9c3-db606e83278f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    And Operator update delivery addresses on Update Delivery Address with CSV page:
      | trackingId                      | toAddressLatitude | toAddressLongitude |
      | {KEY_CREATED_ORDER_TRACKING_ID} | empty             | empty              |
    Then Operator verify updated addresses on Update Delivery Address with CSV page
    When Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator verify addresses were updated successfully on Update Delivery Address with CSV page
    And API Operator get order details
    And Operator verify created orders info after address update

#  @DeleteOrArchiveRoute 
  @routing-refactor @wip
  Scenario: Bulk Update Order Delivery Address with CSV - Routed Delivery (uid:c6c4b64a-2171-4c36-bb19-b119ab6a2dce)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery address of created orders on Update Delivery Address with CSV page
    Then Operator verify updated addresses on Update Delivery Address with CSV page
    When Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator verify addresses were updated successfully on Update Delivery Address with CSV page
    And API Operator get order details
    And Operator verify created orders info after address update
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE CONTACT INFORMATION |
    When API Operator get order details
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | Routed |
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies first & last waypoints.seq_no are dummy waypoints

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op