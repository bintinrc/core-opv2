@OperatorV2 @AllShippers @LaunchBrowser @EnableClearCache @SelfServePricingProfile
Feature: Self-Serve Pricing Profile Creation Page

  Scenario: Access Self-Serve Pricing Profile Creation without Login OPv2 (uid:d55af73c-b6c0-4b8d-a49a-bb8c722f21f7)
    Given Operator go to this URL "{upload-self_serve-promo-url}"
    Then Operator waits for 3 seconds
    And Operator verifies operator is in login page
