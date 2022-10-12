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
      | pName             | audia &^$#,Point Name             |
      | sName             | audia &^$#,Short Name             |
      | city              | {Jakarta}<Selatan>,City           |
      | esId              | {Alfa}<Express>,External Store Id |
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
      | pName             | audia &^$#,Point Name             |
      | city              | {Jakarta}<Selatan>,City           |
      | esId              | {Alfa}<Express>,External Store Id |
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
  Scenario: Create new DP - Only add 1 alternative DP - Search DP by DP ID - save settings - success create DP - SG
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name              | shipperId                          | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User ALT1 | {alternate-dp-1-shipper-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    And Operator Set newly created dp for Alternate DP number "1"
    When Operator fill Detail for create DP Management:
      | name              | shipperId                          | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User ALT2 | {alternate-dp-2-shipper-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    And Operator Set newly created dp for Alternate DP number "2"
    When Operator fill Detail for create DP Management:
      | name              | shipperId                          | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test User ALT3 | {alternate-dp-3-shipper-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    And Operator Set newly created dp for Alternate DP number "3"
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

