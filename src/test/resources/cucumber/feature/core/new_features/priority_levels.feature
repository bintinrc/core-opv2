@OperatorV2 @Core @NewFeatures @PriorityLevels
Feature: Priority Levels

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Update Reservation Priority Level by CSV upload (uid:eb88c7d6-ef21-4226-9ffb-f171ce65716a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu New Features -> Priority Levels
    And Operator uploads "Order CSV" using next priority levels for reservations:
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} | 10 |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} | 10 |
    Then Operator verifies reservations info in Bulk Priority Edit dialog:
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} | 10 |
      | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} | 10 |
    When Operator clicks Save Changes in Bulk Priority Edit dialog
    Then Operator verifies that success toast displayed:
      | top                | 2 of 2 updated successfully |
      | waitUntilInvisible | true                        |
    And DB Operator verifies reservation:
      | id            | {KEY_LIST_OF_CREATED_RESERVATION_IDS[1]} |
      | priorityLevel | 10                                       |
    And DB Operator verifies reservation:
      | id            | {KEY_LIST_OF_CREATED_RESERVATION_IDS[2]} |
      | priorityLevel | 10                                       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
