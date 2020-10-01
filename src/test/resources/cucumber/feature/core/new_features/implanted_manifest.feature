@OperatorV2 @Core @NewFeatures @ImplantedManifest
Feature: Implanted Manifest

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Scan All Orders and Download & Verifies CSV File Info on Implanted Manifest Page (uid:cd7f3ec4-3887-4f61-b057-d40ae8a56d5b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub {hub-name} and scan barcodes
    And Operator clicks "Download CSV File" on Implanted Manifest
    Then Operator verifies the file is downloaded successfully and contains all scanned orders with correct info

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page (uid:fb17a389-4f54-45b7-b5f1-c12a830d6aa8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub {hub-name} and scan barcodes
    Then Operator verifies all scanned orders is listed on Manifest table and the info is correct

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page and Remove Scanned Order by Scanning (uid:ca1314b5-661a-4dc7-b144-8b897e4d54b0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub {hub-name} and scan barcodes
    And Operator do "Remove order by Scan" for all created orders on Implanted Manifest page
    Then Operator verifies all scanned orders is removed from the Manifest table

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page and Remove All Scanned Orders by Remove All Button (uid:5284e3dc-43ab-4336-b395-6ee7c46be8ed)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub {hub-name} and scan barcodes
    And Operator clicks "Remove All" button on Implanted Manifest page
    Then Operator verifies all scanned orders is removed from the Manifest table

  Scenario: Operator Scan All Orders to Pickup on Implanted Manifest Page and Remove All Scanned Orders by X Button (uid:b18d3f25-98d9-4d76-bb5b-3c92c8e9bada)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Implanted Manifest
    When Operator creates Manifest for Hub {hub-name} and scan barcodes
    And Operator clicks "Actions X" button on Manifest table for all created orders on Implanted Manifest page
    Then Operator verifies all scanned orders is removed from the Manifest table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
