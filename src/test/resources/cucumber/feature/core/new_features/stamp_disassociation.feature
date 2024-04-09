@OperatorV2 @Core @NewFeatures @StampDisassociation @current
Feature: Stamp Disassociation

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Operator Should not be Able to Disassociate Order that Has no Stamp ID
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" value into 'Scan Stamp ID' field on Stamp Disassociation page
    Then Operator verify the label says "stamp id not available" on Stamp Disassociation page
    Then Operator verify order details on Stamp Disassociation page:
      | orderId         | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                               |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                       |
      | deliveryAddress | 998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss} home {gradle-current-date-yyyyMMddHHmmsss},, SG 159363 |

  @MediumPriority
  Scenario: Stamp Disassociation of Order by Stamp Id - Invalid Stamp Id
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enters "INVALID_STAMP_ID" value into 'Scan Stamp ID' field on Stamp Disassociation page
    Then Operator will get the "Not Found" alert on Stamp Disassociation page

  @HighPriority @wip
  Scenario: Stamp Disassociation of Order by Stamp Id - Valid Stamp Id
    Given New Stamp ID was generated
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | {"internal_ref":{"stamp_id":"{KEY_CORE_STAMP_ID}"},"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enters "{KEY_CORE_STAMP_ID}" value into 'Scan Stamp ID' field on Stamp Disassociation page
    Then Operator verify order details on Stamp Disassociation page:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When Operator click on the Disassociate Stamp button
#    disable it first due https://jira.ninjavan.co/browse/COREV2-1963
#    And Operator go to menu Order -> All Orders
#    Then Operator can't find order on All Orders page using this criteria below:
#      | category    | Tracking / Stamp ID |
#      | searchLogic | contains            |
#      | searchTerm  | KEY_CORE_STAMP_ID   |

  @MediumPriority
  Scenario: Stamp Disassociation of Order by Stamp Id - Invalid Tracking Id
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enters "INVALID_TRACKING_ID" value into 'Scan Stamp ID' field on Stamp Disassociation page
    Then Operator will get the "Not Found" alert on Stamp Disassociation page

  @HighPriority
  Scenario: Stamp Disassociation of Order by Stamp Id - Valid Tracking Id
    Given New Stamp ID was generated
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | {"internal_ref":{"stamp_id":"{KEY_CORE_STAMP_ID}"},"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enters "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" value into 'Scan Stamp ID' field on Stamp Disassociation page
    Then Operator verify order details on Stamp Disassociation page:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When Operator click on the Disassociate Stamp button
    Then Operator verify the label says "stamp id not available" on Stamp Disassociation page
    And Disassociate Stamp button is disabled