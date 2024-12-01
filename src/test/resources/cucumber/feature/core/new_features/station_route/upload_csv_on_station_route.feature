@OperatorV2 @Core @Route @NewFeatures @StationRoute @UploadCsvOnStationRoute
Feature: Upload CSV on Station Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteCreatedShipments @MediumPriority
  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV on Station Route - CSV file from Downloaded CSV
    Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-12}"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "27 Sentosa Golf {date: 0 days next, yyyyMMddHHmmss}","address2": "club {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | hubId     | {hub-id-12}                              |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-12}, "hub": { "displayName": "{hub-name-12}", "value": {hub-id-12} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-12}, "hub": { "displayName": "{hub-name-12}", "value": {hub-id-12} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-12}                              |
      | area             | 27 Sentosa Golf                          |
      | areaVariations   | Golf {date: 0 days next, yyyyMMddHHmmss} |
      | keywords         | club {date: 0 days next, yyyyMMddHHmmss} |
      | primaryDriverId  | {KEY_DRIVER_LIST_OF_DRIVERS[1].id}       |
      | fallbackDriverId | {KEY_DRIVER_LIST_OF_DRIVERS[2].id}       |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-12}                   |
      | shipmentType               | AIR_HAUL                        |
      | shipmentDateFrom           | {date: 0 days next, yyyy-MM-dd} |
      | shipmentDateTo             | {date: 1 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {date: 0 days next, yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {date: 1 days next, yyyy-MM-dd} |
    And Operator click Download CSV button on Station Route page
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name-12}" hub on Station Route page
    And Operator upload downloaded CSV file on Station Route page
    Then Operator verify parcels are displayed on Upload CSV tab on Station Route page:
      | trackingId                                 | address                                                                                                |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | 27 Sentosa Golf {date: 0 days next, yyyyMMddHHmmss} club {date: 0 days next, yyyyMMddHHmmss} 159363 SG |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                             |
      | address    | 27 Sentosa Golf {date: 0 days next, yyyyMMddHHmmss} club {date: 0 days next, yyyyMMddHHmmss} 159363 SG |
      | parcelSize | Small                                                                                                  |
      | driverId   | Unassigned                                                                                             |

  @DeleteDriverV2 @MediumPriority
  Scenario: Operator Allow Assign Order to Suggested Driver by Upload CSV on Station Route - Valid TIDs, Valid Driver with Valid Hub
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "19 Mandai Chip Tiong {date: 0 days next, yyyyMMddHHmmss}","address2": "estate {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-12}, "hub": { "displayName": "{hub-name-12}", "value": {hub-id-12} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-12}, "hub": { "displayName": "{hub-name-12}", "value": {hub-id-12} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name-12}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId                                 | driverId                           |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    Then Operator verify exactly parcels are displayed on Upload CSV tab on Station Route page:
      | trackingId                                 | driverId                           |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                    |
      | address    | 19 Mandai Chip Tiong {date: 0 days next, yyyyMMddHHmmss} estate {date: 0 days next, yyyyMMddHHmmss} 159363 SG |
      | parcelSize | Small                                                                                                         |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} - {KEY_DRIVER_LIST_OF_DRIVERS[1].firstName}                                |
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                    |
      | address    | 19 Mandai Chip Tiong {date: 0 days next, yyyyMMddHHmmss} estate {date: 0 days next, yyyyMMddHHmmss} 159363 SG |
      | parcelSize | Small                                                                                                         |
      | driverId   | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} - {KEY_DRIVER_LIST_OF_DRIVERS[2].firstName}                                |

  @DeleteDriverV2 @MediumPriority
  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV on Station Route - Valid TIDs, Valid Driver with Invalid Hub
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "457 Jalan Ahmad {date: 0 days next, yyyyMMddHHmmss}","address2": "ibrahim {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-12}, "hub": { "displayName": "{hub-name-12}", "value": {hub-id-12} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-12}, "hub": { "displayName": "{hub-name-12}", "value": {hub-id-12} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId                                 | driverId                           |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And Operator verify Tracking IDs are not displayed in Invalid Input dialog on Station Route page
    And Operator verify Driver IDs in Invalid Input dialog on Station Route page:
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator click Cancel button in Invalid Input dialog on Station Route page
    Then Operator verify Assign Drivers button is disabled on Station Route page

  @DeleteDriverV2 @MediumPriority
  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV on Station Route - Invalid TIDs, Invalid Driver with Invalid Hub
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "8 Woodlands {date: 0 days next, yyyyMMddHHmmss}","address2": "loop {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-12}, "hub": { "displayName": "{hub-name-12}", "value": {hub-id-12} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId  | driverId                           |
      | INVALIDTID1 | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | INVALIDTID2 | 123456                             |
    And Operator verify Tracking IDs in Invalid Input dialog on Station Route page:
      | INVALIDTID1 |
      | INVALIDTID2 |
    And Operator verify Driver IDs in Invalid Input dialog on Station Route page:
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | 123456                             |
    When Operator click Cancel button in Invalid Input dialog on Station Route page
    Then Operator verify Assign Drivers button is disabled on Station Route page

  @MediumPriority
  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV on Station Route - Invalid CSV Format
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId | driverId |
      |            |          |
      |            |          |
    Then Operator verifies that error react notification displayed:
      | top    | Upload failed    |
      | bottom | Invalid CSV data |
    Then Operator verify Assign Drivers button is disabled on Station Route page

  @DeleteDriverV2 @MediumPriority
  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV on Station Route - Duplicate TIDs
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "16 Raffles {date: 0 days next, yyyyMMddHHmmss}","address2": "quay {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-12}, "hub": { "displayName": "{hub-name-12}", "value": {hub-id-12} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name-12}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId                                 | driverId                           |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
    Then Operator verifies that error react notification displayed:
      | top    | Upload failed                                                |
      | bottom | Duplicated TIDs - {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    Then Operator verify Assign Drivers button is disabled on Station Route page

  @DeleteCreatedHubs @MediumPriority
  Scenario: Operator Disallow To Select Hub with Disabled Status on Station Route
    And API Sort - Operator creates 1 new hubs with data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Sort - Operator disable hub with "{KEY_SORT_LIST_OF_CREATED_HUBS[1].id}" hub id
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator cannot select "{KEY_SORT_LIST_OF_CREATED_HUBS[1].name}" hub on Station Route page

  @DeleteDriverV2 @MediumPriority
  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV After Update Selected Hub on Station Route
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "10 Hoe {date: 0 days next, yyyyMMddHHmmss}","address2": "chiang {date: 0 days next, yyyyMMddHHmmss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-12}, "hub": { "displayName": "{hub-name-12}", "value": {hub-id-12} } } |
    And API Driver - Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}-{{TIMESTAMP}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DC1{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{date: 0 days next, yyyy-MM-dd}", "employment_end_date": "{date: 3 days next, yyyy-MM-dd}", "hub_id": {hub-id-12}, "hub": { "displayName": "{hub-name-12}", "value": {hub-id-12} } } |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name-12}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId                                 | driverId                           |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    Then Operator verify exactly parcels are displayed on Upload CSV tab on Station Route page:
      | trackingId                                 | driverId                           |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator verify Tracking IDs are not displayed in Invalid Input dialog on Station Route page
    And Operator verify Driver IDs in Invalid Input dialog on Station Route page:
      | {KEY_DRIVER_LIST_OF_DRIVERS[1].id} |
      | {KEY_DRIVER_LIST_OF_DRIVERS[2].id} |
    When Operator click Cancel button in Invalid Input dialog on Station Route page
    Then Operator verify Assign Drivers button is disabled on Station Route page

  @MediumPriority
  Scenario: Operator Disallow Assign More Than 10.000 Orders to Suggested Driver by Upload CSV on Station Route
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator upload CSV file with more then 10000 rows on Station Route page
    Then Operator verifies that error react notification displayed:
      | top    | Upload failed              |
      | bottom | Max rows of 10000 exceeded |
    Then Operator verify Assign Drivers button is disabled on Station Route page

