@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling @CustomTemplate
Feature: Order Billing - Custom Template

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read

  @DeleteOrArchiveRoute @HappyPath
  Scenario: Generate "ALL" Success Billing Report - All Shippers - Use Custom Template
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Driver deliver the created parcel successfully
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                          |
      | generateFile    | All orders (1 very big file, takes long time to generate) |
      | emailAddress    | {order-billing-email}                                     |
      | csvFileTemplate | {custom-csv-template}                                     |
    Then Operator gets 'Completed' price order details from the billing_qa_gl.priced_orders table
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received email
    Then Operator gets the success billing report entries
    Then Operator verifies the header using data {custom-ssb-headers}
    Then Operator verifies the priced order details in the body