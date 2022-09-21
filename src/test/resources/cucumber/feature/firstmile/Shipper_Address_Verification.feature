@FirstMile @ShipperAddressVerification
Feature: Shipper Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @ForceSuccessOrder
  Scenario Outline: [SG] New Shipper Address Without Lat Long is Created After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                       |
      | withLatLong                 | NO                                                                                                                                                                                                    |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"Firstmile.ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","milkrun_settings":[],"is_milk_run":false} |
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"size":"S","weight":5,"length":"40","width":"41","height":"12"}},"from":{"name":"<name>","email":"Firstmile.ninjavan.co","phone_number":"<contact>","address":{"address1":"<Address1>","address2":"","postcode":"<postcode>","country":"<country>"}},"to":{"name":"FirstMileTo","email":"FirstMile@ninjavan.co","phone_number":"+6598980004","address":{"address1":"Address1","address2":"441 Address Verification Automation Ave","postcode":"960304","country":"SG"}}} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG}"
    Then Operator verifies table is filtered "lat_long" based on input in "9.99999,9.99999" in shipper address page
    Then Operator verifies that green check mark icon is not shown under the Lat Long
    Then DB Operator verifies the verified status for addressId "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG}" is equal to "0"

    Examples:
      | name      | contact    | Address1          | country | postcode |
      | FirstMile | 6598984204 | FirstMile Address | SG      | 123456   |

  @ForceSuccessOrder @SystemIdNotSg @default-id
  Scenario Outline: [ID, MY, TH, PH, VN] New Shipper Address Without Lat Long is Created After Order Creation
    Given Operator loads Operator portal home page
    And Operator changes the country to "Indonesia"
    And Operator verify operating country is "Indonesia"
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                       |
      | withLatLong                 | NO                                                                                                                                                                                                    |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"Firstmile.ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","milkrun_settings":[],"is_milk_run":false} |
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"STANDARD","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Jakarta"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Jakarta"},"dimensions":{"size":"S","weight":5,"length":"40","width":"41","height":"12"}},"from":{"name":"<name>","email":"Firstmile.ninjavan.co","phone_number":"<contact>","address":{"address1":"<Address1>","address2":"","postcode":"<postcode>","country":"<country>"}},"to":{"name":"FirstMileTo","email":"FirstMile@ninjavan.co","phone_number":"+6598980004","address":{"address1":"Address1","address2":"441 Address Verification Automation Ave","postcode":"12456","country":"<country>"}}} |
    When Operator loads Shipper Address Configuration page
    And Operator selects "Unverified" in the Address Status dropdown
    And Operator chooses start and end date on Address Creation date using the following data:
      | From | {gradle-previous-1-day-dd/MM/yyyy} |
      | To   | {gradle-next-1-day-dd/MM/yyyy}     |
    And Operator clicks on the load selection button
    And Operator filter the column "Address ID" with "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG}"
    Then Operator verifies table is filtered "lat_long" based on input in "-6.035939,106.843739" in shipper address page
    Then Operator verifies that green check mark icon is not shown under the Lat Long
    Then DB Operator verifies the verified status for addressId "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG}" is equal to "0"

    Examples:
      | name      | contact    | Address1     | country | postcode |
      | FirstMile | 6598984204 | FirstMile ID | ID      | 12345    |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op