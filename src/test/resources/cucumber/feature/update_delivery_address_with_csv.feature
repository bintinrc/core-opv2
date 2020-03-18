@OperatorV2 @OperatorV2Part1 @UpdateDeliveryAddressWithCSV
Feature: Update Delivery Address with CSV

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk update order delivery address with CSV - Valid Order Status (uid:b2d8ca6c-e8fd-4ef4-b0fd-04bef13eae1d)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery address of created orders on Update Delivery Address with CSV page
    Then Operator verify updated addresses on Update Delivery Address with CSV page
    When Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator verify addresses were updated successfully on Update Delivery Address with CSV page
    And API Operator get order details
    And Operator verify orders info after address update

  Scenario: Bulk update order delivery address with CSV - Empty File (uid:b6d0d984-f27f-41af-9a04-7226c49e0c58)
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery address of created orders on Update Delivery Address with CSV page
    Then Toast "No valid orders found, please check your file" is displayed

  Scenario: Bulk update order delivery address with CSV - Invalid Order/Format (uid:d1464c96-b61f-40e0-96fd-3f33854c6aed)
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery addresses of given orders on Update Delivery Address with CSV page:
      | SOMEINVALIDTRACKINGID |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | SOMEINVALIDTRACKINGID | Invalid tracking Id |

  Scenario: Bulk update order delivery address with CSV - Partial (uid:d054bee5-b89a-4790-882c-7b1b9893acf2)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery addresses of given orders on Update Delivery Address with CSV page:
      | {KEY_CREATED_ORDER_TRACKING_ID} |
      | SOMEINVALIDTRACKINGID           |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                      | status              |
      | {KEY_CREATED_ORDER_TRACKING_ID} | Pass                |
      | SOMEINVALIDTRACKINGID           | Invalid tracking Id |

  Scenario: Bulk update order delivery address with CSV - Empty compulsory fields (uid:1ec94c3c-4c72-49cd-aa49-0f2203ca32e3)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery addresses of given order with empty value on Update Delivery Address with CSV page:
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                      | status                                                                                                                                                                                           |
      | {KEY_CREATED_ORDER_TRACKING_ID} | Require to fill in to.name, to.email, to.phone_number, to.address.address1, to.address.address2, to.address.postcode, to.address.city, to.address.country, to.address.state, to.address.district |

  Scenario: Bulk update order delivery address with CSV - With technical issues (uid:786c8edb-376b-461d-913d-421d29ccbce6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery address of created orders on Update Delivery Address with CSV page with technical issues
    When Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator closes the modal for unsuccessful update

  Scenario: Bulk update order delivery address with CSV - With technical issues and valid orders (uid:35d9217e-e0e4-4bc3-bf7d-28626b0263c8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2           |
      | generateFromAndTo   | RANDOM      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery address of created orders on Update Delivery Address with CSV page with technical issues and valid orders
    When Operator confirm addresses update on Update Delivery Address with CSV page
    Then Operator closes the modal for unsuccessful update
    And API Operator get order details
    And Operator verify orders with technical issues info after address update

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
