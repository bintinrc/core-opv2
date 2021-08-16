@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling @UploadCsv @HappyPath

Feature: Order Billing
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)
  "ALL": All orders (1 very big file, takes long time to generate)
  "SCRIPT": Orders consolidated by script (1 file per script), grouped by shipper within the file
  "AGGREGATED": All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Finance Tools -> Order Billing
    Given API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read

  @DeleteOrArchiveRoute
  Scenario: Search Shipper by Upload CSV -  Valid Shipper ID - Generate "SHIPPER" Report (uid:dab7512d-2eb3-434f-9275-07165ea21f98)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And Operator gets 'Completed' price order details from the billing_qa_gl.priced_orders table
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate         | {gradle-next-1-day-yyyy-MM-dd}                      |
      | uploadCsv       | {shipper-sop-v4-legacy-id}                          |
      | generateFile    | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress    | {order-billing-email}                               |
      | csvFileTemplate | 2 - SG Default SSB Template                         |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator gets the success billing report entries
    Then Operator verifies the header using data {shipper-ssb-headers}
    Then Operator verifies the priced order details in the body
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |

  @DeleteOrArchiveRoute
  Scenario: Search Shipper by Upload CSV - Valid Shipper ID - Generate "ALL" Report (uid:2973eb67-3164-4808-8cf6-55ee4b48d282)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And Operator gets 'Completed' price order details from the billing_qa_gl.priced_orders table
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                          |
      | uploadCsv       | {shipper-sop-v4-legacy-id}                                |
      | generateFile    | All orders (1 very big file, takes long time to generate) |
      | emailAddress    | {order-billing-email}                                     |
      | csvFileTemplate | 2 - SG Default SSB Template                               |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received email
    Then Operator gets the success billing report entries
    Then Operator verifies the header using data {shipper-ssb-headers}
    Then Operator verifies the priced order details in the body
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |

  @DeleteOrArchiveRoute
  Scenario: Search Shipper by Upload CSV -  Valid Shipper ID - Generate "AGGREGATED" Report (uid:286402c8-3ef7-40cb-b97a-d0c4a23709ea)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    When Operator generates success billings using data below:
      | startDate    | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate      | {gradle-current-date-yyyy-MM-dd}                                                           |
      | uploadCsv    | {shipper-sop-v4-legacy-id}                                                                 |
      | generateFile | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress | {order-billing-email}                                                                      |
    Then Operator gets 'Completed' price order details from the billing_qa_gl.priced_orders table
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator gets the success billing report entries
    Then Operator verifies the header using data {aggregated-ssb-headers}
    Then Operator verifies the priced order details in the body
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |

  @DeleteOrArchiveRoute
  Scenario: Search Shipper by Upload CSV -  Valid Shipper ID - Generate "SCRIPT" Report (uid:da5c9eb3-2769-4d6a-a836-99cfeffa5239)
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                                                      |
      | uploadCsv       | {shipper-sop-v4-legacy-id}                                                            |
      | generateFile    | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress    | {order-billing-email}                                                                 |
      | csvFileTemplate | 2 - SG Default SSB Template                                                           |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received email
    Then Operator gets the success billing report entries
    Then Operator verifies the header using data {shipper-ssb-headers}
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {shipper-sop-v4-legacy-id} |


  @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op