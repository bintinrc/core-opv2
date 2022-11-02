@FirstMile @ShipperAddressConfiguration @PickupType
Feature: Shipper Address Configuration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  Scenario Outline: Filter Shipper Address by Multiple Pickup Type - Pickup Type Null
    Given Operator loads Operator portal home page
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
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<pickupType>" in shipper address page

    Examples:
      | search_field | search_value                                     | column_datakey        | pickupTypeSelect | pickupTypeAPI | pickupType |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | formatted_pickup_type | None assigned    |               | -          |


  Scenario Outline: Filter Shipper Address by Multiple Pickup Type - Pickup Type Hybrid
    Given Operator loads Operator portal home page
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
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<pickupType>" in shipper address page

    Examples:
      | search_field | search_value                                     | column_datakey        | pickupTypeSelect | pickupTypeAPI | pickupType |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | formatted_pickup_type | Hybrid           | HYBRID        | Hybrid     |


  Scenario Outline: Filter Shipper Address by Multiple Pickup Type - Pickup Type FM Dedicated
    Given Operator loads Operator portal home page
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
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<pickupType>" in shipper address page

    Examples:
      | search_field | search_value                                     | column_datakey        | pickupTypeSelect | pickupTypeAPI | pickupType   |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | formatted_pickup_type | FM-Dedicated     | fm_dedicated  | FM Dedicated |


  Scenario Outline: Filter Shipper Address by Multiple Pickup Type - Pickup Type Truck
    Given Operator loads Operator portal home page
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
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<pickupType>" in shipper address page

    Examples:
      | search_field | search_value                                     | column_datakey        | pickupTypeSelect | pickupTypeAPI | pickupType |
      | Address ID   | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | formatted_pickup_type | Truck            | TRUCK         | Truck      |


  Scenario: Filter Shipper Address by Multiple Pickup Type
    Given Operator loads Operator portal home page
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
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "formatted_pickup_type" based on input in "-" in shipper address page
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]}"
    Then Operator verifies table is filtered "formatted_pickup_type" based on input in "Hybrid" in shipper address page
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[3]}"
    Then Operator verifies table is filtered "formatted_pickup_type" based on input in "FM Dedicated" in shipper address page
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[4]}"
    Then Operator verifies table is filtered "formatted_pickup_type" based on input in "Truck" in shipper address page


  Scenario Outline: Search Shipper Addresses on Pickup Type Configure Page - <dataset_name>
    Given Operator loads Operator portal home page
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
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<search_value>" in shipper address page

    Examples:
      | dataset_name             | search_field   | search_value                                     | column_datakey        |
      | Search by Address ID     | Address ID     | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | shipper_address_id    |
      | Search by Pickup Address | Pickup Address | 15SenokoRd,Singapore, SG, 994289                 | pickup_address        |
      | Search by Shipper ID     | Shipper ID     | {shipper-v4-id}                                  | shipper_id            |
      | Search by Pickup Type    | Pickup Type    | -                                                | formatted_pickup_type |
      | Search by Zone           | Zones          | -                                                | zones                 |
      | Search by Hub            | Hubs           | -                                                | hubs                  |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op