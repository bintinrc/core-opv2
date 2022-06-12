@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @SSB @DeleteTemplate

Feature: Delete SSB Template

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Delete Template - Template is Not Used By Report Schedule (uid:f2809e91-1612-4e7f-af2b-e8ae42b52e6c)
    #create template
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID                                                |
    #Delete template
    Then Operator deletes the SSB template "{KEY_TEMPLATE.name}"
    Then Operator waits for 1 seconds
    Then DB Operator gets the template details using template name
    Then Operator verifies below details in billing_qa_gl.templates table
      | column                | expected_value                   |
      | system_id             | {KEY_COUNTRY}                    |
      | description           | {KEY_TEMPLATE.description}       |
      | report_type           | {KEY_TEMPLATE.reportType}        |
      | configuration         | notNull                          |
      | configuration.headers | Legacy Shipper ID                |
      | created_at            | {gradle-current-date-yyyy-MM-dd} |
      | updated_at            | {gradle-current-date-yyyy-MM-dd} |
      | deleted_at            | notNull                          |
      | deleted_id            | notNull                          |
