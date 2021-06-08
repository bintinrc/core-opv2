@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsMY @OrderBillingMY
Feature: Order Billing
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Malaysia"
    And API Operator whitelist email "{order-billing-email}"
    And operator marks gmail messages as read


  @KillBrowser
  Scenario: Generate "SHIPPER" Success Billing Report - Selected Shipper - MY (uid:0691e4cc-60f6-4568-b6ab-102a9f88f17b)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-noDiscount-country-default-3-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-sop-normal-noDiscount-country-default-3-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "15, Jalan Raja Laut","country": "MY","postcode": "50530"}},"to": {"name": "QA-SO-Test-To","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1": "8, Lorong Ang Seng 2, Brickfields","country": "MY","postcode": "50470"}},"parcel_job":{"cash_on_delivery": 40,"insured_value": 85, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Given Operator go to menu Finance Tools -> Order Billing
    Then Operator verifies "{default-csv-template}" is selected in Customized CSV File Template
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                            |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                            |
      | shipper         | {shipper-sop-normal-noDiscount-country-default-3-legacy-id} |
      | generateFile    | Orders consolidated by shipper (1 file per shipper)         |
      | emailAddress    | {order-billing-email}                                       |
      | csvFileTemplate | {csv-template}                                              |
    Then Operator gets 'Completed' price order details from the billing_qa_gl.priced_orders table
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Legacy Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Service Type" | "Service Level" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body