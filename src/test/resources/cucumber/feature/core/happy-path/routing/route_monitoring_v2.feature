Feature: Route Monitoring V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @coverage-operator-auto @coverage-auto @step-done @happy-path
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Delivery (uid:45e0b063-386d-4e9a-aa55-6258b968fe2e)
    Given Shipper creates multiple "2 Parcel" orders
    And Operator tags order with tag name = "PRIOR" from Order Tag Management page
    And Operator global inbound the order
    And Operator creates a driver route
    And Operator adds order to "Delivery" route
    And UI_LOAD_ROUTE_MONITORING_V2_PAGE
    And Verify that "column 'Pending Priority Parcels' = 2"
    When Operator clicks on "number" inside "Pending Priority Parcels" column
    Then Verify that "Pending Priority" pop up modal is showing correct total parcels "(Pending Priority Deliveries = 2)"
    And Verify that "parcel" has correct details
      """
      - Tracking Id
      - Customer Name
      - Order Tags = PRIOR
      - Address
      """
    When Operator clicks on "each tracking id link"
    Then Verify that Operator is redirected to "Edit Order" page
    And Verify that "search function is working on each column, Search by Tracking Id, Customer Name, Order Tags & Time Window, Address"

  @coverage-operator-auto @coverage-auto @step-done @happy-path
  Scenario: Operator Filter Route Monitoring Data And Checks Pending Priority Parcels - Pickup (uid:d90eb775-2b4b-42aa-96c7-9a090d49cf64)
    Given Shipper creates multiple "2 Return" orders
    And Operator tags order with tag name = "PRIOR" from Order Tag Management page
    And Operator creates a driver route
    And Operator adds order to "Pickup" route
    And UI_LOAD_ROUTE_MONITORING_V2_PAGE
    And Verify that "column 'Pending Priority Parcels' = 2"
    When Operator clicks on "number" inside "Pending Priority Parcels" column
    Then Verify that "Pending Priority" pop up modal is showing correct total parcels "(Pending Priority Pickups = 2)"
    And Verify that "parcel" has correct details
      """
      - Tracking Id
      - Customer Name
      - Order Tags = PRIOR
      - Address
      """
    When Operator clicks on "each tracking id link"
    Then Verify that Operator is redirected to "Edit Order" page
    And Verify that "search function is working on each column, Search by Tracking Id, Customer Name, Order Tags & Time Window, Address"

  @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Filter Route Monitoring Data And Checks Invalid Failed Waypoints - Pickup, Delivery & Reservation Under the Same Route (uid:0aa5f6f9-0176-4fde-a2f1-01087f4a037d)
    Given Shipper creates a "Return" order
    And Operator creates a driver route
    And Operator adds order to "Pickup" route
    And Driver fails the "Pickup" "with Invalid Failure Reason "
      """
      pickup-failure-reason-id=112
      pickup-failure-reason-string=Cannot Make It (CMI)
      """
    When Shipper creates a "Parcel" order
    And Operator global inbound the order
    And Operator adds order to "Delivery" route
    And Driver fails the "Delivery" "with Invalid Failure Reason"
      """
      delivery-failure-reason-id=11
      delivery-failure-reason-string=I had insufficient time to complete all my deliveries
      """
    Given Shipper creates a reservation
    And Operator adds reservation to route
    And Driver fails the "reservation" "with Invalid Failure Reason"
      """
      reservation-failure-reason-id=63
      reservation-failure-reason-string=Cannot Make It (CMI)
      """
    And UI_LOAD_ROUTE_MONITORING_V2_PAGE
    And Verify that "column 'Invalid Failed WP' = 3"
    When Operator clicks on "number" inside "Invalid Failed WP" column
    Then Verify that "Invalid Failed WP" pop up modal is showing correct total parcels "( 'Invalid Failed Deliveries' = 1 & 'Invalid Failed Pickups' = 1 & 'Invalid Failed Reservations' = 1)"
    And Verify that "parcel" has correct details
      """
      - Tracking Id
      - Customer Name
      - Order Tags
      - Address
      """
    And Verify that "search function is working on each column : Search by Tracking Id, Customer Name, Order Tags & Time Window, Address"
    And Verify that "reservation" has correct details
      """
      - Reservation Id
      - Pickup Name
      - Timeslot
      - Address
      - Contact
      """
    And Verify that "search function is working on each column : Search by Reservation Id, Pickup Name, Timeslot, Address, Contact"
    When Operator clicks on "each tracking id link"
    Then Verify that Operator is redirected to "Edit Order" page
    When Operator clicks on "each Reservation Id link"
    Then Verify that Operator is redirected to "Shipper Pickups" page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op