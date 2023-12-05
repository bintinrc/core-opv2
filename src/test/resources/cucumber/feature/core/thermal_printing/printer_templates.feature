@OperatorV2 @Core @ThermalPrinting @PrinterTemplates
Feature: Printer Templates

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @MediumPriority
  Scenario: Operator Should be Able to Load Printer Label Template and List All of Needed Fields (uid:c9cededd-939b-48b8-82f4-64367eb9c5cd)
    Given Operator go to menu Thermal Printing -> Printer Templates
    When Operator select template with name = "Ninja Stamp Label" on Printer Templates page
    Then Operator verifies the selected template is loaded and all needed fields from the template should be shown on the right panel on Printer Templates page
