@Sort @Utilities @BulkAddressVerificationPart1
Feature: Bulk Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk AV RTS orders - RTS zone exist
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[4].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[5].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk multiple address CSV using data below:
      | method                     | waypoint                                                   | toAddress1                                 | latitude        | longitude       |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[3].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[4].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[5].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[5].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
    And Operator verifies waypoints are assigned to "RTS" rack sector upon bulk address verification
    Then Operator clicks Update successful matched on Bulk Address Verification page
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[3].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[4].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[5].id}"

  Scenario: Bulk AV RTS orders - RTS zone doesn't exist
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
   And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[4].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[5].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk multiple address CSV using data below:
      | method                     | waypoint                                                   | toAddress1                                 | latitude    | longitude   |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} | FROM_CONFIG | FROM_CONFIG |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} | FROM_CONFIG | FROM_CONFIG |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[3].toAddress1} | FROM_CONFIG | FROM_CONFIG |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[4].toAddress1} | FROM_CONFIG | FROM_CONFIG |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[5].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[5].toAddress1} | FROM_CONFIG | FROM_CONFIG |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator clicks Update successful matched on Bulk Address Verification page
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[3].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[4].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[5].id}"

  Scenario: Bulk AV RTS orders - Zone is NULL
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
   And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[4].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[5].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk multiple address CSV using data below:
      | method                     | waypoint                                                   | toAddress1                                 | latitude        | longitude       |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} | FROM_CONFIG_OOZ | FROM_CONFIG_OOZ |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} | FROM_CONFIG_OOZ | FROM_CONFIG_OOZ |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[3].toAddress1} | FROM_CONFIG_OOZ | FROM_CONFIG_OOZ |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[4].toAddress1} | FROM_CONFIG_OOZ | FROM_CONFIG_OOZ |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[5].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[5].toAddress1} | FROM_CONFIG_OOZ | FROM_CONFIG_OOZ |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator clicks Update successful matched on Bulk Address Verification page
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[3].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[4].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[5].id}"

  Scenario: Bulk AV Non RTS orders - RTS zone exist
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
   And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk multiple address CSV using data below:
      | method                     | waypoint                                                   | toAddress1                                 | latitude        | longitude       |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[3].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[4].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[5].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[5].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator clicks Update successful matched on Bulk Address Verification page
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[3].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[4].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[5].id}"

  Scenario: Bulk AV Non RTS orders - RTS zone doesn't exist
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
   And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk multiple address CSV using data below:
      | method                     | waypoint                                                   | toAddress1                                 | latitude    | longitude   |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} | FROM_CONFIG | FROM_CONFIG |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} | FROM_CONFIG | FROM_CONFIG |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[3].toAddress1} | FROM_CONFIG | FROM_CONFIG |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[4].toAddress1} | FROM_CONFIG | FROM_CONFIG |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[5].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[5].toAddress1} | FROM_CONFIG | FROM_CONFIG |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator clicks Update successful matched on Bulk Address Verification page
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[3].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[4].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[5].id}"

  Scenario: Bulk AV Non RTS orders - Zone is NULL
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
   And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk multiple address CSV using data below:
      | method                     | waypoint                                                   | toAddress1                                 | latitude        | longitude       |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} | FROM_CONFIG_OOZ | FROM_CONFIG_OOZ |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} | FROM_CONFIG_OOZ | FROM_CONFIG_OOZ |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[3].toAddress1} | FROM_CONFIG_OOZ | FROM_CONFIG_OOZ |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[4].toAddress1} | FROM_CONFIG_OOZ | FROM_CONFIG_OOZ |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[5].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[5].toAddress1} | FROM_CONFIG_OOZ | FROM_CONFIG_OOZ |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator clicks Update successful matched on Bulk Address Verification page
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[3].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[4].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[5].id}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op