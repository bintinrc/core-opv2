@OperatorV2 @Core @Routing @CreateRouteGroups
Feature: Create Route Groups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Filter Reservation Type on Create Route Group - Reservation Filters - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_service_level":"<pickup_service_level>", "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Hide Transactions" on Transaction Filters section on Create Route Group page
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group page
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | reservationType   | <rsvn_type> |
      | reservationStatus | Pending     |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Reservation records on Create Route Group page using data below:
      | id                           | type        | shipper                    | address                                                     | status  |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | PENDING |

    Examples:
      | Note                                 | hiptest-uid                              | rsvn_type         | pickup_service_level |
      | Reservation Type : Normal            | uid:77ac93be-96a4-4019-a584-bf32c5831000 | Normal            | Standard             |
      | Reservation Type : Premium Scheduled | uid:bea12c7f-ce7d-45dd-8c0c-79497f89c9b5 | Premium Scheduled | Premium              |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
