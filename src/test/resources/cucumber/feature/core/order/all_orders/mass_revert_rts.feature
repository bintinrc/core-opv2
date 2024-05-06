@OperatorV2 @Core @AllOrders @MassRevertRTS
Feature: All Orders - Mass-Revert RTS

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority @wip
  Scenario: Operator Mass-Revert Single RTS Order
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator Mass-Revert RTS orders on All Orders Page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verifies that info toast displayed:
      | top | Downloading Reverted Tracking IDs ... |
    Then Operator verifies that success toast displayed:
      | top    | 1 RTS Order(s) Reverted             |
      | bottom | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator verify that revert_rts_tracking_ids CSV has correct details:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order V2 page
    When Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | REVERT RTS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                 |
      | description | To Address 1 changed from 233E ST. JOHN'S ROAD to 9 TUA KONG GREEN To Postcode changed from 757995 to 455384 Is RTS changed from true to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                                                          |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 9 TUA KONG GREEN \|\|\|\|455384 Address Type: ADDRESS_TYPE_DELIVERY Zone ID: 22861 Destination Hub ID: 387 Lat, Long: 1.3184395712682, 103.925311276846 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | Elsa Sender                |
      | email   | elsaf@ninja.com            |
      | contact | +6583014912                |
      | address | 9 TUA KONG GREEN 455384 SG |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts        | 0                                  |
      | toAddress1 | 9 TUA KONG GREEN                   |
      | toAddress2 |                                    |
      | toPostcode | 455384                             |
      | toCity     |                                    |
      | toCountry  | SG                                 |
      | toState    |                                    |
      | toName     | Elsa Sender                        |
      | toEmail    | elsaf@ninja.com                    |
      | toContact  | +6583014912                        |
      | toDistrict |                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION.id}               |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | type       | DD                                 |
      | address1   | 9 TUA KONG GREEN                   |
      | address2   | null                               |
      | postcode   | 455384                             |
      | city       | null                               |
      | country    | SG                                 |
      | name       | Elsa Sender                        |
      | email      | elsaf@ninja.com                    |
      | contact    | +6583014912                        |
    When DB Route - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_TRANSACTION.waypointId}          |
      | address1      | 9 TUA KONG GREEN                      |
      | address2      | null                                  |
      | postcode      | 455384                                |
      | city          | null                                  |
      | country       | SG                                    |
      | latitude      | 1.3184395712682                       |
      | longitude     | 103.925311276846                      |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId} |

  @HighPriority
  Scenario: Operator Mass-Revert Multiple RTS Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator Mass-Revert RTS orders on All Orders Page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    Then Operator verifies that info toast displayed:
      | top | Downloading Reverted Tracking IDs ... |
    Then Operator verifies that success toast displayed:
      | top    | 2 RTS Order(s) Reverted                                                 |
      | bottom | KEY_LIST_OF_CREATED_TRACKING_IDS[1],KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator verify that revert_rts_tracking_ids CSV has correct details:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order V2 page
    When Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | REVERT RTS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                 |
      | description | To Address 1 changed from 233E ST. JOHN'S ROAD to 9 TUA KONG GREEN To Postcode changed from 757995 to 455384 Is RTS changed from true to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                                                          |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 9 TUA KONG GREEN \|\|\|\|455384 Address Type: ADDRESS_TYPE_DELIVERY Zone ID: 22861 Destination Hub ID: 387 Lat, Long: 1.3184395712682, 103.925311276846 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | Elsa Sender                |
      | email   | elsaf@ninja.com            |
      | contact | +6583014912                |
      | address | 9 TUA KONG GREEN 455384 SG |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts        | 0                                  |
      | toAddress1 | 9 TUA KONG GREEN                   |
      | toAddress2 |                                    |
      | toPostcode | 455384                             |
      | toCity     |                                    |
      | toCountry  | SG                                 |
      | toState    |                                    |
      | toName     | Elsa Sender                        |
      | toEmail    | elsaf@ninja.com                    |
      | toContact  | +6583014912                        |
      | toDistrict |                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION.id}               |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | type       | DD                                 |
      | address1   | 9 TUA KONG GREEN                   |
      | address2   | null                               |
      | postcode   | 455384                             |
      | city       | null                               |
      | country    | SG                                 |
      | name       | Elsa Sender                        |
      | email      | elsaf@ninja.com                    |
      | contact    | +6583014912                        |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_TRANSACTION.waypointId} |
      | address1      | 9 TUA KONG GREEN             |
      | address2      | null                         |
      | postcode      | 455384                       |
      | city          | null                         |
      | country       | SG                           |
      | latitude      | 1.3184395712682              |
      | longitude     | 103.925311276846             |
      | routingZoneId | not null                     |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order V2 page
    When Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | REVERT RTS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                 |
      | description | To Address 1 changed from 233E ST. JOHN'S ROAD to 9 TUA KONG GREEN To Postcode changed from 757995 to 455384 Is RTS changed from true to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                                                          |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 9 TUA KONG GREEN \|\|\|\|455384 Address Type: ADDRESS_TYPE_DELIVERY Zone ID: 22861 Destination Hub ID: 387 Lat, Long: 1.3184395712682, 103.925311276846 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | Elsa Sender                |
      | email   | elsaf@ninja.com            |
      | contact | +6583014912                |
      | address | 9 TUA KONG GREEN 455384 SG |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts        | 0                                  |
      | toAddress1 | 9 TUA KONG GREEN                   |
      | toAddress2 |                                    |
      | toPostcode | 455384                             |
      | toCity     |                                    |
      | toCountry  | SG                                 |
      | toState    |                                    |
      | toName     | Elsa Sender                        |
      | toEmail    | elsaf@ninja.com                    |
      | toContact  | +6583014912                        |
      | toDistrict |                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION.id}               |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | type       | DD                                 |
      | address1   | 9 TUA KONG GREEN                   |
      | address2   | null                               |
      | postcode   | 455384                             |
      | city       | null                               |
      | country    | SG                                 |
      | name       | Elsa Sender                        |
      | email      | elsaf@ninja.com                    |
      | contact    | +6583014912                        |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_TRANSACTION.waypointId} |
      | address1      | 9 TUA KONG GREEN             |
      | address2      | null                         |
      | postcode      | 455384                       |
      | city          | null                         |
      | country       | SG                           |
      | latitude      | 1.3184395712682              |
      | longitude     | 103.925311276846             |
      | routingZoneId | not null                     |

  @MediumPriority
  Scenario: Operator Mass-Revert Multiple Completed RTS Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[1].id}" with cod collected "false"
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[2].id}" with cod collected "false"
    When Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator Mass-Revert RTS orders on All Orders Page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    Then Operator verifies error messages in dialog on All Orders page:
      | Fail to process {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}: Order is in final state: [GranularStatus:Returned to Sender] |
      | Fail to process {KEY_LIST_OF_CREATED_TRACKING_IDS[2]}: Order is in final state: [GranularStatus:Returned to Sender] |

  @MediumPriority
  Scenario: Operator Mass-Revert Multiple Non-RTS Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And Operator Mass-Revert RTS orders on All Orders Page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    Then Operator verifies error messages in dialog on All Orders page:
      | Fail to process {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}: Order is not currently in RTS |
      | Fail to process {KEY_LIST_OF_CREATED_TRACKING_IDS[2]}: Order is not currently in RTS |

  @HighPriority
  Scenario: Operator Partial Success Mass-Revert Multiple RTS Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator force success order "{KEY_LIST_OF_CREATED_ORDERS[2].id}" with cod collected "false"
    When Operator go to menu Order -> All Orders
    And Operator find multiple orders below by uploading CSV on All Orders page
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And Operator Mass-Revert RTS orders on All Orders Page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId} |
    Then Operator verifies error messages in dialog on All Orders page:
      | Fail to process {KEY_LIST_OF_CREATED_TRACKING_IDS[2]}: Order is in final state: [GranularStatus:Returned to Sender] |
      | Fail to process {KEY_LIST_OF_CREATED_TRACKING_IDS[3]}: Order is not currently in RTS                                |
    When Operator close Errors dialog on All Orders page
    Then Operator verifies that info toast displayed:
      | top | Downloading Reverted Tracking IDs ... |
    Then Operator verifies that success toast displayed:
      | top    | 1 RTS Order(s) Reverted             |
      | bottom | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And Operator verify that revert_rts_tracking_ids CSV has correct details:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order V2 page
    When Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | REVERT RTS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                 |
      | description | To Address 1 changed from 233E ST. JOHN'S ROAD to 9 TUA KONG GREEN To Postcode changed from 757995 to 455384 Is RTS changed from true to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                                                          |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 9 TUA KONG GREEN \|\|\|\|455384 Address Type: ADDRESS_TYPE_DELIVERY Zone ID: 22861 Destination Hub ID: 387 Lat, Long: 1.3184395712682, 103.925311276846 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | Elsa Sender                |
      | email   | elsaf@ninja.com            |
      | contact | +6583014912                |
      | address | 9 TUA KONG GREEN 455384 SG |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts        | 0                                  |
      | toAddress1 | 9 TUA KONG GREEN                   |
      | toAddress2 |                                    |
      | toPostcode | 455384                             |
      | toCity     |                                    |
      | toCountry  | SG                                 |
      | toState    |                                    |
      | toName     | Elsa Sender                        |
      | toEmail    | elsaf@ninja.com                    |
      | toContact  | +6583014912                        |
      | toDistrict |                                    |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION.id}               |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | type       | DD                                 |
      | address1   | 9 TUA KONG GREEN                   |
      | address2   | null                               |
      | postcode   | 455384                             |
      | city       | null                               |
      | country    | SG                                 |
      | name       | Elsa Sender                        |
      | email      | elsaf@ninja.com                    |
      | contact    | +6583014912                        |
    When DB Route - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_TRANSACTION.waypointId}          |
      | address1      | 9 TUA KONG GREEN                      |
      | address2      | null                                  |
      | postcode      | 455384                                |
      | city          | null                                  |
      | country       | SG                                    |
      | latitude      | 1.3184395712682                       |
      | longitude     | 103.925311276846                      |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId} |
