@StationManagement @StationRouteMonitoringPart3
Feature: Route Monitoring V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @ArchiveRouteCommonV2 @Pass
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Empty Route
    Given Operator loads Operator portal home page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriver @Hold
  Scenario Outline: Show Updated Driver Name in Route Monitoring (uid:88878587-9c53-482f-80c2-a98f4376ac0b)
    Given Operator loads Operator portal home page
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    When API Driver Management - Operator create new driver with data below:
      | driverSettingParameter | {"first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "driver", "display_name": "D{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}","driver_type":"{driver-type-name}", "availability": false, "cod_limit": 1000000, "max_on_demand_jobs": 1000000, "username":"Station{{TIMESTAMP}}","password":"Password1", "tags": {}, "employment_start_date": "{date:0 days next,YYYY-MM-dd}", "employment_end_date": null, "hub_id":<HubId>} |
      | vehicles               | [{"active": true, "vehicleNo": "1ashdkajdsc", "vehicleType": "Car", "ownVehicle": false, "capacity": 999999}]                                                                                                                                                                                                                                                                                                                      |
      | contacts               | [{"active":true,"type":"Mobile Phone","details":"+65 65745 455"}]                                                                                                                                                                                                                                                                                                                                                                  |
      | zonePreferences        | [{"latitude": -6.2141988, "longitude": 106.8064186, "maxWaypoints": 1000000, "minWaypoints": 1, "zoneId": 2, "cost": 1000000, "rank": 1}]                                                                                                                                                                                                                                                                                          |
      | hub                    | {"displayName": "<HubName>", "value": <HubId>}                                                                                                                                                                                                                                                                                                                                                                                     |
      | version                | 2.0                                                                                                                                                                                                                                                                                                                                                                                                                                |
#   And API Operator create new Driver using data below:
#  | driverCreateRequest | {"first_name":"{{RANDOM_FIRST_NAME}}","last_name":"driver","display_name":"D{{TIMESTAMP}}","license_number":"D{{TIMESTAMP}}","driver_type":"{driver-type-name}","availability":false,"cod_limit":4353,"vehicles":[{"active":true,"vehicleNo":"6456345","vehicleType":"{vehicle-type-name}","ownVehicle":false,"capacity":345}],"contacts":[{"active":true,"type":"Mobile Phone","details":"+65 65745 455"}],"zone_preferences":[{"latitude":1.3597220659709373,"longitude":103.82701942695314,"maxWaypoints":6,"minWaypoints":6,"rank":1,"zoneId":3629,"cost":6}],"max_on_demand_jobs":45,"username":"Station{{TIMESTAMP}}","password":"Password1","tags":{},"employment_start_date":"{date:0 days next,YYYY-MM-dd}","employment_end_date":null,"hub_id":<HubId>,"hub":{"displayName":"<HubName>","value":<HubId>}} |
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "DRIVER_NAME" column is equal to "{ninja-driver-name}"
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY |
      | routeDateTo   | TODAY     |
      | hubName       | <HubName> |
    And Operator edits details of created route using data below:
      | date       | {gradle-current-date-yyyy-MM-dd}            |
      | tags       | {route-tag-name}                            |
      | zone       | {zone-name}                                 |
      | hub        | <HubName>                                   |
      | driverName | {KEY_DRIVER_LIST_OF_DRIVERS[1].displayName} |
      | comments   | Route has been edited by automated test     |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "DRIVER_NAME" column is equal to "{KEY_DRIVER_LIST_OF_DRIVERS[1].displayName}"


    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriver @Pass
  Scenario Outline: View Pickup Appointment Job in Route Monitoring - Add Multiple PA Jobs to Route
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @Pass
  Scenario Outline: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending PA Job From Route
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0
    And API Operator removes Pickup Appointment job to Route
      | pa_Id    | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
      | route_Id | {KEY_LIST_OF_CREATED_ROUTES[1].id}  |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0
    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @Hold
  Scenario Outline: Show Updated Route Id & Driver Name of Routed PA Job in Route Monitoring
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0
    And Operator saves old route
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"first_name":"{{RANDOM_FIRST_NAME}}","last_name":"driver","display_name":"D{{TIMESTAMP}}","license_number":"D{{TIMESTAMP}}","driver_type":"{driver-type-name}","availability":false,"cod_limit":4353,"vehicles":[{"active":true,"vehicleNo":"6456345","vehicleType":"{vehicle-type-name}","ownVehicle":false,"capacity":345}],"contacts":[{"active":true,"type":"Mobile Phone","details":"+65 65745 455"}],"zone_preferences":[{"latitude":1.3597220659709373,"longitude":103.82701942695314,"maxWaypoints":6,"minWaypoints":6,"rank":1,"zoneId":3629,"cost":6}],"max_on_demand_jobs":45,"username":"Station{{TIMESTAMP}}","password":"Password1","tags":{},"employment_start_date":"{date:0 days next,YYYY-MM-dd}","employment_end_date":null,"hub_id":<HubId>,"hub":{"displayName":"<HubName>","value":<HubId>}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_ID} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_OLD_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "DRIVER_NAME" column is equal to "{KEY_CREATED_DRIVER_INFO.getDisplayName}"
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @Pass
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - PA Job
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}    |
      | pickupAppointmentProofRequest | {"status":"completed","photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @SystemIdNotSg @default-my @Pass
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed PA Job
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                         |
      | pickupAppointmentProofRequest | {"failure_reason_code_id": 9,"failure_reason_id": 2664,"status": "failed","photo_urls": []} |
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId      | HubName      | Country  |
      | {hub-id-2} | {hub-name-2} | Malaysia |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriver @Pass
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Valid Failed PA Job
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                        |
      | pickupAppointmentProofRequest | {"status":"failed","failure_reason_id":1476,"failure_reason_code_id":1476,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriver @Pass
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Valid Failed PA Job
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                   |
      | pickupAppointmentProofRequest | {"status":"failed","failure_reason_id":63,"failure_reason_code_id":9,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0
    When Operator clicks on the "INVALID_FAILED_WAYPOINTS" column value link
    Then Operator verifies pop up modal is showing correct total parcels
      | INVALID_FAILED_DELIVERIES   | 0 |
      | INVALID_FAILED_PICKUPS      | 0 |
      | INVALID_FAILED_RESERVATIONS | 1 |
    When Operator Filters the records in the "Invalid Failed Reservations" by applying the following filters:
      | Reservation ID                      | Pickup Name | Contact   |
      | {KEY_CONTROL_CREATED_PA_JOBS[1].id} | <Name>      | <Contact> |
    And Operator selects the timeslot "9am - 6pm" in the table
    Then Operator verify value in the "Invalid Failed Reservations" table for the "RESERVATION_ID" column value is equal to "{KEY_CONTROL_CREATED_PA_JOBS[1].id}"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "PICKUP_NAME" column value is equal to "<Name>"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "ADDRESS" column value is equal to "<Address>"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "TIME_SLOT" column value is equal to "9am - 6pm"
    Then Operator verify value in the "Invalid Failed Reservations" table for the "CONTACT" column value is equal to "<Contact>"
    And Operator verifies that Shipper Pickup page is opened on clicking Reservation ID "{KEY_CONTROL_CREATED_PA_JOBS[1].id}" table "Invalid Failed Reservations"

    Examples:
      | HubId       | HubName       | Name                        | Address                 | Contact                 |
      | {hub-id-22} | {hub-name-22} | {PA_shipper-v4-pickup-name} | {PA_shipper-v4-address} | {PA_shipper-v4-contact} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriver @TimeBased @Failed
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending & Late PA Job Waypoint
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriver @TimeBased @Failed
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Success & Late PA Job Waypoint
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}    |
      | pickupAppointmentProofRequest | {"status":"completed","photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriver @TimeBased @Failed
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Failed & Late PA Job Waypoint
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                     |
      | pickupAppointmentProofRequest | {"status":"failed","failure_reason_id":9,"failure_reason_code_id":2664,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 1

    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriver @TimeBased @Failed
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Success & Early PA Job Waypoint
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}    |
      | pickupAppointmentProofRequest | {"status":"completed","photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @DeleteDriver @TimeBased @Failed
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Failed & Early PA Job Waypoint
    Given Operator loads Operator portal home page
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId       | {PA_shipper-v4-id} |
      | generateAddress | RANDOM             |
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                  |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"overwrite":true} |
    When API Control - Operator update pickup appointment job proof with data below:
      | jobId                         | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                     |
      | pickupAppointmentProofRequest | {"status":"failed","failure_reason_id":9,"failure_reason_code_id":2664,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_LIST_OF_CREATED_ROUTES[1].id}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_PARCEL_COUNT" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "TOTAL_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "PENDING_PRIORITY_PARCELS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "PENDING_AND_LATE_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "SUCCESSFUL_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "INVALID_FAILED_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "VALID_FAILED_WAYPOINTS" column is equal to 0
    Then Operator verify value on Station Route Monitoring page for the "EARLY_WAYPOINTS" column is equal to 1
    Then Operator verify value on Station Route Monitoring page for the "LATE_WAYPOINTS" column is equal to 0

    Examples:
      | HubId       | HubName       |
      | {hub-id-22} | {hub-name-22} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op