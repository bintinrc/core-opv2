Feature: Shipper Pickups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Find Created Reservation by Shipper Name (uid:d8f5c2ca-1c9b-401d-8125-b6b91989f090)
  @binti
    Given Reservation "belongs to certain Shipper"
    And UI_LOAD_SHIPPER_PICKUP_PAGE "false" "true" "a Shipper "
    And Verify that "Reservation result showing only reservations belongs to those Shipper"
    And Verify that "'Shipper Name & Contact' & 'Shipper Id'  columns are correct"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Assign a Pending Reservation to a Driver Route (uid:040e08e7-97f9-4085-94e9-e52db7f32edc)
  @binti
    Given Shipper creates a reservation
    And Operator creates a driver route
    When UI_LOAD_SHIPPER_PICKUP_PAGE "true" "false" "Reservation Type : Normal "
    When Operator type in "New Route"
    And Operator clicks "'Save Changes'" button
    Then Verify that "route is updated" successfully
    And VERIFY_ADD_TO_ROUTE "Routed" "false" "false"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Filters Created Reservation by Master Shipper (uid:5020c570-4f72-4ba2-bc26-8de5560eca89)
  @binti
    Given Shipper creates "a Marketplace Order under a Marketplace Seller" with "Pickup required = true (use the following request & use a Marketplace Shipper)"
      """
      {
          "service_type": "Marketplace",
          "service_level": "Standard",
          "from": {
              "name": "binti v4.1",
              "phone_number": "+65189189",
              "email": "binti@test.co",
              "address": {
                  "address1": "Orchard Road central",
                  "address2": "",
                  "country": "SG",
                  "postcode": "511200",
                  "latitude": 1.3248209,
                  "longitude": 103.6983167
              }
          },
          "to": {
              "name": "George Ezra",
              "phone_number": "+65189178",
              "email": "ezra@g.ent",
              "address": {
                  "address1": "999 Toa Payoh North",
                  "address2": "",
                  "country": "SG",
                  "postcode": "318993"
              }
          },
          "parcel_job": {
              "experimental_from_international": false,
              "experimental_to_international": false,
              "cash_on_delivery": null,
              "is_pickup_required": true,
              "pickup_date": "{{pickup_date}}",
              "pickup_service_type": "Scheduled",
              "pickup_service_level": "Standard",
              "pickup_timeslot": {
                  "start_time": "09:00",
                  "end_time": "12:00",
                  "timezone": "Asia/Singapore"
              },
              "pickup_address_id": "add08",
              "pickup_instruction": "Please be careful with the v-day flowers.",
              "delivery_start_date": "{{delivery_start_date}}",
              "delivery_timeslot": {
                  "start_time": "09:00",
                  "end_time": "22:00",
                  "timezone": "Asia/Singapore"
              },
              "delivery_instruction": "Please be careful with the v-day flowers.",
              "dimensions": {
                  "weight": 5
              }
          },
          "marketplace": {
              "seller_id": "seller-ABCnew01",
              "seller_company_name": "ABC Shop"
          }
      }
      """
    And UI_LOAD_SHIPPER_PICKUP_PAGE "false" "true" "Master Shipper"
    And Verify that "filtered reservation belongs to correct shipper id & shipper name & contact"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Edits Priority Level on Bulk Action - Multiple Reservations (uid:2641d40f-f8f5-4dae-86bb-c64cd36c1ca0)
  @binti
    Given Shipper creates multiple reservations
    And UI_LOAD_SHIPPER_PICKUP_PAGE "false" "false" "Reservation Type : Normal "
    When Operator clicks on checkbox for selected "reservation" from the list
    And Operator clicks "'Apply Action'" button
    And Operator clicks "'Edit Priority Level'" button
    Then Verify that "'Bulk Priority Edit'" modal is shown
    When Operator type in "priority level value for all Reservations list"
    And Operator clicks "'Save Changes'" button
    Then Verify that "Priority Level for all reservations are updated" successfully
    And Verify that "'Priority Level' column has correct updated priority level value"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Bulk Removes Driver Route of Routed Reservation - Multiple Reservations (uid:3aa95d49-297d-43ca-a082-32606a32fe0c)
    Given Shipper creates multiple reservations
    And Operator creates a driver route
    And Operator adds reservation to route
    When UI_LOAD_SHIPPER_PICKUP_PAGE "false" "false" "Reservation Type : Normal "
    And UI_PULL_ROUTE_SHIPPER_PICKUP
    Then Verify that success toast message is displayed with message = "$total Reservation(s) Pulled Out from Route"
    And VERIFY_PULL_OUT_OF_ROUTE "false"

  @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Bulk Assign Route to Reservation on Shipper Pickup Page - Multiple Reservations (uid:7a0ad9b6-cb35-4321-954f-c8a04b7645ad)
    Given Shipper creates multiple reservations
    And UI_LOAD_SHIPPER_PICKUP_PAGE "false" "false" "Reservation Type : Normal "
    And Operator clicks switch "on 'Bulk Assign Route'" toggle button
    Then Verify that "Slide Panel is Shown on the right side"
    When Operator clicks on checkbox for selected "Reservation" from the list
    Then Verify that "'{number_of_selected_reservations}/100 Reservation' text is shown at the top of Slide Panel"
    And Verify that "selected reservations details are shown correctly"
    When Operator clicks "'X' (close)" button
    And Verify that "removed Reservation detail is cleared from Side Panel and number of reservation is decreased"
    And Verify that "removed Reservation checkbox is unchecked from the lists"
    When Operator select "a route" from dropdown menu
    And Operator clicks "'Bulk Assign'" button
    Then Verify that success toast message is displayed with message = "bulk assign reservation to route"
    And Verify that "all Reservations are routed successfully"
    And Verify that new record in ""/"route_waypoint" is created ""
    And Verify that in "core_qa_sg" / "waypoint"."status" is "Routed"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Force Finishes a Pending Reservation on Shipper Pickup Page - Success Reservation (uid:4a2910a0-364b-4fc7-9149-a4c80bcdc70b)
  @binti
    Given Shipper creates a reservation
    And Operator creates a driver route
    And Operator adds reservation to route
    And UI_LOAD_SHIPPER_PICKUP_PAGE "false" "false" "Reservation Type : Normal "
    When Operator clicks on "'Arrow' icon on 'Actions' menu"
    And Operator clicks "'Success'" button
    Then Verify that "'Success Reservation'" modal is shown
    When Operator clicks "'Proceed'" button
    Then Verify that "Reservation is force succeeded" successfully
    And Verify that "Reservation Status" is updated to "Success"
    And Verify that "Success Reservation row background color is changed to Green"
    And Verify that "'Arrow' icon" button is "disabled"
    And VERIFY_FORCE_FINISH_RESERVATION "Pending/Pending Pickup" "Pending" "Success" "false" "1 (Success)"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Force Finishes a Pending Reservation on Shipper Pickup Page - Fail Reservation (uid:7edbeffb-bd5e-466c-bc8d-2aa43eb50555)
  @binti
    Given Shipper creates a reservation
    And Operator creates a driver route
    And Operator adds reservation to route
    And UI_LOAD_SHIPPER_PICKUP_PAGE "false" "false" "Reservation Type : Normal "
    When Operator clicks on "'Arrow' icon on 'Actions' menu"
    And Operator clicks "'Fail'" button
    Then Verify that "'Fail Reservation'" modal is shown
    When Operator clicks "'Proceed'" button
    And Operator select "a failure reason" from dropdown menu
    Then Verify that "Reservation is force failed" successfully
    And Verify that "Reservation Status" is updated to "Fail"
    And Verify that "Failed Reservation row background color is changed to RED"
    And Verify that "'Arrow' icon" button is "disabled"
    And Verify that "selected Failure reason is displayed in Failure Reason column"
    And VERIFY_FORCE_FINISH_RESERVATION "Pending/Pending Pickup" "Pending" "Fail" "false" "2 (Fail)"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op