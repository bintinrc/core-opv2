@OperatorV2 @Utilities @NinjaPackTrackingIdGenerator
Feature: Ninja Pack Tracking ID Generator

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator should be able to generate Ninja Pack Tracking ID on Ninja Pack Tracking ID Generator page (<hiptest-uid>)
    Given Operator go to menu Utilities -> Ninja Pack Tracking ID Generator
    Then Operator generates tracking IDs using data below:
      | parcelSize   | <Parcel Size>   |
      | serviceScope | <Service Scope> |
      | quantity     | <Quantity>      |
    Examples:
      | Note           | hiptest-uid                              | Parcel Size | Service Scope | Quantity |
      | XS - Intracity | uid:350e4586-7305-47be-8703-09b71c3a3eb9 | Extra-Small | Intracity     | 1        |
      | XL - Intracity | uid:a187313b-143c-46f8-9b7d-de335bc52e32 | Extra-Large | Nationwide    | 1        |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op