@Sort @AddressDataSourceVnPart2
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: VN Address Datasource Landing Page - Search Box 1 of 3 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {created-province} |
    Then Operator verifies new address datasource is added:
      | province  | {created-province} |
      | kota      | {created-district} |
      | kecamatan | {created-ward}     |
      | latitude  | {latitude-1}       |
      | longitude | {longitude-1}      |

  Scenario: VN Address Datasource Landing Page - Search Box 2 of 3 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {created-province} |
      | kota     | {created-district} |
    Then Operator verifies new address datasource is added:
      | province  | {created-province} |
      | kota      | {created-district} |
      | kecamatan | {created-ward}     |
      | latitude  | {latitude-1}       |
      | longitude | {longitude-1}      |

  Scenario: VN Address Datasource Landing Page - Search Box 3 of 3  Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {created-province} |
      | kota      | {created-district} |
      | kecamatan | {created-ward}     |
    Then Operator verifies new address datasource is added:
      | province  | {created-province} |
      | kota      | {created-district} |
      | kecamatan | {created-ward}     |
      | latitude  | {latitude-1}       |
      | longitude | {longitude-1}      |

  Scenario: VN Address Datasource Landing Page - Search Box Invalid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | INVALID |
      | kota      | INVALID |
      | kecamatan | INVALID |
    Then Operator verifies no result found on Address Datasource page

  Scenario: VN Address Datasource Landing Page - Scrolling
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {province} |
    Then Operator verifies search box not affected by the scroll

  @DeleteAddressDatasourceCommonV2
  Scenario: VN Address Datasource - Edit Row - LatLong
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | province    | {edit-province}            |
      | district    | {edit-district}            |
      | ward        | {edit-ward}                |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province | {KEY_SORT_CREATED_ADDRESS.province}    |
      | district | {KEY_SORT_CREATED_ADDRESS.district}    |
      | ward     | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
      | zone     | {KEY_SORT_ZONE_INFO.shortName}            |
      | hub      | {KEY_HUB_INFO.name}                  |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_SORT_CREATED_ADDRESS.province}    |
      | kota      | {KEY_SORT_CREATED_ADDRESS.district}    |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
    Then Operator verifies new address datasource is added:
      | province    | {KEY_SORT_CREATED_ADDRESS.province}    |
      | kota        | {KEY_SORT_CREATED_ADDRESS.district}    |
      | kecamatan   | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
      | latitude    | {KEY_SORT_CREATED_ADDRESS.latitude}    |
      | longitude   | {KEY_SORT_CREATED_ADDRESS.longitude}   |
      | whitelisted | True                                 |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | {latitude-2},{longitude-2} |
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province | {edit-province}           |
      | district | {edit-district}           |
      | ward     | {edit-ward}               |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.name}       |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    Then Operator verifies new address datasource is added:
      | province  | {edit-province} |
      | kota      | {edit-district} |
      | kecamatan | {edit-ward}     |
      | latitude  | {latitude-2}    |
      | longitude | {longitude-2}   |

  Scenario: VN Address Datasource - View Zone and Hub match - Existing Row
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator search the existing address datasource:
      | province  | {created-province} |
      | kota      | {created-district} |
      | kecamatan | {created-ward}     |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1} |
      | zone    | {KEY_SORT_ZONE_INFO.shortName}   |
      | hub     | {KEY_HUB_INFO.name}         |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op