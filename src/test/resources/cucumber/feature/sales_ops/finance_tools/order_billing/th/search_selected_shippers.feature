@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsTH @OrderBillingTH
Feature: Order Billing
  "ALL": All orders (1 very big file, takes long time to generate)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Thailand"
    And API Operator whitelist email "{order-billing-email}"
    And operator marks gmail messages as read

  Scenario: Generate "ALL" Success Billing Report - Selected Shipper - TH (uid:5518868f-0065-49b1-9478-fca4ff50105c)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-noDiscount-country-default-3-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-sop-normal-noDiscount-country-default-3-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-SSB-From","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "11/1 Soi Samsen 3 Samsen Road, Wat Samphraya, Phranakhon","address2": "","country": "TH","postcode": "10200"}},"to": {"name": "QA-SO-Test-SSB-To","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1": "10 Soi Siri Ammat, Boonsiri Road San Chao Pho Sua, Phanakon","address2": "","country": "TH","postcode": "10200"}},"parcel_job":{"cash_on_delivery": 40,"insured_value": 85, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator force succeed created order
    Given Operator go to menu Finance Tools -> Order Billing
    Then Operator verifies "{default-csv-template}" is selected in Customized CSV File Template
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                            |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                            |
      | shipper         | {shipper-sop-normal-noDiscount-country-default-3-legacy-id} |
      | generateFile    | All orders (1 very big file, takes long time to generate)   |
      | emailAddress    | {order-billing-email}                                       |
      | csvFileTemplate | {csv-template}                                              |
    Then Operator gets 'Completed' price order details from the billing_qa_gl.priced_orders table
    And Finance Operator waits for "{order-billing-wait-time}" seconds
    And Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator gets the success billing report entries
    Then Operator verifies the header using data {default-ssb-headers}
    Then Operator verifies the priced order details in the body

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op