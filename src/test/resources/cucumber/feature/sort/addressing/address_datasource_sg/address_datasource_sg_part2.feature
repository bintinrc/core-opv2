@Sort @AddressDataSourceSgPart2
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun  @BeforeDeleteAddressCommonV2
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: SG Address Datasource - Add a Row with Valid Input Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | postcode    | {auto-postcode-sg-2}       |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {auto-postcode-sg-2}           |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2}   |
      | postcode    | {auto-postcode-sg-duplicate} |
      | whitelisted | True                         |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {KEY_SORT_CREATED_ADDRESS.postcode} |
      | zone     | {KEY_SORT_ZONE_INFO.shortName}      |
      | hub      | {KEY_HUB_DETAILS.shortName}         |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    And Operator verify the data source toast disappears
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | postcode | {KEY_SORT_CREATED_ADDRESS.postcode} |
    Then Operator verifies new address datasource is added:
      | postcode    | {KEY_SORT_CREATED_ADDRESS.postcode}  |
      | latitude    | {KEY_SORT_CREATED_ADDRESS.latitude}  |
      | longitude   | {KEY_SORT_CREATED_ADDRESS.longitude} |
      | whitelisted | True                                 |

  Scenario: SG Address Datasource - Edit Row Form
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-1} |
    When Operator clicks on Edit Button on Address Datasource Page
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {datasource-postcode-1}        |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_DETAILS.shortName}    |


  Scenario: SG Address Datasource - Edit Row - LatLong
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | postcode    | {auto-postcode-sg-3}       |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {auto-postcode-sg-3}           |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | postcode | {KEY_SORT_CREATED_ADDRESS.postcode} |
    Then Operator verifies new address datasource is added:
      | postcode    | {KEY_SORT_CREATED_ADDRESS.postcode}  |
      | latitude    | {KEY_SORT_CREATED_ADDRESS.latitude}  |
      | longitude   | {KEY_SORT_CREATED_ADDRESS.longitude} |
      | whitelisted | True                               |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | {latitude-2},{longitude-2} |
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {auto-postcode-sg-3}           |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {auto-postcode-sg-3} |
    Then Operator verifies new address datasource is added:
      | postcode    | {auto-postcode-sg-3} |
      | latitude    | {latitude-2}            |
      | longitude   | {longitude-2}           |
      | whitelisted | True                    |

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
      | postcode    | {auto-postcode-sg-4}       |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {auto-postcode-sg-4}           |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | {auto-postcode-sg-4} |
    When Operator clicks on Edit Button on Address Datasource Page
    When Operator clicks on Delete Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {auto-postcode-sg-4} |
    Then Operator verifies no result found on Address Datasource page

  Scenario: SG Address Datasource - Edit Row Form Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | postcode    | {auto-postcode-sg-5}       |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {auto-postcode-sg-5}           |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {auto-postcode-sg-5} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | postcode | {auto-postcode-sg-duplicate} |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {auto-postcode-sg-duplicate}   |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_DETAILS.shortName}    |
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
      | postcode | {auto-postcode-sg-duplicate} |
    Then Operator verifies new address datasource is added:
      | postcode  | {auto-postcode-sg-duplicate} |
      | latitude  | {latitude-1}            |
      | longitude | {longitude-1}           |

  Scenario: SG Address Datasource - View Zone and Hub match - Existing Row
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator search the existing address datasource:
      | postcode | {datasource-postcode-1} |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1}    |
      | zone    | {KEY_SORT_ZONE_INFO.shortName} |
      | hub     | {KEY_HUB_DETAILS.shortName}    |


  Scenario: SG Address Datasource - Edit Row -  Whitelisted
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | postcode    | {auto-postcode-sg-6}       |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {auto-postcode-sg-6}           |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_DETAILS.name}         |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | postcode | {KEY_SORT_CREATED_ADDRESS.postcode} |
    Then Operator verifies new address datasource is added:
      | postcode    | {KEY_SORT_CREATED_ADDRESS.postcode}  |
      | latitude    | {KEY_SORT_CREATED_ADDRESS.latitude}  |
      | longitude   | {KEY_SORT_CREATED_ADDRESS.longitude} |
      | whitelisted | True                                 |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | whitelisted | False |
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode | {auto-postcode-sg-6}           |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_DETAILS.name}         |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {auto-postcode-sg-6} |
    Then Operator verifies new address datasource is added:
      | postcode    | {auto-postcode-sg-6} |
      | latitude    | {latitude-1}            |
      | longitude   | {longitude-1}           |
      | whitelisted | False                   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op