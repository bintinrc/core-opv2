@Sort @AddressDataSourceIdPart1
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun @BeforeDeleteAddressCommonV2
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: ID Address Datasource - Add a Row with No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    Then Operator verifies Add Button is Disabled

  Scenario: ID Address Datasource - Add a Row with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | GENERATED           |
      | province    | {created-province}  |
      | kecamatan   | {created-kecamatan} |
      | whitelisted | True                |
    Then Operator verifies Add Button is Disabled

  Scenario: ID Address Datasource - Add a Row with Invalid Latlong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | 1.1,1.11            |
      | province    | {created-province}  |
      | kota        | {created-kota}      |
      | kecamatan   | {created-kecamatan} |
      | whitelisted | True                |
    Then Operator verifies Add Button is Disabled
    And Operator verifies invalid latlong message

  Scenario: ID Address Datasource - Add a Row with Valid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | province    | {auto-province-id-1}       |
      | kota        | {auto-kota-id-1}           |
      | kecamatan   | {auto-kecamatan-id-1}      |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {KEY_SORT_CREATED_ADDRESS.province} |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}     |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone      | {KEY_SORT_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_DETAILS.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_SORT_CREATED_ADDRESS.province} |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}     |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district} |
    Then Operator verifies new address datasource is added:
      | province  | {KEY_SORT_CREATED_ADDRESS.province}  |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}      |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district}  |
      | latitude  | {KEY_SORT_CREATED_ADDRESS.latitude}  |
      | longitude | {KEY_SORT_CREATED_ADDRESS.longitude} |


  Scenario: ID Address Datasource - Add a Row with Valid Input Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | province    | {auto-province-id-2}       |
      | kota        | {auto-kota-id-2}           |
      | kecamatan   | {auto-kecamatan-id-2}      |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {KEY_SORT_CREATED_ADDRESS.province} |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}     |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone      | {KEY_SORT_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_DETAILS.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | province    | {auto-province-id-2}       |
      | kota        | {auto-kota-id-2}           |
      | kecamatan   | {auto-kecamatan-id-2}      |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {KEY_SORT_CREATED_ADDRESS.province} |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}     |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone      | {KEY_SORT_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_DETAILS.shortName}          |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    And Operator verify the data source toast disappears
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_SORT_CREATED_ADDRESS.province} |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}     |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district} |
    Then Operator verifies new address datasource is added:
      | province  | {KEY_SORT_CREATED_ADDRESS.province}  |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}      |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district}  |
      | latitude  | {KEY_SORT_CREATED_ADDRESS.latitude}  |
      | longitude | {KEY_SORT_CREATED_ADDRESS.longitude} |

  Scenario: ID Address Datasource Landing Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verify search field lable:
      | l1 | province         |
      | l2 | Kota / Kabupaten |
      | l3 | Kecamatan        |

  Scenario: ID Address Datasource  Landing Page - Search Box No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verifies search button is disabled

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op