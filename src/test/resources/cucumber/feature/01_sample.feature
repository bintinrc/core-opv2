@01Sample @Dummy
Feature: Sample 01

  @ShouldAlwaysRun
  Scenario: Launch Browser
    Given step "SUCCESS"

  Scenario Outline: Scenario 1 on Sample 1 <orderType>
    Given random step
  Examples:
    | Note   | hiptest-uid                              | orderType |
    | Normal | uid:3e01ecc1-4e17-4b26-bc30-65711dd73133 | Normal    |
    | C2C    | uid:a9db815b-1187-4cee-81fd-c5f4ccec8d56 | C2C       |
    | Return | uid:f298d342-ebb3-4a49-ab04-0b7f13c004d3 | Return    |

  Scenario: Scenario 2 on Sample 1 <orderType>
    Given random step

  @ShouldAlwaysRun
  Scenario: Kill Browser
    Given step "SUCCESS"