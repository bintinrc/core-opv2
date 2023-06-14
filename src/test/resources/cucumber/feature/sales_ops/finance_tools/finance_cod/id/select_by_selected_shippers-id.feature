@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsID @FinanceCodID

Feature: Generate COD Report - Selected Shipper(s)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given API Gmail - Operator connect to "{cod-reconciliation-report-email}" inbox using password "{cod-reconciliation-report-email-password}"
    Given API Operator whitelist email "{cod-reconciliation-report-email}"
    Given operator marks gmail messages as read

  @DeleteOrArchiveRoute
  Scenario: Generate COD Report - Filter By Order Completed Date - Select One Shipper - ID
      #Test Data - Normal Order
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD","from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": 500.11,"insured_value": 85000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully with cod
    Then Operator gets price order details from the billing_qa_gl.priced_orders table
    Then Operator gets order details from the billing_qa_gl.cod_orders table
    # Finance COD Report
    And API Operator generates finance cod report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}","email_addresses": ["{cod-reconciliation-report-email}"],"date_type": "ORDER_COMPLETED", "report_type" : "COD", "global_shipper_ids": [ {shipper-v4-global-id} ], "template_id": {finance-cod-template-id}} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received finance cod email
    And Operator gets the finance cod report entries
    Then DB Operator verifies the count of entries for data below
      | startDate    | {gradle-current-date-yyyyMMdd} |
      | endDate      | {gradle-current-date-yyyyMMdd} |
      | basedOn      | Order Completed Date           |
      | generateFile | Selected Shippers              |
      | shipperId    | {shipper-v4-global-id}         |
    Then Operator verifies the finance cod report header using data {default-finance-cod-headers}
    Then Operator verifies the cod entry details in the body