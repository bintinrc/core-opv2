@StationManagement @StationPODValidation
Feature: POD Validation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  Scenario: Download Validation Report
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Download Validation Reports
    When Operator selects the date time range based on below data:
      | startDate | {date: -1 days next, YYYY-MM-dd} 00:00:00 |
      | endDate   | {date: 0 days next, YYYY-MM-dd} 23:59:07  |
    When Operator click "Download Report" button
    And Verify that csv file is downloaded with filename: "Download_Validation_Report.csv"
    Then Operator verifies header names are available in the downloaded CSV file "Download_Validation_Report"
      | TaskID            |
      | JobID             |
      | JobStatus         |
      | JobType           |
      | AttemptedAt       |
      | HubID             |
      | FailureReasonId   |
      | DriverID          |
      | ShipperIDs        |
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

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Refresh POD Details Page While User Validates Less Than 5 PODs
    When DB Station - Operator deletes the POD assignment record in the Assignments table by user ID "{user-id}"
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
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
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
    Then Operator is redirected to Validate Delivery or Pickup Attempt page
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[5].trackingId} |
    Then Operator validates current URL ends with "validate"
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator refresh page
    Then Operator validates current URL ends with "validate"
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Refresh POD Details Page While User Validates More Than 5 PODs
    When DB Station - Operator deletes the POD assignment record in the Assignments table by user ID "{user-id}"
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
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
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
    Then Operator is redirected to Validate Delivery or Pickup Attempt page
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[3].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[4].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[5].trackingId} |
    Then Operator validates current URL ends with "validate"
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator click "Valid" button
    When Operator refresh page
    Then Operator validates current URL ends with "validate"
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Resume Validating Remaining Task Given Filter has Less Than 5 PODs
    When DB Station - Operator deletes the POD assignment record in the Assignments table by user ID "{user-id}"
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
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
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
    Then Operator is redirected to Validate Delivery or Pickup Attempt page
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[3].trackingId} |
    Then Operator validates current URL ends with "validate"
    When Operator click "Valid" button
    When Operator click "Valid" button
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator validates current URL ends with "validate"
    When Operator click "Resume Validating" button
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt"


    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validator End Session and Unassign Task
    When DB Station - Operator deletes the POD assignment record in the Assignments table by user ID "{user-id}"
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
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator waits for 5 seconds
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator validates current URL ends with "validate"
    When Operator click "End Session" button
    Then Operator validates current URL ends with "validate-attempt"
    Then DB Station - Operator verifies that row with taskId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" is deleted in the assignments table


    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Invalidate POD using Normal Filter
    When DB Station - Operator deletes the POD assignment record in the Assignments table by user ID "{user-id}"
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
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page
    When Operator filters the PODs based on below criteria
      | job       | Delivery Job                              |
      | status    | Success                                   |
      | startDate | {date: -1 days next, YYYY-MM-dd} 00:00:00 |
      | endDate   | {date: 0 days next, YYYY-MM-dd} 23:59:07  |
      | hub       | <HubName>                                 |
      | driver    | <driverName>                              |
    When Operator click "Invalid" button
    Then Operator validate "Enter Reason for invalid attempt" Modal is displayed
    When Operator selects the Invalid Attempt Reason "No Photo"
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE |
      | invalidReasonId | 29      |
      | type            | type    |
    Then DB Station - Operator verifies that the validator count "1" is updated in the tasks table for the tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator is redirected to Validate Delivery or Pickup Attempt page

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |


  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD using Normal Filter
    When DB Station - Operator deletes the POD assignment record in the Assignments table by user ID "{user-id}"
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
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page
    When Operator filters the PODs based on below criteria
      | job       | Delivery Job                              |
      | status    | Success                                   |
      | startDate | {date: -1 days next, YYYY-MM-dd} 00:00:00 |
      | endDate   | {date: 0 days next, YYYY-MM-dd} 23:59:07  |
      | hub       | <HubName>                                 |
      | driver    | <driverName>                              |
    When Operator click "Valid" button
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | SUCCESS |
      | invalidReasonId | NULL    |
      | type            | type    |
    Then DB Station - Operator verifies that the validator count "1" is updated in the tasks table for the tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator is redirected to Validate Delivery or Pickup Attempt page

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD Failed Delivery Job via TID's Filter
    When DB Station - Operator deletes the POD assignment record in the Assignments table by user ID "{user-id}"
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
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                 |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "FAIL"}] |
      | routes          | KEY_DRIVER_ROUTES                                                                  |
      | jobAction       | FAIL                                                                               |
      | failureReasonId | 13                                                                                 |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | failureReason     | Delay due to unexpected traffic conditions |
      | transactionStatus | FAIL                                       |
      | attemptDateTime   | {date: 0 days next, YYYY-MM-dd}            |
      | cod               | No                                         |
      | shipperName       | {shipper-v4-name}                          |
      | latitude          | <latitude>                                 |
      | longitude         | <longitude>                                |
#      | distanceFromWaypoint | type                                       |
      | address1          | <address1>                                 |
      | address2          | <address2>                                 |
      | postcode          | <postcode>                                 |
      | phone             | <phone>                                    |
      | relationship      | -                                          |
      | code              | -                                          |
    When Operator click "Valid" button
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | SUCCESS |
      | invalidReasonId | NULL    |
      | type            | type    |
    Then DB Station - Operator verifies that the validator count "1" is updated in the tasks table for the tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator is redirected to Validate Delivery or Pickup Attempt page

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Validate POD Success Pickup Job via TID's Filter
    When DB Station - Operator deletes the POD assignment record in the Assignments table by user ID "{user-id}"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{date: 0 days next, YYYY-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
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
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}                                      |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
      | jobType    | RESERVATION                                                                           |
      | jobAction  | SUCCESS                                                                               |
      | jobMode    | PICK_UP                                                                               |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page
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
    When Operator click "Valid" button
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | SUCCESS |
      | invalidReasonId | NULL    |
      | type            | type    |
    Then DB Station - Operator verifies that the validator count "1" is updated in the tasks table for the tracking Id "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    Then Operator is redirected to Validate Delivery or Pickup Attempt page

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1                         | address2 | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-20} | {hub-name-20} | {ninja-driver-name-20} | {ninja-driver-id-20} | 01-07 North Bridge Rd, Singapore |          | 670237   | SG      | 1.37856500735532 | 103.770646512516 | 87687687687 |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op