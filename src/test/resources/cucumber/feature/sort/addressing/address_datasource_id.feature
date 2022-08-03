@Sort @AddressDataSourceId
Feature: Addressing

  @LaunchBrowser @ShouldAlwaysRun
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
      | latlong  | GENERATED       |
      | province | Jakarta         |
      | kota     | Jakarta Selatan |
    Then Operator verifies Add Button is Disabled

  @DeleteAddressDatasource
  Scenario: ID Address Datasource - Add a Row with Valid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | -6.2579475,106.8436415 |
      | province  | Jakarta                |
      | kota      | Jakarta Selatan        |
      | kecamatan | Pancoran               |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | -6.2579475  |
      | longitude | 106.8436415 |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
    Then Operator verifies new address datasource is added:
      | province  | {KEY_CREATED_ADDRESSING.province}  |
      | kota      | {KEY_CREATED_ADDRESSING.city}      |
      | kecamatan | {KEY_CREATED_ADDRESSING.district}  |
      | latitude  | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude | {KEY_CREATED_ADDRESSING.longitude} |

  @DeleteAddressDatasource
  Scenario: ID Address Datasource - Add a Row with Valid Input Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | -6.2579475,106.8436415 |
      | province  | Jakarta                |
      | kota      | Jakarta Selatan        |
      | kecamatan | Pancoran               |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | -6.2579475  |
      | longitude | 106.8436415 |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | -6.1936067,106.89121 |
      | province  | Jakarta              |
      | kota      | Jakarta Selatan      |
      | kecamatan | Pancoran             |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | -6.1936067 |
      | longitude | 106.89121  |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    When Operator search the created address datasource:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
    Then Operator verifies new address datasource is added:
      | province  | {KEY_CREATED_ADDRESSING.province}  |
      | kota      | {KEY_CREATED_ADDRESSING.city}      |
      | kecamatan | {KEY_CREATED_ADDRESSING.district}  |
      | latitude  | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude | {KEY_CREATED_ADDRESSING.longitude} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op