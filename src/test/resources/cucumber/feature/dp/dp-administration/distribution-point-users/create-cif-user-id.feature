@OperatorV2Id @Dp @CIF @CreateCifUserId
Feature: DP Administration - Distribution Point Users

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    When API Operator whitelist email "{check-dp-user-email}"

  @DeleteDpManagementPartnerDpAndDpUser
  Scenario: DP Administration - CIF - Create DP User - Check email notifications
    Given operator marks gmail messages as read
    Given Operator go to menu Distribution Points -> DP Administration
    And Operator refresh page
    Then The Dp Administration page is displayed
    And Operator fill the partner filter by "id" with value "{check-partner-id}"
    And Operator press view DP Button
    Then The Dp page is displayed
    And Operator fill the Dp list filter by "id" with value "{check-dp-id}"
    Then Operator press view DP User Button
    Then The Dp page is displayed
    And Operator press add user Button
    When Operator Fill Dp User Details below :
      | firstName | lastName | contactNo           | emailId               |
      | Diaz      | Ilyasa   | {default-phone-num} | {check-dp-user-email} |
    Then Operator press submit user button
    And Verifies email with details:
      | credentialsUsername | {npv3-gmailclient-email}                 |
      | credentialsPassword | {npv3-gmailclient-password}              |
      | expectedSubject     | {ninja-point-email-announcement-subject} |
      | emailBody           | {ninja-point-email-announcement-body}    |
    And Verifies email with details:
      | credentialsUsername | {npv3-gmailclient-email}                 |
      | credentialsPassword | {npv3-gmailclient-password}              |
      | expectedSubject     | {ninja-point-password-temporary-subject} |
      | emailBody           | {ninja-point-password-temporary-body}    |
    Then Operator check the email for newly created CIF user from data below:
      | email | {KEY_LIST_OF_EMAIL_BODY[1]} |
      | key   | {subject-email-check}       |
    Then Operator check the email for newly created CIF user from data below:
      | email | {KEY_LIST_OF_EMAIL_BODY[2]}        |
      | key   | {subject-temporary-password-check} |