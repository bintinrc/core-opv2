@OperatorV2 @OperatorV2Part1 @PrinterTemplates
Feature: Printer Templates

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to load Printer label template and list all of needed fields (uid:4665c73f-6d40-42b2-8e74-37d2db89e26b)
    Given Operator go to menu Thermal Printing -> Printer Templates
    When Operator select template with name = "Ninja Stamp Label" on Printer Templates page
    Then Operator verifies the selected template is loaded and all needed fields from the template should be shown on the right panel on Printer Templates page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
