@OperatorV2 @LaunchBrowser @SalesOps @AllOrdersFeesID
Feature: All Orders - ID

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Indonesia"


  Scenario: Operator Check All Pricing Details Edit Order Page - Order Pricing is not calculated - ID
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-invalid-script-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-sop-normal-invalid-script-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","from": {"name": "QA-SO-Test-From","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-SO-Test-To","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address":{"address1": "Jalan jalan, , Sukun , P","country": "ID","province": "p","kecamatan": "P","postcode": "12345","latitude": 1.290270,"longitude": 103.851959}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator waits for 1 seconds
    And API Operator force succeed created order
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verifies pricing information on Edit Order page:
      | total         | -            |
      | deliveryFee   | -            |
      | codFee        | -            |
      | insuranceFee  | -            |
      | handlingFee   | -            |
      | rtsFee        | -            |
      | gst           | -            |
      | insuredValue  | -            |
      | billingWeight | notAvailable |
      | billingSize   | notAvailable |
      | source        | notAvailable |
