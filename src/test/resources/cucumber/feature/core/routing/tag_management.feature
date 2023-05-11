@OperatorV2 @Core @Routing @RoutingJob1 @TagManagement
Feature: Tag Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteTags
  Scenario: Operator Create New Tag on Tag Management Page
    When Operator go to menu Routing -> Tag Management
    And Tag Management page is loaded
    And Operator create new route tag on Tag Management page:
      | name        | AAA                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    Then Operator verifies that success react notification displayed:
      | top | Tag created |
    When Operator refresh page
    Then Operator verifies tag on Tag Management page:
      | name        | {KEY_CREATED_ROUTE_TAG.name}        |
      | description | {KEY_CREATED_ROUTE_TAG.description} |

  @DeleteRouteTags
  Scenario: Operator Update Created Tag on Tag Management Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route tag:
      | name        | AAA                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    When Operator go to menu Routing -> Tag Management
    And Tag Management page is loaded
    And Operator update created tag on Tag Management page:
      | name        | AAC                                                                                        |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. [EDITED] |
    Then Operator verifies that success react notification displayed:
      | top                | Tag successfully edited |
      | waitUntilInvisible | true                    |
    Then Operator verifies tag on Tag Management page:
      | name        | {KEY_CREATED_ROUTE_TAG.name}        |
      | description | {KEY_CREATED_ROUTE_TAG.description} |

  @DeleteRouteTags
  Scenario: Operator Search Created Tag on Tag Management Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route tag:
      | name        | AAA                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    When Operator go to menu Routing -> Tag Management
    And Tag Management page is loaded
    Then Operator search tag on Tag Management page:
      | column | name                         |
      | value  | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verifies search result on Tag Management page:
      | name        | {KEY_CREATED_ROUTE_TAG.name}        |
      | description | {KEY_CREATED_ROUTE_TAG.description} |
    Then Operator search tag on Tag Management page:
      | column | description                         |
      | value  | {KEY_CREATED_ROUTE_TAG.description} |
    Then Operator verifies search result on Tag Management page:
      | name        | {KEY_CREATED_ROUTE_TAG.name}        |
      | description | {KEY_CREATED_ROUTE_TAG.description} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op