@Sort @AddressDataSourcePhPart3
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun @BeforeDeleteAddressCommonV2
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: PH Address Datasource - Edit Row - Invalid LatLong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province     | {created-province}     |
      | municipality | {created-municipality} |
      | barangay     | {created-barangay}     |
      | whitelisted  | True                   |
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

  Scenario: PH Address Datasource - Edit Row Form - Delete
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | {latitude-2},{longitude-2} |
      | province     | {auto-province-ph-6}       |
      | municipality | {auto-municipality-ph-6}   |
      | barangay     | {auto-barangay-ph-6}       |
      | whitelisted  | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {auto-province-ph-6}           |
      | municipality | {auto-municipality-ph-6}       |
      | barangay     | {auto-barangay-ph-6}           |
      | zone         | {KEY_SORT_ZONE_INFO.shortName} |
      | hub          | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province     | {auto-province-ph-6}     |
      | municipality | {auto-municipality-ph-6} |
      | barangay     | {auto-barangay-ph-6}     |
    When Operator clicks on Edit Button on Address Datasource Page
    When Operator clicks on Delete Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |

  Scenario: PH Address Datasource - Edit Row Form Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | {latitude-2},{longitude-2} |
      | province     | {auto-province-ph-7}       |
      | municipality | {auto-municipality-ph-7}   |
      | barangay     | {auto-barangay-ph-7}       |
      | whitelisted  | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {auto-province-ph-7}           |
      | municipality | {auto-municipality-ph-7}       |
      | barangay     | {auto-barangay-ph-7}           |
      | zone         | {KEY_SORT_ZONE_INFO.shortName} |
      | hub          | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province     | {auto-province-ph-7}     |
      | municipality | {auto-municipality-ph-7} |
      | barangay     | {auto-barangay-ph-7}     |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | province     | {auto-province-ph-duplicate}     |
      | municipality | {auto-municipality-ph-duplicate} |
      | barangay     | {auto-barangay-ph-duplicate}     |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {auto-province-ph-duplicate}     |
      | municipality | {auto-municipality-ph-duplicate} |
      | barangay     | {auto-barangay-ph-duplicate}     |
      | zone         | {KEY_SORT_ZONE_INFO.shortName}   |
      | hub          | {KEY_HUB_DETAILS.shortName}      |
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
      | province     | {auto-province-ph-duplicate}     |
      | municipality | {auto-municipality-ph-duplicate} |
      | barangay     | {auto-barangay-ph-duplicate}     |

  Scenario: PH Address Datasource - Edit Row - with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province     | {created-province}     |
      | municipality | {created-municipality} |
      | barangay     | {created-barangay}     |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | province     | EMPTY |
      | municipality | EMPTY |
      | barangay     | EMPTY |
    And Operator verifies empty field error shows up in address datasource page

  Scenario: PH Address Datasource - View Zone and Hub match - Existing Row
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator search the existing address datasource:
      | province     | {created-province}     |
      | municipality | {created-municipality} |
      | barangay     | {created-barangay}     |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1}    |
      | zone    | {KEY_SORT_ZONE_INFO.shortName} |
      | hub     | {KEY_HUB_DETAILS.shortName}    |


  Scenario: PH Address Datasource - View Zone and Hub Match - New Added Row
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | {latitude-1},{longitude-1} |
      | province     | {auto-province-ph-8}       |
      | municipality | {auto-municipality-ph-8}   |
      | barangay     | {auto-barangay-ph-8}       |
      | whitelisted  | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {KEY_SORT_CREATED_ADDRESS.province} |
      | municipality | {KEY_SORT_CREATED_ADDRESS.city}     |
      | barangay     | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone         | {KEY_SORT_ZONE_INFO.shortName}      |
      | hub          | {KEY_HUB_DETAILS.shortName}         |
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
      | whitelisted  | True                                 |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1}    |
      | zone    | {KEY_SORT_ZONE_INFO.shortName} |
      | hub     | {KEY_HUB_DETAILS.shortName}    |


  Scenario: PH Address Datasource - View Zone and Hub Match - Edited Row - LatLong
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | {latitude-1},{longitude-1} |
      | province     | {auto-province-ph-9}       |
      | municipality | {auto-municipality-ph-9}   |
      | barangay     | {auto-barangay-ph-9}       |
      | whitelisted  | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province     | {KEY_SORT_CREATED_ADDRESS.province} |
      | municipality | {KEY_SORT_CREATED_ADDRESS.city}     |
      | barangay     | {KEY_SORT_CREATED_ADDRESS.district} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | {latitude-2},{longitude-2} |
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-2}, "longitude":{longitude-2}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {auto-province-ph-9}           |
      | municipality | {auto-municipality-ph-9}       |
      | barangay     | {auto-barangay-ph-9}           |
      | zone         | {KEY_SORT_ZONE_INFO.shortName} |
      | hub          | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    Then Operator verifies new address datasource is added:
      | province     | {auto-province-ph-9}     |
      | municipality | {auto-municipality-ph-9} |
      | barangay     | {auto-barangay-ph-9}     |
      | latitude     | {latitude-2}             |
      | longitude    | {longitude-2}            |
      | whitelisted  | True                     |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-2}, {longitude-2}    |
      | zone    | {KEY_SORT_ZONE_INFO.shortName} |
      | hub     | {KEY_HUB_DETAILS.shortName}    |


  Scenario: PH Address Datasource - Edit Row - Whitelisted
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong      | {latitude-1},{longitude-1} |
      | province     | {auto-province-ph-10}      |
      | municipality | {auto-municipality-ph-10}  |
      | barangay     | {auto-barangay-ph-10}      |
      | whitelisted  | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {KEY_SORT_CREATED_ADDRESS.province} |
      | municipality | {KEY_SORT_CREATED_ADDRESS.city}     |
      | barangay     | {KEY_SORT_CREATED_ADDRESS.district} |
      | zone         | {KEY_SORT_ZONE_INFO.shortName}      |
      | hub          | {KEY_HUB_DETAILS.shortName}         |
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
      | whitelisted  | True                                 |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | whitelisted | False |
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province     | {auto-province-ph-10}          |
      | municipality | {auto-municipality-ph-10}      |
      | barangay     | {auto-barangay-ph-10}          |
      | zone         | {KEY_SORT_ZONE_INFO.shortName} |
      | hub          | {KEY_HUB_DETAILS.shortName}    |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province     | {auto-province-ph-10}     |
      | municipality | {auto-municipality-ph-10} |
      | barangay     | {auto-barangay-ph-10}     |
    Then Operator verifies new address datasource is added:
      | province     | {auto-province-ph-10}     |
      | municipality | {auto-municipality-ph-10} |
      | barangay     | {auto-barangay-ph-10}     |
      | latitude     | {latitude-1}              |
      | longitude    | {longitude-1}             |
      | whitelisted  | False                     |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op