@FirstMile @AddressesUngrouping
Feature: Shipper Address Configuration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Unable to Group Only One Address
    When Operator loads Shipper Address Configuration page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    And Operator clicks on the "Group Addresses" button
    Then Operator verifies page url ends with "group-addresses"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    And Operator waits for 120 seconds
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    And Operator clicks on the "Group Address" button
    Then Operator verify "Please select at least 2 addresses to start grouping" message is displayed

  Scenario: Unable to Group Addresses with Different Billing Zone
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3610824655719687,"longitude":103.82899312865466,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 1                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.4300973657820213,"longitude":103.83564428801563,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    And Operator clicks on the "Group Addresses" button
    Then Operator verifies page url ends with "group-addresses"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    And Operator waits for 120 seconds
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}"
    And Operator clicks on the "Group Address" button
    Then Operator verify "Selected addresses have different billing zones: {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}. Please contact pricing and finance team" message is displayed

  Scenario: Unable Group addresses with Multiple Parent
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 4                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3610824655719687,"longitude":103.82899312865466,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    Given API First Mile - Operator group shipper address using data below :
      | request | {"group_shipper_address_id" : {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, "shipper_address_ids" : [{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]},{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}]} |
    Given API First Mile - Operator group shipper address using data below :
      | request | {"group_shipper_address_id" : {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[3]}, "shipper_address_ids" : [{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[3]},{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[4]}]} |
    And Operator clicks on the "Group Addresses" button
    Then Operator verifies page url ends with "group-addresses"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    And Operator waits for 120 seconds
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[3]}"
    And Operator clicks on the "Group Address" button
    Then Operator verify "Please check that there is only 1 group address selected" message is displayed

  Scenario: Unable to Group Addresses with No Physical Zone
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 2                                                                                                                                                                                                                                           |
      | withLatLong                 | NO                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
     And Operator clicks on the "Group Addresses" button
    Then Operator verifies page url ends with "group-addresses"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    And Operator waits for 120 seconds
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]}"
    And Operator clicks on the "Group Address" button
    And Operator waits for 5 seconds
    Then Operator verify modal with below data:
      | title           | Select group address                                                      |
      | title2          | Select the main address that will be shown as the waypoint on drivers app |
      | pickup_Address  | Pickup Address                                                            |
      | address1        | 36SenokoRd,Singapore, SG, 124100                                          |
    When Operator select radio checkbox for address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    And Operator clicks on the "Confirm" button
    Then Operator verify "Selected addresses do not have a zone assigned: {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]}. Please contact first mile team" message is displayed

  @SystemIdNotSg @default-vn
  Scenario: Unable to Group Addresses with No Lat Long
    When Operator loads Shipper Address Configuration page in VN
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 2                                                                                                                                                                                                                                           |
      | withLatLong                 | NO                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"VN","postcode":"960000","milkrun_settings":[],"is_milk_run":false} |
    And Operator clicks on the "Group Addresses" button
    Then Operator verifies page url ends with "group-addresses"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    And Operator waits for 120 seconds
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]}"
    And Operator clicks on the "Group Address" button
    Then Operator verify "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}, {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[2]} do not have a lat long assigned. Please contact first mile team" message is displayed

  Scenario: Unable to Remove Address with No Group Address
    When Operator loads Shipper Address Configuration page
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 2                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3610824655719687,"longitude":103.82899312865466,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    And Operator clicks on the "Group Addresses" button
    Then Operator verifies page url ends with "group-addresses"
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {date: 1 days ago,  dd/MM/yyyy} |
      | To   | {date: 1 days next, dd/MM/yyyy} |
    And Operator clicks on the load selection button
    And Operator waits for 60 seconds
    And Operator filter the column "Pickup Address" with "36SenokoRd,Singapore"
    And Operator waits for 120 seconds
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}"
    And Operator clicks on the "Remove from Group" button
    Then Operator verify "Please check that all addresses selected have an existing group address" message is displayed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op