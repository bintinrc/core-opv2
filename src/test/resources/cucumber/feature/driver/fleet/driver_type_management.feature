@OperatorV2 @Driver @Fleet @DriverTypeManagement
Feature: Driver Type Management

  Background:
    When Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Download CSV File of Driver Type (uid:76f6ba04-4f9c-46f7-b450-8b73f67a7b7b)
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Type Management
    When Operator get all Driver Type params on Driver Type Management page
    And Operator click on Download CSV File button on Driver Type Management page
    Then Downloaded CSV file contains correct Driver Types data

  @DeleteDriverType
  Scenario: Create New Driver Type (uid:eaa1b45c-725f-4ec3-9383-99fa808f887a)
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Type Management
    And Operator create new Driver Type with the following attributes:
      | driverTypeName | DT-{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator get new Driver Type params on Driver Type Management page
    Then Operator verify new Driver Type params

  @DeleteDriverType
  Scenario: Update Driver Type (uid:d47cf8da-5c64-4771-ad90-0ceed2f4bac0)
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Type Management
    And Operator create new Driver Type with the following attributes:
      | driverTypeName | DT-{gradle-current-date-yyyyMMddHHmmsss} |
    And Operator get new Driver Type params on Driver Type Management page
    When Operator edit new Driver Type with the following attributes:
      | driverTypeName | DT-{gradle-current-date-yyyyMMddHHmmsss}-Updatedname |
    Then Operator verify new Driver Type params

  @DeleteDriverType
  Scenario: Delete Driver Type That Is Not Being Used by Driver (uid:693eafa6-09c6-4a38-9a84-043c5afed854)
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Type Management
    And Operator create new Driver Type with the following attributes:
      | driverTypeName | DT-{gradle-current-date-yyyyMMddHHmmsss} |
    And Operator get new Driver Type params on Driver Type Management page
    When Operator delete new Driver Type on on Driver Type Management page
    Then Operator verify new Driver Type is deleted successfully

  @DeleteDriverType @DeleteDriverV2
  Scenario: Can Not Delete Driver Type That Is Being Used by Driver (uid:ea7d45b6-cc32-4362-8b8c-f57743a6d453)
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Type Management
    And Operator create new Driver Type with the following attributes:
      | driverTypeName | DT-{gradle-current-date-yyyyMMddHHmmsss} |
    And Operator get new Driver Type params on Driver Type Management page
    And API Operator create new Driver using data below:
      | driverCreateRequest | { "first_name": "{{RANDOM_FIRST_NAME}}", "last_name": "{{RANDOM_LAST_NAME}}", "display_name": "{{RANDOM_FIRST_NAME}}", "license_number": "D{{TIMESTAMP}}", "driver_type": "{KEY_CREATED_DRIVER_TYPE_NAME}", "availability": false, "cod_limit": 1, "vehicles": [ { "active": true, "vehicleNo": "D{{TIMESTAMP}}", "vehicleType": "{vehicle-type}", "ownVehicle": false, "capacity": 1 } ], "contacts": [ { "active": true, "type": "{contact-type-name}", "details": "{{DRIVER_CONTACT_DETAIL}}" } ], "zone_preferences": [ { "latitude": {{RANDOM_LATITUDE}}, "longitude": {{RANDOM_LONGITUDE}}, "maxWaypoints": 2, "minWaypoints": 1, "rank": 1, "zoneId": {zone-id}, "cost": 5 } ], "max_on_demand_jobs": 2, "username": "D{{TIMESTAMP}}", "password": "Ninjitsu89", "tags": {}, "employment_start_date": "{gradle-current-date-yyyy-MM-dd}", "employment_end_date": null, "hub_id": {hub-id}, "hub": { "displayName": "{hub-name}", "value": 16 } } |
    When Operator delete new Driver Type on on Driver Type Management page
    Then Operator verify toast error message "Driver type is still being used by some drivers" displayed
    And Operator verify new Driver Type params

#  @DeleteDriverType Commented as this scenario is no longer applicable as these columns are removed from the Driver Type
#  Scenario Outline: Filter Driver Type - <dataset_name> (<hiptest-uid>)
#    Given Operator loads Operator portal home page
#    And Operator go to menu Fleet -> Driver Type Management
#    And Operator create new Driver Type with the following attributes:
#      | driverTypeName | DT-{gradle-current-date-yyyyMMddHHmmsss} |
#    And Operator get new Driver Type params on Driver Type Management page
#    When Operator configure filter on Driver Type Management page with the following attributes:
#      | <param> | <value> |
#    Then Operator verify filter results on Driver Type Management page
#    Examples:
#      | dataset_name                           | hiptest-uid                              | param           | value                |
#      | Delivery Type: Normal Delivery         | uid:a69d8fa5-aad1-4170-a100-bd43c9b0b793 | deliveryType    | Normal Delivery      |
#      | Delivery Type: C2C + Return Pick Up    | uid:00b15b2c-e87c-4e07-823c-24ee481380cf | deliveryType    | C2C + Return Pick Up |
#      | Delivery Type: Reservation Pick Up     | uid:21c1de4e-0619-4b53-8d23-64105d2acf79 | deliveryType    | Reservation Pick Up  |
#      | Priority Level: Priority               | uid:b514d462-467c-47a0-b4fe-c82df5834889 | priorityLevel   | Priority             |
#      | Priority Level: Non-Priority           | uid:9027f529-996c-4d58-a4c9-5e6bac0a2277 | priorityLevel   | Non-Priority         |
#      | Reservation Size: Less Than 3 Parcels  | uid:ba68986e-ee83-4cec-abf5-4cebf192794f | reservationSize | Less Than 3 Parcels  |
#      | Reservation Size: Less Than 10 Parcels | uid:f8d513f3-ae0a-4e64-95a7-ebf664923665 | reservationSize | Less Than 10 Parcels |
#      | Reservation Size: Trolley Required     | uid:9804ec93-777d-4f93-943b-aaa457e4303a | reservationSize | Trolley Required     |
#      | Reservation Size: Half Van Load        | uid:72144b17-806c-45e5-a0fb-78582d974f52 | reservationSize | Half Van Load        |
#      | Reservation Size: Full Van Load        | uid:f6b83d44-d9d2-4260-98d5-de01176275f7 | reservationSize | Full Van Load        |
#      | Reservation Size: Larger Than Van Load | uid:40c8c390-cf70-4c72-886e-c9da988ac0f9 | reservationSize | Larger Than Van Load |
#      | Parcel Size: Small                     | uid:20280f7f-776b-459c-898a-ab395149d9f9 | parcelSize      | Small                |
#      | Parcel Size: Medium                    | uid:0bc47f9e-84e9-44e3-8b3c-0713d2fb9155 | parcelSize      | Medium               |
#      | Parcel Size: Large                     | uid:9cd5657d-91d5-4007-90bb-d73c56c6ce73 | parcelSize      | Large                |
#      | Parcel Size: Extra Large               | uid:323c0136-f16a-4a50-ba57-b228b8785ad3 | parcelSize      | Extra Large          |
#      | Timeslot: 9AM to 6PM                   | uid:059d54c9-5c0b-460a-871d-993b7bf30a6b | timeslot        | 9AM To 6PM           |
#      | Timeslot: 9AM to 10PM                  | uid:edff64fb-462c-4634-bb6f-d48a684f35d9 | timeslot        | 9AM To 10PM          |
#      | Timeslot: 9AM to 12PM                  | uid:53f0409a-e6a4-4cf3-b21e-c2d1304f070e | timeslot        | 9AM To 12PM          |
#      | Timeslot: 12PM to 3PM                  | uid:61d3a209-bb95-43bd-9c17-900809c502a1 | timeslot        | 12PM To 3PM          |
#      | Timeslot: 3PM to 6PM                   | uid:f10f162d-1a52-4889-ba33-da950d324327 | timeslot        | 3PM To 6PM           |
#      | Timeslot: 6PM to 10PM                  | uid:867017c2-566a-465f-b253-b78b52367824 | timeslot        | 6PM To 10PM          |

  @RunThis @DeleteDriverType
  Scenario: Search Driver Type by ID
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Type Management
    And Operator create new Driver Type with the following attributes:
      | driverTypeName | DT-{gradle-current-date-yyyyMMddHHmmsss} |
    And Operator get new Driver Type params on Driver Type Management page
    Then Operator search created Driver Type using ID

  @DeleteDriverType
  Scenario: List All Driver Type
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Type Management
    When Operator create new Driver Type with the following attributes:
      | driverTypeName | DT-{gradle-current-date-yyyyMMddHHmmsss} |
    And API Operator get all driver types
    And Operator refresh page
    Then Operator verify all driver types are displayed on Driver Type Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
