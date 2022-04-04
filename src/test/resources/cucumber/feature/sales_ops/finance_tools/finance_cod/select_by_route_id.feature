@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @FinanceCod

Feature: Generate COD Report - Select by Parent Shipper

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read

  Scenario: Generate COD Report - Select One Route ID
       #Test Data - Normal Order
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-rts-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-sop-normal-rts-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-COD-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-COD-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35.5,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    # Finance COD Report
    And API Operator generates finance cod report using data below
      | {"timezone": "Asia/Singapore","email_addresses": ["{order-billing-email}"], "report_type" : "COD", "route_ids": [ {KEY_CREATED_ROUTE_ID} ], "template_id": {finance-cod-template-id}} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received finance cod email
    And Operator gets the finance cod report entries
    Then DB Operator verifies the count of entries for data below
      | generateFile | Select By Route        |
      | routeId      | {KEY_CREATED_ROUTE_ID} |
    Then Operator verifies the finance cod report header using data {default-finance-cod-headers}
    Then Operator gets order details from the billing_qa_gl.cod_orders table
    Then Operator gets price order details from the billing_qa_gl.priced_orders table
    Then Operator verifies the cod entry details in the body