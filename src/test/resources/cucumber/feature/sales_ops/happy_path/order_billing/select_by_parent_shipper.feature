@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling @HappyPath
Feature: Order Billing
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)
  "ALL": All orders (1 very big file, takes long time to generate)
  "SCRIPT": Orders consolidated by script (1 file per script), grouped by shipper within the file
  "AGGREGATED": All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read

  @DeleteOrArchiveRoute
  Scenario: Test Data: Generate order for MarketPlace shipper
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-mktpl-v4-client-id}                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-sop-mktpl-v4-client-secret}                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order

  @DeleteOrArchiveRoute
  Scenario: Test Data: Generate order for sub shipper
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {sub-shipper-sop-mktpl-v4-client-id}                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {sub-shipper-sop-mktpl-v4-client-secret}                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "SHIPPER" Success Billing Report - Selected By Parent Shipper - Marketplace Shipper (uid:8d849e00-001d-427b-9d52-ab52bd0d3ecf)
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                    |
      | parentShipper   | {shipper-sop-mktpl-v4-legacy-id}                    |
      | generateFile    | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress    | {order-billing-email}                               |
      | csvFileTemplate | 2 - SG Default SSB Template                         |
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Legacy Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Service Type" | "Service Level" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {sub-shipper-sop-mktpl-v4-legacy-id} | {shipper-sop-mktpl-v4-legacy-id} |

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "ALL" Success Billing Report - Selected By Parent Shipper - Marketplace Shipper (uid:312b04b5-59b6-493d-b578-6887411dd145)
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                          |
      | parentShipper   | {shipper-sop-mktpl-v4-legacy-id}                          |
      | generateFile    | All orders (1 very big file, takes long time to generate) |
      | emailAddress    | {order-billing-email}                                     |
      | csvFileTemplate | 2 - SG Default SSB Template                               |
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Legacy Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Service Type" | "Service Level" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {sub-shipper-sop-mktpl-v4-legacy-id} | {shipper-sop-mktpl-v4-legacy-id} |

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "AGGREGATED" Success Billing Report - Selected By Parent Shipper - Marketplace Shipper (uid:f4cbf856-3952-49cb-bc20-84a90a2aaefb)
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                                                           |
      | parentShipper   | {shipper-sop-mktpl-v4-legacy-id}                                                           |
      | generateFile    | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress    | {order-billing-email}                                                                      |
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Aggregated Billing Report"
    Then Operator verifies the header using data below:
      | "Legacy Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Service Type" | "Service Level" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {sub-shipper-sop-mktpl-v4-legacy-id} | {shipper-sop-mktpl-v4-legacy-id} |

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "SCRIPT" Success Billing Report - Selected By Parent Shipper - Marketplace Shipper (uid:9470be20-b69a-4309-a0e1-e72394c5f4d0)
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                                                      |
      | parentShipper   | {shipper-sop-mktpl-v4-legacy-id}                                                      |
      | generateFile    | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress    | {order-billing-email}                                                                 |
      | csvFileTemplate | 2 - SG Default SSB Template                                                           |
    Then Operator opens Gmail and checks received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Legacy Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Service Type" | "Service Level" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {sub-shipper-sop-mktpl-v4-legacy-id} | {shipper-sop-mktpl-v4-legacy-id} |