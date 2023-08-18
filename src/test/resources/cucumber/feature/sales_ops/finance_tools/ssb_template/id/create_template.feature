@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOpsID @SSBID @CreateTemplateID

Feature: Create SSB Template

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteSsbTemplate
  Scenario: Create New Template - ID (uid:4e78058d-fbb4-4831-9430-3df5ab5e0456)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | selectHeaders       | Legacy Shipper ID,Shipper Name,Billing Name,Tracking ID,L1 ID (To-address L1 ID),L2 ID (To-address L2 ID),L3 ID (To-address L3 ID) |
    Then DB Operator gets the template details using template name
    Then Operator verifies below details in billing_qa_gl.templates table
      | column                | expected_value                                          |
      | system_id             | {KEY_COUNTRY}                                           |
      | description           | {KEY_TEMPLATE.description}                              |
      | report_type           | {KEY_TEMPLATE.reportType}                               |
      | configuration         | notNull                                                                   |
      | configuration.headers | Legacy Shipper ID,Shipper Name,Billing Name,Tracking ID,L1 ID,L2 ID,L3 ID |
      | created_at            | {gradle-current-date-yyyy-MM-dd}                                          |
      | updated_at            | {gradle-current-date-yyyy-MM-dd}                        |
      | deleted_at            | null                                                    |