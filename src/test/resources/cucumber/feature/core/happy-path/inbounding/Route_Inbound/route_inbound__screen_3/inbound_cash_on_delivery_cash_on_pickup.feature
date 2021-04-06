@undecided @undecided @undecided
Feature: Inbound Cash On Delivery & Cash On Pickup

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @category-core @coverage-auto @coverage-operator-auto @happy-path @step-done
  Scenario Outline: Inbound Cash for COD (<hiptest-uid>)
    Given Shipper creates "multiple Parcel Order" with "COD"
    And Operator global inbound the order
    And Operator creates a driver route
    And Operator adds order to "delivery transaction" route
    And Operator merges the transaction waypoints
    And Driver "success" the "delivery transaction" from driver app
    And Verify that order status/granular_status is "Completed/Completed "
    And UI_VIEW_INBOUND_CASH

    Examples:
      | Note                             | field                             | is_split | type                     | hiptest-uid                              |
      | Inbound Cash Only                | Cash Collected                    | false    | Cash                     | uid:24674576-d71b-44a9-bb42-8f2b42fb97d6 |
      | Inbound Credit Only              | Credit Collected                  | false    | Credit                   | uid:a61424da-030c-4e3c-8371-c0b0d42eaeb3 |
      | Inbound Split Into Cash & Credit | Cash Collected & Credit Collected | true     | Cash/Credit respectively | uid:0fd362ee-b81d-4a2e-8805-c4724a4d78d0 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op