package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.HubUserManagementPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.Date;
import java.util.Map;
import java.util.Objects;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HubUserManagementSteps extends AbstractSteps {

  private HubUserManagementPage hubUserManagementPage;
  private static final Logger LOGGER = LoggerFactory.getLogger(FirstMileZonesSteps.class);

  public HubUserManagementSteps() {
  }

  @Override
  public void init() {
    hubUserManagementPage = new HubUserManagementPage(getWebDriver());

  }

  @When("Operator click edit button {string} on Hub User Management Page")
  public void operatorClickEditButtonOnHubUserManagementPage(String hubId) {
    String editXpath = String.format(hubUserManagementPage.XPATH_OF_EDIT_BUTTON, hubId);
    hubUserManagementPage.waitUntilPageLoaded();
    hubUserManagementPage.switchTo();
    hubUserManagementPage.findElementByXpath(editXpath).click();
    hubUserManagementPage.waitUntilPageLoaded();
  }

  @When("Operator click select hub on Hub User Management Page")
  public void operatorClickSelectHubOnHubUserManagementPage(Map<String, String> data) {

    data = resolveKeyValues(data);
    String hubName = data.get("hubName");
    if (StringUtils.isBlank(hubName)) {
      throw new IllegalArgumentException("hubName parameter was not provided");
    }
    if (hubUserManagementPage.selectHub.isDisplayedFast()) {
      hubUserManagementPage.selectHub.click();
    }
    hubUserManagementPage.selectHub.selectValue(hubName);
    pause5s();
  }

  @Then("Operator verifies redirect to correct {string} Hub User Management Page")
  public void operatorVerifiesRedirectToCorrectHubUserManagementPage(String titleName) {
    hubUserManagementPage.waitUntilPageLoaded();
    hubUserManagementPage.switchTo();
    Assertions.assertThat(hubUserManagementPage.findElementByXpath(
            String.format(hubUserManagementPage.hubTitleXpath, titleName)).getText())
        .as("User is redirected to Correct Hub " + titleName)
        .isEqualToIgnoringCase(titleName);
  }

  @When("Operator bulk upload hub user using a {string} CSV file")
  public void operatorBulkUploadHubUserUsingACSVFile(String fileName) {
    final String csvFileName = "csv/" + fileName;
    final ClassLoader classLoader = getClass().getClassLoader();
    File csvFile = new File(
        Objects.requireNonNull(classLoader.getResource(csvFileName)).getFile());
    hubUserManagementPage.bulkAssignButton.waitUntilClickable();
    hubUserManagementPage.bulkAssignButton.click();
    hubUserManagementPage.uploadCsvFile(csvFile);
    hubUserManagementPage.submitCsvFile.click();
    hubUserManagementPage.waitUntilPageLoaded();
  }

  @Then("Operator verifies the error details in modal:")
  public void operatorVerifiesTheErrorDetailsInModal(Map<String, String> data) {
    data = resolveKeyValues(data);
    String modalTitle = data.get("modalTitle");
    String modalBody = data.get("modalBody");
    pause3s();
    hubUserManagementPage.switchTo();
    Assertions.assertThat(hubUserManagementPage.errorTitle.getText()).as("Modal Title is True")
        .isEqualToIgnoringCase(modalTitle);
    Assertions.assertThat(hubUserManagementPage.errorBody.getText()).as("Modal Body is True")
        .isEqualToIgnoringCase(modalBody);

  }

  @Then("Make sure it show error {string} exceeds the maximum size")
  public void makeSureItShowErrorExceedsTheMaximumSize(String csv) {
    Assertions.assertThat(hubUserManagementPage.errorExceedMaximumSize.getText())
        .as("Error Message is True")
        .isEqualToIgnoringCase("Error: " + csv + " exceeds the maximum size.");
  }

  @When("Operator click add user button on Hub User Management Page")
  public void operatorClickAddUserButtonOnHubUserManagementPage() {
    hubUserManagementPage.waitWhilePageIsLoading();
    hubUserManagementPage.addUserButton.click();
  }

  @When("Operator input {string} user email")
  public void operatorInputUserEmail(String email) {
    hubUserManagementPage.emailInput.sendKeys((email));
    hubUserManagementPage.addButton.click();
  }

  @Then("Make sure add button is disabled")
  public void makeSureAddButtonIsDisabled() {
    Assertions.assertThat(hubUserManagementPage.disabledAddButton.isDisplayedFast())
        .as("Add Button is Disabled")
        .isTrue();
  }

  @Then("Operator verifies that success react notification displayed in Hub User Management Page:")
  @Then("Operator verifies that error react notification displayed in Hub User Management Page:")
  public void operatorVerifiesThatErrorReactNotificationDisplayedInHubUserManagementPage(
      Map<String, String> data) {
    hubUserManagementPage.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      boolean waitUntilInvisible = Boolean.parseBoolean(
          finalData.getOrDefault("waitUntilInvisible", "false"));
      long start = new Date().getTime();
      AntNotification toastInfo;
      do {
        toastInfo = hubUserManagementPage.noticeNotifications.stream().filter(toast -> {
          String actualTop = toast.message.getNormalizedText();
          LOGGER.info("Found notification: " + actualTop);
          String value = finalData.get("top");
          if (StringUtils.isNotBlank(value)) {
            if (value.startsWith("^")) {
              if (!actualTop.matches(value)) {
                return false;
              }
            } else {
              if (!StringUtils.equalsIgnoreCase(value, actualTop)) {
                return false;
              }
            }
          }
          value = finalData.get("bottom");
          if (StringUtils.isNotBlank(value)) {
            String actual = toast.description.getNormalizedText();
            if (value.startsWith("^")) {
              return actual.matches(value);
            } else {
              return StringUtils.equalsIgnoreCase(value, actual);
            }
          }
          return true;
        }).findFirst().orElse(null);
      } while (toastInfo == null && new Date().getTime() - start < 20000);
      Assertions.assertThat(toastInfo != null).as("Toast " + finalData + " is displayed").isTrue();
      if (toastInfo != null && waitUntilInvisible) {
        toastInfo.waitUntilInvisible();
      }
    });
  }

  @When("Operator click remove button for {string} on Hub User Management Page")
  public void operatorClickRemoveButtonForOnHubUserManagementPage(String userId) {
    String editXpath = String.format(hubUserManagementPage.XPATH_OF_REMOVE_USER_BUTTON, userId);
    hubUserManagementPage.findElementByXpath(editXpath).click();
  }

  @When("Operator click on remove button on remove user modal")
  public void operatorClickOnRemoveButtonOnRemoveUserModal() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      hubUserManagementPage.removeButton.click();
    }, 1000, 5);
  }

  @Then("Operator verify hub user parameter:")
  public void operatorVerifyHubUserParameter(Map<String, String> data) {
    Map<String, String> userData = resolveKeyValues(data);
    String username = String.format(hubUserManagementPage.XPATH_OF_USERNAME,
        userData.get("username"));
    switch (userData.get("check")) {
      case "Added":
        Assertions.assertThat(hubUserManagementPage.findElementByXpath(username).isDisplayed())
            .as("User is Added")
            .isTrue();
        break;
      case "Removed":
        Assertions.assertThat(hubUserManagementPage.isElementExist(username))
            .as("User is Removed")
            .isFalse();
        break;
    }
  }
}
