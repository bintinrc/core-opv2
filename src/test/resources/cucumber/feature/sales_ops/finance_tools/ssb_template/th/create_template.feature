@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsTH @SSBTH @CreateTemplateTH

Feature: Create SSB Template

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteSsbTemplate
  Scenario: Create New Template - TH Characters (uid:68115590-b260-4305-ad1f-794fb9478566)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}-แม่แบบสำหรับรายงาน                                            |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss}-นี่คือเทมเพลตการทดสอบที่สร้างโดยการทดสอบอัตโนมัติ |
      | selectHeaders       | Legacy Shipper ID,Shipper Name,Billing Name,Tracking ID                                                            |
    Then DB Operator gets the template details using template name
    Then Operator verifies below details in billing_qa_gl.templates table
      | column                | expected_value                       |
      | system_id             | {KEY_COUNTRY}                        |
      | description           | {KEY_TEMPLATE.description}           |
      | report_type           | {KEY_TEMPLATE.reportType}            |
      | configuration         | notNull                              |
      | configuration.headers | {KEY_TEMPLATE.configuration.headers} |
      | created_at            | {gradle-current-date-yyyy-MM-dd}     |
      | updated_at            | {gradle-current-date-yyyy-MM-dd}     |
      | deleted_at            | null                                 |