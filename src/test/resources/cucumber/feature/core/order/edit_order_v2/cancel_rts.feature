@OperatorV2 @Core @EditOrderV2 @CancelRTS
Feature: Cancel RTS

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path
  Scenario: Operator Cancel RTS from Edit Order Page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Return to sender -> Cancel RTS on Edit Order V2 page
    And Operator cancel RTS on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top                | The RTS has been cancelled |
      | waitUntilInvisible | true                       |
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order V2 page
    When Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | REVERT RTS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                 |
      | description | To Address 1 changed from 233E ST. JOHN'S ROAD to 9 TUA KONG GREEN To Postcode changed from 757995 to 455384 Is RTS changed from true to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                      |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 9 TUA KONG GREEN \|\|\|\|455384 Zone ID: 22861 Destination Hub ID: 387 Lat, Long: 1.3184395712682, 103.925311276846 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |
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
    When DB Core - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    And DB Core - verify waypoints record:
      | id            | {KEY_TRANSACTION.waypointId}          |
      | address1      | 9 TUA KONG GREEN                      |
      | address2      | null                                  |
      | postcode      | 455384                                |
      | city          | null                                  |
      | country       | SG                                    |
      | latitude      | 1.3184395712682                       |
      | longitude     | 103.925311276846                      |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId} |