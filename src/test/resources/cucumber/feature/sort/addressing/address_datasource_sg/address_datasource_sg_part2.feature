@Sort @AddressDataSourceSgPart2
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteAddressDatasource
  Scenario: SG Address Datasource - Add a Row with Valid Input Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | postcode    | {datasource-postcode-2}    |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {datasource-postcode-2}   |
      | zone     | {KEY_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.shortName}  |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | postcode    | {datasource-postcode-2}    |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {KEY_CREATED_ADDRESSING.postcode} |
      | zone     | {KEY_ZONE_INFO.shortName}         |
      | hub      | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    And Operator verify the data source toast disappears
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | postcode | {KEY_CREATED_ADDRESSING.postcode} |
    Then Operator verifies new address datasource is added:
      | postcode    | {KEY_CREATED_ADDRESSING.postcode}  |
      | latitude    | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude   | {KEY_CREATED_ADDRESSING.longitude} |
      | whitelisted | True                               |

  Scenario: SG Address Datasource - Edit Row Form
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-1} |
    When Operator clicks on Edit Button on Address Datasource Page
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {datasource-postcode-1}     |
      | zone     | {KEY_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.shortName}  |

  @DeleteAddressDatasource
  Scenario: SG Address Datasource - Edit Row - LatLong
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | postcode    | {datasource-postcode-2}    |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {datasource-postcode-2}   |
      | zone     | {KEY_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.shortName}  |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | postcode | {KEY_CREATED_ADDRESSING.postcode} |
    Then Operator verifies new address datasource is added:
      | postcode    | {KEY_CREATED_ADDRESSING.postcode}  |
      | latitude    | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude   | {KEY_CREATED_ADDRESSING.longitude} |
      | whitelisted | True                               |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | {latitude-2},{longitude-2} |
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {datasource-postcode-2}     |
      | zone     | {KEY_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.shortName}  |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-2} |
    Then Operator verifies new address datasource is added:
      | postcode    | {datasource-postcode-2} |
      | latitude    | {latitude-2}          |
      | longitude   | {longitude-2}         |
      | whitelisted | True                  |

  Scenario: SG Address Datasource - Edit Row - with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-1} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | postcode | EMPTY |
    And Operator verifies empty field error shows up in address datasource page

  Scenario: SG Address Datasource - Edit Row Form - Delete
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | postcode    | {datasource-postcode-2}    |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {datasource-postcode-2}   |
      | zone     | {KEY_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.shortName}  |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-2} |
    When Operator clicks on Edit Button on Address Datasource Page
    When Operator clicks on Delete Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-2} |
    Then Operator verifies no result found on Address Datasource page

  Scenario: SG Address Datasource - Edit Row Form Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | postcode    | {datasource-postcode-2}    |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {datasource-postcode-2}   |
      | zone     | {KEY_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.shortName}  |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-2} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | postcode | {datasource-postcode-1} |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {datasource-postcode-1}   |
      | zone     | {KEY_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.shortName}  |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    And Operator verify the data source toast disappears
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-1} |
    Then Operator verifies new address datasource is added:
      | postcode  | {datasource-postcode-1} |
      | latitude  | {latitude-1}            |
      | longitude | {longitude-1}           |

  Scenario: SG Address Datasource - View Zone and Hub match - Existing Row
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode} |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1} |
      | zone    | {KEY_ZONE_INFO.shortName}   |
      | hub     | {KEY_HUB_INFO.shortName}    |

  @DeleteAddressDatasource
  Scenario: SG Address Datasource - Edit Row -  Whitelisted
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | postcode    | {datasource-postcode-2}    |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {datasource-postcode-2}   |
      | zone     | {KEY_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.name}       |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | postcode | {KEY_CREATED_ADDRESSING.postcode} |
    Then Operator verifies new address datasource is added:
      | postcode    | {KEY_CREATED_ADDRESSING.postcode}  |
      | latitude    | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude   | {KEY_CREATED_ADDRESSING.longitude} |
      | whitelisted | True                               |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | whitelisted | False |
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {datasource-postcode-2}   |
      | zone     | {KEY_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.name}       |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-2} |
    Then Operator verifies new address datasource is added:
      | postcode    | {datasource-postcode-2} |
      | latitude    | {latitude-1}            |
      | longitude   | {longitude-1}           |
      | whitelisted | False                   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op