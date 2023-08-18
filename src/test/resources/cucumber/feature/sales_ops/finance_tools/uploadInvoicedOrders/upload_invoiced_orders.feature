@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @UploadInvoicedOrders
Feature: Upload Invoiced Orders
  non-invoiced = orders that are in priced_orders table, but not yet in invoiced_orders table
  has-invoiced = orders that are in priced_orders table and in invoiced_orders table
  non-priced = orders that are not in priced_orders table neither in invoiced_orders table

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    # MUST use qa@ninjavan.co because the email will be sent out to the operator email account.
    And API Operator whitelist email "{qa-email-address}"
    And operator marks gmail messages as read
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    When Upload Invoiced Orders page is loaded

  Scenario: Download Template Sample (uid:73c198bf-91eb-4177-a2bb-bb4cf6b2f283)
    And Operator clicks Download sample CSV template button on the Upload Invoiced Orders Page
    Then Operator verify Sample CSV file on Upload Invoiced Orders page downloaded successfully with below data
      | NVSAMPL00000000001 |
      | NVSAMPL00000000002 |
      | NVSAMPL00000000003 |

  @HappyPath
  Scenario: Upload Invoice Orders CSV - When Orders are Completed but not yet Invoiced (non-invoiced) (uid:ddb3318b-b545-411c-b750-1f1521befcdb)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-UIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-UIO-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And DB Operator verifies the order is not in billing_qa_gl.invoiced_orders table
    And Operator upload a CSV file with below order ids and verify success message
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And DB Operator verifies the order is in billing_qa_gl.invoiced_orders table
    Then Operator verifies below details in billing_qa_gl.invoiced_orders table
      | column              | expected_value                   |
      | order_id            | {KEY_CREATED_ORDER_ID}           |
      | shipper_id          | {shipper-sop-v4-global-id}       |
      | system_id           | SG                               |
      | invoiced_at         | {gradle-current-date-yyyy-MM-dd} |
      | invoiced_local_date | {gradle-current-date-yyyyMMdd}   |
      | created_at          | {gradle-current-date-yyyy-MM-dd} |
      | updated_at          | null                             |
      | deleted_at          | null                             |
    And DB Operator verifies the order is in billing_qa_gl.invoicing_jobs table
    Then Operator verifies below details in billing_qa_gl.invoicing_jobs table
      | column     | expected_value |
      | status     | SUCCESS        |
      | system_id  | SG             |
      | created_at | notNull        |
      | updated_at | notNull        |
      | deleted_at | notNull        |
    Then Operator gets price order details from the billing_qa_gl.priced_orders table
    Then Operator verifies below details in billing_qa_gl.priced_orders table
      | column       | expected_value |
      | payment_tags | INVOICED       |
    Then DB Billing - Operator gets order_payment_tags from the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies below details in billing_qa_gl.order_payment_tags table for tracking_id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
      | column               | expected_value                   |
      | order_id             | {KEY_CREATED_ORDER_ID}           |
      | shipper_id           | {shipper-sop-v4-global-id}       |
      | parent_shipper_id    | null                             |
      | system_id            | SG                               |
      | invoiced_at          | {gradle-current-date-yyyy-MM-dd} |
      | completed_local_date | {gradle-current-date-yyyyMMdd}   |
      | created_at           | {gradle-current-date-yyyy-MM-dd} |
      | deleted_at           | null                             |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    Then Operator opens Gmail and verifies email with below details
      | subject | Invoicing Result                           |
      | body    | All Tracking IDs are successfully invoiced |


  Scenario: Upload Invoice Orders CSV - When Orders are not in priced_orders neither invoiced_orders (non-priced) (uid:6c8bb540-5f3e-428f-a271-5fa05bf154aa)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-UIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-UIO-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And Operator verifies the order with status 'Completed' is not in billing_qa_gl.priced_orders
    And DB Operator verifies the order is not in billing_qa_gl.invoiced_orders table
    And Operator upload a CSV file with below order ids and verify success message
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And DB Operator verifies the order is not in billing_qa_gl.invoiced_orders table
    And DB Operator verifies the order is in billing_qa_gl.invoicing_jobs table
    Then Operator verifies below details in billing_qa_gl.invoicing_jobs table
      | column     | expected_value |
      | status     | SUCCESS        |
      | system_id  | SG             |
      | created_at | notNull        |
      | updated_at | notNull        |
      | deleted_at | notNull        |
    Then DB Billing - Operator verifies there is no entry in the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    Then Operator opens Gmail and verifies email with below details
      | subject            | Invoicing Result                           |
      | body               | (Total failed: 0, Total not yet priced: 1) |
      | isZipFileAvailable | true                                       |
    When Operator clicks on link to download on email and verifies CSV file
    Then Operator verifies below tracking id(s) is\are available in the CSV file
      | {KEY_CREATED_ORDER_TRACKING_ID} |


  Scenario: Upload Invoice Orders CSV - With Orders are already in invoiced_orders (has-invoiced) (uid:0736ad19-8d02-49a4-b5a1-07368a743daa)
  #pre-condition: Orders are already in invoiced_orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-UIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-UIO-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And DB Operator verifies the order is not in billing_qa_gl.invoiced_orders table
    And Operator upload a CSV file with below order ids and verify success message
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And DB Operator verifies the order is in billing_qa_gl.invoiced_orders table
    And DB Operator verifies the order is in billing_qa_gl.invoicing_jobs table
    Then Operator verifies below details in billing_qa_gl.invoicing_jobs table
      | column     | expected_value |
      | status     | SUCCESS        |
      | system_id  | SG             |
      | created_at | notNull        |
      | updated_at | notNull        |
      | deleted_at | notNull        |
    Then DB Billing - Operator gets order_payment_tags from the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator saves the invoiced_at value in the billing_qa_gl.order_payment_tags table for verifying purpose
  # Upload again
    And Operator upload a CSV file with below order ids and verify success message
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And DB Operator verifies the order is in billing_qa_gl.invoiced_orders table
    And DB Operator verifies there is\are 1 order(s) in billing_qa_gl.invoiced_orders table
    And DB Operator verifies the order is in billing_qa_gl.invoicing_jobs table
    Then Operator verifies below details in billing_qa_gl.invoicing_jobs table
      | column     | expected_value |
      | status     | SUCCESS        |
      | system_id  | SG             |
      | created_at | notNull        |
      | updated_at | notNull        |
      | deleted_at | notNull        |
    Then DB Billing - Operator gets order_payment_tags from the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies below details in billing_qa_gl.order_payment_tags table for tracking_id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
      | column               | expected_value                   |
      | order_id             | {KEY_CREATED_ORDER_ID}           |
      | shipper_id           | {shipper-sop-v4-global-id}       |
      | parent_shipper_id    | null                             |
      | system_id            | SG                               |
      | invoiced_at          | {gradle-current-date-yyyy-MM-dd} |
      | completed_local_date | {gradle-current-date-yyyyMMdd}   |
      | created_at           | {gradle-current-date-yyyy-MM-dd} |
      | deleted_at           | null                             |
      | update_at            | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies the invoiced_at value in the billing_qa_gl.order_payment_tags table is same as the previous value
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    Then Operator opens Gmail and verifies email with below details
      | subject | Invoicing Result                           |
      | body    | All Tracking IDs are successfully invoiced |

  Scenario: Upload Invoice Orders CSV - Some Orders are non-invoiced, Some Orders are non-priced neither non-invoiced (uid:531d9dea-0866-48e5-9fb8-522d029e696d)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-UIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-UIO-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And Operator upload a CSV file with below order ids and verify success message
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    Then Operator opens Gmail and verifies email with below details
      | subject            | Invoicing Result                           |
      | body               | (Total failed: 0, Total not yet priced: 1) |
      | isZipFileAvailable | true                                       |
    When Operator clicks on link to download on email and verifies CSV file
    Then Operator verifies below tracking id(s) is\are available in the CSV file
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |

  Scenario: Upload Invoiced Orders with invalid file type (not .csv) (uid:3ef6bcc3-2c11-477e-82ed-27c477b783e8)
    Then Operator uploads a PDF and verifies that any other file except csv is not allowed

  Scenario: Upload Invoice Orders with invalid template (e.g. two columns) (uid:38d566d5-c35a-493f-bec3-7ca283661534)
    Then Operator uploads an invalid CSV and verifies error message

  Scenario: Upload Invoice Orders CSV - upload CSV without the extension
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-UIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-UIO-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    And Operator gets 'Completed' price order details from the billing_qa_gl.priced_orders table
    And DB Operator verifies the order is not in billing_qa_gl.invoiced_orders table
    And Operator upload a CSV file without extension with below order ids and verify success message
      | {KEY_CREATED_ORDER_TRACKING_ID} |

  Scenario: Upload Invoice Orders CSV - When Orders are Completed but not yet Invoiced - Marketplace Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-mktpl-flat5-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-sop-mktpl-flat5-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Marketplace", "service_level":"STANDARD","marketplace": {"seller_id": "{sub-shipper-sop-mktpl-noDiscount-ext-ref}","seller_company_name": "{sub-shipper-sop-mktpl-noDiscount-name}"}, "from": {"name": "QA-SO-Test-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "COMPLETED"
    And Operator upload a CSV file with below order ids and verify success message
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And CV2 - Add common v1 data
      | order_id     | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | tracking_id  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | order_object | KEY_LIST_OF_CREATED_ORDERS[1]              |
    Then Operator gets price order details from the billing_qa_gl.priced_orders table
    Then Operator verifies below details in billing_qa_gl.priced_orders table
      | column       | expected_value |
      | payment_tags | INVOICED       |
    Then DB Billing - Operator gets order_payment_tags from the billing_qa_gl.order_payment_tags table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verifies below details in billing_qa_gl.order_payment_tags table for tracking_id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
      | column               | expected_value                      |
      | order_id             | {KEY_CREATED_ORDER_ID}              |
      | shipper_id           | {shipper-sop-v4-global-id}          |
      | parent_shipper_id    | {shipper-sop-mktpl-flat5-global-id} |
      | system_id            | SG                                  |
      | invoiced_at          | {gradle-current-date-yyyy-MM-dd}    |
      | completed_local_date | {gradle-current-date-yyyyMMdd}      |
      | created_at           | {gradle-current-date-yyyy-MM-dd}    |
      | deleted_at           | null                                |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op