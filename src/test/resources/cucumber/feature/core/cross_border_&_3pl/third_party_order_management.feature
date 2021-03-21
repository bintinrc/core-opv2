@OperatorV2 @Core @CrossBorderAnd3PL @ThirdPartyOrderManagement
Feature: Third Party Order Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Upload Single Third Party Order (uid:8ab54ea3-9906-4873-9a92-cf36e8dafa0d)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
      |3plShipperName  | {3pl-shipper-name}    |
      |3plShipperId    | {3pl-shipper-id}      |
    Then Operator verify the new mapping is created successfully

  Scenario: Operator Edit Third Party Order (uid:c0683282-fc84-4b36-a6ad-3a77bb0efc0a)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
      |3plShipperName  | {3pl-shipper-name}    |
      |3plShipperId    | {3pl-shipper-id}      |
    Then Operator verify the new mapping is created successfully
    When Operator edit the new mapping with a new data
    Then Operator verify the new edited data is updated successfully


  Scenario: Operator Delete Third Party Order (uid:eacf2d3b-a8c3-4ca2-a7ce-888299d86e29)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
      |3plShipperName  | {3pl-shipper-name}    |
      |3plShipperId    | {3pl-shipper-id}      |
    Then Operator verify the new mapping is created successfully
    When Operator delete the new mapping
    Then Operator verify the new mapping is deleted successfully

  Scenario: Operator Upload Bulk Third Party Orders Successfully (uid:77d98b59-635e-409e-8b0d-9e2aaa0f8a04)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads bulk mapping
    Then Operator verify multiple new mapping is created successfully

  Scenario: Return To Sender (RTS) Third Party Order from All Orders Page - Single RTS (uid:13f3b766-9ef0-4cde-a015-b2780a7cf047)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
      |3plShipperName  | {3pl-shipper-name}    |
      |3plShipperId    | {3pl-shipper-id}      |
    Then Operator verify the new mapping is created successfully
    When API Operator get order details
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator RTS single order on next day on All Orders page
    Then API Operator Verify 3pl Order Info After Rts-ed on next day

  Scenario: Return To Sender (RTS) Third Party Order from All Orders Page - Bulk RTS (uid:795a3464-d569-43f0-b149-35901a46aae8)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads bulk mapping
    Then Operator verify multiple new mapping is created successfully
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    When Operator RTS multiple orders on next day on All Orders page
    Then API Operator verify multiple orders info after 3pl parcels RTS-ed on next day

  @KillBrowser
  Scenario: Kill Browser
    Given no-op