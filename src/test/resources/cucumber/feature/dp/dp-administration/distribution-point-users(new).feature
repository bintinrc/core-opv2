@OperatorV2 @DpAdministration @DistributionPointUsersReact @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Point Users

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Create DP User (uid:0146137a-6964-4985-a417-7bbd6035e5b7)
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
    When Operator Fill Dp User Details below :
      | firstName | lastName | contactNo | emailId                 | username  | password |
      | Diaz      | Ilyasa   | GENERATED | {default-dp-user-email} | GENERATED | password |
    Then Operator press submit user button
    And Operator fill the Dp User filter by "username"
    When DB Operator gets details for DP User from Hibernate
      | username | {KEY_DP_USER_USERNAME} |
    And Operator verifies the newly created DP user data is right
      | dpUser   | KEY_DP_USER          |
      | dpUserDb | KEY_DATABASE_DP_USER |

  @DeleteNewlyCreatedDpManagementPartnerAndDp
  Scenario: DP Administration - Create DP User - Username is duplicate (uid:4b65c669-4fc4-44b1-9205-2ea7b44cf247)
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
    When Operator Fill Dp User Details below :
      | firstName | lastName | contactNo | emailId                 | username        | password |
      | Diaz      | Ilyasa   | GENERATED | {default-dp-user-email} | {dp-user-exist} | password |
    Then Operator press submit user button
    And Operator will get the error message that the username is duplicate

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Download CSV DP Users (uid:11060b54-7a1d-4122-9ceb-7f693c1bf154)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Then Operator fill Detail for create DP Management User:
      | firstName | lastName | contactNo    | email                   | username                                    | password |
      | Diaz      | Ilyasa   | {dp-contact} | {default-dp-user-email} | USERNAME{gradle-next-0-day-yyyyMMddHHmmsss} | password |
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
    And API Operator get DP Management partner list
    Then API Operator get DP Management User list:
      | dpPartner | KEY_DP_MANAGEMENT_PARTNER         |
      | dp        | KEY_CREATE_DP_MANAGEMENT_RESPONSE |
    When Operator click on Download CSV File button on React page
    When Operator get DP Users Data on DP Administration page
      | dpUsers | KEY_DP_MANAGEMENT_USER_LIST |
      | count   | 1                           |
    Then Downloaded CSV file contains correct DP Users data in new react page
      | userList | DP_USER_LIST                      |
      | dp       | KEY_CREATE_DP_MANAGEMENT_RESPONSE |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Search DP User (uid:f254face-546e-410c-90dd-b23780cb40e2)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
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
    And Operator Search with Some DP User Details :
      | dpUser        | KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE    |
      | searchDetails | username,firstName,lastName,email,contact |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario Outline: DP Administration - Update DP User - Validation check - <dataset_name> (<hiptest-uid>)
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
    When Operator Fill Dp User Details below :
      | firstName | lastName | contactNo | emailId                 | username  | password |
      | Diaz      | Ilyasa   | GENERATED | {default-dp-user-email} | GENERATED | password |
    Then Operator press submit user button
    And Operator fill the Dp User filter by "username"
    When DB Operator gets details for DP User from Hibernate
      | username | {KEY_DP_USER_USERNAME} |
    And Operator verifies the newly created DP user data is right
      | dpUser   | KEY_DP_USER          |
      | dpUserDb | KEY_DATABASE_DP_USER |
    Then Operator press edit user Button
    And Operator define the DP Partner value "<input>" for key "<key_dataset>"
    Then Operator Fill Dp User Details to Check The Error Status with key "<key_dataset>"
    And Operator will check the error message is equal "<error_message>"

    Examples:
      | dataset_name  | key_dataset | error_message                    | input           | hiptest-uid                              |
      | Invalid Email | !USEMAIL    | That doesn't look like an email. | {Alfa}<Express> | uid:2fb74862-2dff-4649-a3af-375ec9010c3a |

  @DeleteNewlyCreatedDpManagementPartnerAndDp
  Scenario Outline: DP Administration - Create DP User - Validation check - <dataset_name> (<hiptest-uid>)
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
      | dataset_name              | key_dataset | error_message                          | input         | hiptest-uid                              |
      | First Name Cannot Blank   | USFIRNME    | This field is required                 | abc           | uid:6909dc6a-5160-4f1d-a12e-1e3aa57a714a |
      | Last Name Cannot Blank    | USLANME     | This field is required                 | abc           | uid:563dfb85-0095-4122-b741-40a770daf227 |
      | Phone Number Cannot Blank | CONTACT     | This field is required                 | 123456789     | uid:bd5b7849-e28d-4c76-93e1-ef9e2d1e4024 |
      | Phone Number Invalid      | !CONTACT    | That doesn't look like a phone number. | abc           | uid:8381ec58-8022-4a20-8b67-4ab3229cc623 |
      | Email Cannot Blank        | USEMAIL     | This field is required                 | abc@email.com | uid:bcbfff6e-168e-4792-9aee-93952306f55b |
      | Email Invalid             | !USEMAIL    | That doesn't look like an email.       | abc           | uid:542423be-8a8b-4935-8da1-c98173c5ca49 |
      | Username Cannot Blank     | USNME       | This field is required                 | username      | uid:98d53c06-e9ee-4407-8214-e493a7cdc0f7 |
      | Password Cannot Blank     | PWORD       | This field is required                 | password      | uid:cad7abaa-bfe6-4456-887d-64403a7f2495 |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Update DP user (uid:cfa0f458-4373-4927-b411-a653e5b9dc10)
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
    When Operator Fill Dp User Details below :
      | firstName | lastName | contactNo | emailId                 |
      | Diaz      | Edited   | GENERATED | {default-dp-user-email} |
    Then Operator press submit edit user button
    And Operator waits for 5 seconds
    When DB Operator gets details for DP User from Hibernate
      | username | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE.username} |
    And Operator verifies the newly created DP user data is right
      | dpUser   | KEY_DP_USER          |
      | dpUserDb | KEY_DATABASE_DP_USER |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Update DP User - Reset Password Successfully (uid:c969e718-4404-4652-8c04-06decadf38ea)
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
    And Operator press reset password button
    And Operator fill the password changes
      | password        | miniso123 |
      | confirmPassword | miniso123 |
    Then Operator press save reset password button
    And Operator waits for 5 seconds

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Update DP User - Reset Password Failed (uid:494cd400-a0b9-4142-acab-e777741756ac)
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
    And Operator press reset password button
    And Operator fill the password changes
      | password        | miniso123 |
      | confirmPassword | daiso123  |
    Then Operator will get the error message "Password does not match!"

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Update DP User - Reset Password - Back to User Edit (uid:30502542-9542-4cde-890f-10770a7ff62e)
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
    And Operator press reset password button
    And Operator press back to user edit button
    Then The Edit Dp User popup is Displayed

  @DeleteNewlyCreatedDpManagementPartnerAndDp
  Scenario: DP Administration - Delete Dp User (uid:15116d9e-9569-44b4-b970-4884355f9195)
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
    When Operator Fill Dp User Details below :
      | firstName | lastName | contactNo | emailId                 | username                                | password |
      | Diaz      | Ilyasa   | GENERATED | {default-dp-user-email} | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | password |
    Then Operator press submit user button
    And Operator fill the Dp User filter by "username"
    When DB Operator gets details for DP User from Hibernate
      | username | {KEY_DP_USER_USERNAME} |
    And Operator verifies the newly created DP user data is right
      | dpUser   | KEY_DP_USER          |
      | dpUserDb | KEY_DATABASE_DP_USER |
    And API Operator request to delete DP User:
      | dpPartner | {KEY_DP_MANAGEMENT_PARTNER.id}         |
      | dp        | {KEY_CREATE_DP_MANAGEMENT_RESPONSE.id} |
      | dpUser    | {KEY_DATABASE_DP_USER.id}              |
    When DB Operator gets details for DP User from Hibernate
      | username | {KEY_DP_USER_USERNAME} |
    And Operator verifies the newly created DP user data is deleted
      | dpUser   | KEY_DP_USER          |
      | dpUserDb | KEY_DATABASE_DP_USER |
      | status   | SUCCESS              |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Delete Dp User - Wrong DP (uid:ef25d5d3-d575-4128-af02-5e56cc7cd46e)
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
    When Operator Fill Dp User Details below :
      | firstName | lastName | contactNo | emailId                 | username                                | password |
      | Diaz      | Ilyasa   | GENERATED | {default-dp-user-email} | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | password |
    Then Operator press submit user button
    And Operator waits for 2 seconds
    And Operator refresh page
    Then The Dp page is displayed
    And Operator waits for 3 seconds
    And Operator fill the Dp User filter by "username"
    When DB Operator gets details for DP User from Hibernate
      | username | {KEY_DP_USER_USERNAME} |
    And Operator verifies the newly created DP user data is right
      | dpUser   | KEY_DP_USER          |
      | dpUserDb | KEY_DATABASE_DP_USER |
    And API Operator request to delete DP User:
      | dpPartner | {KEY_DP_MANAGEMENT_PARTNER.id} |
      | dp        | {wrong-dp-id}                  |
      | dpUser    | {KEY_DATABASE_DP_USER.id}      |
    When DB Operator gets details for DP User from Hibernate
      | username | {KEY_DP_USER_USERNAME} |
    And Operator verifies the newly created DP user data is deleted
      | dpUser   | KEY_DP_USER          |
      | dpUserDb | KEY_DATABASE_DP_USER |
      | status   | FAILED               |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Delete Dp User - Wrong DP Partner (uid:16a7cf1b-6778-48de-b69e-7ef163edc71c)
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
    When Operator Fill Dp User Details below :
      | firstName | lastName | contactNo | emailId                 | username                                | password |
      | Diaz      | Ilyasa   | GENERATED | {default-dp-user-email} | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | password |
    Then Operator press submit user button
    And Operator waits for 2 seconds
    And Operator refresh page
    Then The Dp page is displayed
    And Operator waits for 3 seconds
    And Operator fill the Dp User filter by "username"
    When DB Operator gets details for DP User from Hibernate
      | username | {KEY_DP_USER_USERNAME} |
    And Operator verifies the newly created DP user data is right
      | dpUser   | KEY_DP_USER          |
      | dpUserDb | KEY_DATABASE_DP_USER |
    And API Operator request to delete DP User:
      | dpPartner | {wrong-dp-partner}                     |
      | dp        | {KEY_CREATE_DP_MANAGEMENT_RESPONSE.id} |
      | dpUser    | {KEY_DATABASE_DP_USER.id}              |
    When DB Operator gets details for DP User from Hibernate
      | username | {KEY_DP_USER_USERNAME} |
    And Operator verifies the newly created DP user data is deleted
      | dpUser   | KEY_DP_USER          |
      | dpUserDb | KEY_DATABASE_DP_USER |
      | status   | FAILED               |
