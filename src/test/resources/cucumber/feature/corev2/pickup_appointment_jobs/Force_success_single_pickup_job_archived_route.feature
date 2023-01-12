@OperatorV2 @CoreV2 @PickupAppointment @ForceSuccessSinglePickupRouteArchived
Feature: Force Success Single Pickup Job, Route Archived

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @deletePickupJob @DeleteShipperAddress
  Scenario:Force Success Single Pickup Job Routed route is archived
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                       |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":false} |
    When API Operator archives routes:
      | {KEY_CREATED_ROUTE_ID} |
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Tool tip is hidden
    When Operator hover on Success button in pickup job drawer
    Then Operator check Success button disabled in pickup job drawer
    Then Operator check Tool tip is shown


  @deletePickupJob @DeleteShipperAddress
  Scenario:Force Fail Single Pickup Job Routed route is archived
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                       |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":false} |
    When API Operator archives routes:
      | {KEY_CREATED_ROUTE_ID} |
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Tool tip is hidden
    When Operator hover on Fail button in pickup job drawer
    Then Operator check Fail button disabled in pickup job drawer
    Then Operator check Tool tip is shown

  @deletePickupJob @DeleteShipperAddress
  Scenario:Force Fail Single Pickup Job In Progress route is archived
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Operator start the route
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                       |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":false} |
    When API Operator archives routes:
      | {KEY_CREATED_ROUTE_ID} |
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator select only In progress job status, on pickup jobs filter
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Tool tip is hidden
    When Operator hover on Fail button in pickup job drawer
    Then Operator check Fail button disabled in pickup job drawer
    Then Operator check Tool tip is shown

  @deletePickupJob @DeleteShipperAddress
  Scenario:Force Success Single Pickup Job In Progress route is archived
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {normal-shipper-pickup-appointment-1-global-id} |
      | generateAddress | RANDOM                                          |
    Given API Control - Operator create pickup appointment job with data below:
      | createPickupJobRequest | { "shipperId":{normal-shipper-pickup-appointment-1-global-id}, "from":{ "addressId":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}}, "pickupService":{ "type": "Scheduled","level":"Standard"}, "pickupApproxVolume": "Less than 3 Parcels", "priorityLevel": 0, "pickupInstructions": "Automation created", "disableCutoffValidation": false, "pickupTimeslot":{ "ready":"{gradle-next-1-day-yyyy-MM-dd}T09:00:00+08:00", "latest":"{gradle-next-1-day-yyyy-MM-dd}T12:00:00+08:00"}} |
    When API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{driver-id} } |
    When API Operator start the route
    When API Core - Operator add pickup job to the route using data below:
      | jobId                      | {KEY_CONTROL_CREATED_PA_JOBS[1].id}                       |
      | addPickupJobToRouteRequest | {"new_route_id":{KEY_CREATED_ROUTE_ID},"overwrite":false} |
    When API Operator archives routes:
      | {KEY_CREATED_ROUTE_ID} |
    When Operator goes to Pickup Jobs Page
    When Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    When Operator select the data range
      | startDay | {gradle-next-1-day-yyyy-MM-dd} |
      | endDay   | {gradle-next-1-day-yyyy-MM-dd} |
    When Operator select only In progress job status, on pickup jobs filter
    When Operator click load selection on pickup jobs filter
    When Operator search for address = "{KEY_LIST_OF_CREATED_ADDRESSES[1].address1}" in pickup jobs table
    When Operator click edit icon for Pickup job row
    Then Operator check Tool tip is hidden
    When Operator hover on Success button in pickup job drawer
    Then Operator check Success button disabled in pickup job drawer
    Then Operator check Tool tip is shown

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op