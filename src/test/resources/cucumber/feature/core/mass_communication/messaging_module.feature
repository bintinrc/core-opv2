@OperatorV2 @Core @MassCommunications @MessagingModule
Feature: Messaging Module

  @LaunchBrowser
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Upload Mass Messaging CSV File and Send Message to Customer (uid:eefe0e93-1ec1-49ca-b97e-feef651a335d)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "from":{ "name":"Sim Sze Kiat", "phone_number":"+6588698632" }, "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Mass Communications -> Messaging Module
    Then Operator upload SMS campaign CSV file
      | tracking_id            | name         | email          | job |
      | GET_FROM_CREATED_ORDER | Sim Sze Kiat | qa@ninjavan.co | Dev |
    When Operator compose SMS with name = "Sim Sze Kiat" and tracking ID = "GET_FROM_CREATED_ORDER"
    Then Operator send SMS

  Scenario: Operator Upload Mass Messaging CSV File with Invalid Data (uid:ade83f54-1287-4da7-bf65-e5263057e226)
    Given Operator go to menu Mass Communications -> Messaging Module
    Then Operator upload SMS campaign CSV file
      | tracking_id       | name         | email          | job |
      | SOMERANDOMTRACKID | Sim Sze Kiat | qa@ninjavan.co | Dev |
    Then Operator continue on invalid dialog
    Then Operator verify sms module page reset

  Scenario: Operator Retrieve SMS Records History with Valid Tracking Id (uid:958dcd89-4e1a-4d27-b030-f56a8ccb88c6)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "from":{ "name":"Sim Sze Kiat", "phone_number":"+6588698632" }, "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Mass Communications -> Messaging Module
    Then op upload sms campaign csv file
        | tracking_id | name         | email          | job |
        | _created_   | Sim Sze Kiat | qa@ninjavan.co |	Dev |
    When op compose sms with data : Sim Sze Kiat, _created_
    Then op send sms
    Then op wait for sms to be processed
    Then op verify that sms sent to phone number _created_ and tracking id +6588698632

  Scenario: Operator Retrieve SMS Records History with Invalid Tracking Id (uid:8d95975d-2b39-4c12-b46d-315a375f8efc)
    Given Operator go to menu Mass Communications -> Messaging Module
    Then Operator verify that tracking ID "SOMERANDOMTRACKINGID" is invalid

  Scenario: Operator Using URL Shortener on SMS Editor (uid:965cd004-a4a9-4871-af7c-1f2a49bd5a56)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "from":{ "name":"Sim Sze Kiat", "phone_number":"+6588698632" }, "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Mass Communications -> Messaging Module
    Then Operator upload SMS campaign CSV file
      | tracking_id            | name         | email          | job |
      | GET_FROM_CREATED_ORDER | Sim Sze Kiat | qa@ninjavan.co | Dev |
    Then Operator compose SMS using URL shortener
    Then Operator verify SMS preview using shortened URL

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
