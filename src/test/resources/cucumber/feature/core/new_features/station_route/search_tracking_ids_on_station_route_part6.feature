@OperatorV2 @Core @Route @NewFeatures @StationRoute @SearchTrackingIdsOnStationRoutePart6
Feature: Search Tracking IDs on Station Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Keyword Partial Matched with Address - Keyword is Missing First Half
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-11}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "83 Genting Lane 20","address2": "","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-11}                              |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | 456 UTARA 789                      |
      | areaVariations   | 83 Long 2                          |
      | keywords         | 3 Genting Lane 20                  |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-11}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}           |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} |
      | parcelSize | Small                                                |
      | driverId   | Unassigned                                           |
    And Operator verify area match is not displayed on Station Route page
    And Operator verify keyword match is not displayed on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Keyword Partial Matched with Address - Keyword is Missing Second Half
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-11}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "20 Bideford 08","address2": "","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-11}                              |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | 456 DAYA 789                       |
      | areaVariations   | 20 Tan 0                           |
      | keywords         | 20 Bideford 0                      |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-11}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}           |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} |
      | parcelSize | Small                                                |
      | driverId   | Unassigned                                           |
    And Operator verify area match is not displayed on Station Route page
    And Operator verify keyword match is not displayed on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Keyword Partial Matched with Address - Keyword is Missing First and Second Half
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-11}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "33 HarbourFront Place 44","address2": "","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-11}                              |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | 456 TIM 789                        |
      | areaVariations   | 30 SELAT 4                         |
      | keywords         | 3 HarbourFront Place 4             |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-11}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}           |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} |
      | parcelSize | Small                                                |
      | driverId   | Unassigned                                           |
    And Operator verify area match is not displayed on Station Route page
    And Operator verify keyword match is not displayed on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Matching Address - coverage A (area, keyword) & coverage B (area) are Match to Single Address
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-11}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "JL KEBUN SELATAN TIMUR KOTA 596363 SG","address2": "","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-11}                              |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | KEBUN                              |
      | keywords         | BARAT, SELATAN, TIMUR              |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | KOTA                               |
      | keywords         | UTARA, MERUYA, MOGOT               |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-11}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString}                           |
      | parcelSize | Small                                                                          |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "KEBUN" is displayed in row 1 on Station Route page
    And Operator verify keyword match "SELATAN" is displayed on 1 position on Station Route page
    And Operator verify keyword match "TIMUR" is displayed on 2 position on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Matching Address - coverage A (area, keyword) & coverage B (area, keyword) are Match to Single Address
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-11}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "2 International Business Park Tower 1","address2": "","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-11}                              |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | International                      |
      | keywords         | One, Two, Park                     |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | Tower                              |
      | keywords         | Four, Business, Five               |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-11}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify any parcel is displayed on Station Route page:
      | trackingId                                 | address                                              | parcelSize | driverId                                                                       |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | Small      | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "International" is displayed in row 1 on Station Route page
    And Operator verify keyword match "Park" is displayed in row 1 on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Matching Address - coverage A (area, empty keyword) & coverage B (area) are Match to Single Address
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-11}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "25A Teck Chye Ter","address2": "","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-11}                              |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | Teck                               |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | Ter                                |
      | keywords         | Castle, House, Place               |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-11}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString}                           |
      | parcelSize | Small                                                                          |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "Teck" is displayed in row 1 on Station Route page
    And Operator verify keyword match is not displayed on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Matching Address - coverage A (area, empty keyword) & coverage B (area, keyword) are Match to Single Address
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-11}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "772 Bedok Reservoir View","address2": "","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-11}                              |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | Bedok                              |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | View                               |
      | keywords         | Citra, Reservoir, Green            |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-11}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify any parcel is displayed on Station Route page:
      | trackingId                                 | address                                              | parcelSize | driverId                                                                       |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | Small      | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "Bedok" is displayed in row 1 on Station Route page
    And Operator verify keyword match is not displayed on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Matching Address - coverage A (area) & coverage B (keyword) are Match to Single Address
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-11}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "865 Katong Shopping Centre","address2": "","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-11}                              |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | Katong                             |
      | keywords         | Lamp, Castle, Office               |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | City                               |
      | keywords         | Citrus, Shopping, Parman           |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-11}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}           |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} |
      | parcelSize | Small                                                |
      | driverId   | Unassigned                                           |
    And Operator verify area match "Katong" is displayed in row 1 on Station Route page
    And Operator verify keyword match is not displayed on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Matching Address - coverage A (area, empty keyword) & coverage B (2 area, keyword) are Match to Single Address
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-11}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "11 Chin Bee Drive","address2": "","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-11}                              |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-11}, "hub": { "displayName": "{hub-name-11}", "value": {hub-id-11} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | Chin                               |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-11}                        |
      | area             | Bee                                |
      | keywords         | High, Drive, Keat                  |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id} |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-11}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify any parcel is displayed on Station Route page:
      | trackingId                                 | address                                              | parcelSize | driverId                                                                       |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | Small      | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "Chin" is displayed in row 1 on Station Route page
    And Operator verify keyword match is not displayed on Station Route page

  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - Start Date > End Date
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-11}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 1 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 0 days next, yyyy-MM-dd} |
    And Operator verify "Start date cannot be after end date" Shipment date error on Station Route page
    And Operator verify "Start date cannot be after end date" Shipment completion time error on Station Route page
    And Operator verify Assign drivers button is disabled on Station Route page

  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - Time Range Greater Than 1 Month
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                                  | {hub-name-11}                   |
      | shipmentType                         | AIR_HAUL                        |
      | shipmentDateFromTypeManual           | {date: 31 days ago, dd/MM/yyyy} |
      | shipmentDateToTypeManual             | {date: 1 days next, dd/MM/yyyy} |
      | shipmentCompletionTimeFromTypeManual | {date: 31 days ago, dd/MM/yyyy} |
      | shipmentCompletionTimeToTypeManual   | {date: 1 days next, dd/MM/yyyy} |
    And Operator verify "Time range cannot be greater than 1 month(s)" Shipment date error on Station Route page
    And Operator verify "Time range cannot be greater than 1 month(s)" Shipment completion time error on Station Route page
    And Operator verify Assign drivers button is disabled on Station Route page

  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - Start Date < End Date
    Given Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-13}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    Then Operator verify Assign drivers button is enabled on Station Route Page
