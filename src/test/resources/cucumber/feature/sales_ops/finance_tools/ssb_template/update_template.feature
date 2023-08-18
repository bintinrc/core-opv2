@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @SSB @UpdateTemplate

Feature: Update Template

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteSsbTemplate
  Scenario: Update Template - Add Some Columns - SG (uid:0c8831da-93a7-4453-84cb-df6202841f4b)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-1-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-1-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID                                                  |
    Then Operator waits for 1 seconds
    Then Operator edits SSB Template with Name "{KEY_TEMPLATE.getName}"
    Then Operator updates SSB template with below data successfully
      | selectHeaders | Total (Sum of All Fees),L1 Name (to address l1 name),L2 Name (to address l2 name),L3 Name (to address l3 name),Source (source of order creation),Dispro Campaign Name,Dispro Discount Value,Dispro(%),Nett Delivery Fee (Delivery fee including all discounts) |
    Then DB Operator gets the template details using template name
    Then Operator verifies below details in billing_qa_gl.templates table
      | column                | expected_value                   |
      | system_id             | {KEY_COUNTRY}                    |
      | description           | {KEY_TEMPLATE.description}       |
      | report_type           | {KEY_TEMPLATE.reportType}        |
      | configuration         | notNull                                                                                                                       |
      | configuration.headers | Legacy Shipper ID,Total,L1 Name,L2 Name,L3 Name,Nett Delivery Fee,Dispro(%),Dispro Discount Value,Dispro Campaign Name,Source |
      | created_at            | {gradle-current-date-yyyy-MM-dd}                                                                                              |
      | updated_at            | {gradle-current-date-yyyy-MM-dd} |
      | deleted_at            | null                             |

  @DeleteSsbTemplate
  Scenario: Update Template - Update Name and Description (uid:3195225a-8fe0-421d-b666-59434bb79222)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-2-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-2-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Shipper Name                                                       |
    Then Operator waits for 1 seconds
    Then Operator edits SSB Template with Name "{KEY_TEMPLATE.getName}"
    Then Operator updates SSB template with below data successfully
      | templateName        | Dummy-Template-2-Update-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-2-Update-Description-{gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator waits for 2 seconds
    Then DB Operator gets the template details using template name
    Then Operator verifies below details in billing_qa_gl.templates table
      | column                | expected_value                   |
      | system_id             | {KEY_COUNTRY}                    |
      | description           | {KEY_TEMPLATE.description}       |
      | report_type           | {KEY_TEMPLATE.reportType}        |
      | configuration         | notNull                          |
      | configuration.headers | Shipper Name                     |
      | created_at            | {gradle-current-date-yyyy-MM-dd} |
      | updated_at            | {gradle-current-date-yyyy-MM-dd} |
      | deleted_at            | null                             |

  @DeleteSsbTemplate
  Scenario: Update Template - Update Name - Duplicate Found (uid:add9c33c-61c6-48c4-afe2-36484c0e00ed)
    #create template with name Dummy-Template-Duplicate-{gradle-current-date-yyyyMMdd}
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-Duplicate-1-{gradle-current-date-yyyyMMdd}             |
      | templateDescription | Dummy-Template-Duplicate-1-Description-{gradle-current-date-yyyyMMdd} |
      | selectHeaders       | Legacy Shipper ID                                                     |
      #create template with a different name
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-Duplicate-2-{gradle-current-date-yyyyMMdd}             |
      | templateDescription | Dummy-Template-Duplicate-2-Description-{gradle-current-date-yyyyMMdd} |
      | selectHeaders       | Legacy Shipper ID                                                     |
    #edit the second template
    Then Operator waits for 1 seconds
    Then Operator edits SSB Template with Name "{KEY_TEMPLATE.getName}"
    Then Operator creates SSB template with below data
      | templateName | Dummy-Template-Duplicate-1-{gradle-current-date-yyyyMMdd} |
    Then Operator verifies that error toast is displayed on SSB Template page:
      | top    | Network Request Error                                                          |
      | bottom | Template Name Dummy-Template-Duplicate-1-{gradle-current-date-yyyyMMdd} exists |

  @DeleteSsbTemplate
  Scenario: Update Template Name - Existing Template Has The Same Name as Deleted Template (uid:5d8e4056-c33a-453c-93b8-d4156e1e8be9)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
   # create and delete template
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-Delete-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Delete-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID                                                       |
    Then DB Operator deletes the SSB template "{KEY_TEMPLATE.name}"
    # create new template with same name
    Then Operator go to menu Finance Tools -> SSB Template
    Then SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-Delete-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Delete-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Shipper Name                                                            |
    Then Operator waits for 1 seconds
    Then Operator edits SSB Template with Name "{KEY_TEMPLATE.getName}"
    # Update name to a different name
    Then Operator updates SSB template with below data successfully
      | templateName | Dummy-Template-Delete-1-{gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator waits for 2 seconds
    Then DB Operator gets the template details using template name
    Then Operator verifies below details in billing_qa_gl.templates table
      | column                | expected_value                   |
      | system_id             | {KEY_COUNTRY}                    |
      | description           | {KEY_TEMPLATE.description}       |
      | report_type           | {KEY_TEMPLATE.reportType}        |
      | configuration         | notNull                          |
      | configuration.headers | Shipper Name                     |
      | created_at            | {gradle-current-date-yyyy-MM-dd} |
      | updated_at            | {gradle-current-date-yyyy-MM-dd} |
      | deleted_at            | null                             |

  @DeleteSsbTemplate
  Scenario: Update Template - Template Has The Same Name as Template From Other Country (uid:8472de68-125c-486e-9d1a-7fa60cc4033b)
    #create template in ID
    And Operator changes the country to "Indonesia"
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-ID-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-ID-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID                                                   |
    # create template in SG
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Singapore"
    Then Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-SG-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-SG-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID                                                   |
    Then Operator waits for 1 seconds
    Then Operator edits SSB Template with Name "{KEY_TEMPLATE.getName}"
    Then Operator updates SSB template with below data successfully
      | templateName        | Dummy-Template-ID-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-ID-Description-{gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator waits for 2 seconds
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
      | deleted_at            | null                             |

  @DeleteSsbTemplate
  Scenario: Update Template - Remove Some Columns (uid:f54df623-63cc-4d4e-9a0a-a46fd92929a2)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID,Shipper Name                                   |
    Then Operator waits for 1 seconds
    Then Operator edits SSB Template with Name "{KEY_TEMPLATE.getName}"
    Then Operator updates SSB template with below data successfully
      | removeHeaders | Legacy Shipper ID |
    Then DB Operator gets the template details using template name
    Then Operator verifies below details in billing_qa_gl.templates table
      | column                | expected_value                   |
      | system_id             | {KEY_COUNTRY}                    |
      | description           | {KEY_TEMPLATE.description}       |
      | report_type           | {KEY_TEMPLATE.reportType}        |
      | configuration         | notNull                          |
      | configuration.headers | Shipper Name                     |
      | created_at            | {gradle-current-date-yyyy-MM-dd} |
      | updated_at            | {gradle-current-date-yyyy-MM-dd} |
      | deleted_at            | null                             |