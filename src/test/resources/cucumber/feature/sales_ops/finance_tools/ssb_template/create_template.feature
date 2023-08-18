@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @SSB @CreateTemplate

Feature: Create SSB Template

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteSsbTemplate
  Scenario: Create New Template - Duplicate Template Found (uid:ca713ddb-c583-4375-a15d-dce0b4449af3)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID,Shipper Name,Billing Name,Tracking ID          |
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data
      | templateName        | {KEY_TEMPLATE.name}                                     |
      | templateDescription | {KEY_TEMPLATE.description}                              |
      | selectHeaders       | Legacy Shipper ID,Shipper Name,Billing Name,Tracking ID |
    Then Operator verifies that error toast is displayed on SSB Template page:
      | top    | Network Request Error                    |
      | bottom | Template Name {KEY_TEMPLATE.name} exists |

  @DeleteSsbTemplate
  Scenario: Create New Template - New Template Has The Same Name as Deleted Template (uid:b3b2b622-b506-4326-8ce5-8d4e974da7a4)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID                                                |
    Then DB Operator deletes the SSB template "{KEY_TEMPLATE.name}"
    Then Operator go to menu Finance Tools -> SSB Template
    Then SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | {KEY_TEMPLATE.name}        |
      | templateDescription | {KEY_TEMPLATE.description} |
      | selectHeaders       | Legacy Shipper ID          |

  @DeleteSsbTemplate
  Scenario: Create New Template - New Template Has The Same Name as Template From Other Country (uid:6770c6b4-d146-40ee-931c-b7b7084f86ac)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}             |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | selectHeaders       | Legacy Shipper ID                                                |
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And Operator changes the country to "Indonesia"
    Then Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | {KEY_TEMPLATE.name}        |
      | templateDescription | {KEY_TEMPLATE.description} |
      | selectHeaders       | Legacy Shipper ID          |


  @DeleteSsbTemplate
  Scenario: Create New Template - All Columns (uid:ccb37c83-1b31-4f0c-9662-49387c30bec0)
    Given Operator go to menu Finance Tools -> SSB Template
    When SSB Template page is loaded
    And Operator clicks Create Template button
    And SSB Report Template Editor page is loaded
    Then Operator creates SSB template with below data successfully
      | templateName        | Dummy-Template-{gradle-current-date-yyyyMMddHHmmsss}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | templateDescription | Dummy-Template-Description-{gradle-current-date-yyyyMMddHHmmsss}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | selectHeaders       | Legacy Shipper ID,Shipper Name,Billing Name,Tracking ID,Shipper Order Ref,Order Granular Status,Customer Name,Delivery Type Name,Delivery Type ID,Service Type,Service Level,Parcel Size ID,Billing Weight,Create Time,Delivery Date,From City,From Billing Zone,Origin Hub,To Address,To Postcode,To Billing Zone,Destination Hub,Delivery Fee,COD Fee,Insured Value,Insurance Fee,Handling Fee,GST,Total (Sum of All Fees),Script ID,Script Version,Last Calculated Date,Global Shipper ID,L1 Name (to address l1 name),L2 Name (to address l2 name),L3 Name (to address l3 name),NV Measured Height,NV Measured Length,NV Measured Width,Shipper Provided Height,Shipper Provided Length,Shipper Provided Width,Shipper Provided Weight,RTS Fee,From Country,To Country,COD Value,Pickup Date,Source (source of order creation),Dispro Campaign Name,Dispro Discount Value,Dispro(%),First Mile Type,Invoiced Amount,Salesperson Discount (displayed in either percentage or flat amount based on country defaults),Nett Delivery Fee (Delivery fee including all discounts),From Address,Customer Phone Number |
    Then DB Operator gets the template details using template name
    Then Operator verifies below details in billing_qa_gl.templates table
      | column                | expected_value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | system_id             | {KEY_COUNTRY}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | description           | {KEY_TEMPLATE.description}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | report_type           | {KEY_TEMPLATE.reportType}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | configuration         | notNull                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | configuration.headers | Legacy Shipper ID,Shipper Name,Billing Name,Tracking ID,Shipper Order Ref,Order Granular Status,Customer Name,Delivery Type Name,Delivery Type ID,Service Type,Service Level,Parcel Size ID,Billing Weight,Create Time,Delivery Date,From City,From Billing Zone,Origin Hub,To Address,To Postcode,To Billing Zone,Destination Hub,Delivery Fee,COD Fee,Insured Value,Insurance Fee,Handling Fee,GST,Total,Script ID,Script Version,Last Calculated Date,Global Shipper ID,L1 Name,L2 Name,L3 Name,NV Measured Height,NV Measured Length,NV Measured Width,Shipper Provided Height,Shipper Provided Length,Shipper Provided Width,Shipper Provided Weight,RTS Fee,From Country,To Country,COD Value,Source,Pickup Date,Dispro Campaign Name,Dispro Discount Value,Dispro(%),First Mile Type,Invoiced Amount,Salesperson Discount,Nett Delivery Fee,From Address,Customer Phone Number |
      | created_at            | {gradle-current-date-yyyy-MM-dd}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | updated_at            | {gradle-current-date-yyyy-MM-dd}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | deleted_at            | null                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |