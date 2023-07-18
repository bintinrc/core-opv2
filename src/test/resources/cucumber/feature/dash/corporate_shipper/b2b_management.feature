@MileZero @CorporateHQ @WithSg
Feature: B2B Management

  @LaunchBrowser @ShouldAlwaysRun @DeleteCorporateSubShipper
  Scenario: Go to master shipper details page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given API Operator get b2b sub shippers for master shipper id "{postpaid-corporate-hq-id}"
    When Operator go to menu Shipper -> All Shippers
    And Operator open Edit Shipper Page of shipper "{postpaid-corporate-hq-legacy-id}-"

  Scenario Outline: Create sub shipper with empty branch id field on shipper settings (<hiptest-uid>)
    When Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId |           |
      | name     | generated |
      | email    | generated |
    Then Operator verifies error message "Branch ID (External Ref) must be filled." is displayed on b2b management page

    Examples:
      | hiptest-uid                              |
      | uid:0753d045-341d-4381-8d4c-9cef90812756 |

  Scenario Outline: Create sub shipper with empty name field on shipper settings (<hiptest-uid>)
    When Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     |           |
      | email    | generated |
    Then Operator verifies error message "Name must be filled." is displayed on b2b management page

    Examples:
      | hiptest-uid                              |
      | uid:0c7d0a6f-93de-44cc-a609-f994d5f0ae0c |

  Scenario Outline: Create sub shipper with empty email field on shipper settings (<hiptest-uid>)
    When Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    |           |
    Then Operator verifies error message "Email must be filled." is displayed on b2b management page

    Examples:
      | hiptest-uid                              |
      | uid:700ec24d-ccd1-4c86-a715-9d88a69a91a5 |

  Scenario Outline: Create sub shipper with invalid email format on shipper settings (<hiptest-uid>)
    When Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | wrongForm |
    Then Operator verifies error message "Email not formatted as _@_._" is displayed on b2b management page

    Examples:
      | hiptest-uid                              |
      | uid:ce0bf69e-92dd-4e72-9012-9a449b4b4d8f |

  Scenario Outline: Create sub shipper with existing branch ID on shipper settings (<hiptest-uid>)
    When Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created
    And Operator create corporate sub shipper with data below:
      | branchId | {KEY_SUB_SHIPPER_SELLER_ID} |
      | name     | generated                   |
      | email    | generated                   |
    Then Operator verifies error message "Error creating this sub-shipper. Please try again." is displayed on b2b management page

    Examples:
      | hiptest-uid                              |
      | uid:8cacbec8-868f-4298-8d02-d90b0453829e |

  @ShouldAlwaysRun
  Scenario Outline: Create sub shipper on shipper settings (<hiptest-uid>)
    When Operator go to tab corporate sub shipper
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created

    Examples:
      | hiptest-uid                              |
      | uid:678abdf3-d232-437c-8e14-b267561be0e9 |

  Scenario Outline: View list of sub shippers (<hiptest-uid>)
    When API Operator get b2b sub shippers for master shipper id "<masterShipperId>"
    Then Operator verifies corporate sub shipper is correct

    Examples:
      | masterShipperId                  | hiptest-uid                              |
      | {operator-b2b-master-shipper-id} | uid:ed3c11a3-2c61-42c0-8ef4-e892bf6065ab |

  Scenario Outline: Search sub shippers by name (<hiptest-uid>)
    When Operator go to tab corporate sub shipper
    And Operator search corporate sub shipper by name with "<searchValue>"
    Then Operator verifies corporate sub shippers with name contains "<searchValue>" is displayed

    Examples:
      | searchValue | hiptest-uid                              |
      | sub shipper | uid:c49d2be8-e535-45a1-9781-09e6d3857226 |

  Scenario Outline: Search sub shippers by email (<hiptest-uid>)
    When Operator go to tab corporate sub shipper
    And Operator search corporate sub shipper by email with "<searchValue>"
    Then Operator verifies corporate sub shippers with email contains "<searchValue>" is displayed

    Examples:
      | searchValue | hiptest-uid                              |
      | sub.shipper | uid:3aa9758b-2f85-43e3-8f99-adc34c71a868 |


  Scenario Outline: Edit sub shippers on shipper settings (<hiptest-uid>)
    When Operator go to tab corporate sub shipper
    And Operator click edit action button for first corporate sub shipper
    Then Operator verifies corporate sub shipper details page is displayed

    Examples:
      | hiptest-uid                              |
      | uid:9268ca97-0365-4075-bfa5-e3f8b12db9ac |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op