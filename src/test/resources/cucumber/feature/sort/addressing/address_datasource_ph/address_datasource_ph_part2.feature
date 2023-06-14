@Sort @AddressDataSourcePhPart2
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: PH Address Datasource  Landing Page - Search Box 1 of 3 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {created-province} |
    Then Operator verifies new address datasource is added:
      | province     | {created-province}     |
      | municipality | {created-municipality} |
      | barangay     | {created-barangay}     |
      | latitude     | {latitude-1}           |
      | longitude    | {longitude-1}          |
      | whitelisted  | True                   |

  Scenario: PH Address Datasource  Landing Page - Search Box 2 of 3 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province     | {created-province}     |
      | municipality | {created-municipality} |
    Then Operator verifies new address datasource is added:
      | province     | {created-province}     |
      | municipality | {created-municipality} |
      | barangay     | {created-barangay}     |
      | latitude     | {latitude-1}           |
      | longitude    | {longitude-1}          |
      | whitelisted  | True                   |

  Scenario: PH Address Datasource  Landing Page - Search Box 3 of 3  Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province     | {created-province}     |
      | municipality | {created-municipality} |
      | barangay     | {created-barangay}     |
    Then Operator verifies new address datasource is added:
      | province     | {created-province}     |
      | municipality | {created-municipality} |
      | barangay     | {created-barangay}     |
      | latitude     | {latitude-1}           |
      | longitude    | {longitude-1}          |
      | whitelisted  | True                   |

  Scenario: PH Address Datasource Landing Page - Search Box Invalid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province     | INVALID |
      | municipality | INVALID |
      | barangay     | INVALID |
    Then Operator verifies no result found on Address Datasource page

  Scenario: PH Address Datasource  Landing Page - Scrolling
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {province} |
    Then Operator verifies search box not affected by the scroll

  Scenario: PH Address Datasource - Edit Row Form
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province     | {created-province}     |
      | municipality | {created-municipality} |
      | barangay     | {created-barangay}     |
    When Operator clicks on Edit Button on Address Datasource Page
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {created-province}             |
      | municipality | {created-municipality}         |
      | barangay     | {created-barangay}             |
      | zone         | {KEY_SORT_ZONE_INFO.shortName} |
      | hub          | {KEY_HUB_DETAILS.shortName}    |

  @DeleteAddressDatasourceCommonV2
  Scenario: PH Address Datasource - Edit Row - LatLong
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | {latitude-1},{longitude-1} |
      | province     | {province-2}               |
      | municipality | {municipality-2}           |
      | barangay     | {barangay-2}               |
      | whitelisted  | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {KEY_SORT_CREATED_ADDRESS.province} |
      | municipality | {KEY_SORT_CREATED_ADDRESS.city}     |
      | barangay     | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone         | {KEY_SORT_ZONE_INFO.shortName}      |
      | hub          | {KEY_HUB_DETAILS.shortName}         |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province     | {KEY_SORT_CREATED_ADDRESS.province} |
      | municipality | {KEY_SORT_CREATED_ADDRESS.city}     |
      | barangay     | {KEY_SORT_CREATED_ADDRESS.district} |
    Then Operator verifies new address datasource is added:
      | province     | {KEY_SORT_CREATED_ADDRESS.province}  |
      | municipality | {KEY_SORT_CREATED_ADDRESS.city}      |
      | barangay     | {KEY_SORT_CREATED_ADDRESS.district}  |
      | latitude     | {KEY_SORT_CREATED_ADDRESS.latitude}  |
      | longitude    | {KEY_SORT_CREATED_ADDRESS.longitude} |
      | whitelisted  | True                                 |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | {latitude-2},{longitude-2} |
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {province-2}                   |
      | municipality | {municipality-2}               |
      | barangay     | {barangay-2}                   |
      | zone         | {KEY_SORT_ZONE_INFO.shortName} |
      | hub          | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province     | {province-2}     |
      | municipality | {municipality-2} |
      | barangay     | {barangay-2}     |
    Then Operator verifies new address datasource is added:
      | province     | {province-2}     |
      | municipality | {municipality-2} |
      | barangay     | {barangay-2}     |
      | latitude     | {latitude-2}     |
      | longitude    | {longitude-2}    |
      | whitelisted  | True             |

  @DeleteAddressDatasourceCommonV2
  Scenario: PH Address Datasource - Edit Row - L1/L2/L3
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | {latitude-2},{longitude-2} |
      | province     | {province-2}               |
      | municipality | {municipality-2}           |
      | barangay     | {barangay-2}               |
      | whitelisted  | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {province-2}                   |
      | municipality | {municipality-2}               |
      | barangay     | {barangay-2}                   |
      | zone         | {KEY_SORT_ZONE_INFO.shortName} |
      | hub          | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province     | {province-2}     |
      | municipality | {municipality-2} |
      | barangay     | {barangay-2}     |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | province     | {province-4}     |
      | municipality | {municipality-4} |
      | barangay     | {barangay-4}     |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {province-4}                   |
      | municipality | {municipality-4}               |
      | barangay     | {barangay-4}                   |
      | zone         | {KEY_SORT_ZONE_INFO.shortName} |
      | hub          | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province     | {province-4}     |
      | municipality | {municipality-4} |
      | barangay     | {barangay-4}     |
    Then Operator verifies new address datasource is added:
      | province     | {province-4}     |
      | municipality | {municipality-4} |
      | barangay     | {barangay-4}     |
      | latitude     | {latitude-2}     |
      | longitude    | {longitude-2}    |
      | whitelisted  | True             |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op