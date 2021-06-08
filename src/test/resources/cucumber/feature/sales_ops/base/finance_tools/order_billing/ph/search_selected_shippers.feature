@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsPH @OrderBillingPH
Feature: Order Billing
  "ALL": All orders (1 very big file, takes long time to generate)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Philippines"
    And API Operator whitelist email "{order-billing-email}"
    And operator marks gmail messages as read


  @KillBrowser
  Scenario: Generate "ALL" Success Billing Report - Selected Shipper - PH (uid:36f50aa0-9b63-4c6b-a12d-6fab2589b706)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-noDiscount-country-default-3-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-sop-normal-noDiscount-country-default-3-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "Quezon Ave, Santa Cruz, 4009 Laguna, Philippines","address2": "","country": "PH","postcode": "4009"}},"to": {"name": "QA-SO-Test-To","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1": "Emilio Aguinaldo Highway, By Pass Road, Tubuan 2, Silang, 4118 Cavite, Philippines","address2": "","country": "PH","postcode": "4118"}},"parcel_job":{"cash_on_delivery": 40,"insured_value": 85, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                            |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                            |
      | shipper         | {shipper-sop-normal-noDiscount-country-default-3-legacy-id} |
      | generateFile    | All orders (1 very big file, takes long time to generate)   |
      | emailAddress    | {order-billing-email}                                       |
      | csvFileTemplate | 4 - PH Default SSB Template                                 |
    Then Operator gets 'Completed' price order details from the billing_qa_gl.priced_orders table
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Legacy Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Service Type" | "Service Level" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body

#  billing
#https://storage.googleapis.com/storage-qa.ninjavan.co/job/billing-java-job/ssb/AUTOMATION-EDITED-2021-06-07-2021-06-07-ph-1623032559888.zip
#"12891","QA-SO-Normal-NoDiscount-COD-DEF-INS-DEF-71445","QA-SO-Normal-NoDiscount-COD-DEF-INS-DEF-71445","NVPHA03840KPLZNN9K","KPLZNN9K","Completed","QA-SO-Test-To","DELIVERY_THREE_DAYS_ANYTIME","2","Parcel","STANDARD","SMALL","0.4","2021-06-07 10:22:01","2021-06-07","","MM-MNL","-","","","","Emilio Aguinaldo Highway, By Pass Road, Tubuan 2, Silang, 4118 Cavite, Philippines  PH 4118","4118","GMA-CAV","-","3.6","40.00","0.4","85.00","1.7","0.4","0.786","7.336","71445","2","2021-06-07"
#"12891","QA-SO-Normal-NoDiscount-COD-DEF-INS-DEF-71445","QA-SO-Normal-NoDiscount-COD-DEF-INS-DEF-71445","NVPHA03840KPLZLLGO","KPLZLLGO","Completed","QA-SO-Test-To","DELIVERY_THREE_DAYS_ANYTIME","2","Parcel","STANDARD","SMALL","0.4","2021-06-07 10:20:25","2021-06-07","","MM-MNL","-","","","","Emilio Aguinaldo Highway, By Pass Road, Tubuan 2, Silang, 4118 Cavite, Philippines  PH 4118","4118","GMA-CAV","-","3.6","40.00","0.4","85.00","1.7","0.4","0.786","7.336","71445","2","2021-06-07"
#  dwh
#url: https://cdn-qa.ninjavan.co/ph/billings/AUTOMATION-EDITED-2021-06-07-2021-06-07-ph-1623032667478.zip
#"12891","QA-SO-Normal-NoDiscount-COD-DEF-INS-DEF-71445","QA-SO-Normal-NoDiscount-COD-DEF-INS-DEF-71445","NVPHA03840KPLZLLGO","KPLZLLGO","Completed","QA-SO-Test-To","DELIVERY_THREE_DAYS_ANYTIME","2","SMALL","0.4","2021-06-07 10:20:25","2021-06-07","","MM-MNL","-","Cavite","","","Emilio Aguinaldo Highway, By Pass Road, Tubuan 2, Silang, 4118 Cavite, Philippines  PH 4118","4118","GMA-CAV","-","3.60","40.00","0.40","85.00","1.70","0.85","0.79","7.34","71445","2","2021-06-07"
#"12891","QA-SO-Normal-NoDiscount-COD-DEF-INS-DEF-71445","QA-SO-Normal-NoDiscount-COD-DEF-INS-DEF-71445","NVPHA03840KPLZNN9K","KPLZNN9K","Completed","QA-SO-Test-To","DELIVERY_THREE_DAYS_ANYTIME","2","SMALL","0.4","2021-06-07 10:22:01","2021-06-07","","MM-MNL","-","Cavite","","","Emilio Aguinaldo Highway, By Pass Road, Tubuan 2, Silang, 4118 Cavite, Philippines  PH 4118","4118","GMA-CAV","-","3.60","40.00","0.40","85.00","1.70","0.85","0.79","7.34","71445","2","2021-06-07"