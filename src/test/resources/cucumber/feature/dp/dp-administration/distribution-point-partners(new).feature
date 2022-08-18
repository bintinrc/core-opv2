@OperatorV2 @DpAdministration @DistributionPointPartnersReact @OperatorV2Part1 @DpAdministrationV2 @EnableClearCache @DP
Feature: DP Administration - Distribution Point Partners

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDpPartner
  Scenario: DP Administration - Download CSV DP Partners (uid:ccd24e58-8ae7-4410-8d20-831b6da979b1)
    Given Operator go to menu Distribution Points -> DP Administration (New)
    Then The Dp Administration page is displayed
    And API Operator get DP Management partner list
    When Operator get DP Partners Data on DP Administration page
      | dpPartnerList | KEY_DP_MANAGEMENT_PARTNER_LIST |
      | count         | 10                             |
    When Operator click on Download CSV File button on React page
    Then Downloaded CSV file contains correct DP Partners data in new react page

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: DP Administration - Search DP partner (uid:2a3723b3-4584-492d-871e-52b439b2ade3)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    And Operator refresh page
    Given Operator go to menu Distribution Points -> DP Administration (New)
    Then The Dp Administration page is displayed
    And Operator Search with Some DP Partner Details :
      | searchDetails | id,name,pocName,pocTel,pocEmail,restrictions |
    And Operator check the data again with pressing ascending and descending order :
      | searchDetails | id,name,pocName,pocTel,pocEmail,restrictions |

  Scenario Outline: DP Administration - Create DP Partner - Check validation form - <dataset_name>
    Given Operator go to menu Distribution Points -> DP Administration (New)
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator refresh page
    And Operator click on Add Partner button on DP Administration React page
    Then Operator Fill Dp Partner Details below :
      | name                      | pocName     | pocTel | pocEmail                | restrictions     | sendNotificationsToCustomer |
      | ERROR_CHECK_<key_dataset> | Diaz Ilyasa | VALID  | diaz.ilyasa@ninjavan.co | Only For Testing | true                        |
    And Operator will check the error message is equal "<error_message>"

    Examples:
      | dataset_name       | key_dataset | error_message                    |
      | Empty Partner Name | NAME        | This field is required           |
      | Empty POC Name     | POCNME      | This field is required           |
      | Empty POC No       | POCNUM      | This field is required           |
      | Empty Restrictions | RESTRICTION | This field is required           |
      | Wrong Format Email | POCMAIL     | That doesn't look like an email. |


  @DeleteNewlyCreatedDpManagementPartner
  Scenario: DP Administration - Create DP Partner (uid:b12cc97d-4764-4870-ac54-781e7c7970e5)
    Given Operator go to menu Distribution Points -> DP Administration (New)
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator refresh page
    And Operator click on Add Partner button on DP Administration React page
    Then Operator Fill Dp Partner Details below :
      | name                                    | pocName     | pocTel | pocEmail                | restrictions     | sendNotificationsToCustomer |
      | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | Diaz Ilyasa | VALID  | diaz.ilyasa@ninjavan.co | Only For Testing | true                        |
    Then Operator press submit button
    And Operator check the submitted data in the table
    And Operator get partner id
    Then DB Operator get newly DP partner by Id
    Then Operator need to make sure that the id and dpms partner id from newly created dp partner is same

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: DP Administration - Update DP Partner (uid:cb1ca5de-be07-4a3b-903e-955bf19dd2b1)
    Given Operator go to menu Distribution Points -> DP Administration (New)
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator click on Add Partner button on DP Administration React page
    Then Operator Fill Dp Partner Details below :
      | name                                    | pocName     | pocTel | pocEmail                | restrictions     | sendNotificationsToCustomer |
      | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | Diaz Ilyasa | VALID  | diaz.ilyasa@ninjavan.co | Only For Testing | true                        |
    Then Operator press submit button
    And Operator check the submitted data in the table
    And Operator get partner id
    Then Operator press edit partner button
    Then Operator Fill Dp Partner Details below :
      | pocName     | pocTel   |
      | UPDATE TEST | 11111111 |
    Then Operator press submit partner changes button
    And Operator check the submitted data in the table
    Then DB Operator get newly DP partner by Id
    Then Operator need to make sure that the id and dpms partner id from newly created dp partner is same

  @DeleteNewlyCreatedDpManagementPartner
  Scenario Outline: DP Administration - Update DP Partner - Check validation form - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Distribution Points -> DP Administration (New)
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator click on Add Partner button on DP Administration React page
    Then Operator Fill Dp Partner Details below :
      | name                                    | pocName     | pocTel | pocEmail                | restrictions     | sendNotificationsToCustomer |
      | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | Diaz Ilyasa | VALID  | diaz.ilyasa@ninjavan.co | Only For Testing | true                        |
    Then Operator press submit button
    And Operator check the submitted data in the table
    And Operator get partner id
    Then Operator press edit partner button
    Then Operator Fill Dp Partner Details below :
      | name                      | pocName     | pocTel | pocEmail                | restrictions     | sendNotificationsToCustomer |
      | ERROR_CHECK_<key_dataset> | Diaz Ilyasa | VALID  | diaz.ilyasa@ninjavan.co | Only For Testing | true                        |
    And Operator will check the error message is equal "<error_message>"

    Examples:
      | dataset_name       | key_dataset | error_message                          | form        | hiptest-uid                              |
      | Empty Partner Name | NAME        | This field is required                 | name        | uid:069ee3a5-8cb2-4635-8e2f-f2c3099377fd |
      | Empty POC Name     | POCNME      | This field is required                 | pocName     | uid:c410a9dd-077e-4440-932c-d34ef2921292 |
      | Empty POC No       | POCNUM      | This field is required                 | pocTel      | uid:0259c76c-91e5-44b3-91bf-a9f88bc5e3ab |
      | Invalid POC No     | !POCNUM     | That doesn't look like a phone number. | pocTel      | uid:704e42eb-3920-4b1a-99fc-844e39a520e1 |
      | Empty Restrictions | RESTRICTION | This field is required                 | restriction | uid:40c4ce1e-e5ab-43ac-8cb0-e7c01ae83fcf |
      | Wrong Format Email | POCMAIL     | That doesn't look like an email.       | pocEmail    | uid:0fe5eebf-b7b6-40cc-8d13-7b6576da02b9 |
