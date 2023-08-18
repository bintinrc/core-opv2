@FirstMile @ShipperAddressVerification
Feature: Shipper Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @ForceSuccessOrder @default-sg
  Scenario Outline: [SG] New Shipper Address Without Lat Long is Created After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"Singapore","country":"<country>","postcode":"758103"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "0"
    Then DB Shipper - verifies that latlong value is assigned in shipper address table for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1            | country | postcode |
      | FirstMile | 1234567890 | TestSG, Test Street | SG      | 994289   |


  @ForceSuccessOrder @SystemIdNotSg @default-id @HappyPath
  Scenario Outline: [ID, MY, TH, PH, VN] New Shipper Address Without Lat Long is Created After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"75810"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Jakarta"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Jakarta"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "0"
    Then DB Shipper - verifies that latlong value is assigned in shipper address table for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode |
      | FirstMile | 1234567890 | Test ID, Test Street | ID      | 99443    |

  @ForceSuccessOrder @SystemIdNotSg @default-id @HappyPath
  Scenario Outline: [ID, MY, TH, PH, VN] Lat Long of Existing Shipper Address is Updated After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                       |
      | noOfAddress                 | 1                                                                                                                                                                                                     |
      | withLatLong                 | NO                                                                                                                                                                                                    |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","milkrun_settings":[],"is_milk_run":false} |
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"75810"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Jakarta"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Jakarta"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Shipper - verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude |
      | FirstMile | 1234567890 | Test ID, Test Street | ID      | 99443    | 1.463    | 103.801   |

  @ForceSuccessOrder @default-sg
  Scenario Outline: New Shipper Address with Lat Long is Created from OPV2
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                         |
      | noOfAddress                 | 1                                                                                                                                                                                                                                                       |
      | withLatLong                 | NO                                                                                                                                                                                                                                                      |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>","milkrun_settings":[],"is_milk_run":false} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Shipper - verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude |
      | FirstMile | 1234567890 | Test SG, Test Street | SG      | 994289   | 1.463    | 103.801   |

  @ForceSuccessOrder
  Scenario Outline: New Shipper Address with Lat Long is Created After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"758100"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Shipper - verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude |
      | FirstMile | 1234567890 | Test SG, Test Street | SG      | 994289   | 1.123    | 1.123     |

  @ForceSuccessOrder @SystemIdNotSg @default-vn
  Scenario Outline: [VN] New Shipper Address with Lat Long is Created After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"758100"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Jakarta"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Jakarta"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "0"
    Then DB Shipper - verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude  |
      | FirstMile | 1234567890 | Test VN, Test Street | VN      |          | 1.46378  | 103.801811 |

  @ForceSuccessOrder @default-vn
  Scenario Outline: [VN] Lat Long of Existing Shipper Address is updated After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                    |
      | noOfAddress                 | 1                                                                                                                                                                                                                                  |
      | withLatLong                 | YES                                                                                                                                                                                                                                |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"Test VN, Test Street","address2":"","country":"VN","latitude":24.5,"longitude":47.5,"milkrun_settings":[],"is_milk_run":false}  |
    And API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<fromAddress>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"758100"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Jakarta"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Jakarta"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "0"
    Then DB Shipper - verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | fromAddress              | country | postcode |  latitude | longitude  |
      | Firstmile | 1234567890 | Test VN, Test Street     | VN      |          |  1.46378  | 103.801811 |

  @ForceSuccessOrder @default-vn
  Scenario Outline: [VN] Lat Long of Existing Shipper Address is Not Updated After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                    |
      | noOfAddress                 | 1                                                                                                                                                                                                                                  |
      | withLatLong                 | YES                                                                                                                                                                                                                                |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"Test VN, Test Street","address2":"","country":"VN","latitude":24.5,"longitude":47.5,"postcode":"124100","milkrun_settings":[],"is_milk_run":false}  |
    And API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<fromAddress>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"758100"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Jakarta"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Jakarta"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Shipper - verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | fromAddress              | country | postcode |  latitude | longitude  |
      | FirstMile | 1234567890 | Test VN, Test Street     | VN      |          |  24.5     | 47.5       |

  @ForceSuccessOrder @default-sg
  Scenario Outline: Lat Long of Existing Shipper Address is Updated from OPV2 - Verified Address
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                         |
      | noOfAddress                 | 1                                                                                                                                                                                                                                                       |
      | withLatLong                 | Yes                                                                                                                                                                                                                                                      |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"60 SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","latitude":"1.23","longitude":"1.23","milkrun_settings":[],"is_milk_run":false} |
    When API Shipper - Operator updates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                           |
      | withLatLong                 | YES                                                                                                                       |
      | addressID                   | <search_value>                                                                                                            |
      | newLatitude                 | <newLatitude>                                                                                                             |
      | newLongitude                | <newLongitude>                                                                                                            |
      | newAddress                  | <newAddress>                                                                                                              |
    Then DB Shipper - verifies the verified status for shipper address "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}" is equal to "1"
    Then DB Shipper - verifies that Latitude "<newLatitude>" and Longitude "<newLongitude>" is equal to the expected value for AddressId "{KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]}"

    Examples:
      | search_value                                  | newLatitude | newLongitude | newAddress            |
      | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]} | 50.5        |  50.5        | 30 SenokoRd,Singapore |

  @ForceSuccessOrder @default-sg
  Scenario Outline: Lat Long of Existing Shipper Address is Updated from OPV2 - Unverified Address
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                         |
      | noOfAddress                 | 1                                                                                                                                                                                                                                                       |
      | withLatLong                 | NO                                                                                                                                                                                                                                                      |
      | createShipperAddressRequest | {"name":"FirstMile","contact":"09876576","email":"Station@gmail.com","address1":"15SenokoRd,Singapore","address2":"","country":"SG","postcode":"000000","milkrun_settings":[],"is_milk_run":false} |
    When API Shipper - Operator updates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                           |
      | withLatLong                 | YES                                                                                                                       |
      | addressID                   | <search_value>                                                                                                            |
      | newLatitude                 | <newLatitude>                                                                                                             |
      | newLongitude                | <newLongitude>                                                                                                            |
      | newAddress                  | <newAddress>                                                                                                              |
    Then DB Shipper - verifies the verified status for shipper address "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}" is equal to "1"
    Then DB Shipper - verifies that Latitude "<newLatitude>" and Longitude "<newLongitude>" is equal to the expected value for AddressId "{KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]}"

    Examples:
      | search_value                                     | newLatitude | newLongitude | newAddress            |
      | {KEY_CREATED_SHIPPER_ADDRESS_WITHOUT_LATLONG[1]} | 50.5        |  50.5        | 30 SenokoRd,Singapore |


  @ForceSuccessOrder @default-sg
  Scenario Outline: Lat Long of Existing Shipper Address is Not Updated After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                         |
      | noOfAddress                 | 1                                                                                                                                                                                                                                                       |
      | withLatLong                 | YES                                                                                                                                                                                                                                                     |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>","milkrun_settings":[],"is_milk_run":false} |
    And API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"758100"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","pickup_address_id":"<addressId>","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Shipper - verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude | addressId                                     |
      | FirstMile | 1234567890 | Test SG, Test Street | SG      | 994289   | 1.123    | 1.123     | {KEY_CREATED_SHIPPER_ADDRESS_WITH_LATLONG[1]} |


  @ForceSuccessOrder @SystemIdNotSg @default-id @HappyPath
  Scenario Outline: [ID, MY, TH, PH, VN] Lat Long of Unverified Shipper Address is Added After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                       |
      | noOfAddress                 | 1                                                                                                                                                                                                     |
      | withLatLong                 | YES                                                                                                                                                                                                   |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","milkrun_settings":[],"is_milk_run":false} |
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"75810"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Jakarta"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Jakarta"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Shipper - verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude |
      | FirstMile | 1234567890 | Test ID, Test Street | ID      | 99443    | 1.123    | 1.123     |

  @ForceSuccessOrder @SystemIdNotSg @default-id @HappyPath
  Scenario Outline: [ID, MY, TH, PH, VN] New Shipper Address without Lat Long is Created from OPV2
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                       |
      | noOfAddress                 | 1                                                                                                                                                                                                     |
      | withLatLong                 | NO                                                                                                                                                                                                    |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","milkrun_settings":[],"is_milk_run":false} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "0"
    Then DB Shipper - verifies that latlong value is assigned in shipper address table for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode |
      | FirstMile | 1234567890 | Test ID, Test Street | ID      | 99443    |

  @ForceSuccessOrder @default-sg
  Scenario Outline: New Shipper Address with Lat Long is Created from OPV2
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                       |
      | noOfAddress                 | 1                                                                                                                                                                                                     |
      | withLatLong                 | NO                                                                                                                                                                                                    |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","milkrun_settings":[],"is_milk_run":false} |
    Then DB Shipper - verifies the verified status for shipperId "{shipper-v4-id}" is equal to "0"
    Then DB Shipper - verifies that latlong value is assigned in shipper address table for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode |
      | FirstMile | 1234567890 | Test SG, Test Street | SG      | 994289   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op