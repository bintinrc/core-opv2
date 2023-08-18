#@OperatorV2 @Core @EditOrder @UpdateStampId @EditOrder4
Feature: Update Stamp ID

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with New Stamp ID (uid:ce1f0e4d-435e-4467-ab58-76019c30f8a4)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit order page
    Then Operator verify next order info on Edit order page:
      | stampId | KEY_STAMP_ID |
    And DB Core Operator gets Order by Stamp ID
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | KEY_STAMP_ID        |
    And Operator switch to Edit Order's window

  Scenario: Update Stamp ID - Update Stamp ID with Stamp ID that Have been Used Before (uid:e43837c6-311c-40c7-9a7b-08d47253ecf9)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And DB Core Operator gets order with Stamp ID
    Then Operator unable to change Stamp ID of the created order to "KEY_LAST_STAMP_ID" on Edit order page
    And Operator refresh page
    Then Operator verify next order info on Edit order page:
      | stampId | - |

  Scenario: Remove Stamp ID (uid:70f0c0e4-1331-4a92-911e-ca6ac132377c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit order page
    And Operator remove Stamp ID of the created order on Edit order page
    Then Operator verify next order info on Edit order page:
      | stampId | - |
    When Operator go to menu Order -> All Orders
    Then Operator can't find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | KEY_STAMP_ID        |
