@RouteGroupTemplates @selenium
Feature: Route Group Templates

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create, update and delete 'route group template' on 'Route Group Templates'. (uid:a49a930e-1fb2-4a0c-8a8f-8bbccc5d87cc)
    Given op click navigation Route Group Templates in Routing
    When op create new 'route group template' on 'Route Group Templates'
#    Then new 'route group template' on 'Route Group Templates' created successfully
#    When op update 'route group template' on 'Route Group Templates'
#    Then 'route group template' on 'Route Group Templates' updated successfully
#    When op delete 'route group template' on 'Route Group Templates'
#    Then 'route group template' on 'Route Group Templates' deleted successfully

  @KillBrowser
  Scenario: Kill Browser
