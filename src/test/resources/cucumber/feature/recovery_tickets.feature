@OperatorV2 @OperatorV2Part1 @RecoveryTickets @Saas
Feature: Recovery Tickets

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create damage ticket on Recovery Tickets menu (uid:43d733f5-61e2-4877-82c2-ae1ac3220a2b)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT     |
      | investigatingDepartment | DISTRIBUTION POINTS SG |
      | investigatingHub        | {hub-name}             |
      | ticketType              | DAMAGED                |
      | ticketSubType           | IMPROPER PACKAGING     |
      | parcelLocation          | DAMAGED RACK           |
      | liability               | NV DRIVER              |
      | damageDescription       | GENERATED              |
      | orderOutcomeDamaged     | PENDING                |
      | custZendeskId           | 1                      |
      | shipperZendeskId        | 1                      |
      | ticketNotes             | GENERATED              |

    Then Operator verify ticket is created successfully on page Recovery Tickets

  Scenario: Create missing ticket on Recovery Tickets menu (uid:dc66d575-0700-44c8-a4bc-2787a5616e64)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT     |
      | investigatingDepartment | DISTRIBUTION POINTS SG |
      | investigatingHub        | {hub-name}             |
      | ticketType              | MISSING                |
      | parcelDescription       | GENERATED              |
      | custZendeskId           | 1                      |
      | shipperZendeskId        | 1                      |
      | ticketNotes             | GENERATED              |
    Then Operator verify ticket is created successfully on page Recovery Tickets

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
