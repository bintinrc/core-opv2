@OperatorV2 @Core @MassCommunications @MessagingModule
Feature: Messaging Module

  @LaunchBrowser
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Upload Mass Messaging CSV File and Send Message to Customer (uid:eefe0e93-1ec1-49ca-b97e-feef651a335d)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Mass Communications -> Messaging Module
    And Operator upload SMS campaign CSV file:
      | tracking_id                     | name                       | email          | job |
      | {KEY_CREATED_ORDER_TRACKING_ID} | {KEY_CREATED_ORDER.toName} | qa@ninjavan.co | Dev |
    Then Operator verifies that "CSV uploaded successfully" success toast message is displayed
    When Operator compose SMS with name = "{KEY_CREATED_ORDER.toName}" and tracking ID = "{KEY_CREATED_ORDER_TRACKING_ID}"
    Then Operator send SMS

  Scenario: Operator Upload Mass Messaging CSV File with Invalid Data (uid:ade83f54-1287-4da7-bf65-e5263057e226)
    When Operator go to menu Mass Communications -> Messaging Module
    And Operator upload SMS campaign CSV file:
      | tracking_id       | name         | email          | job |
      | SOMERANDOMTRACKID | Sim Sze Kiat | qa@ninjavan.co | Dev |
    Then Operator continue on invalid dialog
    And Operator verify sms module page reset

  Scenario: Operator Retrieve SMS Records History with Valid Tracking Id (uid:958dcd89-4e1a-4d27-b030-f56a8ccb88c6)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Mass Communications -> Messaging Module
    And Operator upload SMS campaign CSV file:
      | tracking_id                     | name                       | email          | job |
      | {KEY_CREATED_ORDER_TRACKING_ID} | {KEY_CREATED_ORDER.toName} | qa@ninjavan.co | Dev |
    Then Operator verifies that "CSV uploaded successfully" success toast message is displayed
    When Operator compose SMS with name = "{KEY_CREATED_ORDER.toName}" and tracking ID = "{KEY_CREATED_ORDER_TRACKING_ID}"
    And Operator send SMS
    And Operator wait for sms to be processed
    Then Operator verify that sms sent to phone number "{KEY_CREATED_ORDER.toContact}" and tracking id "{KEY_CREATED_ORDER_TRACKING_ID}"

  Scenario: Operator Retrieve SMS Records History with Invalid Tracking Id (uid:8d95975d-2b39-4c12-b46d-315a375f8efc)
    When Operator go to menu Mass Communications -> Messaging Module
    Then Operator verify that tracking ID "SOMERANDOMTRACKINGID" is invalid

  Scenario: Operator Using URL Shortener on SMS Editor (uid:965cd004-a4a9-4871-af7c-1f2a49bd5a56)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Mass Communications -> Messaging Module
    And Operator upload SMS campaign CSV file:
      | tracking_id                     | name                       | email          | job |
      | {KEY_CREATED_ORDER_TRACKING_ID} | {KEY_CREATED_ORDER.toName} | qa@ninjavan.co | Dev |
    And Operator compose SMS using URL shortener
    Then Operator verify SMS preview using shortened URL

  @KillBrowser
  Scenario: Kill Browser
    Given no-op