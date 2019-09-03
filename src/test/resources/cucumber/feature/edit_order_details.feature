@OperatorV2 @OperatorV2Part2 @EditOrder @Saas @test2
Feature: Edit Oder Details Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  @CloseNewWindows @DeleteOrArchiveRoute
#  Scenario: Operator Edit Pickup Details on Edit Order page
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
#      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    When Operator go to menu Order -> All Orders
#    Then Operator find order on All Orders page using this criteria below:
#      | category    | Tracking / Stamp ID           |
#      | searchLogic | contains                      |
#      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
#    When Operator switch to Edit Order's window
#    And Operator click Pickup -> Edit Pickup Details on Edit Order page
#    And Operator update Pickup Details on Edit Order Page
#      | senderName        | test sender name         |
#      | senderContact     | +9727894434              |
#      | senderEmail       | test@mail.com            |
#      | internalNotes     | test internalNotes       |
#      | pickupDate        | {{next-1-day-yyyy-MM-dd}}|
#      | pickupTimeslot    | 9AM - 12PM               |
#      | country           | Singapore                |
#      | city              | Singapore                |
#      | address1          | 116 Keng Lee Rd          |
#      | address2          | 15                       |
#      | postalCode        | 308402                   |
#    Then Operator verify Pickup "UPDATE ADDRESS" order event description on Edit order page
#    And Operator verify Pickup "UPDATE CONTACT INFORMATION" order event description on Edit order page
#    And Operator verify Pickup "UPDATE SLA" order event description on Edit order page
#    And Operator verify Pickup "VERIFY ADDRESS" order event description on Edit order page
#    And Operator verifies Pickup Details are updated on Edit Order Page
#    And Operator verifies "PICKUP" Transaction is updated on Edit Order Page
#    And DB Operator verifies pickup info is updated in order record
#    And DB Operator verify the order_events record exists for the created order with type:
#    | 7    |
#    | 17   |
#    | 11   |
#    | 12   |
#    And DB Operator verify Pickup '17' order_events record for the created order
#    And DB Operator verify Pickup transaction record is updated for the created order
#    And DB Operator verify Pickup waypoint record is updated

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Edit Delivery Details on Edit Order page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    And Operator click Delivery -> Edit Delivery Details on Edit Order page
    And Operator update Delivery Details on Edit Order Page
      | recipientName        | test sender name         |
      | recipientContact     | +9727894434              |
      | recipientEmail       | test@mail.com            |
      | internalNotes        | test internalNotes       |
      | deliveryDate         | {{next-1-day-yyyy-MM-dd}}|
      | deliveryTimeslot     | 9AM - 12PM               |
      | country              | Singapore                |
      | city                 | Singapore                |
      | address1             | 116 Keng Lee Rd          |
      | address2             | 15                       |
      | postalCode           | 308402                   |
    Then Operator verify Delivery "UPDATE ADDRESS" order event description on Edit order page
    And Operator verify Delivery "UPDATE CONTACT INFORMATION" order event description on Edit order page
    And Operator verify Delivery "UPDATE SLA" order event description on Edit order page
    And Operator verify Delivery "VERIFY ADDRESS" order event description on Edit order page
    And Operator verifies Delivery Details are updated on Edit Order Page
    And Operator verifies Delivery Transaction is updated on Edit Order Page
    And DB Operator verifies delivery info is updated in order record
    And DB Operator verify the order_events record exists for the created order with type:
      | 7    |
      | 17   |
      | 11   |
      | 12   |
    And DB Operator verify Delivery '17' order_events record for the created order
    And DB Operator verify Delivery transaction record is updated for the created order
    And DB Operator verify Delivery waypoint record is updated

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op