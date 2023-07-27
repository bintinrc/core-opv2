@FirstMile @ShipperAddressConfiguration @UpdateLatLong @Part2
Feature: Shipper Address Configuration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath
  Scenario: Success Bulk Update Shipper Addresses Lat Long
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 2                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    Then Operator updates the CSV file with below data:
      | fileName    | Success_Bulk_Update_All_Shipper_Addresses.csv    |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    Then Operator updates the CSV file with below data:
      | fileName    | Success_Bulk_Update_All_Shipper_Addresses.csv    |
      | rowIndex    | 2                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Success_Bulk_Update_All_Shipper_Addresses.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload success message is displayed for success count "2"
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "1.2,100.1" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]}"
    Then Operator verifies table is filtered "lat_long" based on input in "1.2,100.1" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long

  Scenario: Success Bulk Update Duplicate Shipper Addresses Lat Long
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    Then Operator updates the CSV file with below data:
      | fileName    | Success_Bulk_Update_Duplicate_Shipper_Addresses.csv |
      | rowIndex    | 1                                                   |
      | columnIndex | 0                                                   |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}    |
    Then Operator updates the CSV file with below data:
      | fileName    | Success_Bulk_Update_Duplicate_Shipper_Addresses.csv |
      | rowIndex    | 2                                                   |
      | columnIndex | 0                                                   |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}    |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Success_Bulk_Update_Duplicate_Shipper_Addresses.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload success message is displayed for success count "1"
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "1.2,50.5" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long

  Scenario: Unable to Bulk Update Some Shipper Addresses Lat Long
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 2                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    Then Operator updates the CSV file with below data:
      | fileName    | Unable_to_bulk_update_some_addresses.csv         |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    Then Operator updates the CSV file with below data:
      | fileName    | Unable_to_bulk_update_some_addresses.csv         |
      | rowIndex    | 2                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Unable_to_bulk_update_some_addresses.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload error message is displayed for error count "1" and total count "3"
    And Operator clicks on the Download Errors button
    Then Operator verifies header names are available in the downloaded CSV file "Update Lat Long Failure Reasons"
      | Address ID      |
      | Pickup Address  |
      | Shipper ID      |
      | Latitude        |
      | Longitude       |
      | Failure Reasons |
    And Operator verifies that the following texts are available on the downloaded file "Update Lat Long Failure Reasons"
      | Address id #991119 Not Found |
    And Operator closes modal popup window
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "1.2,100.1" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]}"
    Then Operator verifies table is filtered "lat_long" based on input in "1.2,100.1" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long

  Scenario: Unable to Bulk Update All Shipper Addresses
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 2                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Unable_to_Bulk_Update_All_Shipper_Addresses.csv" by browsing files in "Update Addresses Lat Long" upload window
    Then Operator verifies upload error message is displayed for error count "2" and total count "2"
    And Operator clicks on the Download Errors button
    Then Operator verifies header names are available in the downloaded CSV file "Update Lat Long Failure Reasons"
      | Address ID      |
      | Pickup Address  |
      | Shipper ID      |
      | Latitude        |
      | Longitude       |
      | Failure Reasons |
    And Operator verifies that the following texts are available on the downloaded file "Update Lat Long Failure Reasons"
      | Address id #991119 Not Found |
      | Address id #881118 Not Found |

  @HappyPath @Debug
  Scenario Outline: View Updated Shipper Address Detail on Update Lat Long Page
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"60 SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","latitude":"1.23","longitude":"1.23","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator selects  following picktypes in the dropdown:
      | <pickupTypeSelect> |
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 60 seconds
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "zones" based on input in "<expectedZoneValue>" in shipper address page
    Then Operator verifies table is filtered "hubs" based on input in "<expectedHubValue>" in shipper address page
    Then Operator verifies table is filtered "pickup_address" based on input in "60 SenokoRd,Singapore, SG, 000000" in shipper address page
    When Operator loads Shipper Address Configuration page
    When API Shipper - Operator updates shipper address using below data:
      | shipperID                   | {shipper-v4-id}            |
      | withLatLong                 | YES                        |
      | addressID                   | <search_value>             |
      | newLatitude                 | <newLatitude>              |
      | newLongitude                | <newLongitude>             |
      | newAddress                  | <newAddress>               |
    And Operator waits for 60 seconds
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Update Lat Long" button
    Then Operator verifies page url ends with "lat-long"
    And Operator selects "Verified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "50.5,50.5" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long
    Then Operator verifies table is filtered "pickup_address" based on input in "<newAddress>, SG, 000000" in shipper address page

    Examples:
      | search_field | search_value                                  |  expectedZoneValue | expectedHubValue | newAddress             | newLatitude | newLongitude | pickupTypeSelect |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]} |  DYO1              | JKB              | 30 SenokoRd,Singapore  | 50.5        |  50.5        | FM-Dedicated     |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op