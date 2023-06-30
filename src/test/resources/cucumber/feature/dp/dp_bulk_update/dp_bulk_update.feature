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

  Scenario: Select DP IDs - Input duplicate Valid DP IDs
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given DB Operator gets 30 existed DP IDs
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "duplicate_valid" condition into the textbox
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
    Then Operator verifies error toast with "Invalid DP ID" message is shown


  Scenario: Select DP IDs - Bulk Update DP Information - Enable Customer Collect and Rest Settings are Blank (uid:7cb79661-d7be-4e51-94e8-83615bcb4893)
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
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "Max Capcaity" and "Buffer Capcaity"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Enable Customer Collect - Add Max Capacity Only (uid:b4392d86-1eea-41b5-81aa-fb737dd1de55)
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
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "Max Capcaity" and ""
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Enable Customer Collect - Add Buffer Only (uid:7dc60442-aec8-4c56-9657-9aae63ee4755)
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
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "" and "Buffer Capcaity"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Enable Customer Return and Rest Settings are Blank (uid:97113b26-0f6e-4e3b-910a-599b0246a2cf)
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
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Enable Customer Return" and "Max Capcaity" and "Buffer Capcaity"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Disable Shipper Send and Rest Settings are Blank (uid:a32de9f9-fd27-4e2b-85e4-90da5d0d6fe0)
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
    And Operator disables "shipper_send" of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Disable Shipper Send" and "" and ""
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Enable All Settings (uid:aeabaf37-bdeb-42f3-86a9-b33a8db69eeb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes all columns available for dp bulk update to 0 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables all settings of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies all dp details from bulk update are "Enabled"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Disable All Settings - Only Some DPs are Selected (uid:2016c2d9-9466-43e1-b0d0-5dc9428f321b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes all columns available for dp bulk update to 1 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator disables all settings of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies all dp details from bulk update are "Disabled"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Cancel, Clear Selection and All Settings are Empty (uid:675d653d-0d53-4567-ad00-6392402dd67e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes all columns available for dp bulk update to 1 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies all dp details from bulk update are "Enabled"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - Partial Success Updated - Download CSV (uid:7ee108b7-2831-4667-bc66-9cac8b9f668c)
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-bulk-update-id}"
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":true,"is_ninja_warehouse":false,"is_public": true,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given DB Operator changes all columns available for dp bulk update to 1 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "dp_delete_later" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator disables all settings of DP via DP Bulk Update Page
    And DB DP deletes the newly created DP in DP Creation Scenario
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "ERROR"
    When DB Operator verifies all dp details from bulk update are "Disabled"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |

  Scenario: Select DP IDs - Bulk Update DP Information - All Errors - Download CSV (uid:e34a0287-9a24-4981-b14f-f4a0a6d8c519)
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-bulk-update-id}"
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"SHOP","can_shipper_lodge_in":true,"can_customer_collect":true,"allow_customer_return": true,"allow_shipper_send": true,"packs_sold_here": true,"dp_service_type":"RETAIL_POINT_NETWORK","driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":true,"is_ninja_warehouse":false,"is_public": true,"floor_number": "1","unit_number": "1","actual_max_capacity": 65,"computed_max_capacity": 90,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "dp_delete_later_1" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator disables all settings of DP via DP Bulk Update Page
    And DB DP deletes the newly created DP in DP Creation Scenario
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "ERROR"
    When DB Operator verifies all dp details from bulk update are "Enabled"
      | dpId                                    |
      | deletedDp                               |

  Scenario: Select DP IDs - DP Pick - Bulk Update DP Information - Enable Customer Collect - Add Max Capacity Pick for XS (uid:bf8497dc-7cae-47b2-92a9-7618b42fc0c2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "pick_dp" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "can_customer_collect" of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "XS"
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "Max Capacity" and "Buffer Capacity"
      | dpId                                 |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
    And DB Operator verifies pick dp capacity from bulk update for "XS"
      | dpId                                 |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
      | {imda-pick-bulk-update-opv2-dp-1-id} |

  Scenario: Select DP IDs - DP Pick - Bulk Update DP Information - Disable Customer Collect - Add Max Capacity Pick for S (uid:a60b745e-58ca-480d-9303-dafee1516629)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "pick_dp" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator disables "can_customer_collect" of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "S"
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Disable Customer Collect" and "Max Capacity" and "Buffer Capacity"
      | dpId                                 |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
    And DB Operator verifies pick dp capacity from bulk update for "S"
      | dpId                                 |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
      | {imda-pick-bulk-update-opv2-dp-1-id} |

  Scenario: Select DP IDs - Normal DPs and Pick DPs - Bulk Update DP Information - Update All Settings and Add Max Capacity Pick (uid:f88f2e0a-6d93-4285-a4df-a9b8ede9dd6c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes all columns available for dp bulk update to 0 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables all settings of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 65 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 90 of DP via DP Bulk Update Page
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "XS"
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Bulk Update" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies all dp details from bulk update are "Enabled"
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
    And DB Operator verifies pick dp capacity from bulk update for "XS"
      | dpId                                 |
      | {imda-pick-bulk-update-opv2-dp-1-id} |

  Scenario: Select DP IDs - Set Public and download CSV (uid:417eb9a4-e7ee-4ea4-b40e-07d21d3e6e64)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes "is_public" to 0 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Set Public on Apply Action Drop Down
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies all dps are set public to 1
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Set Not Public and download CSV (uid:fdb16bb5-da1b-4d44-be5e-ffa30339aace)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes "is_public" to 1 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    When Operator clicks on Set Not Public on Apply Action Drop Down
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies all dps are set public to 0
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - Only Some Dps are Selected - Set Public and download CSV (uid:6ebf5636-1414-470b-8a76-346da6516ac5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes "is_public" to 0 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    And Operator clicks on first checkbox
    When Operator clicks on Set Public on Apply Action Drop Down
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies all dps are set public to 0
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
    When DB Operator verifies all dps are set public to 1
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  Scenario: Select DP IDs - DP Pick - Bulk Update DP Information - Enable Customer Collect - Add Max Capacity Pick for XL
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "pick_dp" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "can_customer_collect" of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 50 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 50 of DP via DP Bulk Update Page
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "XL"
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Load Failure" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "Max Capacity" and "Buffer Capacity"
      | dpId                                 |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
      | {imda-pick-bulk-update-opv2-dp-1-id} |

  Scenario: Select DP IDs - DP Pick - Bulk Update DP Information - Disable Customer Collect - Add Max Capacity Pick for L
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "pick_dp" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "can_customer_collect" of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 40 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 40 of DP via DP Bulk Update Page
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "L"
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Load Failure" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "Max Capacity" and "Buffer Capacity"
      | dpId                                 |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
      | {imda-pick-bulk-update-opv2-dp-1-id} |

  Scenario: Select DP IDs - DP Pick - Bulk Update DP Information - Enable Customer Collect - Add Max Capacity Pick for M
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "pick_dp" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "can_customer_collect" of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 25 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 25 of DP via DP Bulk Update Page
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "M"
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Load Failure" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "Max Capacity" and "Buffer Capacity"
      | dpId                                 |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
      | {imda-pick-bulk-update-opv2-dp-1-id} |

  Scenario: Select DP IDs - DP Pick - Bulk Update DP Information - Enable Customer Collect - Add Max Capacity Pick for All Sizes
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "pick_dp" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "can_customer_collect" of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 25 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 25 of DP via DP Bulk Update Page
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "M"
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Load Failure" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "Max Capacity" and "Buffer Capacity"
      | dpId                                 |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
      | {imda-pick-bulk-update-opv2-dp-1-id} |

  Scenario: Select DP IDs - DP Pick - Bulk Update DP Information - Enable Customer Collect - Add Max Capacity Pick for All Sizes
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "pick_dp" condition into the textbox
    When Operator clicks on Bulk Update on Apply Action Drop Down
    And Operator enables "can_customer_collect" of DP via DP Bulk Update Page
    And Operator edits the "Max Capacity" capacity to 25 of DP via DP Bulk Update Page
    And Operator edits the "buffer Capacity" capacity to 25 of DP via DP Bulk Update Page
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "M"
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "L"
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "XL"
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "S"
    And Operator edits the Max Capacity of pick DP via DP Bulk Update Page for "XS"
    Then Operator saves the updated settings via DP Bulk Update Page
    Then Operator verifies that the toast of "Load Failure" will be shown
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies dp details from bulk update for "Enable Customer Collect" and "Max Capacity" and "Buffer Capacity"
      | dpId                                 |
      | {imda-pick-bulk-update-opv2-dp-1-id} |
      | {imda-pick-bulk-update-opv2-dp-1-id} |

  Scenario: Select DP IDs - Only Some Dps are Selected - Set Not Public and download CSV
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Bulk Update
    Given DB Operator changes "is_public" to 1 for dps:
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |
    Then Operator verifies that the DP Bulk Update is loaded completely
    When Operator clicks on Select DP ID Button
    And Operator inputs DP with "same_partner_3_dps" condition into the textbox
    And Operator clicks on first checkbox
    When Operator clicks on Set Not Public on Apply Action Drop Down
    Then Operator download CSV for bulk update
    Then Operator verifies data is correct in downloaded csv file = "SUCCESS"
    When DB Operator verifies all dps are set public to 1
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-1-id} |
    When DB Operator verifies all dps are set public to 0
      | dpId                                    |
      | {same-partner-bulk-update-opv2-dp-2-id} |
      | {same-partner-bulk-update-opv2-dp-3-id} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op