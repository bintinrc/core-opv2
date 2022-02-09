@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsMY @SSBMY @CreateTemplateMY

Feature: Create SSB Template

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteSsbTemplate
  Scenario: Create New Template - MY (uid:43046547-f398-461e-b0ce-267098e8e2b1)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID,Shipper Name,Billing Name,Tracking ID          |
    Then DB Operator gets the template details using template name
    Then Operator verifies below details in billing_qa_gl.templates table
      | column                | expected_value                       |
      | system_id             | {KEY_COUNTRY}                        |
      | description           | {KEY_TEMPLATE.description}           |
      | report_type           | {KEY_TEMPLATE.reportType}            |
      | configuration         | notNull                                                 |
      | configuration.headers | Legacy Shipper ID,Shipper Name,Billing Name,Tracking ID |
      | created_at            | {gradle-current-date-yyyy-MM-dd}                        |
      | updated_at            | {gradle-current-date-yyyy-MM-dd}     |
      | deleted_at            | null                                 |