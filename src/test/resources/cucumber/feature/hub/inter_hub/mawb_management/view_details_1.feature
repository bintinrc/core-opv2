@OperatorV2 @MiddleMile @Hub @InterHub @mawbManagement @ViewDetails1
Feature: MAWB Management - View Details 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: View Details Created MAWB
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    When Operator opens MAWB detail for the MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}" on MAWB Management page
    Then Operator verifies mawb event on MAWB Details page:
      | source    | CREATED                             |
      | result    | Source: OPERATOR                    |
      | status    | CREATED                             |
      | user      | qa@ninjavan.co                      |
      | when      | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteShipments @DeleteCreatedMAWBs @DeleteDriver @ForceSuccessOrder
  Scenario: View Details In-Transit to Airport MAWB (Van Inbound from OPV2)
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM            |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"102600","city":"-","country":"SG"}}} |
    Given API Operator put created parcel to shipment
    Given API Operator closes the created shipment
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-2} |
      | originAirportId      | {airport-id-1} |
      | vendorId             | {vendor-id}    |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP    |
      | originFacility      | {hub-id}   |
      | destinationFacility | {airport-hub-id-1}|
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP         |
      | originFacility      | {airport-hub-id-1}  |
      | destinationFacility | {airport-hub-id-2}  |
      | flight_no           | 12345               |
      | mawb | {KEY_LIST_OF_CREATED_MAWB[1]}      |
    When API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Given API Operator shipment inbound scan in hub id "{hub-id}" with trip with data below:
      | tripId     | {KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id} |
      | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}         |
      | actionType | ADD                                           |
      | scanType   | SHIPMENT_VAN_INBOUND                          |
    Then API Operator end shipment inbound with trip in hub id "{hub-id}" with data below:
      | systemId    | sg                                            |
      | tripId      | {KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id} |
      | scanType    | shipment_van_inbound                          |
      | driverId    | {KEY_CREATED_DRIVER.id}                       |
      | environment | OPV2                                          |
    Then API Operator depart trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Then API Operator arrive trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Then API Operator complete trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    When Operator opens MAWB detail for the MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}" on MAWB Management page
    Then Operator verifies mawb event on MAWB Details page:
      | source    | TRANSIT_TO_AIRPORT                  |
      | result    | Source: OPERATOR                    |
      | status    | IN_TRANSIT_TO_AIRPORT               |
      | user      | qa@ninjavan.co                      |
      | when      | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteShipments @DeleteCreatedMAWBs @DeleteDriver @ForceSuccessOrder
  Scenario: View Details In-Transit to Airport MAWB (Van Inbound from MMDA)
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM            |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"102600","city":"-","country":"SG"}}} |
    Given API Operator put created parcel to shipment
    Given API Operator closes the created shipment
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-2} |
      | originAirportId      | {airport-id-1} |
      | vendorId             | {vendor-id}    |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP    |
      | originFacility      | {hub-id}   |
      | destinationFacility | {airport-hub-id-1}|
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP         |
      | originFacility      | {airport-hub-id-1}  |
      | destinationFacility | {airport-hub-id-2}  |
      | flight_no           | 12345               |
      | mawb | {KEY_LIST_OF_CREATED_MAWB[1]}      |
    When API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Given API Operator shipment inbound scan in hub id "{hub-id}" with trip with data below:
      | tripId     | {KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id} |
      | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}         |
      | actionType | ADD                                           |
      | scanType   | SHIPMENT_VAN_INBOUND                          |
    Then API Operator end shipment inbound with trip in hub id "{hub-id}" with data below:
      | systemId    | sg                                            |
      | tripId      | {KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id} |
      | scanType    | shipment_van_inbound                          |
      | driverId    | {KEY_CREATED_DRIVER.id}                       |
    Then API Operator depart trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Then API Operator arrive trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Then API Operator complete trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    When Operator opens MAWB detail for the MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}" on MAWB Management page
    Then Operator verifies mawb event on MAWB Details page:
      | source    | TRANSIT_TO_AIRPORT                  |
      | result    | Source: MM_DRIVER_APP               |
      | status    | IN_TRANSIT_TO_AIRPORT               |
      | user      | qa@ninjavan.co                      |
      | when      | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteShipments @DeleteCreatedMAWBs @DeleteDriver @ForceSuccessOrder
  Scenario: Record Offload Handed Over to Airline MAWB
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM            |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"102600","city":"-","country":"SG"}}} |
    Given API Operator put created parcel to shipment
    Given API Operator closes the created shipment
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator create 1 new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM              |
      | destinationAirportId | {airport-id-2} |
      | originAirportId      | {airport-id-1} |
      | vendorId             | {vendor-id}    |
    Given API Operator create new air trip with data below:
      | airtripType         | TO_FROM_AIRPORT_TRIP    |
      | originFacility      | {hub-id}   |
      | destinationFacility | {airport-hub-id-1}|
    Given API Operator create new air trip with data below:
      | airtripType         | FLIGHT_TRIP                   |
      | originFacility      | {airport-hub-id-1}  |
      | destinationFacility | {airport-hub-id-2}  |
      | flight_no           | 12345                                 |
      | mawb | {KEY_LIST_OF_CREATED_MAWB[1]}       |
    When API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to airhaul trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Given API Operator shipment inbound scan in hub id "{hub-id}" with trip with data below:
      | tripId     | {KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id} |
      | scanValue  | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}         |
      | actionType | ADD                                           |
      | scanType   | SHIPMENT_VAN_INBOUND                          |
    Then API Operator end shipment inbound with trip in hub id "{hub-id}" with data below:
      | systemId | sg                                            |
      | tripId   | {KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id} |
      | scanType | shipment_van_inbound                          |
      | driverId | {KEY_CREATED_DRIVER.id}                       |
    Then API Operator depart trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Then API Operator arrive trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Then API Operator complete trip "{KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id}"
    Given API Operator shipment inbound scan in hub id "{airport-hub-id-1}" with trip with data below:
      | tripId     | {KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id} |
      | scanValue  | {KEY_CREATED_SHIPMENT_ID}                     |
      | actionType | ADD                                           |
      | scanType   | SHIPMENT_HUB_INBOUND                          |
    Then API Operator end shipment inbound with trip in hub id "{airport-hub-id-1}" with data below:
      | systemId | sg                                            |
      | tripId   | {KEY_LIST_OF_AIRHAUL_TOFROM_TRIPS[1].trip_id} |
      | scanType | shipment_hub_inbound                          |
      | driverId | {KEY_CREATED_DRIVER.id}                       |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    When Operator opens MAWB detail for the MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}" on MAWB Management page
    Then Operator verifies mawb event on MAWB Details page:
      | source    | HANDED_OVER_TO_AIRLINE              |
      | result    | Source: MM_DRIVER_APP               |
      | status    | HANDED_OVER_TO_AIRLINE              |
      | user      | qa@ninjavan.co                      |
      | when      | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: Success Manifest MAWB with Attachment and No Comments
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    When Operator performs manifest MAWB following data below:
      | mawb                 | {KEY_LIST_OF_CREATED_MAWB[1]}       |
      | uploadFileSize       | 1000                                |
    And Operator clicks on submit manifest button on Manifest MAWB Page
    Then Operator verifies manifest MAWB successfully message
    When Operator opens MAWB detail for the MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}" on MAWB Management page
    Then Operator verifies mawb event on MAWB Details page:
      | source    | MANIFESTED                                    |
      | result    | Source: OPERATOR                              |
      | status    | MANIFESTED                                    |
      | user      | qa@ninjavan.co                                |
      | when      | ^{gradle-current-date-yyyy-MM-dd}.*           |
    And Operator verifies manifest items on MAWB Details page:
      | comments             | N/A            |

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: View Details Manifested MAWB updated by OPV2 with Comments
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    When Operator performs manifest MAWB following data below:
      | mawb                 | {KEY_LIST_OF_CREATED_MAWB[1]}       |
      | comments             | Automation comment                  |
    And Operator clicks on submit manifest button on Manifest MAWB Page
    Then Operator verifies manifest MAWB successfully message
    When Operator opens MAWB detail for the MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}" on MAWB Management page
    Then Operator verifies mawb event on MAWB Details page:
      | source    | MANIFESTED                                    |
      | result    | Comments: Automation comment\nSource: OPERATOR|
      | status    | MANIFESTED                                    |
      | user      | qa@ninjavan.co                                |
      | when      | ^{gradle-current-date-yyyy-MM-dd}.*           |
    And Operator verifies manifest items on MAWB Details page:
      | comments             | Automation comment            |

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: View Details Manifested MAWB updated by OPV2 with Attachment and Comments
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    When Operator performs manifest MAWB following data below:
      | mawb                 | {KEY_LIST_OF_CREATED_MAWB[1]}       |
      | uploadFileSize       | 1000                                |
      | comments             | Automation comment                  |
    And Operator clicks on submit manifest button on Manifest MAWB Page
    Then Operator verifies manifest MAWB successfully message
    When Operator opens MAWB detail for the MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}" on MAWB Management page
    Then Operator verifies mawb event on MAWB Details page:
      | source    | MANIFESTED                                    |
      | result    | Comments: Automation comment\nSource: OPERATOR|
      | status    | MANIFESTED                                    |
      | user      | qa@ninjavan.co                                |
      | when      | ^{gradle-current-date-yyyy-MM-dd}.*           |
    And Operator verifies manifest items on MAWB Details page:
      | comments             | Automation comment            |

  @DeleteShipments @DeleteCreatedMAWBs
  Scenario: View Details Manifested MAWB updated by OPV2 without Attachment
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    When Operator performs manifest MAWB following data below:
      | mawb                 | {KEY_LIST_OF_CREATED_MAWB[1]}       |
      | comments             | Automation comment                  |
    And Operator clicks on submit manifest button on Manifest MAWB Page
    Then Operator verifies manifest MAWB successfully message
    When Operator opens MAWB detail for the MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}" on MAWB Management page
    Then Operator verifies mawb event on MAWB Details page:
      | source    | MANIFESTED                                    |
      | result    | Comments: Automation comment\nSource: OPERATOR|
      | status    | MANIFESTED                                    |
      | user      | qa@ninjavan.co                                |
      | when      | ^{gradle-current-date-yyyy-MM-dd}.*           |
    And Operator verifies manifest items on MAWB Details page:
      | comments             | Automation comment            |

  @KillBrowser
  Scenario: Kill Browser
    Given no-op

