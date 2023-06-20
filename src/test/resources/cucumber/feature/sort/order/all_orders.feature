@Sort @AllOrdersSort
Feature: All Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedSortCode
  Scenario: Print AWB - Delivery Sort Code Exist (uid:c6fb37da-e61c-4fbf-940c-224877a5319a)
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And API Operator has created a sort code using "{default-postcode}" postcode
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "to":{"name":"Tristania Siagian","phone_number":"+60377322226","email":"ninjavan.qa3@gmail.com","address":{"country":"{country-code}","address1":"Lot A-12-G Block A","address2":"Glomac Damansara No 699","postcode":"{default-postcode}"}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click View/Print -> Print Airway Bill on Edit Order page
    Then Operator verifies that there will be a toast of successfully downloaded airway bill

  Scenario: Print AWB - Delivery Sort Code Does Not Exist (uid:0bc031f9-83a1-4e85-b78c-627e6535c2bc)
    Given Operator go to menu Routing -> Last Mile and RTS Zones
    And Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click View/Print -> Print Airway Bill on Edit Order page
    Then Operator verifies that there will be a toast of successfully downloaded airway bill

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
