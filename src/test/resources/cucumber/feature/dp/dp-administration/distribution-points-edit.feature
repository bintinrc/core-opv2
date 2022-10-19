@OperatorV2 @DistributionPointsEditReactPage @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Point Edit

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2,
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Edit existing DP - Add 3 alternative DPs - Save settings - SG (uid:c3350858-d3bb-46fd-bde0-6b3e4d34989d)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | alternateDpId1      | alternateDpId2      | alternateDpId3      |
      | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} |
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
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    Then Operator check the alternate DP is shown in DP Edit page
      | dpList    | ADP1,ADP2,ADP3                   |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Edit existing DP - Only add 2 alternative DPs - Save settings - Success - SG (uid:8a0b4f8b-7ae1-4569-a4f3-2d2cb904dfc0)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | alternateDpId1      | alternateDpId2      |
      | {alternate-dp-id-1} | {alternate-dp-id-2} |
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
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    Then Operator check the alternate DP is shown in DP Edit page
      | dpList    | ADP1,ADP2                        |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Edit existing DP - Add Pick! & 711 DP - Save settings - SG (uid:886783f2-c3b9-43f3-8720-2ee80906f4ee)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | alternateDpId1          | alternateDpId2        |
      | {alternate-dp-pick!-dp} | {alternate-dp-711-dp} |
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
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    Then Operator check the alternate DP is shown in DP Edit page
      | dpList    | ADP1,ADP2                        |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Edit existing DP - Only add 1 alternative DPs - Save settings - Success - SG (uid:b18381a0-36a3-447e-aa33-62eb593b69f6)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator fill Detail for create DP Management:
      | alternateDpId1      |
      | {alternate-dp-id-1} |
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
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    Then Operator check the alternate DP is shown in DP Edit page
      | dpList    | ADP1                             |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Edit existing DP - Alternative DPs empty - Save settings - Success - SG (uid:e073c908-e8ed-4055-bc91-e824fb54d17a)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
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
  Scenario: Edit existing DP - Inactive alternative dp - DP not shown on list - SG (uid:77eb62a5-7949-4de0-a61f-14999c9957d0)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    And Operator fill the alternate DP details
      | alternateDp1     | {alternate-dp-inactive-cc-enabled} |
      | validationStatus | INVALID                            |
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
  Scenario: Edit existing DP - Alternative dp with can_customer_collect = false - Not eligible - SG (uid:35496c26-b1ca-4a6f-a5b7-d8321aa08a37)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    And Operator fill the alternate DP details
      | alternateDp1     | {alternate-dp-active-cc-disabled} |
      | validationStatus | INVALID                           |
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
  Scenario: Edit existing DP - Existing dp with alternate dps - Edit alternate dps as inactive and can_customer_collect = false - DP not shown - SG (uid:dfcb00eb-4849-4404-879c-8ed3eecd163c)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    And Operator fill the alternate DP details
      | alternateDp1     | {alternate-dp-inactive-cc-disabled} |
      | validationStatus | INVALID                             |
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
  Scenario: Edit existing DP - Existing dp with alternate dps - Remove alternate dp 1 - Save settings - SG (uid:03cbb524-151e-4a81-abbe-7f12b29eac96)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | alternateDpId1      | alternateDpId2      | alternateDpId3      | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator press clear alternate DP number "2"
    Then Operator will get the popup message for alternate DP number "3"
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
  Scenario: Edit existing DP - Alternate DP field only shown on SG - ID (uid:d00274dc-14f2-457e-938a-e92ff38825d5)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    And Operator fill the alternate DP details
      | alternateDp1     | {alternate-dp-from-indonesia} |
      | validationStatus | INVALID                       |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Edit existing DP - Search dp from another country - SG (uid:b5dbbf20-8ddd-4a3d-bec7-ee58264fd5ea)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    And Operator fill the alternate DP details
      | alternateDp1     | {alternate-dp-from-indonesia} |
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
  Scenario: Edit existing DP - Modal confirmation - Click Select another button - SG (uid:d9f48677-1d10-448a-a6b3-8bb082316ac3)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | alternateDpId1      | alternateDpId2      | alternateDpId3      | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
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
  Scenario: Edit existing DP - Modal confirmation - Click Update button - SG (uid:ccb90db6-00f4-4eac-b856-a071454efc53)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | alternateDpId1      | alternateDpId2      | alternateDpId3      | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
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
  Scenario: Edit DP - Input duplicate dp as alternative DP - Save settings - Failed create DP - SG (uid:eabc4cd9-8dcf-439a-a1f8-bf7a5643f402)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | alternateDpId1      | alternateDpId2      | alternateDpId3      | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator press clear alternate DP number "3"
    And Operator fill the alternate DP details
      | alternateDp3     | {alternate-dp-id-2} |
      | validationStatus | INVALID             |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator will receiving error message pop-up "duplicate"

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Edit existing DP - Modal confirmation - Click select another button - keep 2nd column empty - SG (uid:1473c949-11d6-46c4-9475-15194f3ae501)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | alternateDpId1      | alternateDpId2      | alternateDpId3      | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator press clear alternate DP number "2"
    Then Operator will get the popup message for alternate DP number "3"
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
  Scenario: Edit existing DP - Given 2nd column empty from add dp page - SG (uid:26922c3d-108d-45d2-b98b-829acf9ab4c9)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | alternateDpId1      | alternateDpId2      | alternateDpId3      | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator press clear alternate DP number "2"
    Then Operator will get the popup message for alternate DP number "3"
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
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator refresh page
    And Operator waits for 5 seconds
    Then Operator check the alternate DP is shown in DP Edit page
      | dpList    | ADP1,ADP2                        |
      | dpDetails | KEY_CREATE_DP_MANAGEMENT_REQUEST |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Edit existing DP - Alternative dp same Main dp - Save settings - Failed to update (uid:0842831f-d39a-4b67-9d1f-b0502f43b7d0)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | true               | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    And Operator fill the alternate DP details
      | alternateDp1     | KEY_CREATE_DP_MANAGEMENT_RESPONSE_ID |
      | validationStatus | VALID                                |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator will receiving error message pop-up "Dp to redirect cannot be same as the original Dp"

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Edit existing DP - remove selected alternative dp - modal confirmation shown - click cancel button - SG (uid:4cf16f15-20ce-4094-9d52-d7d3df8f5e2f)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-partners-dp-edit-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | alternateDpId1      | alternateDpId2      | alternateDpId3      | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Test Edit | {shipper-create-new-dp-management-legacy-id} | {alternate-dp-id-1} | {alternate-dp-id-2} | {alternate-dp-id-3} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP Management
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press edit DP button
    And The Create and Edit Dp page is displayed
    And Operator waits for 5 seconds
    When Operator press clear alternate DP number "1"
    Then Operator will get the popup message for alternate DP number "2"
    And Operator press cancel choose DP Alternate Button
    When Operator check disabled alternate DP form
      | alternateDp1 | ENABLED  |
      | alternateDp2 | DISABLED |
      | alternateDp3 | DISABLED |
    And Operator fill the alternate DP details
      | alternateDp1     | {alternate-dp-id-1} |
      | validationStatus | VALID               |
    When Operator press clear alternate DP number "2"
    Then Operator will get the popup message for alternate DP number "3"
    And Operator press cancel choose DP Alternate Button
    When Operator check disabled alternate DP form
      | alternateDp1 | ENABLED  |
      | alternateDp2 | ENABLED  |
      | alternateDp3 | DISABLED |
    And Operator fill the alternate DP details
      | alternateDp2     | {alternate-dp-id-2} |
      | validationStatus | VALID               |
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