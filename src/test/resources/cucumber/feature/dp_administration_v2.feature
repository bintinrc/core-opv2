@OperatorV2Disabled @DpAdministrationV2
Feature: DP Administration

  @LaunchBrowser
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDpPartner
  Scenario: Operator should be able to create a new DP Partners on DP Administration page
    Given Operator go to menu Distribution Points -> DP Administration
    Given Operator add new DP Partner on DP Administration page with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Then Operator verify new DP Partner params

  @DeleteDpPartner
  Scenario: Operator should be able to update a new DP Partners on DP Administration page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
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
  Scenario: Operator should be able to download and verify DP Partners CSV file on DP Administration page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator get first 10 DP Partners params on DP Administration page
    When Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct PD Partners data

  @DeleteDpAndPartner
  Scenario: Operator should be able to create a new DP on DP Administration page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator add new DP for the DP Partner on DP Administration page with the following attributes:
      | name               | GENERATED                                                 |
      | shortName          | TEST-DP                                                   |
      | type               | Ninja Box                                                 |
      | canShipperLodgeIn  | true                                                      |
      | canCustomerCollect | true                                                      |
      | contactNo          | GENERATED                                                 |
      | address1           | 1 JELEBU ROAD                                             |
      | address2           | BUKIT PANJANG PLAZA, #01-32                               |
      | city               | SG                                                        |
      | country            | SG                                                        |
      | postcode           | 677743                                                    |
      | directions         | Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743 |
    Then Operator verify new DP params

  @DeleteDpAndPartner
  Scenario: Operator should be able to update a new DP on DP Administration page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"TEST-DP","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","country":"SG","postal_code":"677743","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | shortName         | UPDATED-TEST-DP                                     |
      | type              | Ninja Point                                         |
      | canShipperLodgeIn | false                                               |
#      | canCustomerCollect | false                                               | causes 500 error
      | contactNo         | GENERATED                                           |
      | address1          | 311 NEW UPPER CHANGI ROAD                           |
      | address2          | BEDOK MALL, #B2-17/18                               |
      | postcode          | 467360                                              |
      | directions        | Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360 |
    Then Operator verify new DP params

  @DeleteDpAndPartner
  Scenario: Operator should be able to download and verify DPs CSV file on DP Administration page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"TEST-DP","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","country":"SG","postal_code":"677743","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator get all DP params on DP Administration page
    And Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct PD data

  @DeleteDpAndPartner
  Scenario: Operator should be able to create a new DP User on DP Administration page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"TEST-DP","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","country":"SG","postal_code":"677743","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
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
  Scenario: Operator should be able to update a DP User on DP Administration page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"TEST-DP","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","country":"SG","postal_code":"677743","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    And API Operator add new DP User for the created DP with the following attributes:
      | requestBody | {"firstName":"Han","lastName":"Solo","contactNo":"{{generated_phone_no}}","emailId":"{{unique_string}}@gmail.com","clientId":"DP-USER-{{unique_string}}","clientSecret":"{{unique_string}}"} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    And Operator select View Users action for created DP on DP Administration page
    When Operator update created DP User for the created DP on DP Administration page with the following attributes:
      | firstName | Jabba     |
      | lastName  | Hutt      |
      | contactNo | GENERATED |
      | emailId   | GENERATED |
    Then Operator verify new DP User params

  @DeleteDpAndPartner
  Scenario: Operator should be able to download and verify DP Users CSV file on DP Administration page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"TEST-DP","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","country":"SG","postal_code":"677743","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    And API Operator add new DP User for the created DP with the following attributes:
      | requestBody | {"firstName":"Han","lastName":"Solo","contactNo":"{{generated_phone_no}}","emailId":"{{unique_string}}@gmail.com","clientId":"DP-USER-{{unique_string}}","clientSecret":"{{unique_string}}"} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    And Operator select View Users action for created DP on DP Administration page
    When Operator get all DP Users params on DP Administration page
    And Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct PD Users data

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
