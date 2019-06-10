@NinjaPackTIDGenerator
Feature: Ninja Pack Tracking ID Generator

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator should be able to generate Ninja Pack Tracking ID for '<Note>' on Ninja Pack Tracking ID Generator page (<hiptest-uid>)
    Given Operator go to menu Utilities -> Ninja Pack Tracking ID Generator
    Then Operator generates tracking IDs using data below:
    | parcelSize   | <Parcel Size>   |
    | serviceScope | <Service Scope> |
    | quantity     | <Quantity>      |
  Examples:
  | Note           | hiptest-uid                              | Parcel Size | Service Scope | Quantity |
  | XS - Intracity | uid:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Extra-Small | Intracity     | 1        |
  | XL - Intracity | uid:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Extra-Large | Nationwide    | 1        |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op