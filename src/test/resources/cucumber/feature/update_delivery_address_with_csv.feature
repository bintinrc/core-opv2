@OperatorV2 @OperatorV2Part1 @UpdateDeliveryAddressWithCSV
Feature: Update Delivery Address with CSV

  @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless @Debug
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk update order delivery address with CSV - Valid Order Status
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

  Scenario: Bulk update order delivery address with CSV - Empty File
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery address of created orders on Update Delivery Address with CSV page
    Then Toast "No valid orders found, please check your file" is displayed

  Scenario: Bulk update order delivery address with CSV - Invalid Order/Format
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery addresses of given orders on Update Delivery Address with CSV page:
      | SOMEINVALIDTRACKINGID |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | SOMEINVALIDTRACKINGID | Invalid tracking Id |

  Scenario: Bulk update order delivery address with CSV - Partial
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

  Scenario: Bulk update order delivery address with CSV - Empty compulsory fields
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Update Delivery Address with CSV
    When Operator update delivery addresses of given order with empty value on Update Delivery Address with CSV page:
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify validation statuses on Update Delivery Address with CSV page:
      | trackingId                      | status                                                                                                                                                                                           |
      | {KEY_CREATED_ORDER_TRACKING_ID} | Require to fill in to.name, to.email, to.phone_number, to.address.address1, to.address.address2, to.address.postcode, to.address.city, to.address.country, to.address.state, to.address.district |


  @KillBrowser @ShouldAlwaysRun @Debug
  Scenario: Kill Browser
    Given no-op
