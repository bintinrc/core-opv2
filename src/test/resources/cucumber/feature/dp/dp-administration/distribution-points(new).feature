@OperatorV2 @DistributionPointsReactPage @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Point

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2,
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedDpManagementPartner
  Scenario: Create DP - Validation check
    Given API Operator create new DP Management partner using data below:
      | createDpManagementPartnerRequest | { "name": "Create Dp Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "duserview@ninjavan.co","restrictions": "Test View DP","send_notifications_to_customer": false } |
    Given Operator go to menu Distribution Points -> DP Administration (New)
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

