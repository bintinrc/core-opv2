@FirstMile @ReservationCreation
Feature: Reservation Creation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath
  Scenario: [SG, ID, PH, MY] Create Reservation Given the Address Pickup Type is None Assigned
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","latitude":50.5,"longitude":50.5,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
  And  DB Core - get waypoint Id from reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
  Then DB Core - verifies that zone type is equal to "FIRST_MILE" and zone id is not null for waypointId "{KEY_WAYPOINT_ID}"

  @SystemIdNotSg @default-vn
  Scenario: [VN, TH] Create Reservation Given the Address Pickup Type is None Assigned
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"VN","latitude":24.5,"longitude":47.5,"postcode":"124100","milkrun_settings":[],"is_milk_run":false}           |
    When Operator loads Shipper Address Configuration page
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And  DB Core - get waypoint Id from reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then DB Core - verifies that zone type is equal to "LAST_MILE" and zone id is not null for waypointId "{KEY_WAYPOINT_ID}"

  Scenario: Create Reservation Given the Lat Long Fall in a Zone
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","latitude":50.5,"longitude":50.5,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And  DB Core - get waypoint Id from reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then DB Core - verifies that zone type is equal to "FIRST_MILE" and zone id is not null for waypointId "{KEY_WAYPOINT_ID}"

  Scenario: Create Reservation Given the Lat Long does not Fall in Any Zone
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | NO                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And  DB Core - get waypoint Id from reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then DB Core - verifies that zone type is equal to "FIRST_MILE" and zone id is null for waypointId "{KEY_WAYPOINT_ID}"

  @HappyPath
  Scenario Outline: Create Reservation Given the Address Pickup Type is Configured - HYBRID
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","latitude":50.5,"longitude":50.5,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickupTypeAPI>"}            |
    And Operator waits for 10 seconds
    When Operator loads Shipper Address Configuration page
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":<search_value>, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And  DB Core - get waypoint Id from reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then DB Core - verifies that zone type is equal to "LAST_MILE" and zone id is not null for waypointId "{KEY_WAYPOINT_ID}"

    Examples:
      | search_value                                  | pickupTypeAPI |
      | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]} | HYBRID        |

  @HappyPath
  Scenario Outline:: Create Reservation Given the Address Pickup Type is Configured - FM Dedicated
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","latitude":50.5,"longitude":50.5,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickupTypeAPI>"}            |
    When Operator loads Shipper Address Configuration page
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":<search_value>, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And  DB Core - get waypoint Id from reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then DB Core - verifies that zone type is equal to "FIRST_MILE" and zone id is not null for waypointId "{KEY_WAYPOINT_ID}"

    Examples:
      | search_value                                  | pickupTypeAPI |
      | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]} | FM_DEDICATED  |

  @HappyPath
  Scenario Outline:: Create Reservation Given the Address Pickup Type is Configured - Truck
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","latitude":50.5,"longitude":50.5,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickupTypeAPI>"}            |
    When Operator loads Shipper Address Configuration page
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":<search_value>, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And  DB Core - get waypoint Id from reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then DB Core - verifies that zone type is equal to "FIRST_MILE" and zone id is not null for waypointId "{KEY_WAYPOINT_ID}"

    Examples:
      | search_value                                  | pickupTypeAPI |
      | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]} | Truck         |

  @HappyPath
    Scenario Outline: Create Reservation After Update Lat Long
     When Operator loads Shipper Address Configuration page
     When API Operator creates shipper address using below data:
       | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
       | noOfAddress                 | 2                                                                                                                                                                                                |
       | withLatLong                 | NO                                                                                                                                                                                               |
       | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    Then Operator updates the CSV file with below data:
      | fileName    | Create_Reservation_After_Update_Lat_Long.csv     |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    Then Operator updates the CSV file with below data:
      | fileName    | Create_Reservation_After_Update_Lat_Long.csv     |
      | rowIndex    | 2                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator chooses start and end date on Address Creation date using the following data:
    | From | {gradle-previous-1-day-dd/MM/yyyy} |
    | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator clicks on the load selection button
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Create_Reservation_After_Update_Lat_Long.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload success message is displayed for success count "2"
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "50.5,50.5" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]}"
    Then Operator verifies table is filtered "lat_long" based on input in "50.5,50.5" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long
    And Operator waits for 30 seconds
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":<search_value>, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And  DB Core - get waypoint Id from reservation id "{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}"
    Then DB Core - verifies that zone type is equal to "FIRST_MILE" and zone id is not null for waypointId "{KEY_WAYPOINT_ID}"

      Examples:
        | search_value                                     |
        | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op