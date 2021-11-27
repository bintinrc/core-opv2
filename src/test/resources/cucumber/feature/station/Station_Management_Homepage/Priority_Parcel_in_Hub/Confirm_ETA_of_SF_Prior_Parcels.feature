@StationManagement @StationHome @SfldPriorParcelEta
Feature: Confirm ETA of SF Prior Parcels

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

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
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator verifies that the sfld ticket count has increased by 1
    And Operator verifies that the text: "<FSRParcelText>" and count are matching for fsr parcels in urgent tasks banner
    And Operator clicks the alarm button to view parcels with sfld tickets
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
      | HubName      | TileName                | ModalName                                    | SlackMessageContent | FSRParcelText                              |
      | {hub-name-8} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | FSR parcels' ETA that need to be confirmed |

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
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-previous-2-day-yyyy-MM-dd}", "{gradle-previous-1-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the modal: "<ModalName>" is displayed and can be closed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator verifies that the sfld ticket count has increased by 1
    And Operator verifies that the text: "<FSRParcelText>" and count are matching for fsr parcels in urgent tasks banner
    And Operator clicks the alarm button to view parcels with sfld tickets
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
      | HubName      | TileName                | ModalName                                    | SlackMessageContent | FSRParcelText                              |
      | {hub-name-8} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | GENERATED           | FSR parcels' ETA that need to be confirmed |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op