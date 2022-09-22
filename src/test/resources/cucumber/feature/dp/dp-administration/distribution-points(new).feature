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

    And Operator will get the error from some field
      | field | Point Name,Short Name,City,External Store Id,Postcode,Floor No,Unit No,Latitude,Longitude,Maximum Parcel Capacity,Buffer Capacity,Maximum Parcel Stay |
