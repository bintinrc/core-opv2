@OperatorV2 @DistributionPoints2ReactPage @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Point

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2,
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Select Opening and Operating Hours - Apply first day slots to all days
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-create-dp-2-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | type      | address_1      | address_2      | city      | postalCode       | hubId | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                                        | applyFirstDayOpeningHours | applyFirstDayOperatingHours |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | directions | false            | {dp-service-type} | Ninja Box | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | 1     | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | true            | true             | monday,tuesday,wednesday,thursday,friday,saturday,sunday | true                      | true                        |
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
  Scenario: Create DP - Select Opening and Operating Hours - Apply first day slots to all days
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-create-dp-2-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | type      | address_1      | address_2      | city      | postalCode       | hubId | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | autoReservationCutOffTime |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | directions | false            | {dp-service-type} | Ninja Box | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | 1     | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | 18:00                     |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails  | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | dpSettings | KEY_DP_SETTINGS                  |
      | condition  | CHECK_DP_RESERVATION_DATA        |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Auto-reservation Enabled - Remove and Manually type the pickup cut off time
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-create-dp-2-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | type      | address_1      | address_2      | city      | postalCode       | hubId | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | autoReservationCutOffTime |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | directions | false            | {dp-service-type} | Ninja Box | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | 1     | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | 19:30                     |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    And Operator get the value of DP ID
    When DB operator gets all details from DP Settings From Hibernate
      | parameter | dpId                                        |
      | value     | {KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID} |
    And Operator Check the Data from created DP is Right
      | dpDetails  | KEY_CREATE_DP_MANAGEMENT_REQUEST |
      | dpSettings | KEY_DP_SETTINGS                  |
      | condition  | CHECK_DP_RESERVATION_DATA        |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario Outline: Create DP - Clear the opening or operating timeslot - Return error - <dataset_name>(<hiptest-uid>)
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-create-dp-2-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | type      | address_1      | address_2      | city      | postalCode       | hubId | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | autoReservationCutOffTime | cutOffDay                                         |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | directions | false            | {dp-service-type} | Ninja Box | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | 1     | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | 19:30                     | tuesday,wednesday,thursday,friday,saturday,sunday |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator delete the opening and operating hours "<key_dataset>"
    Then Operator press save setting button
    And Operator waits for 5 seconds
    Then Operator will receiving error message pop-up "Invalid date"

    Examples:
      | dataset_name           | key_dataset     | hiptest-uid |
      | Remove Opening Hours   | opening_hours   |             |
      | Remove Operating Hours | operating_hours |             |

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Select Opening Hours - Apply opening hours for operating hours
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-create-dp-2-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | type      | address_1      | address_2      | city      | postalCode       | hubId | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | isTimestampSame | isOperatingHours | operatingHoursDay                    | applyFirstDayOpeningHours | applyFirstDayOperatingHours |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | directions | false            | {dp-service-type} | Ninja Box | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | 1     | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | false           | true             | everydayOpeningOperating!10:15!18:00 | true                      | true                        |
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
  Scenario: Create DP - Remove all opening and operating timeslots - Return error
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-create-dp-2-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id"
    And Operator press view DP Button
    Then The Dp page is displayed
    Then Operator press Add DP
    And The Create and Edit Dp page is displayed
    When Operator fill Detail for create DP Management:
      | name         | shipperId                                    | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | type      | address_1      | address_2      | city      | postalCode       | hubId | hubName   | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled | autoReservationCutOffTime | cutOffDay                                                |
      | Dp Test User | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | GENERATED | GENERATED       | 1          | 1           | {dp-latitude} | {dp-longitude} | directions | false            | {dp-service-type} | Ninja Box | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | 1     | {sbm-hub} | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   | 19:30                     | monday,tuesday,wednesday,thursday,friday,saturday,sunday |
    Then Operator fill the DP details
      | distributionPoint | KEY_CREATE_DP_MANAGEMENT_REQUEST |
    Then Operator press save setting button
    And Operator waits for 5 seconds
    Then Operator will receiving error message pop-up "Missing opening/operating hours for DP"