@OperatorV2 @Core @Route @NewFeatures @StationRoute @SearchTrackingIdsOnStationRoutePart2
Feature: Search Tracking IDs on Station Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteShipment
  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - Match To Multiple Coverages - Duplicate Area
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-7}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-7}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-7}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "house {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-7}
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                  |
      | area             | 998 Toa Payoh                               |
      | areaVariations   | North {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}  |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}         |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}         |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                  |
      | area             | 998 Toa Payoh                               |
      | areaVariations   | North {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress2}  |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[3].id}         |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[4].id}         |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                   |
      | shipmentType               | AIR_HAUL                       |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                       |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString}                             |
      | parcelSize | Small                                                                            |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[1].id} - {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} |
    And Operator verify area match "998 Toa Payoh" is displayed in row 1 on Station Route page
    And Operator verify keyword match "home {gradle-current-date-yyyyMMddHHmmsss}" is displayed in row 1 on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                       |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString}                             |
      | parcelSize | Small                                                                            |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[3].id} - {KEY_LIST_OF_CREATED_DRIVERS[3].firstName} |
    And Operator verify area match "998 Toa Payoh" is displayed in row 1 on Station Route page
    And Operator verify keyword match "house {gradle-current-date-yyyyMMddHHmmsss}" is displayed in row 1 on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteShipment
  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - Match To Multiple Coverages - Duplicate Keyword
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-7}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-7}
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-7}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "another address {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-7}
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                          |
      | area             | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}          |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}          |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                            |
      | area             | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1}            |
      | areaVariations   | AreaVariation 2 {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress2}            |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[3].id}                   |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[4].id}                   |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                   |
      | shipmentType               | AIR_HAUL                       |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                       |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString}                             |
      | parcelSize | Small                                                                            |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[1].id} - {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} |
    And Operator verify area match "{KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}" is displayed in row 1 on Station Route page
    And Operator verify keyword match "{KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}" is displayed in row 1 on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                       |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString}                             |
      | parcelSize | Small                                                                            |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[3].id} - {KEY_LIST_OF_CREATED_DRIVERS[3].firstName} |
    And Operator verify area match "{KEY_LIST_OF_CREATED_ORDERS[2].toAddress1}" is displayed in row 1 on Station Route page
    And Operator verify keyword match "{KEY_LIST_OF_CREATED_ORDERS[2].toAddress2}" is displayed in row 1 on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Search Tracking IDs on Station Route - Include Parcel In Hub - Valid Orders - Hub Inbound Scan
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id-7}}           |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                 |
      | area             | 998 Toa Payoh North                        |
      | areaVariations   | 998 Toa Payoh, Payoh North                 |
      | keywords         | home {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                   |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | alsoSearchInHub            | true                           |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_CREATED_ORDER.trackingId}                                                   |
      | address    | {KEY_CREATED_ORDER.buildToAddressString}                                         |
      | parcelSize | Small                                                                            |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[1].id} - {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} |
    And Operator verify area match "998 Toa Payoh North" is displayed in row 1 on Station Route page
    And Operator verify keyword match "home {gradle-current-date-yyyyMMddHHmmsss}" is displayed in row 1 on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2
  Scenario: Operator Search Tracking IDs on Station Route - Include Parcel In Hub - Valid Orders - Parcel Sweep Scan
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Operator sweep parcel:
      | scan  | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | hubId | {hub-id-7}                                 |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                 |
      | area             | 998 Toa Payoh North                        |
      | areaVariations   | 998 Toa Payoh, Payoh North                 |
      | keywords         | home {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                   |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | alsoSearchInHub            | true                           |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_CREATED_ORDER.trackingId}                                                   |
      | address    | {KEY_CREATED_ORDER.buildToAddressString}                                         |
      | parcelSize | Small                                                                            |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[1].id} - {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} |
    And Operator verify area match "998 Toa Payoh North" is displayed in row 1 on Station Route page
    And Operator verify keyword match "home {gradle-current-date-yyyyMMddHHmmsss}" is displayed in row 1 on Station Route page

  @DeleteDriverV2 @DeleteCoverageV2 @DeleteShipment
  Scenario: Operator Search Tracking IDs on Station Route - Include Parcel In Hub and Shipment Filters
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-7}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-7}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id-7}}           |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    And API Route - Operator create new coverage:
      | hubId            | {hub-id-7}                                 |
      | area             | 998 Toa Payoh North                        |
      | areaVariations   | 998 Toa Payoh, Payoh North                 |
      | keywords         | home {gradle-current-date-yyyyMMddHHmmsss} |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}        |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}        |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                   |
      | shipmentType               | AIR_HAUL                       |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | alsoSearchInHub            | true                           |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                                        |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString}                              |
      | parcelSize | Small                                                                            |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[1].id} - {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} |
    And Operator verify area match "998 Toa Payoh North" is displayed in row 1 on Station Route page
    And Operator verify keyword match "home {gradle-current-date-yyyyMMddHHmmsss}" is displayed in row 1 on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[2].trackingId}                                        |
      | address    | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString}                              |
      | parcelSize | Small                                                                            |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[1].id} - {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} |
    And Operator verify area match "998 Toa Payoh North" is displayed in row 1 on Station Route page
    And Operator verify keyword match "home {gradle-current-date-yyyyMMddHHmmsss}" is displayed in row 1 on Station Route page

  @DeleteShipment
  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - No Active Driver
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-7}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-7}
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                   |
      | shipmentType               | AIR_HAUL                       |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}           |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} |
      | parcelSize | Small                                               |
      | driverId   | Unassigned                                          |
    And Operator verify area match is not displayed on Station Route page
    And Operator verify keyword match is not displayed on Station Route page

  @DeleteShipment
  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - No Orders Found
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-7}
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-7}                   |
      | shipmentType               | AIR_HAUL                       |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verifies that error react notification displayed:
      | top | No orders found |

  @DeleteOrArchiveRoute
  Scenario: Operator Search Tracking IDs on Station Route - Invalid Additional Tracking IDs
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
      | granularStatus | Completed                         |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name}                                                                            |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd}                                                        |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd}                                                        |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                                        |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                                        |
      | additionalTids             | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]},{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verifies that error react notification displayed:
      | top | These tracking IDs are invalid: {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}, {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |

  @DeleteOrArchiveRoute @DeleteShipment
  Scenario: Operator Search Tracking IDs on Station Route - Invalid Additional Tracking IDs and No Orders Found
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-7}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
      | granularStatus | Completed                         |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name}                                                                            |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd}                                                        |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd}                                                        |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                                        |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                                        |
      | additionalTids             | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]},{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verifies that error react notification displayed:
      | top | These tracking IDs are invalid: {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]}, {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator verifies that error react notification displayed:
      | top | No orders found |

  @DeleteOrArchiveRoute @DeleteShipment @DeleteDriverV2
  Scenario: Operator Search Tracking IDs on Station Route - Include Parcel In Hub - Invalid Orders
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-7}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-7}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |

    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
      | granularStatus | Completed                         |

    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{driver-type-name}", "availability": true, "cod_limit": 50000, "vehicles": [ { "active": true, "vehicleNo": "7899168", "vehicleType": "{vehicle-type-name}", "ownVehicle": false, "capacity": 10000 } ], "contacts": [ { "active": true, "type": "Mobile Phone", "details": "+65 81237890" } ], "zone_preferences": [ { "latitude": 1.3597220659709373, "longitude": 103.82701942695314, "maxWaypoints": 100, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 500 } ], "max_on_demand_jobs": 1, "username": "DSR3{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-next-0-day-yyyy-MM-dd}", "employment_end_date": "{gradle-next-3-day-yyyy-MM-dd}", "hub_id": {hub-id-7}, "hub": { "displayName": "{hub-name-7}", "value": {hub-id-7} } } |

    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name}                     |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | alsoSearchInHub            | true                           |
    And Operator click Assign drivers button on Station Route page
    Then Operator verifies that error react notification displayed:
      | top | No orders found |
