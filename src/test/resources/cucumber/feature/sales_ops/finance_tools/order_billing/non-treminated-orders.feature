@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling @NonTerminatedOrders
Feature: Order Billing - Non Terminated Orders
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)
  "ALL": All orders (1 very big file, takes long time to generate)
  "SCRIPT": Orders consolidated by script (1 file per script), grouped by shipper within the file
  "AGGREGATED": All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Gmail - Connect to "{order-billing-email}" inbox using password "{order-billing-email-password}"
    And API Operator whitelist email "{order-billing-email}"
    And API Gmail - Operator marks all gmail messages as read

  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `Arrived at Distribution Point` Order Exists (uid:e7eee954-af8d-471c-8c60-42df489fe56a)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Billing - Operator updates the granular status of the priced order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" to "Arrived at Distribution Point" in billing_qa_gl.priced_orders table
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-v4-legacy-id}                              |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `Arrived at Distribution Point` Order Exists (uid:81a5fe1a-caaa-4c35-a42c-302b0f8c8209)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "Arrived at Distribution Point" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-v4-legacy-id}                                    |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `Arrived at Distribution Point` Order Exists (uid:2252083c-7576-457b-af7b-3e101b3feb0d)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "Arrived at Distribution Point" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-v4-legacy-id}                                                                |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on SSB report


  #@nad
  @ArchiveRouteCommonV2 @e2e
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `Arrived at Distribution Point` to `Completed` Order (uid:79e44d8c-6b4a-4ce7-86d4-b5a1525c36fb)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{opv2-dp-dpms-id},"drop_off_date":"{date:0 days next, yyyy-MM-dd}"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                     |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DD"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then DB DP - get DP job order with order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" and status "PENDING"
    When API DP - DP user authenticate with username "{dp-user-username}" password "{dp-user-password}" and dp id "{opv2-dp-dp-id}"
    And API DP - DP success parcel:
      | request | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "job_id": {KEY_DP_LIST_OF_DP_JOB_ORDERS[1].dpJobId}, "received_from": "DRIVER" }] |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ON_VEHICLE_FOR_DELIVERY"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And DB Operator gets Customer Unlock Code Based on Tracking ID
    And API DP do the Customer Collection from dp with ID = "{opv2-dp-dp-id}"
    And API Operator runs the RecalculatePricedOrders endpoint
    And DB Pricing - Operator verifies there is an entry in the pricing_qa_gl.pricing_orders_history table for tracking id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "Completed"
    And DB Billing - Operator gets price order details from the billing_qa_gl.priced_orders table for order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with status "Completed"
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-v4-legacy-id}                              |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on SSB report
    Then Operator verifies the order with status 'Completed' is displayed on billing report
    Then Operator verifies the SSB header using data {shipper-ssb-headers}
    Then Operator verifies the priced order details in the SSB CSV body for tracking Id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then DB Operator verifies completed date of the priced order is the same as core.transactions.service_end_time


  @ArchiveRouteCommonV2 @e2e
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `Arrived at Distribution Point` to `Completed` Order (uid:4f65e234-4a9f-4f5a-9949-71350459be2b)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{opv2-dp-dpms-id},"drop_off_date":"{date:0 days next, yyyy-MM-dd}"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                     |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DD"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then DB DP - get DP job order with order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" and status "PENDING"
    When API DP - DP user authenticate with username "{dp-user-username}" password "{dp-user-password}" and dp id "{opv2-dp-dp-id}"
    And API DP - DP success parcel:
      | request | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "job_id": {KEY_DP_LIST_OF_DP_JOB_ORDERS[1].dpJobId}, "received_from": "DRIVER" }] |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ON_VEHICLE_FOR_DELIVERY"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And DB Operator gets Customer Unlock Code Based on Tracking ID
    And API DP do the Customer Collection from dp with ID = "{opv2-dp-dp-id}"
    And API Operator runs the RecalculatePricedOrders endpoint
    And DB Pricing - Operator verifies there is an entry in the pricing_qa_gl.pricing_orders_history table for tracking id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "Completed"
    And DB Billing - Operator gets price order details from the billing_qa_gl.priced_orders table for order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with status "Completed"
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-v4-legacy-id}                                    |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on SSB report
    Then Operator verifies the order with status 'Completed' is displayed on billing report
    Then Operator verifies the SSB header using data {default-ssb-headers}
    Then Operator verifies the priced order details in the SSB CSV body for tracking Id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"

  @ArchiveRouteCommonV2 @e2e
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `Arrived at Distribution Point` to `Completed` Order (uid:6abadb91-53e6-4f39-b7c3-52859d0061c7)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{opv2-dp-dpms-id},"drop_off_date":"{date:0 days next, yyyy-MM-dd}"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                     |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DD"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then DB DP - get DP job order with order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" and status "PENDING"
    When API DP - DP user authenticate with username "{dp-user-username}" password "{dp-user-password}" and dp id "{opv2-dp-dp-id}"
    And API DP - DP success parcel:
      | request | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "job_id": {KEY_DP_LIST_OF_DP_JOB_ORDERS[1].dpJobId}, "received_from": "DRIVER" }] |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ON_VEHICLE_FOR_DELIVERY"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And DB Operator gets Customer Unlock Code Based on Tracking ID
    And API DP do the Customer Collection from dp with ID = "{opv2-dp-dp-id}"
    And API Operator runs the RecalculatePricedOrders endpoint
    And DB Pricing - Operator verifies there is an entry in the pricing_qa_gl.pricing_orders_history table for tracking id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "Completed"
    And DB Billing - Operator gets price order details from the billing_qa_gl.priced_orders table for order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with status "Completed"
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-v4-legacy-id}                                                                |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on SSB report
    Then Operator verifies the order with status 'Completed' is displayed on billing report
    Then Operator verifies the SSB header using data {default-ssb-headers}
    Then Operator verifies the priced order details in the SSB CSV body for tracking Id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"


  @ArchiveRouteCommonV2 @e2e
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `Arrived at Distribution Point` to `Returned to Sender` Order (uid:2700aa48-d75b-49da-8493-6b8f6ea4dd77)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{opv2-dp-dpms-id},"drop_off_date":"{date:0 days next, yyyy-MM-dd}"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                     |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DD"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then DB DP - get DP job order with order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" and status "PENDING"
    When API DP - DP user authenticate with username "{dp-user-username}" password "{dp-user-password}" and dp id "{opv2-dp-dp-id}"
    And API DP - DP success parcel:
      | request | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "job_id": {KEY_DP_LIST_OF_DP_JOB_ORDERS[1].dpJobId}, "received_from": "DRIVER" }] |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ON_VEHICLE_FOR_DELIVERY"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And DB Operator set pickup date of DP reservation to current date
    And API Operator trigger Add Overstayed Orders
    And DB Operator set collect until date of DP reservation to yesterday's date
    And API Operator trigger overstay to create new reservation
    And API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                     |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id},"type":"DD"} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ON_VEHICLE_FOR_DELIVERY"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[4].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[4].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "RETURNED_TO_SENDER"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And DB Billing - Operator gets price order details from the billing_qa_gl.priced_orders table for order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with status "Returned to Sender"
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-v4-legacy-id}                              |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on SSB report
    Then Operator verifies the order with status 'Returned To Sender' is displayed on billing report
    Then Operator verifies the SSB header using data {shipper-ssb-headers}
    Then Operator verifies the priced order details in the SSB CSV body for tracking Id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then DB Operator verifies completed date of the priced order is the same as core.transactions.service_end_time

  @ArchiveRouteCommonV2 @e2e
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `Arrived at Distribution Point` to `Returned to Sender` Order (uid:ddcd007e-92f6-4ab9-acdf-09e970a0cd83)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{opv2-dp-dpms-id},"drop_off_date":"{date:0 days next, yyyy-MM-dd}"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                     |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DD"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then DB DP - get DP job order with order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" and status "PENDING"
    When API DP - DP user authenticate with username "{dp-user-username}" password "{dp-user-password}" and dp id "{opv2-dp-dp-id}"
    And API DP - DP success parcel:
      | request | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "job_id": {KEY_DP_LIST_OF_DP_JOB_ORDERS[1].dpJobId}, "received_from": "DRIVER" }] |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ON_VEHICLE_FOR_DELIVERY"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And DB Operator set pickup date of DP reservation to current date
    And API Operator trigger Add Overstayed Orders
    And DB Operator set collect until date of DP reservation to yesterday's date
    And API Operator trigger overstay to create new reservation
    And API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                     |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id},"type":"DD"} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ON_VEHICLE_FOR_DELIVERY"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[4].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[4].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "RETURNED_TO_SENDER"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-v4-legacy-id}                                    |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on SSB report
    Then Operator verifies the order with status 'Returned To Sender' is displayed on billing report

  @ArchiveRouteCommonV2 @e2e
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `Arrived at Distribution Point` to `Returned to Sender` Order (uid:a7e7cbbd-9291-4737-95ca-8166df5d7a04)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{opv2-dp-dpms-id},"drop_off_date":"{date:0 days next, yyyy-MM-dd}"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                     |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DD"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then DB DP - get DP job order with order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" and status "PENDING"
    When API DP - DP user authenticate with username "{dp-user-username}" password "{dp-user-password}" and dp id "{opv2-dp-dp-id}"
    And API DP - DP success parcel:
      | request | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "job_id": {KEY_DP_LIST_OF_DP_JOB_ORDERS[1].dpJobId}, "received_from": "DRIVER" }] |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ON_VEHICLE_FOR_DELIVERY"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And DB Operator set pickup date of DP reservation to current date
    And API Operator trigger Add Overstayed Orders
    And DB Operator set collect until date of DP reservation to yesterday's date
    And API Operator trigger overstay to create new reservation
    And API Core - Operator archives routes below:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id}                                                                                                                                                                                                                                           |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                     |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id},"type":"DD"} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "ON_VEHICLE_FOR_DELIVERY"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[4].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[4].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "RETURNED_TO_SENDER"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-v4-legacy-id}                                                                |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on SSB report
    Then Operator verifies the order with status 'Returned To Sender' is displayed on billing report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `On Vehicle for Delivery` Order Exists (uid:8a72ea83-d7e9-4044-9dd7-fd8bb396e1ec)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "On Vehicle for Delivery" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-v4-legacy-id}                              |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'On Vehicle for Delivery' is not displayed on SSB report


  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `On Vehicle for Delivery` Order Exists (uid:a6142b06-fa81-45cf-b206-c73e43c58915)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "On Vehicle for Delivery" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-v4-legacy-id}                                    |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'On Vehicle for Delivery' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `On Vehicle for Delivery` Order Exists (uid:03e4f822-afba-405e-8a3c-64002f8e75c6)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "On Vehicle for Delivery" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-v4-legacy-id}                                                                |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'On Vehicle for Delivery' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `Cancelled ` Order Exists (uid:2b4a671e-f7e7-40a3-86ce-c7e9d74a6e3e)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "Cancelled" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-v4-legacy-id}                              |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Cancelled' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `Cancelled` Order Exists (uid:24d5fd4a-0a7a-465e-9651-4f15849b6643)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "Cancelled" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-v4-legacy-id}                                    |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Cancelled' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `Cancelled` Order Exists (uid:fe78275d-b4b9-4bd3-881e-6d6dd5f8d6dc)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "Cancelled" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-v4-legacy-id}                                                                |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Cancelled' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `On Hold` Order Exists (uid:40a0c5f0-7177-4637-8415-9f1a7a901bb3)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "On Hold" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-v4-legacy-id}                              |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'On Hold' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `On Hold` Order Exists (uid:4541831c-72dc-4c82-8fb1-1ed824ada455)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "On Hold" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-v4-legacy-id}                                    |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'On Hold' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `On Hold` Order Exists (uid:c38a672b-6ff1-4fdd-add2-b2fcd443eb3d)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "On Hold" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-v4-legacy-id}                                                                |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'On Hold' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - NULL Status Order Exists (uid:6bc3350d-f2a3-462c-82a2-6ebc295ac597)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "NULL" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-v4-legacy-id}                              |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'NULL' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - NULL Status Order Exists (uid:97578e96-9d0b-4616-9874-3e4c23cdfdfe)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "NULL" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper         | {shipper-v4-legacy-id}                                    |
      | generateFile    | All orders (1 very big file, takes long time to generate) |
      | emailAddress    | {order-billing-email}                                     |
      | csvFileTemplate | {csv-template}                                            |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'NULL' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - NULL Status Order Exists (uid:ff35ea8d-c629-44d5-8d4d-696ddd440ba8)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "NULL" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-v4-legacy-id}                                                                |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'NULL' is not displayed on SSB report

  @DeleteOrArchiveRoute
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `Pending Reschedule` Order Exists (uid:534bc797-010e-408a-86d7-1db75441a0b2)
    Given API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator updates the granular status of the priced order to "Pending Reschedule" in Billing DB
    And Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-v4-legacy-id}                              |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    And Operator gets the success billing report entries from the zip file
    Then Operator verifies the order with status 'Pending Reschedule' is not displayed on SSB report

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op