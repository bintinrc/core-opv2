@OperatorV2 @Core @PickUps @ReservationPresetManagement
Feature: Reservation Preset Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteReservationGroup
  Scenario: Operator Create New Group to Assign Driver on Reservation Preset Management Page (uid:5e413315-ed96-4c3a-92b6-9b58b2d34a25)
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params

  @DeleteDriver @DeleteReservationGroup
  Scenario: Operator Edit Reservation Group on Reservation Preset Management Page (uid:c4721621-2712-410e-b8c7-561e2999361e)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params
    When Operator edit created Reservation Group on Reservation Preset Management page using data below:
      | name | GENERATED    |
      | hub  | {hub-name-2} |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page

  @DeleteDriver @DeleteReservationGroup
  Scenario: Operator Delete Reservation Group on Reservation Preset Management Page (uid:3c303ac8-8409-4337-b854-786a22b50f62)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params
    When Operator delete created Reservation Group on Reservation Preset Management page
    And Operator refresh page
    Then Operator verify created Reservation Group was deleted successfully on Reservation Preset Management page

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Assign a Shipper Milkrun Address to a Milkrun Group
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive               | true                  |
      | shipperType                   | Normal                |
      | ocVersion                     | v4                    |
      | services                      | STANDARD              |
      | trackingType                  | Fixed                 |
      | isAllowCod                    | false                 |
      | isAllowCashPickup             | true                  |
      | isPrepaid                     | true                  |
      | isAllowStagedOrders           | false                 |
      | isMultiParcelShipper          | false                 |
      | isDisableDriverAppReschedule  | false                 |
      | pricingScriptName             | {pricing-script-name} |
      | industryName                  | {industry-name}       |
      | salesPerson                   | {sales-person}        |
      | pickupAddressCount            | 1                     |
      | address.1.milkrun.1.startTime | 9AM                   |
      | address.1.milkrun.1.endTime   | 12PM                  |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name}           |
      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
    Then Operator verifies that success toast displayed:
      | top | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |

#    TODO DISABLED
#  @DeleteDriver @DeleteShipper @DeleteReservationGroup
#  Scenario: Route Pending Reservations From the Reservation Preset Management Page
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
#    And Operator go to menu Shipper -> All Shippers
#    And Operator create new Shipper with basic settings using data below:
#      | isShipperActive               | true                  |
#      | shipperType                   | Normal                |
#      | ocVersion                     | v4                    |
#      | services                      | STANDARD              |
#      | trackingType                  | Fixed                 |
#      | isAllowCod                    | false                 |
#      | isAllowCashPickup             | true                  |
#      | isPrepaid                     | true                  |
#      | isAllowStagedOrders           | false                 |
#      | isMultiParcelShipper          | false                 |
#      | isDisableDriverAppReschedule  | false                 |
#      | pricingScriptName             | {pricing-script-name} |
#      | industryName                  | {industry-name}       |
#      | salesPerson                   | {sales-person}        |
#      | pickupAddressCount            | 1                     |
#      | address.1.milkrun.1.startTime | 9AM                   |
#      | address.1.milkrun.1.endTime   | 12PM                  |
#      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
#    And API Operator fetch id of the created shipper
#    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
#    And API Operator create V2 reservation using data below:
#      | reservationRequest | { "pickup_address_id":{KEY_LIST_OF_SHIPPER_ADDRESSES[1].id}, "legacy_shipper_id":{KEY_LEGACY_SHIPPER_ID}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
#    When Operator go to menu Pick Ups -> Reservation Preset Management
#    And Operator create new Reservation Group on Reservation Preset Management page using data below:
#      | name   | GENERATED                                                              |
#      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
#      | hub    | {hub-name}                                                             |
#    And Operator assign pending task on Reservation Preset Management page:
#      | shipper | {KEY_CREATED_SHIPPER.name}           |
#      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
#    Then Operator verifies that success toast displayed:
#      | top                | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
#      | waitUntilInvisible | true                                                                                         |
#    When Operator route pending reservations on Reservation Preset Management page:
#      | group | {KEY_CREATED_RESERVATION_GROUP.name} |
#    Then Operator verifies that success toast displayed:
#      | top | 1 reservations added to route |

#    TODO DISABLED
#  @DeleteDriver @DeleteShipper @DeleteReservationGroup
#  Scenario: Create Route for Pickup Reservation - Route Date = Today
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
#    And Operator go to menu Shipper -> All Shippers
#    And Operator create new Shipper with basic settings using data below:
#      | isShipperActive               | true                  |
#      | shipperType                   | Normal                |
#      | ocVersion                     | v4                    |
#      | services                      | STANDARD              |
#      | trackingType                  | Fixed                 |
#      | isAllowCod                    | false                 |
#      | isAllowCashPickup             | true                  |
#      | isPrepaid                     | true                  |
#      | isAllowStagedOrders           | false                 |
#      | isMultiParcelShipper          | false                 |
#      | isDisableDriverAppReschedule  | false                 |
#      | pricingScriptName             | {pricing-script-name} |
#      | industryName                  | {industry-name}       |
#      | salesPerson                   | {sales-person}        |
#      | pickupAddressCount            | 1                     |
#      | address.1.milkrun.1.startTime | 9AM                   |
#      | address.1.milkrun.1.endTime   | 12PM                  |
#      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
#    And API Operator fetch id of the created shipper
#    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
#    When Operator go to menu Pick Ups -> Reservation Preset Management
#    And Operator create new Reservation Group on Reservation Preset Management page using data below:
#      | name   | GENERATED                                                              |
#      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
#      | hub    | {hub-name}                                                             |
#    And Operator assign pending task on Reservation Preset Management page:
#      | shipper | {KEY_CREATED_SHIPPER.name}           |
#      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
#    Then Operator verifies that success toast displayed:
#      | top                | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
#      | waitUntilInvisible | true                                                                                         |
#    When Operator create route on Reservation Preset Management page:
#      | group     | {KEY_CREATED_RESERVATION_GROUP.name} |
#      | routeDate | {gradle-current-date-yyyy-MM-dd}     |
#    Then Operator verifies that success toast displayed:
#      | top                | Routes have been created for all groups! |
#      | waitUntilInvisible | true                                     |
#    When Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
#      | fromDate    | {gradle-current-date-yyyy-MM-dd} |
#      | toDate      | {gradle-current-date-yyyy-MM-dd} |
#      | shipperName | {KEY_LEGACY_SHIPPER_ID}          |
#      | status      | ROUTED                           |
#    Then Operator verify reservation details on Shipper Pickups page:
#      | shipperId              | {KEY_LEGACY_SHIPPER_ID}                                                |
#      | shipperName            | ^{KEY_CREATED_SHIPPER.name}.*                                          |
#      | pickupAddress          | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode}                       |
#      | routeId                | not null                                                               |
#      | driverName             | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
#      | priorityLevel          | 0                                                                      |
#      | readyBy                | ^{gradle-current-date-yyyy-MM-dd} .*                                   |
#      | latestBy               | ^{gradle-current-date-yyyy-MM-dd} .*                                   |
#      | reservationType        | REGULAR                                                                |
#      | reservationStatus      | ROUTED                                                                 |
#      | reservationCreatedTime | ^{gradle-current-date-yyyy-MM-dd}.*                                    |
#      | serviceTime            | null                                                                   |
#      | failureReason          | null                                                                   |
#      | comments               | null                                                                   |

#  TODO DISABLED
#  @DeleteDriver @DeleteShipper @DeleteReservationGroup
#  Scenario: Create Route for Pickup Reservation - Route Date = Tomorrow
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Operator create new Driver using data below:
#      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
#    And Operator go to menu Shipper -> All Shippers
#    And Operator create new Shipper with basic settings using data below:
#      | isShipperActive               | true                  |
#      | shipperType                   | Normal                |
#      | ocVersion                     | v4                    |
#      | services                      | STANDARD              |
#      | trackingType                  | Fixed                 |
#      | isAllowCod                    | false                 |
#      | isAllowCashPickup             | true                  |
#      | isPrepaid                     | true                  |
#      | isAllowStagedOrders           | false                 |
#      | isMultiParcelShipper          | false                 |
#      | isDisableDriverAppReschedule  | false                 |
#      | pricingScriptName             | {pricing-script-name} |
#      | industryName                  | {industry-name}       |
#      | salesPerson                   | {sales-person}        |
#      | pickupAddressCount            | 1                     |
#      | address.1.milkrun.1.startTime | 9AM                   |
#      | address.1.milkrun.1.endTime   | 12PM                  |
#      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
#    And API Operator fetch id of the created shipper
#    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
#    When Operator go to menu Pick Ups -> Reservation Preset Management
#    And Operator create new Reservation Group on Reservation Preset Management page using data below:
#      | name   | GENERATED                                                              |
#      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
#      | hub    | {hub-name}                                                             |
#    And Operator assign pending task on Reservation Preset Management page:
#      | shipper | {KEY_CREATED_SHIPPER.name}           |
#      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
#    Then Operator verifies that success toast displayed:
#      | top                | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
#      | waitUntilInvisible | true                                                                                         |
#    When Operator create route on Reservation Preset Management page:
#      | group     | {KEY_CREATED_RESERVATION_GROUP.name} |
#      | routeDate | {gradle-next-1-day-yyyy-MM-dd}       |
#    Then Operator verifies that success toast displayed:
#      | top                | Routes have been created for all groups! |
#      | waitUntilInvisible | true                                     |
#    When Operator go to menu Pick Ups -> Shipper Pickups
#    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
#      | fromDate    | {gradle-next-1-day-yyyy-MM-dd} |
#      | toDate      | {gradle-next-1-day-yyyy-MM-dd} |
#      | shipperName | {KEY_LEGACY_SHIPPER_ID}        |
#      | status      | ROUTED                         |
#    Then Operator verify reservation details on Shipper Pickups page:
#      | shipperId              | {KEY_LEGACY_SHIPPER_ID}                                                |
#      | shipperName            | ^{KEY_CREATED_SHIPPER.name}.*                                          |
#      | pickupAddress          | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode}                       |
#      | routeId                | not null                                                               |
#      | driverName             | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
#      | priorityLevel          | 0                                                                      |
#      | readyBy                | ^{gradle-next-1-day-yyyy-MM-dd}.*                                      |
#      | latestBy               | ^{gradle-next-1-day-yyyy-MM-dd}.*                                      |
#      | reservationType        | REGULAR                                                                |
#      | reservationStatus      | ROUTED                                                                 |
#      | reservationCreatedTime | ^{gradle-current-date-yyyy-MM-dd}.*                                    |
#      | serviceTime            | null                                                                   |
#      | failureReason          | null                                                                   |
#      | comments               | null                                                                   |

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Unassign a Shipper Milkrun Address from a Milkrun Group
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive               | true                  |
      | shipperType                   | Normal                |
      | ocVersion                     | v4                    |
      | services                      | STANDARD              |
      | trackingType                  | Fixed                 |
      | isAllowCod                    | false                 |
      | isAllowCashPickup             | true                  |
      | isPrepaid                     | true                  |
      | isAllowStagedOrders           | false                 |
      | isMultiParcelShipper          | false                 |
      | isDisableDriverAppReschedule  | false                 |
      | pricingScriptName             | {pricing-script-name} |
      | industryName                  | {industry-name}       |
      | salesPerson                   | {sales-person}        |
      | pickupAddressCount            | 1                     |
      | address.1.milkrun.1.startTime | 9AM                   |
      | address.1.milkrun.1.endTime   | 12PM                  |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name}           |
      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
    Then Operator verifies that success toast displayed:
      | top | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
    When Operator go to menu Shipper -> All Shippers
    And Operator unset pickup addresses of the created shipper
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator unassign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name} |
    Then Operator verifies that success toast displayed:
      | top | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been unlink from {KEY_CREATED_RESERVATION_GROUP.name} group! |

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Operator Add Shipper Address To Milkrun Reservation via Upload CSV - Address Has Not Assign to Milkrun and Has Not Added to Milkrun Group
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
      | pickupAddressCount           | 1                     |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator waits for 10 seconds
    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    And API Operator get created Reservation Group params
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId                | addressId                | action | milkrunGroupId                     | days            | startTime | endTime |
      | {KEY_CREATED_SHIPPER.id} | {KEY_CREATED_ADDRESS.id} | add    | {KEY_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And Operator go to menu Shipper -> All Shippers
    And Operator open Edit Shipper Page of shipper "{KEY_CREATED_SHIPPER.name}"
    Then Operator verify pickup address on Edit Shipper page:
      | address.1.milkrun.1.startTime | 3PM           |
      | address.1.milkrun.1.endTime   | 6PM           |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7 |

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Operator Add Shipper Address To Milkrun Reservation via Upload CSV - Address Assign to Milkrun and Has Not Added to Milkrun Group
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive               | true                  |
      | shipperType                   | Normal                |
      | ocVersion                     | v4                    |
      | services                      | STANDARD              |
      | trackingType                  | Fixed                 |
      | isAllowCod                    | false                 |
      | isAllowCashPickup             | true                  |
      | isPrepaid                     | true                  |
      | isAllowStagedOrders           | false                 |
      | isMultiParcelShipper          | false                 |
      | isDisableDriverAppReschedule  | false                 |
      | pricingScriptName             | {pricing-script-name} |
      | industryName                  | {industry-name}       |
      | salesPerson                   | {sales-person}        |
      | pickupAddressCount            | 1                     |
      | address.1.milkrun.1.startTime | 3PM                   |
      | address.1.milkrun.1.endTime   | 6PM                   |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator waits for 10 seconds
    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    And API Operator get created Reservation Group params
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId                | addressId                | action | milkrunGroupId                     | days            | startTime | endTime |
      | {KEY_CREATED_SHIPPER.id} | {KEY_CREATED_ADDRESS.id} | add    | {KEY_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And Operator go to menu Shipper -> All Shippers
    And Operator open Edit Shipper Page of shipper "{KEY_CREATED_SHIPPER.name}"
    Then Operator verify pickup address on Edit Shipper page:
      | address.1.milkrun.1.startTime | 3PM           |
      | address.1.milkrun.1.endTime   | 6PM           |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7 |

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Operator Add Shipper Address To Milkrun Reservation via Upload CSV - Address Assign to Milkrun and Added to Milkrun Group
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive               | true                  |
      | shipperType                   | Normal                |
      | ocVersion                     | v4                    |
      | services                      | STANDARD              |
      | trackingType                  | Fixed                 |
      | isAllowCod                    | false                 |
      | isAllowCashPickup             | true                  |
      | isPrepaid                     | true                  |
      | isAllowStagedOrders           | false                 |
      | isMultiParcelShipper          | false                 |
      | isDisableDriverAppReschedule  | false                 |
      | pricingScriptName             | {pricing-script-name} |
      | industryName                  | {industry-name}       |
      | salesPerson                   | {sales-person}        |
      | pickupAddressCount            | 1                     |
      | address.1.milkrun.1.startTime | 3PM                   |
      | address.1.milkrun.1.endTime   | 6PM                   |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator waits for 10 seconds
    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name}           |
      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
    Then Operator verifies that success toast displayed:
      | top                | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
      | waitUntilInvisible | true                                                                                         |
    And API Operator get created Reservation Group params
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId                | addressId                | action | milkrunGroupId                     | days            | startTime | endTime |
      | {KEY_CREATED_SHIPPER.id} | {KEY_CREATED_ADDRESS.id} | add    | {KEY_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And Operator go to menu Shipper -> All Shippers
    And Operator open Edit Shipper Page of shipper "{KEY_CREATED_SHIPPER.name}"
    Then Operator verify pickup address on Edit Shipper page:
      | address.1.milkrun.1.startTime | 3PM           |
      | address.1.milkrun.1.endTime   | 6PM           |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7 |

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Operator Delete Shipper Address To Milkrun Reservation via Upload CSV
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive               | true                  |
      | shipperType                   | Normal                |
      | ocVersion                     | v4                    |
      | services                      | STANDARD              |
      | trackingType                  | Fixed                 |
      | isAllowCod                    | false                 |
      | isAllowCashPickup             | true                  |
      | isPrepaid                     | true                  |
      | isAllowStagedOrders           | false                 |
      | isMultiParcelShipper          | false                 |
      | isDisableDriverAppReschedule  | false                 |
      | pricingScriptName             | {pricing-script-name} |
      | industryName                  | {industry-name}       |
      | salesPerson                   | {sales-person}        |
      | pickupAddressCount            | 1                     |
      | address.1.milkrun.1.startTime | 3PM                   |
      | address.1.milkrun.1.endTime   | 6PM                   |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator waits for 10 seconds
    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    And API Operator get created Reservation Group params
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId                | addressId                | action | milkrunGroupId                     | days            | startTime | endTime |
      | {KEY_CREATED_SHIPPER.id} | {KEY_CREATED_ADDRESS.id} | add    | {KEY_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId                | addressId                | action | milkrunGroupId                     |
      | {KEY_CREATED_SHIPPER.id} | {KEY_CREATED_ADDRESS.id} | delete | {KEY_CREATED_RESERVATION_GROUP_ID} |
    Then Operator verifies that success toast displayed:
      | top | ^Deleted milkruns.* |
    And Operator go to menu Shipper -> All Shippers
    And Operator open Edit Shipper Page of shipper "{KEY_CREATED_SHIPPER.name}"
    Then Operator verify pickup address on Edit Shipper page:
      | address.1.milkrun.isMilkrun | false |

  @DeleteDriver @DeleteShipper @DeleteReservationGroup @CloseNewWindows
  Scenario: Operator Add and Delete Shipper Address To Milkrun Reservation via Upload CSV
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
      | pickupAddressCount           | 1                     |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive              | true                  |
      | shipperType                  | Normal                |
      | ocVersion                    | v4                    |
      | services                     | STANDARD              |
      | trackingType                 | Fixed                 |
      | isAllowCod                   | false                 |
      | isAllowCashPickup            | true                  |
      | isPrepaid                    | true                  |
      | isAllowStagedOrders          | false                 |
      | isMultiParcelShipper         | false                 |
      | isDisableDriverAppReschedule | false                 |
      | pricingScriptName            | {pricing-script-name} |
      | industryName                 | {industry-name}       |
      | salesPerson                  | {sales-person}        |
      | pickupAddressCount           | 1                     |
    And API Operator reload shipper's cache
    And API Operator fetch id of the created shipper
    And Operator waits for 10 seconds
    And API Operator get address of shipper with ID = "{KEY_LIST_OF_CREATED_SHIPPERS[1].id}"
    And API Operator get address of shipper with ID = "{KEY_LIST_OF_CREATED_SHIPPERS[2].id}"
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                           |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} |
      | hub    | {hub-name}                          |
    And API Operator get created Reservation Group params
    And Operator waits for 10 seconds
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId                            | addressId                           | action | milkrunGroupId                     | days            | startTime | endTime |
      | {KEY_LIST_OF_CREATED_SHIPPERS[1].id} | {KEY_LIST_OF_FOUND_ADDRESSES[1].id} | add    | {KEY_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    And Operator uploads CSV on Reservation Preset Management page:
      | shipperId                            | addressId                           | action | milkrunGroupId                     | days            | startTime | endTime |
      | {KEY_LIST_OF_CREATED_SHIPPERS[1].id} | {KEY_LIST_OF_FOUND_ADDRESSES[1].id} | delete | {KEY_CREATED_RESERVATION_GROUP_ID} |                 |           |         |
      | {KEY_LIST_OF_CREATED_SHIPPERS[2].id} | {KEY_LIST_OF_FOUND_ADDRESSES[2].id} | add    | {KEY_CREATED_RESERVATION_GROUP_ID} | "1,2,3,4,5,6,7" | 15:00     | 18:00   |
    Then Operator verifies that success toast displayed:
      | top | ^Created milkruns.* |
    Then Operator verifies that success toast displayed:
      | top | ^Deleted milkruns.* |
    And Operator opens Edit Shipper Page of shipper "{KEY_LIST_OF_CREATED_SHIPPERS[1].legacyId}"
    Then Operator verify pickup address on Edit Shipper page:
      | shipperId                   | {KEY_LIST_OF_CREATED_SHIPPERS[1].legacyId} |
      | address.1.milkrun.isMilkrun | false                                      |
    And Operator opens Edit Shipper Page of shipper "{KEY_LIST_OF_CREATED_SHIPPERS[2].legacyId}"
    Then Operator verify pickup address on Edit Shipper page:
      | shipperId                     | {KEY_LIST_OF_CREATED_SHIPPERS[2].legacyId} |
      | address.1.milkrun.1.startTime | 3PM                                        |
      | address.1.milkrun.1.endTime   | 6PM                                        |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7                              |

  Scenario: Operator Download Sample CSV file for Create and Delete Pickup Reservation
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator downloads sample CSV on Reservation Preset Management page
    Then sample CSV file on Reservation Preset Management page is downloaded successfully

  @DeleteDriver @DeleteShipper @DeleteReservationGroup @DeleteOrArchiveRoute
  Scenario: Route Pending Reservations From the Reservation Preset Management Page - Reservation Added to Different Driver Route
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive               | true                  |
      | shipperType                   | Normal                |
      | ocVersion                     | v4                    |
      | services                      | STANDARD              |
      | trackingType                  | Fixed                 |
      | isAllowCod                    | false                 |
      | isAllowCashPickup             | true                  |
      | isPrepaid                     | true                  |
      | isAllowStagedOrders           | false                 |
      | isMultiParcelShipper          | false                 |
      | isDisableDriverAppReschedule  | false                 |
      | pricingScriptName             | {pricing-script-name} |
      | industryName                  | {industry-name}       |
      | salesPerson                   | {sales-person}        |
      | pickupAddressCount            | 1                     |
      | address.1.milkrun.1.startTime | 9AM                   |
      | address.1.milkrun.1.endTime   | 12PM                  |
      | address.1.milkrun.1.days      | 1,2,3,4,5,6,7         |
    And API Operator fetch id of the created shipper
    And API Operator disable pickup appointment for Shipper with ID = "{KEY_CREATED_SHIPPER.legacyId}"
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                  |
      | driver | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} |
      | hub    | {hub-name}                                 |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name}           |
      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
    Then Operator verifies that success toast displayed:
      | top | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{KEY_LEGACY_SHIPPER_ID}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{KEY_LEGACY_SHIPPER_ID}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{KEY_LEGACY_SHIPPER_ID}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-next-2-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-2-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}"} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{KEY_LIST_OF_CREATED_DRIVERS[2].id}, "date":"{gradle-next-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-next-1-day-yyyy-MM-dd}T16:00:00+00:00"} |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[3]} |
    When Operator finish reservation with success
    When Operator go to menu Pick Ups -> Reservation Preset Management
    When Operator create route on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP.name} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}     |
    Then Operator verifies that success toast displayed:
      | top                | Routes have been created for all groups! |
      | waitUntilInvisible | true                                     |
    When Operator create route on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP.name} |
      | routeDate | {gradle-next-1-day-yyyy-MM-dd}       |
    Then Operator verifies that success toast displayed:
      | top                | Routes have been created for all groups! |
      | waitUntilInvisible | true                                     |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[3]} |
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | shipperId               | shipperName                   | pickupAddress                                    | routeId                | driverName                                                                           | readyBy                              | latestBy                             |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} | {KEY_LEGACY_SHIPPER_ID} | ^{KEY_CREATED_SHIPPER.name}.* | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode} | not null               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} {KEY_LIST_OF_CREATED_DRIVERS[1].lastName} | ^{gradle-current-date-yyyy-MM-dd} .* | ^{gradle-current-date-yyyy-MM-dd} .* |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} | {KEY_LEGACY_SHIPPER_ID} | ^{KEY_CREATED_SHIPPER.name}.* | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode} | not null               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} {KEY_LIST_OF_CREATED_DRIVERS[1].lastName} | ^{gradle-next-1-day-yyyy-MM-dd} .*   | ^{gradle-next-1-day-yyyy-MM-dd} .*   |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[3]} | {KEY_LEGACY_SHIPPER_ID} | ^{KEY_CREATED_SHIPPER.name}.* | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode} | {KEY_CREATED_ROUTE_ID} | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName} {KEY_LIST_OF_CREATED_DRIVERS[2].lastName} | ^{gradle-next-2-day-yyyy-MM-dd} .*   | ^{gradle-next-2-day-yyyy-MM-dd} .*   |
    When Operator refresh page
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} |
    And Operator removes reservation from route from Edit Route Details dialog
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | shipperId               | shipperName                   | pickupAddress                                    | routeId | driverName | readyBy                            | latestBy                           |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} | {KEY_LEGACY_SHIPPER_ID} | ^{KEY_CREATED_SHIPPER.name}.* | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode} | null    | null       | ^{gradle-next-1-day-yyyy-MM-dd} .* | ^{gradle-next-1-day-yyyy-MM-dd} .* |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    When Operator route pending reservations on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP.name} |
      | routeDate | {gradle-next-1-day-yyyy-MM-dd}       |
    Then Operator verifies that info toast displayed:
      | top | 1 reservations added to route |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator search reservations on Shipper Pickups page:
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[3]} |
    Then Operator verify reservations details on Shipper Pickups page:
      | id                                       | shipperId               | shipperName                   | pickupAddress                                    | routeId                | driverName                                                                           | readyBy                              | latestBy                             |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} | {KEY_LEGACY_SHIPPER_ID} | ^{KEY_CREATED_SHIPPER.name}.* | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode} | not null               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} {KEY_LIST_OF_CREATED_DRIVERS[1].lastName} | ^{gradle-current-date-yyyy-MM-dd} .* | ^{gradle-current-date-yyyy-MM-dd} .* |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} | {KEY_LEGACY_SHIPPER_ID} | ^{KEY_CREATED_SHIPPER.name}.* | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode} | not null               | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} {KEY_LIST_OF_CREATED_DRIVERS[1].lastName} | ^{gradle-next-1-day-yyyy-MM-dd} .*   | ^{gradle-next-1-day-yyyy-MM-dd} .*   |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[3]} | {KEY_LEGACY_SHIPPER_ID} | ^{KEY_CREATED_SHIPPER.name}.* | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode} | {KEY_CREATED_ROUTE_ID} | {KEY_LIST_OF_CREATED_DRIVERS[2].firstName} {KEY_LIST_OF_CREATED_DRIVERS[2].lastName} | ^{gradle-next-2-day-yyyy-MM-dd} .*   | ^{gradle-next-2-day-yyyy-MM-dd} .*   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op