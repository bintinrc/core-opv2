@FirstMile @AddressesGrouping
Feature: Shipper Address Configuration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

    @Debug
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
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"
    When Operator select address from the list with Id "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[2]}"
    And Operator clicks on the "Group Address" button



  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op