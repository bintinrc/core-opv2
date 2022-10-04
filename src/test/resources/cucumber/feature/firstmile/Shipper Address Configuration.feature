@FirstMile @ShipperAddressConfiguration
Feature: Shipper Address Configuration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  Scenario: Filter Unverified Shipper Address
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "1.288147,103.740233" in shipper address page
    Then Operator verifies that green check mark icon is not shown under the Lat Long


  Scenario: Filter Verified Shipper Address
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","latitude":28.640084,"longitude":77.791013,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Verified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "28.640084,77.791013" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long


  Scenario: Filter All Shipper Addresses
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","latitude":28.640084,"longitude":77.791013,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "All" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "1.288147,103.740233" in shipper address page
    Then Operator verifies that green check mark icon is not shown under the Lat Long
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "28.640084,77.791013" in shipper address page
    Then Operator verifies that green check mark icon is shown under the Lat Long


  Scenario Outline: Search Shipper Addresses - <dataset_name>
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "All" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator filter the column "<search_field>" with "<search_value>"
    Then Operator verifies table is filtered "<column_datakey>" based on input in "<search_value>" in shipper address page

    Examples:
      | dataset_name              | search_field         | search_value                                  | column_datakey       |
      | Search by Address ID      | Address ID           | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG} | id                   |
      | Search by Pickup Address  | Pickup Address       | 15SenokoRd,Singapore, SG, 000000              | pickup_address       |
      | Search by Lat Long        | Lat Long             | 1.288147,103.740233                           | lat_long             |
      | Search by Shipper ID      | Shipper ID           | 5356053                                       | shipper_id           |
      | Search by Shipper Name    | Shipper Name/Contact | Station - 09876576                            | shipper_name_contact |
      | Search by Shipper Contact | Shipper Name/Contact | Station - 09876576                            | shipper_name_contact |

  Scenario: Download CSV of Shipper Address
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "All" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator clicks on the Download Addresses button
    Then Operator verifies header names are available in the downloaded CSV file "Downloaded Pickup Addresses"
      | Address ID           |
      | Pickup Address       |
      | Shipper ID           |
      | Shipper Name/Contact |
      | Latitude             |
      | Longitude            |

  Scenario: Download CSV of Shipper Address Template
    Given Operator loads Operator portal home page
    When Operator loads Shipper Address Configuration page
    And Operator selects "All" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator clicks on the Update Addresses Lat Long button
    And Operator clicks on the Download CSV Template button
    Then Operator verifies header names are available in the downloaded CSV file "CSV Template_Pickup Address Lat Long.csv"
      | Address ID           |
      | Pickup Address       |
      | Shipper ID           |
      | Shipper Name/Contact |
      | Latitude             |
      | Longitude            |


  Scenario: Unable to Update Shipper Addresses with Invalid Shipper ID
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    Then Operator verifies table is filtered "lat_long" based on input in "1.288147,103.740233" in shipper address page
    Then Operator verifies that green check mark icon is not shown under the Lat Long
    And Operator clicks on the Update Addresses Lat Long button
    And Operator uploads csv file: "csv\firstMile\Unable_to_Update_Shipper_Addresses_with_Invalid_Shipper_ID.csv" by browsing files
    And Operator clicks on the Download Errors button
    Then Operator verifies header names are available in the downloaded CSV file "Downloaded Pickup Addresses"
      | Address ID           |
      | Pickup Address       |
      | Shipper ID           |
      | Shipper Name/Contact |
      | Latitude             |
      | Longitude            |
      | Failure Reasons      |
    And Operator verifies that the following texts are available on the downloaded file
      | Shipper ID #54321 not found |
      | Shipper ID #23423 not found |


  Scenario: Unable to Update Shipper Addresses with Invalid Shipper ID
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator clicks on the Update Addresses Lat Long button
    And Operator uploads csv file: "csv\firstMile\Unable_to_Update_Shipper_Addresses_with_Invalid_Shipper_ID.csv" by browsing files
#    And Operator uploads csv file: "csv\firstMile\Unable_to_Update_Shipper_Addresses_with_Invalid_Shipper_ID.csv" to bulk update the shipper address details
    Then Operator verifies upload error message is displayed for error count "2" and total count "2"
    And Operator clicks on the Download Errors button
    Then Operator verifies header names are available in the downloaded CSV file "Downloaded Pickup Addresses"
      | Address ID           |
      | Pickup Address       |
      | Shipper ID           |
      | Shipper Name/Contact |
      | Latitude             |
      | Longitude            |
      | Failure Reasons      |
    And Operator verifies that the following texts are available on the downloaded file
      | Address id #999 Not Found |
      | Address id #888 Not Found |


  Scenario: Unable to Update Shipper Addresses with Invalid Address ID
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator clicks on the Update Addresses Lat Long button
    And Operator uploads csv file: "csv\firstMile\Unable_to_Update_Shipper_Address_with_Invalid_Address_ID.csv" by browsing files
    Then Operator verifies upload error message is displayed for error count "2" and total count "2"
    And Operator clicks on the Download Errors button
    Then Operator verifies header names are available in the downloaded CSV file "Downloaded Pickup Addresses"
      | Address ID           |
      | Pickup Address       |
      | Shipper ID           |
      | Shipper Name/Contact |
      | Latitude             |
      | Longitude            |
      | Failure Reasons      |


  Scenario: Unable to Update Shipper Addresses with Invalid Input
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator clicks on the Update Addresses Lat Long button
    And Operator uploads csv file: "csv\firstMile\Unable_to_Update_Shipper_Address_with_Invalid_Input.csv" by browsing files
    Then Operator verifies upload error message is displayed for invalid file


  Scenario: Unable to Upload Invalid Formatted Shipper Address File
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator clicks on the Update Addresses Lat Long button
    And Operator uploads csv file: "csv\firstMile\Unable_to_Upload_Invalid_Formatted_Shipper_Address_File.xlsx" by browsing files
    Then Operator verifies upload error message is displayed for invalid file


  Scenario: Upload Addresses Lat Long CSV by Browsing File
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator clicks on the Update Addresses Lat Long button
    And Operator uploads csv file: "csv\firstMile\Unable_to_Update_Shipper_Address_with_Invalid_Input.csv" by browsing files
    Then Operator verifies upload error message is displayed for invalid file


  Scenario: Upload Addresses Lat Long CSV by Drag and Drop
    Given Operator loads Operator portal home page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                  |
      | noOfAddress                 | 1                                                                                                                                                                                                |
      | withLatLong                 | NO                                                                                                                                                                                               |
      | createShipperAddressRequest | {"name":"Station","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator clicks on the Update Addresses Lat Long button
    And Operator uploads csv file: "csv\firstMile\Unable_to_Update_Shipper_Address_with_Invalid_Input.csv" by browsing files
    Then Operator verifies upload error message is displayed for invalid file

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op