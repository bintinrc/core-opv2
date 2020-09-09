@OperatorV2 @ShipperSupport @OperatorV2Part1 @UploadCsv @LaunchBrowser
Feature: Order Billing
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)
  "ALL": All orders (1 very big file, takes long time to generate)
  "SCRIPT": Orders consolidated by script (1 file per script), grouped by shipper within the file
  "AGGREGATED": All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate)
  "PARENT": Orders consolidated by parent shipper (1 file per parent shipper)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Order Billing
    When API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read


@nadeera
  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV -  Valid Shipper ID - Generate "SHIPPER" Report (uid:4176de9f-42ef-498b-911a-42379b1866b6)
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
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | uploadCsv    | {shipper-v4-legacy-id}                              |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body
    Then Operator verifies the report only contains orders from the shipper IDs in the uploaded file


  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV - Invalid Shipper ID - Generate "SHIPPER" Report (uid:edfd517b-1112-4821-b393-4b4cf0a69afb)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | uploadCsv    | 1122334455                                          |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is not attached with any CSV files in received email

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV - Valid & Invalid Shipper ID at the Same Time - Generate "SHIPPER" Report (uid:d3e4c175-1eec-415d-a1fe-74ea2a94bc4e)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                    |
      | uploadCsv    | {shipper-v4-legacy-id},1122334455                   |
      | generateFile | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress | {order-billing-email}                               |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {shipper-v4-legacy-id} |


  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV - Valid Shipper ID - Generate "ALL" Report (uid:94211053-c20d-499b-9742-54baa208182a)
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
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | uploadCsv    | {shipper-v4-legacy-id}                                    |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body
    Then Operator verifies the report only contains orders from the shipper IDs in the uploaded file

#  @nadeera
  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV - Invalid Shipper ID - Generate "ALL" Report (uid:87374ccf-6795-4d22-9028-391e7a46a1fc)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | uploadCsv    | 1122334455                                                |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is not attached with any CSV files in received email


  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV - Valid & Invalid Shipper ID at the Same Time - Generate "ALL" Report (uid:a3c83778-4a7d-4b14-b8a3-9a9ba1e03001)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                          |
      | uploadCsv    | {shipper-v4-legacy-id},1122334455                         |
      | generateFile | All orders (1 very big file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                     |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {shipper-v4-legacy-id} |

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV -  Valid Shipper ID - Generate "AGGREGATED" Report (uid:6e4e54e5-fb92-4ecc-a61a-1301799d969c)
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
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | uploadCsv    | {shipper-v4-legacy-id}                                                                |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body
    Then Operator verifies the report only contains orders from the shipper IDs in the uploaded file

#  @nadeera
  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV - Invalid Shipper ID - Generate "AGGREGATED" Report (uid:e9d47d53-e032-4666-b18f-638a99474cf5)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | uploadCsv    | 1122334455                                                                            |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is not attached with any CSV files in received email

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV - Valid & Invalid Shipper ID at the Same Time - Generate "AGGREGATED" Report (uid:62ae496e-0fab-4708-bf9f-da781eb068b0)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                      |
      | uploadCsv    | {shipper-v4-legacy-id},1122334455                                                     |
      | generateFile | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress | {order-billing-email}                                                                 |
    Then Operator gets price order details from the database
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {shipper-v4-legacy-id} |


  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV -  Valid Shipper ID - Generate "SCRIPT" Report (uid:2d148d59-72e0-4516-b9ac-165f4fe1e2fc)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                           |
      | uploadCsv    | {shipper-v4-legacy-id}                                                                     |
      | generateFile | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                                                      |
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Aggregated Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size" | "Parcel Weight" | "Count" | "Cost" |
    Then Operator verifies the report only contains orders from the shipper IDs in the uploaded file


  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV - Invalid Shipper ID - Generate "SCRIPT" Report (uid:73e3dce4-6ae4-4790-a8d5-79dc008bbd78)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                           |
      | uploadCsv    | 1122334455                                                                                 |
      | generateFile | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                                                      |
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is not attached with any CSV files in received email


  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Search Shipper by Upload CSV - Valid & Invalid Shipper ID at the Same Time - Generate "SCRIPT" Report (uid:c023accf-e4c0-4c46-9dfb-227a144fbf6e)
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                           |
      | uploadCsv    | {shipper-v4-legacy-id},1122334455                                                          |
      | generateFile | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                                                      |
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Aggregated Billing Report"
    Then Operator verifies the header using data below:
      | "Shipper ID" | "Shipper Name" | "Billing Name" | "Delivery Type Name" | "Delivery Type ID" | "Parcel Size" | "Parcel Weight" | "Count" | "Cost" |
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {shipper-v4-legacy-id} |

