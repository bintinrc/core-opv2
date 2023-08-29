@StationManagement @SfldTickets @SfldPriorParcelEta
Feature: Confirm ETA of SF Prior Parcels

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder
  Scenario Outline: View Unacknowledged SFLD Parcel (uid:5c6583f0-7639-461f-aa59-876c0c11f0ef)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName>" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
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
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator verifies that the sfld ticket count has increased by 1
    And Operator clicks the arrow button to view parcels with sfld tickets
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd}  |
    And Operator confirms that station confirmed eta field is empty
    And Operator verifies that save and confirm button is disabled
    And Operator verifies that Edit Order page is opened on clicking tracking id

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent | FSRParcelText                              |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | FSR parcels' ETA that need to be confirmed |

  @Happypath @ForceSuccessOrder
  Scenario Outline: View Unacknowledged SFLD Parcel When ETA has Passed (uid:ceae8b90-16da-48a1-b74f-25cad6dc2e58)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName>" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
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
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-previous-2-day-yyyy-MM-dd}", "{gradle-previous-1-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator verifies that the sfld ticket count has increased by 1
    And Operator clicks the arrow button to view parcels with sfld tickets
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID           | {KEY_CREATED_ORDER_TRACKING_ID}    |
      | ETA Calculated        | {gradle-previous-2-day-yyyy-MM-dd} |
      | Station Confirmed ETA | -                                  |
    And Operator confirms that station confirmed eta field is empty
    And Operator verifies that save and confirm button is disabled
    And Operator confirms that no checkbox displayed for sfld parcels when eta has passed
    And Operator verifies that Edit Order page is opened on clicking tracking id

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent | FSRParcelText                              |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | FSR parcels' ETA that need to be confirmed |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: Search SFLD Parcel by Tracking ID (uid:8f3a521c-9404-4785-af3a-c26535dc3141)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName>" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
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
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator verifies that the sfld ticket count has increased by 1
    And Operator clicks the arrow button to view parcels with sfld tickets
    And Operator verifies that the modal: "<ModalName>" is displayed
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd}  |

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           |

  @ForceSuccessOrder
  Scenario Outline: Search Unlisted SFLD Parcel by Tracking ID (uid:23465769-f396-4c89-b2f1-0330a31dc1a3)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName>" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
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
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator verifies that the sfld ticket count has increased by 1
    And Operator clicks the arrow button to view parcels with sfld tickets
    And Operator verifies that the modal: "<ModalName>" is displayed
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID  |
      | <TrackingId> |

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent | TrackingId        |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | UNLISTED_TRACK_ID |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: Search SFLD Parcel by Address (uid:0058cd9f-8748-4d8e-ac42-e96a2b5ee2cd)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName>" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator saves to address used in the parcel in the key
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator verifies that the sfld ticket count has increased by 1
    And Operator clicks the arrow button to view parcels with sfld tickets
    And Operator verifies that the modal: "<ModalName>" is displayed
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     | Address                                |
      | {KEY_CREATED_ORDER_TRACKING_ID} | {KEY_COMMA_DELIMITED_ORDER_TO_ADDRESS} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID}        |
      | Address        | {KEY_COMMA_DELIMITED_ORDER_TO_ADDRESS} |
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd}         |

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           |

  @ForceSuccessOrder
  Scenario Outline: Search Unlisted SFLD Parcel by Address (uid:5fb5a447-1b44-4997-8328-e8a3c707dd2f)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName>" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator saves to address used in the parcel in the key
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator verifies that the sfld ticket count has increased by 1
    And Operator clicks the arrow button to view parcels with sfld tickets
    And Operator verifies that the modal: "<ModalName>" is displayed
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     | Address   |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <Address> |

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent | Address          |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | Unlisted Address |

  @ForceSuccessOrder
  Scenario Outline: Search SFLD Parcel by ETA Calculated Date (uid:a0bdfb1f-1107-4747-81c7-66dd89464f31)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName>" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
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
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator verifies that the sfld ticket count has increased by 1
    And Operator clicks the arrow button to view parcels with sfld tickets
    And Operator verifies that the modal: "<ModalName>" is displayed
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator selects the following values in the modal pop up
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd}  |

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: Sort SFLD Parcel Based on ETA Calculated (uid:e1f73510-1de4-42b9-bfbc-e7122b561d73)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName>" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
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
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator verifies that the sfld ticket count has increased by 1
    And Operator clicks the arrow button to view parcels with sfld tickets
    And Operator verifies that the modal: "<ModalName>" is displayed
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operators sorts and verifies that the column:"<ColumnName>" is in ascending order
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd}  |

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent | ColumnName     |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | ETA Calculated |

  @Happypath @ForceSuccessOrder @HighPriority
  Scenario Outline: Update Confirmed ETA for Unacknowledged SFLD Parcel (uid:1ed56a8f-fb7d-482d-b4ee-67fb63d8028f)
    Given Operator loads Operator portal home page
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
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
    And Operator clicks the arrow button to view parcels with sfld tickets
    Then Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd}  |
    And Operator confirms that station confirmed eta field is empty
    And Operators chooses the date:"{gradle-next-2-day-yyyy-MM-dd}" as station confirmed eta and proceed
    And Operators verifies that the toast message: "<ToastMessage>" has displayed
    And Operator verifies that the sfld ticket count has decreased by 1
    And DB Operator verifies that the following details are displaying in sfld_tickets table in station db:
      | status             | MANUAL_CONFIRMED                 |
      | confirmed_eta      | {gradle-next-2-day-yyyy-MM-dd}   |
      | confirmation_time  | {gradle-current-date-yyyy-MM-dd} |
      | acknowledger_email | {operator-portal-uid}            |

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent | FSRParcelText                              | ToastMessage                     |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | FSR parcels' ETA that need to be confirmed | Successfully confirmed 1 ETA(s)! |

  @Happypath @ForceSuccessOrder @HighPriority
  Scenario Outline: Bulk Update Confirmed ETA for Multiple Unacknowledged SFLD Parcel (uid:d395ac0f-61f5-464d-b2ce-3de3d0668273)
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | <NoOfRecords>                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep multiple parcels in the hub
      | hubId | <HubId> |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[1]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[2]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
    And Operator clicks the arrow button to view parcels with sfld tickets
    Then Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator selects the following values in the modal pop up
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verifies that the following details are displayed on the modal
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator confirms that station confirmed eta field is empty
    And Operator selects <NoOfRecords> records that have same eta calculated from the modal
    And Operator verifies that the text: "Confirm the ETA for the <NoOfRecords> parcel(s) selected" is displayed
    And Operator confirms the common eta as:"{gradle-next-1-day-yyyy-MM-dd}" and proceed
    And Operators verifies that the toast message: "Successfully confirmed <NoOfRecords> ETA(s)!" has displayed
    And Operator verifies that the sfld ticket count has decreased by <NoOfRecords>
    And DB Operator verifies that the following details are displaying in sfld_tickets table in station db:
      | status             | MANUAL_CONFIRMED                 |
      | confirmed_eta      | {gradle-next-1-day-yyyy-MM-dd}   |
      | confirmation_time  | {gradle-current-date-yyyy-MM-dd} |
      | acknowledger_email | {operator-portal-uid}            |

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent | NoOfRecords | FSRParcelText                              |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | 2           | FSR parcels' ETA that need to be confirmed |

  @Happypath @ForceSuccessOrder @HighPriority
  Scenario Outline: Partial Success Upon Bulk Update Confirmed ETA for Unacknowledged SFLD Parcel (uid:27d29f5d-9948-47f9-8bee-984174e922bc)
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | <NoOfRecords>                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator saves to address used in the parcel in the key
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep multiple parcels in the hub
      | hubId | <HubId> |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[1]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[2]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
    And Operator clicks the arrow button to view parcels with sfld tickets
    Then Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator selects the following values in the modal pop up
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verifies that the following details are displayed on the modal
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator confirms that station confirmed eta field is empty
    And Operator selects the checkbox on the created orders that are to be confirmed with the eta
    And Operator verifies that the text: "Confirm the ETA for the <NoOfRecords> parcel(s) selected" is displayed
    And DB Operator updates the status of sfld ticket as "<Status>" for the created order directly
    And Operator confirms the common eta as:"{gradle-next-1-day-yyyy-MM-dd}" and proceed
    And Operator verifies that the modal: "<FailureModal>" is displayed
    And Operator downloads the records with failed etas by clicking the download button
    And Operator verifies that the valid error message is updated on the downloaded file
    And Operator verifies that the sfld ticket count has decreased by <NoOfRecords>
    And DB Operator verifies that the following details are displaying in sfld_tickets table in station db:
      | status | MANUAL_CONFIRMED |

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent | NoOfRecords | Status           | FailureModal                     |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | 2           | MANUAL_CONFIRMED | Some Parcels failed to save ETAs |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: Unable to Bulk Update Confirmed ETA of Multiple Unacknowledged SFLD Parcel (uid:e747959c-c93f-49d2-904c-100a8fd148a3)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And Operator get sfld ticket count for the priority parcels
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator saves to address used in the parcel in the key
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep multiple parcels in the hub
      | hubId | <HubId> |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[1]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[2]}, "system_id": "sg", "suggested_etas": ["{gradle-next-2-day-yyyy-MM-dd}", "{gradle-next-3-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 2
    And Operator verifies that the sfld ticket count has increased by 2
    And Operator clicks the arrow button to view parcels with sfld tickets
    And Operator verifies that the modal: "<ModalName>" is displayed
    Then Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator selects the checkbox on the created orders that are to be confirmed with the eta
    And Operator verifies that the text: "Please select parcels with the same calculated ETA" is displayed
    And Operator verifies that the station confirmed eta is disabled and cannot be updated
    And Operator verifies that the following buttons are displayed in disabled state
      | Save & Proceed |

    Examples:
      | HubId       | HubName       | TileName                | ModalName                                    | SlackMessageContent |
      | {hub-id-12} | {hub-name-12} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           |

  @Happypath @ForceSuccessOrder @HighPriority
  Scenario Outline: Fail Bulk Update Confirmed ETA for Less Than 5 Unacknowledged SFLD Parcels (uid:72868a40-a4d0-4712-b206-2d16b5c12aba)
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | <NoOfRecords>                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator saves to address used in the parcel in the key
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep multiple parcels in the hub
      | hubId | <HubId> |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[1]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[2]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[3]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator get sfld ticket count for the priority parcels
    And Operator clicks the arrow button to view parcels with sfld tickets
    Then Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator selects the following values in the modal pop up
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verifies that the following details are displayed on the modal
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator confirms that station confirmed eta field is empty
    And Operator selects the checkbox on the created orders that are to be confirmed with the eta
    And Operator verifies that the text: "Confirm the ETA for the <NoOfRecords> parcel(s) selected" is displayed
    And DB Operator updates the status of sfld ticket as "<Status>" for all created orders directly
    And Operator confirms the common eta as:"{gradle-next-1-day-yyyy-MM-dd}" and proceed
    And Operator verifies that the modal: "<FailureModal>" is displayed
    And Operator verifies that the sfld ticket count has decreased by 0
    And DB Operator verifies that the following details are displayed for all created orders in station db:
      | status        | MANUAL_CONFIRMED |
      | confirmed_eta | NULL             |

    Examples:
      | HubId       | HubName       | ModalName                                    | SlackMessageContent | NoOfRecords | Status           | FailureModal                                                                                                  | FSRParcelText                              |
      | {hub-id-12} | {hub-name-12} | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | 3           | MANUAL_CONFIRMED | SFLD ticket acknowledgement failed because ticket is not of UNCONFIRMED status or other parameters are wrong. | FSR parcels' ETA that need to be confirmed |

  @ForceSuccessOrder @MediumPriority
  Scenario Outline: Fail Bulk Update Confirmed ETA for 5 Unacknowledged SFLD Parcels (uid:9553b5c5-21f2-43ba-a2ea-93590233488b)
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | <NoOfRecords>                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator saves to address used in the parcel in the key
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep multiple parcels in the hub
      | hubId | <HubId> |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[1]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[2]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[3]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[4]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[5]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator get sfld ticket count for the priority parcels
    And Operator clicks the arrow button to view parcels with sfld tickets
    Then Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator selects the following values in the modal pop up
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verifies that the following details are displayed on the modal
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator confirms that station confirmed eta field is empty
    And Operator selects the checkbox on the created orders that are to be confirmed with the eta
    And Operator verifies that the text: "Confirm the ETA for the <NoOfRecords> parcel(s) selected" is displayed
    And DB Operator updates the status of sfld ticket as "<Status>" for all created orders directly
    And Operator confirms the common eta as:"{gradle-next-1-day-yyyy-MM-dd}" and proceed
    And Operator verifies that the modal: "<FailureModal>" is displayed
    And Operator verifies that the sfld ticket count has decreased by 0
    And DB Operator verifies that the following details are displayed for all created orders in station db:
      | status        | MANUAL_CONFIRMED |
      | confirmed_eta | NULL             |

    Examples:
      | HubId       | HubName       | ModalName                                    | SlackMessageContent | NoOfRecords | Status           | FailureModal                                                                                                  | FSRParcelText                              |
      | {hub-id-12} | {hub-name-12} | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | 5           | MANUAL_CONFIRMED | SFLD ticket acknowledgement failed because ticket is not of UNCONFIRMED status or other parameters are wrong. | FSR parcels' ETA that need to be confirmed |

  @Happypath @ForceSuccessOrder @HighPriority
  Scenario Outline: Fail Bulk Update Confirmed ETA for More Than 5 Unacknowledged SFLD Parcels (uid:baafe30e-90ac-4a2b-9c31-cc967bfe661a)
    Given Operator loads Operator portal home page
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | <NoOfRecords>                                                                                                                                                                                                                                                                                                                    |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator saves to address used in the parcel in the key
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep multiple parcels in the hub
      | hubId | <HubId> |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[1]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[2]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[3]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[4]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[5]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDER_ID[6]}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator get sfld ticket count for the priority parcels
    And Operator clicks the arrow button to view parcels with sfld tickets
    Then Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator selects the following values in the modal pop up
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verifies that the following details are displayed on the modal
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator confirms that station confirmed eta field is empty
    And Operator selects the checkbox on the created orders that are to be confirmed with the eta
    And Operator verifies that the text: "Confirm the ETA for the <NoOfRecords> parcel(s) selected" is displayed
    And DB Operator updates the status of sfld ticket as "<Status>" for all created orders directly
    And Operator confirms the common eta as:"{gradle-next-1-day-yyyy-MM-dd}" and proceed
    And Operator verifies that the modal: "<FailureModal>" is displayed
    And Operator downloads the records with failed etas by clicking the download button
    And Operator verifies that the valid error message is updated on the downloaded file
    And Operator verifies that the sfld ticket count has decreased by 0
    And DB Operator verifies that the following details are displayed for all created orders in station db:
      | status        | MANUAL_CONFIRMED |
      | confirmed_eta | NULL             |

    Examples:
      | HubId       | HubName       | ModalName                                    | SlackMessageContent | NoOfRecords | Status           | FailureModal                                                                                                                         | FSRParcelText                              |
      | {hub-id-12} | {hub-name-12} | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | 6           | MANUAL_CONFIRMED | There were more than 5 parcels whose ETAs were not successfully saved. Please download the list and failure reasons to troubleshoot. | FSR parcels' ETA that need to be confirmed |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op