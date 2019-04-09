@OperatorV2 @OperatorV2Part1 @OutboundAndRouteLoadMonitoring @Saas
Feature: Outbound Monitoring
  Note: Please complete this scenarios below. Some of the steps below already implemented,
  so no need to create your own implementation. Implement the Java code only for the line that says
  "Implement this step:". Will give you a briefing later so you can have a sense about how our automation project works.

  Estimation Time: 6 hours

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Should be able to download CSV file and verifies the file contains all scanned orders with correct info
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest

    # Implement this step: When Operator do "Scan Barcode" for all created orders on Implemented Manifest page
    # Note: To get the list of created order, use this code below on this step Java implementation:
    # List<co.nvqa.commons.model.core.Order> trackingIds = get(KEY_CREATED_ORDER);

    # Implement this step: When Operator clicks "Download CSV File" on Implanted Manifest

    # Implement this step: Then Operator verifies the file is downloaded successfully and contains all scanned orders with correct info
    # Verify all order per line is contains correct information.


  Scenario: Operator Should be able to scan all created orders
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest

    # Implement this step: When Operator do "Scan Barcode" for all created orders on Implemented Manifest page
    # Note: To get the list of created order, use this code below on this step Java implementation:
    # List<co.nvqa.commons.model.core.Order> trackingIds = get(KEY_CREATED_ORDER);

    # Implement this step: Then Operator verifies all scanned orders is listed on Manifest table and the info is correct
    # Note, please verify this:
    # - Tracking ID
    # - Destination is the same as order.fromAddress1 + order.fromAddress2
    # - Addressee is the same as order.fromName


  Scenario: Operator Should be able to scan all created orders and then remove all scanned orders by using "Remove order by scan"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest

    # Implement this step: When Operator do "Scan Barcode" for all created orders on Implemented Manifest page

    # Implement this step: When Operator do "Remove order by Scan" for all created orders on Implemented Manifest page

    # Implement this step: Then Operator verifies all scanned orders is removed from the Manifest table

  Scenario: Operator Should be able to scan all created orders and then remove all scanned orders by using "Remove All" button
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest

    # Implement this step: When Operator do "Scan Barcode" for all created orders on Implemented Manifest page

    # Implement this step: When Operator clicks "Remove All" button on Implemented Manifest page

    # Implement this step: Then Operator verifies all scanned orders is removed from the Manifest table

  Scenario: Operator Should be able to scan all created orders and then remove all scanned orders by using "Actions X" button on Manifest table
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest

    # Implement this step: When Operator do "Scan Barcode" for all created orders on Implemented Manifest page

    # Implement this step: When Operator clicks "Actions X" button on Manifest table for all created orders on Implemented Manifest page

    # Implement this step: Then Operator verifies all scanned orders is removed from the Manifest table


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
