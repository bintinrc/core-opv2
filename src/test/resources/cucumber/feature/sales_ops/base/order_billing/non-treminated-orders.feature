@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling @NonTerminatedOrders
Feature: Order Billing
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)
  "ALL": All orders (1 very big file, takes long time to generate)
  "SCRIPT": Orders consolidated by script (1 file per script), grouped by shipper within the file
  "AGGREGATED": All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And API Operator whitelist email "{order-billing-email}"
    And operator marks gmail messages as read

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `Arrived at Distribution Point` Order Exists (uid:e7eee954-af8d-471c-8c60-42df489fe56a)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "Arrived at Distribution Point"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-sop-v4-legacy-id}                          |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `Arrived at Distribution Point` Order Exists (uid:81a5fe1a-caaa-4c35-a42c-302b0f8c8209)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "Arrived at Distribution Point"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-sop-v4-legacy-id}                                |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `Arrived at Distribution Point` Order Exists (uid:2252083c-7576-457b-af7b-3e101b3feb0d)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "Arrived at Distribution Point"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-sop-v4-legacy-id}                                                            |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser @e2e
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `Arrived at Distribution Point` to `Completed` Order (uid:79e44d8c-6b4a-4ce7-86d4-b5a1525c36fb)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator get order details
    And DB Operator get DP job id
    And API Operator do the DP Success for From Driver Flow
    And API Driver v5 success dp drop off
    And API Operator gets all the SMS notification by Tracking ID
    And DB Operator gets all details for ninja collect driver drop off confirmed status
    And DB Operator gets Customer Unlock Code Based on Tracking ID
    And API DP do the Customer Collection from dp with ID = "{opv2-dp-dp-id}"
    And API Operator recalculate the priced order
    And Operator verifies the order with status 'Completed' is in dwh_qa_gl.priced_orders
    And Operator gets 'Completed' price order details from the dwh_qa_gl.priced_orders table
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-sop-v4-legacy-id}                          |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on billing report
    Then Operator verifies the order with status 'Completed' is displayed on billing report
    Then Operator verifies the priced order details in the body
    Then DB Operator verifies completed date of the priced order is the same as core.transactions.service_end_time

  @DeleteOrArchiveRoute @KillBrowser @e2e
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `Arrived at Distribution Point` to `Completed` Order (uid:4f65e234-4a9f-4f5a-9949-71350459be2b)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator get order details
    And DB Operator get DP job id
    And API Operator do the DP Success for From Driver Flow
    And API Driver v5 success dp drop off
    And API Operator gets all the SMS notification by Tracking ID
    And DB Operator gets all details for ninja collect driver drop off confirmed status
    And DB Operator gets Customer Unlock Code Based on Tracking ID
    And API DP do the Customer Collection from dp with ID = "{opv2-dp-dp-id}"
    And API Operator recalculate the priced order
    And Operator verifies the order with status 'Completed' is in dwh_qa_gl.priced_orders
    And Operator gets 'Completed' price order details from the dwh_qa_gl.priced_orders table
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-sop-v4-legacy-id}                                |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on billing report
    Then Operator verifies the order with status 'Completed' is displayed on billing report
    Then Operator verifies the priced order details in the body

  @DeleteOrArchiveRoute @KillBrowser @e2e
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `Arrived at Distribution Point` to `Completed` Order (uid:6abadb91-53e6-4f39-b7c3-52859d0061c7)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator get order details
    And DB Operator get DP job id
    And API Operator do the DP Success for From Driver Flow
    And API Driver v5 success dp drop off
    And API Operator gets all the SMS notification by Tracking ID
    And DB Operator gets all details for ninja collect driver drop off confirmed status
    And DB Operator gets Customer Unlock Code Based on Tracking ID
    And API DP do the Customer Collection from dp with ID = "{opv2-dp-dp-id}"
    And API Operator recalculate the priced order
    And Operator verifies the order with status 'Completed' is in dwh_qa_gl.priced_orders
    And Operator gets 'Completed' price order details from the dwh_qa_gl.priced_orders table
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-sop-v4-legacy-id}                                                            |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on billing report
    Then Operator verifies the order with status 'Completed' is displayed on billing report
    Then Operator verifies the priced order details in the body

  @DeleteOrArchiveRoute @KillBrowser @e2e
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `Arrived at Distribution Point` to `Returned to Sender` Order (uid:2700aa48-d75b-49da-8493-6b8f6ea4dd77)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator get order details
    And DB Operator get DP job id
    And API Operator do the DP Success for From Driver Flow
    And API Driver "2.2" success dp drop off
    And DB Operator gets all the data input for Driver Drop Off Order from database
    And DB Operator set pickup date of DP reservation to current date
    And API Operator trigger Add Overstayed Orders
    And DB Operator set collect until date of DP reservation to yesterday's date
    And API Operator trigger overstay to create new reservation
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And Operator gets 'Returned to Sender' price order details from the dwh_qa_gl.priced_orders table
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-sop-v4-legacy-id}                          |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on billing report
    Then Operator verifies the order with status 'Returned To Sender' is displayed on billing report
    Then Operator verifies the priced order details in the body
    Then DB Operator verifies completed date of the priced order is the same as core.transactions.service_end_time

  @DeleteOrArchiveRoute @KillBrowser @e2e
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `Arrived at Distribution Point` to `Returned to Sender` Order (uid:ddcd007e-92f6-4ab9-acdf-09e970a0cd83)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator get order details
    And DB Operator get DP job id
    And API Operator do the DP Success for From Driver Flow
    And API Driver "2.2" success dp drop off
    And DB Operator gets all the data input for Driver Drop Off Order from database
    And DB Operator set pickup date of DP reservation to current date
    And API Operator trigger Add Overstayed Orders
    And DB Operator set collect until date of DP reservation to yesterday's date
    And API Operator trigger overstay to create new reservation
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-sop-v4-legacy-id}                                |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on billing report
    Then Operator verifies the order with status 'Returned To Sender' is displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser @e2e
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `Arrived at Distribution Point` to `Returned to Sender` Order (uid:a7e7cbbd-9291-4737-95ca-8166df5d7a04)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator get order details
    And DB Operator get DP job id
    And API Operator do the DP Success for From Driver Flow
    And API Driver "2.2" success dp drop off
    And DB Operator gets all the data input for Driver Drop Off Order from database
    And DB Operator set pickup date of DP reservation to current date
    And API Operator trigger Add Overstayed Orders
    And DB Operator set collect until date of DP reservation to yesterday's date
    And API Operator trigger overstay to create new reservation
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-sop-v4-legacy-id}                                                            |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Arrived at Distribution Point' is not displayed on billing report
    Then Operator verifies the order with status 'Returned To Sender' is displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `On Vehicle for Delivery` Order Exists (uid:8a72ea83-d7e9-4044-9dd7-fd8bb396e1ec)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "On Vehicle for Delivery"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-sop-v4-legacy-id}                          |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'On Vehicle for Delivery' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `On Vehicle for Delivery` Order Exists (uid:a6142b06-fa81-45cf-b206-c73e43c58915)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "On Vehicle for Delivery"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-sop-v4-legacy-id}                                |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'On Vehicle for Delivery' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `On Vehicle for Delivery` Order Exists (uid:03e4f822-afba-405e-8a3c-64002f8e75c6)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "On Vehicle for Delivery"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-sop-v4-legacy-id}                                                            |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'On Vehicle for Delivery' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `Cancelled ` Order Exists (uid:2b4a671e-f7e7-40a3-86ce-c7e9d74a6e3e)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "Cancelled"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-sop-v4-legacy-id}                          |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Cancelled' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `Cancelled` Order Exists (uid:24d5fd4a-0a7a-465e-9651-4f15849b6643)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "Cancelled"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-sop-v4-legacy-id}                                |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Cancelled' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `Cancelled` Order Exists (uid:fe78275d-b4b9-4bd3-881e-6d6dd5f8d6dc)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "Cancelled"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-sop-v4-legacy-id}                                                            |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Cancelled' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `On Hold` Order Exists (uid:40a0c5f0-7177-4637-8415-9f1a7a901bb3)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "On Hold"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-sop-v4-legacy-id}                          |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'On Hold' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - `On Hold` Order Exists (uid:4541831c-72dc-4c82-8fb1-1ed824ada455)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "On Hold"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-sop-v4-legacy-id}                                |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'On Hold' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - `On Hold` Order Exists (uid:c38a672b-6ff1-4fdd-add2-b2fcd443eb3d)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "On Hold"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-sop-v4-legacy-id}                                                            |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'On Hold' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - NULL Status Order Exists (uid:6bc3350d-f2a3-462c-82a2-6ebc295ac597)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "NULL"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-sop-v4-legacy-id}                          |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'NULL' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "ALL" Success Billing Report - NULL Status Order Exists (uid:97578e96-9d0b-4616-9874-3e4c23cdfdfe)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "NULL"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-sop-v4-legacy-id}                                |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'NULL' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SCRIPT" Success Billing Report - NULL Status Order Exists (uid:ff35ea8d-c629-44d5-8d4d-696ddd440ba8)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "NULL"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | shipper      | {shipper-sop-v4-legacy-id}                                                            |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'NULL' is not displayed on billing report

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Selected Shipper - Generate "SHIPPER" Success Billing Report - `Pending Reschedule` Order Exists (uid:534bc797-010e-408a-86d7-1db75441a0b2)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator updates the granular status of the priced order to "Pending Reschedule"
    And Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-sop-v4-legacy-id}                          |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    And Operator waits for 40 seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    And Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the order with status 'Pending Reschedule' is not displayed on billing report

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op