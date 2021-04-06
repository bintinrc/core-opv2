@core
Feature: Failed Delivery Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario: Operator RTS Multiple Failed Deliveries (uid:3d3d7420-29b5-4072-9ebe-c5870756c8c5)
  Update By Zuhri 20/12/2017
    Given Shipper creates multiple "Parcel" orders
    And Operator global inbound the order
    And Operator creates a driver route
    And Operator adds order to "delivery transactions" route
    And Driver "fail" the "delivery transactions" from driver app
    When UI_RTS_FAILED_DELIVERY "true" "false" "Add New Address" "false" "a reason " "a timeslot"
    Then VERIFY_RTS_ORDER "true" "Fail" "true" "Fail" "Transit/En-route to Sorting Hub" "false"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @ha @happy-path
  Scenario Outline: Operator Reschedule Failed Delivery Order on Next Day (<hiptest-uid>)
  Created by Arga Yuda Permana
  Update by zuhri 20/12/2017
    Given Shipper creates a "<Note>" order
    And Operator global inbound the order
    And Operator creates a driver route
    And Operator adds order to "delivery transaction" route
    And Driver "fail" the "delivery transaction" from driver app
    When UI_RESCHEDULE_FAILED_DELIVERY "true"
    Then VERIFY_RESCHEDULE_ORDER "Transit/En-route to Sorting Hub" "Delivery" "true"

    Examples:
      | Note   | hiptest-uid                              |
      | Normal | uid:5e0902e9-5bcc-4993-810d-caea0781b772 |
      | Return | uid:c51d01b9-7f03-462f-ae1d-b685b739ce0e |

  @core @category-core @coverage-auto @coverage-operator-auto @happy-path @step-done
  Scenario: Operator Reschedule Multiple Failed Deliveries (uid:6cba01c9-2685-457e-b4d1-5e08db86fdfe)
  Created by Arga Yuda Permana
  Update By Zuhri 20/12/2017
    Given Shipper creates multiple "Parcel" orders
    And Operator global inbound the order
    And Operator creates a driver route
    And Operator adds order to "delivery transactions" route
    And Driver "fail" the "delivery transactions" from driver app
    When UI_RESCHEDULE_FAILED_DELIVERY "false"
    Then VERIFY_RESCHEDULE_ORDER "Transit/En-route to Sorting Hub" "Delivery" "false"

  @coverage-auto @coverage-operator-auto @step-done @happy-path
  Scenario Outline: Operator RTS Failed Delivery Order on Next Day (<hiptest-uid>)
    Given Shipper creates a "<Note>" order
    And Operator global inbound the order
    And Operator creates a driver route
    And Operator adds order to "delivery transaction" route
    And Driver "fail" the "delivery transaction" from driver app
    When UI_RTS_FAILED_DELIVERY "false" "false" "-" "true" "a reason " "a timeslot"
    Then VERIFY_RTS_ORDER "true" "Pending" "true" "Fail" "Transit/En-route to Sorting Hub" "false"

    Examples:
      | Note   | hiptest-uid                              |
      | Normal | uid:e2336c49-a955-4f55-a44a-4757a2ce5386 |
      | Return | uid:03b0e991-9bb1-4eae-9f2c-944b2856948a |

  @core @category-core @happy-path @step-done @coverage-manual @coverage-operator-manual
  Scenario: Operator Reschedule Multiple Failed Deliveries by Upload CSV (uid:a57d82d5-1ac1-48a9-9f21-ad5a136a69ea)
  Created by Arga Yuda Permana
  Update By Zuhri 20/12/2017
    Given Shipper creates multiple "Parcel" orders
    And Operator global inbound the order
    And Operator creates a driver route
    And Operator adds order to "delivery transactions" route
    And Driver "fail" the "delivery transactions" from driver app
    When Operator goes to "'Failed Delivery Management'" page
    And Operator "prepare sample_reschedule.xlsx file"
    And Operator clicks "'+ CSV Reschedule'" button
    And Operator uploads "reschedule excel" file
    And Operator clicks "'Upload CSV'" button
    Then Verify that success toast message is displayed with message = "$total order(s) updated. CSV Reschedule"
    And Verify that "csv-reschedule-result" CSV file is successfully downloaded
      """
      NOTE : excel file should contain ALL successfully rescheduled tracking id & chosen date
      """
    Then VERIFY_RESCHEDULE_ORDER "Transit/En-route to Sorting Hub" "Delivery" "false"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op