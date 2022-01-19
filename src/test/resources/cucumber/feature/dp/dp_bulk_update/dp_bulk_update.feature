@OperatorV2 @DpBulkUpdate @DpAdministrationV2 @DP
Feature: DP Administration - DP Bulk Update

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedDp
  Scenario: Select DP IDs - Input Valid DP IDs from Different DP Partners (uid:58c8b4c0-52da-4e52-a303-f3c9e6303b5a)
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-bulk-update-id}"
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":true,"is_ninja_warehouse":false,"is_public": true,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "valid_different_partner" condition into the textbox
    Then Operator verifies the data shown in DP Bulk Update Page is correct

  @DeleteNewlyCreatedDp
  Scenario: Select DP IDs - Input Valid DP IDs from Same DP Partner (uid:78f7aca4-ed70-4b84-a0a3-54a14d9a2737)
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-bulk-update-id}"
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":true,"is_ninja_warehouse":false,"is_public": true,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "valid_same_partner" condition into the textbox
    Then Operator verifies the data shown in DP Bulk Update Page is correct

  @DeleteNewlyCreatedDp
  Scenario: Select DP IDs - Input Valid DP IDs - Some DPs are Inactive (uid:5e485f67-21c9-459d-a390-bf10347a0104)
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-bulk-update-id}"
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":true,"is_ninja_warehouse":false,"is_public": true,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "valid_inactive" condition into the textbox
    Then Operator verifies the data shown in DP Bulk Update Page is correct

  @DeleteNewlyCreatedDp
  Scenario: Select DP IDs - Input Valid DP IDs - Edit DP via Edit Action (uid:09d4073a-3fe2-460d-84ed-881395c19e4b)
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-bulk-update-id}"
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":true,"is_ninja_warehouse":false,"is_public": true,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "valid_same_partner" condition into the textbox
    Then Operator verifies the data shown in DP Bulk Update Page is correct
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator edits the capacity of DP via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator verifies the data shown in DP Bulk Update Page is correct

  Scenario: Select DP IDs - Input Invalid DP IDs (uid:706c180a-cc82-4c3c-8629-878f55223ef7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "invalid" condition into the textbox
    Then Operator verifies that the toast of "Load Failure" will be shown

  Scenario: Select DP IDs - Input more than 30 Invalid DP IDs (uid:3d3a6149-be9b-4b88-8c3a-1fc68af27e46)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given DB Operator gets 30 existed DP IDs
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "more_than_30" condition into the textbox
    Then Operator verifies the data shown in DP Bulk Update Page is correct

  @DeleteNewlyCreatedDp
  Scenario: Select DP IDs - Input Valid and Invalid DP IDs (uid:f311f1a9-812d-4828-bdb1-d067d9e33882)
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-bulk-update-id}"
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":true,"is_ninja_warehouse":false,"is_public": true,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "valid_invalid" condition into the textbox
    Then Operator verifies the data shown in DP Bulk Update Page is correct

  @DeleteNewlyCreatedDp
  Scenario: Select DP IDs - Input Alphabetics/Special Characters on DP IDs Modal (uid:0da85d08-66bf-4cb9-b643-2ecae5f1481f)
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-bulk-update-id}"
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":true,"is_ninja_warehouse":false,"is_public": true,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "special_char" condition into the textbox

  Scenario: Select DP IDs - Input Blank DP IDs (uid:f33bbe45-237a-4535-a02b-517a43a8633a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "blank" condition into the textbox
    Then Operator verifies error toast with invalid error message is shown

  Scenario: Select DP IDs - Bulk Update DP Information - Enable Customer Collect and Rest Settings are Blank
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes "can_customer_collect" to 0 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "can_customer_collect" of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "Max Capcaity" and "Buffer Capcaity"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Enable Customer Collect - Add Max Capacity Only
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes "can_customer_collect" to 0 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "can_customer_collect" of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "Max Capcaity" and ""
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Enable Customer Collect - Add Buffer Only
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes "can_customer_collect" to 0 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "can_customer_collect" of DP via DP Bulk Update Page
    And Operator edits the "Buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "" and "Buffer Capcaity"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Enable Customer Return and Rest Settings are Blank
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes "allow_customer_return" to 0 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "allow_customer_return" of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file
    When DB Operator verifies dp details from bulk update for "Enable Customer Return" and "Max Capcaity" and "Buffer Capcaity"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Disable Shipper Send and Rest Settings are Blank
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes "allow_shipper_send" to 1 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "disable_shipper_send" of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file
    When DB Operator verifies dp details from bulk update for "Disable Shipper Send" and "" and ""
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
