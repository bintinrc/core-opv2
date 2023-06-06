@Sort @AddressDataSourceVnPart3
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteAddressDatasourceCommonV2
  Scenario: VN Address Datasource - View Zone and Hub Match - New Added Row
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | province    | {view-province}            |
      | district    | {view-district}            |
      | ward        | {view-ward}                |
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
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1} |
      | zone    | {KEY_SORT_ZONE_INFO.shortName}   |
      | hub     | {KEY_HUB_INFO.name}         |

  @DeleteAddressDatasourceCommonV2
  Scenario: VN Address Datasource - View Zone and Hub Match - Edited Row - LatLong
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-1},{longitude-1} |
      | province    | {view-province}            |
      | district    | {view-district}            |
      | ward        | {view-ward}                |
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
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | {latitude-2},{longitude-2} |
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province | {view-province}           |
      | district | {view-district}           |
      | ward     | {view-ward}               |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.name}       |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {view-province} |
      | kota      | {view-district} |
      | kecamatan | {view-ward}     |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-2}, {longitude-2} |
      | zone    | {KEY_SORT_ZONE_INFO.shortName}   |
      | hub     | {KEY_HUB_INFO.name}         |

  Scenario: VN Address Datasource - Edit Row Form
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {created-province} |
      | kota      | {created-district} |
      | kecamatan | {created-ward}     |
    When Operator clicks on Edit Button on Address Datasource Page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Edit A Row modal:
      | province | {created-province}        |
      | district | {created-district}        |
      | ward     | {created-ward}            |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.name}       |

  @DeleteAddressDatasourceCommonV2
  Scenario: VN Address Datasource - Edit Row - L1/L2/L3
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {edit-row-province}        |
      | district    | {edit-row-district}        |
      | ward        | {edit-row-ward}            |
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
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_SORT_CREATED_ADDRESS.province}    |
      | kota      | {KEY_SORT_CREATED_ADDRESS.district}    |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | province  | {edit-row-update-province} |
      | kota      | {edit-row-update-district} |
      | kecamatan | {edit-row-update-ward}     |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province | {edit-row-update-province} |
      | district | {edit-row-update-district} |
      | ward     | {edit-row-update-ward}     |
      | zone     | {KEY_SORT_ZONE_INFO.shortName}  |
      | hub      | {KEY_HUB_INFO.name}        |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {edit-row-update-province} |
      | kota      | {edit-row-update-district} |
      | kecamatan | {edit-row-update-ward}     |
    Then Operator verifies new address datasource is added:
      | province    | {edit-row-update-province} |
      | kota        | {edit-row-update-district} |
      | kecamatan   | {edit-row-update-ward}     |
      | latitude    | {latitude-2}               |
      | longitude   | {longitude-2}              |
      | whitelisted | True                       |

  Scenario: VN Address Datasource - Edit Row - Invalid LatLong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {created-province} |
      | kota      | {created-district} |
      | kecamatan | {created-ward}     |
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

  Scenario: VN Address Datasource - Edit Row Form - Delete
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {edit-row-province}        |
      | district    | {edit-row-district}        |
      | ward        | {edit-row-ward}            |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_SORT_CREATED_ADDRESS.province}    |
      | kota      | {KEY_SORT_CREATED_ADDRESS.district}    |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
    When Operator clicks on Edit Button on Address Datasource Page
    When Operator clicks on Delete Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {KEY_SORT_CREATED_ADDRESS.province}    |
      | kota      | {KEY_SORT_CREATED_ADDRESS.district}    |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
    Then Operator verifies no result found on Address Datasource page

  Scenario: VN Address Datasource - Edit Row Form Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {edit-row-province}        |
      | district    | {edit-row-district}        |
      | ward        | {edit-row-ward}            |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {KEY_SORT_CREATED_ADDRESS.province}    |
      | kota      | {KEY_SORT_CREATED_ADDRESS.district}    |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | province  | {edit-row-exist-province} |
      | kota      | {edit-row-exist-district} |
      | kecamatan | {edit-row-exist-ward}     |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province | {edit-row-exist-province} |
      | district | {edit-row-exist-district} |
      | ward     | {edit-row-exist-ward}     |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.name}       |
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
      | province  | {edit-row-exist-province} |
      | kota      | {edit-row-exist-district} |
      | kecamatan | {edit-row-exist-ward}     |
    Then Operator verifies new address datasource is added:
      | province    | {edit-row-exist-province} |
      | kota        | {edit-row-exist-district} |
      | kecamatan   | {edit-row-exist-ward}     |
      | latitude    | {latitude-2}              |
      | longitude   | {longitude-2}             |
      | whitelisted | True                      |

  @DeleteAddressDatasourceCommonV2
  Scenario: VN Address Datasource - Edit Row - Whitelisted
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {edit-row-province}        |
      | district    | {edit-row-district}        |
      | ward        | {edit-row-ward}            |
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
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_SORT_CREATED_ADDRESS.province}    |
      | kota      | {KEY_SORT_CREATED_ADDRESS.district}    |
      | kecamatan | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | whitelisted | False |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province | {edit-row-province}       |
      | district | {edit-row-district}       |
      | ward     | {edit-row-ward}           |
      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
      | hub      | {KEY_HUB_INFO.name}       |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {edit-row-province} |
      | kota      | {edit-row-district} |
      | kecamatan | {edit-row-ward}     |
    Then Operator verifies new address datasource is added:
      | province    | {edit-row-province} |
      | kota        | {edit-row-district} |
      | kecamatan   | {edit-row-ward}     |
      | latitude    | {latitude-2}        |
      | longitude   | {longitude-2}       |
      | whitelisted | False               |

  Scenario: VN Address Datasource - Edit Row - with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {created-province} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | province  | EMPTY |
      | kota      | EMPTY |
      | kecamatan | EMPTY |
    And Operator verifies empty field error shows up in address datasource page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op