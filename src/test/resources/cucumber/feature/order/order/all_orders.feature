@OperatorV2 @Order @Orders @AllOrders
Feature: All Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator download sample CSV file for Find Orders with CSV on All Orders page (uid:477b8e47-4904-4b91-8887-d8337c2eeb58)
    Given Operator go to menu Order -> All Orders
    When Operator download sample CSV file for "Find Orders with CSV" on All Orders page
    Then Operator verify sample CSV file for "Find Orders with CSV" on All Orders page is downloaded successfully

  Scenario: Operator find new pending pickup order by using Specific Search on All Orders page (uid:d577d48b-8fe3-4101-9d51-d62900c8b3ac)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {shipper-v4-prefix} |
    Then Operator filter the result table by Tracking ID on All Orders page and verify order info is correct

  Scenario Outline: Operator find new pending pickup order on All Orders page - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator verify the new pending pickup order is found on All Orders page with correct info
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:990cce84-e25e-4d1f-80ee-0ea529c51fc3 | Normal    | false            |
      | Return | uid:9a73adc4-ad0e-4305-8fd0-c691cd33e892 | Return    | true             |

  Scenario: Operator find multiple orders with CSV on All Orders page (uid:25b77d12-1f86-4543-85ec-859fbbc5375e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info

  Scenario: Operator uploads CSV that contains invalid Tracking ID on All Orders page (uid:d09fa956-7c95-4b48-9cf5-8a5edcfa7aef)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Order -> All Orders
    When Operator uploads CSV that contains invalid Tracking ID on All Orders page
    Then Operator verify that the page failed to find the orders inside the CSV that contains invalid Tracking IDS on All Orders page

  Scenario: Operator should be able to Search Order with Exact tracking ID (uid:73c08224-46b2-458a-b164-50896073a05d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> All Orders
    When Operator open page of the created order from All Orders page
    Then Operator verifies tha searched Tracking ID is the same to the created one

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op