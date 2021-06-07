@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsVN @OrderBillingVN
Feature: Order Billing
  "SHIPPER": Orders consolidated by shipper (1 file per shipper)
  "ALL": All orders (1 very big file, takes long time to generate)
  "SCRIPT": Orders consolidated by script (1 file per script), grouped by shipper within the file
  "AGGREGATED": All orders grouped by shipper and parcel size/weight (1 file, takes long time to generate)

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Vietnam"
    And API Operator whitelist email "{order-billing-email}"
    And operator marks gmail messages as read

  @DeleteOrArchiveRoute @KillBrowser
  Scenario: Generate "SHIPPER" Success Billing Report - Selected Shipper - ID (uid:b62d1ba9-3e88-47ba-b5a4-2103cb27b15a)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-normal-noDiscount-country-default-3-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-sop-normal-noDiscount-country-default-3-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "QA-SO-Test-From","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "11/1 Soi Samsen 3 Samsen Road, Wat Samphraya, Phranakhon","address2": "","country": "TH","postcode": "10200"}},"to": {"name": "QA-SO-Test-To","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1": "10 Soi Siri Ammat, Boonsiri Road San Chao Pho Sua, Phanakon","address2": "","country": "TH","postcode": "10200"}},"parcel_job":{"cash_on_delivery": 40000,"insured_value": 85000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Given Operator go to menu Finance Tools -> Order Billing
    When Operator generates success billings using data below:
      | startDate       | {gradle-current-date-yyyy-MM-dd}                            |
      | endDate         | {gradle-current-date-yyyy-MM-dd}                            |
      | shipper         | {shipper-sop-normal-noDiscount-country-default-3-legacy-id} |
      | generateFile    | Orders consolidated by shipper (1 file per shipper)         |
      | emailAddress    | {order-billing-email}                                       |
      | csvFileTemplate | 7 - VN Default SSB Template                                 |
    Then Operator gets 'Completed' price order details from the billing_qa_gl.priced_orders table
    Then Operator opens Gmail and checks received email
    Then Operator verifies zip is attached with one CSV file in received email
    Then Operator reads the CSV attachment for "Shipper Billing Report"
    Then Operator verifies the header using data below:
      | "Legacy Shipper ID" | "Shipper Name" | "Billing Name" | "Tracking ID" | "Shipper Order Ref" | "Order Granular Status" | "Customer Name" | "Delivery Type Name" | "Delivery Type ID" | "Service Type" | "Service Level" | "Parcel Size ID" | "Parcel Weight" | "Create Time" | "Delivery Date" | "From City" | "From Billing Zone" | "Origin Hub" | "L1 Name" | "L2 Name" | "L3 Name" | "To Address" | "To Postcode" | "To Billing Zone" | "Destination Hub" | "Delivery Fee" | "COD Collected" | "COD Fee" | "Insured Value" | "Insurance Fee" | "Handling Fee" | "GST" | "Total" | "Script ID" | "Script Version" | "Last Calculated Date" |
    Then Operator verifies the priced order details in the body

#url: https://storage.googleapis.com/storage-qa.ninjavan.co/job/billing-java-job/ssb/AUTOMATION-EDITED-2021-06-07-2021-06-07-vn-1623033800147.zip
#"806","QA-SO-Normal-NoDiscount-COD-15000-55-INS-5000-55-70777","QA-SO-Normal-NoDiscount-COD-15000-55-INS-5000-55-70777","AT1VNKPM0BLO8","KPM0BLO8","Completed","QA-SO-Test-To","DELIVERY_THREE_DAYS_ANYTIME","2","Parcel","STANDARD","SMALL","0.4","2021-06-07 09:40:39","2021-06-07","Ho Chi Minh","S-HCMSUB1-THU-DUC","-","","","","10 Soi Siri Ammat, Boonsiri Road San Chao Pho Sua, Phanakon  TH 10200","10200","BKK","-","6","40000.00","22000","85000.00","46750","22000","0","68756.12","70777","1","2021-06-07"
#url: https://cdn-qa.ninjavan.co/vn/billings/AUTOMATION-EDITED-2021-06-07-2021-06-07-vn-1623034070882.zip
#"806","QA-SO-Normal-NoDiscount-COD-15000-55-INS-5000-55-70777","QA-SO-Normal-NoDiscount-COD-15000-55-INS-5000-55-70777","AT1VNKPM0BLO8","KPM0BLO8","Completed","QA-SO-Test-To","DELIVERY_THREE_DAYS_ANYTIME","2",                    "SMALL","0.4","2021-06-07 10:40:39","2021-06-07","Ho Chi Minh","S-HCMSUB1-THU-DUC","-","Bangkok Metropolis | กรุงเทพมหานคร","","","10 Soi Siri Ammat, Boonsiri Road San Chao Pho Sua, Phanakon  TH 10200","10200","BKK","-","6.00","40000.00","22000.00","85000.00","46750.00","0.12","0.00","68756.12","70777","1","2021-06-07"
