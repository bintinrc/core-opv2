@OperatorV2 @DistributionPointsCleaning @DpAdministrationV2 @DP
Feature: DP Administration - Data Cleaning

  Scenario: Cleaning DP Partner Data
    Given DB Operator fetch DP Partner data by email from hibernate:
      | email                              |
      | {default-partners-email}           |
      | {default-partners-dp-email}        |
      | {default-partners-dp-user-email}   |
      | {default-partners-dp-edit-email}   |
      | {default-create-dp-2-email}        |
      | {default-create-partner-api-email} |
    Then API Operator delete DP management partner
      | dpPartners | KEY_LIST_DATABASE_DP_PARTNER |

  Scenario: Cleaning DP User Data
    Given DB Operator fetch DP User data by email from hibernate:
      | email                   |
      | {default-dp-user-email} |
    Then DB Operator delete Dp User
      | dpUsers | KEY_LIST_DATABASE_DP_USER |