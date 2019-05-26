@OperatorV2 @OperatorV2Part2 @ParcelSweeperLive
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: test1
    Given Operator go to menu Routing -> Parcel Sweeper Live
#  Parcel Sweeper Live - Order Not Found - Invalid Tracking ID	"Instruction:
#  GIVEN an invalid Tracking Id which is not exist in core.orders table
#  When  select a hub to sweep at (Physical Hub) from dropdown menu
#  AND click 'continue' button
  Then Operator verifies on providing invalid trackingId errors displayed on Parcel Sweeper Live page
#  WHEN scan/enter tracking_id into 'Tracking Id' field
#  THEN verify that there is a very loud siren sound alert
#  AND verify Route ID = 'NOT FOUND' and driver name = 'NIL' with red background color
#  AND verify Zone name = 'NIL' with red backgroud color
#  AND verify destination hub = 'NOT FOUND' with red background color
# !!!!!!!! AND verify that NO changes in order's status/granular_status
#
#  Note: You don't have to use the same step name, if possible please combine some steps into one to reduce duplicate step name."

  Scenario: test2
    Given Operator go to menu Routing -> Parcel Sweeper Live

#  "Instruction:
#
#  GIVEN an order with status = Pending Pickup
#  WHEN go to Parcel Sweeper live page Operator V2, https://operatorv2-qa.ninjavan.co/#/sg/parcel-sweeper-live
#  AND select a hub to sweep at (Physical Hub) from dropdown menu
#  AND click 'continue' button
#  THEN verify that 'Parcel Sweeper' page is loaded
#  WHEN scan/enter tracking_id into 'Tracking Id' field
#  THEN verify that there is a very loud siren sound alert
#  AND verify Route ID = 'NOT FOUND' and driver name = 'NIL' with red background color
#  AND verify Zone name = 'NIL' with red backgroud color
#  AND verify destination hub = 'NOT FOUND' with red background color
#  AND verify that NO changes in order's status/granular_status
#  AND verify that one warehouse_sweep record is created in core database  warehouse_sweeps table, with correct hub_id, order_id, scan=tracking_id
#  AND verify that core.orders.latest_warehouse_sweep_id is updated with newest warehouse_sweeps.id if it is scanned more than once
#  AND verify that one new record is created in events database order_events table with correct order_id and type = 27 (PARCEL_ROUTING_SCAN)
#  AND verify that 'Parcel Routing Scan' event is shown in edit order page Operator V2 events table with correct details on event description column
#
#  Note: You don't have to use the same step name, if possible please combine some steps into one to reduce duplicate step name."



  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op