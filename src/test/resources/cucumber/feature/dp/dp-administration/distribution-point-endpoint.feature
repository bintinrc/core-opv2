@OperatorV2 @DistributionPointUpdateEndpoint
Feature: Distribution Point - Endpoint

  @DeleteDpPartnerV2
  Scenario: DP Administration - Attempting to create user for DP from another partner - dp management service endpoint
    Given Operator generate 11 prefix
    Given Operator generate 7 random phone number
    Given API DP - Operator Create DP Partner:
      | dpPartner | { "name": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[1]}", "poc_name": "Diaz{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[2]}", "poc_tel": "DUSER00123","poc_email": "{default-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    And API DP - Operator Create DP:
      | dpPartnerId            | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | dpSettingParameter     | {"name": "New DP {KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[3]}", "shipper_id": "{shipper-create-new-dp-management-legacy-id}", "contact": "+65{KEY_LIST_OF_OPERATOR_GENERATE_PHONE_NUMBER[1]}", "short_name": "DP{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[4]}", "external_store_id": "EX{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[5]}", "address_1": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[6]}", "address_2": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[7]}", "postal_code": "{dp_postal_code}", "city": "{dp_city}", "images": [], "unit_number": "1", "floor_number": "1", "hub_id": 1, "latitude": {dp-latitude}, "longitude": {dp-longitude}, "directions": null, "type": "SHOP", "dp_service_type": "{dp-service-type}", "computed_max_capacity": 10000, "max_parcel_stay_duration": 1, "actual_max_capacity": 1000000, "driver_collection_mode": "CONFIRMATION_CODE", "dps_to_redirect": [], "cutoff_hour": "23:59:59"} |
      | dpBooleanParameter     | {"auto_reservation_enabled": true, "is_ninja_warehouse": false, "is_public": true, "is_active": true, "allow_shipper_send": true, "allow_create_post": true, "can_customer_collect": true, "allow_create_pack": true, "allow_manual_pack_oc": true, "allow_customer_return": false, "allow_cod_service": false, "packs_sold_here": false, "allow_view_order_events_history": false, "is_hyperlocal": true}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | dpSettingOpeningHour   | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                                                                                                                                                             |
      | dpSettingOperatingHour | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                                                                                                                                                             |
    Given API DP Management - Operator Create DP Users:
      | partnerId | 999993402                                                                                                                           |
      | dpId      | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_ID[1]}                                                                                           |
      | request   | {"first_name":"Diaz","last_name":"Ilyasa","email":"diaz@gmail.com","contact_no": "{KEY_LIST_OF_OPERATOR_GENERATE_PHONE_NUMBER[1]}"} |
      | isSuccess | false                                                                                                                               |

  @DeleteDpPartnerV2
  Scenario: DP Administration - Creating user for valid partner and DP from a different country - dp management service endpoint
    Given Operator generate 11 prefix
    Given Operator generate 7 random phone number
    Given API DP - Operator Create DP Partner:
      | dpPartner | { "name": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[1]}", "poc_name": "Diaz{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[2]}", "poc_tel": "DUSER00123","poc_email": "{default-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    And API DP - Operator Create DP:
      | dpPartnerId            | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | dpSettingParameter     | {"name": "New DP {KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[3]}", "shipper_id": "{shipper-create-new-dp-management-legacy-id}", "contact": "+65{KEY_LIST_OF_OPERATOR_GENERATE_PHONE_NUMBER[1]}", "short_name": "DP{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[4]}", "external_store_id": "EX{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[5]}", "address_1": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[6]}", "address_2": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[7]}", "postal_code": "{dp_postal_code}", "city": "{dp_city}", "images": [], "unit_number": "1", "floor_number": "1", "hub_id": 1, "latitude": {dp-latitude}, "longitude": {dp-longitude}, "directions": null, "type": "SHOP", "dp_service_type": "{dp-service-type}", "computed_max_capacity": 10000, "max_parcel_stay_duration": 1, "actual_max_capacity": 1000000, "driver_collection_mode": "CONFIRMATION_CODE", "dps_to_redirect": [], "cutoff_hour": "23:59:59"} |
      | dpBooleanParameter     | {"auto_reservation_enabled": true, "is_ninja_warehouse": false, "is_public": true, "is_active": true, "allow_shipper_send": true, "allow_create_post": true, "can_customer_collect": true, "allow_create_pack": true, "allow_manual_pack_oc": true, "allow_customer_return": false, "allow_cod_service": false, "packs_sold_here": false, "allow_view_order_events_history": false, "is_hyperlocal": true}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | dpSettingOpeningHour   | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                                                                                                                                                             |
      | dpSettingOperatingHour | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                                                                                                                                                             |
    Given API DP Management - Operator Create DP Users:
      | partnerId | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]}                                                                                   |
      | dpId      | 999993402                                                                                                                           |
      | request   | {"first_name":"Diaz","last_name":"Ilyasa","email":"diaz@gmail.com","contact_no": "{KEY_LIST_OF_OPERATOR_GENERATE_PHONE_NUMBER[1]}"} |
      | isSuccess | false                                                                                                                               |

  @DeleteDpPartnerV2
  Scenario: DP Administration - Invalid fields in request - Password is empty string  - dp management service endpoint
    Given Operator generate 8 prefix
    Given Operator generate 7 random phone number
    Given API DP - Operator Create DP Partner:
      | dpPartner | { "name": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[1]}", "poc_name": "Diaz{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[2]}", "poc_tel": "DUSER00123","poc_email": "{default-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    And API DP - Operator Create DP:
      | dpPartnerId            | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | dpSettingParameter     | {"name": "New DP {KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[3]}", "shipper_id": "{shipper-create-new-dp-management-legacy-id}", "contact": "+65{KEY_LIST_OF_OPERATOR_GENERATE_PHONE_NUMBER[1]}", "short_name": "DP{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[4]}", "external_store_id": "EX{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[5]}", "address_1": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[6]}", "address_2": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[7]}", "postal_code": "{dp_postal_code}", "city": "{dp_city}", "images": [], "unit_number": "1", "floor_number": "1", "hub_id": 1, "latitude": {dp-latitude}, "longitude": {dp-longitude}, "directions": null, "type": "SHOP", "dp_service_type": "{dp-service-type}", "computed_max_capacity": 10000, "max_parcel_stay_duration": 1, "actual_max_capacity": 1000000, "driver_collection_mode": "CONFIRMATION_CODE", "dps_to_redirect": [], "cutoff_hour": "23:59:59"} |
      | dpBooleanParameter     | {"auto_reservation_enabled": true, "is_ninja_warehouse": false, "is_public": true, "is_active": true, "allow_shipper_send": true, "allow_create_post": true, "can_customer_collect": true, "allow_create_pack": true, "allow_manual_pack_oc": true, "allow_customer_return": false, "allow_cod_service": false, "packs_sold_here": false, "allow_view_order_events_history": false, "is_hyperlocal": true}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | dpSettingOpeningHour   | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                                                                                                                                                             |
      | dpSettingOperatingHour | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                                                                                                                                                             |
    Given API DP Management - Operator Create DP Users:
      | partnerId | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]}                                                                                                                                                           |
      | dpId      | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_ID[1]}                                                                                                                                                                   |
      | request   | {"first_name":"Diaz","last_name":"Ilyasa","email":"diaz@gmail.com","contact_no": "{KEY_LIST_OF_OPERATOR_GENERATE_PHONE_NUMBER[1]}", "username": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[8]}", "password":""} |
      | isSuccess | false                                                                                                                                                                                                       |

  @DeleteDpPartnerV2 @DeleteDpUser
  Scenario: DP Administration - Invalid fields in request - Username already exists  - dp management service endpoint
    Given Operator generate 9 prefix
    Given Operator generate 7 random phone number
    Given API DP - Operator Create DP Partner:
      | dpPartner | { "name": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[1]}", "poc_name": "Diaz{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[2]}", "poc_tel": "DUSER00123","poc_email": "{default-dp-user-email}","restrictions": "Test View DP","send_notifications_to_customer": false } |
    And API DP - Operator Create DP:
      | dpPartnerId            | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | dpSettingParameter     | {"name": "New DP {KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[3]}", "shipper_id": "{shipper-create-new-dp-management-legacy-id}", "contact": "+65{KEY_LIST_OF_OPERATOR_GENERATE_PHONE_NUMBER[1]}", "short_name": "DP{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[4]}", "external_store_id": "EX{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[5]}", "address_1": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[6]}", "address_2": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[7]}", "postal_code": "{dp_postal_code}", "city": "{dp_city}", "images": [], "unit_number": "1", "floor_number": "1", "hub_id": 1, "latitude": {dp-latitude}, "longitude": {dp-longitude}, "directions": null, "type": "SHOP", "dp_service_type": "{dp-service-type}", "computed_max_capacity": 10000, "max_parcel_stay_duration": 1, "actual_max_capacity": 1000000, "driver_collection_mode": "CONFIRMATION_CODE", "dps_to_redirect": [], "cutoff_hour": "23:59:59"} |
      | dpBooleanParameter     | {"auto_reservation_enabled": true, "is_ninja_warehouse": false, "is_public": true, "is_active": true, "allow_shipper_send": true, "allow_create_post": true, "can_customer_collect": true, "allow_create_pack": true, "allow_manual_pack_oc": true, "allow_customer_return": false, "allow_cod_service": false, "packs_sold_here": false, "allow_view_order_events_history": false, "is_hyperlocal": true}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | dpSettingOpeningHour   | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                                                                                                                                                             |
      | dpSettingOperatingHour | {"sunday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "saturday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "tuesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "friday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "thursday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "wednesday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ], "monday": [ { "start_time": "08:00:00", "end_time": "21:00:00" } ]}                                                                                                                                                                                                                                                                                                                                                                                                             |
    Given API DP Management - Operator Create DP Users:
      | partnerId | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]}                                                                                                                                                                                                    |
      | dpId      | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_ID[1]}                                                                                                                                                                                                            |
      | request   | {"first_name":"Diaz","last_name":"Ilyasa","email":"diaz@gmail.com","contact_no": "{KEY_LIST_OF_OPERATOR_GENERATE_PHONE_NUMBER[1]}", "username": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[8]}", "password":"{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[9]}"} |
      | isSuccess | true                                                                                                                                                                                                                                                 |
    Given API DP Management - Operator Create DP Users:
      | partnerId | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_PARTNER_ID[1]}                                                                                                                                                                                                    |
      | dpId      | {KEY_DP_LIST_OF_DISTRIBUTION_POINT_ID[1]}                                                                                                                                                                                                            |
      | request   | {"first_name":"Diaz","last_name":"Ilyasa","email":"diaz@gmail.com","contact_no": "{KEY_LIST_OF_OPERATOR_GENERATE_PHONE_NUMBER[1]}", "username": "{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[8]}", "password":"{KEY_LIST_OF_OPERATOR_GENERATE_PREFIX[9]}"} |
      | isSuccess | false                                                                                                                                                                                                                                                |