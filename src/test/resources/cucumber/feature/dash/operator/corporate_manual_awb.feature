@OperatorV2 @Utilities @CorporateManualAWB
Feature: Corporate Manual AWB

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Generate corporate manual awb TID through corporate awb generation page (uid:3f77b1b3-7424-4951-b9fa-f7e4a891e3bd)
    When Operator go to menu Utilities -> Corporate Manual AWB TID Generator
    And Corporate Manual AWB TID Generator page is loaded
    And Operator enters 2 quantity on Corporate Manual AWB TID Generator page
    And Operator clicks Generate button on Corporate Manual AWB TID Generator page
    Then Operator verifies that "TIDs generated" success notification is displayed
    And Operator verifies Corporate Manual AWB Tracking ID file contains 2 records
    When Operator saves generated Corporate Manual AWB Tracking IDs from file
    And DB Operator verifies Ninja Pack Tracking ID record:
      | trackingId  | {KEY_LIST_CORPORATE_MANUAL_AWB_TRACKING_ID[1]} |
      | isUsed      | false                                          |
      | isCorporate | true                                           |
      | sku         | null                                           |
    And DB Operator verifies Ninja Pack Tracking ID record:
      | trackingId  | {KEY_LIST_CORPORATE_MANUAL_AWB_TRACKING_ID[2]} |
      | isUsed      | false                                          |
      | isCorporate | true                                           |
      | sku         | null                                           |

  Scenario: Generate corporate manual awb TID through corporate awb generation page - empty quantity field (uid:f1134b9f-f0d5-4afe-80ff-6a3e3761e93d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Utilities -> Corporate Manual AWB TID Generator
    And Corporate Manual AWB TID Generator page is loaded
    And Operator clicks Generate button on Corporate Manual AWB TID Generator page
    Then Operator verifies "Quantity is required" error message on Corporate Manual AWB TID Generator page

  Scenario Outline: Generate corporate manual awb TID through corporate awb generation page - invalid quantity - <note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Utilities -> Corporate Manual AWB TID Generator
    And Corporate Manual AWB TID Generator page is loaded
    And Operator enters <enter_val> quantity on Corporate Manual AWB TID Generator page
    Then Operator verifies quantity is <expected_val> on Corporate Manual AWB TID Generator page
    Examples:
      | note                   | enter_val | expected_val | hiptest-uid                              |
      | less then min quantity | 0         | 1            | uid:45966fa6-8ad8-423b-9616-582c6e6ebd34 |
      | more then max quantity | 9999      | 5000         | uid:63919c7c-24a4-48c9-882c-4fdf7aba737f |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op