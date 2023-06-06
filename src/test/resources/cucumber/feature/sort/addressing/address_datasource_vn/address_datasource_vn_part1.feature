@Sort @AddressDataSourceVnPart1
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: VN Address Datasource - Add a Row with No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    Then Operator verifies Add Button is Disabled

  Scenario: VN Address Datasource - Add a Row with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | GENERATED  |
      | province    | {province} |
      | kota        | {kota}     |
      | whitelisted | True       |
    Then Operator verifies Add Button is Disabled

  Scenario: VN Address Datasource - Add a Row with Invalid Latlong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | 1.1,1.11   |
      | province    | {province} |
      | district    | {district} |
      | ward        | {ward}     |
      | whitelisted | True       |
    Then Operator verifies Add Button is Disabled
    And Operator verifies invalid latlong message

  @DeleteAddressDatasourceCommonV2
  Scenario: VN Address Datasource - Add a Row with Valid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | province    | {province}                 |
      | district    | {district}                 |
      | ward        | {ward}                     |
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

  @DeleteAddressDatasourceCommonV2
  Scenario: VN Address Datasource - Add a Row with Valid Input Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | province    | {province}                 |
      | district    | {district}                 |
      | ward        | {ward}                     |
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
    When Operator refresh page
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {province}                 |
      | district    | {district}                 |
      | ward        | {ward}                     |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province | {KEY_SORT_CREATED_ADDRESS.province}    |
      | district | {KEY_SORT_CREATED_ADDRESS.district}    |
      | ward     | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
      | zone     | {KEY_SORT_ZONE_INFO.shortName}            |
      | hub      | {KEY_HUB_INFO.name}                  |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    And Operator verify the data source toast disappears
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

  Scenario: VN Address Datasource Landing Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verify search field lable:
      | l1 | province |
      | l2 | District |
      | l3 | Ward     |

  Scenario: VN Address Datasource Landing Page - Search Box No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verifies search button is disabled

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op