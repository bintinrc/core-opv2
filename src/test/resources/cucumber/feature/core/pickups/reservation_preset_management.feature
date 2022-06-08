@OperatorV2 @Core @PickUps @ReservationPresetManagement
Feature: Reservation Preset Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteReservationGroup
  Scenario: Operator Create New Group to Assign Driver on Reservation Preset Management Page (uid:5e413315-ed96-4c3a-92b6-9b58b2d34a25)
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params

  @DeleteDriver @DeleteReservationGroup
  Scenario: Operator Edit Reservation Group on Reservation Preset Management Page (uid:c4721621-2712-410e-b8c7-561e2999361e)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params
    When Operator edit created Reservation Group on Reservation Preset Management page using data below:
      | name | GENERATED    |
      | hub  | {hub-name-2} |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page

  @DeleteDriver @DeleteReservationGroup
  Scenario: Operator Delete Reservation Group on Reservation Preset Management Page (uid:3c303ac8-8409-4337-b854-786a22b50f62)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
    Then Operator verify created Reservation Group properties on Reservation Preset Management page
    And API Operator get created Reservation Group params
    When Operator delete created Reservation Group on Reservation Preset Management page
    And Operator refresh page
    Then Operator verify created Reservation Group was deleted successfully on Reservation Preset Management page

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Assign a Shipper Milkrun Address to a Milkrun Group
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
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
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name}           |
      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
    Then Operator verifies that success toast displayed:
      | top | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Route Pending Reservations From the Reservation Preset Management Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
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
    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_address_id":{KEY_LIST_OF_SHIPPER_ADDRESSES[1].id}, "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name}           |
      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
    Then Operator verifies that success toast displayed:
      | top                | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
      | waitUntilInvisible | true                                                                                         |
    When Operator route pending reservations on Reservation Preset Management page:
      | group | {KEY_CREATED_RESERVATION_GROUP.name} |

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Create Route for Pickup Reservation - Route Date = Today
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
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
    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_address_id":{KEY_LIST_OF_SHIPPER_ADDRESSES[1].id}, "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name}           |
      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
    Then Operator verifies that success toast displayed:
      | top                | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
      | waitUntilInvisible | true                                                                                         |
    When Operator create route on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP.name} |
      | routeDate | {gradle-current-date-yyyy-MM-dd}     |

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Create Route for Pickup Reservation - Route Date = Tomorrow
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
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
    And API Operator get address of shipper with ID = "{KEY_CREATED_SHIPPER.id}"
    When Operator go to menu Pick Ups -> Reservation Preset Management
    And Operator create new Reservation Group on Reservation Preset Management page using data below:
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
    And Operator assign pending task on Reservation Preset Management page:
      | shipper | {KEY_CREATED_SHIPPER.name}           |
      | group   | {KEY_CREATED_RESERVATION_GROUP.name} |
    Then Operator verifies that success toast displayed:
      | top                | ^{KEY_CREATED_SHIPPER.name} \(.*\) has been assigned to {KEY_CREATED_RESERVATION_GROUP.name} |
      | waitUntilInvisible | true                                                                                         |
    When Operator create route on Reservation Preset Management page:
      | group     | {KEY_CREATED_RESERVATION_GROUP.name} |
      | routeDate | {gradle-next-1-day-yyyy-MM-dd}       |
    Then Operator verifies that success toast displayed:
      | top                | Routes have been created for all groups! |
      | waitUntilInvisible | true                                     |
    When Operator go to menu Pick Ups -> Shipper Pickups
    And Operator set filter parameters and click Load Selection on Shipper Pickups page:
      | fromDate    | {gradle-next-1-day-yyyy-MM-dd} |
      | toDate      | {gradle-next-1-day-yyyy-MM-dd} |
      | shipperName | {KEY_LEGACY_SHIPPER_ID}        |
      | status      | ROUTED                         |
    Then Operator verify reservation details on Shipper Pickups page:
      | shipperId              | {KEY_LEGACY_SHIPPER_ID}                                                |
      | shipperName            | ^{KEY_CREATED_SHIPPER.name}.*                                          |
      | pickupAddress          | {KEY_CREATED_ADDRESS.to1LineAddressWithPostcode}                       |
      | routeId                | not null                                                               |
      | driverName             | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | priorityLevel          | 0                                                                      |
      | readyBy                | ^{gradle-next-1-day-yyyy-MM-dd}.*                                      |
      | latestBy               | ^{gradle-next-1-day-yyyy-MM-dd}.*                                      |
      | reservationType        | REGULAR                                                                |
      | reservationStatus      | ROUTED                                                                 |
      | reservationCreatedTime | ^{gradle-current-date-yyyy-MM-dd}.*                                    |
      | serviceTime            | null                                                                   |
      | failureReason          | null                                                                   |
      | comments               | null                                                                   |

  @DeleteDriver @DeleteShipper @DeleteReservationGroup
  Scenario: Unassign a Shipper Milkrun Address from a Milkrun Group
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","driverType":"{driver-type-name}","availability":true,"codLimit":100,"maxOnDemandJobs":1,"vehicles":[{"capacity":100,"active":true,"vehicleType":"{vehicle-type}","ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}"}],"contacts":[{"active":true,"type":"{contact-type-name}","details":"+6589011608"}],"zonePreferences":[{"latitude":{{RANDOM_LATITUDE}},"longitude":{{RANDOM_LONGITUDE}},"rank":1,"zoneId":{zone-id},"minWaypoints":1,"maxWaypoints":1,"cost":1}],"tags":{"RESUPPLY":false},"username":"D{{TIMESTAMP}}","password":"D00{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","hub":"{hub-name}"}} |
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
      | name   | GENERATED                                                              |
      | driver | {KEY_CREATED_DRIVER_INFO.firstName} {KEY_CREATED_DRIVER_INFO.lastName} |
      | hub    | {hub-name}                                                             |
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op