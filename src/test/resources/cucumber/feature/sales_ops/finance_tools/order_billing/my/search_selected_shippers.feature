@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsMY @OrderBillingMY
Feature: Order Billing
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Malaysia"
    And API Operator whitelist email "{order-billing-email}"
    Given API Gmail - Connect to "{order-billing-email}" inbox using password "{order-billing-email-password}"
    And API Gmail - Operator marks all gmail messages as read

  Scenario: Generate "SHIPPER" Success Billing Report - Selected Shipper - MY (uid:0691e4cc-60f6-4568-b6ab-102a9f88f17b)
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-sop-normal-noDiscount-country-default-3-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-sop-normal-noDiscount-country-default-3-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "15, Jalan Raja Laut","country": "MY","postcode": "50530"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1":"Jalan Paya Datok / Simpang","address2":"Kampung Tepat, 78000 Alor Gajah, Melaka","area":"Damansara Perdana","city":"Petaling Jaya","state":"Selangor","country":"MY","postcode":"78000","latitude":3.1312045,"longitude":101.6707697}},"parcel_job":{"cash_on_delivery": 40,"insured_value": 85, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]" with granular status "PENDING_PICKUP"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "true"
    Given Operator go to menu Finance Tools -> Order Billing
    Then Operator verifies "{default-csv-template}" is selected in Customized CSV File Template
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                            |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                            |
      | shipper         | {shipper-sop-normal-noDiscount-country-default-3-legacy-id} |
      | generateFile    | Orders consolidated by shipper (1 file per shipper)         |
      | emailAddress    | {order-billing-email}                                       |
      | csvFileTemplate | {csv-template}                                              |
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and validates received order billing email
    Then Operator verifies zip is attached with one CSV file in received SSB email
    Then Operator gets the success billing report entries from the zip file
    Then Operator verifies the SSB header using data {default-ssb-headers}
    Then DB Billing - Operator gets price order details from the billing_qa_gl.priced_orders table for order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with status "Completed"
    Then Operator verifies the priced order details in the SSB CSV body for tracking Id "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
