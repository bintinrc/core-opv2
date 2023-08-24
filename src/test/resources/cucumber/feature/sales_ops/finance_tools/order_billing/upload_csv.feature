@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling @UploadCsv
Feature: Order Billing - Upload CSV
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)
  "ALL": All orders (1 very big file, takes long time to generate)
  "SCRIPT": Orders consolidated by script (1 file per script), grouped by shipper within the file
  "AGGREGATED": All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Finance Tools -> Order Billing
    Given API Operator whitelist email "{order-billing-email}"
    Given API Gmail - Connect to "{order-billing-email}" inbox using password "{order-billing-email-password}"
    Given API Gmail - Operator marks all gmail messages as read
@test
@HappyPath
  Scenario: Search Shipper by Upload CSV -  Valid Shipper ID - Generate "SHIPPER" Report (uid:4176de9f-42ef-498b-911a-42379b1866b6)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
  And DB Billing - Operator gets price order details from the billing_qa_gl.priced_orders table for order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with status "Completed"
  When Operator generates success billings using data below:
    | startDate       | {gradle-current-date-yyyy-MM-dd}                    |
    | endDate         | {gradle-next-1-day-yyyy-MM-dd}                      |
    | uploadCsv       | {shipper-sop-v4-legacy-id}                          |
    | generateFile    | Orders consolidated by shipper (1 file per shipper) |
    | emailAddress    | {order-billing-email}                               |
    | csvFileTemplate | {csv-template}                                      |
  And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies the SSB header using data {shipper-ssb-headers}
    Then Operator verifies the priced order details in the SSB CSV body for tracking Id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verifies the SSB report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |


  Scenario: Search Shipper by Upload CSV - Invalid Shipper ID - Generate "SHIPPER" Report (uid:edfd517b-1112-4821-b393-4b4cf0a69afb)
    Given Operator selects Order Billing data as below
      | startDate       | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                    |
      | uploadCsv       | 1122334455                                          |
      | generateFile    | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress    | {order-billing-email}                               |
      | csvFileTemplate | {csv-template}                                      |
    And Operator clicks Generate Success Billing Button
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                              |
      | bottom | the request can't be processed: No orders found for the report request ; no file will be generated |


  Scenario: Search Shipper by Upload CSV - Valid & Invalid Shipper ID at the Same Time - Generate "SHIPPER" Report (uid:d3e4c175-1eec-415d-a1fe-74ea2a94bc4e)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And Operator selects Order Billing data as below
      | startDate       | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                    |
      | uploadCsv       | {shipper-sop-v4-legacy-id},1122334455               |
      | generateFile    | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress    | {order-billing-email}                               |
      | csvFileTemplate | {csv-template}                                      |
    And Operator clicks Generate Success Billing Button
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                               |
      | bottom | Note: 1 Shippers in the file were not found. We will continue generation for the remaining shippers |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies the SSB header using data {shipper-ssb-headers}
    Then Operator verifies the SSB report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |


  Scenario: Search Shipper by Upload CSV -  Invalid File Type (uid:2c0617ed-a93e-4146-8a57-8743c472b050)
    Then Operator tries to upload a PDF and verifies that any other file except csv is not allowed

  @test
  @ArchiveRouteCommonV2
  Scenario: Search Shipper by Upload CSV with two columns (uid:f404e9e5-70f8-4407-bfa7-3057d410a97f)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[2].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]" with granular status "COMPLETED"
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                    |
      | uploadCsv       | {shipper-sop-v4-legacy-id},{shipper-v4-legacy-id}   |
      | generateFile    | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress    | {order-billing-email}                               |
      | csvFileTemplate | {csv-template}                                      |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies the SSB header using data {shipper-ssb-headers}
    Then Operator verifies the SSB report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} | {shipper-v4-legacy-id} |


  Scenario: Search Shipper by Upload CSV - Shipper ID from Different Operating Country (uid:d7760ca6-1f92-4f61-b9f3-a96240a5d57b)
    Given Operator selects Order Billing data as below
      | startDate       | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                    |
      | uploadCsv       | {shipper-sop-id-v4-legacy-id}                       |
      | generateFile    | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress    | {order-billing-email}                               |
      | csvFileTemplate | {csv-template}                                      |
    And Operator clicks Generate Success Billing Button
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                              |
      | bottom | the request can't be processed: No orders found for the report request ; no file will be generated |

  @HappyPath
  Scenario: Search Shipper by Upload CSV - Valid Shipper ID - Generate "ALL" Report (uid:94211053-c20d-499b-9742-54baa208182a)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Billing - Operator gets price order details from the billing_qa_gl.priced_orders table for order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with status "Completed"
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                          |
      | uploadCsv       | {shipper-sop-v4-legacy-id}                                |
      | generateFile    | All orders (1 very big file, takes long time to generate) |
      | emailAddress    | {order-billing-email}                                     |
      | csvFileTemplate | {csv-template}                                            |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies the SSB header using data {default-ssb-headers}
    Then Operator verifies the priced order details in the SSB CSV body for tracking Id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verifies the SSB report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |


  Scenario: Search Shipper by Upload CSV - Invalid Shipper ID - Generate "ALL" Report (uid:87374ccf-6795-4d22-9028-391e7a46a1fc)
    Given Operator selects Order Billing data as below
      | startDate       | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                          |
      | uploadCsv       | 1122334455                                                |
      | generateFile    | All orders (1 very big file, takes long time to generate) |
      | emailAddress    | {order-billing-email}                                     |
      | csvFileTemplate | {csv-template}                                            |
    And Operator clicks Generate Success Billing Button
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                              |
      | bottom | the request can't be processed: No orders found for the report request ; no file will be generated |

  @nadz
  Scenario: Search Shipper by Upload CSV - Valid & Invalid Shipper ID at the Same Time - Generate "ALL" Report (uid:a3c83778-4a7d-4b14-b8a3-9a9ba1e03001)
    Given Operator selects Order Billing data as below
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | uploadCsv    | {shipper-sop-v4-legacy-id},1122334455                     |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Operator clicks Generate Success Billing Button
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                               |
      | bottom | Note: 1 Shippers in the file were not found. We will continue generation for the remaining shippers |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies the SSB header using data {default-ssb-headers}
    Then Operator verifies the SSB report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |

  @HappyPath
  Scenario: Search Shipper by Upload CSV -  Valid Shipper ID - Generate "AGGREGATED" Report (uid:6e4e54e5-fb92-4ecc-a61a-1301799d969c)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                           |
      | uploadCsv    | {shipper-sop-v4-legacy-id}                                                                 |
      | generateFile | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                                                      |
    Then DB Billing - Operator gets price order details from the billing_qa_gl.priced_orders table for order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with status "Completed"
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies header for aggregated report using data {aggregated-ssb-headers}
    Then Operator verifies the SSB report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |


  Scenario: Search Shipper by Upload CSV - Invalid Shipper ID - Generate "AGGREGATED" Report (uid:e9d47d53-e032-4666-b18f-638a99474cf5)
    Given Operator selects Order Billing data as below
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                           |
      | uploadCsv    | 1122334455                                                                                 |
      | generateFile | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                                                      |
    And Operator clicks Generate Success Billing Button
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                              |
      | bottom | the request can't be processed: No orders found for the report request ; no file will be generated |


  Scenario: Search Shipper by Upload CSV - Valid & Invalid Shipper ID at the Same Time - Generate "AGGREGATED" Report (uid:62ae496e-0fab-4708-bf9f-da781eb068b0)
    Given Operator selects Order Billing data as below
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                           |
      | uploadCsv    | {shipper-sop-v4-legacy-id},1122334455                                                      |
      | generateFile | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                                                      |
    And Operator clicks Generate Success Billing Button
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                               |
      | bottom | Note: 1 Shippers in the file were not found. We will continue generation for the remaining shippers |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies header for aggregated report using data {aggregated-ssb-headers}
    Then Operator verifies the SSB report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |

  @HappyPath
  Scenario: Search Shipper by Upload CSV -  Valid Shipper ID - Generate "SCRIPT" Report (uid:2d148d59-72e0-4516-b9ac-165f4fe1e2fc)
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                                                      |
      | uploadCsv       | {shipper-sop-v4-legacy-id}                                                            |
      | generateFile    | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress    | {order-billing-email}                                                                 |
      | csvFileTemplate | {csv-template}                                                                        |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies the SSB header using data {default-ssb-headers}
    Then Operator verifies the SSB report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |

  Scenario: Search Shipper by Upload CSV - Invalid Shipper ID - Generate "SCRIPT" Report (uid:73e3dce4-6ae4-4790-a8d5-79dc008bbd78)
    Given Operator selects Order Billing data as below
      | startDate       | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                                                      |
      | uploadCsv       | 1122334455                                                                            |
      | generateFile    | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress    | {order-billing-email}                                                                 |
      | csvFileTemplate | {csv-template}                                                                        |
    And Operator clicks Generate Success Billing Button
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                              |
      | bottom | the request can't be processed: No orders found for the report request ; no file will be generated |


  Scenario: Search Shipper by Upload CSV - Valid & Invalid Shipper ID at the Same Time - Generate "SCRIPT" Report (uid:c023accf-e4c0-4c46-9dfb-227a144fbf6e)
    Given Operator selects Order Billing data as below
      | startDate       | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                                                      |
      | uploadCsv       | {shipper-sop-v4-legacy-id},1122334455                                                 |
      | generateFile    | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress    | {order-billing-email}                                                                 |
      | csvFileTemplate | {csv-template}                                                                        |
    And Operator clicks Generate Success Billing Button
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Network Request Error                                                                               |
      | bottom | Note: 1 Shippers in the file were not found. We will continue generation for the remaining shippers |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies the SSB header using data {default-ssb-headers}
    Then Operator verifies the SSB report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |


  Scenario: Search Shipper by Upload CSV - More than 1000 shippers - Generate "SHIPPER" Report (uid:39996a68-c65f-4b6e-a70e-d899eae896f8)
    Given Operator selects Order Billing data as below
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Operator generates CSV file with 1001 shippers
    When Operator selects Order Billing data as below
      | uploadCsv | generatedCsv |
    Then Operator verifies that error toast is displayed on Order Billing page:
      | top    | Upload failed                                                                 |
      | bottom | Your selected file has > 1000 shippers - please re-upload in smaller batches. |
    Then Finance Operator waits for '4' seconds
    When Operator generates CSV file with 1000 shippers
    When Operator generates success billings using data below:
      | uploadCsv | generatedCsv |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
