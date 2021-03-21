@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling
Feature: Order Billing
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)
  "ALL": All orders (1 very big file, takes long time to generate)
  "SCRIPT": Orders consolidated by script (1 file per script), grouped by shipper within the file
  "AGGREGATED": All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read


  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "SHIPPER" Success Billing Report - Selected Shipper (uid:3fe5e7fb-4dbb-4078-93f2-c2e1ce1bb2db)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Given Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | shipper      | {shipper-v4-legacy-id}                              |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    Then Operator gets 'Completed' price order details from the dwh_qa_gl.priced_orders table
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "ALL" Success Billing Report - Selected Shipper (uid:6f415334-b2d5-48b0-b39d-57e89bd9d1eb)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Given Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | shipper      | {shipper-v4-legacy-id}                                    |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    Then Operator gets 'Completed' price order details from the dwh_qa_gl.priced_orders table
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "AGGREGATED" Success Billing Report - Selected Shipper (uid:e45b4c91-9a83-46ef-8384-9cf841cea016)
    Given Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                           |
      | shipper      | {shipper-v4-legacy-id}                                                                     |
      | generateFile | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                                                      |
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Aggregated Billing Report"
    Then Operator gets the orders and parcel size and weight from the database for specified shipper
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size" | "Parcel Weight" | "Count" | "Cost" |
    Then Operator verifies the orders grouped by shipper and parcel size and weight

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "SCRIPT" Success Billing Report - Selected Shipper (uid:1fc9c536-15b8-4157-b14c-88c595805819)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Given Operator go to menu Shipper Support -> Order Billing
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | uploadCsv    | {shipper-v4-legacy-id}                                                                |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    Then Operator opens Gmail and checks received email
    Then Operator gets 'Completed' price order details from the dwh_qa_gl.priced_orders table
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body

