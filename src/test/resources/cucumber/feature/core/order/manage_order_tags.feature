@OperatorV2 @Core @Order @ManageOrderTags
Feature: Manage Order Tags

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrderTagsV2
  Scenario: Operator Create Order Tag
    Given Operator go to menu Order -> Manage Order Tags
    When Operator create new route tag on Manage Order Tags page:
      | name        | AAA                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    Then Operator verify the new tag is created successfully on Manage Order Tags page

  @DeleteOrderTagsV2
  Scenario: Operator Delete Order Tag
    And API Core - create new order tag:
      | name        | ABC                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    When Operator go to menu Order -> Manage Order Tags
    And Operator refresh page
    And Operator deletes "{KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].name}" tag on Manage Order Tags page
    Then Operator verifies that success react notification displayed:
      | top | 1 Order Tag Deleted |
    And Operator verifies that "{KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].name}" tag has been deleted on Manage Order Tags page

  @DeleteOrderTagsV2
  Scenario: Operator Search Order Tag
    And API Core - create new order tag:
      | name        | ABD                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    When Operator go to menu Order -> Manage Order Tags
    And Operator refresh page
    And Operator filter tags on Manage Order Tags page:
      | name | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].name} |
    Then Operator verify tag record on Manage Order Tags page:
      | name        | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].name}        |
      | description | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].description} |
    And Operator filter tags on Manage Order Tags page:
      | description | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].description} |
    Then Operator verify tag record on Manage Order Tags page:
      | name        | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].name}        |
      | description | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].description} |
    And Operator filter tags on Manage Order Tags page:
      | name        | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].name}        |
      | description | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].description} |
    Then Operator verify tag record on Manage Order Tags page:
      | name        | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].name}        |
      | description | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].description} |

  @DeleteOrderTagsV2
  Scenario: Operator Fail Create Duplicate Order Tag
    And API Core - create new order tag:
      | name        | ABE                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    When Operator go to menu Order -> Manage Order Tags
    When Operator create new route tag on Manage Order Tags page:
      | name        | ABE                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
      | getId       | false                                                                             |
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Unknown                                            |
      | bottom | ^.*Error Message: Order Tag with Name ABE is already in use!.* |

  @DeleteOrderTagsV2
  Scenario: Operator Fail Delete Order Tag - Not Found
    And API Core - create new order tag:
      | name        | ABF                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    When Operator go to menu Order -> Manage Order Tags
    And Operator refresh page
    And Operator filter tags on Manage Order Tags page:
      | name | {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].name} |
    And API Core - delete "{KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].id}" order tag
    And Operator deletes "{KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].name}" tag without filtering on Manage Order Tags page
    Then Operator verifies that error react notification displayed:
      | top    | Status 404: Not Found                                                                |
      | bottom | ^.*Error Message: Order Tag {KEY_CORE_LIST_OF_CREATED_ORDER_TAGS[1].id} not found!.* |
