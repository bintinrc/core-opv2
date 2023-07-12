@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @SearchInvoicedOrders

Feature: Upload Invoiced Orders

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath
  Scenario: Search by uploading CSV which contains existing invoiced order (uid:e21e7b2f-1423-494e-ae7b-842c42e6ced9)
    #pre-condition: Order is already in invoiced_orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SIO-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator force succeed created order
    And DB Operator verifies the order is not in billing_qa_gl.invoiced_orders table
    And Operator go to menu Finance Tools -> Upload Invoiced Orders
    When Upload Invoiced Orders page is loaded
    And Operator upload a CSV file with below order ids and verify success message
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operator verifies the order is in billing_qa_gl.invoiced_orders table
    # Upload Csv
    And Operator go to menu Finance Tools -> Invoiced Orders Search
    When Search Invoiced Orders page is loaded
    And Operator upload a CSV file with below order ids on Invoiced Orders Search Page
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verifies the order count is correctly displayed as 1
    Then Operator verifies below tracking ID(s) and creation time is displayed
      | {KEY_CREATED_ORDER_TRACKING_ID} |

  Scenario: Search by Uploading CSV which contains non-invoiced orders (uid:22a4abe1-b971-4f06-b2a6-d82d92c16169)
    #pre-condition: Order is already in invoiced_orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SIO-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator force succeed created order
    And DB Operator verifies the order is not in billing_qa_gl.invoiced_orders table
    # Upload Csv
    And Operator go to menu Finance Tools -> Invoiced Orders Search
    When Search Invoiced Orders page is loaded
    And Operator upload a CSV file with below order ids on Invoiced Orders Search Page
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verifies No Data is displayed in the invoiced orders search page

  Scenario: Search by Uploading Invalid File Type (uid:daf938d9-983d-477b-950b-1f9c8f3577ca)
    Given Operator go to menu Finance Tools -> Invoiced Orders Search
    When Search Invoiced Orders page is loaded
    Then Operator uploads a PDF on Invoiced Orders Search Page and verifies error message as below:
      | top    | Failed to upload CSV file      |
      | bottom | Please select only .csv files. |

  Scenario: Search by Uploading CSV file with invalid format template (uid:e4e8b221-0776-45fd-9924-5229f390020d)
    Given Operator go to menu Finance Tools -> Invoiced Orders Search
    When Search Invoiced Orders page is loaded
    Then Operator uploads an invalid CSV on Invoiced Orders Search Page CSV and verifies error message as below:
      | top    | Failed to upload CSV file                |
      | bottom | More than 1 column detected in csv file. |

  @HappyPath
  Scenario: Search by Inputting invoiced order tracking IDs manually (uid:caceedb4-fdd5-4f71-a82c-e80271b6cc4b)
       #pre-condition: Order is already in invoiced_orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SIO-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator force succeed created order
    And DB Operator verifies the order is not in billing_qa_gl.invoiced_orders table
    And Operator go to menu Finance Tools -> Upload Invoiced Orders
    When Upload Invoiced Orders page is loaded
    And Operator upload a CSV file with below order ids and verify success message
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operator verifies the order is in billing_qa_gl.invoiced_orders table
      # Search by tracking_id
    And Operator go to menu Finance Tools -> Invoiced Orders Search
    When Search Invoiced Orders page is loaded
    And Operator clicks in Enter Tracking ID(s) tab
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Invoiced Orders Search Page
    And Operator clicks Search Invoiced Order button
    Then Operator verifies below tracking ID(s) and creation time is displayed
      | {KEY_CREATED_ORDER_TRACKING_ID} |

  Scenario: Search by Inputting non-invoiced order tracking IDs manually (uid:990f7046-ec19-4c45-b560-78783f28b367)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SIO-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator force succeed created order
    And DB Operator verifies the order is not in billing_qa_gl.invoiced_orders table
      # Search by tracking_id
    And Operator go to menu Finance Tools -> Invoiced Orders Search
    When Search Invoiced Orders page is loaded
    And Operator clicks in Enter Tracking ID(s) tab
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Invoiced Orders Search Page
    And Operator clicks Search Invoiced Order button
    Then Operator verifies No Data is displayed in the invoiced orders search page

  Scenario: Search invoiced orders without upload file or input manually (uid:1ea16236-000e-4ac2-872a-9fde775261f0)
    Given Operator go to menu Finance Tools -> Invoiced Orders Search
    When Search Invoiced Orders page is loaded
    And Operator clicks in Enter Tracking ID(s) tab
    And Operator clicks Search Invoiced Order button without a tracking ID
    Then Operator verifies message "This field is required." is displayed

  Scenario: Refresh the invoiced order search result (uid:0aff78ff-af38-4e08-8eb5-0087a16cfec6)
     #pre-condition: Order is already in invoiced_orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-sop-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SIO-From","phone_number": "+6512453201","email": "senderV4@nvqa.co","address": {"address1": "30 Jalan Kilang Barat","address2": "NVQA V4 HQ","country": "SG","postcode": "159364"}},"to": {"name": "QA-SO-Test-SIO-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North V4","address2": "NVQA V4 home","country": "SG","postcode": "159363"}},"parcel_job":{"cash_on_delivery": 35,"insured_value": 75, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": "1.0" },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator force succeed created order
    And DB Operator verifies the order is not in billing_qa_gl.invoiced_orders table
    And Operator go to menu Finance Tools -> Upload Invoiced Orders
    When Upload Invoiced Orders page is loaded
    And Operator upload a CSV file with below order ids and verify success message
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operator verifies the order is in billing_qa_gl.invoiced_orders table
    # Upload Csv
    And Operator go to menu Finance Tools -> Invoiced Orders Search
    When Search Invoiced Orders page is loaded
    And Operator upload a CSV file with below order ids on Invoiced Orders Search Page
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verifies the order count is correctly displayed as 1
    Then Operator verifies below tracking ID(s) and creation time is displayed
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator clicks Refresh button
    Then Operator verifies below tracking ID(s) and creation time is displayed
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator clicks Go Back To Filter button
     # Search by tracking_id
    And Operator clicks in Enter Tracking ID(s) tab
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Invoiced Orders Search Page
    And Operator clicks Search Invoiced Order button
    Then Operator verifies below tracking ID(s) and creation time is displayed
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator clicks Refresh button
    Then Operator verifies below tracking ID(s) and creation time is displayed
      | {KEY_CREATED_ORDER_TRACKING_ID} |

  Scenario: Search by Uploading empty CSV file (uid:3c8f9e4e-ae03-4054-9b4e-b1fecd83bdc5)
    Given Operator go to menu Finance Tools -> Invoiced Orders Search
    When Search Invoiced Orders page is loaded
    Then Operator uploads an empty CSV on Invoiced Orders Search Page CSV and verifies error message as below:
      | top    | Failed to upload CSV file |
      | bottom | Empty csv file detected.  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op