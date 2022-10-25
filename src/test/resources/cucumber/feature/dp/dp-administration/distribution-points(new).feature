@OperatorV2 @DistributionPointsReactPage @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Point

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2,
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Validation check (uid:f701193b-2965-4ecf-8e56-0d854468f7dc)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    Then Operator check the form that all the checkbox element is exist base on the country setup
      | elements | RETAIL_POINT_NETWORK_ENABLED,FRANCHISEE_DISABLED,SEND_CHECK,PACK_CHECK,RETURN_CHECK,POST_DISABLED,CUSTOMER_COLLECT_CHECK,SELL_PACK_AT_POINT_CHECK |
    Then Operator press save setting button
    And Operator will get the error from some mandatory field
      | field | Point Name,Short Name,Contact Number,Postcode,City,Point Address 1,Floor No,Unit No,Latitude,Longitude,Pudo Point Type,Service Type,Maximum Parcel Capacity,Buffer Capacity |
    And Operator refresh page
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type      | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Box | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    And Operator will get the error from some field
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST  |
      | poCode            | abc,Postcode                      |
      | floorNo           | abc,Floor No                      |
      | unitNo            | abc,Unit No                       |
      | latitude          | abc,Latitude                      |
      | longitude         | abc,Longitude                     |
      | mcapacity         | abc,Maximum Parcel Capacity       |
      | bCapacity         | abc,Buffer Capacity               |
      | mpStay            | abc,Maximum Parcel Stay           |

  @DeleteNewlyCreatedDpManagementPartnerAndDp
  Scenario: Update DP - Validation check (uid:15a71188-4ee0-4713-8733-451b83eadebb)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name             | shipperId                                    | contact      | shortName         | externalStoreId   | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Creation Test | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpCheckManagement | onCheckManagement | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator will get the error from some field
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_RESPONSE |
      | poCode            | abc,Postcode                      |
      | floorNo           | abc,Floor No                      |
      | unitNo            | abc,Unit No                       |
      | latitude          | abc,Latitude                      |
      | longitude         | abc,Longitude                     |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: DP Administration - Create Distribution Point (DP) - Choose Ninja Point Type (uid:6f003723-fe55-4cdb-808c-92230ecba8eb)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP details from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    Then DB operator gets data from audit metadata
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
      | type      | CREATE                                      |
    And Operator Check the Data from created DP is Right
      | dp            | KEY_DP_DETAILS     |
      | auditMetadata | KEY_AUDIT_METADATA |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: DP Administration - Create Distribution Point (DP) - Choose Ninja Box Type (uid:9bb9265c-0513-4abe-88f8-cde661391231)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type      | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Box | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP details from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    Then DB operator gets data from audit metadata
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
      | type      | CREATE                                      |
    And Operator Check the Data from created DP is Right
      | dp            | KEY_DP_DETAILS     |
      | auditMetadata | KEY_AUDIT_METADATA |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: DP Administration - Search Distribution Point (uid:db71c7b5-bba0-4ccf-8b3a-da428fc596c2)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Point Test", "poc_name": "Diaz DP TEST", "poc_tel": "DIAZ00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | directions | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator Search with Some DP Details :
      | searchDetails | id,name,shortName,hub,address,direction,activity |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Input Address by Search via Lat Long (uid:c7c810d1-8163-45e6-aa1b-3c6aaf29a35e)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | latLongSearch     | latLongSearchName      | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {lat-long-search} | {lat-long-search-name} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP details from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dp        | KEY_DP_DETAILS                   |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_DP_SEARCH_LAT_LONG         |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Input Address by Search via Address Name (uid:5062a478-dc55-48d6-856c-13af6347497a)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | addressSearch    | addressSearchName     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {address-search} | {address-search-name} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP details from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dp        | KEY_DP_DETAILS                   |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_DP_SEARCH_ADDRESS          |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Select Opening and Operating Hours (uid:4a96bbeb-e290-42e0-86a6-67884e807b0d)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | false           | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP Opening Hours Data from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    When DB operator gets DP Operating Hours Data from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpOpeningHours   | KEY_DP_OPENING_HOUR_DETAILS      |
      | dpOperatingHours | KEY_DP_OPERATING_HOUR_DETAILS    |
      | dpDetails        | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition        | CHECK_DP_OPENING_OPERATING_HOURS |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Use Default Opening and Operating Hours (uid:2efad90b-eadd-4097-88fc-51102bf19cdd)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP Opening Hours Data from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    When DB operator gets DP Operating Hours Data from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpOpeningHours   | KEY_DP_OPENING_HOUR_DETAILS      |
      | dpOperatingHours | KEY_DP_OPERATING_HOUR_DETAILS    |
      | dpDetails        | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition        | CHECK_DP_OPENING_OPERATING_HOURS |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Add Multiple Opening and Operating Hours (uid:132479bb-9275-40ea-88a0-8344dfe99ebb)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay               |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | OPERATING_HOURS_EVERYDAY_DOUBLE |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP Opening Hours Data from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    When DB operator gets DP Operating Hours Data from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpOpeningHours   | KEY_DP_OPENING_HOUR_DETAILS      |
      | dpOperatingHours | KEY_DP_OPERATING_HOUR_DETAILS    |
      | dpDetails        | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition        | CHECK_DP_OPENING_OPERATING_HOURS |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Without Edit Days individually (uid:55e770ae-9bd9-4c78-99e0-20e88f9f1af3)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP Opening Hours Data from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    When DB operator gets DP Operating Hours Data from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpOpeningHours   | KEY_DP_OPENING_HOUR_DETAILS      |
      | dpOperatingHours | KEY_DP_OPERATING_HOUR_DETAILS    |
      | dpDetails        | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition        | CHECK_DP_OPENING_OPERATING_HOURS |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create new DP - Only add 1 alternative DP - Search DP by DP ID - save settings - success create DP - SG (uid:c2bfe629-af59-4677-9d57-fef685f51550)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | alternateDpId1      | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | {alternate-dp-id-1} | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create new DP - Only add 2 alternative DPs - search by DP name - save settings - success create DP - SG (uid:e23c05f6-8d5c-47e5-817a-1a68006c8a0d)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | alternateDpId1      | alternateDpId2      | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | {alternate-dp-id-1} | {alternate-dp-id-2} | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create new DP - add 3 alternative DPs - search by DP short name - save settings - success create DP - SG (uid:917227aa-a39d-4048-a07d-a22fcf78c778)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | alternateDpId1      | alternateDpId2      | alternateDpId3      | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create new DP - alternative DPs are empty - Save settings - success create DP - SG (uid:a1acb03d-7d92-4b05-af92-f0cca3908b0c)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create new DP - Add Pick! & 711 DP as alternative dp - Save Settings - success create DP - SG (uid:7f3b85d7-7518-47ed-936f-b1132221df4d)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | alternateDpId1          | alternateDpId2        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | {alternate-dp-pick!-dp} | {alternate-dp-711-dp} | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario Outline: Create New DP - check validation where alternative dp should be active and can customer collect enabled -  DP not found - SG - <dataset_name> (<hiptest-uid>)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator check disabled alternate DP form
      | alternateDp1 | ENABLED  |
      | alternateDp2 | DISABLED |
      | alternateDp3 | DISABLED |
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | alternateDpId1      | alternateDpId2      | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | {alternate-dp-id-1} | {alternate-dp-id-2} | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    And Operator fill the alternate DP details
      | alternateDp3     | <key_dataset> |
      | validationStatus | INVALID       |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

    Examples:
      | dataset_name                                | key_dataset                         | hiptest-uid                              |
      | inactive & can customer collect enabled DP  | {alternate-dp-inactive-cc-enabled}  | uid:b8e0adb5-ae00-4f84-9921-9e8700274579 |
      | inactive & can customer collect disabled DP | {alternate-dp-inactive-cc-disabled} | uid:b8718cf3-3f79-44c4-8daa-e1529056d6a0 |
      | active & can customer collect disabled DP   | {alternate-dp-active-cc-disabled}   | uid:10dc341f-8395-435e-9874-49df04e18497 |


  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create new DP - remove selected alternative dp - modal confirmation shown - click update button - SG (uid:6f22a1b4-a860-441e-ab76-b9db00c394fb)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | alternateDpId1      | alternateDpId2      | alternateDpId3      | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    When Operator press clear alternate DP number "2"
    Then Operator will get the popup message for alternate DP number "3"
    And Operator press update DP Alternate Button
    When Operator press clear alternate DP number "1"
    Then Operator will get the popup message for alternate DP number "2"
    And Operator press update DP Alternate Button
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create new DP - remove selected alternative dp - modal confirmation shown - click select another button - SG (uid:32b6dd2c-a5c9-4047-bdd0-34442ab35b2c)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | alternateDpId1      | alternateDpId2      | alternateDpId3      | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    When Operator press clear alternate DP number "2"
    Then Operator will get the popup message for alternate DP number "3"
    And Operator press Select Another DP Alternate Button
    And Operator fill the alternate DP details
      | alternateDp2     | {alternate-dp-id-2} |
      | validationStatus | VALID               |
    When Operator press clear alternate DP number "1"
    Then Operator will get the popup message for alternate DP number "2"
    And Operator press Select Another DP Alternate Button
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create new DP - input duplicate dp as alternative DP - save settings - SG (uid:2580ab62-f911-4993-a934-8531f39fcb31)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | alternateDpId1      | alternateDpId2      | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | {alternate-dp-id-1} | {alternate-dp-id-2} | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    And Operator fill the alternate DP details
      | alternateDp3     | {alternate-dp-id-2} |
      | validationStatus | INVALID             |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create new DP - Alternate DP field only shown on SG - SG (uid:f1c1d5e0-aa54-457a-bfed-207d19e991fc)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | alternateDpId1      | alternateDpId2      | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | {alternate-dp-id-1} | {alternate-dp-id-2} | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    And Operator fill the alternate DP details
      | alternateDp3     | {alternate-dp-from-indonesia} |
      | validationStatus | INVALID                       |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create new DP - remove selected alternative dp - modal confirmation shown - click cancel button - SG (uid:0348ec3a-a3e5-4001-978c-d2e0e3bde49f)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                           | shipperId                                    | contact      | shortName              | externalStoreId        | alternateDpId1      | alternateDpId2      | alternateDpId3      | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | editDaysIndividuallyOpeningHours | editDaysIndividuallyOperatingHours |
      | AUDIA-ANJANI_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | false                            | false                              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    When Operator press clear alternate DP number "1"
    Then Operator will get the popup message for alternate DP number "2"
    And Operator press cancel choose DP Alternate Button
    When Operator check disabled alternate DP form
      | alternateDp1 | ENABLED  |
      | alternateDp2 | DISABLED |
      | alternateDp3 | DISABLED |
    And Operator fill the alternate DP details
      | alternateDp1     | {alternate-dp-id-1} |
      | validationStatus | INVALID             |
    When Operator press clear alternate DP number "2"
    Then Operator will get the popup message for alternate DP number "3"
    And Operator press cancel choose DP Alternate Button
    When Operator check disabled alternate DP form
      | alternateDp1 | ENABLED  |
      | alternateDp2 | ENABLED  |
      | alternateDp3 | DISABLED |
    And Operator fill the alternate DP details
      | alternateDp2     | {alternate-dp-id-2} |
      | validationStatus | INVALID             |
    When Operator press clear alternate DP number "3"
    When Operator check disabled alternate DP form
      | alternateDp1 | ENABLED |
      | alternateDp2 | ENABLED |
      | alternateDp3 | ENABLED |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_ALTERNATE_DP_DATA          |
      | dpSetting | KEY_DP_SETTINGS                  |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Download CSV DPs
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
    When Operator click on the distribution points Download CSV File button
    When Operator get all DP params on DP Administration page
    Then Downloaded CSV file contains correct DP data

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Update Distribution Point - Ninja Point
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
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
            | contact      |  unitNumber | floorNumber |  directions                                                |  address_1      | address_2                  |  postalCode       | type        |
            | {dp-contact}  | 1          | 1           |  Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360       |  1 JELEBU ROAD  | BUKIT PANJANG PLAZA, #01-32 |  467360          |  Ninja Box  |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP details from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dp        | KEY_DP_DETAILS                   |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_DP_SEARCH_LAT_LONG         |


  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - Update Distribution Point - Ninja Point
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type       | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Box  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | contact      |  unitNumber | floorNumber |  directions                                                |  address_1      | address_2                  |  postalCode       | type          |
      | {dp-contact}  | 1          | 1           |  Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360       |  1 JELEBU ROAD  | BUKIT PANJANG PLAZA, #01-32 |  467360          |  Ninja Point  |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP details from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dp        | KEY_DP_DETAILS                   |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_DP_SEARCH_LAT_LONG         |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: Edit Existing DP with Auto-reservation Enabled and Cutoff Time
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type       | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Box  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | contact      |  unitNumber | floorNumber |  directions                                                |  address_1      | address_2                   |  postalCode       | type          | cutOffTime       |
      | {dp-contact}  | 1          | 1           |  Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360       |  1 JELEBU ROAD  | BUKIT PANJANG PLAZA, #01-32 |  467360          |  Ninja Point  | 19 h 00 m         |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP details from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dp        | KEY_DP_DETAILS                   |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_DP_SEARCH_LAT_LONG         |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: Update Existing DP - External Store ID is Unique - Success Update
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type       | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Box  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | contact      |  unitNumber | floorNumber |  directions                                                |  address_1      | address_2                   |  postalCode       | type            | externalStoreId |
      | {dp-contact}  | 1          | 1           |  Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360       |  1 JELEBU ROAD  | BUKIT PANJANG PLAZA, #01-32 |  467360          |  Ninja Point     | GENERATED       |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP details from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dp        | KEY_DP_DETAILS                   |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_DP_SEARCH_LAT_LONG         |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: Update Existing DP - External Store ID is Duplicate - Error Message Displayed
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type       | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Box  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | contact      |  unitNumber | floorNumber |  directions                                                |  address_1      | address_2                   |  postalCode       | type            | externalStoreId |
      | {dp-contact}  | 1          | 1           |  Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360       |  1 JELEBU ROAD  | BUKIT PANJANG PLAZA, #01-32 |  467360          |  Ninja Point     | TESTING-NewDP   |
    Then Operator will get the error from some field
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_RESPONSE |
      | externalStoreId   | external_store_id TESTING-NewDP   |


  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: Update Existing DP - External Store ID is NULL - Success Update (uid:8067639b-8ceb-4b72-94ec-831afb3a1938)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    And API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    When Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | contact      |  unitNumber | floorNumber |  directions                                                |  address_1      | address_2                  |  postalCode       | type          |
      | {dp-contact}  | 1          | 1           |  Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360       |  1 JELEBU ROAD  | BUKIT PANJANG PLAZA, #01-32 |  467360          |  Ninja Point  |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP details from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dp        | KEY_DP_DETAILS                   |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_DP_SEARCH_LAT_LONG         |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: Update Existing DP - External Store ID is Space only - Success Update
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    And API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    When Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | contact      |  unitNumber | floorNumber |  directions                                                |  address_1      | address_2                  |  postalCode       | type          |
      | {dp-contact}  | 1          | 1           |  Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360       |  1 JELEBU ROAD  | BUKIT PANJANG PLAZA, #01-32 |  467360          |  Ninja Point  |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets DP details from Hibernate
      | dpId | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dp        | KEY_DP_DETAILS                   |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | condition | CHECK_DP_SEARCH_LAT_LONG         |

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: Edit Existing DP - Auto Reservation to Disabled
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type       | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Box  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | contact      |  unitNumber | floorNumber |  directions                                                |  address_1      | address_2                   |  postalCode       | type          | isAutoReservation |
      | {dp-contact}  | 1          | 1           |  Home-Fix at Bedok Mall, #B2-17/18, Singapore 467360       |  1 JELEBU ROAD  | BUKIT PANJANG PLAZA, #01-32 |  467360          |  Ninja Point  | false              |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator verifies that the cut off time for "KEY_CREATE_DP_MANAGEMENT_REQUEST" is "23:59:59"

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: Edit Existing DP - Upload DP Photos - Right Dimensions
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    And API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    When Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | contact       |  dpPhoto   |
      | {dp-contact}  | valid      |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    And Operator press save setting button
    And Operator waits for 5 seconds
    And Operator verifies the image for "KEY_CREATE_DP_MANAGEMENT_REQUEST" is "present"

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: Edit Existing DPs - Update DP Photo - Wrong Dimensions
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    And API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    When Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id"
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | contact       |  dpPhoto     |
      | {dp-contact}  | invalid      |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    And Operator press save setting button
    And Operator waits for 5 seconds
    Then Operator verifies the image for "KEY_CREATE_DP_MANAGEMENT_REQUEST" is "not valid"

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Edit Existing DPs - Delete DP Photo without Save
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name                     | shipperId                                    | contact      | shortName              | externalStoreId        | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type        | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | dpPhoto  |
      | HUSSAM_NINJA_123 TESTING | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | AUDIA-ANJANI_NINJA_123 | Mirza.Aziz-Ninjavan09_ | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | Ninja Point | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 15 h 30 m  | true                   | valid    |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator verifies the image for "KEY_CREATE_DP_MANAGEMENT_REQUEST" is "present"
    When Operator fill Detail for create DP Management:
      | contact       |  dpPhoto     |
      | {dp-contact}  |  clear       |
    When Operator press return to list button
    Then Operator verifies the image for "KEY_CREATE_DP_MANAGEMENT_REQUEST" is "present"




