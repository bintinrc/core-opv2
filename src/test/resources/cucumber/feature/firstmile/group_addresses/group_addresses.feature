@FirstMile @AddressesGrouping
Feature: Shipper Address Configuration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Success Group Addresses
    When Operator loads Shipper Address Configuration page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 2                                                                                                                                                                                                                                           |
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
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}"
    And Operator clicks on the "Group Address" button
    Then Operator verify modal with below data:
      | title           | Select group address                                                      |
      | title2          | Select the main address that will be shown as the waypoint on drivers app |
      | pickup_Address  | Pickup Address                                                            |
      | address1        | 36SenokoRd,Singapore, SG, 124100                                          |
    When Operator select radio checkbox for address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    And Operator clicks on the "Confirm" button
    Then Operator verify success message is displayed
    Then Verify that the Group Address for Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}" is showing with text "36SenokoRd,Singapore, SG, 124100"

  Scenario: Success Remove All Addresses from Group
    When Operator loads Shipper Address Configuration page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 2                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    Given API First Mile - Operator group shipper address using data below :
      | request | {"group_shipper_address_id" : {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, "shipper_address_ids" : [{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]},{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}]} |
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
    Then Operator verify modal with below data:
      | title           | Remove pickup address from group                                                     |
      | title2          | Are you sure you want to remove the following pickup address(es) from their group(s)?|
      | pickup_Address  | Pickup Address                                                            |
      | address1        | 36SenokoRd,Singapore, SG, 124100                                          |
    And Operator clicks on the "Remove" button
    Then Operator verify success message is displayed
    Then Verify that the Group Address for Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}" is showing with text "No Group"

  Scenario: Success Remove Multiple Addresses with More than 1 Parent
    When Operator loads Shipper Address Configuration page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 4                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
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
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[4]}"
    And Operator clicks on the "Remove from Group" button
    Then Operator verify modal with below data:
      | title           | Remove pickup address from group                                                     |
      | title2          | Are you sure you want to remove the following pickup address(es) from their group(s)?|
      | pickup_Address  | Pickup Address                                                            |
      | address1        | 36SenokoRd,Singapore, SG, 124100                                          |
    And Operator clicks on the "Remove" button
    Then Operator verify success message is displayed
    Then Verify that the Group Address for Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}" is showing with text "No Group"
    Then Verify that the Group Address for Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[4]}" is showing with text "No Group"

  Scenario: Success Add New Address Existing Group and Set As New Group Address
  When Operator loads Shipper Address Configuration page
  And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
  When API Operator creates shipper address using below data:
    | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
    | noOfAddress                 | 3                                                                                                                                                                                                                                           |
    | withLatLong                 | YES                                                                                                                                                                                                                                         |
    | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
  Given API First Mile - Operator group shipper address using data below :
    | request | {"group_shipper_address_id" : {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, "shipper_address_ids" : [{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]},{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}]} |
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
  And Operator waits for 5 seconds
  Then Operator verify modal with below data:
    | title           | Select group address                                                      |
    | title2          | Select the main address that will be shown as the waypoint on drivers app |
    | pickup_Address  | Pickup Address                                                            |
    | address1        | 36SenokoRd,Singapore, SG, 124100                                          |
  Then Operator verify current group text with below data:
    | address1        | Current group address                                                     |
  When Operator select radio checkbox for address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
  And Operator clicks on the "Confirm" button
  Then Operator verify success message is displayed
  Then Verify that the Group Address for Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}" is showing with text "36SenokoRd,Singapore, SG, 124100"
  Then Verify that the Group Address for Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[3]}" is showing with text "36SenokoRd,Singapore, SG, 124100"

  Scenario: Success Add New Address Existing Group and Group Address Remain the Same
    When Operator loads Shipper Address Configuration page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                             |
      | noOfAddress                 | 3                                                                                                                                                                                                                                           |
      | withLatLong                 | YES                                                                                                                                                                                                                                         |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"36SenokoRd,Singapore","address2":"","country":"SG","latitude":1.3594786439016684,"longitude":103.83924902161432,"postcode":"124100","milkrun_settings":[],"is_milk_run":false} |
    Given API First Mile - Operator group shipper address using data below :
      | request | {"group_shipper_address_id" : {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}, "shipper_address_ids" : [{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]},{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}]} |
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
    And Operator waits for 5 seconds
    Then Operator verify modal with below data:
      | title           | Select group address                                                      |
      | title2          | Select the main address that will be shown as the waypoint on drivers app |
      | pickup_Address  | Pickup Address                                                            |
      | address1        | 36SenokoRd,Singapore, SG, 124100                                          |
    Then Operator verify current group text with below data:
      | address1        | Current group address                                                     |
    When Operator select radio checkbox for address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[3]}"
    And Operator clicks on the "Confirm" button
    Then Operator verify success message is displayed
    Then Verify that the Group Address for Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}" is showing with text "36SenokoRd,Singapore, SG, 124100"
    Then Verify that the Group Address for Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[3]}" is showing with text "36SenokoRd,Singapore, SG, 124100"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op