@OperatorV2 @Recovery @OperatorV2Part2 @RecoveryTicketsScanning @Saas
Feature: Recovery Tickets Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator creates new <Note> ticket (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Recovery -> Recovery Tickets Scanning
    When Operator fills all the field on Recovery Tickets Scanning Page and clicks on enter with data bellow:
      | recoveryTicketsScanning | { "ticketType":"<ticketType>", "investigatingGroup":"<investigatingGroup>", "investigatingHub" : "<investigatingHub>", "entrySource":"<entrySource>", "comment":"<comment>", "ticketSubtype":"<ticketSubtype>", "trackingId":"<trackingId>" } |
    Then Operator verifies the details of the ticket on Recovery Tickets Scanning Page is correct
    When Operator clicks on Create Ticket Button on Recovery Tickets Scanning Page
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator clicks on Load Selection Button on Recovery Tickets Page and enters the Tracking ID
    Then Operator verifies the created ticket on Recovery Tickets Page is made
    Examples:
      | Note    | hiptest-uid                              | ticketType | investigatingGroup | investigatingHub | entrySource        | comment      | ticketSubtype      | trackingId      |
      | DAMAGED | uid:7193f95d-5c4a-48a8-90e1-3de847648b5e | DAMAGED    | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE | IMPROPER PACKAGING | {{tracking_id}} |
      | MISSING | uid:ae3b88fa-a9eb-4ea2-96b9-e0880d9e3c29 | MISSING    | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE |                    | {{tracking_id}} |
#      | SELF COLLECTION  | uid:f70f75ff-7c8d-40d1-b292-39c8576ac234 | SELF COLLECTION  | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE |                    | {{tracking_id}} |
#      | PARCEL EXCEPTION | uid:887e49fa-9806-4c92-bd14-856849e42f39 | PARCEL EXCEPTION | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE | INACCURATE ADDRESS | {{tracking_id}} |
#      | SHIPPER ISSUE    | uid:5e1ac33b-2ec2-49e1-8054-f44f50faeab1 | SHIPPER ISSUE    | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE | DUPLICATE PARCEL   | {{tracking_id}} |

  Scenario Outline: Operator creates new ticket with invalid tracking ID and clicks cancel (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets Scanning
    When Operator fills all the field on Recovery Tickets Scanning Page with invalid tracking ID and clicks on enter with data bellow:
      | recoveryTicketsScanning | { "ticketType":"<ticketType>", "investigatingGroup":"<investigatingGroup>", "investigatingHub" : "<investigatingHub>", "entrySource":"<entrySource>", "comment":"<comment>", "ticketSubtype":"<ticketSubtype>", "trackingId":"<trackingId>" } |
    Then Operator verifies the dialogue shown on Recovery Ticket Scanning Page and clicks on cancel button
    And Operator verifies the ticket is not made on Recovery Ticket Scanning Page
    Examples:
      | Note             | hiptest-uid                              | ticketType       | investigatingGroup | investigatingHub | entrySource        | comment      | ticketSubtype      | trackingId      |
      | DAMAGED          | uid:a1557ceb-b4b9-4770-a121-22ab71fd9973 | DAMAGED          | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE | IMPROPER PACKAGING | {{tracking_id}} |
      | MISSING          | uid:b702687c-fb47-4d6d-bfc5-ba37dee22021 | MISSING          | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE |                    | {{tracking_id}} |
#      | SELF COLLECTION  | uid:eb6d10f0-6fbe-42de-b6d3-d041d7e4bdbe | SELF COLLECTION  | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE |                    | {{tracking_id}} |
      | PARCEL EXCEPTION | uid:bddb1050-6012-486d-a50e-e49fe9c70e83 | PARCEL EXCEPTION | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE | INACCURATE ADDRESS | {{tracking_id}} |
      | SHIPPER ISSUE    | uid:b6372f73-4651-4981-b282-76269fe11973 | SHIPPER ISSUE    | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE | DUPLICATE PARCEL   | {{tracking_id}} |

  Scenario Outline: Operator creates new ticket with invalid tracking ID and clicks save (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets Scanning
    When Operator fills all the field on Recovery Tickets Scanning Page with invalid tracking ID and clicks on enter with data bellow:
      | recoveryTicketsScanning | { "ticketType":"<ticketType>", "investigatingGroup":"<investigatingGroup>", "investigatingHub" : "<investigatingHub>", "entrySource":"<entrySource>", "comment":"<comment>", "ticketSubtype":"<ticketSubtype>", "trackingId":"<trackingId>" } |
    Then Operator verifies the dialogue shown on Recovery Ticket Scanning Page and clicks on save button
    Then Operator verifies the details of the ticket on Recovery Tickets Scanning Page is correct
    When Operator clicks on Create Ticket Button on Recovery Tickets Scanning Page
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator clicks on Load Selection Button on Recovery Tickets Page and enters the Tracking ID
    Then Operator verifies the created ticket on Recovery Tickets Page is made
    Examples:
      | Note             | hiptest-uid                              | ticketType       | investigatingGroup | investigatingHub | entrySource        | comment      | ticketSubtype      | trackingId      |
      | DAMAGED          | uid:bc48c070-f72e-46c7-bc05-98e0e922083d | DAMAGED          | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE | IMPROPER PACKAGING | {{tracking_id}} |
      | MISSING          | uid:e87e3b80-16a5-4e44-9ba6-8fa4c229fc2f | MISSING          | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE |                    | {{tracking_id}} |
#      | SELF COLLECTION  | uid:28af7372-6195-4542-87a6-eabe68166334 | SELF COLLECTION  | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE |                    | {{tracking_id}} |
      | PARCEL EXCEPTION | uid:11ee4b05-d6b5-4bda-bc2f-e7c9a1fca529 | PARCEL EXCEPTION | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE | INACCURATE ADDRESS | {{tracking_id}} |
      | SHIPPER ISSUE    | uid:b18091a5-8fea-45fd-b8af-4684cd7cbf90 | SHIPPER ISSUE    | Fleet (First Mile) | {hub-name}       | CUSTOMER COMPLAINT | TEST PURPOSE | DUPLICATE PARCEL   | {{tracking_id}} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
