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

  Scenario Outline: DP Administration - Create DP Partner - Check validation form - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Distribution Points -> DP Administration (New)
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator refresh page
    And Operator click on Add Partner button on DP Administration React page
    And Operator define the DP Partner value "<input>" for key "<key_dataset>"
    Then Operator Fill Dp Partner Details to Check The Error Status with key "<key_dataset>"
    And Operator will check the error message is equal "<error_message>"

    Examples:
      | dataset_name              | key_dataset  | error_message                                                                                                                 | input                    | hiptest-uid                              |
      | Empty Partner Name        | NAME         | This field is required                                                                                                        | abc                      | uid:be66a290-cb2a-49ec-b4ac-88e221172a46 |
      | Empty POC Name            | POCNME       | This field is required                                                                                                        | abc                      | uid:0b74eb08-7eaf-486f-94ad-e1adc99b04f9 |
      | Empty POC No              | POCNUM       | This field is required                                                                                                        | +65746                   | uid:dd7c5e95-21d2-41b5-adcc-169e12a0c039 |
      | Empty Restrictions        | RESTRICTION  | This field is required                                                                                                        | abc                      | uid:488e1065-b0f4-4336-b98b-a70449fdaa37 |
      | Wrong Format Email        | POCMAIL      | That doesn't look like an email.                                                                                              | @jlgkdg.c                | uid:fedb91ca-d2f5-4332-8f69-10977790c0b9 |
      | Invalid POC No            | !POCNUM      | That doesn't look like a phone number.                                                                                        | 36456dfhdfhd             | uid:13991f78-4626-4920-adbd-2939d25c478c |
      | Invalid Partner Name      | !NAME        | Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( ) | Mir$@&(Aziz)             | uid:ff15623d-b2c4-4094-9082-0d0440b2e3e8 |
      | Invalid POC Name          | !POCNME      | Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( ) | Aziz~Ichwanul?{Ninjavan} | uid:0ba8ddac-60f2-4015-8911-fcf7cc93f5e3 |
      | Invalid Restrictions name | !RESTRICTION | Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( ) | {Alfa}<Express>          | uid:c707f35a-f992-49b2-bf1b-efe999c0a462 |

  Scenario Outline: DP Administration - Create DP Partner - Additional check validation form - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Distribution Points -> DP Administration (New)
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator refresh page
    And Operator click on Add Partner button on DP Administration React page
    And Operator define the DP Partner value "<input>" for key "<key_dataset>"
    Then Operator Fill Dp Partner Details to Check The Error Status with key "<key_dataset>"
    And Operator will check the error message is equal "<error_message>"
    And Operator clear the "<key_dataset>" from DP Partner form
    Then Operator Fill Dp Partner Details below :
      | name                                    | pocName     | pocTel | pocEmail                | restrictions     | sendNotificationsToCustomer |
      | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | Diaz Ilyasa | VALID  | diaz.ilyasa@ninjavan.co | Only For Testing | true                        |
    Then Operator press submit button
    And Operator check the submitted data in the table
    And Operator get partner id
    Then DB Operator get newly DP partner by Id
    Then Operator need to make sure that the id and dpms partner id from newly created dp partner is same

    Examples:
      | dataset_name                                                                                                                  | key_dataset  | error_message                                                                                                                 | input                    | hiptest-uid                              |
      | Invalid POC No                                                                                                                | !POCNUM      | That doesn't look like a phone number.                                                                                        | 36456dfhdfhd             | uid:2efaba07-c86c-45b5-83d8-5c82f632fb4f |
      | Invalid Partner Name                                                                                                          | !NAME        | Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( ) | Mir$@&(Aziz)             | uid:51e38f33-29dc-4ba7-87c2-624e43ac3cb1 |
      | Invalid POC Name                                                                                                              | !POCNME      | Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( ) | Aziz~Ichwanul?{Ninjavan} | uid:179943b5-8d53-4486-a7a3-ab4386341818 |
      | Invalid Restrictions name                                                                                                     | !RESTRICTION | Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( ) | {Alfa}<Express>          | uid:e1196875-4c30-4c76-9576-3f940e323295 |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario Outline: DP Administration - Create DP Partner - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Distribution Points -> DP Administration (New)
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator refresh page
    And Operator click on Add Partner button on DP Administration React page
    Then Operator Fill Dp Partner Details below :
      | name                                    | pocName     | pocTel         | pocEmail                | restrictions     | sendNotificationsToCustomer |
      | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | Diaz Ilyasa | <phone_number> | diaz.ilyasa@ninjavan.co | Only For Testing | true                        |
    Then Operator press submit button
    And Operator check the submitted data in the table
    And Operator get partner id
    Then DB Operator get newly DP partner by Id
    Then Operator need to make sure that the id and dpms partner id from newly created dp partner is same
    Examples:
      | dataset_name                   | phone_number | hiptest-uid                              |
      | Valid POC no                   | 65234727352  | uid:fc6502ee-9cbe-48a1-8a87-95da834f3dab |
      | Valid POC no with country code | +65657 35726 | uid:1cb54cfb-f586-4228-82d1-7f3e7716ea02 |

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
    And Operator define the DP Partner value "<input>" for key "<key_dataset>"
    Then Operator Fill Dp Partner Details to Check The Error Status with key "<key_dataset>"
    And Operator will check the error message is equal "<error_message>"

    Examples:
      | dataset_name              | key_dataset  | error_message                                                                                                                 | form        | input                    | hiptest-uid                              |
      | Empty Partner Name        | NAME         | This field is required                                                                                                        | name        | abc                      | uid:069ee3a5-8cb2-4635-8e2f-f2c3099377fd |
      | Empty POC Name            | POCNME       | This field is required                                                                                                        | pocName     | abc                      | uid:c410a9dd-077e-4440-932c-d34ef2921292 |
      | Empty POC No              | POCNUM       | This field is required                                                                                                        | pocTel      | +65746                   | uid:0259c76c-91e5-44b3-91bf-a9f88bc5e3ab |
      | Invalid POC No            | !POCNUM      | That doesn't look like a phone number.                                                                                        | pocTel      | abc                      | uid:704e42eb-3920-4b1a-99fc-844e39a520e1 |
      | Empty Restrictions        | RESTRICTION  | This field is required                                                                                                        | restriction | abc                      | uid:40c4ce1e-e5ab-43ac-8cb0-e7c01ae83fcf |
      | Wrong Format Email        | POCMAIL      | That doesn't look like an email.                                                                                              | pocEmail    | @jlgkdg.c                | uid:0fe5eebf-b7b6-40cc-8d13-7b6576da02b9 |
      | Invalid Partner Name      | !NAME        | Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( ) | name        | Mir$@&(Aziz)             | uid:1d774855-bb82-4ae3-b78c-10b79370f98d |
      | Invalid POC Name          | !POCNME      | Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( ) | pocName     | Aziz~Ichwanul?{Ninjavan} | uid:59687fab-c590-4b89-b12b-216af809b507 |
      | Invalid Restrictions name | !RESTRICTION | Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( ) | restriction | {Alfa}<Express>          | uid:dddd6e43-3167-4205-8471-3100331f692a |
