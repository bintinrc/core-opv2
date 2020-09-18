@MovementTrip @InterHub @Hub @MiddleMile @refo
Feature: Cancel Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @SoftDeleteHubViaDb
  Scenario: Cancel Trip - Trip Status Pending (uid:318c9c20-adae-40f0-8094-e82d986008e6)
#    When API Operator creates new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | CROSSDOCK |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator reloads hubs cache
#    When Operator go to menu Inter-Hub -> Movement Schedules
#    When Movement Management page is loaded
#    And Operator opens Add Movement Schedule modal on Movement Management page
#    Then Operator can select "{KEY_LIST_OF_CREATED_HUBS[1].name}" crossdock hub when create crossdock movement schedule
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And Operator verifies a trip to destination hub "{KEY_LIST_OF_CREATED_HUBS[2].name}" exist
    And Operator searches for the Trip Management based on its "status"
#    When Operator clicks on "cancel" icon on the action column
    And Operator clicks "Cancel Trip" button on cancel trip dialog
    # click cancel
    # show dialog
    # click yes
    # verify status cancelled
    # [verify ui] wait toast
    # [verify ui] trip has status: Cancelled in Departure tab Opv2
    # [verify db] has event cancelled in hub_qa_gl/movement_trip_event
    # [verify db] event has status cancelled in hub_qa_gl/movement_trip_event
    # [verify db] event has user id: email of user in hub_qa_gl/movement_trip_event

#    Given Operator open Trip Management page on Opv2
#    When Operator search and load trip in Departure tab
#    And Operator select Trip with status ${trip_status}
#    And Operator click Trash button
#    Then Operator see the validation 'Are you sure you want to cancel this trip?'
#    When Operator select Yes
#    Then Operator see the toast 'Movement trip cancelled'
#    And Make sure trip has event: CANCELLED in hub_qa_gl/movement_trip_event
#    And Make sure the event has status: CANCELLED in hub_qa_gl/movement_trip_event
#    And Make sure the event has user id: email of user in hub_qa_gl/movement_trip_event
#    And Make sure trip has status: Cancelled in Departure tab Opv2

#  @coverage-auto @coverage-operator-auto
#  Scenario: Cancel Trip - Trip Status Transit (uid:c4b7c24e-e9c1-42a6-8bcd-299f0bde7d68)
#    Given Operator open Trip Management page on Opv2
#    When Operator search and load trip in Departure tab
#    And Operator select Trip with status ${trip_status}
#    And Operator click Trash button
#    Then Operator see the validation 'Are you sure you want to cancel this trip?'
#    When Operator select Yes
#    Then Operator see the toast 'Movement trip cancelled'
#    And Make sure trip has event: CANCELLED in hub_qa_gl/movement_trip_event
#    And Make sure the event has status: CANCELLED in hub_qa_gl/movement_trip_event
#    And Make sure the event has user id: email of user in hub_qa_gl/movement_trip_event
#    And Make sure trip has status: Cancelled in Departure tab Opv2

#  @coverage-auto @coverage-operator-auto
#  Scenario: Call Off Cancel Trip - Trip Status Pending (uid:770109ba-1146-459c-8be6-26eba77c303d)
#    Given dummy_noop
#
#  @coverage-auto @coverage-operator-auto
#  Scenario: Call Off Cancel Trip - Trip Status Transit (uid:9003a32c-c483-4a4c-981a-b331abf7b684)
#    Given dummy_noop
#
#  @coverage-auto @coverage-operator-auto
#  Scenario: Cannot Cancel Invalid Trip - Trip status Cancelled (uid:dba2be77-0bd7-439d-9c6e-58c5bd07ddd1)
#    Given dummy_noop
#
#  @coverage-auto @coverage-operator-auto
#  Scenario: Cannot Cancel Invalid Trip - Trip status Completed (uid:6b520ff1-b954-4877-a9c3-985ac92b4fc4)
#    Given dummy_noop


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
