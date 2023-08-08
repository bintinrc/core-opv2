@FirstMile @ShipperAddressConfiguration @PickupType @Part1
Feature: Shipper Address Configuration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Filter Shipper Address by Multiple Pickup Type - Pickup Type Null
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"994289","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator selects  following picktypes in the dropdown:
      | <pickupTypeSelect> |
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<pickupType>" in shipper address page

    Examples:
      | search_field | search_value                                     | column_datakey        | pickupTypeSelect | pickupType |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | formatted_pickup_type | None assigned    | -          |

  Scenario Outline: Filter Shipper Address by Multiple Pickup Type - Pickup Type Hybrid
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"994289","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickupTypeAPI>"}               |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator selects  following picktypes in the dropdown:
      | <pickupTypeSelect> |
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<pickupType>" in shipper address page

    Examples:
      | search_field | search_value                                     | column_datakey        | pickupTypeSelect | pickupTypeAPI | pickupType |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | formatted_pickup_type | Hybrid           | HYBRID        | Hybrid     |

  Scenario Outline: Filter Shipper Address by Multiple Pickup Type - Pickup Type FM Dedicated
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"994289","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickupTypeAPI>"}               |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator selects  following picktypes in the dropdown:
      | <pickupTypeSelect> |
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<pickupType>" in shipper address page

    Examples:
      | search_field | search_value                                     | column_datakey        | pickupTypeSelect | pickupTypeAPI | pickupType   |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | formatted_pickup_type | FM-Dedicated     | fm_dedicated  | FM Dedicated |

  Scenario Outline: Filter Shipper Address by Multiple Pickup Type - Pickup Type Truck
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"994289","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
      | requestBody | {"pickup_type": "<pickupTypeAPI>"}               |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator selects  following picktypes in the dropdown:
      | <pickupTypeSelect> |
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<pickupType>" in shipper address page

    Examples:
      | search_field | search_value                                     | column_datakey        | pickupTypeSelect | pickupTypeAPI | pickupType |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | formatted_pickup_type | Truck            | TRUCK         | Truck      |

  Scenario: Filter Shipper Address by Multiple Pickup Type
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 4                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"994289","milkrun_settings":[],"is_milk_run":false} |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]} |
      | requestBody | {"pickup_type": "Hybrid"}                        |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[3]} |
      | requestBody | {"pickup_type": "fm_dedicated"}                  |
    And API Operator update the pickup type for the shipper address
      | addressId   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[4]} |
      | requestBody | {"pickup_type": "TRUCK"}                         |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator selects  following picktypes in the dropdown:
      | None assigned |
      | Hybrid        |
      | FM-Dedicated  |
      | Truck         |
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "formatted_pickup_type" based on input in "-" in shipper address page
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]}"
    Then Operator verifies table is filtered "formatted_pickup_type" based on input in "Hybrid" in shipper address page
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[3]}"
    Then Operator verifies table is filtered "formatted_pickup_type" based on input in "FM Dedicated" in shipper address page
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[4]}"
    Then Operator verifies table is filtered "formatted_pickup_type" based on input in "Truck" in shipper address page

  Scenario Outline: Search Shipper Addresses on Pickup Type Configure Page - <dataset_name>
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                           |
      | noOfAddress                 | 1                                                                                                                                                                                                                                         |
      | withLatLong                 | NO                                                                                                                                                                                                                                        |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"994289","latitude":"1.463","longitude":"103.801","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<search_value>" in shipper address page

    Examples:
      | dataset_name             | search_field   | search_value                                     | column_datakey        |
      | Search by Address ID     | Address ID     | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | shipper_address_id    |
      | Search by Pickup Address | Pickup Address | 15SenokoRd,Singapore, SG, 994289                 | pickup_address        |
      | Search by Shipper ID     | Shipper ID     | {shipper-v4-legacy-id}                           | legacy_shipper_id     |
      | Search by Pickup Type    | Pickup Type    | -                                                | formatted_pickup_type |
      | Search by Zone           | Zones          | -                                                | zones                 |
      | Search by Hub            | Hubs           | -                                                | hubs                  |

  Scenario Outline: Filter Shipper Address by Address ID
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"994289","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator selects  following picktypes in the dropdown:
      | <pickupTypeSelect> |
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<search_value>" in shipper address page

    Examples:
      | search_field | search_value                                     | column_datakey     | pickupTypeSelect |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | shipper_address_id | None assigned    |

  @HappyPath
  Scenario Outline: Download CSV of Address Pickup Type
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"994289","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator selects  following picktypes in the dropdown:
      | <pickupTypeSelect> |
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<search_value>" in shipper address page
    And Operator clicks on the Download Addresses button
    And Verify that csv file is downloaded with filename: "Downloaded Pickup Addresses_<current_Date>.csv"
    Then Operator verifies header names are available in the downloaded CSV file "Downloaded Pickup Addresses"
      | Address ID     |
      | Pickup Address |
      | Shipper ID     |
      | Pickup Type    |
      | Zones          |
      | Hubs           |
    And Operator verifies that the following texts are available on the downloaded file "Downloaded Pickup Addresses"
      | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |

    Examples:
      | search_field | search_value                                     | column_datakey     | pickupTypeSelect |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | shipper_address_id | None assigned    |

  Scenario: Download CSV of Address Pickup Type Template
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator clicks on the Download CSV Template button
    And Verify that csv file is downloaded with filename: "CSV Template_Pickup Address Pickup Type.csv"
    Then Operator verifies header names are available in the downloaded CSV file "CSV Template_Pickup Address Pickup Type"
      | Address ID     |
      | Pickup Address |
      | Shipper ID     |
      | Pickup Type    |

  Scenario: Upload Addresses Pickup Type CSV by Browsing File
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 2                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    Then Operator updates the CSV file with below data:
      | fileName    | Upload_Addresses_Pickup_Type_CSV_Valid_Input.csv |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator uploads csv file: "Upload_Addresses_Pickup_Type_CSV_Valid_Input.csv" by browsing files in "Configure Address Pickup Type" upload window
    Then Operator verifies the success message is displayed on uploading the pickup type file "1"

  Scenario: Upload Addresses Pickup Type CSV by Drag and Drop
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 2                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    Then Operator updates the CSV file with below data:
      | fileName    | Upload_Addresses_Pickup_Type_CSV_Valid_Input.csv |
      | rowIndex    | 1                                                |
      | columnIndex | 0                                                |
      | value       | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} |
    When Operator loads Shipper Address Configuration page
    And Operator clicks on the "Configure Pickup Type" button
    Then Operator verifies page url ends with "pickup-type"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator waits for 30 seconds
    And Operator clicks on the "Update Addresses Lat Long" button to upload CSV file
    And Operator drag and drop csv file: "Upload_Addresses_Pickup_Type_CSV_Valid_Input.csv" in "Configure Address Pickup Type" upload window
    Then Operator verifies the success message is displayed on uploading the pickup type file "1"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op