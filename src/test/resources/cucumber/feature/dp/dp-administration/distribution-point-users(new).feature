@OperatorV2 @DpAdministration @DistributionPointUsersReact @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Point Users

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedDpManagementPartnerAndDp @SoftDeleteDpUser
  Scenario: DP Administration - Create DP User (uid:0146137a-6964-4985-a417-7bbd6035e5b7)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "duserview@ninjavan.co","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName              | externalStoreId       | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpOnUserTestManagement | onTesting21Management | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration (New)
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
      | firstName | lastName | contactNo | emailId   | username                                | password |
      | Diaz      | Ilyasa   | GENERATED | GENERATED | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | password |
    Then Operator press submit user button
    And Operator fill the Dp User filter by "username"
    When DB Operator gets details for newly created dp users from Hibernate
    And Operator verifies the newly created DP user data is right

  @DeleteNewlyCreatedDpManagementPartnerAndDp
  Scenario: DP Administration - Create DP User - Username is duplicate (uid:4b65c669-4fc4-44b1-9205-2ea7b44cf247)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "duserview@ninjavan.co","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName              | externalStoreId       | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpOnUserTestManagement | onTesting21Management | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration (New)
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
      | firstName | lastName | contactNo | emailId   | username        | password |
      | Diaz      | Ilyasa   | GENERATED | GENERATED | {dp-user-exist} | password |
    Then Operator press submit user button
    And Operator will get the error message that the username is duplicate

  @DeleteNewlyCreatedDpManagementPartnerAndDp
  Scenario: DP Administration - Create DP User - Validation check (uid:fca3060c-a44a-4893-8b0d-b542fb18e644)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "duserview@ninjavan.co","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName              | externalStoreId       | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpOnUserTestManagement | onTesting21Management | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration (New)
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
      | firstName   | lastName | contactNo | emailId   | username                                | password |
      | ERROR_CHECK | Ilyasa   | GENERATED | GENERATED | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | password |

  @DeleteNewlyCreatedDpManagementPartnerAndDp @SoftDeleteDpUser
  Scenario: DP Administration - Download CSV DP Users (uid:11060b54-7a1d-4122-9ceb-7f693c1bf154)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "duserview@ninjavan.co","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName             | externalStoreId       | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpUserCheckManagement | onUserCheckManagement | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Then Operator fill Detail for create DP Management User:
      | firstName | lastName | contactNo    | email            | username                                | password |
      | Diaz      | Ilyasa   | {dp-contact} | tested@email.com | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | password |
    And API Operator request to create DP Management User:
      | dpPartner | KEY_DP_MANAGEMENT_PARTNER             |
      | dp        | KEY_CREATE_DP_MANAGEMENT_RESPONSE     |
      | dpUser    | KEY_CREATE_DP_MANAGEMENT_USER_REQUEST |
    Given Operator go to menu Distribution Points -> DP Administration (New)
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

  @DeleteNewlyCreatedDpManagementPartnerAndDp @SoftDeleteDpUser
  Scenario: DP Administration - Search DP User (uid:f254face-546e-410c-90dd-b23780cb40e2)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "duserview@ninjavan.co","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName             | externalStoreId       | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpUserCheckManagement | onUserCheckManagement | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Then Operator fill Detail for create DP Management User:
      | firstName | lastName | contactNo    | email            | username                                | password |
      | Diaz      | Ilyasa   | {dp-contact} | tested@email.com | AUTO{gradle-next-0-day-yyyyMMddHHmmsss} | password |
    And API Operator request to create DP Management User:
      | dpPartner | KEY_DP_MANAGEMENT_PARTNER             |
      | dp        | KEY_CREATE_DP_MANAGEMENT_RESPONSE     |
      | dpUser    | KEY_CREATE_DP_MANAGEMENT_USER_REQUEST |
    Given Operator go to menu Distribution Points -> DP Administration (New)
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