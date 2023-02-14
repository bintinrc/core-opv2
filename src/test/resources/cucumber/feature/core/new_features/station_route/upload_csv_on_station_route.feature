@OperatorV2 @Route @NewFeatures @StationRoute
Feature: Upload CSV on Station Route

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteCoverage @DeleteShipment
  Scenario: Operator Allow Assign Order to Suggested Driver by Upload CSV on Station Route - CSV file from Downloaded CSV
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-2}
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id-2}                                  |
      | area             | 998 Toa Payoh                               |
      | areaVariations   | North {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | home {gradle-current-date-yyyyMMddHHmmsss}  |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}         |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}         |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-2}                   |
      | shipmentType               | AIR_HAUL                       |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click Download CSV button on Station Route page
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name-2}" hub on Station Route page
    And Operator upload downloaded CSV file on Station Route page
    Then Operator verify parcels are displayed on Upload CSV tab on Station Route page:
      | trackingId                            | address                                                                                                        |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | 998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss} home {gradle-current-date-yyyyMMddHHmmsss} 159363 SG |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                              |
      | address    | 998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss} home {gradle-current-date-yyyyMMddHHmmsss} SG |
      | parcelSize | Small                                                                                                   |
      | driverId   | Unassigned                                                                                              |

  @DeleteDriver
  Scenario: Operator Allow Assign Order to Suggested Driver by Upload CSV on Station Route - Valid TIDs, Valid Driver with Valid Hub
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name-2}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId                            | driverId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    Then Operator verify exactly parcels are displayed on Upload CSV tab on Station Route page:
      | trackingId                            | driverId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                              |
      | address    | 998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss} home {gradle-current-date-yyyyMMddHHmmsss} SG |
      | parcelSize | Small                                                                                                   |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[1].id} - {KEY_LIST_OF_CREATED_DRIVERS[1].firstName}                        |
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                              |
      | address    | 998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss} home {gradle-current-date-yyyyMMddHHmmsss} SG |
      | parcelSize | Small                                                                                                   |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[2].id} - {KEY_LIST_OF_CREATED_DRIVERS[2].firstName}                        |

  @DeleteDriver
  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV on Station Route - Valid TIDs, Valid Driver with Invalid Hub
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId                            | driverId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And Operator verify Tracking IDs are not displayed in Invalid Input dialog on Station Route page
    And Operator verify Driver IDs in Invalid Input dialog on Station Route page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    When Operator click Cancel button in Invalid Input dialog on Station Route page
    Then Operator verify Assign Drivers button is disabled on Station Route page

  @DeleteDriver
  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV on Station Route - Invalid TIDs, Invalid Driver with Invalid Hub
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId  | driverId                            |
      | INVALIDTID1 | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | INVALIDTID2 | 123456                              |
    And Operator verify Tracking IDs in Invalid Input dialog on Station Route page:
      | INVALIDTID1 |
      | INVALIDTID2 |
    And Operator verify Driver IDs in Invalid Input dialog on Station Route page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | 123456                              |
    When Operator click Cancel button in Invalid Input dialog on Station Route page
    Then Operator verify Assign Drivers button is disabled on Station Route page

  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV on Station Route - Invalid CSV Format
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId | driverId |
      |            |          |
      |            |          |
    Then Operator verifies that error react notification displayed:
      | top    | Upload failed    |
      | bottom | Invalid CSV data |
    Then Operator verify Assign Drivers button is disabled on Station Route page

  @DeleteDriver
  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV on Station Route - Duplicate TIDs
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId                            | driverId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
    Then Operator verifies that error react notification displayed:
      | top    | Upload failed                                           |
      | bottom | Duplicated TIDs - {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify Assign Drivers button is disabled on Station Route page

  @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Operator Disallow To Select Hub with Disabled Status on Station Route
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator disable hub with ID "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator cannot select "{KEY_LIST_OF_CREATED_HUBS[1].name}" hub on Station Route page

  @DeleteDriver
  Scenario: Operator Disallow Assign Order to Suggested Driver by Upload CSV After Update Selected Hub on Station Route
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name-2}" hub on Station Route page
    And Operator upload CSV file on Station Route page:
      | trackingId                            | driverId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    Then Operator verify exactly parcels are displayed on Upload CSV tab on Station Route page:
      | trackingId                            | driverId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator verify Tracking IDs are not displayed in Invalid Input dialog on Station Route page
    And Operator verify Driver IDs in Invalid Input dialog on Station Route page:
      | {KEY_LIST_OF_CREATED_DRIVERS[1].id} |
      | {KEY_LIST_OF_CREATED_DRIVERS[2].id} |
    When Operator click Cancel button in Invalid Input dialog on Station Route page
    Then Operator verify Assign Drivers button is disabled on Station Route page

  Scenario: Operator Disallow Assign More Than 10.000 Orders to Suggested Driver by Upload CSV on Station Route
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator open Upload CSV tab on Station Route page
    And Operator selects "{hub-name}" hub on Station Route page
    And Operator upload CSV file with more then 10000 rows on Station Route page
    Then Operator verifies that error react notification displayed:
      | top    | Upload failed              |
      | bottom | Max rows of 10000 exceeded |
    Then Operator verify Assign Drivers button is disabled on Station Route page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op