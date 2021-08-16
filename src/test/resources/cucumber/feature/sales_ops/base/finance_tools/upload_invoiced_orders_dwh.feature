# Will be deleted after deprecation of DWH
Feature: Upload Invoiced Orders
  non-invoiced = orders that are in priced_orders table, but not yet in invoiced_orders table
  has-invoiced = orders that are in priced_orders table and in invoiced_orders table
  non-priced = orders that are not in priced_orders table neither in invoiced_orders table

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read


  Scenario: Download Template Sample (uid:73c198bf-91eb-4177-a2bb-bb4cf6b2f283)
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    And Operator clicks Download sample CSV template button on the Upload Invoiced Orders Page
    Then Operator verify Sample CSV file on Upload Invoiced Orders page downloaded successfully with below data
      | NVSAMPL00000000001 |
      | NVSAMPL00000000002 |
      | NVSAMPL00000000003 |

  @DeleteOrArchiveRoute
  Scenario: Upload Invoice Orders CSV - When Orders are Completed but not yet Invoiced (non-invoiced) (uid:ddb3318b-b545-411c-b750-1f1521befcdb)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And Operator gets 'Completed' price order details from the dwh_qa_gl.priced_orders table
    And DB Operator verifies the order is not in dwh_qa_gl.invoiced_orders table
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids and verify success message
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operator verifies the order is in dwh_qa_gl.invoiced_orders table
    Then Operator verifies below details in dwh_qa_gl.invoiced_orders table
      | column              | expected_value                   |
      | shipper_id          | {shipper-sop-v4-legacy-id}       |
      | system_id           | sg                               |
      | invoiced_at         | {gradle-current-date-yyyy-MM-dd} |
      | invoiced_local_date | {gradle-current-date-yyyyMMdd}   |
      | created_at          | {gradle-current-date-yyyy-MM-dd} |
      | updated_at          | null                             |
      | deleted_at          | null                             |
    And DB Operator verifies the order is not in dwh_qa_gl.invoicing_jobs table
    Then Operator waits for 20 seconds
    Then Operator opens Gmail and verifies email with below details
      | subject | Invoicing result                               |
      | body    | All tracking numbers are successfully invoiced |

  @DeleteOrArchiveRoute
  Scenario: Upload Invoice Orders CSV - When Orders are not in priced_orders neither invoiced_orders (non-priced) (uid:6c8bb540-5f3e-428f-a271-5fa05bf154aa)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator verifies the order with status 'Completed' is not in dwh_qa_gl.priced_orders
    And DB Operator verifies the order is not in dwh_qa_gl.invoiced_orders table
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids and verify success message
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operator verifies the order is not in dwh_qa_gl.invoiced_orders table
    And DB Operator verifies the order is not in dwh_qa_gl.invoicing_jobs table
    Then Operator waits for 20 seconds
    Then Operator opens Gmail and verifies email with below details
      | subject            | Invoicing result                           |
      | body               | (Total failed: 0, Total not yet priced: 1) |
      | isZipFileAvailable | true                                       |
    When Operator clicks on link to download on email and verifies CSV file
    Then Operator verifies below tracking id(s) is\are available in the CSV file
      | {KEY_CREATED_ORDER_TRACKING_ID} |

  @DeleteOrArchiveRoute
  Scenario: Upload Invoice Orders CSV - With Orders are already in invoiced_orders (has-invoiced) (uid:0736ad19-8d02-49a4-b5a1-07368a743daa)
   #pre-condition: Orders are already in invoiced_orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator verifies the order is not in dwh_qa_gl.invoiced_orders table
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids and verify success message
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operator verifies the order is in dwh_qa_gl.invoiced_orders table
    And DB Operator verifies the order is not in dwh_qa_gl.invoicing_jobs table
    # Upload again
    And Operator clicks on Upload New File Button
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids and verify success message
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operator verifies the order is in dwh_qa_gl.invoiced_orders table
    And DB Operator verifies there is\are 1 order(s) in dwh_qa_gl.invoiced_orders table
    And DB Operator verifies the order is not in dwh_qa_gl.invoicing_jobs table
    And DB Operator verifies the order is not in dwh_qa_gl.invoicing_jobs table
    Then Operator waits for 20 seconds
    Then Operator opens Gmail and verifies email with below details
      | subject | Invoicing result                               |
      | body    | All tracking numbers are successfully invoiced |

  @DeleteOrArchiveRoute
  Scenario: Upload Invoice Orders CSV - Some Orders are non-invoiced, Some Orders are non-priced neither non-invoiced (uid:531d9dea-0866-48e5-9fb8-522d029e696d)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids and verify success message
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator waits for 20 seconds
    Then Operator opens Gmail and verifies email with below details
      | subject            | Invoicing result                           |
      | body               | (Total failed: 0, Total not yet priced: 1) |
      | isZipFileAvailable | true                                       |
    When Operator clicks on link to download on email and verifies CSV file
    Then Operator verifies below tracking id(s) is\are available in the CSV file
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |


  Scenario: Upload Invoiced Orders with invalid file type (not .csv) (uid:3ef6bcc3-2c11-477e-82ed-27c477b783e8)
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    Then Operator uploads a PDF and verifies that any other file except csv is not allowed


  Scenario: Upload Invoice Orders with invalid template (e.g. two columns) (uid:38d566d5-c35a-493f-bec3-7ca283661534)
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    Then Operator uploads an invalid CSV and verifies error message

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
