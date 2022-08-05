@Sort @AddressDataSourcePh
Feature: Address Datasource

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
      | latlong       | GENERATED  |
      | province      | {province} |
      | municipality  | {municipality}     |
    Then Operator verifies Add Button is Disabled

  @DeleteAddressDatasource
  Scenario: ID Address Datasource - Add a Row with Valid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong       | {latitude-1},{longitude-1} |
      | province      | {province}                 |
      | municipality  | {municipality}             |
      | barangay      | {barangay}                 |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province      | {KEY_CREATED_ADDRESSING.province} |
      | municipality  | {KEY_CREATED_ADDRESSING.city}     |
      | barangay      | {KEY_CREATED_ADDRESSING.district} |
      | zone          | {KEY_ZONE_INFO.shortName}         |
      | hub           | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province      | {KEY_CREATED_ADDRESSING.province} |
      | municipality  | {KEY_CREATED_ADDRESSING.city}     |
      | barangay      | {KEY_CREATED_ADDRESSING.district} |
    Then Operator verifies new address datasource is added:
      | province      | {KEY_CREATED_ADDRESSING.province}  |
      | municipality  | {KEY_CREATED_ADDRESSING.city}      |
      | barangay      | {KEY_CREATED_ADDRESSING.district}  |
      | latitude      | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude     | {KEY_CREATED_ADDRESSING.longitude} |

  @DeleteAddressDatasource
  Scenario: ID Address Datasource - Add a Row with Valid Input Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong       | {latitude-1},{longitude-1} |
      | province      | {province}                 |
      | municipality  | {municipality}             |
      | barangay      | {barangay}                 |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province      | {KEY_CREATED_ADDRESSING.province} |
      | municipality  | {KEY_CREATED_ADDRESSING.city}     |
      | barangay      | {KEY_CREATED_ADDRESSING.district} |
      | zone          | {KEY_ZONE_INFO.shortName}         |
      | hub           | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong       | {latitude-2},{longitude-2}  |
      | province      | {province}                  |
      | municipality  | {municipality}              |
      | barangay      | {barangay}                  |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province      | {KEY_CREATED_ADDRESSING.province} |
      | municipality  | {KEY_CREATED_ADDRESSING.city}     |
      | barangay      | {KEY_CREATED_ADDRESSING.district} |
      | zone          | {KEY_ZONE_INFO.shortName}         |
      | hub           | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    When Operator search the created address datasource:
      | province      | {KEY_CREATED_ADDRESSING.province} |
      | municipality  | {KEY_CREATED_ADDRESSING.city}     |
      | barangay      | {KEY_CREATED_ADDRESSING.district} |
    Then Operator verifies new address datasource is added:
      | province          | {KEY_CREATED_ADDRESSING.province}  |
      | municipality      | {KEY_CREATED_ADDRESSING.city}      |
      | barangay          | {KEY_CREATED_ADDRESSING.district}  |
      | latitude          | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude         | {KEY_CREATED_ADDRESSING.longitude} |

  Scenario: ID Address Datasource Landing Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verify search field lable:
      | l1 | province     |
      | l2 | Municipality |
      | l3 | Barangay     |

  Scenario: ID Address Datasource  Landing Page - Search Box No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verifies search button is disabled

  Scenario: ID Address Datasource  Landing Page - Search Box 1 of 3 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {created-province} |
    Then Operator verifies new address datasource is added:
      | province      | {created-province}      |
      | municipality  | {created-municipality}  |
      | barangay      | {created-barangay}      |
      | latitude      | {latitude-1}            |
      | longitude     | {longitude-1}           |

  Scenario: ID Address Datasource  Landing Page - Search Box 2 of 3 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province      | {created-province}      |
      | municipality  | {created-municipality}  |
    Then Operator verifies new address datasource is added:
      | province      | {created-province}      |
      | municipality  | {created-municipality}  |
      | barangay      | {created-barangay}      |
      | latitude      | {latitude-1}            |
      | longitude     | {longitude-1}           |

  Scenario: ID Address Datasource  Landing Page - Search Box 3 of 3  Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province      | {created-province}      |
      | municipality  | {created-municipality}  |
      | barangay      | {created-barangay}      |
    Then Operator verifies new address datasource is added:
      | province      | {created-province}      |
      | municipality  | {created-municipality}  |
      | barangay      | {created-barangay}      |
      | latitude      | {latitude-1}            |
      | longitude     | {longitude-1}           |

  Scenario: ID Address Datasource Landing Page - Search Box Invalid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province      | INVALID |
      | municipality  | INVALID |
      | barangay      | INVALID |
    Then Operator verifies no result found on Address Datasource page

  Scenario: ID Address Datasource  Landing Page - Scrolling
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {province} |
    Then Operator verifies search box not affected by the scroll

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op