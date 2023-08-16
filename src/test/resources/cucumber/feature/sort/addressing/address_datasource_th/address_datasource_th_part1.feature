@Sort @AddressDataSourceThPart1
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun @BeforeDeleteAddressCommonV2
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: TH Address Datasource Landing Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verify search field lable:
      | l1 | Province    |
      | l2 | District    |
      | l3 | Subdistrict |
      | l4 | Postcode    |

  Scenario: TH Address Datasource Landing Page - Search Box No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verifies Address Datasource search button is disabled

  Scenario: TH Address Datasource Landing Page - Search Box Invalid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province    | INVALID |
      | district    | INVALID |
      | subdistrict | INVALID |
      | postcode    | INVALID |
    Then Operator verifies no result found on Address Datasource page

  Scenario: TH Address Datasource Landing Page - Search Box 1 of 4 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {province-1} |
    Then Operator verifies new address datasource is added:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | latitude    | {latitude-1}    |
      | longitude   | {longitude-1}   |
      | whitelisted | True            |

  Scenario: TH Address Datasource Landing Page - Search Box 2 of 4 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {province-1} |
      | district | {district-1} |
    Then Operator verifies new address datasource is added:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | latitude    | {latitude-1}    |
      | longitude   | {longitude-1}   |
      | whitelisted | True            |

  Scenario: TH Address Datasource Landing Page - Search Box 3 of 4 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
    Then Operator verifies new address datasource is added:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | latitude    | {latitude-1}    |
      | longitude   | {longitude-1}   |
      | whitelisted | True            |

  Scenario: TH Address Datasource Landing Page - Search Box 4 of 4 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | postcode    | {postcode-1}    |
    Then Operator verifies new address datasource is added:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | latitude    | {latitude-1}    |
      | longitude   | {longitude-1}   |
      | whitelisted | True            |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op