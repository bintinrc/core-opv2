@Story-3 @StationHome
Feature: Number of Missing or Damaged Parcels


  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @Case-1
  Scenario Outline: View Missing Ticket Type and Order Outcome Is NULL (uid:4e719189-0118-4ab9-bfa1-b391c47816ca)
    #Given Operator go to menu Station Management Tool -> Station Management Homepage
    #And Operator selects the hub as "{hub-name-1}" and proceed
    #And get the count from the tile: "<TileName>"
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
      | TileName                             | Status   | KeepCurrentOrderOutcome | Outcome           | OrderStatus |
      | Number of missing or damaged parcels | RESOLVED | No                      | LOST - DECLARED   |Transit|
      | Number of missing or damaged parcels | RESOLVED | No                      | LOST - UNDECLARED |Transit|
      | Number of missing or damaged parcels | RESOLVED | No                      | FOUND - INBOUND   |Transit|
      | Number of missing or damaged parcels | RESOLVED | No                      | CUSTOMER RECEIVED  |Completed    |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op