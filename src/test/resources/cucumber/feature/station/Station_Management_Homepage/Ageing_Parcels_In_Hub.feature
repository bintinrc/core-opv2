@StationManagement @StationHome @AgeingParcels
Feature: Ageing Parcels In Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @ForceSuccessOrder
  Scenario Outline: View Ageing Parcel in Hub
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operators updates the column value: inbounded_into_hub_at as "{date: -3 days next, YYYY-MM-dd} 00:00:00" of parcel table in station db
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID/ Route ID |
      | Address               |
      | Granular Status       |
      | Time in Hub           |
      | Committed ETA         |
      | Recovery Ticket Type  |
      | Ticket Status         |
      | Order Tags            |
      | Size                  |
      | Timeslot              |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: View Priority Ageing Parcel in Hub
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operators updates the column value: inbounded_into_hub_at as "{date: -3 days next, YYYY-MM-dd} 00:00:00" of parcel table in station db
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           | Order Tags |
      | {KEY_CREATED_ORDER_TRACKING_ID} | PRIOR      |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Can Not View Parcel Inbounded Less than 3 Days
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And DB Operators updates the column value: inbounded_into_hub_at as "{date: 0 days next, YYYY-MM-dd} 00:00:00" of parcel table in station db
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in tile: "<TileName>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID |
      | <TrackingId>          |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op