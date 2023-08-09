@OperatorV2 @Dp @CIF @CreateCifUser
Feature: DP Administration - Distribution Point Users

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedDpManagementPartnerAndDp
  Scenario Outline: DP Administration - Create DP User - Validation check - CIF Login - Feature Flag ON - <dataset_name>
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press view DP User Button
    Then The Dp page is displayed
    And Operator press add user Button
    And Operator define the DP Partner value "<input>" for key "<key_dataset>"
    Then Operator Fill Dp User Details to Check The Error Status with key "<key_dataset>"
    And Operator will check the error message is equal "<error_message>"

    Examples:
      | dataset_name                                   | key_dataset | error_message                                                                      | input       |
      | First Name Cannot Blank                        | USFIRNME    | This field is required                                                             | abc         |
      | Last Name Cannot Blank                         | USLANME     | This field is required                                                             | abc         |
      | First Name Non English Char                    | INFIRNME    | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | 임지연         |
      | Last Name Non English Char                     | INLANME     | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | 임지연         |
      | First Name With Other than underscode and dash | INFIRNME    | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | di%sP0      |
      | Last Name With Other than underscode and dash  | INLANME     | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | di%sP0      |
      | First Name With Space                          | INFIRNME    | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | Diaz Ilyasa |
      | Last Name With Space                           | INLANME     | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | Diaz Ilyasa |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario Outline: DP Administration - Update DP User - Validation check - CIF Login - Feature Flag ON - <dataset_name>
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name             | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Creation Test | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Then Operator fill Detail for create DP Management User:
      | firstName | lastName | contactNo    | email                   | username  | password |
      | Diaz      | Ilyasa   | {dp-contact} | {default-dp-user-email} | GENERATED | password |
    And API Operator request to create DP Management User:
      | dpPartner | KEY_DP_MANAGEMENT_PARTNER             |
      | dp        | KEY_CREATE_DP_MANAGEMENT_RESPONSE     |
      | dpUser    | KEY_CREATE_DP_MANAGEMENT_USER_REQUEST |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press view DP User Button
    Then The Dp page is displayed
    Then Operator press edit user Button
    And Operator define the DP Partner value "<input>" for key "<key_dataset>"
    Then Operator Fill Dp User Details to Check The Error Status with key "<key_dataset>"
    And Operator will check the error message is equal "<error_message>"

    Examples:
      | dataset_name                                   | key_dataset | error_message                                                                      | input       |
      | First Name Cannot Blank                        | USFIRNME    | This field is required                                                             | abc         |
      | Last Name Cannot Blank                         | USLANME     | This field is required                                                             | abc         |
      | First Name Non English Char                    | INFIRNME    | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | 임지연         |
      | Last Name Non English Char                     | INLANME     | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | 임지연         |
      | First Name With Other than underscode and dash | INFIRNME    | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | di%sP0      |
      | Last Name With Other than underscode and dash  | INLANME     | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | di%sP0      |
      | First Name With Space                          | INFIRNME    | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | Diaz Ilyasa |
      | Last Name With Space                           | INLANME     | Invalid name. Only English characters, hypens (-) and underscores (_) are allowed. | Diaz Ilyasa |

