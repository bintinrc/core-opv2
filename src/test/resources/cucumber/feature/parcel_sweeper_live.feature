@OperatorV2 @OperatorV2Part2 @ParcelSweeperLive
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: test1
    Given Operator go to menu Routing -> Parcel Sweeper Live
#  Parcel Sweeper Live - Order Not Found - Invalid Tracking ID	"Instruction:
#  GIVEN an invalid Tracking Id which is not exist in core.orders table
#  AND select a hub to sweep at (Physical Hub) from dropdown menu
#  AND click 'continue' button
#  THEN verify that 'Parcel Sweeper' page is loaded
#  WHEN scan/enter tracking_id into 'Tracking Id' field
#  THEN verify that there is a very loud siren sound alert
#  AND verify Route ID = 'NOT FOUND' and driver name = 'NIL' with red background color
#  AND verify Zone name = 'NIL' with red backgroud color
#  AND verify destination hub = 'NOT FOUND' with red background color
#  AND verify that NO changes in order's status/granular_status
#
#  Note: You don't have to use the same step name, if possible please combine some steps into one to reduce duplicate step name."


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op