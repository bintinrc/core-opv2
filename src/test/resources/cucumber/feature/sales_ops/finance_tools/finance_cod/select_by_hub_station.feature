@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @FinanceCod

Feature: Generate COD Report - Select by Hub/Station

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read


  @DeleteOrArchiveRoute
  Scenario: Generate COD Report - Filter By Order Completed Date - Select Multiple Hub/Station
         #Test Data - Normal Order- Hub 1
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
        #Test Data - Normal Order-Hub 2
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-rts-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-sop-normal-rts-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-COD-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-COD-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35.5,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
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
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}","email_addresses": ["{order-billing-email}"],"date_type": "ORDER_COMPLETED", "report_type" : "COD", "hub_ids": [ {hub-id},{hub-id-2} ], "template_id": {finance-cod-template-id}} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received finance cod email
    And Operator gets the finance cod report entries
    Then DB Operator verifies the count of entries for data below
      | startDate    | {gradle-current-date-yyyyMMdd} |
      | endDate      | {gradle-current-date-yyyyMMdd} |
      | basedOn      | Order Completed Date           |
      | generateFile | Select By Hub/Station          |
      | hubId        | {hub-id},{hub-id-2}            |
    Then Operator verifies the finance cod report header using data {default-finance-cod-headers}
    Then Operator verifies the cod entry details in the body

  @DeleteOrArchiveRoute
  Scenario: Generate COD Report - Filter By Route Date - Select One Hub/Station
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
    Then Operator gets price order details from the billing_qa_gl.priced_orders table
    Then Operator gets order details from the billing_qa_gl.cod_orders table
    # Finance COD Report
    And API Operator generates finance cod report using data below
      | {"start_date": "{gradle-current-date-yyyy-MM-dd}","end_date": "{gradle-current-date-yyyy-MM-dd}","email_addresses": ["{order-billing-email}"],"date_type": "ROUTE", "report_type" : "COD", "hub_ids": [ {hub-id} ], "template_id": {finance-cod-template-id}} |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received finance cod email
    And Operator gets the finance cod report entries
    Then DB Operator verifies the count of entries for data below
      | startDate    | {gradle-current-date-yyyyMMdd} |
      | endDate      | {gradle-current-date-yyyyMMdd} |
      | basedOn      | Route Date                     |
      | generateFile | Select By Hub/Station          |
      | hubId        | {hub-id}                       |
    Then Operator verifies the finance cod report header using data {default-finance-cod-headers}
    Then Operator verifies the cod entry details in the body

  Scenario: Generate COD Report - Not Select Any Hub/Station
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Finance Tools -> Finance COD
    When Operator selects Finance COD Report data as below
      | generateFile | Select By Hub/Station |
      | emailAddress | {order-billing-email} |
    Then Operator verifies error message "Please select at least one hub."