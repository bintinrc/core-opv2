@StationManagement @StationHome @PriorityParcelInHub
Feature: Priority Parcel in Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder
  Scenario Outline: View Priority Parcel in Hub (uid:4e760809-5688-407c-83c5-32f2fe53e368)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID/ Route ID |
      | Address               |
      | Granular Status       |
      | Order Tags            |
      | Size                  |
      | Timeslot              |
      | Committed ETA         |
      | Recovery Ticket Type  |
      | Ticket Status         |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           | Order Tags |
      | {KEY_CREATED_ORDER_TRACKING_ID} | PRIOR      |
    And Operator verifies that Edit Order page is opened on clicking tracking id

    Examples:
      | HubName      | TileName                | ModalName               |
      | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Priority Parcel in Hub by Tracking ID (uid:0b167e79-c711-4a02-a135-ca97ac6b6ac9)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
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
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |

    Examples:
      | HubName      | TileName                | ModalName               |
      | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Unlisted Priority Parcel in Hub by Tracking ID (uid:5a7fa32f-0149-49eb-a847-f79aedebf3c8)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
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
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID |
      | <TrackingId>          |

    Examples:
      | HubName      | TileName                | ModalName               | TrackingId  |
      | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub | UNLISTED_ID |

  @ForceSuccessOrder @ArchiveRoute
  Scenario Outline: Search Priority Parcel in Hub by Route ID (uid:8bb1be40-27c4-4712-a33f-1ec350361401)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
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
      | Tracking ID/ Route ID  |
      | {KEY_CREATED_ROUTE_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\nRoute ID: {KEY_CREATED_ROUTE_ID} |

    Examples:
      | HubId      | HubName      | TileName                | ModalName               |
      | {hub-id-8} | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Priority Parcel in Hub by Address (uid:13a0e3d0-5879-48f0-958c-91302cedf212)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator saves to address used in the parcel in the key
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
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
      | Tracking ID/ Route ID           | Address                                |
      | {KEY_CREATED_ORDER_TRACKING_ID} | {KEY_COMMA_DELIMITED_ORDER_TO_ADDRESS} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n-     |
      | Address               | {KEY_COMMA_DELIMITED_ORDER_TO_ADDRESS} |

    Examples:
      | HubName      | TileName                | ModalName               |
      | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Unlisted Priority Parcel in Hub by Address (uid:843e3f04-1971-4ca0-bcab-bd908cfa4ab2)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator saves to address used in the parcel in the key
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
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
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID           | Address   |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <Address> |

    Examples:
      | HubName      | TileName                | ModalName               | Address         |
      | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub | UnlistedAddress |

  @ForceSuccessOrder
  Scenario Outline: Search Priority Parcel in Hub by Granular Status (uid:4480b84e-2cf9-40a2-b52a-9caf02a0720a)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator saves to address used in the parcel in the key
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
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
      | Tracking ID/ Route ID           | Granular Status  |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <GranularStatus> |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |
      | Granular Status       | <GranularStatus>                   |

    Examples:
      | HubName      | TileName                | ModalName               | GranularStatus         |
      | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub | Arrived at Sorting Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Priority Parcel in Hub by Size (uid:26f7e683-9b6d-4136-af89-a9875c5f46ab)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"<SizeShortForm>", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
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
    And Operator selects the following values in the modal pop up
      | Size | <Size> |
    And Operator verifies that the following details are displayed on the modal
      | Size | <Size> |

    Examples:
      | SizeShortForm | Size  | HubName      | TileName                | ModalName               |
      | S             | Small | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Priority Parcel in Hub by Timeslot (uid:083e8984-56d1-4f1e-8936-b52273e433ef)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"<StartHour>:00", "end_time":"<EndHour>:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
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
    And Operator selects the following values in the modal pop up
      | Timeslot | <StartHour>00 - <EndHour>00 |
    And Operator verifies that the following details are displayed on the modal
      | Timeslot | <StartHour>00 - <EndHour>00 |

    Examples:
      | HubName      | StartHour | EndHour | TileName                | ModalName               |
      | {hub-name-8} | 09        | 22      | Priority parcels in hub | Priority Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Priority Parcel in Hub by Committed ETA (uid:6f558855-a826-4a48-81c6-c30849141e7a)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalName>" if it is displayed on the page
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalName>" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator get sfld ticket count for the priority parcels
    And Operator clicks the alarm button to view parcels with sfld tickets
    Then Operator verifies that a table is displayed with following columns:
      | Tracking ID           |
      | Address               |
      | ETA Calculated        |
      | Station Confirmed ETA |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator confirms that station confirmed eta field is empty
    And Operators chooses the date:"{gradle-next-2-day-yyyy-MM-dd}" as station confirmed eta and proceed
    And Operators verifies that the toast message: "<ToastMessage>" has displayed
    And Operator verifies that the sfld ticket count has decreased by 1
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
    And Operator selects the following values in the modal pop up
      | Committed ETA | {gradle-next-2-day-yyyy-MM-dd} |
    And Operator verifies that the following details are displayed on the modal
      | Committed ETA | {gradle-next-2-day-yyyy-MM-dd} |

    Examples:
      | HubName      | TileName                | ModalName               | FSRModalName                                 | ToastMessage                     |
      | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub | Please Confirm ETA of FSR Parcels to Proceed | Successfully confirmed 1 ETA(s)! |

  @ForceSuccessOrder
  Scenario Outline: Search Priority Parcel in Hub by Recovery Ticket Type (uid:aaae82b8-355e-4081-81d6-43f6b6a1f1e7)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"<SizeShortForm>", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | XMAS CAGE          |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
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
    And Operator selects the following values in the modal pop up
      | Recovery Ticket Type | <TicketType> |
    And Operator verifies that the following details are displayed on the modal
      | Recovery Ticket Type | <TicketType> |

    Examples:
      | TicketType    | TicketSubType    | HubName      | TileName                | ModalName               |
      | SHIPPER ISSUE | DUPLICATE PARCEL | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Search Priority Parcel in Hub by Ticket Status (uid:ee55364a-d65e-4655-b037-f7915e243edb)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"<SizeShortForm>", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | XMAS CAGE          |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
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
    And Operator selects the following values in the modal pop up
      | Recovery Ticket Type | <TicketType>   |
      | Ticket Status        | <TicketStatus> |
    And Operator verifies that the following details are displayed on the modal
      | Recovery Ticket Type | <TicketType>   |
      | Ticket Status        | <TicketStatus> |

    Examples:
      | HubName      | TicketType    | TicketSubType    | TicketStatus | TileName                | ModalName               |
      | {hub-name-8} | SHIPPER ISSUE | DUPLICATE PARCEL | CREATED      | Priority parcels in hub | Priority Parcels in Hub |

  @ForceSuccessOrder
  Scenario Outline: Sort Priority Parcel in Hub Based on Size (uid:ec1a8d72-07d5-4376-b2ab-286b240c5ba9)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
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
    And Operators sorts and verifies that the column:"<ColumnName>" is in ascending order
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |

    Examples:
      | HubName      | TileName                | ModalName               | ColumnName |
      | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub | Size       |

  @ForceSuccessOrder
  Scenario Outline: Can Not View Untagged Priority Parcel in Hub (uid:059c175f-842b-4f9a-bea0-0d7b02039fb6)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | <TagId> |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName1>" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName2>" through hamburger button for the tile: "<TileName>"
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
    And Operator verifies that the following details are displayed on the modal
      | Committed ETA | - |
    When API Operator delete order tag with id: <TagId> from the created order
    Then Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName1>" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName2>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName      | TileName                | TagId | ModalName1                                   | ModalName2              | SlackMessageContent |
      | {hub-name-8} | Priority parcels in hub | 5570  | Please Confirm ETA of FSR Parcels to Proceed | Priority Parcels in Hub | GENERATED           |

  @ForceSuccessOrder
  Scenario Outline: View Priority Parcel in Hub of Unacknowledged SLFD Parcel (uid:f748e580-5089-4003-bdee-b9cfaa06e8ff)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    When API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName1>" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName2>" through hamburger button for the tile: "<TileName>"
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
    And Operator verifies that the following details are displayed on the modal
      | Committed ETA | - |
    And Operator verifies that Edit Order page is opened on clicking tracking id

    Examples:
      | HubName      | TileName                | ModalName1                                   | ModalName2              | SlackMessageContent |
      | {hub-name-8} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | Priority Parcels in Hub | GENERATED           |

  @ForceSuccessOrder
  Scenario Outline: View Priority Parcel in Hub of Acknowledged SLFD Parcel (uid:1d024335-8032-4efb-b82a-c9b6bf14e387)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    When API Operator tags the parcel as SFLD parcel using below data:
      | sfldRequest | {"order_id": {KEY_CREATED_ORDER_ID}, "system_id": "sg", "suggested_etas": ["{gradle-next-1-day-yyyy-MM-dd}", "{gradle-next-2-day-yyyy-MM-dd}"], "sfld_slack_notification": {"slack_channel_id": "uat-sg-fss", "slack_message_title": "Test executed on-{gradle-current-date-yyyy-MM-dd}", "slack_message_content": "<SlackMessageContent>"}} |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName1>" if it is displayed on the page
    And Operator clicks the alarm button to view parcels with sfld tickets
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd}  |
    And Operator confirms that station confirmed eta field is empty
    And Operators chooses the date:"{gradle-next-2-day-yyyy-MM-dd}" as station confirmed eta and proceed
    And Operators verifies that the toast message: "<ToastMessage>" has displayed
    And Operator opens modal pop-up: "<ModalName2>" through hamburger button for the tile: "<TileName>"
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
    Then Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Committed ETA | {gradle-next-2-day-yyyy-MM-dd} |
    And Operator verifies that Edit Order page is opened on clicking tracking id

    Examples:
      | HubName      | TileName                | ModalName1                                   | ModalName2              | SlackMessageContent | ToastMessage                     |
      | {hub-name-8} | Priority parcels in hub | Please Confirm ETA of FSR Parcels to Proceed | Priority Parcels in Hub | GENERATED           | Successfully confirmed 1 ETA(s)! |

  @ForceSuccessOrder
  Scenario Outline: View Priority Parcel of Pending Ticket Status (uid:8fa5f052-59e4-4154-819b-718d4d891984)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | XMAS CAGE          |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator verify ticket is created successfully on page Recovery Tickets
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    And Operator verifies that the following details are displayed on the modal
      | Recovery Ticket Type | <TicketType> |
      | Ticket Status        | <Status>     |

    Examples:
      | HubName      | TicketType    | TicketSubType    | Status  | HubName      | TileName                | ModalName               | FSRModalTitle                                |
      | {hub-name-8} | SHIPPER ISSUE | DUPLICATE PARCEL | CREATED | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder
  Scenario Outline: View Priority Parcel of In Progress Ticket Status (uid:9300f0ce-bdd6-4698-a794-3bddc5ee4a38)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | XMAS CAGE          |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    And Operator verifies that the following details are displayed on the modal
      | Recovery Ticket Type | <TicketType> |
      | Ticket Status        | <Status>     |

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome | Status      | TileName                | ModalName               | FSRModalTitle                                |
      | {hub-name-8} | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | IN PROGRESS | Priority parcels in hub | Priority Parcels in Hub | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder
  Scenario Outline: View Priority Parcel of On Hold Ticket Status (uid:7e86bf11-0b25-42e1-baae-a875220d9fa5)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | XMAS CAGE          |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    And Operator verifies that the following details are displayed on the modal
      | Recovery Ticket Type | <TicketType> |
      | Ticket Status        | <Status>     |

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome | Status  | TileName                | ModalName               | FSRModalTitle                                |
      | {hub-name-8} | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | ON HOLD | Priority parcels in hub | Priority Parcels in Hub | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder
  Scenario Outline: Filter Parcels by Committed ETA (uid:c3b04170-37eb-4f15-9597-41f22ef4521a)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
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
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<ModalName1>" if it is displayed on the page
    And Operator clicks the alarm button to view parcels with sfld tickets
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | ETA Calculated | {gradle-next-1-day-yyyy-MM-dd}  |
    And Operator confirms that station confirmed eta field is empty
    And Operators chooses the date:"{gradle-next-2-day-yyyy-MM-dd}" as station confirmed eta and proceed
    And Operators verifies that the toast message: "<ToastMessage>" has displayed
    And Operator opens modal pop-up: "<ModalName2>" through hamburger button for the tile: "<TileName>"
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
    When Operator applies filter as "<Filter>" from quick filters option
    Then Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |
      | Committed ETA         | {gradle-next-2-day-yyyy-MM-dd}     |

    Examples:
      | HubName      | TileName                | Filter        | ModalName1                                   | ModalName2              | SlackMessageContent | ToastMessage                     |
      | {hub-name-8} | Priority parcels in hub | Committed ETA | Please Confirm ETA of FSR Parcels to Proceed | Priority Parcels in Hub | GENERATED           | Successfully confirmed 1 ETA(s)! |

  @ForceSuccessOrder
  Scenario Outline: Filter Parcels by Routed (uid:cb324815-cf07-45fa-9dd6-416d934eea1f)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    When Operator applies filter as "<Filter>" from quick filters option
    Then Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID  |
      | {KEY_CREATED_ROUTE_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\nRoute ID: {KEY_CREATED_ROUTE_ID} |

    Examples:
      | HubId      | HubName      | HubName      | TileName                | ModalName               | Filter | FSRModalTitle                                |
      | {hub-id-8} | {hub-name-8} | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub | Routed | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder
  Scenario Outline: Filter Parcels by Unrouted (uid:01408032-d8ea-4259-a3fa-12b7edfd7c7b)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    When Operator applies filter as "<Filter>" from quick filters option
    Then Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |

    Examples:
      | HubName      | HubName      | TileName                | ModalName               | Filter   | FSRModalTitle                                |
      | {hub-name-8} | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub | Unrouted | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder
  Scenario Outline: View Priority Parcel of Pending Shipper Ticket Status (uid:5cbabffd-dd14-4604-905b-191cfb44e93f)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    And Operator verifies that the following details are displayed on the modal
      | Recovery Ticket Type | <TicketType> |
      | Ticket Status        | <Status>     |

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome | Status          | TileName                | ModalName               | FSRModalTitle                                |
      | {hub-name-8} | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | PENDING SHIPPER | Priority parcels in hub | Priority Parcels in Hub | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder
  Scenario Outline: View Priority Parcel of Cancelled Ticket Status (uid:6f86c722-3500-4d45-97d1-2f39d899476b)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status          | <Status>       |
      | outcome         | <OrderOutcome> |
      | assignTo        | NikoSusanto    |
      | newInstructions | GENERATED      |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    Then Operator verifies that a table is displayed with following columns:
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
    And Operator verifies that the following details are displayed on the modal
      | Recovery Ticket Type | <TicketType> |
      | Ticket Status        | <Status>     |

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome | Status    | TileName                | ModalName               | FSRModalTitle                                |
      | {hub-name-8} | SHIPPER ISSUE | DUPLICATE PARCEL | XMAS CAGE    | CANCELLED | Priority parcels in hub | Priority Parcels in Hub | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder
  Scenario Outline: View Priority Parcel of Resolved Ticket Status (uid:7d43c915-de6d-4804-a372-d73fff9b33dc)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                 | CUSTOMER COMPLAINT |
      | investigatingDepartment     | Fleet (First Mile) |
      | investigatingHub            | <HubName>          |
      | ticketType                  | <TicketType>       |
      | ticketSubType               | <TicketSubType>    |
      | orderOutcomeDuplicateParcel | <OrderOutcome>     |
      | issueDescription            | GENERATED          |
      | custZendeskId               | 1                  |
      | shipperZendeskId            | 1                  |
      | ticketNotes                 | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | outcome                 | <OrderOutcome>            |
      | assignTo                | NikoSusanto               |
      | newInstructions         | GENERATED                 |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    Then Operator verifies that a table is displayed with following columns:
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
    And Operator verifies that the following details are displayed on the modal
      | Recovery Ticket Type | <TicketType> |
      | Ticket Status        | <Status>     |

    Examples:
      | HubName      | TicketType    | TicketSubType    | OrderOutcome                | Status   | KeepCurrentOrderOutcome | TileName                | ModalName               | FSRModalTitle                                |
      | {hub-name-8} | SHIPPER ISSUE | DUPLICATE PARCEL | REPACKED/RELABELLED TO SEND | RESOLVED | No                      | Priority parcels in hub | Priority Parcels in Hub | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder
  Scenario Outline: View Priority Parcel of Missing Ticket Type (uid:05e8d756-57f8-48bc-aa3a-f3b35c67d41d)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | <HubName>          |
      | ticketType              | <TicketType>       |
      | orderOutcomeMissing     | <OrderOutcome>     |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator updates recovery ticket on Edit Order page:
      | status                  | <Status>                  |
      | outcome                 | <OrderOutcome>            |
      | keepCurrentOrderOutcome | <KeepCurrentOrderOutcome> |
      | assignTo                | NikoSusanto               |
      | newInstructions         | GENERATED                 |
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    Then Operator verifies that a table is displayed with following columns:
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
    And Operator verifies that the following details are displayed on the modal
      | Recovery Ticket Type | <TicketType> |
      | Ticket Status        | <Status>     |

    Examples:
      | HubName      | TicketType | OrderOutcome    | Status   | KeepCurrentOrderOutcome | TileName                | ModalName               | FSRModalTitle                                |
      | {hub-name-8} | MISSING    | FOUND - INBOUND | RESOLVED | No                      | Priority parcels in hub | Priority Parcels in Hub | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder
  Scenario Outline: [SG] Filter Parcels by Late If Inbound After Cut Off Time (uid:dcd4bf2f-37c5-4ea1-81f6-276ecf2ed1e0)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    And DB Operators updates the column value: inbounded_into_hub_at as "<HubInboundedAt>" of parcel table in station db
    Then Operator applies filter as "<Filter>" from quick filters option
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |

    Examples:
      | HubName      | HubName      | TileName                | ModalName               | Filter | HubInboundedAt                              | FSRModalTitle                                |
      | {hub-name-8} | {hub-name-8} | Priority parcels in hub | Priority Parcels in Hub | Late   | {gradle-previous-2-day-yyyy-MM-dd} 20:00:00 | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder @SystemIdNotSg @default-id
  Scenario Outline: [ID] Filter Parcels by Late If Inbound After Cut Off Time (uid:c13a5cae-9218-4a08-8cbc-cdfa2466862e)
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"STANDARD","from": {"name": "QA-STATION-TEST-FROM","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-STATION-TEST-TO","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": 100,"insured_value": 85000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 172 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    And DB Operators updates the column value: inbounded_into_hub_at as "<HubInboundedAt>" of parcel table in station db
    And Operator applies filter as "<Filter>" from quick filters option
    Then Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |

    Examples:
      | Country   | HubName      | TileName                | ModalName               | Filter | HubInboundedAt                              | FSRModalTitle                                |
      | Indonesia | {hub-name-1} | Priority parcels in hub | Priority Parcels in Hub | Late   | {gradle-previous-2-day-yyyy-MM-dd} 18:00:00 | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder @SystemIdNotSg @default-my
  Scenario Outline: [MY] Filter Parcels by Late If Inbound After Cut Off Time (uid:f2a0396a-9888-4a2a-bb2e-a91340598875)
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 2 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    And DB Operators updates the column value: inbounded_into_hub_at as "<HubInboundedAt>" of parcel table in station db
    And Operator applies filter as "<Filter>" from quick filters option
    Then Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |

    Examples:
      | Country  | HubName      | TileName                | ModalName               | Filter | HubInboundedAt                              | FSRModalTitle                                |
      | Malaysia | {hub-name-1} | Priority parcels in hub | Priority Parcels in Hub | Late   | {gradle-previous-2-day-yyyy-MM-dd} 14:00:00 | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder @SystemIdNotSg @default-th
  Scenario Outline: [TH] Filter Parcels by Late If Inbound After Cut Off Time (uid:14d90b36-be01-4cd6-b4e3-5b87743906a5)
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-th-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {station-th-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "AUTO-STATION-FROM","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "11/1 Soi Samsen 3 Samsen Road, Wat Samphraya, Phranakhon","address2": "","country": "TH","postcode": "10200"}},"to": {"name": "AUTO-STATION-TO","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1": "10 Soi Siri Ammat, Boonsiri Road San Chao Pho Sua, Phanakon","address2": "","country": "TH","postcode": "10200"}},"parcel_job":{"cash_on_delivery": 40,"insured_value": 85, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 2 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    And DB Operators updates the column value: inbounded_into_hub_at as "<HubInboundedAt>" of parcel table in station db
    And Operator applies filter as "<Filter>" from quick filters option
    Then Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |

    Examples:
      | Country  | HubName      | TileName                | ModalName               | Filter | HubInboundedAt                              | FSRModalTitle                                |
      | Thailand | {hub-name-1} | Priority parcels in hub | Priority Parcels in Hub | Late   | {gradle-previous-2-day-yyyy-MM-dd} 23:59:00 | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder @SystemIdNotSg @default-ph
  Scenario Outline: [PH] Filter Parcels by Late If Inbound After Cut Off Time (uid:93e0e1fc-9e37-43ea-8e70-008097a66428)
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-ph-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {station-ph-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "AUTO-STATION-FROM","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "Quezon Ave, Santa Cruz, 4009 Laguna, Philippines","address2": "","country": "PH","postcode": "4009"}},"to": {"name": "AUTO-STATION-TO","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1": "Emilio Aguinaldo Highway, By Pass Road, Tubuan 2, Silang, 4118 Cavite, Philippines","address2": "","country": "PH","postcode": "4118"}},"parcel_job":{"cash_on_delivery": 40,"insured_value": 85, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 2 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    And DB Operators updates the column value: inbounded_into_hub_at as "<HubInboundedAt>" of parcel table in station db
    And Operator applies filter as "<Filter>" from quick filters option
    Then Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |

    Examples:
      | Country     | HubName      | TileName                | ModalName               | Filter | HubInboundedAt                              | FSRModalTitle                                |
      | Philippines | {hub-name-1} | Priority parcels in hub | Priority Parcels in Hub | Late   | {gradle-previous-2-day-yyyy-MM-dd} 14:00:00 | Please Confirm ETA of FSR Parcels to Proceed |

  @ForceSuccessOrder @SystemIdNotSg @default-vn
  Scenario Outline: [VN] Filter Parcels by Late If Inbound After Cut Off Time (uid:7c0e04c7-faf1-4fd8-88ab-e4abff58b4d6)
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | shipperClientId     | {station-vn-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {station-vn-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"STANDARD", "from": {"name": "AUTO-STATION-FROM","phone_number": "+6087689827","email": "recipientV4@nvqa.co","address": {"address1": "19 - 23 Lam Son Square, District 1, Ho Chi Minh City","address2": "","country": "VN","postcode": "1440","latitude": 21.01028637,"longitude": 105.81}},"to": {"name": "AUTO-STATION-TO","phone_number": "+60123456798","email": "recipientV4@nvqa.co","address": {"address1": "19 - 23 Lam Son Square, District 1, Ho Chi Minh City","address2": "","country": "VN","postcode": "1440","latitude": 21.01028637,"longitude": 105.81}},"parcel_job":{"cash_on_delivery": 40000,"insured_value": 85000, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"weight": 0.4,"height": 2,"width": 2,"length": 5,"size": "S"},"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 4 |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator closes the modal: "<FSRModalTitle>" if it is displayed on the page
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
    And DB Operators updates the column value: inbounded_into_hub_at as "<HubInboundedAt>" of parcel table in station db
    And Operator applies filter as "<Filter>" from quick filters option
    Then Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID/ Route ID           |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator verifies that the following details are displayed on the modal
      | Tracking ID/ Route ID | {KEY_CREATED_ORDER_TRACKING_ID}\n- |

    Examples:
      | Country | HubName      | TileName                | ModalName               | Filter | HubInboundedAt                              | FSRModalTitle                                |
      | Vietnam | {hub-name-1} | Priority parcels in hub | Priority Parcels in Hub | Late   | {gradle-previous-2-day-yyyy-MM-dd} 14:00:00 | Please Confirm ETA of FSR Parcels to Proceed |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op