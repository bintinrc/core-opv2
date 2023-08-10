@StationManagement @StationPODValidation1
Feature: POD Validation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Download POD Validation Report and View Review Appeal Detail
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-25}" and "{ninja-driver-password-25}"
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
    When API Station - Operator assigns Pod for validation
      | assignPODRequest | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"],"num_tasks_requested":5} |
    When DB Station - Operator gets task Id for the trackingId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When API Station -  Operator submit invalidate POP:
      | podValidationRequest | {"task_id":{KEY_STATION_LIST_OF_TASK_IDS[1]},"validity":"FAILURE","validation_failure_reason_id":29} |
    And Operator waits for 5 seconds
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE    |
      | invalidReasonId | 29         |
      | type            | VALIDATION |
    When API Driver - submit appeal for POD
      | appealRequest | {"task_id":{KEY_STATION_LIST_OF_TASK_IDS[1]},"driver_id":<driverId>,"appeal_reason_id":51,"appeal_info":"StationTesting"} |
    Given Operator login with client id = "{POD-Reviewer-client-id}" and client secret = "{POD-Reviewer-client-secret}"
    When API Station - Operator assigns Pod for Review
      | reviewPODRequest | {"job_type":"DELIVERY","num_tasks_requested":5} |
    When API Station -  Operator submit invalidate POP:
      | podValidationRequest | {"task_id":{KEY_STATION_LIST_OF_TASK_IDS[1]},"validity":"FAILURE","validation_failure_reason_id":29,"type":"REVIEW"} |
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Download Validation Reports
    When Operator selects the date time range based on below data:
      | startDate | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate   | {date: 1 days next, YYYY-MM-dd} 23:59:07 |
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
    Then Operator verifies that the following texts are available in the POD validation report file "Download_Validation_Report"
      | PODValidator@nvqa.tech                     |
      | {KEY_STATION_LIST_OF_TASK_IDS[1]}          |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-25} | {hub-name-25} | {ninja-driver-name-25} | {ninja-driver-id-25} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Download POD Validation Report and View Validation Detail
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type": "Parcel", "service_level": "Standard", "requested_tracking_number": null, "reference": { "merchant_order_number": "TEST-ZZZ-Z67867861" }, "from": { "name": "User test", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>" } }, "to": { "name": "User Auto", "phone_number": "<phone>", "email": "user.test@ninjavan.co", "address": { "address1": "<address1>", "address2": "<address2>", "country": "<country>", "postcode": "<postcode>","latitude":"<latitude>","longitude":"<longitude>" } }, "parcel_job": { "allow_doorstep_dropoff": true, "enforce_delivery_verification": false, "delivery_verification_mode": "OTP", "is_pickup_required": false, "pickup_date": "{{next-1-day-yyyy-MM-dd}}", "pickup_service_type": "Scheduled", "pickup_service_level": "Standard", "pickup_address_id": "reservation-01", "pickup_address": { "name": "Auto User", "phone_number": "<phone>", "email": "auto@gmail.com", "address": { "address1": "7 Keppel Rd #01-18/20", "address2": "", "country": "SG", "postcode": "089053" } }, "pickup_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "pickup_instructions": "Please ignore, this is for testing purposes", "delivery_start_date": "{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot": { "start_time": "09:00", "end_time": "22:00", "timezone": "Asia/Singapore" }, "delivery_instructions": "Please ignore, this is for testing purposes", "dimensions": { "weight": 10 } } } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Driver - Driver login with username "{ninja-driver-username-25}" and "{ninja-driver-password-25}"
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
    When API Station - Operator assigns Pod for validation
      | assignPODRequest | {"tracking_ids":["{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"],"num_tasks_requested":5} |
    When DB Station - Operator gets task Id for the trackingId "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"
    When API Station -  Operator submit invalidate POP:
      | podValidationRequest | {"task_id":{KEY_STATION_LIST_OF_TASK_IDS[1]},"validity":"FAILURE","validation_failure_reason_id":29} |
    And Operator waits for 5 seconds
    Then DB Station - Operator verifies the following details for the tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" in the assignments table
      | validity        | FAILURE    |
      | invalidReasonId | 29         |
      | type            | VALIDATION |
    When API Driver - submit appeal for POD
      | appealRequest | {"task_id":{KEY_STATION_LIST_OF_TASK_IDS[1]},"driver_id":<driverId>,"appeal_reason_id":51,"appeal_info":"StationTesting"} |
    Given Operator login with client id = "{POD-Reviewer-client-id}" and client secret = "{POD-Reviewer-client-secret}"
    When API Station - Operator assigns Pod for Review
      | reviewPODRequest | {"job_type":"DELIVERY","num_tasks_requested":5} |
    When API Station -  Operator submit invalidate POP:
      | podValidationRequest | {"task_id":{KEY_STATION_LIST_OF_TASK_IDS[1]},"validity":"FAILURE","validation_failure_reason_id":29,"type":"REVIEW"} |
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Download Validation Reports
    When Operator selects the date time range based on below data:
      | startDate | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate   | {date: 1 days next, YYYY-MM-dd} 23:59:07 |
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
    Then Operator verifies that the following texts are available in the POD validation report file "Download_Validation_Report"
      | PODValidator@nvqa.tech                     |
      | {KEY_STATION_LIST_OF_TASK_IDS[1]}          |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |

    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-25} | {hub-name-25} | {ninja-driver-name-25} | {ninja-driver-id-25} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |


  Scenario Outline: User has Validator Role and Reviewer Role
    Given Operator login with client id = "{POD-Validator-Reviewer-client-id}" and client secret = "{POD-Validator-Reviewer-client-secret}"
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator validates current URL ends with "validate-attempt/role"
    When Operator click "Validate PODs" button
    Then Operator validates current URL ends with "validate-attempt?role=validator"
    When Operator click back to task button
    Then Operator validates current URL ends with "validate-attempt/role"
    When Operator click "Review appealed PODs" button
    Then Operator validates current URL ends with "validate-attempt?role=reviewer"
    When Operator click back to task button
    Then Operator validates current URL ends with "validate-attempt/role"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-25} | {hub-name-25} | {ninja-driver-name-25} | {ninja-driver-id-25} |


  Scenario Outline: User has Auditor Role and Reviewer Role
    Given Operator login with client id = "{POD-Auditor-Reviewer-client-id}" and client secret = "{POD-Auditor-Reviewer-client-secret}"
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator validates current URL ends with "validate-attempt/role"
    When Operator click "Audit validated PODs" button
    Then Operator validates current URL ends with "validate-attempt?role=auditor"
    When Operator click back to task button
    Then Operator validates current URL ends with "validate-attempt/role"
    When Operator click "Review appealed PODs" button
    Then Operator validates current URL ends with "validate-attempt?role=reviewer"
    When Operator click back to task button
    Then Operator validates current URL ends with "validate-attempt/role"

    Examples:
      | HubId       | HubName       | driverName             | driverId             |
      | {hub-id-25} | {hub-name-25} | {ninja-driver-name-25} | {ninja-driver-id-25} |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Validator Task given Operator has Multiple Roles
    Given Operator login with client id = "{POD-Validator-Reviewer-client-id}" and client secret = "{POD-Validator-Reviewer-client-secret}"
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
    And API Driver - Driver login with username "{ninja-driver-username-25}" and "{ninja-driver-password-25}"
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
    Then Operator validates current URL ends with "validate-attempt/role"
    When Operator click "Validate PODs" button
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
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
      | {hub-id-25} | {hub-name-25} | {ninja-driver-name-25} | {ninja-driver-id-25} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: Filter Auditor Task given Operator has Multiple Roles
    Given Operator login with client id = "{POD-Validator-client-id}" and client secret = "{POD-Validator-client-secret}"
    Given Station DB - operator deletes the tasks parcel and assignments record for driver "<driverId>"
    Given Operator loads Operator portal home page
    When API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
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
    And API Driver - Driver login with username "{ninja-driver-username-25}" and "{ninja-driver-password-25}"
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
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                        |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                                                |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                         |
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with "validate-attempt?role=validator"
    When Operator filters the PODs based on trackingIds
      | trackingIds | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}\n{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    Then Operator validates current URL ends with "validate-attempt/validate?role=validator"
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
    When Operator click "Valid" button
    Then Operator verifies the following details in the POD validate details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | transactionStatus | SUCCESS                                    |
    When Operator click "Valid" button
#    Then Operator validates current URL ends with "validate-attempt/completed"
    Given Operator login with client id = "{POD-Auditor-Reviewer-client-id}" and client secret = "{POD-Auditor-Reviewer-client-secret}"
    And Operator go to menu Station Management Tool -> Validate Delivery or Pickup Attempt
    Then Operator validates current URL ends with "validate-attempt/role"
    When Operator click "Audit validated PODs" button
    Then Operator validates current URL ends with "validate-attempt?role=auditor"
    When Operator filters the PODs to audit based on below criteria
      | validatorName | {POD-Validator-name}                     |
      | startDate     | {date: 0 days next, YYYY-MM-dd} 00:00:00 |
      | endDate       | {date: 0 days next, YYYY-MM-dd} 23:59:07 |
    Then Operator validates current URL ends with "validate-attempt/validate?role=auditor"
    Then Operator verifies the following details in the POD audit details page
      | trackingId        | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | transactionStatus | SUCCESS                                    |
    When Operator click "Valid" button
    Then Operator validates current URL ends with "validate-attempt/completed"
    Then Operator validate "No more POD to audit!" text is displayed
    When Operator click "Back to filter" button
    Then Operator validates current URL ends with "validate-attempt?role=auditor"


    Examples:
      | HubId       | HubName       | driverName             | driverId             | address1    | address2   | postcode | country | latitude         | longitude        | phone       |
      | {hub-id-25} | {hub-name-25} | {ninja-driver-name-25} | {ninja-driver-id-25} | Station POD | Validation | 123456   | SG      | 1.29261998789502 | 103.850241824751 | +6597119425 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op