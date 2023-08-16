@FirstMile @ReservationUpdate
Feature: Reservation Update

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Update Address Lat Long - Pending Reservation for Today
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator update pick up date and time for the reservation using data below:
      | reservationId             |  {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}                                     |
      | reservationUpdateRequest  | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" , "reservation_type_value" :0 } |
    Then Operator updates the CSV file with below data:
      | fileName    | Update_Address_Lat_Long.csv                      |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator clicks on the load selection button
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Update_Address_Lat_Long.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload success message is displayed for success count "1"
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "50.5,50.5" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long
    Then DB Core - verifies that zone type is equal to "FIRST_MILE" and zone id is not null for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"
    Then DB Core - verifies that latitude is equal to "50.5" and longitude is equal to "50.5" and for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"

  Scenario Outline: Update Address Lat Long - Pending Reservation for Upcoming Date - <dataset_name>
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickUpType>"}                  |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Then Operator updates the CSV file with below data:
      | fileName    | Update_Address_Lat_Long.csv                      |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator clicks on the load selection button
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Update_Address_Lat_Long.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload success message is displayed for success count "1"
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "50.5,50.5" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long
    Then DB Core - verifies that zone type is equal to "<zone>" and zone id is not null for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"
    Then DB Core - verifies that latitude is equal to "50.5" and longitude is equal to "50.5" and for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"

    Examples:
      | dataset_name             | pickUpType   | zone        |
      | Pickup Type Hybrid       | Truck        | FIRST_MILE  |
      | Pickup Type FM Dedicated | fm_dedicated | FIRST_MILE  |
      | Pickup Type Truck        | Hybrid       | LAST_MILE   |

  Scenario Outline: Update Address Pickup Type - Success Reservation - <dataset_name>
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "Hybrid"}                        |
    And API Core - Operator create reservation using data below:
      | reservationRequest  | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickUpType>"}                  |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-0} , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
      And API Core - Operator add reservation to route using data below:
      | routeId                |   {KEY_CREATED_ROUTE_ID}                           |
      | reservationId          |   {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}         |
    And API Core - Operator force success waypoint via route manifest:
      | routeId                |   {KEY_CREATED_ROUTE_ID}                                   |
      | waypointId             |   {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}         |
    And Operator waits for 30 seconds
    Then DB Core - verifies that zone type is equal to "<zone>" and zone id is null for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"
    Then DB Core - verifies that latitude is equal to "1.2881" and longitude is equal to "103.74" and for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"

    Examples:
      | dataset_name             | pickUpType     | zone        |
      | Pickup Type Hybrid       | Truck          | FIRST_MILE  |
      | Pickup Type FM Dedicated | fm_dedicated   | FIRST_MILE  |
      | Pickup Type Truck        | Hybrid         | LAST_MILE   |

  Scenario: Update Address Lat Long - Success Reservation
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-0} , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | routeId                |   {KEY_CREATED_ROUTE_ID}                           |
      | reservationId          |   {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}         |
    And API Core - Operator force success waypoint via route manifest:
      | routeId                |   {KEY_CREATED_ROUTE_ID}                                   |
      | waypointId             |   {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}         |
    Then Operator updates the CSV file with below data:
      | fileName    | Update_Address_Lat_Long.csv                      |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator clicks on the load selection button
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Update_Address_Lat_Long.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload success message is displayed for success count "1"
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "50.5,50.5" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long
    Then DB Core - verifies that zone type is equal to "FIRST_MILE" and zone id is null for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"
    Then DB Core - verifies that latitude is equal to "1.2881" and longitude is equal to "103.74" and for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"

  Scenario Outline: Update Address Lat Long - Fail Reservation - <dataset_name>
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickUpType>"}                  |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-0} , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | routeId                |   {KEY_CREATED_ROUTE_ID}                           |
      | reservationId          |   {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}         |
    And API Core - Operator force fail waypoint via route manifest:
      | routeId                |   {KEY_CREATED_ROUTE_ID}                                    |
      | waypointId             |   {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}          |
      | failureReasonId        |   {failure-reason-id}                                       |
    Then Operator updates the CSV file with below data:
      | fileName    | Update_Address_Lat_Long.csv                      |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator clicks on the load selection button
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Update_Address_Lat_Long.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload success message is displayed for success count "1"
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "50.5,50.5" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long
    Then DB Core - verifies that zone type is equal to "<zone>" and zone id is null for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"
    Then DB Core - verifies that latitude is equal to "1.2881" and longitude is equal to "103.74" and for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"

    Examples:
      | dataset_name             | pickUpType     | zone        |
      | Pickup Type Hybrid       | Truck          | FIRST_MILE  |
      | Pickup Type FM Dedicated | fm_dedicated   | FIRST_MILE  |
      | Pickup Type Truck        | Hybrid         | LAST_MILE   |

  Scenario Outline: Update Address Pickup Type - Fail Reservation - <dataset_name>
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "Hybrid"}                        |
    And API Core - Operator create reservation using data below:
      | reservationRequest  | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickUpType>"}                  |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-0} , "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add reservation to route using data below:
      | routeId                |   {KEY_CREATED_ROUTE_ID}                           |
      | reservationId          |   {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}         |
    And API Core - Operator force fail waypoint via route manifest:
      | routeId                |   {KEY_CREATED_ROUTE_ID}                           |
      | waypointId             |   {KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId} |
      | failureReasonId        |   {failure-reason-id}                              |
    Then DB Core - verifies that zone type is equal to "<zone>" and zone id is null for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"
    Then DB Core - verifies that latitude is equal to "1.2881" and longitude is equal to "103.74" and for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"

    Examples:
      | dataset_name             | pickUpType     | zone        |
      | Pickup Type Hybrid       | Truck          | FIRST_MILE  |
      | Pickup Type FM Dedicated | fm_dedicated   | FIRST_MILE  |
      | Pickup Type Truck        | Hybrid         | LAST_MILE   |

  Scenario Outline: Update Address Pickup Type - Pending Reservation for Today - <dataset_name>
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "Hybrid"}                        |
    And API Core - Operator create reservation using data below:
      | reservationRequest  | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator update pick up date and time for the reservation using data below:
      | reservationId             |  {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}                                     |
      | reservationUpdateRequest  | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" , "reservation_type_value" :0 } |
    Then Operator updates the CSV file with below data:
      | fileName    | Update_Address_Lat_Long.csv                      |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickUpType>"}                  |
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator clicks on the load selection button
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Update_Address_Lat_Long.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload success message is displayed for success count "1"
    Then DB Core - verifies that zone type is equal to "<zone>" and zone id is not null for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"
    Then DB Core - verifies that latitude is equal to "50.5" and longitude is equal to "50.5" and for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"

    Examples:
      | dataset_name             | pickUpType   | zone        |
      | Pickup Type Hybrid       | Truck        | FIRST_MILE  |
      | Pickup Type FM Dedicated | fm_dedicated | FIRST_MILE  |
      | Pickup Type Truck        | Hybrid       | LAST_MILE   |

  Scenario Outline: Update Address Pickup Type - Pending Reservation for Upcoming Date - <dataset_name>
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "Hybrid"}                        |
    And API Core - Operator create reservation using data below:
      | reservationRequest  | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, "pickup_start_time":"{date: 0 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 0 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Core - Operator update pick up date and time for the reservation using data below:
      | reservationId             |  {KEY_LIST_OF_CREATED_RESERVATIONS[1].id}                                     |
      | reservationUpdateRequest  | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{date: 1 days next, yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{date: 1 days next, yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" , "reservation_type_value" :0 } |
    Then Operator updates the CSV file with below data:
      | fileName    | Update_Address_Lat_Long.csv                      |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickUpType>"}                  |
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator clicks on the load selection button
    And Operator waits for 10 seconds
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Update_Address_Lat_Long.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload success message is displayed for success count "1"
    Then DB Core - verifies that zone type is equal to "<zone>" and zone id is not null for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"
    Then DB Core - verifies that latitude is equal to "50.5" and longitude is equal to "50.5" and for waypointId "{KEY_LIST_OF_CREATED_RESERVATIONS[1].waypointId}"

    Examples:
      | dataset_name             | pickUpType   | zone        |
      | Pickup Type Hybrid       | Truck        | FIRST_MILE  |
      | Pickup Type FM Dedicated | fm_dedicated | FIRST_MILE  |
      | Pickup Type Truck        | Hybrid       | LAST_MILE   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op