@Sort @AddressDataSourceIdPart3
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteAddressDatasourceCommonV2
  Scenario: ID Address Datasource - View Zone and Hub Match - New Added Row
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | province    | {auto-province-id-4}       |
      | kota        | {auto-kota-id-4}           |
      | kecamatan   | {auto-kecamatan-id-4}      |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {KEY_SORT_CREATED_ADDRESS.province} |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}     |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone      | {KEY_SORT_ZONE_INFO.shortName}      |
      | hub       | {KEY_HUB_DETAILS.shortName}         |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_SORT_CREATED_ADDRESS.province} |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}     |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district} |
    Then Operator verifies new address datasource is added:
      | province    | {KEY_SORT_CREATED_ADDRESS.province}  |
      | kota        | {KEY_SORT_CREATED_ADDRESS.city}      |
      | kecamatan   | {KEY_SORT_CREATED_ADDRESS.district}  |
      | latitude    | {KEY_SORT_CREATED_ADDRESS.latitude}  |
      | longitude   | {KEY_SORT_CREATED_ADDRESS.longitude} |
      | whitelisted | True                                 |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1}    |
      | zone    | {KEY_SORT_ZONE_INFO.shortName} |
      | hub     | {KEY_HUB_DETAILS.shortName}    |

  @DeleteAddressDatasourceCommonV2
  Scenario: ID Address Datasource - View Zone and Hub Match - Edited Row - LatLong
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | province    | {auto-province-id-5}       |
      | kota        | {auto-kota-id-5}           |
      | kecamatan   | {auto-kecamatan-id-5}      |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {KEY_SORT_CREATED_ADDRESS.province} |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}     |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone      | {KEY_SORT_ZONE_INFO.shortName}      |
      | hub       | {KEY_HUB_DETAILS.shortName}         |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_SORT_CREATED_ADDRESS.province} |
      | kota      | {KEY_SORT_CREATED_ADDRESS.city}     |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.district} |
    Then Operator verifies new address datasource is added:
      | province    | {KEY_SORT_CREATED_ADDRESS.province}  |
      | kota        | {KEY_SORT_CREATED_ADDRESS.city}      |
      | kecamatan   | {KEY_SORT_CREATED_ADDRESS.district}  |
      | latitude    | {KEY_SORT_CREATED_ADDRESS.latitude}  |
      | longitude   | {KEY_SORT_CREATED_ADDRESS.longitude} |
      | whitelisted | True                                 |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | {latitude-2},{longitude-2} |
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {auto-province-id-5}           |
      | kota      | {auto-kota-id-5}               |
      | kecamatan | {auto-kecamatan-id-5}          |
      | zone      | {KEY_SORT_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {auto-province-id-5}  |
      | kota      | {auto-kota-id-5}      |
      | kecamatan | {auto-kecamatan-id-5} |
    Then Operator verifies new address datasource is added:
      | province  | {auto-province-id-5}  |
      | kota      | {auto-kota-id-5}      |
      | kecamatan | {auto-kecamatan-id-5} |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-2}, {longitude-2}    |
      | zone    | {KEY_SORT_ZONE_INFO.shortName} |
      | hub     | {KEY_HUB_DETAILS.shortName}    |



  Scenario: ID Address Datasource - Edit Row Form
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {created-province}  |
      | kota      | {created-kota}      |
      | kecamatan | {created-kecamatan} |
    When Operator clicks on Edit Button on Address Datasource Page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Edit A Row modal:
      | province  | {created-province}  |
      | kota      | {created-kota}      |
      | kecamatan | {created-kecamatan} |
      | zone      | {KEY_SORT_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_DETAILS.shortName}    |

  @DeleteAddressDatasourceCommonV2
  Scenario: ID Address Datasource - Edit Row - L1/L2/L3
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {auto-province-id-6}       |
      | kota        | {auto-kota-id-6}           |
      | kecamatan   | {auto-kecamatan-id-6}      |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {auto-province-id-6}           |
      | kota      | {auto-kota-id-6}               |
      | kecamatan | {auto-kecamatan-id-6}          |
      | zone      | {KEY_SORT_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {auto-province-id-6}  |
      | kota      | {auto-kota-id-6}      |
      | kecamatan | {auto-kecamatan-id-6} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | province  | {auto-province-id-7}  |
      | kota      | {auto-kota-id-7}      |
      | kecamatan | {auto-kecamatan-id-7} |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {auto-province-id-7}           |
      | kota      | {auto-kota-id-7}               |
      | kecamatan | {auto-kecamatan-id-7}          |
      | zone      | {KEY_SORT_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {auto-province-id-7}  |
      | kota      | {auto-kota-id-7}      |
      | kecamatan | {auto-kecamatan-id-7} |
    Then Operator verifies new address datasource is added:
      | province    | {auto-province-id-7}  |
      | kota        | {auto-kota-id-7}      |
      | kecamatan   | {auto-kecamatan-id-7} |
      | latitude    | {latitude-2}          |
      | longitude   | {longitude-2}         |
      | whitelisted | True                  |

  Scenario: ID Address Datasource - Edit Row - Invalid LatLong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {created-province}  |
      | kota      | {created-kota}      |
      | kecamatan | {created-kecamatan} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | 91,90 |
    And Operator verify the latlong error alert:
      | latlongError | Latitude must between -90 to 90 degrees |
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | 89.11111,181 |
    And Operator verify the latlong error alert:
      | latlongError | Longitude must between -180 to 180 degrees |
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | 89.11111,180 |
    And Operator verify the latlong error alert:
      | latlongError | Longitude must be at minimum 5 decimal places |
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | , |
    And Operator verify the latlong error alert:
      | latlongError | Please provide latitude |
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | 89.11111, |
    And Operator verify the latlong error alert:
      | latlongError | Please provide longitude |

  Scenario: ID Address Datasource - Edit Row Form - Delete
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {auto-province-id-8}       |
      | kota        | {auto-kota-id-8}           |
      | kecamatan   | {auto-kecamatan-id-8}      |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {auto-province-id-8}           |
      | kota      | {auto-kota-id-8}               |
      | kecamatan | {auto-kecamatan-id-8}          |
      | zone      | {KEY_SORT_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {auto-province-id-8}  |
      | kota      | {auto-kota-id-8}      |
      | kecamatan | {auto-kecamatan-id-8} |
    When Operator clicks on Edit Button on Address Datasource Page
    When Operator clicks on Delete Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {auto-province-id-8}  |
      | kota      | {auto-kota-id-8}      |
      | kecamatan | {auto-kecamatan-id-8} |
    Then Operator verifies no result found on Address Datasource page

  @DeleteAddressDatasourceCommonV2
  Scenario: ID Address Datasource - Edit Row Form Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {auto-province-id-9}       |
      | kota        | {auto-kota-id-9}           |
      | kecamatan   | {auto-kecamatan-id-9}      |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {auto-province-id-9}           |
      | kota      | {auto-kota-id-9}               |
      | kecamatan | {auto-kecamatan-id-9}          |
      | zone      | {KEY_SORT_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {auto-province-id-9}  |
      | kota      | {auto-kota-id-9}      |
      | kecamatan | {auto-kecamatan-id-9} |
    Then Operator verifies new address datasource is added:
      | province    | {auto-province-id-9}  |
      | kota        | {auto-kota-id-9}      |
      | kecamatan   | {auto-kecamatan-id-9} |
      | latitude    | {latitude-2}          |
      | longitude   | {longitude-2}         |
      | whitelisted | True                  |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | province  | {auto-province-id-duplicate}  |
      | kota      | {auto-kota-id-duplicate}      |
      | kecamatan | {auto-kecamatan-id-duplicate} |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {auto-province-id-duplicate}   |
      | kota      | {auto-kota-id-duplicate}       |
      | kecamatan | {auto-kecamatan-id-duplicate}  |
      | zone      | {KEY_SORT_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    And Operator verify the data source toast disappears
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    And Operator verify the data source toast disappears
    And Operator refresh page v1
    When Operator search the existing address datasource:
      | province  | {auto-province-id-duplicate}  |
      | kota      | {auto-kota-id-duplicate}      |
      | kecamatan | {auto-kecamatan-id-duplicate} |
    Then Operator verifies new address datasource is added:
      | province    | {auto-province-id-duplicate}  |
      | kota        | {auto-kota-id-duplicate}      |
      | kecamatan   | {auto-kecamatan-id-duplicate} |
      | latitude    | {latitude-2}                  |
      | longitude   | {longitude-2}                 |
      | whitelisted | True                          |

  @DeleteAddressDatasourceCommonV2
  Scenario: ID Address Datasource - Edit Row - Whitelisted
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {auto-province-id-10}      |
      | kota        | {auto-kota-id-10}          |
      | kecamatan   | {auto-kecamatan-id-10}     |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {auto-province-id-10}          |
      | kota      | {auto-kota-id-10}              |
      | kecamatan | {auto-kecamatan-id-10}         |
      | zone      | {KEY_SORT_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {auto-province-id-10}  |
      | kota      | {auto-kota-id-10}      |
      | kecamatan | {auto-kecamatan-id-10} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | whitelisted | False |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province  | {auto-province-id-10}          |
      | kota      | {auto-kota-id-10}              |
      | kecamatan | {auto-kecamatan-id-10}         |
      | zone      | {KEY_SORT_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {auto-province-id-10}  |
      | kota      | {auto-kota-id-10}      |
      | kecamatan | {auto-kecamatan-id-10} |
    Then Operator verifies new address datasource is added:
      | province    | {auto-province-id-10}  |
      | kota        | {auto-kota-id-10}      |
      | kecamatan   | {auto-kecamatan-id-10} |
      | latitude    | {latitude-2}           |
      | longitude   | {longitude-2}          |
      | whitelisted | False                  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op