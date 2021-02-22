@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @PricingProfiles @PricingLevers @Insurance @CreatePricingProfiles
Feature: All Shippers

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator go to menu Shipper -> All Shippers
    And DB Operator deletes "{shipper-sop-corp-v4-dummy-script-global-id}" shipper's pricing profiles

  @nadeera
  Scenario: Create Pricing Profile - Corporate Shipper - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage - Corporate Sub Shipper who Reference Parent's Pricing Profile is Exists (uid:4a5db608-65c4-410f-9a3f-44eab4f64acd)
    Given Operator edits shipper "{shipper-sop-corp-v4-dummy-script-legacy-id}"
    When Operator adds new Shipper's Pricing Profile
      | pricingScriptName   | {pricing-script-id} - {pricing-script-name} |
      | type                | FLAT                                        |
      | discount            | 20                                          |
      | insuranceMinFee     | 1.2                                         |
      | insurancePercentage | 3                                           |
      | insuranceThreshold  | 0                                           |
      | comments            | This is a test pricing script               |
    And Operator save changes on Edit Shipper Page and gets saved pricing profile values
    And DB Operator fetches pricing profile and shipper discount details
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details
    Then Operator edits shipper "{sub-shipper-sop-corp-v4-dummy-script-legacy-id}"
    And Operator gets pricing profile values
    Then Operator verifies the pricing profile and shipper discount details are correct
    And DB Operator fetches pricing lever details
    Then Operator verifies the pricing lever details



#
#
#  Scenario: Create Pricing Profile - Corporate Shipper - with 'Int' Insurance Min Fee and 'Int' Insurance Percentage - Corporate Sub Shipper who Reference Parent's Pricing Profile is Exists (uid:4a5db608-65c4-410f-9a3f-44eab4f64acd)
#Given "corporate shipper" is created
#And "corporate sub shipper of the corporate (parent) shipper" is exists
#And "corporate sub shipper" has "reference parent's" pricing profile
#And UI_LOAD_PRICING_PROFILE "the corporate shipper"
#When "operator" clicks on "Add New Profile" button
#Then verifies "New Pricing Profile" modal is displayed
#And verifies "Insurance Min Fee and Insurance Percentage field" is displayed on the modal
#When "operator" inputs "Insurance Min Fee" field with "integer value = 1.5"
#And "operator" inputs "Insurance Percentage" field with "integer value = 3"
#And "operator" chooses "COD Country Default" checkbox
#And "operator" chooses "pricing script ID = 70743 " to be added
#And "operator" clicks on "Save Changes" button on "New Pricing Profile" modal
#And "operator" clicks on "Save Changes" button on "Edit Shippers" page
#Then verifies "success message "All changes saved successfully"" notification is shown
#And verifies "a new Pricing Profile" is created with "Insurance Min Fee and Insurance Percentage" value same as the input
#And verifies "the new Insurance Min Fee and Insurance Percentage value" is added to "script_engine_qa_gl" / "pricing_levers" table
#And verifies "a new Pricing Profile" is added to "script_engine_qa_gl" / "pricing_profiles" table
#And DB_VALIDATION_PRICING_LEVERS_CREATE_INS_LEVERS "1.5" "3" "0" "current datetime"
#When "operator" goes to "pricing profile's of sub shipper in edit shipper" page
#Then verifies "parent's new pending pricing profile" information is displayed
