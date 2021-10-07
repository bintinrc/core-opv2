@NumberOfParcels @StationHome @StationManagement
Feature: Number of Parcels In Hub


  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @coverage-manual @coverage-operator-manual @step-done @station-happy-path
  Scenario Outline: View Number of Parcels in Hub (uid:34b4182d-ee92-4936-b4b8-fbc3890be67d)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has increased by 1
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that the table:"<TableName1>" is displayed with following columns:
      | Size  |
      | Count |
    And verifies that the table:"<TableName2>" is displayed with following columns:
      | Zones |
      | Count |
    And reloads operator portal to reset the test state

    Examples:
      | TileName                 | ModalName      | TableName1     | TableName2 |
      | Number of parcels in hub | Parcels in Hub | By Parcel Size | By Zones   |


  @coverage-manual @coverage-operator-manual @step-done @NVQA-3871
  Scenario Outline: View Parcel of Resolved Missing Ticket Type and Outcome is <Outcome> (<hiptest-uid>)
  NOTE: For the Missing Ticket Type and Order Outcome Is CUSTOMER RECEIVED it suppose be included to the counts but because the granular status will be updated to Completed so it's not included (we have a logic to exclude order counts if the order granular status is '
  Completed', 'Cancelled', 'Returned to Sender')
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name-1}       |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | LOST - DECLARED    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And get the count from the tile: "<TileName>"
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | outcome                 | <Outcome>                 |
      | newInstructions         | GENERATED                 |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "<OrderStatus>" on Edit Order page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the count in tile: "<TileName>" has decreased by 1

    Examples:
      | TileName                             | Status   | KeepCurrentOrderOutcome | Outcome           | OrderStatus | hiptest-uid                              |
      | Number of missing or damaged parcels | RESOLVED | No                      | LOST - DECLARED   | Transit     | uid:136f000f-9deb-44b2-9e92-f2195932a3cc |
      | Number of missing or damaged parcels | RESOLVED | No                      | LOST - UNDECLARED | Transit     | uid:70f81b81-e530-4a34-b520-ff5b0347977e |
      | Number of missing or damaged parcels | RESOLVED | No                      | FOUND - INBOUND   | Transit     | uid:a1767cec-1039-4743-8f8a-210e8cab9255 |
      | Number of missing or damaged parcels | RESOLVED | No                      | CUSTOMER RECEIVED | Completed   | uid:9c5beef9-79df-4423-9a2d-42b9d37e228d |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op