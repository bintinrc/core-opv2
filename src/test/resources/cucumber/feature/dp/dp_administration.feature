@OperatorV2 @DistributionPoints @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDpPartner
  Scenario: DP Administration - Create DP Partner (uid:b12cc97d-4764-4870-ac54-781e7c7970e5)
    Given Operator go to menu Distribution Points -> DP Administration
    Given Operator add new DP Partner on DP Administration page with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Then Operator verify new DP Partner params

  @DeleteDpPartner
  Scenario: DP Administration - Update DP Partner (uid:cb1ca5de-be07-4a3b-903e-955bf19dd2b1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator update created DP Partner on DP Administration page with the following attributes:
      | pocName      | UPDATED-TEST                                 |
      | pocTel       | GENERATED                                    |
      | pocEmail     | GENERATED                                    |
      | restrictions | UPDATED Created for test automation purposes |
    Then Operator verify new DP Partner params

  @DeleteDpPartner
  Scenario: DP Administration - Download CSV DP Partners (uid:ccd24e58-8ae7-4410-8d20-831b6da979b1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator get first 10 DP Partners params on DP Administration page
    When Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct DP Partners data

  @DeleteDpAndPartner
  Scenario: DP Administration - Create Distribution Point (DP) - Choose Ninja Point Type (uid:6f003723-fe55-4cdb-808c-92230ecba8eb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page with the following attributes:
      | name                  | GENERATED                                                 |
      | shortName             | TEST-DP                                                   |
      | contactNo             | GENERATED                                                 |
      | externalStoreId       | TESTING-NewDP                                             |
      | shipperId             | 129623                                                    |
      | postcode              | 677743                                                    |
      | city                  | SG                                                        |
      | address1              | 1 JELEBU ROAD                                             |
      | address2              | BUKIT PANJANG PLAZA, #01-32                               |
      | floorNo               | 12                                                        |
      | unitNo                | 11                                                        |
      | hub                   | JKB                                                       |
      | type                  | Ninja Point                                               |
      | directions            | Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743 |
      | canShipperLodgeIn     | true                                                      |
      | canCustomerCollect    | true                                                      |
      | maxParcelStayDuration | 2                                                         |
      | maxCap                | 1000000                                                   |
      | capBuffer             | 1000000                                                   |
    Then Operator verify new DP params
    When DB Operator fetches dp details
    And API DP get the DP Details by DP ID
    Then Operator verifies dp Params with database

  @DeleteDpAndPartner
  Scenario: DP Administration - Update Distribution Point - Ninja Point (uid:9f588a33-c2f9-45b2-a3ee-939bc5fe8e60)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"TEST-DP","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | type              | Ninja Point                                         |
      | canShipperLodgeIn | false                                               |
      | contactNo         | GENERATED                                           |
      | address1          | 311 NEW UPPER CHANGI ROAD                           |
      | address2          | BEDOK MALL, #B2-17/18                               |
      | unitNo            | 1                                                   |
      | floorNo           | 1                                                   |
      | postcode          | 467360                                              |
      | directions        | Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360 |
    Then Operator verify new DP params
    When DB Operator fetches dp details
    And API DP get the DP Details by DP ID
    Then Operator verifies dp Params with database

  @DeleteDpAndPartner
  Scenario: DP Administration - Download CSV DPs (uid:f4161483-42f6-4fc3-8f69-88e232e4642a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"TEST-DP","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator get all DP params on DP Administration page
    And Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct DP data

  @DeleteDpAndPartner
  Scenario: DP Administration - Create DP User (uid:0146137a-6964-4985-a417-7bbd6035e5b7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"TEST-DP","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName    | Han       |
      | lastName     | Solo      |
      | contactNo    | GENERATED |
      | emailId      | GENERATED |
      | clientId     | GENERATED |
      | clientSecret | p@ssw0rd  |
    Then Operator verify new DP User params

  @DeleteDpAndPartner
  Scenario: DP Administration - Update DP user (uid:cfa0f458-4373-4927-b411-a653e5b9dc10)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"TEST-DP","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    And Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName    | Han       |
      | lastName     | Solo      |
      | contactNo    | GENERATED |
      | emailId      | GENERATED |
      | clientId     | GENERATED |
      | clientSecret | p@ssw0rd  |
    When Operator update created DP User for the created DP on DP Administration page with the following attributes:
      | firstName | Jabba     |
      | lastName  | Hutt      |
      | contactNo | GENERATED |
      | emailId   | GENERATED |
    Then Operator verify new DP User params

  @DeleteDpAndPartner
  Scenario: DP Administration - Download CSV DP Users (uid:11060b54-7a1d-4122-9ceb-7f693c1bf154)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"TEST-DP","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    And API Operator add new DP User for the created DP with the following attributes:
      | requestBody | {"firstName":"Han","lastName":"Solo","contactNo":"{{generated_phone_no}}","emailId":"{{unique_string}}@gmail.com","clientId":"DP-USER-{{unique_string}}","clientSecret":"{{unique_string}}"} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    And Operator select View Users action for created DP on DP Administration page
    When Operator get all DP Users params on DP Administration page
    And Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct DP Users data

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
