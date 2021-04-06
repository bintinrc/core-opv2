@core
Feature: Change Delivery Timings

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Uploads the CSV File on Change Delivery Timings Page (uid:a0f33e34-b37b-4a8e-b18f-6c52155c3bdb)
    Given Shipper creates a "Parcel" order
    And a valid "Change Delivery Timings" CSV file template is created
    When Operator goes to "Change Delivery Timings" page
    And Operator clicks "'+Upload CSV'" button
    Then Verify that "'Upload Change Delivery Timing CSV'" modal is shown
    When Operator clicks "'Choose'" button
    And Operator uploads "Change Delivery Timings CSV" file
    Then Verify that "Change Delivery Timings CSV file" is shown on modal
    When Operator clicks "'Upload CSV'" button
    Then Verify that success toast message is displayed with message = "'$total order(s) updated, Change Delivery Timings'"
    And Verify that "Change Delivery Timings has been uploaded in the list" successfully
    And Verify that in "core_qa_sg" / "transaction"."start_time" is "updated with start_time"
    And Verify that in "core_qa_sg" / "transaction"."end_time" is "updated with end_time"
    And Verify that Order Event  = "UPDATE SLA" is published and shown in Edit Order page Events section

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op