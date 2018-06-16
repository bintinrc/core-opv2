@OperatorV2Disabled @DpAdministrationV2
Feature: DP Administration

  @LaunchBrowser
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to create a new DP Partners on DP Administration page
    Given Operator go to menu Distribution Points -> DP Administration
    Given Operator add new DP Partner on DP Administration page with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Then Operator verify new DP Partner params

  Scenario: Operator should be able to update a new DP Partners on DP Administration page
    Given Operator go to menu Distribution Points -> DP Administration
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    When Operator update created DP Partner on DP Administration page with the following attributes:
      | pocName      | UPDATED-TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | UPDATED Created for test automation purposes |
    Then Operator verify new DP Partner params

  Scenario: Operator should be able to download and verify DP Partners CSV file on DP Administration page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Administration
    When Operator get first 10 DP Partners params on DP Administration page
    When Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct PD Partners data


  Scenario: Operator should be able to create a new DP on DP Administration page
    Given Operator go to menu Distribution Points -> DP Administration
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    When Operator add new DP for the DP Partner on DP Administration page with the following attributes:
      | name              | GENERATED                                                 |
      | shortName         | TEST-DP                                                   |
      | type              | Ninja Box                                                 |
      | canShipperLodgeIn | true                                                      |
      | canCustomerCollect | true                                                      |
      | contactNo         | GENERATED                                                 |
      | address1          | 1 JELEBU ROAD                                             |
      | address2          | BUKIT PANJANG PLAZA, #01-32                               |
      | city              | SG                                                        |
      | country           | SG                                                        |
      | postcode          | 677743                                                    |
      | directions        | Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743 |
    Then Operator verify new DP params

  Scenario: Operator should be able to update a new DP Partners on DP Administration page
    Given Operator go to menu Distribution Points -> DP Administration
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given Operator add new DP for the DP Partner on DP Administration page with the following attributes:
      | name              | GENERATED                                                 |
      | shortName         | TEST-DP                                                   |
      | type              | Ninja Box                                                 |
      | canShipperLodgeIn | true                                                      |
      | canCustomerCollect | true                                                      |
      | contactNo         | GENERATED                                                 |
      | address1          | 1 JELEBU ROAD                                             |
      | address2          | BUKIT PANJANG PLAZA, #01-32                               |
      | city              | SG                                                        |
      | country           | SG                                                        |
      | postcode          | 677743                                                    |
      | directions        | Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743 |
    When Operator update created DP for the DP Partner on DP Administration page with the following attributes:
      | shortName         | UPDATED-TEST-DP                                     |
      | type              | Ninja Point                                         |
      | canShipperLodgeIn | false                                               |
      | canCustomerCollect | false                                               |
      | contactNo         | GENERATED                                           |
      | address1          | 311 NEW UPPER CHANGI ROAD                           |
      | address2          | BEDOK MALL, #B2-17/18                               |
      | postcode          | 467360                                              |
      | directions        | Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360 |
    Then Operator verify new DP params

  @DeleteDpAndPartner
  Scenario: Operator should be able to download and verify DPs CSV file on DP Administration page
    Given Operator go to menu Distribution Points -> DP Administration
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given Operator add new DP for the DP Partner on DP Administration page with the following attributes:
      | name              | GENERATED                                                 |
      | shortName         | TEST-DP                                                   |
      | type              | Ninja Box                                                 |
      | canShipperLodgeIn | true                                                      |
      | canCustomerCollect | true                                                      |
      | contactNo         | GENERATED                                                 |
      | address1          | 1 JELEBU ROAD                                             |
      | address2          | BUKIT PANJANG PLAZA, #01-32                               |
      | city              | SG                                                        |
      | country           | SG                                                        |
      | postcode          | 677743                                                    |
      | directions        | Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743 |
    When Operator get all DP params on DP Administration page
    And Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct PD data

  @DeleteDpAndPartner
  Scenario: Operator should be able to create a new DP User on DP Administration page
    Given Operator go to menu Distribution Points -> DP Administration
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given Operator add new DP for the DP Partner on DP Administration page with the following attributes:
      | name              | GENERATED                                                 |
      | shortName         | TEST-DP                                                   |
      | type              | Ninja Box                                                 |
      | canShipperLodgeIn | true                                                      |
      | canCustomerCollect | true                                                      |
      | contactNo         | GENERATED                                                 |
      | address1          | 1 JELEBU ROAD                                             |
      | address2          | BUKIT PANJANG PLAZA, #01-32                               |
      | city              | SG                                                        |
      | country           | SG                                                        |
      | postcode          | 677743                                                    |
      | directions        | Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743 |
    When Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName | Han       |
      | lastName  | Solo      |
      | contactNo | GENERATED |
      | email     | GENERATED |
      | username  | GENERATED |
      | password  | p@ssw0rd  |
    Then Operator verify new DP User params

  @DeleteDpAndPartner
  Scenario: Operator should be able to update a DP User on DP Administration page
    Given Operator go to menu Distribution Points -> DP Administration
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given Operator add new DP for the DP Partner on DP Administration page with the following attributes:
      | name              | GENERATED                                                 |
      | shortName         | TEST-DP                                                   |
      | type              | Ninja Box                                                 |
      | canShipperLodgeIn | true                                                      |
      | canCustomerCollect | true                                                      |
      | contactNo         | GENERATED                                                 |
      | address1          | 1 JELEBU ROAD                                             |
      | address2          | BUKIT PANJANG PLAZA, #01-32                               |
      | city              | SG                                                        |
      | country           | SG                                                        |
      | postcode          | 677743                                                    |
      | directions        | Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743 |
    When Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName | Han       |
      | lastName  | Solo      |
      | contactNo | GENERATED |
      | email     | GENERATED |
      | username  | GENERATED |
      | password  | p@ssw0rd  |
    When Operator update created DP User for the created DP on DP Administration page with the following attributes:
      | firstName | Jabba        |
      | lastName  | Hutt         |
      | contactNo | GENERATED    |
      | email     | GENERATED    |
    Then Operator verify new DP User params

  @DeleteDpAndPartner
  Scenario: Operator should be able to download and verify DP Users CSV file on DP Administration page
    Given Operator go to menu Distribution Points -> DP Administration
    Given API Operator create new DP Partner with the following attributes:
      | name         | GENERATED                            |
      | pocName      | TEST                                 |
      | pocTel       | GENERATED                            |
      | pocEmail     | GENERATED                            |
      | restrictions | Created for test automation purposes |
    Given Operator add new DP for the DP Partner on DP Administration page with the following attributes:
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
    When Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName | Han       |
      | lastName  | Solo      |
      | contactNo | GENERATED |
      | email     | GENERATED |
      | username  | GENERATED |
      | password  | p@ssw0rd  |
    When Operator get all DP Users params on DP Administration page
    And Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct PD Users data

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
