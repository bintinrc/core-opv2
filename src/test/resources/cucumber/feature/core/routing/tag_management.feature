@OperatorV2 @Core @Routing  @TagManagement
Feature: Tag Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteTagsV2 @MediumPriority
  Scenario: Operator Create New Tag on Tag Management Page
    When Operator go to menu Routing -> Tag Management
    And Tag Management page is loaded
    And Operator create new route tag on Tag Management page:
      | name        | AAA                         |
      | description | This tag AAA is for testing |
    Then Operator verifies that success react notification displayed:
      | top | Tag created |
    When Operator refresh page
    Then Operator verifies tag on Tag Management page:
      | name        | KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS[1].name        |
      | description | KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS[1].description |

  @DeleteRouteTagsV2 @MediumPriority
  Scenario: Operator Update Created Tag on Tag Management Page
    And API Route - create new route tag:
      | name        | ABC                    |
      | description | ABC tag is for testing |
    When Operator go to menu Routing -> Tag Management
    And Tag Management page is loaded
    And Operator update "KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS[1].name" tag on Tag Management page:
      | name        | UPT                             |
      | description | UPT tag is for testing [EDITED] |
    Then Operator verifies that success react notification displayed:
      | top | Tag successfully edited |
    Then Operator verifies tag on Tag Management page:
      | name        | UPT                             |
      | description | UPT tag is for testing [EDITED] |

  @DeleteRouteTagsV2 @MediumPriority
  Scenario: Operator Search Created Tag on Tag Management Page
    And API Route - create new route tag:
      | name        | ABE                    |
      | description | ABE tag is for testing |
    When Operator go to menu Routing -> Tag Management
    And Tag Management page is loaded
    Then Operator search tag on Tag Management page:
      | column | name                                         |
      | value  | KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS{[1].name |
    Then Operator verifies search result on Tag Management page:
      | name        | KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS[1].name        |
      | description | KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS[1].description |
    Then Operator search tag on Tag Management page:
      | column | description                                        |
      | value  | KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS[1].description |
    Then Operator verifies search result on Tag Management page:
      | name        | KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS[1].name        |
      | description | KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS[1].description |