@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @UploadInvoicedOrders

Feature: Upload Invoiced Orders
  non-invoiced = orders that are in priced_orders table, but not yet in invoiced_orders table
  has-invoiced = orders that are in priced_orders table and in invoiced_orders table
  non-priced = orders that are not in priced_orders table neither in invoiced_orders table

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Operator whitelist email "{order-billing-email}"
    Given operator marks gmail messages as read

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Upload Invoice Orders CSV - When Orders are Completed but not yet Invoiced (non-invoiced) (uid:ddb3318b-b545-411c-b750-1f1521befcdb)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And Operator gets 'Completed' price order details from the dwh_qa_gl.priced_orders table
    And DB Operator verifies the order is not in dwh_qa_gl.invoiced_orders table
    Given Operator go to menu New Features -> Upload Invoiced Orders
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids
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
    Then Operator opens Gmail and verifies email with below details
      | subject | Invoicing result                               |
      | body    | All tracking numbers are successfully invoiced |

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Upload Invoice Orders CSV - When Orders are not in priced_orders neither invoiced_orders (non-priced) (uid:6c8bb540-5f3e-428f-a271-5fa05bf154aa)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator verifies the order with status 'Completed' is not in dwh_qa_gl.priced_orders
    And DB Operator verifies the order is not in dwh_qa_gl.invoiced_orders table
    Given Operator go to menu New Features -> Upload Invoiced Orders
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operator verifies the order is not in dwh_qa_gl.invoiced_orders table
    And DB Operator verifies the order is not in dwh_qa_gl.invoicing_jobs table
    And DB Operator verifies the order is not in dwh_qa_gl.invoicing_jobs table
    Then Operator opens Gmail and verifies email with below details
      | subject            | Invoicing result                           |
      | body               | (Total failed: 0, Total not yet priced: 1) |
      | isZipFileAvailable | true                                       |
    When Operator clicks on link to download on email and verifies CSV file
    Then Operator verifies Tracking ID is available in the CSV file

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Upload Invoice Orders CSV - With Orders are already in invoiced_orders (has-invoiced) (uid:0736ad19-8d02-49a4-b5a1-07368a743daa)
   #pre-condition: Orders are already in invoiced_orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    And DB Operator verifies the order is not in dwh_qa_gl.invoiced_orders table
    Given Operator go to menu New Features -> Upload Invoiced Orders
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operator verifies the order is in dwh_qa_gl.invoiced_orders table
    And DB Operator verifies the order is not in dwh_qa_gl.invoicing_jobs table
    # Upload again
    And Operator clicks on Upload New File Button
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operator verifies the order is in dwh_qa_gl.invoiced_orders table
    And DB Operator verifies there is\are 1 order(s) in dwh_qa_gl.invoiced_orders table
    And DB Operator verifies the order is not in dwh_qa_gl.invoicing_jobs table
    And DB Operator verifies the order is not in dwh_qa_gl.invoicing_jobs table
    Then Operator opens Gmail and verifies email with below details
      | subject | Invoicing result                               |
      | body    | All tracking numbers are successfully invoiced |

  @nadeera
  Scenario: Upload Invoice Orders CSV - Some Orders are non-invoiced, Some Orders are non-priced neither non-invoiced (uid:531d9dea-0866-48e5-9fb8-522d029e696d)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","from": {"name": "QA-SO-Test-From","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-SO-Test-To","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order id "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Given Operator go to menu New Features -> Upload Invoiced Orders
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    Then Operator opens Gmail and verifies email with below details
      | subject | Invoicing result                               |
      | body    | All tracking numbers are successfully invoiced |
#
#    Given "finance" has non-invoiced order
#    And "order 'A'" is in "db_name" / "priced_orders" table - completed
#    But "order 'A'" is not in "invoiced_orders" table
#    And "order 'B'" is not in "priced_orders" table- not completed
#    And "order 'B'" is not in "invoiced_orders" table
#    When "finance" goes to "Upload Invoiced Orders" page on operatorv2
#    Then verifies "Upload Invoiced Orders" page is displayed
#    When "finance" clicks on "'Upload Invoiced Orders with CSV'" button
#    Then verifies "'Upload Invoiced Orders with CSV'" modal is displayed
#    When "finance" chooses "a CSV file" to upload
#    Then verifies "the file's name and size" is displayed on the modal
#    When "finance" clicks on "Submit" button
#    Then verifies "success upload" notification is shown
#    And verifies "'Uploaded: file_name.csv'" information is displayed
#    And verifies "'Invoiced orders are processing... please wait for an email confirmation.'" information is displayed
#    And verifies "'Upload New File'" button is displayed
#    And verifies "tracking ids from order 'A'" is in "invoiced_orders" table
#    And verifies "tracking ids from order 'B'" is not found in "invoiced_orders" table
#    And verifies "invoicing email" is sent to the email address
#    And EMAIL_ORDERS_FAIL_TO_INVOICED
#    When "finance" clicks on "link to download" on email
#    Then verifies "csv (list of orders that are not priced)" is downloaded
#    When qa checks into "dwh_qa_gl" / "invoicing_job" by "tracking_ids"
#    Then verifies "the tracking id" is not found in "invoicing_job" table



