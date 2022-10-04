@FirstMile @ShipperAddressVerification
Feature: Shipper Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @ForceSuccessOrder
  Scenario Outline: [SG] New Shipper Address Without Lat Long is Created After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"Singapore","country":"<country>","postcode":"758103"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Operator verifies the verified status for shipperId "{shipper-v4-id}" is equal to "0"
    Then DB Operator verifies that latlong is assigned in shipper address table for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1            | country | postcode |
      | Firstmile | 1234567890 | TestSG, Test Street | SG      | 994289   |


  @ForceSuccessOrder @SystemIdNotSg @default-id
  Scenario Outline: [ID, MY, TH, PH, VN] New Shipper Address Without Lat Long is Created After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"75810"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Jakarta"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Jakarta"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Operator verifies the verified status for shipperId "{shipper-v4-id}" is equal to "0"
    Then DB Operator verifies that latlong is assigned in shipper address table for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode |
      | Firstmile | 1234567890 | Test ID, Test Street | ID      | 99443    |

  @ForceSuccessOrder @SystemIdNotSg @default-id
  Scenario Outline: [ID, MY, TH, PH, VN] Lat Long of Existing Shipper Address is Updated After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                       |
      | withLatLong                 | NO                                                                                                                                                                                                    |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","milkrun_settings":[],"is_milk_run":false} |
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"75810"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Jakarta"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Jakarta"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Operator verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Operator verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude |
      | Firstmile | 1234567890 | Test ID, Test Street | ID      | 99443    | 1.463    | 103.801   |

  @ForceSuccessOrder
  Scenario Outline: New Shipper Address with Lat Long is Created from OPV2
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                         |
      | noOfAddress                 | 1                                                                                                                                                                                                                                                       |
      | withLatLong                 | NO                                                                                                                                                                                                                                                      |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>","milkrun_settings":[],"is_milk_run":false} |
    Then DB Operator verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Operator verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude |
      | Firstmile | 1234567890 | Test SG, Test Street | SG      | 994289   | 1.463    | 103.801   |

  @ForceSuccessOrder
  Scenario Outline: New Shipper Address with Lat Long is Created After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"758100"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Operator verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Operator verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude |
      | Firstmile | 1234567890 | Test SG, Test Street | SG      | 994289   | 1.123    | 1.123     |

  @ForceSuccessOrder
  Scenario Outline: Lat Long of Existing Shipper Address is Not Updated After Order Creation
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                                                                         |
      | noOfAddress                 | 1                                                                                                                                                                                                                                                       |
      | withLatLong                 | YES                                                                                                                                                                                                                                                     |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","latitude":"<latitude>","longitude":"<longitude>","milkrun_settings":[],"is_milk_run":false} |
    Given API Shipper create an order using below json as request body
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"<name>","phone_number":"<contact>","email":"FirstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>"}},"to":{"name":"<name>","phone_number":"<contact>","email":"FirsstMile@ninjavan.co","address":{"address1":"<Address1>","address2":"","country":"<country>","postcode":"758100"}},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":10,"pickup_timeslot":{"start_time":"18:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_instructions":"ThisiscreatedforQA-TESTING","delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"18:00","timezone":"Asia/Singapore"},"delivery_instructions":"ThisiscreatedforQA-TESTING","dimensions":{"weight":1,"width":20,"height":10,"length":40,"size":"S"},"pickup_approximate_volume":"LargerthanVanLoad","experimental_from_international":false,"experimental_to_international":false}} |
    Then DB Operator verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Operator verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude |
      | Firstmile | 1234567890 | Test SG, Test Street | SG      | 994289   | 1.123    | 1.123     |


  @ForceSuccessOrder @SystemIdNotSg @default-id
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
    Then DB Operator verifies the verified status for shipperId "{shipper-v4-id}" is equal to "1"
    Then DB Operator verifies that Latitude "<latitude>" and Longitude "<longitude>" is equal to the expected value for shipperID "{shipper-v4-id}"


    Examples:
      | name      | contact    | Address1             | country | postcode | latitude | longitude |
      | Firstmile | 1234567890 | Test ID, Test Street | ID      | 99443    | 1.123    | 1.123     |

  @ForceSuccessOrder @SystemIdNotSg @default-id
  Scenario Outline: [ID, MY, TH, PH, VN] New Shipper Address without Lat Long is Created from OPV2
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                       |
      | noOfAddress                 | 1                                                                                                                                                                                                     |
      | withLatLong                 | YES                                                                                                                                                                                                   |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","milkrun_settings":[],"is_milk_run":false} |
    Then DB Operator verifies the verified status for shipperId "{shipper-v4-id}" is equal to "0"
    Then DB Operator verifies that latlong is assigned in shipper address table for shipperID "{shipper-v4-id}"


    Examples:
      | name      | contact    | Address1             | country | postcode |
      | Firstmile | 1234567890 | Test ID, Test Street | ID      | 99443    |

  @ForceSuccessOrder
  Scenario Outline: New Shipper Address with Lat Long is Created from OPV2
    Given Operator loads Operator portal home page
    And DB Operator delete shipper address for the shipperId "{shipper-v4-id}"
    When API Operator creates shipper address using below data:
      | shipperID                   | {shipper-v4-id}                                                                                                                                                                                       |
      | noOfAddress                 | 1                                                                                                                                                                                                     |
      | withLatLong                 | NO                                                                                                                                                                                                    |
      | createShipperAddressRequest | {"name":"<name>","contact":"<contact>","email":"FirstMile@ninjavan.co","address1":"<Address1>","address2":"","country":"<country>","postcode":"<postcode>","milkrun_settings":[],"is_milk_run":false} |
    Then DB Operator verifies the verified status for shipperId "{shipper-v4-id}" is equal to "0"
    Then DB Operator verifies that latlong is assigned in shipper address table for shipperID "{shipper-v4-id}"

    Examples:
      | name      | contact    | Address1             | country | postcode |
      | Firstmile | 1234567890 | Test SG, Test Street | SG      | 994289   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op