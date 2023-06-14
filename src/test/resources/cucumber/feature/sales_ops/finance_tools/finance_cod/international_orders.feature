@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @FinanceCod

Feature: Generate COD Report - International Order(s)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given API Gmail - Operator connect to "{cod-reconciliation-report-email}" inbox using password "{cod-reconciliation-report-email-password}"
    Given API Operator whitelist email "{cod-reconciliation-report-email}"
    Given operator marks gmail messages as read

  @DeleteOrArchiveRoute
  Scenario: Generate COD Report - Filter By Order Completed Date - International Orders
    #Test Data - International Order
    Given API Shipper create an order using below json as request body
      | shipperClientId     | {shipper-sop-normal-rts-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-sop-normal-rts-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"International", "service_level":"Standard", "international": {"portation": "Import"}, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "11/1 Soi Samsen 3 Samsen Road, Wat Samphraya, Phranakhon","address2": "","country": "VN","postcode": "10200"}},"parcel_job":{"cash_on_delivery": 35.55, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00","timezone": "Asia/Singapore"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00","timezone": "Asia/Ho_Chi_Minh"}}} |
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
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}","email_addresses": ["{cod-reconciliation-report-email}"],"date_type": "ORDER_COMPLETED", "report_type" : "COD", "service_types" : ["International","Marketplace International"], "template_id": {finance-cod-template-id}} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received finance cod email
    And Operator gets the finance cod report entries
    Then DB Operator verifies the count of entries for data below
      | startDate    | {gradle-current-date-yyyyMMdd} |
      | endDate      | {gradle-current-date-yyyyMMdd} |
      | basedOn      | Order Completed Date           |
      | generateFile | International                  |
    Then Operator verifies the finance cod report header using data {default-finance-cod-headers}
    Then Operator verifies the cod entry details in the body

  @DeleteOrArchiveRoute
  Scenario: Generate COD Report - Filter By Route Date - International Orders
    #Test Data - International Order
    Given API Shipper create an order using below json as request body
      | shipperClientId     | {shipper-sop-normal-rts-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-sop-normal-rts-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"International", "service_level":"Standard", "international": {"portation": "Import"}, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "11/1 Soi Samsen 3 Samsen Road, Wat Samphraya, Phranakhon","address2": "","country": "VN","postcode": "10200"}},"parcel_job":{"cash_on_delivery": 35.55, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00","timezone": "Asia/Singapore"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00","timezone": "Asia/Ho_Chi_Minh"}}} |
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
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}","email_addresses": ["{cod-reconciliation-report-email}"],"date_type": "ROUTE", "report_type" : "COD", "service_types" : ["International","Marketplace International"], "template_id": {finance-cod-template-id}} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received finance cod email
    And Operator gets the finance cod report entries
    Then DB Operator verifies the count of entries for data below
      | startDate    | {gradle-current-date-yyyyMMdd} |
      | endDate      | {gradle-current-date-yyyyMMdd} |
      | basedOn      | Route Date                     |
      | generateFile | International                  |
    Then Operator verifies the finance cod report header using data {default-finance-cod-headers}
    Then Operator verifies the cod entry details in the body

  Scenario: Generate COD Report - Filter By Order Completed Date - International Orders - Orders Not Exist On The Selected Date
    And API Operator generates finance cod report using data below
      | {"start_date": "{gradle-next-1-day-yyyy-MM-dd}","end_date": "{gradle-next-1-day-yyyy-MM-dd}","email_addresses": ["{cod-reconciliation-report-email}"],"date_type": "ROUTE", "report_type" : "COD", "service_types" : ["International","Marketplace International"], "template_id": {finance-cod-template-id}} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and verifies the finance cod email body contains message "Error: No orders found."

  @DeleteOrArchiveRoute
  Scenario: Generate COD Report - Filter By Order Completed Date - International Orders - Service Type = Non-International - Delivery Type = International
   #Test Data - International Order
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-rts-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-sop-normal-rts-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-COD-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-COD-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35.5,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator update order delivery Type to 6
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
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}","email_addresses": ["{cod-reconciliation-report-email}"],"date_type": "ORDER_COMPLETED", "report_type" : "COD", "service_types" : ["International","Marketplace International"], "template_id": {finance-cod-template-id}} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received finance cod email
    And Operator gets the finance cod report entries
    Then DB Operator verifies the count of entries for data below
      | startDate    | {gradle-current-date-yyyyMMdd} |
      | endDate      | {gradle-current-date-yyyyMMdd} |
      | basedOn      | Order Completed Date           |
      | generateFile | International                  |
    Then Operator verifies the finance cod report header using data {default-finance-cod-headers}
    Then Operator verifies the cod entry details in the body

  @DeleteOrArchiveRoute
  Scenario: Generate COD Report - Filter By Order Completed Date - International Orders - Service Type = Non-International - Delivery Type = International
   #Test Data - International Order
    Given API Shipper create an order using below json as request body
      | shipperClientId     | {shipper-sop-normal-rts-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-sop-normal-rts-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"International", "service_level":"Standard", "international": {"portation": "Import"}, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "From Address1","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "11/1 Soi Samsen 3 Samsen Road, Wat Samphraya, Phranakhon","address2": "","country": "VN","postcode": "10200"}},"parcel_job":{"cash_on_delivery": 35.55, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00","timezone": "Asia/Singapore"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00","timezone": "Asia/Ho_Chi_Minh"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator update order delivery Type to 2
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
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}","email_addresses": ["{cod-reconciliation-report-email}"],"date_type": "ORDER_COMPLETED", "report_type" : "COD", "service_types" : ["International","Marketplace International"], "template_id": {finance-cod-template-id}} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received finance cod email
    And Operator gets the finance cod report entries
    Then DB Operator verifies the count of entries for data below
      | startDate    | {gradle-current-date-yyyyMMdd} |
      | endDate      | {gradle-current-date-yyyyMMdd} |
      | basedOn      | Order Completed Date           |
      | generateFile | International                  |
    Then Operator verifies the finance cod report header using data {default-finance-cod-headers}
    Then Operator verifies the cod entry details in the body