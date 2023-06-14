@Sort @AddressingPart1
Feature: Addressing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteAddress
  Scenario: Add Address SG
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on "Singapore" Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page:
      | postcode   | {KEY_CREATED_ADDRESSING.postcode}   |
      | streetName | {KEY_CREATED_ADDRESSING.streetName} |
      | buildingNo | {KEY_CREATED_ADDRESSING.buildingNo} |
      | latitude   | {KEY_CREATED_ADDRESSING.latitude}   |
      | longitude  | {KEY_CREATED_ADDRESSING.longitude}  |

  @DeleteAddress
  Scenario: Search Address
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on "Singapore" Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page:
      | postcode   | {KEY_CREATED_ADDRESSING.postcode}   |
      | streetName | {KEY_CREATED_ADDRESSING.streetName} |
      | buildingNo | {KEY_CREATED_ADDRESSING.buildingNo} |
      | latitude   | {KEY_CREATED_ADDRESSING.latitude}   |
      | longitude  | {KEY_CREATED_ADDRESSING.longitude}  |

  @DeleteAddress
  Scenario: Delete Address
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on "Singapore" Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    When Operator delete address on Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | ^Success delete address.* |
      | waitUntilInvisible | true                      |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}" address on Addressing Page
    Then Operator verifies the address does not exist on Addressing Page

  @DeleteAddress
  Scenario: Edit Address
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on "Singapore" Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    And Operator edits the address on Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success update address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_EDITED_ADDRESSING.buildingNo}, {KEY_EDITED_ADDRESSING.buildingName}, {KEY_EDITED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page:
      | postcode   | {KEY_EDITED_ADDRESSING.postcode}   |
      | streetName | {KEY_EDITED_ADDRESSING.streetName} |
      | buildingNo | {KEY_EDITED_ADDRESSING.buildingNo} |
      | latitude   | {KEY_EDITED_ADDRESSING.latitude}   |
      | longitude  | {KEY_EDITED_ADDRESSING.longitude}  |

  @DeleteAddress
  Scenario: Add Address ID
    Given Operator change the country to "Indonesia"
    And Operator refresh page
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on "Indonesia" Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page to Return Default Value:
      | postcode    | {addressing-default-postcode}     |
      | streetName  | {addressing-default-streetname}   |
      | latitude    | {addressing-default-latitude-id}  |
      | longitude   | {addressing-default-longitude-id} |
      | province    | {addressing-default-province}     |
      | city        | {addressing-default-city}         |
      | source      | {addressing-default-source}       |
      | addresstype | {addressing-default-addresstype}  |

  @DeleteAddress
  Scenario: Add Address TH
    Given Operator change the country to "Thailand"
    And Operator refresh page
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on "Thailand" Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page to Return Default Value:
      | postcode    | {addressing-default-postcode}     |
      | streetName  | {addressing-default-streetname}   |
      | latitude    | {addressing-default-latitude-th}  |
      | longitude   | {addressing-default-longitude-th} |
      | province    | {addressing-default-province}     |
      | city        | {addressing-default-city}         |
      | source      | {addressing-default-source}       |
      | addresstype | {addressing-default-addresstype}  |

  @DeleteAddress
  Scenario: Add Address VN
    Given Operator change the country to "Vietnam"
    And Operator refresh page
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on "Vietnam" Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page to Return Default Value:
      | postcode    | {addressing-default-postcode}     |
      | streetName  | {addressing-default-streetname}   |
      | latitude    | {addressing-default-latitude-vn}  |
      | longitude   | {addressing-default-longitude-vn} |
      | province    | {addressing-default-province}     |
      | city        | {addressing-default-city}         |
      | source      | {addressing-default-source}       |
      | addresstype | {addressing-default-addresstype}  |

  @DeleteAddress
  Scenario: Add Address MY
    Given Operator change the country to "Malaysia"
    And Operator refresh page
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on "Malaysia" Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page to Return Default Value:
      | postcode    | {addressing-default-postcode}     |
      | streetName  | {addressing-default-streetname}   |
      | latitude    | {addressing-default-latitude-my}  |
      | longitude   | {addressing-default-longitude-my} |
      | province    | {addressing-default-province}     |
      | city        | {addressing-default-city}         |
      | source      | {addressing-default-source}       |
      | addresstype | {addressing-default-addresstype}  |

  @DeleteAddres
  Scenario: Add Address PH
    Given Operator change the country to "Philippines"
    And Operator refresh page
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on "Philippines" Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page to Return Default Value:
      | postcode    | {addressing-default-postcode}     |
      | streetName  | {addressing-default-streetname}   |
      | latitude    | {addressing-default-latitude-ph}  |
      | longitude   | {addressing-default-longitude-ph} |
      | province    | {addressing-default-province}     |
      | city        | {addressing-default-city}         |
      | source      | {addressing-default-source}       |
      | addresstype | {addressing-default-addresstype}  |

  @DeleteAddress
  Scenario: Create Order from Existing Address
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on "Singapore" Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "Niko","contact": "+659143425","email": "test@mail.co","phone_number": "+659143429","address": {"address1": "{KEY_CREATED_ADDRESSING.streetName}","address2": "", "country": "SG","postcode": "{KEY_CREATED_ADDRESSING.postcode}"}},"parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator switch to edit order page using direct URL
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                                                                       |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: Click to reveal (tracked) \|\|\|\|112233 Zone ID: 1 Destination Hub ID: 1 Lat, Long: {KEY_CREATED_ADDRESSING.latitude}, {KEY_CREATED_ADDRESSING.longitude} Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op