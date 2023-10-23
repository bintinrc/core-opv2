@OperatorV2 @Core @Route @NewFeatures @StationRoute @SearchTrackingIdsOnStationRoutePart2
Feature: Search Tracking IDs on Station Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - Match To Multiple Coverages - Duplicate Area
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-7}"
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "34B Lorong Mambong {date: 0 days next, yyyyMMddHHmmss}","address2": "village {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "34B Lorong Mambong {date: 0 days next, yyyyMMddHHmmss}","address2": "court {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-7}                               |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-7}                               |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                 |
      | area             | 34B Lorong Mambong                         |
      | areaVariations   | Drill {date: 0 days next, yyyyMMddHHmmss}  |
      | keywords         | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}         |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}         |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                 |
      | area             | 34B Lorong Mambong                         |
      | areaVariations   | Drill {date: 0 days next, yyyyMMddHHmmss}  |
      | keywords         | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress2} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}         |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}         |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                    |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString}                           |
      | parcelSize | Small                                                                          |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "34B Lorong Mambong" is displayed in row 1 on Station Route page
    And Operator verify keyword match "village {date: 0 days next, yyyyMMddHHmmss}" is displayed in row 1 on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                     |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString}                           |
      | parcelSize | Small                                                                          |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[3].id} - {KEY_DRIVER_LIST_OF_DRIVERS[3].firstName} |
    And Operator verify area match "34B Lorong Mambong" is displayed in row 1 on Station Route page
    And Operator verify keyword match "court {date: 0 days next, yyyyMMddHHmmss}" is displayed in row 1 on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - Match To Multiple Coverages - Duplicate Keyword
    Given API MM - Operator creates multiple 2 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-7}"
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "140A Sims {date: 0 days next, yyyyMMddHHmmss}","address2": "ave {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "194 Pandan {date: 0 days next, yyyyMMddHHmmss}","address2": "ave {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id}                                                                                |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-7}                               |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[2].id} |
      | scanType  | SHIPMENT_HUB_INBOUND                     |
      | hubId     | {hub-id-7}                               |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                        |
      | area             | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}        |
      | areaVariations   | AreaVariation {date: 0 days next, yyyyMMddHHmmss} |
      | keywords         | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}        |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}                |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}                |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                          |
      | area             | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1}          |
      | areaVariations   | AreaVariation 2 {date: 0 days next, yyyyMMddHHmmss} |
      | keywords         | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress2}          |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[3].id}                  |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[4].id}                  |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                    |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString}                           |
      | parcelSize | Small                                                                          |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "{KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}" is displayed in row 1 on Station Route page
    And Operator verify keyword match "{KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}" is displayed in row 1 on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                     |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString}                           |
      | parcelSize | Small                                                                          |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[3].id} - {KEY_DRIVER_LIST_OF_DRIVERS[3].firstName} |
    And Operator verify area match "{KEY_LIST_OF_CREATED_ORDERS[2].toAddress1}" is displayed in row 1 on Station Route page
    And Operator verify keyword match "{KEY_LIST_OF_CREATED_ORDERS[2].toAddress2}" is displayed in row 1 on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Search Tracking IDs on Station Route - Include Parcel In Hub - Valid Orders - Hub Inbound Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "12 West Coast {date: 0 days next, yyyyMMddHHmmss}","address2": "walk {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id-7}}                       |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                               |
      | area             | 12 West Coast                            |
      | areaVariations   | 12 West, West Coast                      |
      | keywords         | walk {date: 0 days next, yyyyMMddHHmmss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}       |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}       |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                    |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
      | alsoSearchInHub            | true                            |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString}                           |
      | parcelSize | Small                                                                          |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "12 West Coast" is displayed in row 1 on Station Route page
    And Operator verify keyword match "walk {date: 0 days next, yyyyMMddHHmmss}" is displayed in row 1 on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Search Tracking IDs on Station Route - Include Parcel In Hub - Valid Orders - Parcel Sweep Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "31 Kaki Bukit {date: 0 days next, yyyyMMddHHmmss}","address2": "place {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator parcel sweep
      | parcelSweepRequest | {"hubId" : {hub-id-7}, "scan": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}"} |
      | trackingId         | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                   |
      | hubId              | {hub-id-7}                                                                   |
      | taskId             | 1                                                                            |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                |
      | area             | 31 Kaki Bukit                             |
      | areaVariations   | 31 Kaki Bukit, Bukit Kaki                 |
      | keywords         | place {date: 0 days next, yyyyMMddHHmmss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}        |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}        |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                    |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
      | alsoSearchInHub            | true                            |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString}                           |
      | parcelSize | Small                                                                          |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "31 Kaki Bukit" is displayed in row 1 on Station Route page
    And Operator verify keyword match "place {date: 0 days next, yyyyMMddHHmmss}" is displayed in row 1 on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments
  Scenario: Operator Search Tracking IDs on Station Route - Include Parcel In Hub and Shipment Filters
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-7}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "50 Jalan Sultan {date: 0 days next, yyyyMMddHHmmss}","address2": "centre {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id-7}}                       |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id-7}}                       |
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
      | hubId     | {hub-id-7}                               |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                 |
      | area             | 50 Jalan Sultan                            |
      | areaVariations   | 50 Jalan, Jalan Sultan                     |
      | keywords         | centre {date: 0 days next, yyyyMMddHHmmss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}         |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}         |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                    |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
      | alsoSearchInHub            | true                            |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                     |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString}                           |
      | parcelSize | Small                                                                          |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "50 Jalan Sultan" is displayed in row 1 on Station Route page
    And Operator verify keyword match "centre {date: 0 days next, yyyyMMddHHmmss}" is displayed in row 1 on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                     |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString}                           |
      | parcelSize | Small                                                                          |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName} |
    And Operator verify area match "50 Jalan Sultan" is displayed in row 1 on Station Route page
    And Operator verify keyword match "centre {date: 0 days next, yyyyMMddHHmmss}" is displayed in row 1 on Station Route page

  @DeleteCreatedShipments
  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - No Active Driver
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-7}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "10 Anson Road {date: 0 days next, yyyyMMddHHmmss}","address2": "plaza {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | hubId     | {hub-id-7}                               |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                    |
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

  @DeleteCreatedShipments
  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - No Orders Found
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-7}"
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                    |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verifies that error react notification displayed:
      | top | No orders found |

  @ArchiveRouteCommonV2
  Scenario: Operator Search Tracking IDs on Station Route - Invalid Additional Tracking IDs
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "17 Eunos Techpark {date: 0 days next, yyyyMMddHHmmss}","address2": "kaki {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | Completed                          |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name}                                                                            |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd}                                                       |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd}                                                       |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd}                                                       |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd}                                                       |
      | additionalTids             | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verifies that error react notification displayed:
      | top | These tracking IDs are invalid: {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}, {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |

  @ArchiveRouteCommonV2 @DeleteCreatedShipments
  Scenario: Operator Search Tracking IDs on Station Route - Invalid Additional Tracking IDs and No Orders Found
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-7}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "09 Telok Blangah {date: 0 days next, yyyyMMddHHmmss}","address2": "industrial {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | Completed                          |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name}                                                                            |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd}                                                       |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd}                                                       |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd}                                                       |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd}                                                       |
      | additionalTids             | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId},{KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verifies that error react notification displayed:
      | top | These tracking IDs are invalid: {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}, {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    Then Operator verifies that error react notification displayed:
      | top | No orders found |

  @ArchiveRouteCommonV2 @DeleteCreatedShipments @DeleteDriverV2
  Scenario: Operator Search Tracking IDs on Station Route - Include Parcel In Hub - Invalid Orders
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-7}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "Blk 503 Wood {date: 0 days next, yyyyMMddHHmmss}","address2": "land {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | Completed                          |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                    |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
      | alsoSearchInHub            | true                            |
    And Operator click Assign drivers button on Station Route page
    When Operator filter parcels table on Station Route page:
      | trackingId            | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | shownOnlyMatchingArea | false                                      |
    Then Operator verify parcels table not contains "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" value in "trackingId" column on Station Route page
    When Operator filter parcels table on Station Route page:
      | trackingId            | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | shownOnlyMatchingArea | false                                      |
    Then Operator verify parcels table not contains "{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}" value in "trackingId" column on Station Route page
