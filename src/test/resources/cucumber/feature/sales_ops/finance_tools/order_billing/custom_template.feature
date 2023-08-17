@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling @CustomTemplate
Feature: Order Billing - Custom Template

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Gmail - Connect to "{order-billing-email}" inbox using password "{order-billing-email-password}"
    Given API Operator whitelist email "{order-billing-email}"
    Given API Gmail - Operator marks all gmail messages as read

    #@nad
  @ArchiveRouteCommonV2  @HappyPath
  Scenario: Generate "ALL" Success Billing Report - All Shippers - Use Custom Template
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                     |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                             |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS", "cod":100000.00}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                      |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                          |
      | generateFile    | All orders (1 very big file, takes long time to generate) |
      | emailAddress    | {order-billing-email}                                     |
      | csvFileTemplate | {custom-csv-template}                                     |
    Then DB Billing - Operator gets price order details from the billing_qa_gl.priced_orders table for order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with status "Completed"
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies the SSB header using data {custom-ssb-headers}
    Then Operator verifies the priced order details in the SSB CSV body for tracking Id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"