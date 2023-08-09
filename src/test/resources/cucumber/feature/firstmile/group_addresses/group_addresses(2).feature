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