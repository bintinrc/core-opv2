@OperatorV2 @DistributionPointDeleteEndpoint
Feature: Distribution Point - Delete Dp

  @DeleteNewlyCreatedDpPartner @DeleteNewlyCreatedDpManagementPartner
  Scenario: dp administrations - authorized scope - delete dp - active dp without pending reservations - Success Delete
    Given API Operator create new DP partner using data below:
      | createDpPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP:
      | name            | shipperId                         | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Only Testing | {shipper-create-new-dp-legacy-id} | {dp-contact} | DpOnTest  | onTesting21     | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 2                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    When Operator fill Detail for create DP Management:
      | name            | shipperId                                    | contact      | shortName          | externalStoreId       | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Only Testing | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpOnTestManagement | onTesting21Management | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP
    Then API Operator request to create DP Management
    And API Operator Delete newly created DP
    And API Operator Delete newly created DP Management
    When DB Operator get DP Data by DP ID
    When DB Operator get DP Management Data by DP ID
    Then Operator need to compare both of delete result after "Delete DP" and make sure both of the data is valid

  @DeleteNewlyCreatedDpPartner @DeleteNewlyCreatedDpManagementPartner @CompleteDpReservations @ForceSuccessReservationByApi @ForceSuccessOrder
  Scenario: dp administrations - authorized scope - delete dp - active dp with pending reservations - SG
    Given API Operator create new DP partner using data below:
      | createDpPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP:
      | name            | shipperId                         | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Only Testing | {shipper-create-new-dp-legacy-id} | {dp-contact} | DpOnTest  | onTesting21     | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 2                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    When Operator fill Detail for create DP Management:
      | name            | shipperId                                    | contact      | shortName          | externalStoreId       | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Only Testing | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpOnTestManagement | onTesting21Management | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP
    Then DB Operator update DP into enable collect
    Then API Operator request to create DP Management
    Then DB Operator update DP Management into enable collect
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-create-new-dp-client-id}                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-create-new-dp-client-secret}                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator Setting DP Drop Off from order by DP
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-create-new-dp-management-client-id}                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-create-new-dp-management-client-secret}                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator Setting the DP Drop Off from order by DP Management
    And API Operator Delete newly created DP
    And API Operator Delete newly created DP Management
    When DB Operator get DP Data by DP ID
    When DB Operator get DP Management Data by DP ID
    Then Operator need to compare both of delete result after "Delete DP" and make sure both of the data is valid

  @DeleteNewlyCreatedDpPartner @DeleteNewlyCreatedDpManagementPartner
  Scenario: dp administrations - authorized scope - delete dp - inactive dp - SG
    Given API Operator create new DP partner using data below:
      | createDpPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP:
      | name            | shipperId                         | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Only Testing | {shipper-create-new-dp-legacy-id} | {dp-contact} | DpOnTest  | onTesting21     | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 2                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    When Operator fill Detail for create DP Management:
      | name            | shipperId                                    | contact      | shortName          | externalStoreId       | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Only Testing | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpOnTestManagement | onTesting21Management | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP
    And DB Operator update DP to Inactive
    Then API Operator request to create DP Management
    And DB Operator update DP Management to Inactive
    And API Operator Delete newly created DP
    And API Operator Delete newly created DP Management
    When DB Operator get DP Data by DP ID
    When DB Operator get DP Management Data by DP ID
    Then Operator need to compare both of delete result after "Delete DP" and make sure both of the data is valid

  @DeleteNewlyCreatedDpPartnerAndDp @DeleteNewlyCreatedDpManagementPartnerAndDp
  Scenario: dp administrations - authorized scope - delete dp - Invalid DP ID - Failed Delete - SG
    Given API Operator create new DP partner using data below:
      | createDpPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP:
      | name            | shipperId                         | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Only Testing | {shipper-create-new-dp-legacy-id} | {dp-contact} | DpOnTest  | onTesting21     | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 2                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    When Operator fill Detail for create DP Management:
      | name            | shipperId                                    | contact      | shortName          | externalStoreId       | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Only Testing | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpOnTestManagement | onTesting21Management | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP
    Then API Operator request to create DP Management
    And API Operator Delete newly created DP with invalid "DP"
    And API Operator Delete newly created DP Management with invalid "DP"
    When DB Operator get DP Data by DP ID
    When DB Operator get DP Management Data by DP ID
    Then Operator need to compare both of delete result after "Invalid Delete DP" and make sure both of the data is valid

  @DeleteNewlyCreatedDpPartnerAndDp @DeleteNewlyCreatedDpManagementPartnerAndDp
  Scenario: dp administrations - authorized scope - delete dp - Invalid partner ID - Failed Delete - SG
    Given API Operator create new DP partner using data below:
      | createDpPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "DP Partner Automation", "poc_name": "Diaz Ilyasa", "poc_tel": "DIAZ00123","poc_email": "diaz.ilyasa@ninjavan.co","restrictions": "Only For Testing","send_notifications_to_customer": false } |
    When Operator fill Detail for create DP:
      | name            | shipperId                         | contact      | shortName | externalStoreId | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Only Testing | {shipper-create-new-dp-legacy-id} | {dp-contact} | DpOnTest  | onTesting21     | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 2                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    When Operator fill Detail for create DP Management:
      | name            | shipperId                                    | contact      | shortName          | externalStoreId       | unitNumber | floorNumber | latitude      | longitude      | directions | isNinjaWarehouse | dpServiceType     | address_1      | address_2      | city      | postalCode       | type | hubId | maxParcelStayDuration | actualMaxCapacity | computedMaxCapacity | isActive | isPublic | allowShipperSend | allowCreatePost | canCustomerCollect | allowCreatePack | allowManualPackOc | allowCustomerReturn | allowCodService | allowViewOrderEventsHistory | packsSoldHere | isHyperlocal | driverCollectionMode | cutoffHour | autoReservationEnabled |
      | Dp Only Testing | {shipper-create-new-dp-management-legacy-id} | {dp-contact} | DpOnTestManagement | onTesting21Management | 1          | 1           | {dp-latitude} | {dp-longitude} | null       | false            | {dp-service-type} | {dp_address_1} | {dp_address_2} | {dp_city} | {dp_postal_code} | BOX  | 1     | 1                     | 1000000           | 10000               | true     | true     | true             | true            | false              | true            | false             | false               | false           | true                        | false         | true         | CONFIRMATION_CODE    | 23:59:59   | true                   |
    Then API Operator request to create DP
    Then API Operator request to create DP Management
    And API Operator Delete newly created DP with invalid "DP Partner"
    And API Operator Delete newly created DP Management with invalid "DP Partner"
    When DB Operator get DP Data by DP ID
    When DB Operator get DP Management Data by DP ID
    Then Operator need to compare both of delete result after "Invalid Delete DP" and make sure both of the data is valid