@OperatorV2 @Core @EditOrder @EditOrderDetails @AirwayBill
Feature: Edit Order Details - Airway bill service

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Print order airway bill - single awb - shipper details shown
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {fully-shipper-subscription-1-client-id}                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {fully-shipper-subscription-1-client-secret}                                                                                                                                                                                                                                                                                    |
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator waits for 5 seconds
    And Operator press load selection button
    And Operator fill the tracking id filter with "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator print Waybill for order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on All Orders page
    Then Operator verifies Airway bill infor:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  Scenario: Print order airway bill - single awb - shipper details hidden
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator waits for 5 seconds
    And Operator press load selection button
    And Operator fill the tracking id filter with "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator print Waybill for order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on All Orders page
    Then Operator verifies Airway bill infor:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  Scenario: Print order airway bill - single awb - non-latin font and symbol
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_instruction":"Im waiting. مرسل người 发件人 ပေးပို့သူ ผู้ส่ง +65 ၁၂၃ ١٢٣ ๑๐ 三四 !@#$%^&*() á, é, í, ó, ú, ý, Á, É, Í, Ó, Ú, Ý <br>"}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Order -> All Orders
    And Operator waits for 5 seconds
    And Operator press load selection button
    And Operator fill the tracking id filter with "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator print Waybill for order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}" on All Orders page
    Then Operator verifies Airway bill infor:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
