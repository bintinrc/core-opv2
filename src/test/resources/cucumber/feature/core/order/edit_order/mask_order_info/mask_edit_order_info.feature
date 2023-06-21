@OperatorV2 @Core @EditOrder @MaskEditOrderInfo
Feature: Mask Edit Order Info

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator View Edit Order Details - Order Events Masked
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{from-address}, "to":{to-address}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}" without unmask
    Then Operator verify order event on Edit order page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                                                       |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: Click to reveal (tracked) D MANDAI SQUARE 116 Kilang Timur\|\|\|\|308412 Zone ID: 34654 Destination Hub ID: 1 Lat, Long: 1.288148, 103.740232 Address Status: VERIFIED AV Mode (Manual/Auto): MANUAL Source: FROM_SHIPPER |
    When Operator refresh page
    And Operator click Delivery -> Edit Delivery Details on Edit Order page
    And  Operator update Delivery Details on Edit Order Page
      | recipientName    | test sender name   |
      | recipientContact | +9727894436        |
      | recipientEmail   | test@mail.com      |
      | country          | Singapore          |
      | city             | Singapore          |
      | address1         | 233E ST. JOHN ROAD |
      | address2         | Kilang Selatan     |
      | postalCode       | 318405             |
    Then Operator verifies that success toast displayed:
      | top | Delivery Details Updated |
    When Operator refresh page without unmask
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | description | To Address 1 changed from Click to reveal (tracked) D MANDAI SQUARE 116 to Click to reveal (tracked) OAD To Address 2 changed from Click to reveal (tracked) g Timur to Click to reveal (tracked) g Selatan To Postcode changed from 308412 to 318405 To City updated: assigned new value Singapore To Country changed from SG to Singapore To Latitude changed from 1.288148 to 1.288147 To Longitude changed from 103.740232 to 103.740233 Is Rts changed from false to false |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                                                                                                                                                                                                                |
      | description | To Name changed from Core Automation Customer to test sender name To Email changed from core.automation.customer@ninjavan.co to test@mail.com To Contact changed from Click to reveal (tracked) 4435 to Click to reveal (tracked) 4436 Is Rts changed from false to false |





