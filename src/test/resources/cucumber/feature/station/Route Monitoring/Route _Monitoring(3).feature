@StationManagement @StationRouteMonitoringPart3
Feature: Route Monitoring V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @DeleteOrArchiveRoute
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Empty Route
    Given Operator loads Operator portal home page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver
  Scenario Outline: Show Updated Driver Name in Route Monitoring V2 (uid:88878587-9c53-482f-80c2-a98f4376ac0b)
    Given Operator loads Operator portal home page
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"+6589011608"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by Automation Test for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":<HubId>,"hub":"<HubName>","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password1","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep multiple parcels in the hub
      | hubId | <HubId> |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "DRIVER_NAME" column is equal to "{ninja-driver-name}"
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY |
      | routeDateTo   | TODAY     |
      | hubName       | <HubName> |
    And Operator edits details of created route using data below:
      | date       | {gradle-current-date-yyyy-MM-dd}        |
      | tags       | {route-tag-name}                        |
      | zone       | {zone-name}                             |
      | hub        | <HubName>                               |
      | driverName | {KEY_CREATED_DRIVER_INFO.getFullName}   |
      | comments   | Route has been edited by automated test |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "DRIVER_NAME" column is equal to "{KEY_CREATED_DRIVER_INFO.getFullName}"


    Examples:
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver
  Scenario Outline: View Pickup Appointment Job in Route Monitoring - Add Multiple PA Jobs to Route
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver
  Scenario Outline: Operator Filter Route Monitoring Data and Checks Total Pending Waypoint - Remove Pending PA Job From Route
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | route_Id | {KEY_CREATED_ROUTE_ID}              |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver
  Scenario Outline: Show Updated Route Id & Driver Name of Routed PA Job in Route Monitoring
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"+6589011608"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by Automation Test for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":<HubId>,"hub":"<HubName>","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password1","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{KEY_CREATED_DRIVER_ID} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
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
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
    Then Operator verify value on Station Route Monitoring page for the "DRIVER_NAME" column is equal to "{KEY_CREATED_DRIVER_INFO.getFullName}"
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
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Total Success Waypoint - PA Job
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    And API Operator success Pickup Appointment job
      | pa_Id | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Invalid Failed PA Job
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    And API Operator fails Pickup Appointment job
      | pa_Id       | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                   |
      | requestBody | {"status":"failed","failure_reason_id":63,"failure_reason_code_id":9,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | HubId       | HubName       |
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Valid Failed PA Job
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    And API Operator fails Pickup Appointment job
      | pa_Id       | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                        |
      | requestBody | {"status":"failed","failure_reason_id":1476,"failure_reason_code_id":1476,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Valid Failed PA Job
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    And API Operator fails Pickup Appointment job
      | pa_Id       | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                   |
      | requestBody | {"status":"failed","failure_reason_id":63,"failure_reason_code_id":9,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} | {PA_shipper-v4-pickup-name} | {PA_shipper-v4-address} | {PA_shipper-v4-contact} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @TimeBased
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Pending & Late PA Job Waypoint
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @TimeBased
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Success & Late PA Job Waypoint
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    And API Operator success Pickup Appointment job
      | pa_Id | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @TimeBased
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Failed & Late PA Job Waypoint
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    And API Operator fails Pickup Appointment job
      | pa_Id       | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                   |
      | requestBody | {"status":"failed","failure_reason_id":63,"failure_reason_code_id":9,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @TimeBased
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Success & Early PA Job Waypoint
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    And API Operator success Pickup Appointment job
      | pa_Id | {KEY_CONTROL_CREATED_PA_JOBS[1].id} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} |

  @ForceSuccessOrder @DeleteOrArchiveRoute @DeleteDriver @TimeBased
  Scenario Outline: Operator Filter Route Monitoring Data And Checks Failed & Early PA Job Waypoint
    Given Operator loads Operator portal home page
    When API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{PA_shipper-v4-id}, "from":{ "addressId":1528009}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{"ready":"{gradle-current-date-yyyy-MM-dd}T09:00:00+08:00","latest":"{gradle-current-date-yyyy-MM-dd}T18:00:00+08:00"}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                      |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":true} |
    And API Operator fails Pickup Appointment job
      | pa_Id       | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                                                   |
      | requestBody | {"status":"failed","failure_reason_id":63,"failure_reason_code_id":9,"photo_urls":[]} |
    When Operator loads Operator portal Station Route Monitoring page
    And Operator selects hub "<HubName>" and click load selection
    And Operator enters routeID "{KEY_CREATED_ROUTE_ID}" in the Route filter
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
      | {hub-id-15} | {hub-name-15} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op