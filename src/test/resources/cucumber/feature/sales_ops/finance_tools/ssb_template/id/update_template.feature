@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsID @SSBID @UpdateTemplateID

Feature: Update Template

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteSsbTemplate
  Scenario: Update Template - Add Some Columns - ID (uid:7893783b-0667-4ee3-98e0-a7ba0f82bd37)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Shipper Name                                                     |
    Then Operator waits for 1 seconds
    Then Operator edits SSB Template with Name "{KEY_TEMPLATE.getName}"
    Then Operator updates SSB template with below data successfully
      | selectHeaders | Legacy Shipper ID |
    Then DB Operator gets the template details using template name
    Then Operator verifies below details in billing_qa_gl.templates table
      | column                | expected_value                   |
      | system_id             | {KEY_COUNTRY}                    |
      | description           | {KEY_TEMPLATE.description}       |
      | report_type           | {KEY_TEMPLATE.reportType}        |
      | configuration         | notNull                          |
      | configuration.headers | Legacy Shipper ID,Shipper Name   |
      | created_at            | {gradle-current-date-yyyy-MM-dd} |
      | updated_at            | {gradle-current-date-yyyy-MM-dd} |
      | deleted_at            | null                             |