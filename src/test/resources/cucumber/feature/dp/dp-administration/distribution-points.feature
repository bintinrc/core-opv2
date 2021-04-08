@OperatorV2 @DistributionPoints @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Points

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

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
      | shortName             | GENERATED                                                 |
      | contactNo             | GENERATED                                                 |
      | externalStoreId       | GENERATED                                                 |
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
  Scenario: DP Administration - Create Distribution Point (DP) - Choose Ninja Box Type (uid:9bb9265c-0513-4abe-88f8-cde661391231)
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
      | shortName             | GENERATED                                                 |
      | contactNo             | GENERATED                                                 |
      | externalStoreId       | GENERATED                                                 |
      | shipperId             | 129623                                                    |
      | postcode              | 677743                                                    |
      | city                  | SG                                                        |
      | address1              | 1 JELEBU ROAD                                             |
      | address2              | BUKIT PANJANG PLAZA, #01-32                               |
      | floorNo               | 12                                                        |
      | unitNo                | 11                                                        |
      | hub                   | JKB                                                       |
      | type                  | Ninja Box                                                 |
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
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | type              | Ninja Box                                           |
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
  Scenario: DP Administration - Update Distribution Point - Ninja Box (uid:6e92db17-3dd6-4c11-a1e6-c7dcd7af9a41)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
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
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator get all DP params on DP Administration page
    And Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct DP data

  @DeleteDpAndPartner
  Scenario: Create DP with Cutoff Time (uid:23117956-184a-46c4-b657-fba62c5b2557)
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
      | shortName             | GENERATED                                                 |
      | contactNo             | GENERATED                                                 |
      | externalStoreId       | GENERATED                                                 |
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
      | cutOffTime            | 15 h 30 m                                                 |
    Then Operator verify new DP params
    When DB Operator fetches dp details
    And API DP get the DP Details by DP ID
    Then Operator verifies dp Params with database
    And DB Operator fetches cut off time for dp
    Then Operator verifies the cut off time is "15:30:00"

  @DeleteDpAndPartner
  Scenario: Create DP with Default Cutoff Time (uid:82f0e08c-83a0-4ca3-88ed-a433756f41f9)
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
      | shortName             | GENERATED                                                 |
      | contactNo             | GENERATED                                                 |
      | externalStoreId       | GENERATED                                                 |
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
    And DB Operator fetches cut off time for dp
    Then Operator verifies the cut off time is "23:59:59"

  @DeleteDpAndPartner
  Scenario: Edit Existing DP with Cutoff Time (uid:b8ff0986-cc38-46d4-acbd-8c412076e8f1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | GENERATED                            |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
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
      | cutOffTime        | 19 h 00 m                                           |
    Then Operator verify new DP params
    When DB Operator fetches dp details
    And API DP get the DP Details by DP ID
    Then Operator verifies dp Params with database
    And DB Operator fetches cut off time for dp
    Then Operator verifies the cut off time is "19:00:00"

  @DeleteDpAndPartner
  Scenario: Create New DP - Short name is duplicate - Return Error
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
      | externalStoreId       | GENERATED                                                 |
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
    Then Operator verifies the error message for duplicate "short_name TEST-DP"

  @DeleteDpAndPartner
  Scenario: Create New DP - External Store ID is Duplicate - Return Error
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
      | shortName             | GENERATED                                                 |
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
    Then Operator verifies the error message for duplicate "external_store_id TESTING-NewDP"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op