@StationManagement @AgeingParcels
Feature: Ageing Parcels In Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @ForceSuccessOrder @Happypath
  Scenario Outline: View Ageing Parcel in Hub
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
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
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: View Priority Ageing Parcel in Hub
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      | Order Tags |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PRIOR      |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Can Not View Parcel Inbounded Less than 3 Days
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: 0 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the count in tile: "<TileName>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |


  @ForceSuccessOrder
  Scenario Outline: Click Hyperlink of Tracking ID on Ageing Parcel in Hub
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that Edit Order page is opened on clicking tracking id

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: View Ageing Parcel in Hub of Unacknowledged SLFD Parcel
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -4 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Committed ETA | - |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: View Ageing Parcel in Hub of Acknowledged SLFD Parcel
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Station - Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDERS[1].id}, "system_id": "sg", "suggested_etas": ["{date: 1 days next, YYYY-MM-dd}", "{date: 2 days next, YYYY-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{date: 0 days next, YYYY-MM-dd}", "slack_message_content": "GENERATED"}} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -4 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ETA Calculated | {date: 1 days next, YYYY-MM-dd}            |
    And Operator confirms that station confirmed eta field is empty
    And Operators chooses the date:"{date: 1 days next, YYYY-MM-dd}" as station confirmed eta and proceed
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Committed ETA | {date: 1 days next, YYYY-MM-dd} |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Van Inbounded Ageing Parcel Disappear
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -4 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Shipment Inbounded Ageing Parcel disappear
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -4 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                                  |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | actionType | ADD                                        |
    And API Operator closes the shipment using created shipper id
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | <OrigHubId>               |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Examples:
      | HubName       | HubId       | TileName              | ModalName             | OrigHubId   | OrigHubName   | DestHubId   | DestHubName   | Country |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub | {hub-id-18} | {hub-name-18} | {hub-id-10} | {hub-name-10} | sg      |

  @ForceSuccessOrder
  Scenario Outline: Force completed Ageing Parcel Disappear
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -4 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Success RTS Ageing Parcel Disappear
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -4 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                              |
      | rtsRequest | { "reason": "Return to sender: Nobody at address", "timewindow_id":1, "date":"{date: 1 days next, yyyy-MM-dd}"} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Cancelled Ageing Parcel Disappear
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
    When DB Station - Operator updates inboundedIntoHubAt "{date: -4 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_CREATED_ORDER_TRACKING_ID}"
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    When API Operator force cancels the created order
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Failed Delivery Ageing Parcel Reappear
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
    When DB Station - Operator updates inboundedIntoHubAt "{date: -4 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_CREATED_ORDER_TRACKING_ID}"
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Driver failed the delivery of multiple parcels
    When Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>              |
      | fetchBy      | FETCH_BY_ROUTE_ID      |
      | fetchByValue | GET_FROM_CREATED_ROUTE |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |


  @ForceSuccessOrder
  Scenario Outline: Sort Ageing Parcel in Hub Based on Time in Hub
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 1:30:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}"
    Given Operator loads Operator portal home page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operators sorts and verifies that the column:"Time in Hub" is in descending order


    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Ageing Parcel in Hub by Committed ETA
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When API Station - Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_LIST_OF_CREATED_ORDERS[1].id}, "system_id": "sg", "suggested_etas": ["{date: 1 days next, YYYY-MM-dd}", "{date: 2 days next, YYYY-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{date: 0 days next, YYYY-MM-dd}", "slack_message_content": "GENERATED"}} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | ETA Calculated | {date: 1 days next, YYYY-MM-dd}            |
    And Operator confirms that station confirmed eta field is empty
    And Operators chooses the date:"{date: 1 days next, YYYY-MM-dd}" as station confirmed eta and proceed
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
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
      | Tracking ID/ Route ID                      | Committed ETA                   |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {date: 1 days next, YYYY-MM-dd} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Committed ETA         | {date: 1 days next, YYYY-MM-dd}               |


    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Ageing Parcel in Hub by Size
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"dimensions":{ "size":"S", "weight":"1.0" },"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Size                  | Small                                         |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Ageing Parcel in Hub by Ticket Status
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | IMPROPER PACKAGING                         |
      | parcelLocation          | DAMAGED RACK                               |
      | liability               | Recovery                                   |
      | damageDescription       | GENERATED                                  |
      | orderOutcomeDamaged     | NV LIABLE - FULL                           |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Ticket Status         | CREATED                                       |

    Examples:
      | HubName       | HubId       | TicketType | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | DAMAGED    | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Ageing Parcel in Hub by Timeslot
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Timeslot              | 0900 - 2200                                   |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | IMPROPER PACKAGING                         |
      | parcelLocation          | DAMAGED RACK                               |
      | liability               | Recovery                                   |
      | damageDescription       | GENERATED                                  |
      | orderOutcomeDamaged     | NV LIABLE - FULL                           |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcome     | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | NV LIABLE - FULL | CREATED      |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | ROUTE CLEANING                             |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | <TicketSubType>                            |
      | orderOutcome            | <OrderOutcome>                             |
      | exceptionReason         | GENERATED                                  |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | CREATED      |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                   | ROUTE CLEANING                             |
      | investigatingDepartment       | Fleet (First Mile)                         |
      | investigatingHub              | <HubName>                                  |
      | ticketType                    | <TicketType>                               |
      | ticketSubType                 | <TicketSubType>                            |
      | orderOutcomeInaccurateAddress | RTS                                        |
      | rtsReason                     | Nobody at address                          |
      | exceptionReason               | GENERATED                                  |
      | custZendeskId                 | 1                                          |
      | shipperZendeskId              | 1                                          |
      | ticketNotes                   | GENERATED                                  |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | RESUME DELIVERY | CREATED      |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                 | CUSTOMER COMPLAINT                         |
      | investigatingDepartment     | Fleet (First Mile)                         |
      | investigatingHub            | <HubName>                                  |
      | ticketType                  | <TicketType>                               |
      | ticketSubType               | <TicketSubType>                            |
      | orderOutcomeDuplicateParcel | PARCEL SCRAPPED                            |
      | issueDescription            | GENERATED                                  |
      | custZendeskId               | 1                                          |
      | shipperZendeskId            | 1                                          |
      | ticketNotes                 | GENERATED                                  |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | RESUME DELIVERY | CREATED      |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of On Hold Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | IMPROPER PACKAGING                         |
      | parcelLocation          | DAMAGED RACK                               |
      | liability               | Recovery                                   |
      | damageDescription       | GENERATED                                  |
      | orderOutcomeDamaged     | NV LIABLE - FULL                           |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcome     | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | NV LIABLE - FULL | ON HOLD      |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of On Hold Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | ROUTE CLEANING                             |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | <TicketSubType>                            |
      | orderOutcome            | <OrderOutcome>                             |
      | exceptionReason         | GENERATED                                  |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | ON HOLD      |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of On Hold Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                   | ROUTE CLEANING                             |
      | investigatingDepartment       | Fleet (First Mile)                         |
      | investigatingHub              | <HubName>                                  |
      | ticketType                    | <TicketType>                               |
      | ticketSubType                 | <TicketSubType>                            |
      | orderOutcomeInaccurateAddress | RTS                                        |
      | rtsReason                     | Nobody at address                          |
      | exceptionReason               | GENERATED                                  |
      | custZendeskId                 | 1                                          |
      | shipperZendeskId              | 1                                          |
      | ticketNotes                   | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | RESUME DELIVERY | ON HOLD      |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of On Hold Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                 | CUSTOMER COMPLAINT                         |
      | investigatingDepartment     | Fleet (First Mile)                         |
      | investigatingHub            | <HubName>                                  |
      | ticketType                  | <TicketType>                               |
      | ticketSubType               | <TicketSubType>                            |
      | orderOutcomeDuplicateParcel | PARCEL SCRAPPED                            |
      | issueDescription            | GENERATED                                  |
      | custZendeskId               | 1                                          |
      | shipperZendeskId            | 1                                          |
      | ticketNotes                 | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | RESUME DELIVERY | ON HOLD      |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of In Progress Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | IMPROPER PACKAGING                         |
      | parcelLocation          | DAMAGED RACK                               |
      | liability               | Recovery                                   |
      | damageDescription       | GENERATED                                  |
      | orderOutcomeDamaged     | NV LIABLE - FULL                           |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcome     | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | NV LIABLE - FULL | IN PROGRESS  |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of In Progress Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | ROUTE CLEANING                             |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | <TicketSubType>                            |
      | orderOutcome            | <OrderOutcome>                             |
      | exceptionReason         | GENERATED                                  |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | IN PROGRESS  |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of In Progress Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                   | ROUTE CLEANING                             |
      | investigatingDepartment       | Fleet (First Mile)                         |
      | investigatingHub              | <HubName>                                  |
      | ticketType                    | <TicketType>                               |
      | ticketSubType                 | <TicketSubType>                            |
      | orderOutcomeInaccurateAddress | RTS                                        |
      | rtsReason                     | Nobody at address                          |
      | exceptionReason               | GENERATED                                  |
      | custZendeskId                 | 1                                          |
      | shipperZendeskId              | 1                                          |
      | ticketNotes                   | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | RESUME DELIVERY | IN PROGRESS  |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of In Progress Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                 | CUSTOMER COMPLAINT                         |
      | investigatingDepartment     | Fleet (First Mile)                         |
      | investigatingHub            | <HubName>                                  |
      | ticketType                  | <TicketType>                               |
      | ticketSubType               | <TicketSubType>                            |
      | orderOutcomeDuplicateParcel | PARCEL SCRAPPED                            |
      | issueDescription            | GENERATED                                  |
      | custZendeskId               | 1                                          |
      | shipperZendeskId            | 1                                          |
      | ticketNotes                 | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcome    | TicketStatus |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | RESUME DELIVERY | IN PROGRESS  |

  @ForceSuccessOrder
  Scenario Outline: Missing Ticket Not Appears in Ageing Parcel
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | orderOutcomeMissing     | <OrderOutcome>                             |
      | parcelDescription       | GENERATED                                  |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |


    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | MISSING    | LOST - DECLARED | IN PROGRESS  |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Resolved Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | IMPROPER PACKAGING                         |
      | parcelLocation          | DAMAGED RACK                               |
      | liability               | Recovery                                   |
      | damageDescription       | GENERATED                                  |
      | orderOutcomeDamaged     | NV LIABLE - FULL                           |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcome          | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | NV TO REPACK AND SHIP | RESOLVED     |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Resolved Ticket Status - Recovery Ticket Type = Missing
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | orderOutcomeMissing     | <OrderOutcome>                             |
      | parcelDescription       | GENERATED                                  |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | MISSING    | IMPROPER PACKAGING | FOUND - INBOUND | RESOLVED     |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Resolved Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | ROUTE CLEANING                             |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | <TicketSubType>                            |
      | orderOutcome            | <OrderOutcome>                             |
      | exceptionReason         | GENERATED                                  |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | RESOLVED     |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Resolved Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                   | ROUTE CLEANING                             |
      | investigatingDepartment       | Fleet (First Mile)                         |
      | investigatingHub              | <HubName>                                  |
      | ticketType                    | <TicketType>                               |
      | ticketSubType                 | <TicketSubType>                            |
      | orderOutcomeInaccurateAddress | RTS                                        |
      | rtsReason                     | Nobody at address                          |
      | exceptionReason               | GENERATED                                  |
      | custZendeskId                 | 1                                          |
      | shipperZendeskId              | 1                                          |
      | ticketNotes                   | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | RESUME DELIVERY | RESOLVED     |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Resolved Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                 | CUSTOMER COMPLAINT                         |
      | investigatingDepartment     | Fleet (First Mile)                         |
      | investigatingHub            | <HubName>                                  |
      | ticketType                  | <TicketType>                               |
      | ticketSubType               | <TicketSubType>                            |
      | orderOutcomeDuplicateParcel | PARCEL SCRAPPED                            |
      | issueDescription            | GENERATED                                  |
      | custZendeskId               | 1                                          |
      | shipperZendeskId            | 1                                          |
      | ticketNotes                 | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | RESUME DELIVERY | RESOLVED     |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Cancelled Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | IMPROPER PACKAGING                         |
      | parcelLocation          | DAMAGED RACK                               |
      | liability               | Recovery                                   |
      | damageDescription       | GENERATED                                  |
      | orderOutcomeDamaged     | NV LIABLE - FULL                           |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcome          | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | NV TO REPACK AND SHIP | CANCELLED    |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Cancelled Ticket Status - Recovery Ticket Type = Missing
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | orderOutcomeMissing     | <OrderOutcome>                             |
      | parcelDescription       | GENERATED                                  |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | MISSING    | IMPROPER PACKAGING | FOUND - INBOUND | CANCELLED    |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Cancelled Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | ROUTE CLEANING                             |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | <TicketSubType>                            |
      | orderOutcome            | <OrderOutcome>                             |
      | exceptionReason         | GENERATED                                  |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | CANCELLED    |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Cancelled Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                   | ROUTE CLEANING                             |
      | investigatingDepartment       | Fleet (First Mile)                         |
      | investigatingHub              | <HubName>                                  |
      | ticketType                    | <TicketType>                               |
      | ticketSubType                 | <TicketSubType>                            |
      | orderOutcomeInaccurateAddress | RTS                                        |
      | rtsReason                     | Nobody at address                          |
      | exceptionReason               | GENERATED                                  |
      | custZendeskId                 | 1                                          |
      | shipperZendeskId              | 1                                          |
      | ticketNotes                   | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | RESUME DELIVERY | CANCELLED    |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Cancelled Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                 | CUSTOMER COMPLAINT                         |
      | investigatingDepartment     | Fleet (First Mile)                         |
      | investigatingHub            | <HubName>                                  |
      | ticketType                  | <TicketType>                               |
      | ticketSubType               | <TicketSubType>                            |
      | orderOutcomeDuplicateParcel | PARCEL SCRAPPED                            |
      | issueDescription            | GENERATED                                  |
      | custZendeskId               | 1                                          |
      | shipperZendeskId            | 1                                          |
      | ticketNotes                 | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | Arrived at Sorting Hub                        |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcome    | TicketStatus |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | RESUME DELIVERY | CANCELLED    |

  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Shipper Ticket Status - Recovery Ticket Type = Damaged
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | IMPROPER PACKAGING                         |
      | parcelLocation          | DAMAGED RACK                               |
      | liability               | Recovery                                   |
      | damageDescription       | GENERATED                                  |
      | orderOutcomeDamaged     | NV LIABLE - FULL                           |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcome          | TicketStatus    |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | NV TO REPACK AND SHIP | PENDING SHIPPER |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Shipper Ticket Status - Recovery Ticket Type = Parcel On Hold
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | ROUTE CLEANING                             |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | <TicketSubType>                            |
      | orderOutcome            | <OrderOutcome>                             |
      | exceptionReason         | GENERATED                                  |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType     | TicketSubType   | OrderOutcome    | TicketStatus    |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL ON HOLD | SHIPPER REQUEST | RESUME DELIVERY | PENDING SHIPPER |


  @ForceSuccessOrder @Set1
  Scenario Outline: View Ageing Parcel of Pending Shipper Ticket Status - Recovery Ticket Type = Parcel Exception
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                   | ROUTE CLEANING                             |
      | investigatingDepartment       | Fleet (First Mile)                         |
      | investigatingHub              | <HubName>                                  |
      | ticketType                    | <TicketType>                               |
      | ticketSubType                 | <TicketSubType>                            |
      | orderOutcomeInaccurateAddress | RTS                                        |
      | rtsReason                     | Nobody at address                          |
      | exceptionReason               | GENERATED                                  |
      | custZendeskId                 | 1                                          |
      | shipperZendeskId              | 1                                          |
      | ticketNotes                   | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType       | TicketSubType      | OrderOutcome    | TicketStatus    |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | PARCEL EXCEPTION | INACCURATE ADDRESS | RESUME DELIVERY | PENDING SHIPPER |


  Scenario Outline: View Ageing Parcel of Pending Shipper Ticket Status - Recovery Ticket Type = Shipper Issue
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId                  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource                 | CUSTOMER COMPLAINT                         |
      | investigatingDepartment     | Fleet (First Mile)                         |
      | investigatingHub            | <HubName>                                  |
      | ticketType                  | <TicketType>                               |
      | ticketSubType               | <TicketSubType>                            |
      | orderOutcomeDuplicateParcel | PARCEL SCRAPPED                            |
      | issueDescription            | GENERATED                                  |
      | custZendeskId               | 1                                          |
      | shipperZendeskId            | 1                                          |
      | ticketNotes                 | GENERATED                                  |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator updates recovery ticket on Edit Order page:
      | status | <TicketStatus> |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType    | TicketSubType    | OrderOutcome    | TicketStatus    |
      | {hub-name-19} | {hub-id-19} | Ageing parcels in hub | Ageing Parcels in Hub | SHIPPER ISSUE | DUPLICATE PARCEL | RESUME DELIVERY | PENDING SHIPPER |

  @ForceSuccessOrder
  Scenario Outline: Search Ageing Parcel in Hub by Recovery Ticket Type
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | trackingId              | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | entrySource             | CUSTOMER COMPLAINT                         |
      | investigatingDepartment | Fleet (First Mile)                         |
      | investigatingHub        | <HubName>                                  |
      | ticketType              | <TicketType>                               |
      | ticketSubType           | IMPROPER PACKAGING                         |
      | parcelLocation          | DAMAGED RACK                               |
      | liability               | Recovery                                   |
      | damageDescription       | GENERATED                                  |
      | orderOutcomeDamaged     | NV LIABLE - FULL                           |
      | custZendeskId           | 1                                          |
      | shipperZendeskId        | 1                                          |
      | ticketNotes             | GENERATED                                  |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator selects the following values in the modal pop up
      | Recovery Ticket Type | <TicketType> |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n- |
      | Granular Status       | On Hold                                       |
      | Recovery Ticket Type  | <TicketType>                                  |
      | Ticket Status         | <TicketStatus>                                |

    Examples:
      | HubName       | HubId       | TileName              | ModalName             | TicketType | TicketSubType      | OrderOutcome          | TicketStatus |
      | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub | DAMAGED    | IMPROPER PACKAGING | NV TO REPACK AND SHIP | CREATED      |

  @ForceSuccessOrder
  Scenario Outline: Search Ageing Parcel in Hub - Search by Tracking ID
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | <searchField> |
      | <searchValue> |

    Examples:
      | searchField           | searchValue                                | HubName       | HubId       | TileName              | ModalName             |
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Ageing Parcel in Hub - Search by Route ID
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | <searchField> |
      | <searchValue> |

    Examples:
      | searchField           | searchValue                        | HubName       | HubId       | TileName              | ModalName             |
      | Tracking ID/ Route ID | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Ageing Parcel in Hub - <dataset_name>
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"","postcode":"102600","country":"SG","latitude":"1.288147","longitude":"103.740233"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Shipper tags "{KEY_LIST_OF_CREATED_ORDERS[1].id}" parcel with following tags:
      | 5570 |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    When DB Station - Operator updates inboundedIntoHubAt "{date: -3 days next, YYYY-MM-dd} 00:00:00" for the parcel with tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    Given Operator loads Operator portal home page
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID                      |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | <searchField> |
      | <searchValue> |

    Examples:
      | dataset_name              | searchField     | searchValue                           | HubName       | HubId       | TileName              | ModalName             |
      | Search by Address         | Address         | 30A ST. THOMAS WALK 102600 SG, 102600 | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |
      | Search by Granular Status | Granular Status | Arrived at Sorting Hub                | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |
      | Search by Order Tags      | Order Tags      | PRIOR                                 | {hub-name-18} | {hub-id-18} | Ageing parcels in hub | Ageing Parcels in Hub |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op