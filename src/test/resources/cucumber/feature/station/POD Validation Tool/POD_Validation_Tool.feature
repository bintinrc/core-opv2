@StationManagement @StationPODValidation
Feature: POD Validation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Refresh POD Details Page While User Validates Less Than 5 PODs
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[3].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator refresh page
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Refresh POD Details Page While User Validates More Than 5 PODs
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[4]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[5]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[4].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[5].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[4].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[5].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[5].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[5].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[5].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[5].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[5].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator refresh page
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Resume Validating Remaining Task Given Filter has Less Than 5 PODs
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[3].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "Valid" button
    When Operator click "Valid" button
    And Operator waits for 5 seconds
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "Resume Validating" button
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt?role=validator"


    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validator End Session and Unassign Task
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator waits for 5 seconds
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "End Session" button
    Then Operator validates current URL ends with "validate-attempt?role=validator"
    Then DB Station - Operator verifies that row with taskId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" is deleted in the assignments table


    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD using Normal Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE    |
      | invalidReasonId | 29         |
      | type            | VALIDATION |
    Then DB Station - Operator verifies that the validator count "1" is updated in the tasks table for the tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator validates current URL ends with "validate-attempt/completed"
    When Operator click "Back to filter" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |


  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD using Normal Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "Valid" button
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | SUCCESS |
      | invalidReasonId | NULL    |
      | type            | type    |
    Then DB Station - Operator verifies that the validator count "1" is updated in the tasks table for the tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator validates current URL ends with "validate-attempt/completed"
    When Operator click "Back to filter" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD Failed Delivery Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 11                                                                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}            |
      | failureReason     | I had insufficient time to complete all my deliveries |
      | transactionStatus | FAIL                                                  |
      | attemptDateTime   | {date: 0 days next, YYYY-MM-dd}                       |
      | cod               | No                                                    |
      | shipperName       | {shipper-v4-name}                                     |
      | latitude          | <latitude>                                            |
      | longitude         | <longitude>                                           |
#      | distanceFromWaypoint | type                                       |
      | address1          | <address1>                                            |
      | address2          | <address2>                                            |
      | postcode          | <postcode>                                            |
      | phone             | <phone>                                               |
      | relationship      | -                                                     |
      | code              | -                                                     |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "Valid" button
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | SUCCESS    |
      | invalidReasonId | NULL       |
      | type            | VALIDATION |
    Then DB Station - Operator verifies that the validator count "1" is updated in the tasks table for the tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD Success Pickup Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                          |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobType    | RESERVATION                                                                                                               |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | -                                          |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | -                                          |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator click "Valid" button
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | SUCCESS |
      | invalidReasonId | NULL    |
      | type            | type    |
    Then DB Station - Operator verifies that the validator count "1" is updated in the tasks table for the tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |


  Scenario: Download POD Validation Report and View Audit Detail
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Download Validation Reports
    When Operator selects the date time range based on below data:
      | startDate | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate   | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
    When Operator click "Download Report" button
    And Verify that csv file is downloaded with filename: "Download_Validation_Report.csv"
    Then Operator verifies header names are available in the downloaded CSV file "Download_Validation_Report"
      | TaskID            |
      | JobID             |
      | JobType           |
      | AttemptedAt       |
      | HubID             |
      | FailureReasonId   |
      | DriverID          |
      | ShipperIDs        |
      | ShipperNames      |
      | ParentShipperIDs  |
      | OrderIds          |
      | TrackingIds       |
      | ValidatorId       |
      | ValidatorEmail    |
      | ValidatorValidity |
      | ValidatorReason   |
      | ValidationTime    |
      | AuditorId         |
      | AuditorEmail      |
      | AuditorValidity   |
      | AuditorReason     |
      | AuditTime         |
      | ValidationMatches |
      | AppealReasonId    |
      | AppealReason      |
      | AppealInfo        |
      | AppealUpdatedAt   |
      | ReviewerId        |
      | ReviewerEmail     |
      | ReviewerValidity  |
      | ReviewerReason    |
      | ReviewTime        |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Productivity Count
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[4]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    When Operator get the count from the attempts validated today
    When Operator click "Valid" button
    Then Operator verifies that the count in attempts validated today has increased by 1
    When Operator get the count from the attempts validated today
    When Operator click "Valid" button
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[2].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                      |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
      | jobType    | RESERVATION                                                                           |
      | jobAction  | SUCCESS                                                                               |
      | jobMode    | PICK_UP                                                                               |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                      |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
      | jobType    | RESERVATION                                                                           |
      | jobAction  | SUCCESS                                                                               |
      | jobMode    | PICK_UP                                                                               |
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[4].trackingId} |
    When Operator get the count from the attempts validated today
    When Operator click "Valid" button
    Then Operator verifies that the count in attempts validated today has increased by 1
    When Operator get the count from the attempts validated today
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Unassign POD Tasks from Validator After 3 Hours
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When Station DB - operator updates the UpdatedAt "{date: 11 hours ago, yyyy-MM-dd hh:mm:ss}" for the trackingId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the POD assignment table
    Then DB Station - Operator verifies that the validator count "1" is updated in the tasks table for the tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When API Station - Operator calls unassigned task cron job to remove unassigned Pod task
    When Operator waits for 10 seconds
    Then DB Station - Operator verifies that row with taskId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" is deleted in the assignments table
    Then DB Station - Operator verifies that the validator count "0" is updated in the tasks table for the tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |


  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validated Task is not Appear when Filtering
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job              | Delivery Job                             |
      | status           | Success                                  |
      | startDate        | {date: 1 days ago, YYYY-MM-dd} 00:00:00  |
      | endDate          | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub              | <HubName>                                |
      | driverName       | <driverName>                             |
      | masterShipperIds | 2121222                                  |
    Then Operator validate the error code and error details
      | statusCode | Status 404: Not Found                                                   |
      | url        | https://api-qa.ninjavan.co/sg/pod-validation/1.0/assignments/validation |
      | message    | There are no matching tasks for the selected filters.                   |
    When Operator closes the notification message
    When Operator filters the PODs based on trackingIds
      | trackingIds | SDGSDG7676S78DG |
    Then Operator validate the error code and error details
      | statusCode | Status 404: Not Found                                                                  |
      | url        | https://api-qa.ninjavan.co/sg/pod-validation/1.0/assignments/validation                |
      | message    | There are no matching tasks for the given list of TIDs [TrackingIDs:[SDGSDG7676S78DG]] |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |


  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Reservation POD of Normal Order with COD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP","cash_on_delivery": 100, "is_pickup_required": true, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                          |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobType    | RESERVATION                                                                                                               |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | attemptDateTime   | {date: 0 days next, YYYY-MM-dd}            |
      | cod               | No                                         |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Reservation POD of Normal Order without COD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                          |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobType    | RESERVATION                                                                                                               |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | attemptDateTime   | {date: 0 days next, YYYY-MM-dd}            |
      | cod               | No                                         |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Delivery POD of Normal Order with COD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP","cash_on_delivery": 100, "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                             |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","action": "SUCCESS","cod":100}] |
      | routes     | KEY_DRIVER_ROUTES                                                                              |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | attemptDateTime   | {date: 0 days next, YYYY-MM-dd}            |
      | cod               | Yes                                        |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Delivery POD of Normal Order without COD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | attemptDateTime   | {date: 0 days next, YYYY-MM-dd}            |
      | cod               | No                                         |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Pickup POD of Return Order with COP
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP","cash_on_delivery": 100, "is_pickup_required": true, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                             |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                               |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","cod":100,"action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                              |
      | jobType    | RESERVATION                                                                                    |
      | jobAction  | SUCCESS                                                                                        |
      | jobMode    | PICK_UP                                                                                        |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | attemptDateTime   | {date: 0 days next, YYYY-MM-dd}            |
      | cod               | Yes                                        |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Pickup POD of Return Order without COP
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                   |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                    |
      | jobType    | RESERVATION                                                                          |
      | jobAction  | SUCCESS                                                                              |
      | jobMode    | PICK_UP                                                                              |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | attemptDateTime   | {date: 0 days next, YYYY-MM-dd}            |
      | cod               | No                                         |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Delivery POD of Return Order with COP
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP","cash_on_delivery": 100, "is_pickup_required": true, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                              |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                      |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","cod":100, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                               |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | attemptDateTime   | {date: 0 days next, YYYY-MM-dd}            |
      | cod               | No                                         |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Delivery POD of Return Order without COP
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                   |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                           |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                    |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | attemptDateTime   | {date: 0 days next, YYYY-MM-dd}            |
      | cod               | No                                         |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Success Delivery Job
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | distanceFromWaypoint                       |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Failed Delivery Job
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 11                                                                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job           | Delivery Job                                          |
      | status        | Fail                                                  |
      | failureReason | I had insufficient time to complete all my deliveries |
      | startDate     | {date: 0 days next, YYYY-MM-dd} 00:00:00              |
      | endDate       | {date: 0 days next, YYYY-MM-dd} 23:59:07              |
      | hub           | <HubName>                                             |
      | driverName    | <driverName>                                          |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}            |
      | failureReason        | I had insufficient time to complete all my deliveries |
      | transactionStatus    | FAIL                                                  |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}                       |
      | cod                  | No                                                    |
      | shipperName          | {shipper-v4-name}                                     |
      | latitude             | <latitude>                                            |
      | longitude            | <longitude>                                           |
      | distanceFromWaypoint | Displayed                                             |
      | address1             | <address1>                                            |
      | address2             | <address2>                                            |
      | postcode             | <postcode>                                            |
      | phone                | <phone>                                               |
      | relationship         | -                                                     |
      | code                 | -                                                     |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Success Pickup Job
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                          |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobType    | RESERVATION                                                                                                               |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Pickup Job                               |
      | status     | Success                                  |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | Displayed                                  |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Failed Pickup Job
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                       |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobType         | RESERVATION                                                                                                            |
      | jobMode         | PICK_UP                                                                                                                |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 63                                                                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job           | Pickup Job                               |
      | status        | Fail                                     |
      | failureReason | Normal - Cannot Make It (CMI)            |
      | startDate     | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate       | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub           | <HubName>                                |
      | driverName    | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | Cannot Make It (CMI)                       |
      | transactionStatus    | FAIL                                       |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | Displayed                                  |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Success Return Pickup Job
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Return Pickup                            |
      | status     | Success                                  |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | Displayed                                  |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Failed Return Pickup Job
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | jobMode         | PICK_UP                                                                                                                |
      | failureReasonId | 131                                                                                                                    |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job           | Return Pickup                            |
      | status        | Fail                                     |
      | failureReason | Return - Cannot Make It (CMI)            |
      | startDate     | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate       | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub           | <HubName>                                |
      | driverName    | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | Cannot Make It (CMI)                       |
      | transactionStatus    | FAIL                                       |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | Displayed                                  |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Valid Tracking IDs
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator click "Filter by Tracking IDs" button
    Then Operator validate filterByTackingId modal
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | distanceFromWaypoint                       |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD Success Pickup Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId  | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                          |
      | parcels     | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes      | KEY_DRIVER_ROUTES                                                                                                         |
      | jobType     | RESERVATION                                                                                                               |
      | jobAction   | SUCCESS                                                                                                                   |
      | jobMode     | PICK_UP                                                                                                                   |
      | basePayload | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                                 |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | -                                          |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | podPhoto             | validate                                   |
      | podSignature         | validate                                   |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | -                                          |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    Then Operator validate Enter Reason for invalid attempt modal "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Operator click "Invalid" button
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE |
      | invalidReasonId | 29      |
      | type            | type    |
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD Success Return Pickup Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId  | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                                |
      | parcels     | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes      | KEY_DRIVER_ROUTES                                                                                                         |
      | jobAction   | SUCCESS                                                                                                                   |
      | jobMode     | PICK_UP                                                                                                                   |
      | basePayload | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                                 |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | -                                          |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | podPhoto             | validate                                   |
      | podSignature         | validate                                   |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | -                                          |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    Then Operator validate Enter Reason for invalid attempt modal "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Operator click "Invalid" button
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE    |
      | invalidReasonId | 29         |
      | type            | VALIDATION |
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD Failed Pickup Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobMode         | PICK_UP                                                                                                                |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 131                                                                                                                    |
      | basePayload     | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                              |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | Cannot Make It (CMI)                       |
      | transactionStatus    | FAIL                                       |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | podPhoto             | validate                                   |
      | podSignature         | validate                                   |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | -                                          |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    When Operator click "Valid" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |


  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD Failed Return Pickup Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | jobMode         | PICK_UP                                                                                                                |
      | failureReasonId | 131                                                                                                                    |
      | basePayload     | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                              |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | Cannot Make It (CMI)                       |
      | transactionStatus    | FAIL                                       |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | podPhoto             | validate                                   |
      | podSignature         | validate                                   |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | -                                          |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    When Operator click "Valid" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD Success Delivery Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId  | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels     | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes      | KEY_DRIVER_ROUTES                                                                                                         |
      | basePayload | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                                 |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | -                                          |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | podPhoto             | validate                                   |
      | podSignature         | validate                                   |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | -                                          |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    When Operator click "Valid" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD Success Return Delivery Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId  | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels     | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes      | KEY_DRIVER_ROUTES                                                                                                         |
      | basePayload | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                                 |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | -                                          |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | podPhoto             | validate                                   |
      | podSignature         | validate                                   |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | -                                          |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    When Operator click "Valid" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |


  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD Success Delivery Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId  | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels     | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes      | KEY_DRIVER_ROUTES                                                                                                         |
      | basePayload | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                                 |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | -                                          |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | podPhoto             | validate                                   |
      | podSignature         | validate                                   |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | -                                          |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    Then Operator validate Enter Reason for invalid attempt modal "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Operator click "Invalid" button
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE |
      | invalidReasonId | 29      |
      | type            | type    |
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"


    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD Success Return Delivery Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId  | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels     | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes      | KEY_DRIVER_ROUTES                                                                                                         |
      | basePayload | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                                 |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | -                                          |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | podPhoto             | validate                                   |
      | podSignature         | validate                                   |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | -                                          |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    Then Operator validate Enter Reason for invalid attempt modal "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Operator click "Invalid" button
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE    |
      | invalidReasonId | 29         |
      | type            | VALIDATION |
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"


    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Shipper Name on Multiple Parcel in POD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                                                                                |
      | waypointId  | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                                                                                                                                                  |
      | parcels     | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"},{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes      | KEY_DRIVER_ROUTES                                                                                                                                                                                                                                 |
      | jobType     | RESERVATION                                                                                                                                                                                                                                       |
      | jobAction   | SUCCESS                                                                                                                                                                                                                                           |
      | jobMode     | PICK_UP                                                                                                                                                                                                                                           |
      | basePayload | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                                                                                                                                                         |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                   |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId  | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | shipperName | {shipper-v4-name}                          |
    Then Operator verifies the following details in the POD validate details page
      | trackingId  | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | shipperName | {shipper-v4-name}                          |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Shipper Name on Single Parcel in POD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | distanceFromWaypoint                       |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Shipper Name on Merged Delivery Transaction in POD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {PA_shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {PA_shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","shipper_id":{PA_shipper-v4-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | shipperName       | {shipper-v4-name}                          |
    When Operator click "Valid" button
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | shipperName       | {PA_shipper-v4-name}                       |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |


  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Shipper Name on Marketplace Parcel in POD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientId     | {market-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {market-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | {"service_type":"Marketplace","service_level":"Standard","reference":{"merchant_order_number":"NVQA-ZAN","merchant_order_metadata":{"test":123,"what":"isthis","foo":{"bar":"wah"}}},"from":{"name":"LeriSender","phone_number":"+6281329991234","email":"LeriLazada@email.com","address":{"address1":"NinjaBuildingSG","address2":"","country":"SG","postcode":"150002","latitude":9.9999,"longitude":9.9999}},"to":{"name":"LeriReceiver","phone_number":"+628994647777","email":"Station@gmail.com","address":{"address1":"MenaraBidakaraBuilding","address2":"","country":"SG","postcode":"552855"}},"parcel_job":{"experimental_from_international":false,"experimental_to_international":false,"is_pickup_required":true,"pickup_date":"{date: 0 days next,YYYY-MM-dd}","pickup_service_type":"Scheduled","pickup_service_level":"Standard","pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instruction":"Pleasebecarefulwiththev-dayflowers.","pickup_address":{"name":"LeriSender","phone_number":"+6281329991234","email":"Station@gmail.com","address":{"address1":"NinjaBuildingSG","address2":"","country":"SG","postcode":"150002","latitude":9.9999,"longitude":9.9999}},"delivery_start_date":"{date: 0 days next,YYYY-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"Pleasebecarefulwiththev-dayflowers.","dimensions":{"weight":0.0},"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP"},"experimental_customs_declaration":{"customs_description":"thisordertotestwebhooksubscription"},"marketplace":{"seller_id":"seller-foodbeverage-StationAuto","seller_company_name":"<subShipperName>","warehouse_id":"QA-testing-warehousesg"}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | shipperName       | (<subShipperName>)                         |


    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       | subShipperName           |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 | FoodBeverage StationAuto |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD Failed Normal Pickup Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                       |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobType         | RESERVATION                                                                                                            |
      | jobMode         | PICK_UP                                                                                                                |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 63                                                                                                                     |
      | basePayload     | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                              |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                   |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | Cannot Make It (CMI)                       |
      | transactionStatus    | FAIL                                       |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | podPhoto             | validate                                   |
      | podSignature         | validate                                   |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | Displayed                                  |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    Then Operator validate Enter Reason for invalid attempt modal "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Operator click "Invalid" button
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE |
      | invalidReasonId | 29      |
      | type            | type    |
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD Failed Return Pickup Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | jobMode         | PICK_UP                                                                                                                |
      | failureReasonId | 131                                                                                                                    |
      | basePayload     | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                              |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason        | Cannot Make It (CMI)                       |
      | transactionStatus    | FAIL                                       |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | podPhoto             | validate                                   |
      | podSignature         | validate                                   |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | Displayed                                  |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    Then Operator validate Enter Reason for invalid attempt modal "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Operator click "Invalid" button
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE |
      | invalidReasonId | 29      |
      | type            | type    |
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD Failed Delivery Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 11                                                                                                                     |
      | basePayload     | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                              |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}            |
      | failureReason        | I had insufficient time to complete all my deliveries |
      | transactionStatus    | FAIL                                                  |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}                       |
      | cod                  | No                                                    |
      | shipperName          | {shipper-v4-name}                                     |
      | podPhoto             | validate                                              |
      | podSignature         | validate                                              |
      | latitude             | <latitude>                                            |
      | longitude            | <longitude>                                           |
      | distanceFromWaypoint | validate                                              |
      | address1             | <address1>                                            |
      | address2             | <address2>                                            |
      | postcode             | <postcode>                                            |
      | phone                | <phone>                                               |
      | relationship         | -                                                     |
      | code                 | -                                                     |
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    Then Operator validate Enter Reason for invalid attempt modal "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Operator click "Invalid" button
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE |
      | invalidReasonId | 29      |
      | type            | type    |
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD Failed Return Delivery Job via TID's Filter
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Return", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                     |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                             |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                                                      |
      | jobAction       | FAIL                                                                                                                   |
      | failureReasonId | 11                                                                                                                     |
      | basePayload     | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                              |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                             |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}            |
      | failureReason        | I had insufficient time to complete all my deliveries |
      | transactionStatus    | FAIL                                                  |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}                       |
      | cod                  | No                                                    |
      | shipperName          | {shipper-v4-name}                                     |
      | podPhoto             | validate                                              |
      | podSignature         | validate                                              |
      | latitude             | <latitude>                                            |
      | longitude            | <longitude>                                           |
      | distanceFromWaypoint | -                                                     |
      | address1             | <address1>                                            |
      | address2             | <address2>                                            |
      | postcode             | <postcode>                                            |
      | phone                | <phone>                                               |
      | relationship         | -                                                     |
      | code                 | -                                                     |
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    Then Operator validate Enter Reason for invalid attempt modal "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Operator click "Invalid" button
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE |
      | invalidReasonId | 29      |
      | type            | type    |
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD of Normal Pickup Job with Multiple TIDs
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                                                                                |
      | waypointId  | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                                                                                                                                                  |
      | parcels     | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"},{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes      | KEY_DRIVER_ROUTES                                                                                                                                                                                                                                 |
      | jobType     | RESERVATION                                                                                                                                                                                                                                       |
      | jobAction   | SUCCESS                                                                                                                                                                                                                                           |
      | jobMode     | PICK_UP                                                                                                                                                                                                                                           |
      | basePayload | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                                                                                                                                                         |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                   |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Pickup Job                               |
      | status     | Success                                  |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | Displayed                                  |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt/completed"
    When Operator click "Back to filter" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"


    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD of Normal Pickup Job with Multiple TIDs
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": true, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                                                                                |
      | waypointId  | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                                                                                                                                                  |
      | parcels     | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"},{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes      | KEY_DRIVER_ROUTES                                                                                                                                                                                                                                 |
      | jobType     | RESERVATION                                                                                                                                                                                                                                       |
      | jobAction   | SUCCESS                                                                                                                                                                                                                                           |
      | jobMode     | PICK_UP                                                                                                                                                                                                                                           |
      | basePayload | {"nonce_id":"RANDOM_UUID","num_photos":1}                                                                                                                                                                                                         |
    When API Driver - Driver add photo to created route waypoint
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}               |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | nonceId    | {KEY_DRIVER_LIST_NONCE_IDS[1]}                   |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Pickup Job                               |
      | status     | Success                                  |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus    | SUCCESS                                    |
      | attemptDateTime      | {date: 0 days next, YYYY-MM-dd}            |
      | cod                  | No                                         |
      | shipperName          | {shipper-v4-name}                          |
      | latitude             | <latitude>                                 |
      | longitude            | <longitude>                                |
      | distanceFromWaypoint | Displayed                                  |
      | address1             | <address1>                                 |
      | address2             | <address2>                                 |
      | postcode             | <postcode>                                 |
      | phone                | <phone>                                    |
      | relationship         | -                                          |
      | code                 | -                                          |
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    Then Operator validate Enter Reason for invalid attempt modal "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When Operator click "Invalid" button
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE |
      | invalidReasonId | 29      |
      | type            | type    |
    Then Operator validates current URL ends with "validate-attempt/completed"
    When Operator click "Back to filter" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"


    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter TID with Pickup and Delivery POD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{date: 0 days next, YYYY-MM-dd}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator get address details using data below:
      | shipperId | {shipper-v4-id}      |
      | addressId | {shipper-address-id} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{shipper-address-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add reservation to route using data below:
      | reservationId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id}       |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                                                          |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
      | jobType    | RESERVATION                                                                                                               |
      | jobAction  | SUCCESS                                                                                                                   |
      | jobMode    | PICK_UP                                                                                                                   |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[2].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When Operator click "Valid" button
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When Operator click "Valid" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1          | address2 | postcode          | country | latitude         | longitude        | phone          |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | {pickup-address1} |          | {pickup-postcode} | SG      | 1.37856500735532 | 103.770646512516 | {pickup-phone} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter COD ALL in POD Validation Page
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP","cash_on_delivery": 100, "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                   |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                                                           |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS","cod": 100}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                                    |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | cod        | All                                      |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | cod        | No                                         |
    When Operator click "Valid" button
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | cod        | Yes                                        |
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt/completed"
    When Operator click "Back to filter" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter COD YES in POD Validation Page
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP","cash_on_delivery": 100, "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                             |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                     |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","action": "SUCCESS","cod":100}] |
      | routes     | KEY_DRIVER_ROUTES                                                                              |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | cod        | Yes                                      |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | cod        | Yes                                        |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter COD NO in POD Validation Page
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                   |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                           |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                    |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | cod        | No                                       |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | cod        | No                                         |

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter RTS ALL in POD Validation Page
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                              |
      | rtsRequest | { "reason": "Return to sender: Nobody at address", "timewindow_id":1, "date":"{date: 1 days next, yyyy-MM-dd}"} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                   |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                           |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                    |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                   |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                           |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                    |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | rts        | All                                      |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When Operator click "Valid" button
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt/completed"
    When Operator click "Back to filter" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter RTS YES in POD Validation Page
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                              |
      | rtsRequest | { "reason": "Return to sender: Nobody at address", "timewindow_id":1, "date":"{date: 1 days next, yyyy-MM-dd}"} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                   |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                           |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                    |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | rts        | Yes                                      |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt/completed"
    When Operator click "Back to filter" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter RTS NO in POD Validation Page
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job        | Delivery Job                             |
      | status     | Success                                  |
      | rts        | No                                       |
      | startDate  | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate    | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub        | <HubName>                                |
      | driverName | <driverName>                             |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt/completed"
    When Operator click "Back to filter" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Reopen Page via URL Given User has Remaining Task
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
    When Operator loads Validate Validate Delivery or Pickup Attempt page
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator validate Pending assigned POD modal
    When Operator click "Resume Validating" button
    When Operator click "Valid" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Reopen Page via Side Nav Given User has Remaining Task
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator waits for 5 seconds
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator validate Pending assigned POD modal
    When Operator click "Resume Validating" button
    When Operator click "Valid" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Resume Validating Remaining Task Given Filter has more Than 5 PODs
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[3]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[4]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[5]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[4].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[5].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[4].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[5].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[5].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[5].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[5].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[5].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[5].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    And Operator waits for 5 seconds
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator validate Pending assigned POD modal
    When Operator click "Resume Validating" button
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Back to POD Filter page
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "to": { "name": "User Auto", "phone_number": "+6597119425", "email": "user.test@ninjavan.co", "address": { "address1": "10 Coleman St", "address2": "", "country": "SG", "postcode": "179809" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "+6597119425", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator waits for 5 seconds
    And Operator goes back on browser
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator validate Pending assigned POD modal
    When Operator click "Resume Validating" button
    When Operator click "Valid" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |


  Scenario Outline: Filter Invalid Tracking IDs
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator click "Filter by Tracking IDs" button
    Then Operator validate filterByTackingId modal
    When Operator filters the PODs based on trackingIds
      | trackingIds | 2212121212 |
    Then Operator validate the error code and error details
      | statusCode | Status 404: Not Found                                                             |
      | url        | https://api-qa.ninjavan.co/sg/pod-validation/1.0/assignments/validation           |
      | message    | There are no matching tasks for the given list of TIDs [TrackingIDs:[2212121212]] |
      | data       | {"tracking_ids":["2212121212"],"num_tasks_requested":5}                           |
    When Operator closes the notification message
    When Operator click "Cancel" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |


  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Non-Market Place Shipper POD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job               | Delivery Job                             |
      | status            | Success                                  |
      | startDate         | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate           | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub               | <HubName>                                |
      | driverName        | <driverName>                             |
      | masterShipperName | -                                        |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Market Place Shipper POD
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientId     | {market-shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {market-shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | {"service_type":"Marketplace","service_level":"Standard","reference":{"merchant_order_number":"NVQA-ZAN","merchant_order_metadata":{"test":123,"what":"isthis","foo":{"bar":"wah"}}},"from":{"name":"LeriSender","phone_number":"+6281329991234","email":"LeriLazada@email.com","address":{"address1":"NinjaBuildingSG","address2":"","country":"SG","postcode":"150002","latitude":9.9999,"longitude":9.9999}},"to":{"name":"LeriReceiver","phone_number":"+628994647777","email":"Station@gmail.com","address":{"address1":"MenaraBidakaraBuilding","address2":"","country":"SG","postcode":"552855"}},"parcel_job":{"experimental_from_international":false,"experimental_to_international":false,"is_pickup_required":true,"pickup_date":"{date: 0 days next,YYYY-MM-dd}","pickup_service_type":"Scheduled","pickup_service_level":"Standard","pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instruction":"Pleasebecarefulwiththev-dayflowers.","pickup_address":{"name":"LeriSender","phone_number":"+6281329991234","email":"Station@gmail.com","address":{"address1":"NinjaBuildingSG","address2":"","country":"SG","postcode":"150002","latitude":9.9999,"longitude":9.9999}},"delivery_start_date":"{date: 0 days next,YYYY-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"Pleasebecarefulwiththev-dayflowers.","dimensions":{"weight":0.0},"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"OTP"},"experimental_customs_declaration":{"customs_description":"thisordertotestwebhooksubscription"},"marketplace":{"seller_id":"seller-foodbeverage-StationAuto","seller_company_name":"<subShipperName>","warehouse_id":"QA-testing-warehousesg"}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-20}" and "{ninja-driver-password-20}"
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId> , "vehicleId":{vehicle-id}, "driverId":<driverId>} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | <driverId>                         |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on below criteria
      | job               | Delivery Job                             |
      | status            | Success                                  |
      | startDate         | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate           | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
      | hub               | <HubName>                                |
      | driverName        | <driverName>                             |
      | masterShipperName | Marketplace station Auto                 |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
      | shipperName       | (<subShipperName>)                         |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       | subShipperName           |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 | FoodBeverage StationAuto |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op