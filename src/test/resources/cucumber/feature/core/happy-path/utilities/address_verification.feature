@NOT_AUTOMATED @SAAS @NOT_AUTOMATED_OPV2
Feature: Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @core @category-core @step-done @coverage-auto @coverage-operator-auto @happy-path
  Scenario: Operator Archive Address on Address Verification Page (uid:85faee94-1ca9-4156-b568-19da98157f55)
    Given Shipper creates a "Parcel" order
    And Operator adds "Delivery Transaction" to a Route group
      """
      follow this step to add transaction to a route group : 
      https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/5214754
      """
    And Operator "update DB records in core_qa_sg.order_jaro_scores_v2 of Delivery Transaction waypoint_id on column : archived = 0"
      """
      NOTE : this to make sure, waypoint id is unarchived, since QA behavior is archiving jaro score upon order creation
      """
    When Operator goes to "Address Verification" page
    And Operator clicks on "'Verify Address' tab"
    And Operator select "a Route Group" from dropdown menu
    And Operator clicks "'Fetch Addresses'" button
    Then Verify that "Delivery Transaction address" result is shown correctly
    When Operator clicks on "'More' button under 'Actions' column"
    And Operator clicks "'Archive address'" button
    Then Verify that success toast message is displayed with message = "'Success archive address'"
    And Verify that in "core_qa_sg" / "order_jaro_scores_v2"."archived" is "1"

  @core @category-core @step-done @coverage-auto @coverage-operator-auto @happy-path
  Scenario: Operator Edit Waypoint Lat/Long on Address Verification Page (uid:73e9af2f-87d7-4fa2-b146-47881e3f5dbb)
    Given Shipper creates a "Parcel" order
    And Operator adds "Delivery Transaction" to a Route group
      """
      follow this step to add transaction to a route group : 
      https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/5214754
      """
    And Operator "update DB records in core_qa_sg.order_jaro_scores_v2 of Delivery Transaction waypoint_id on column : archived = 0"
      """
      NOTE : this to make sure, waypoint id is unarchived, since QA behavior is archiving jaro score upon order creation
      """
    When Operator goes to "Address Verification" page
    And Operator clicks on "'Verify Address' tab"
    And Operator select "a Route Group" from dropdown menu
    And Operator clicks "'Fetch Addresses'" button
    Then Verify that "Delivery Transaction address" result is shown correctly
    When Operator clicks on "'Edit' button under 'Actions' column"
    And Operator fills in "latitude/longitude details" details
    And Operator clicks "'Save'" button
    Then Verify that success toast message is displayed with message = "'Address event created. Waypoint succesfully updated'"
    And Verify that in "core_qa_sg" / "order_jaro_scores_v2"."archived" is "1"
    And Verify that Order Event  = "'VERIFY ADDRESS'" is published and shown in Edit Order page Events section

  @core @category-core @step-done @coverage-auto @coverage-operator-auto @happy-path
  Scenario: Operator Save Address on Address Verification Page (uid:0ce0a180-c7c2-4a24-b414-1cd9abebe762)
    Given Shipper creates a "Parcel" order
    And Operator adds "Delivery Transaction" to a Route group
      """
      follow this step to add transaction to a route group : 
      https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/5214754
      """
    And Operator "update DB records in core_qa_sg.order_jaro_scores_v2 of Delivery Transaction waypoint_id on column : archived = 0"
      """
      NOTE : this to make sure, waypoint id is unarchived, since QA behavior is archiving jaro score upon order creation
      """
    When Operator goes to "Address Verification" page
    And Operator clicks on "'Verify Address' tab"
    And Operator select "a Route Group" from dropdown menu
    And Operator clicks "'Fetch Addresses'" button
    Then Verify that "Delivery Transaction address" result is shown correctly
    When Operator clicks on "'More' button under 'Actions' column"
    And Operator clicks "'Save address'" button
    Then Verify that success toast message is displayed with message = "'Address event created. Waypoint succesfully updated'"
    And Verify that in "core_qa_sg" / "order_jaro_scores_v2"."archived" is "1"
    And Verify that Order Event  = "'VERIFY ADDRESS'" is published and shown in Edit Order page Events section

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op