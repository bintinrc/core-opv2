@FirstMile @AddressesGrouping @SG
Feature: Shipper Address Configuration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Pickup Address String
    Given API Shipper - Operator delete all shipper addresses by shipper global id "{shipper-v4-id}"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {shipper-v4-id}                                                                                                                                                                                                                                                 |
      | generateAddress       | null                                                                                                                                                                                                                                                            |
      | shipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    Given Operator loads Group Addresses page
    Then Operator verifies page url ends with "group-addresses"
    And Operator waits for 60 seconds
    When Operator search address "{address-keyword}" on Group Addresses page
    Then Operator verify that address "{address-keyword}" is displayed on pickup address column
    And Operator verify search result is displayed on list of pickup addresses

  Scenario: Search Addresses Detail on Group Addresses Page
    Given API Shipper - Operator delete all shipper addresses by shipper global id "{shipper-v4-id}"
    Given API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                                 |
      | noOfAddress                 | 4                                                                                                                                                                                                                                                               |
      | withLatLong                 | YES                                                                                                                                                                                                                                                             |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    Given API First Mile - Operator group shipper address using data below :
      | request | {"group_shipper_address_id" : {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, "shipper_address_ids" : [{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]},{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}]} |
    When Operator loads Group Addresses page
    Then Operator verifies page url ends with "group-addresses"
    And Operator waits for 60 seconds
    When Operator search address "{address-keyword}" on Group Addresses page
    Then Operator verify that address "{address-keyword}" is displayed on pickup address column
    And Operator verify search result is displayed on list of pickup addresses

  Scenario: Filter Shipper Address by Zone
    Given API Shipper - Operator delete all shipper addresses by shipper global id "{shipper-v4-id}"
    Given API Shipper - Operator create new shipper address using data below:
      | shipperId             | {shipper-v4-id}                                                                                                                                                                                                                                                 |
      | generateAddress       | null                                                                                                                                                                                                                                                            |
      | shipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    Given Operator loads Group Addresses page
    Then Operator verifies page url ends with "group-addresses"
    And Operator waits for 60 seconds
    When Operator select zone "{zone-name-2}" on Group Addresses page
    And Operator clicks on the load selection button on Group Addresses page
    And Operator verify search result is displayed on list of pickup addresses

  Scenario: Filter Shipper Address by Grouping
    Given API Shipper - Operator delete all shipper addresses by shipper global id "{shipper-v4-id}"
    Given API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                                 |
      | noOfAddress                 | 2                                                                                                                                                                                                                                                               |
      | withLatLong                 | YES                                                                                                                                                                                                                                                             |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    Given API First Mile - Operator group shipper address using data below :
      | request | {"group_shipper_address_id" : {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, "shipper_address_ids" : [{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]},{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}]} |
    When Operator loads Group Addresses page
    Then Operator verifies page url ends with "group-addresses"
    And Operator waits for 60 seconds
    When Operator search address "{address-keyword}" on Group Addresses page
    When Operator select "Grouping" on Grouping option
    And Operator clicks on the load selection button on Group Addresses page
    Then Operator verify that address "{address-keyword}" is displayed on pickup address column
    And Operator verify search result is displayed on list of pickup addresses

  Scenario: Filter Shipper Address by Address Creation Date
    Given API Shipper - Operator delete all shipper addresses by shipper global id "{shipper-v4-id}"
    Given API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                                 |
      | noOfAddress                 | 2                                                                                                                                                                                                                                                               |
      | withLatLong                 | YES                                                                                                                                                                                                                                                             |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
     When Operator loads Group Addresses page
    Then Operator verifies page url ends with "group-addresses"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}"

  Scenario: Filter Shipper Address by Latest Pickup Date
    Given DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    Given API Operator creates shipper address using below data:
        | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                                 |
        | noOfAddress                 | 1                                                                                                                                                                                                                                                               |
        | withLatLong                 | YES                                                                                                                                                                                                                                                             |
        | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
      And API Core - Operator create reservation using data below:
        | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_address_id":{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
      When Operator loads Group Addresses page
        Then Operator verifies page url ends with "group-addresses"
      And Operator waits for 20 seconds
      And Operator chooses start and end date on Address PickUp date using the following data:
        | From | {date: 1 days ago,  dd/MM/yyyy} |
        | To   | {date: 1 days next, dd/MM/yyyy} |
      And Operator clicks on the load selection button on Group Addresses page
      And Operator waits for 60 seconds
      And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
      Then Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"

  Scenario: Filter Shipper Address After Update Lat Long
    Given DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    Given API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                                 |
      | noOfAddress                 | 1                                                                                                                                                                                                                                                               |
      | withLatLong                 | YES                                                                                                                                                                                                                                                             |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":50.5,"longitude":50.5,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Group Addresses page
    Then Operator verifies page url ends with "group-addresses"
    And Operator waits for 40 seconds
    And Operator select zone "AUTO-FM-ZONE" on Group Addresses page
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button on Group Addresses page
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    When Operator loads Shipper Address Configuration page
    Then Operator updates the CSV file with below data:
      | fileName    | Update_Address_Lat_Long(2).csv                   |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}    |
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator selects "Verified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Update_Address_Lat_Long(2).csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload success message is displayed for success count "1"
    When Operator loads Group Addresses page
    Then Operator verifies page url ends with "group-addresses"
    And Operator waits for 40 seconds
    And Operator select zone "DYO1" on Group Addresses page
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button on Group Addresses page
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    Then Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"

  Scenario: Filter Shipper Address After Update Pickup Type
    Given DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    Given API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                                 |
      | noOfAddress                 | 1                                                                                                                                                                                                                                                               |
      | withLatLong                 | YES                                                                                                                                                                                                                                                             |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":50.5,"longitude":50.5,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Group Addresses page
    Then Operator verifies page url ends with "group-addresses"
    And Operator waits for 40 seconds
    And Operator select zone "AUTO-FM-ZONE" on Group Addresses page
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button on Group Addresses page
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]} |
      | requestBody | {"pickup_type": "HYBRID"}                     |
    When Operator loads Group Addresses page
    And Operator waits for 40 seconds
    Then Operator verifies page url ends with "group-addresses"
    And Operator waits for 40 seconds
    And Operator select zone "LM - AUTO-FM-ZONE" on Group Addresses page
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button on Group Addresses page
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    Then Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op