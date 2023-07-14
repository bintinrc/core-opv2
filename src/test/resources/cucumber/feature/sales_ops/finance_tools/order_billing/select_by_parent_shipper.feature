@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @OrderBilling @ParentShipper

Feature: Order Billing Parent Shipper
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)
  "ALL": All orders (1 very big file, takes long time to generate)
  "SCRIPT": Orders consolidated by script (1 file per script), grouped by shipper within the file
  "AGGREGATED": All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Gmail - Operator connect to "{order-billing-email}" inbox using password "{order-billing-email-password}"
    Given API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read


  @HappyPath @GenerateTestData
  Scenario: Test Data: Generate order for MarketPlace shipper
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-mktpl-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-sop-mktpl-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order

  @HappyPath @GenerateTestData
  Scenario: Test Data: Generate order for sub shipper
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {sub-shipper-sop-mktpl-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {sub-shipper-sop-mktpl-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order

  @DeleteOrArchiveRoute @HappyPath
  Scenario: Generate "SHIPPER" Success Billing Report - Selected By Parent Shipper - Marketplace Shipper (uid:9f788797-8cda-4fad-b87b-8e92009577b6)
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                    |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                    |
      | parentShipper   | {shipper-sop-mktpl-v4-legacy-id}                    |
      | generateFile    | Orders consolidated by shipper (1 file per shipper) |
      | emailAddress    | {order-billing-email}                               |
      | csvFileTemplate | {csv-template}                                      |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received email
    Then Operator gets the success billing report entries
    Then Operator verifies the header using data {shipper-ssb-headers}
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {sub-shipper-sop-mktpl-v4-legacy-id} | {shipper-sop-mktpl-v4-legacy-id} |


  @DeleteOrArchiveRoute @HappyPath
  Scenario: Generate "ALL" Success Billing Report - Selected By Parent Shipper - Marketplace Shipper (uid:0177a1b4-c964-43de-9e83-8f9d6d67c0a0)
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                          |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                          |
      | parentShipper   | {shipper-sop-mktpl-v4-legacy-id}                          |
      | generateFile    | All orders (1 very big file, takes long time to generate) |
      | emailAddress    | {order-billing-email}                                     |
      | csvFileTemplate | {csv-template}                                            |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received email
    Then Operator gets the success billing report entries
    Then Operator verifies the header using data {default-ssb-headers}
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {sub-shipper-sop-mktpl-v4-legacy-id} | {shipper-sop-mktpl-v4-legacy-id} |


  @DeleteOrArchiveRoute @HappyPath
  Scenario: Generate "AGGREGATED" Success Billing Report - Selected By Parent Shipper - Marketplace Shipper (uid:56d32c3e-bb0f-4a7d-8c94-babe66f3e530)
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate     | {gradle-current-date-yyyy-MM-dd}                                                           |
      | endDate       | {gradle-current-date-yyyy-MM-dd}                                                           |
      | parentShipper | {shipper-sop-mktpl-v4-legacy-id}                                                           |
      | generateFile  | All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate) |
      | emailAddress  | {order-billing-email}                                                                      |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received email
    Then Operator gets the success billing report entries
    Then Operator verifies the header using data {aggregated-ssb-headers}
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {sub-shipper-sop-mktpl-v4-legacy-id} | {shipper-sop-mktpl-v4-legacy-id} |


  @DeleteOrArchiveRoute @HappyPath
  Scenario: Generate "SCRIPT" Success Billing Report - Selected By Parent Shipper - Marketplace Shipper (uid:398a38d3-c451-409b-8a7a-f9e015e0a0e3)
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                                                      |
      | parentShipper   | {shipper-sop-mktpl-v4-legacy-id}                                                      |
      | generateFile    | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress    | {order-billing-email}                                                                 |
      | csvFileTemplate | {csv-template}                                                                        |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received email
    Then Operator gets the success billing report entries
    Then Operator verifies the header using data {default-ssb-headers}
    Then Operator verifies the report only contains valid shipper IDs like below:
      | {sub-shipper-sop-mktpl-v4-legacy-id} | {shipper-sop-mktpl-v4-legacy-id} |

  Scenario: Generate Success Billing Report - Selected By Parent Shipper - Empty Shipper ID (uid:afe1b878-a02c-4df7-808d-58f3c02fe348)
    Given Operator go to menu Finance Tools -> Order Billing
    Given Operator selects Order Billing data as below
      | startDate       | {gradle-current-date-yyyy-MM-dd}                                                      |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                                                      |
      | generateFile    | Orders consolidated by script (1 file per script), grouped by shipper within the file |
      | emailAddress    | {order-billing-email}                                                                 |
      | csvFileTemplate | {csv-template}                                                                        |
    Then Operator chooses 'Select by Parent Shipper' option and does not input a shipper ID
    Then Operator clicks Generate Success Billing Button
    Then Operator verifies error msg "At least 1 shippers must be selected." in Order Billing Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op