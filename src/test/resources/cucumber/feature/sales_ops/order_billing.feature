@OperatorV2 @ShipperSupport @OperatorV2Part1 @OrderBilling @SalesOps @LaunchBrowser
Feature: Order Billing
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)
  "ALL": All orders (1 very big file, takes long time to generate)
  "SCRIPT": Orders consolidated by script (1 file per script), grouped by shipper within the file
  "AGGREGATED": All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate)
  "PARENT": Orders consolidated by parent shipper (1 file per parent shipper)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver deliver the created parcel successfully
    When API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read
    Given Operator go to menu Shipper Support -> Order Billing

    @nadeerad
  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "SHIPPER" Success Billing Report - All Shippers (uid:714b412f-6a26-4198-b7f0-0e55edf054e0)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    Then Operator opens Gmail and checks received email
    Then Operator gets the count of files when orders consolidated by shipper from the database
    Then Operator verifies zip is attached with multiple CSV files in received email
    Then Operator verifies the count of files in zip

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "SHIPPER" Success Billing Report - Selected Shipper (uid:3fe5e7fb-4dbb-4078-93f2-c2e1ce1bb2db)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-v4-name}                                   |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "ALL" Success Billing Report - All Shippers (uid:59af6bea-ac85-446d-97ba-4d386577f447)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "ALL" Success Billing Report - Selected Shipper (uid:6f415334-b2d5-48b0-b39d-57e89bd9d1eb)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-v4-name}                                         |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "AGGREGATED" Success Billing Report - All Shippers (uid:68cbd874-d3a8-4cd0-a1e5-efe6e46fb29e)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                           |
      | generateFile | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                                                      |
    Then Operator gets the orders grouped by shipper and parcel size and weight from the database for all shippers
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Aggregated Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size" | "Parcel Weight" | "Count" | "Cost" |
    Then Operator verifies the orders grouped by shipper and parcel size and weight

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "AGGREGATED" Success Billing Report - Selected Shipper (uid:e45b4c91-9a83-46ef-8384-9cf841cea016)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                           |
      | shipper      | {shipper-v4-name}                                                                          |
      | generateFile | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                                                      |
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Aggregated Billing Report"
    Then Operator gets the orders and parcel size and weight from the database for specified shipper
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size" | "Parcel Weight" | "Count" | "Cost" |
    Then Operator verifies the orders grouped by shipper and parcel size and weight

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "SCRIPT" Success Billing Report - All Shippers (uid:a6967dec-0d31-46f8-98c0-efe91682bd35)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    Then Operator opens Gmail and checks received email
    Then Operator gets the count of files when orders consolidated by script from the database
    Then Operator verifies zip is attached with multiple CSV files in received email
    Then Operator verifies the count of files in zip

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "SCRIPT" Success Billing Report - Selected Shipper (uid:1fc9c536-15b8-4157-b14c-88c595805819)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | uploadCsv    | {shipper-v4-legacy-id}                                                                |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    Then Operator opens Gmail and checks received email
    Then Operator gets price order details from the database
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body
