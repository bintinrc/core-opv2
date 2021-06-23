@OperatorV2 @DistributionPoints @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Points

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HardDeleteDp
  Scenario: DP Administration - Create Distribution Point (DP) - Choose Ninja Point Type (uid:6f003723-fe55-4cdb-808c-92230ecba8eb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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

  @HardDeleteDp
  Scenario: DP Administration - Create Distribution Point (DP) - Choose Ninja Box Type (uid:9bb9265c-0513-4abe-88f8-cde661391231)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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

  @HardDeleteDp
  Scenario: DP Administration - Update Distribution Point - Ninja Point (uid:9f588a33-c2f9-45b2-a3ee-939bc5fe8e60)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | type              | Ninja Box                                           |
      | canShipperLodgeIn | false                                               |
      | contactNo         | GENERATED                                           |
      | address1          | 1 JELEBU ROAD                                       |
      | address2          | BUKIT PANJANG PLAZA, #01-32                         |
      | unitNo            | 1                                                   |
      | floorNo           | 1                                                   |
      | postcode          | 467360                                              |
      | directions        | Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360 |
    Then Operator verify new DP params
    When DB Operator fetches dp details
    And API DP get the DP Details by DP ID
    Then Operator verifies dp Params with database
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: DP Administration - Update Distribution Point - Ninja Box (uid:6e92db17-3dd6-4c11-a1e6-c7dcd7af9a41)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | type              | Ninja Point                                         |
      | canShipperLodgeIn | false                                               |
      | contactNo         | GENERATED                                           |
      | address1          | 1 JELEBU ROAD                                       |
      | address2          | BUKIT PANJANG PLAZA, #01-32                         |
      | unitNo            | 1                                                   |
      | floorNo           | 1                                                   |
      | postcode          | 467360                                              |
      | directions        | Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360 |
    Then Operator verify new DP params
    When DB Operator fetches dp details
    And API DP get the DP Details by DP ID
    Then Operator verifies dp Params with database
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: DP Administration - Download CSV DPs (uid:f4161483-42f6-4fc3-8f69-88e232e4642a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator get all DP params on DP Administration page
    And Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct DP data
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: Create DP with Cutoff Time (uid:23117956-184a-46c4-b657-fba62c5b2557)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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
      | isAutoReservation     | true                                                      |
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

  @HardDeleteDp
  Scenario: Create DP with Default Cutoff Time (uid:82f0e08c-83a0-4ca3-88ed-a433756f41f9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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
      | isAutoReservation     | true                                                      |
      | maxParcelStayDuration | 2                                                         |
      | maxCap                | 1000000                                                   |
      | capBuffer             | 1000000                                                   |
    Then Operator verify new DP params
    When DB Operator fetches dp details
    And API DP get the DP Details by DP ID
    Then Operator verifies dp Params with database
    And DB Operator fetches cut off time for dp
    Then Operator verifies the cut off time is "23:59:59"

  @HardDeleteDp
  Scenario: Edit Existing DP with Cutoff Time (uid:b8ff0986-cc38-46d4-acbd-8c412076e8f1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | type              | Ninja Point                                         |
      | canShipperLodgeIn | false                                               |
      | isAutoReservation | true                                                |
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

  @HardDeleteDp
  Scenario: Create New DP - Short name is duplicate - Return Error (uid:c61d83b1-dd57-4bfc-8ffc-315980a55609)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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

  @HardDeleteDp
  Scenario: Create New DP - External Store ID is Duplicate - Return Error (uid:1c5bf620-8782-49cd-843d-4da1e50ab281)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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

  @HardDeleteDp
  Scenario: Create New DP - Short Name and External Store ID is Duplicate - Return Error (uid:5e810b71-6531-4be7-bcaa-4527ab217fcb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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
    Then Operator verifies the error message for duplicate ""

  @HardDeleteDp
  Scenario: Update Existing DP - External Store ID is Unique - Success Update (uid:7de0e75f-58df-49fc-a808-ef1f08583720)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | externalStoreId   | GENERATED                                           |
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
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: Update Existing DP - External Store ID is Duplicate - Error Message Displayed (uid:cc27b92b-5e1d-4781-9215-e318a0d4a4a4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | externalStoreId   | TESTING-NewDP                                       |
      | type              | Ninja Box                                           |
      | canShipperLodgeIn | false                                               |
      | contactNo         | GENERATED                                           |
      | address1          | 311 NEW UPPER CHANGI ROAD                           |
      | address2          | BEDOK MALL, #B2-17/18                               |
      | unitNo            | 1                                                   |
      | floorNo           | 1                                                   |
      | postcode          | 467360                                              |
      | directions        | Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360 |
    Then Operator verifies the error message for duplicate "external_store_id TESTING-NewDP"
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: Update Existing DP - External Store ID is NULL - Success Update (uid:8067639b-8ceb-4b72-94ec-831afb3a1938)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
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
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: Update Existing DP - External Store ID is Space only - Success Update (uid:ff32b28b-b1af-4f14-93ba-a855126c64dd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | externalStoreId   |                                                     |
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
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: Create New DP - Upload DP Photos - Right Dimensions (uid:832a25fb-e77d-47a0-8b44-03d0ac98f1e3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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
      | dpPhoto               | valid                                                     |
    Then Operator verify new DP params
    When DB Operator fetches image details
    Then Operator verifies the image is "present"

  @HardDeleteDp
  Scenario: Create New DP - Upload DP Photos - Wrong Dimension (uid:76be1fe1-8fe1-4cdb-8899-d5e8ff6dc11c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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
      | dpPhoto               | invalid                                                   |
    Then Operator verify new DP params
    When DB Operator fetches image details
    Then Operator verifies the image is ""

  @HardDeleteDp
  Scenario: Create New DP - Upload DP Photos - Delete DP Photo (uid:e5cd0a1d-323a-42b8-93a2-013f8bd49921)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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
      | dpPhoto               | valid                                                     |
    Then Operator verify new DP params
    When DB Operator fetches image details
    Then Operator verifies the image is "present"
    When Operator deletes the dp image and "save settings"
    When DB Operator fetches image details
    Then Operator verifies the image is ""

  @HardDeleteDp
  Scenario: Edit Existing DP - Upload DP Photos - Right Dimensions (uid:7af87819-09c0-4970-b6f9-7610c31de4bc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator edits the dp "valid" image and save settings
    Then Operator verify new DP params
    When DB Operator fetches image details
    Then Operator verifies the image is "present"
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: Edit Existing DPs - Update DP Photo - Wrong Dimensions (uid:5b56865e-57ca-4ec4-8818-ff83ec25ef2b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator edits the dp "invalid" image and save settings
    Then Operator verify new DP params
    When DB Operator fetches image details
    Then Operator verifies the image is ""
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: Edit Existing DPs - Delete DP Photo (uid:a70e81f7-b333-47b4-bc00-ad7238ce816a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator edits the dp "valid" image and save settings
    Then Operator verify new DP params
    When DB Operator fetches image details
    Then Operator verifies the image is "present"
    When Operator deletes the dp image and "save settings"
    When DB Operator fetches image details
    Then Operator verifies the image is ""
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: Edit Existing DPs - Delete DP Photo without Save (uid:49212dd5-f298-46b4-90bf-95a9e38abdaf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator edits the dp "valid" image and save settings
    Then Operator verify new DP params
    When DB Operator fetches image details
    Then Operator verifies the image is "present"
    When Operator deletes the dp image and "return to list"
    When DB Operator fetches image details
    Then Operator verifies the image is "present"
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: Create DP - Auto Reservation Disabled
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:
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
      | isAutoReservation     | false                                                      |
    Then Operator verify new DP params
    When DB Operator fetches dp details
    And API DP get the DP Details by DP ID
    Then Operator verifies dp Params with database
    Then DB Operator verifies auto reservation for dp is "disabled"
    And DB Operator fetches cut off time for dp
    Then Operator verifies the cut off time is "23:59:59"

  @HardDeleteDp
  Scenario: Edit Existing DP - Auto Reservation to Disabled
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"auto_reservation_enabled":true,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | type              | Ninja Box                                           |
      | canShipperLodgeIn | false                                               |
      | contactNo         | GENERATED                                           |
      | address1          | 1 JELEBU ROAD                                       |
      | address2          | BUKIT PANJANG PLAZA, #01-32                         |
      | unitNo            | 1                                                   |
      | floorNo           | 1                                                   |
      | postcode          | 467360                                              |
      | directions        | Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360 |
      | isAutoReservation | false                                               |
    Then Operator verify new DP params
    When DB Operator fetches dp details
    And API DP get the DP Details by DP ID
    Then Operator verifies dp Params with database
    Then DB Operator verifies auto reservation for dp is "disabled"
    And DB Operator fetches cut off time for dp
    Then Operator verifies the cut off time is "23:59:59"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op