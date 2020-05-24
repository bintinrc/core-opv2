@OperatorV2 @MassCommunications @OperatorV2Part2 @MessagingModule @ShouldAlwaysRun
Feature: Messaging Module

  @LaunchBrowser
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator send sms valid data (uid:553ecbc6-44b4-41b4-86b3-4a864a3fede5)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "from":{ "name":"Sim Sze Kiat", "phone_number":"+6588698632" }, "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Mass Communications -> Messaging Module
    Then Operator upload SMS campaign CSV file
      | tracking_id            | name         | email          | job |
      | GET_FROM_CREATED_ORDER | Sim Sze Kiat | qa@ninjavan.co | Dev |
    When Operator compose SMS with name = "Sim Sze Kiat" and tracking ID = "GET_FROM_CREATED_ORDER"
    Then Operator send SMS

  Scenario: Operator send SMS invalid data (uid:4601d827-7a33-4127-92e2-5774fed0c2b0)
    Given Operator go to menu Mass Communications -> Messaging Module
    Then Operator upload SMS campaign CSV file
      | tracking_id       | name         | email          | job |
      | SOMERANDOMTRACKID | Sim Sze Kiat | qa@ninjavan.co | Dev |
    Then Operator continue on invalid dialog
    Then Operator verify sms module page reset

#  Scenario: Check sent SMS history (uid:343d98d0-ce45-41da-8821-077af014a561)
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM |
#      | v4OrderRequest    | { "from":{ "name":"Sim Sze Kiat", "phone_number":"+6588698632" }, "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    Given Operator go to menu Mass Communications -> Messaging Module
#    Then op upload sms campaign csv file
#        | tracking_id | name         | email          | job |
#        | _created_   | Sim Sze Kiat | qa@ninjavan.co |	Dev |
#    When op compose sms with data : Sim Sze Kiat, _created_
#    Then op send sms
#    Then op wait for sms to be processed
#    Then op verify that sms sent to phone number _created_ and tracking id +6588698632

  Scenario: Check SMS history with invalid tracking id (uid:b9f8f867-c428-4d7a-96d9-b1c597571c60)
    Given Operator go to menu Mass Communications -> Messaging Module
    Then Operator verify that tracking ID "SOMERANDOMTRACKINGID" is invalid

  Scenario: Operator using URL shortener on SMS editor (uid:9ba5f071-f569-41d4-81e5-92316cc34bd3)
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
