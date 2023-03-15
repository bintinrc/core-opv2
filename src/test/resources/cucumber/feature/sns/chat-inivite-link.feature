@NinjaChat
Feature: OPv2 - Chat Invite Link

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Chat Invite Link - Shipper Link
    Given Operator go to menu Customer Experience -> Chat Invite Link
    And Operator generate link for shipper using "{shipper-v4-legacy-id}"
    Then Verify shipper name "{shipper-v4-name}" and contact "{shipper-v4-contact}" on chat invite link page
    Then Operator gets generated chat invite link
    When WebDriver open this url "{KEY_SNS_CHAT_INVITE_LINK}"
    Then Verify user is redirected to "consignee-support" page

  Scenario: Chat Invite Link - Consignee Link
    Given Operator go to menu Customer Experience -> Chat Invite Link
    And Operator generate link for consignee using phone number "359392"
    Then Operator gets generated chat invite link
    When WebDriver open this url "{KEY_SNS_CHAT_INVITE_LINK}"
    Then Verify user is redirected to "consignee-support" page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
