@OperatorV2 @Core @Routing @CreateRouteGroups @happy-path
Feature: Create Route Groups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @core @category-core @coverage-auto @coverage-operator-auto @step-done @happy-path @JIRA-SHIP-2002
  Scenario: Operator Add Transaction to Route Group (uid:369cd974-fa30-4b93-96e9-4d5c5e82833b)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    And Operator adds following transactions to Route Group "{KEY_CREATED_ROUTE_GROUP.name}":
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verifies that success toast displayed:
      | top | Added successfully |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op