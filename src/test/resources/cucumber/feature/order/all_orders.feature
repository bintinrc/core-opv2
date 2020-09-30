@OperatorV2 @Core @Order @AllOrders @Saas
Feature: All Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator download sample CSV file for "Find Orders with CSV" on All Orders page (uid:d95ad43b-5dda-4747-8eb5-4d77e5aaa9d5)
    Given Operator go to menu Order -> All Orders
    When Operator download sample CSV file for "Find Orders with CSV" on All Orders page
    Then Operator verify sample CSV file for "Find Orders with CSV" on All Orders page is downloaded successfully

  Scenario: Operator find new pending pickup order by using Specific Search on All Orders page (uid:3e6ffaf7-ca06-42e3-a68c-959e287f4afe)
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

  Scenario Outline: Operator find new pending pickup order on All Orders page (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator verify the new pending pickup order is found on All Orders page with correct info
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:cf30bd2e-9214-461c-900d-7d7b6c966242 | Normal    | false            |
      | Return | uid:85546b4d-7586-4658-a4e1-02b3406099cb | Return    | true             |
#      | C2C    | uid:7257ec3c-1efc-405f-bc7a-b2effc1362f0 | C2C       | true             |

  Scenario: Operator find multiple orders with CSV on All Orders page (uid:932287da-cf04-471e-b056-e3c44c233677)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info

  Scenario: Operator uploads CSV that contains invalid Tracking ID on All Orders page (uid:db38db19-9d75-46cb-a1ec-339576a14f74)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Order -> All Orders
    When Operator uploads CSV that contains invalid Tracking ID on All Orders page
    Then Operator verify that the page failed to find the orders inside the CSV that contains invalid Tracking IDS on All Orders page

  Scenario: Operator should be able to Search Order with Exact tracking ID (uid:1fedac5b-a277-4507-a298-074928598676)
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