@OperatorV2 @DpAdministration @DistributionPointUsers @OperatorV2Part1 @DpAdministrationV2 @DP
Feature: DP Administration - Distribution Point Users

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HardDeleteDp
  Scenario: DP Administration - Create DP User (uid:0146137a-6964-4985-a417-7bbd6035e5b7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    When Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName    | Han       |
      | lastName     | Solo      |
      | contactNo    | GENERATED |
      | emailId      | GENERATED |
      | clientId     | GENERATED |
      | clientSecret | p@ssw0rd  |
    Then Operator verify new DP User params
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: DP Administration - Update DP user (uid:cfa0f458-4373-4927-b411-a653e5b9dc10)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    And Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName    | Han       |
      | lastName     | Solo      |
      | contactNo    | GENERATED |
      | emailId      | GENERATED |
      | clientId     | GENERATED |
      | clientSecret | p@ssw0rd  |
    When Operator update created DP User for the created DP on DP Administration page with the following attributes:
      | firstName | Jabba     |
      | lastName  | Hutt      |
      | contactNo | GENERATED |
      | emailId   | GENERATED |
    Then Operator verify new DP User params
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: DP Administration - Download CSV DP Users (uid:11060b54-7a1d-4122-9ceb-7f693c1bf154)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    And Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName    | Han       |
      | lastName     | Solo      |
      | contactNo    | GENERATED |
      | emailId      | GENERATED |
      | clientId     | GENERATED |
      | clientSecret | p@ssw0rd  |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    And Operator select View Users action for created DP on DP Administration page
    When Operator get all DP Users params on DP Administration page
    And Operator click on Download CSV File button on DP Administration page
    Then Downloaded CSV file contains correct DP Users data
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: DP Administration - Update DP User - Reset Password Failed (uid:494cd400-a0b9-4142-acab-e777741756ac)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","shipper_id":"129623","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    And Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName    | Han       |
      | lastName     | Solo      |
      | contactNo    | GENERATED |
      | emailId      | GENERATED |
      | clientId     | GENERATED |
      | clientSecret | p@ssw0rd  |
    When Operator Reset password "unsuccessfully"
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: DP Administration - Update DP User - Reset Password - Back to User Edit (uid:30502542-9542-4cde-890f-10770a7ff62e)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","shipper_id":"129623","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    And Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName    | Han       |
      | lastName     | Solo      |
      | contactNo    | GENERATED |
      | emailId      | GENERATED |
      | clientId     | GENERATED |
      | clientSecret | p@ssw0rd  |
    When Operator Reset password "none"
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @HardDeleteDp
  Scenario: DP Administration - Update DP User - Reset Password Successfully (uid:c969e718-4404-4652-8c04-06decadf38ea)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"
    Given Operator convert the Partner to DP Partner Modal
    Given API Operator add new DP for the created DP Partner with the following attributes:
      | requestBody | {"hub_id":null,"type":"BOX","can_shipper_lodge_in":true,"can_customer_collect":true,"driver_collection_mode":"CONFIRMATION_CODE","max_parcel_stay_duration":2,"name":"DP-{{unique_string}}","short_name":"{{unique_string}}","shipper_id":"129623","address_1":"1 JELEBU ROAD","address_2":"BUKIT PANJANG PLAZA, #01-32","city":"SG","postal_code":"677743","latitude": "1.372098","longitude": "103.909417","directions":"Home-Fix at Bukit Panjang Plaza, #01-32, Singapore 677743","contact":"{{generated_phone_no}}","is_active":false,"is_ninja_warehouse":false,"is_public": false,"floor_number": "1","unit_number": "1","actual_max_capacity": 2,"computed_max_capacity": 1,"opening_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]},"operating_hours":{"monday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"tuesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"wednesday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"thursday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"friday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"saturday":[{"start_time":"08:00:00","end_time":"21:00:00"}],"sunday":[{"start_time":"08:00:00","end_time":"21:00:00"}]}} |
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator select View DPs action for created DP partner on DP Administration page
    And Operator add DP User for the created DP on DP Administration page with the following attributes:
      | firstName    | Han       |
      | lastName     | Solo      |
      | contactNo    | GENERATED |
      | emailId      | GENERATED |
      | clientId     | GENERATED |
      | clientSecret | p@ssw0rd  |
    When Operator Reset password "successfully"
    Given Open Ninja Point V3 Web Page
    When User Login with username and new password
    Then Ninja Point V3 Welcome Page displayed
    And API DP gets DP Partner Details for Partner ID "{opv2-dp-partner-id}"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op