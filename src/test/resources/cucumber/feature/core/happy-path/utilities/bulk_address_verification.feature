@AUTOMATED_OPV2
Feature: Bulk Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator Bulk Verify Addresses by Upload CSV Successfully (uid:aee0ee69-5174-4ce3-ad7d-86996efa1680)
  Created by Dini 26 Feb 2018
    Given Operator goes to "Bulk Address Verification" page
    And a valid "Bulk Address Verification" CSV file template is created
    When Operator clicks "'Upload CSV file'" button
    Then Verify that "'Upload Address CSV'" modal is shown
    When Operator clicks "'Choose'" button
    And Operator "uploads Bulk Address Verification CSV file"
    Then Verify that "uploaded  Bulk Address Verification CSV file " is shown on modal
    When Operator clicks "'Submit'" button
    Then Verify that "Bulk Address Verification CSV file has been uploaded" successfully
    And Verify that "waypoint id goes to 'Successful Matches' table"
    When Operator clicks "'Update Successful Matches'" button
    Then Verify that success toast message is displayed with message = " '$total Waypoint(s) Updated'"
    And Verify that Order Event  = "VERIFY ADDRESS" is published and shown in Edit Order page Events section
    And Verify that in "core_qa_sg" / "order_jaro_score_v2"."source_id" is "4"
    And Verify that in "core_qa_sg" / "order_jaro_score_v2"."archived" is "1 (old row)"
    And Verify that in "core_qa_sg" / "order_jaro_score_v2"."score" is "0 (old row)"
    And Verify that in "core_qa_sg" / "order_jaro_score_v2"."archived" is "1 (new row)"
    And Verify that in "core_qa_sg" / "order_jaro_score_v2"."score" is "1 (new row)"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op