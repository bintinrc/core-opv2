@DPUser2 @DpAdministrationV2 @DP @TH
Feature: DP Administration - Distribution Point Users

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    When API Operator whitelist email "{check-dp-user-email}"

  @DeleteDpPartner
  Scenario: DP Administrator - Create DP user - Restrict username and password to 100 char by copy and paste
    When Operator change the country to "Thailand"
    Given Operator generate prefix for dp creation
    Given API DP - Operator Create DP Partner:
      | dpPartner | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    And API DP - Operator Create DP:
      | dpPartnerId            | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]} |
      | dpSettingParameter     | {"name": "PA Appointment", "shipper_id": "{shipper-create-new-dp-management-legacy-id}", "contact": "+6626409984", "short_name": "DP{KEY_DP_GENERATED_PREFIX}", "external_store_id": "EX{KEY_DP_GENERATED_PREFIX}", "address_1": "{dp_address_1}", "address_2": "dp_address_2", "postal_code": "{dp_postal_code}", "city": "{dp_city}", "images": [], "unit_number": "1", "floor_number": "1", "hub_id": 1, "latitude": {dp-latitude}, "longitude": {dp-longitude}, "directions": null, "type": "SHOP", "dp_service_type": "{dp-service-type}", "computed_max_capacity": 10000, "max_parcel_stay_duration": 1, "actual_max_capacity": 1000000, "driver_collection_mode": "CONFIRMATION_CODE", "dps_to_redirect": [], "cutoff_hour": "23:59:59"} |
      | dpBooleanParameter     | {"auto_reservation_enabled": true, "is_ninja_warehouse": false, "is_public": true, "is_active": true, "allow_shipper_send": true, "allow_create_post": true, "can_customer_collect": true, "allow_create_pack": true, "allow_manual_pack_oc": true, "allow_customer_return": false, "allow_cod_service": false, "packs_sold_here": false, "allow_view_order_events_history": false, "is_hyperlocal": true}                                                                                                                                                                                                                                                                                                                                                             |
      | dpSettingOpeningHour   | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                   |
      | dpSettingOperatingHour | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                   |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    When Operator fill the partner filter by "id" with value "{KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]}"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id" with value "{KEY_DP_LIST_OF_DISTRIBUTION_POINT_ID[1]}"
    Then Operator press view DP User Button
    Then The Dp page is displayed
    And Operator press add user Button
    When Operator fill dp user username field with more than 100 characters by "COPY_PASTE"
    When Operator verify dp user username value trimmed to only 100 characters

  @DeleteDpPartner
  Scenario: DP Administrator - Create DP user - Restrict username and password to 100 char by manual key-in
    When Operator change the country to "Thailand"
    Given Operator generate prefix for dp creation
    Given API DP - Operator Create DP Partner:
      | dpPartner | { "name": "DP Users Test", "poc_name": "Diaz View User", "poc_tel": "DUSER00123","poc_email": "{default-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    And API DP - Operator Create DP:
      | dpPartnerId            | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]} |
      | dpSettingParameter     | {"name": "PA Appointment", "shipper_id": "{shipper-create-new-dp-management-legacy-id}", "contact": "+6626409984", "short_name": "DP{KEY_DP_GENERATED_PREFIX}", "external_store_id": "EX{KEY_DP_GENERATED_PREFIX}", "address_1": "{dp_address_1}", "address_2": "dp_address_2", "postal_code": "{dp_postal_code}", "city": "{dp_city}", "images": [], "unit_number": "1", "floor_number": "1", "hub_id": 1, "latitude": {dp-latitude}, "longitude": {dp-longitude}, "directions": null, "type": "SHOP", "dp_service_type": "{dp-service-type}", "computed_max_capacity": 10000, "max_parcel_stay_duration": 1, "actual_max_capacity": 1000000, "driver_collection_mode": "CONFIRMATION_CODE", "dps_to_redirect": [], "cutoff_hour": "23:59:59"} |
      | dpBooleanParameter     | {"auto_reservation_enabled": true, "is_ninja_warehouse": false, "is_public": true, "is_active": true, "allow_shipper_send": true, "allow_create_post": true, "can_customer_collect": true, "allow_create_pack": true, "allow_manual_pack_oc": true, "allow_customer_return": false, "allow_cod_service": false, "packs_sold_here": false, "allow_view_order_events_history": false, "is_hyperlocal": true}                                                                                                                                                                                                                                                                                                                                                             |
      | dpSettingOpeningHour   | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                   |
      | dpSettingOperatingHour | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                   |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    When Operator fill the partner filter by "id" with value "{KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]}"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id" with value "{KEY_DP_LIST_OF_DISTRIBUTION_POINT_ID[1]}"
    Then Operator press view DP User Button
    Then The Dp page is displayed
    And Operator press add user Button
    When Operator fill dp user username field with more than 100 characters by "MANUAL_KEY_IN"
    When Operator verify dp user username value trimmed to only 100 characters

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op