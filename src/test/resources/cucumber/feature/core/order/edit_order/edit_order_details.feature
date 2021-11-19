@OperatorV2 @Core @Order @EditOrder @EditOrderDetails
Feature: Edit Order Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Change Delivery Verification Method from Edit Order - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"<delivery_verification_mode>","is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator set Delivery Verification Required to "<new_delivery_verification_mode>" on on Edit order page
    Then Operator verify Delivery Verification Required is "<new_delivery_verification_mode>" on on Edit order page
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE DELIVERY VERIFICATION |
    When DB Operator get shipper ref metadata of created order
    Then DB Operator make sure shipper ref metadata contains values:
      | deliveryVerificationMode | <new_delivery_verification_mode> |
    When DB Operator get order delivery verifications of created order
    Then DB Operator make sure order delivery verifications contains values:
      | deliveryVerificationMode | <new_delivery_verification_mode> |

    Examples:
      | Note        | delivery_verification_mode | new_delivery_verification_mode | hiptest-uid                              |
      | OTP to NONE | OTP                        | None                           | uid:faa86019-64a6-4755-aa51-252d4fe2dc38 |
      | NONE to OTP | NONE                       | OTP                            | uid:f4cda665-1173-49a8-83ec-e261e69ae554 |

  Scenario: Operator Edit Pickup Details on Edit Order page (uid:bde3592e-843f-4a99-9a60-66c46c4b257c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Pickup -> Edit Pickup Details on Edit Order page
    And Operator update Pickup Details on Edit Order Page
      | senderName     | test sender name                       |
      | senderContact  | +9727894434                            |
      | senderEmail    | test@mail.com                          |
      | internalNotes  | test internalNotes                     |
      | pickupDate     | {gradle-next-2-working-day-yyyy-MM-dd} |
      | pickupTimeslot | 9AM - 12PM                             |
      | country        | Singapore                              |
      | city           | Singapore                              |
      | address1       | 116 Keng Lee Rd                        |
      | address2       | 15                                     |
      | postalCode     | 308402                                 |
    Then Operator verify Pickup "UPDATE ADDRESS" order event description on Edit order page
    And Operator verify Pickup "UPDATE CONTACT INFORMATION" order event description on Edit order page
#    And Operator verify Pickup "UPDATE SLA" order event description on Edit order page
    And Operator verifies Pickup Details are updated on Edit Order Page
    And Operator verifies Pickup Transaction is updated on Edit Order Page
    And DB Operator verifies pickup info is updated in order record
    And DB Operator verify the order_events record exists for the created order with type:
      | 17 |
      | 11 |
      | 12 |
    And DB Operator verify Pickup '17' order_events record for the created order
    And DB Operator verify Pickup transaction record is updated for the created order
    And DB Operator verify Pickup waypoint record is updated

  Scenario: Operator Edit Delivery Details on Edit Order page (uid:e17ae476-5ccb-436e-b256-21ab3443a2ee)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> Edit Delivery Details on Edit Order page
    And API Operator get order details
    And Operator update Delivery Details on Edit Order Page
      | recipientName    | test sender name                       |
      | recipientContact | +9727894434                            |
      | recipientEmail   | test@mail.com                          |
      | internalNotes    | test internalNotes                     |
      | deliveryDate     | {gradle-next-2-working-day-yyyy-MM-dd} |
      | deliveryTimeslot | 9AM - 12PM                             |
      | country          | Singapore                              |
      | city             | Singapore                              |
      | address1         | 116 Keng Lee Rd                        |
      | address2         | 15                                     |
      | postalCode       | 308402                                 |
    Then Operator verifies that success toast displayed:
      | top                | Delivery Details Updated |
      | waitUntilInvisible | true                     |
    Then Operator verify Delivery "UPDATE ADDRESS" order event description on Edit order page
    And Operator verify Delivery "UPDATE CONTACT INFORMATION" order event description on Edit order page
#    And Operator verify Delivery "UPDATE SLA" order event description on Edit order page
    And Operator verifies Delivery Details are updated on Edit Order Page
    And Operator verifies Delivery Transaction is updated on Edit Order Page
    And DB Operator verifies delivery info is updated in order record
    And DB Operator verify the order_events record exists for the created order with type:
      | 17 |
      | 11 |
      | 12 |
    And DB Operator verify Delivery '17' order_events record for the created order
    And DB Operator verify Delivery transaction record of order "KEY_CREATED_ORDER_ID":
      | address1  | {KEY_CREATED_ORDER.toAddress1}                  |
      | address2  | {KEY_CREATED_ORDER.toAddress2}                  |
      | postcode  | {KEY_CREATED_ORDER.toPostcode}                  |
      | city      | {KEY_CREATED_ORDER.toCity}                      |
      | country   | {KEY_CREATED_ORDER.toCountry}                   |
      | name      | {KEY_CREATED_ORDER.toName}                      |
      | email     | {KEY_CREATED_ORDER.toEmail}                     |
      | contact   | {KEY_CREATED_ORDER.toContact}                   |
      | startTime | {gradle-next-2-working-day-yyyy-MM-dd} 09:00:00 |
      | endTime   | {gradle-next-4-working-day-yyyy-MM-dd} 12:00:00 |
    And DB Operator verify Delivery waypoint record is updated

  Scenario: Operator Edit Instructions of an Order on Edit Order Page (uid:a5de8db3-f5a2-4bda-8984-96794753d26c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator click Order Settings -> Edit Instructions on Edit Order page
    When Operator enter Order Instructions on Edit Order page:
      | pickupInstruction   | new pickup instruction   |
      | deliveryInstruction | new delivery instruction |
    When Operator verify Order Instructions are updated on Edit Order Page
    And DB Operator verify order_events record for the created order:
      | type | 14 |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE INSTRUCTION |

  Scenario: Operator Edit Priority Level (uid:849b151c-967b-4a20-afba-73fc9334570d)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Priority Level to "2" on Edit Order page
    Then Operator verify Delivery Priority Level is "2" on Edit Order page
    And DB Operator verify next Delivery transaction values are updated for the created order:
      | priorityLevel | 2 |
    And DB Operator verify next Pickup transaction values are updated for the created order:
      | priorityLevel | 0 |
    And DB Operator verify order_events record for the created order:
      | type | 17 |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE SLA |

  Scenario: Operator Edit Order Details on Edit Order page (uid:1884a911-4599-4faa-8d63-a9b984f1c989)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Order Details on Edit Order page
    When Operator Edit Order Details on Edit Order page
    Then Operator Edit Order Details on Edit Order page successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
