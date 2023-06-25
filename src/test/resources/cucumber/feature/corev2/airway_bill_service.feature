@OperatorV2 @AirwayBill
Feature: Edit Order Details - Airway bill service

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Print order airway bill
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click View/Print -> Print Airway Bill on Edit Order page
    Then Operator verifies Airway bill infor:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | ToName     | binti v4.1                      |
      | ToAddress  | Orchard Road central            |


  Scenario: Print order airway bill - non-latin font and symbol
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest | { "service_type":"Parcel","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click View/Print -> Print Airway Bill on Edit Order page
    Then Operator verifies Airway bill infor:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | ToName     | binti v4.1                      |
      | ToAddress  | Orchard Road central            |

  Scenario: Print order airway bill - show_shipper_details true
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {custom-webhook-lazada-shipper-v41-2.0-1-client-id}                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {custom-webhook-lazada-shipper-v41-2.0-1-client-secret}                                                                                                                                                                                                                                                                         |
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click View/Print -> Print Airway Bill on Edit Order page
    Then Operator verifies Airway bill infor:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  Scenario: Print order airway bill - show_shipper_details false
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click View/Print -> Print Airway Bill on Edit Order page
    Then Operator verifies Airway bill infor:
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | ToName     | binti v4.1                      |
      | ToAddress  | Orchard Road central            |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
