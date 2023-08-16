@Sort @AddressDataSourcePhPart1
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun @BeforeDeleteAddressCommonV2
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: PH Address Datasource - Add a Row with No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    Then Operator verifies Add Button is Disabled

  Scenario: PH Address Datasource - Add a Row with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | GENERATED      |
      | province     | {province}     |
      | municipality | {municipality} |
      | whitelisted  | True           |
    Then Operator verifies Add Button is Disabled

  Scenario: PH Address Datasource - Add a Row with Invalid Latlong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | 1.1,1.11       |
      | province     | {province}     |
      | municipality | {municipality} |
      | barangay     | {barangay}     |
    Then Operator verifies Add Button is Disabled
    And Operator verifies invalid latlong message


  Scenario: PH Address Datasource - Add a Row with Valid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | {latitude-1},{longitude-1} |
      | province     | {auto-province-ph-1}       |
      | municipality | {auto-municipality-ph-1}   |
      | barangay     | {auto-barangay-ph-1}       |
      | whitelisted  | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {KEY_SORT_CREATED_ADDRESS.province} |
      | municipality | {KEY_SORT_CREATED_ADDRESS.city}     |
      | barangay     | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone         | {KEY_SORT_ZONE_INFO.shortName}         |
      | hub          | {KEY_HUB_DETAILS.shortName}          |
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
      | whitelisted  | True                               |

  Scenario: PH Address Datasource - Add a Row with Valid Input Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | {latitude-1},{longitude-1} |
      | province     | {auto-province-ph-2}       |
      | municipality | {auto-municipality-ph-2}   |
      | barangay     | {auto-barangay-ph-2}       |
      | whitelisted  | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {KEY_SORT_CREATED_ADDRESS.province} |
      | municipality | {KEY_SORT_CREATED_ADDRESS.city}     |
      | barangay     | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone         | {KEY_SORT_ZONE_INFO.shortName}         |
      | hub          | {KEY_HUB_DETAILS.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | {latitude-2},{longitude-2}       |
      | province     | {auto-province-ph-duplicate}     |
      | municipality | {auto-municipality-ph-duplicate} |
      | barangay     | {auto-barangay-ph-duplicate}     |
      | whitelisted  | True                             |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}}|
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {KEY_SORT_CREATED_ADDRESS.province} |
      | municipality | {KEY_SORT_CREATED_ADDRESS.city}     |
      | barangay     | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone         | {KEY_SORT_ZONE_INFO.shortName}         |
      | hub          | {KEY_HUB_DETAILS.shortName}          |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
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

  Scenario: PH Address Datasource Landing Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verify search field lable:
      | l1 | province     |
      | l2 | Municipality |
      | l3 | Barangay     |

  Scenario: PH Address Datasource  Landing Page - Search Box No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verifies Address Datasource search button is disabled

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op