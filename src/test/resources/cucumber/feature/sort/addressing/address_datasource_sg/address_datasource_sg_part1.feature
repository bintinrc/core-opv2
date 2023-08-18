@Sort @AddressDataSourceSgPart1
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun @BeforeDeleteAddressCommonV2
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: SG Address Datasource Landing Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verify search field lable:
      | l1 | Postcode |

  Scenario: SG Address Datasource Landing Page - Search Box No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verifies Address Datasource search button is disabled

  Scenario: SG Address Datasource Landing Page - Search Box Invalid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | INVALID |
    Then Operator verifies no result found on Address Datasource page

  Scenario: SG Address Datasource Landing Page - Search Box Valid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-1} |
    Then Operator verifies new address datasource is added:
      | postcode    | {datasource-postcode-1} |
      | latitude    | {latitude-1}            |
      | longitude   | {longitude-1}           |
      | whitelisted | True                    |

  Scenario: SG Address Datasource - Add a Row with Valid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | postcode    | {auto-postcode-sg-1}       |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type":"STANDARD","latitude":{latitude-1},"longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {auto-postcode-sg-1}           |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | postcode | {auto-postcode-sg-1}           |
    Then Operator verifies new address datasource is added:
      | postcode    | {KEY_SORT_CREATED_ADDRESS.postcode}  |
      | latitude    | {KEY_SORT_CREATED_ADDRESS.latitude}  |
      | longitude   | {KEY_SORT_CREATED_ADDRESS.longitude} |
      | whitelisted | True                                 |

  Scenario: SG Address Datasource - Add a Row with No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    Then Operator verifies Add Button is Disabled

  Scenario: SG Address Datasource - Add a Row with Invalid Latlong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | 1.1,1.11                |
      | postcode    | {datasource-postcode-1} |
      | whitelisted | True                    |
    Then Operator verifies Add Button is Disabled
    And Operator verifies invalid latlong message

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op