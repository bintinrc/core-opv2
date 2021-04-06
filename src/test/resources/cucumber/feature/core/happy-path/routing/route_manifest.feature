Feature: Route Manifest

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @core @category-core @coverage-operator-auto @coverage-auto @happy-path @step-done
  Scenario: Operator Admin Manifest Force Fail Reservation on Route Manifest (uid:60dec2d6-20a2-4914-98fb-036c7591f834)
    Given Shipper creates a reservation
    And Operator creates a driver route
    And Operator adds reservation to route
    When UI_LOAD_ROUTE_LOGS_PAGE
    When UI_FORCE_ROUTE_MANIFEST "false"
    Then VERIFY_FORCE_FINISH_RESERVATION "Pending/Pending Pickup" "Pending" "Fail" "true" "2 (Fail)"

  @core @category-core @coverage-operator-auto @coverage-auto @happy-path @step-done
  Scenario: Operator Admin Manifest Force Success Reservation on Route Manifest (uid:b23ca49e-c64f-4b37-b327-f979e33615cc)
    Given Shipper creates a reservation
    And Operator creates a driver route
    And Operator adds reservation to route
    When UI_LOAD_ROUTE_LOGS_PAGE
    When UI_FORCE_ROUTE_MANIFEST "true"
    Then VERIFY_FORCE_FINISH_RESERVATION "Pending/Pending Pickup" "Pending" "Success" "true" "1 (Success)"

  @core @category-core @coverage-operator-auto @coverage-auto @step-done @happy-path
  Scenario: Operator Admin Manifest Force Fail Pickup Transaction on Route Manifest (uid:4a9ab106-410e-49a3-bfb4-05ddbb4a670f)
    Given Shipper is subscribed to "'Pickup fail'" Webhook
    And Shipper creates a "Return" order
    And Operator creates a driver route
    And Operator adds order to "pickup transaction" route
    And Driver starts the route
    When UI_LOAD_ROUTE_LOGS_PAGE
    When UI_FORCE_ROUTE_MANIFEST "false"
    Then VERIFY_MANIFEST_FORCE_TRANSACTIONS "Pickup Fail/Pickup Fail" "Van en-route to Pickup" "false" "false" "true" "Pickup fail"

  @core @category-core @coverage-operator-auto @coverage-auto @step-done @happy-path
  Scenario: Operator Admin Manifest Force Success Pickup Transaction on Route Manifest (uid:c5e5ce6c-bf1b-4113-996a-6ab7ae0532de)
    Given Shipper is subscribed to "'En-route to Sorting Hub'" Webhook
    And Shipper creates a "Return" order
    And Operator creates a driver route
    And Operator adds order to "pickup transaction" route
    And Driver starts the route
    When UI_LOAD_ROUTE_LOGS_PAGE
    When UI_FORCE_ROUTE_MANIFEST "true"
    Then VERIFY_MANIFEST_FORCE_TRANSACTIONS "Transit/En-route to Sorting Hub" "Van en-route to Pickup" "true" "false" "false" "En-route to Sorting Hub"

  @core @category-core @coverage-operator-auto @coverage-auto @happy-path @step-done
  Scenario: Operator Admin Manifest Force Fail Delivery Transaction on Route Manifest (uid:4154cb1e-4384-4fea-85fc-edb7bc5705be)
    Given Shipper is subscribed to "'Pending Reschedule'" Webhook
    And Shipper creates a "Parcel" order
    And Operator global inbound the order
    And Operator creates a driver route
    And Driver starts the route
    And Operator adds order to "delivery transaction" route
    When UI_LOAD_ROUTE_LOGS_PAGE
    When UI_FORCE_ROUTE_MANIFEST "false"
    Then VERIFY_MANIFEST_FORCE_TRANSACTIONS "Delivery Fail/Pending Reschedule" "On Vehicle for Delivery" "false" "false" "true" "Pending Reschedule"

  @core @category-core @coverage-operator-auto @coverage-auto @happy-path @step-done
  Scenario: Operator Admin Manifest Force Success Delivery Transaction on Route Manifest (uid:cbfc2a8a-8cb9-455b-a837-0aeb20bf5bf9)
    Given Shipper is subscribed to "'Completed'" Webhook
    And Shipper creates a "Parcel" order
    And Operator global inbound the order
    And Operator creates a driver route
    And Operator adds order to "delivery transaction" route
    And Driver starts the route
    When UI_LOAD_ROUTE_LOGS_PAGE
    When UI_FORCE_ROUTE_MANIFEST "true"
    Then VERIFY_MANIFEST_FORCE_TRANSACTIONS "Completed/Completed" "On Vehicle for Delivery" "true" "true" "false" "Completed"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op