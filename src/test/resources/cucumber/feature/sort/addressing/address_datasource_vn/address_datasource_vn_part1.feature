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

  @DeleteAddressDatasource
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
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province | {KEY_CREATED_ADDRESSING.province}    |
      | district | {KEY_CREATED_ADDRESSING.district}    |
      | ward     | {KEY_CREATED_ADDRESSING.subdistrict} |
      | zone     | {KEY_ZONE_INFO.shortName}            |
      | hub      | {KEY_HUB_INFO.name}                  |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_CREATED_ADDRESSING.province}    |
      | kota      | {KEY_CREATED_ADDRESSING.district}    |
      | kecamatan | {KEY_CREATED_ADDRESSING.subdistrict} |
    Then Operator verifies new address datasource is added:
      | province    | {KEY_CREATED_ADDRESSING.province}    |
      | kota        | {KEY_CREATED_ADDRESSING.district}    |
      | kecamatan   | {KEY_CREATED_ADDRESSING.subdistrict} |
      | latitude    | {KEY_CREATED_ADDRESSING.latitude}    |
      | longitude   | {KEY_CREATED_ADDRESSING.longitude}   |
      | whitelisted | True                                 |

  @DeleteAddressDatasource
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
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province | {KEY_CREATED_ADDRESSING.province}    |
      | district | {KEY_CREATED_ADDRESSING.district}    |
      | ward     | {KEY_CREATED_ADDRESSING.subdistrict} |
      | zone     | {KEY_ZONE_INFO.shortName}            |
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
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province | {KEY_CREATED_ADDRESSING.province}    |
      | district | {KEY_CREATED_ADDRESSING.district}    |
      | ward     | {KEY_CREATED_ADDRESSING.subdistrict} |
      | zone     | {KEY_ZONE_INFO.shortName}            |
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
      | province  | {KEY_CREATED_ADDRESSING.province}    |
      | kota      | {KEY_CREATED_ADDRESSING.district}    |
      | kecamatan | {KEY_CREATED_ADDRESSING.subdistrict} |
    Then Operator verifies new address datasource is added:
      | province    | {KEY_CREATED_ADDRESSING.province}    |
      | kota        | {KEY_CREATED_ADDRESSING.district}    |
      | kecamatan   | {KEY_CREATED_ADDRESSING.subdistrict} |
      | latitude    | {KEY_CREATED_ADDRESSING.latitude}    |
      | longitude   | {KEY_CREATED_ADDRESSING.longitude}   |
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