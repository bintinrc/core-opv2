package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.HubUserManagementPage;
import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
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
    if (hubUserManagementPage.isElementExist(hubUserManagementPage.XPATH_OF_IFRAME)) {
      hubUserManagementPage.switchTo();
    }
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
    hubUserManagementPage.pause5s();
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

  @Then("Make sure it show error {string} contains no email")
  public void makeSureItShowErrorContainsNoEmail(String csv) {
    Assertions.assertThat(hubUserManagementPage.errorContainsNoEmail.getText())
        .as("Error Message is True")
        .isEqualToIgnoringCase("Error: " + csv + " contains no email");
  }

  @Then("Operator verify bulk hub {string} user is added")
  public void operatorVerifyBulkHubUserIsAdded(String fileName) {
    final String csvFileName = "csv/" + fileName;
    final ClassLoader classLoader = getClass().getClassLoader();
    File csvFile = new File(
        Objects.requireNonNull(classLoader.getResource(csvFileName)).getFile());
    List<String[]> addedUser;
    try (CSVReader csvReader = new CSVReader(new FileReader(csvFile))) {
      addedUser = csvReader.readAll();
    } catch (IOException | CsvException e) {
      throw new RuntimeException(e);
    }
    for (int i = 1; i < addedUser.size(); i++) {
      String username = String.format(hubUserManagementPage.XPATH_OF_USERNAME,
          Arrays.toString(addedUser.get(i)).replace("[", "").replace("]", "")
              .replace("@gmail.com", ""));
      Assertions.assertThat(
              hubUserManagementPage.findElementByXpath(username).isDisplayed())
          .as("User " + Arrays.toString(addedUser.get(i)) + " is Added")
          .isTrue();
    }
  }

  @Then("Operator remove all {string} added user")
  public void operatorRemoveAllAddedUser(String fileName) {
    final String csvFileName = "csv/" + fileName + "_id";
    final ClassLoader classLoader = getClass().getClassLoader();
    File csvFile = new File(
        Objects.requireNonNull(classLoader.getResource(csvFileName)).getFile());
    List<String[]> removeUser;
    try (CSVReader csvReader = new CSVReader(new FileReader(csvFile))) {
      removeUser = csvReader.readAll();
    } catch (IOException | CsvException e) {
      throw new RuntimeException(e);
    }
    for (int i = 1; i < removeUser.size(); i++) {
      String editXpath = String.format(hubUserManagementPage.XPATH_OF_REMOVE_USER_BUTTON,
          Arrays.toString(removeUser.get(i)).replace("[", "").replace("]", "")
      );
      if (hubUserManagementPage.isElementExist(editXpath)) {
        hubUserManagementPage.findElementByXpath(editXpath).click();
        operatorClickOnRemoveButtonOnRemoveUserModal();
      }
    }
  }

  @When("Hub User admin click edit user button")
  public void hubUserAdminClickEditUserButton() {
    hubUserManagementPage.waitUntilPageLoaded();
    pause5s();
    hubUserManagementPage.switchTo();
    try {
      hubUserManagementPage.editUserButton.click();
    } catch (Exception e) {
      throw new RuntimeException(e);
    }

  }

  @When("Hub User search {string} hub user email")
  public void hubUserSearchHubUserEmail(String hubUserEmail) {
    hubUserManagementPage.usernameOrEmailInput.sendKeys(hubUserEmail);
    hubUserManagementPage.searchButton.click();
  }


  @Then("Make sure user assigned to correct hub")
  public void makeSureUserAssignedToCorrectHub(Map<String, String> data) {
    Map<String, String> hubData = resolveKeyValues(data);
    String hub1 = String.format(hubUserManagementPage.XPATH_OF_HUB_SELECTED_HUB,
        hubData.get("hub1"));
    String hub2 = String.format(hubUserManagementPage.XPATH_OF_HUB_SELECTED_HUB,
        hubData.get("hub2"));
    String hub3 = String.format(hubUserManagementPage.XPATH_OF_HUB_SELECTED_HUB,
        hubData.get("hub3"));
    Assertions.assertThat(hubUserManagementPage.isElementExist(hub1))
        .as("Selected Hub 1 is " + hubData.get("hub1")).isTrue();
    Assertions.assertThat(hubUserManagementPage.isElementExist(hub2))
        .as("Selected Hub 2 is " + hubData.get("hub2")).isTrue();
    Assertions.assertThat(hubUserManagementPage.isElementExist(hub3))
        .as("Selected Hub 3 is " + hubData.get("hub3")).isTrue();
  }

  @When("Hub User assigned hub to user with following hub:")
  public void hubUserAssignedHubToUserWithFollowingHub(Map<String, String> data) {
    Map<String, String> hubData = resolveKeyValues(data);
    hubUserManagementPage.selectHub1.click();
    hubUserManagementPage.selectHub1.selectValue(hubData.get("hub1"));
    hubUserManagementPage.selectHub2.click();
    hubUserManagementPage.selectHub2.selectValue(hubData.get("hub2"));
    hubUserManagementPage.selectHub3.click();
    hubUserManagementPage.selectHub3.selectValue(hubData.get("hub3"));
    hubUserManagementPage.addButton.click();
  }


  @Then("Operator verifies {string} user modal for Station Admin flow is shown")
  public void operatorVerifiesUserModalForStationAdminFlowIsShown(String action) {
    pause3s();
    switch (action) {
      case "add":
        Assertions.assertThat(hubUserManagementPage.addUserModal.getText())
            .as("Modal Title is " + hubUserManagementPage.addUserModal.getText())
            .isEqualTo("Add User");
        Assertions.assertThat(hubUserManagementPage.emailInput.isEnabled())
            .as("Email Input is Enabled")
            .isTrue();
        break;
      case "edit":
        Assertions.assertThat(hubUserManagementPage.editUserModal.getText())
            .as("Modal Title is " + hubUserManagementPage.editUserModal.getText())
            .isEqualTo("Edit user");
        Assertions.assertThat(hubUserManagementPage.emailInput.isEnabled())
            .as("Email Input is Disabled")
            .isFalse();
        break;
      case "remove":
        Assertions.assertThat(hubUserManagementPage.removeUserModal.getText())
            .as("Modal Title is " + hubUserManagementPage.removeUserModal.getText())
            .isEqualTo("Remove User");
        break;
    }
    Assertions.assertThat(hubUserManagementPage.roleSelection.isEnabled())
        .as("Role Selection is Disabled")
        .isFalse();
  }

  @When("Operator click edit view user {string} navigation button on Hub User Management Page")
  public void operatorClickEditViewUserNavigationButtonOnHubUserManagementPage(String userId) {
    String editXpath = String.format(hubUserManagementPage.XPATH_OF_EDIT_USER_BUTTON, userId);
    hubUserManagementPage.waitUntilPageLoaded();
    hubUserManagementPage.findElementByXpath(editXpath).click();
    hubUserManagementPage.waitUntilPageLoaded();
  }


  @Then("Operator verifies Add a new user? modal is shown")
  public void operatorVerifiesAddANewUserModalIsShown() {
    pause3s();
    Assertions.assertThat(hubUserManagementPage.addNewUserModal.getText())
        .as("Modal Title is " + hubUserManagementPage.addNewUserModal.getText())
        .isEqualTo("Add a new user?");
  }

  @When("Operator search {string} hub name")
  public void operatorSearchHubName(String hubName) {
    hubUserManagementPage.switchTo();
    hubUserManagementPage.searchHub.sendKeys(hubName);
  }

  @Then("Operator verify remove hub user remove button is not exist")
  public void operatorVerifiesRemoveHubUserButtonIsNotExist() {
    Assertions.assertThat(hubUserManagementPage.removeButton.isDisplayed())
        .as("Remove Button is not displayed").isFalse();
  }

  @When("Operator click delete user {string} button on Hub User Management Page")
  public void operatorClickDeleteUserButtonOnHubUserManagementPage(String userId) {
    String deleteXpath = String.format(hubUserManagementPage.XPATH_OF_REMOVE_USER_BUTTON, userId);
    hubUserManagementPage.waitUntilPageLoaded();
    hubUserManagementPage.findElementByXpath(deleteXpath).click();
    hubUserManagementPage.waitUntilPageLoaded();
  }

  @Then("Operator verifies delete hub user button is not exist")
  public void operatorVerifiesDeleteHubUserButtonIsNotExist() {
    hubUserManagementPage.deleteButtonContainer.isEmptyOrNullString();
  }

  @When("Operator search {string} username with {string} role")
  public void operatorSearchUsernameWithRole(String username, String role) {
    hubUserManagementPage.usernameInput.sendKeys(username);
    Assertions.assertThat(hubUserManagementPage.usernameHighlight.getText())
        .as(username + " is highlighted").isEqualTo(username);
    hubUserManagementPage.roleInput.sendKeys(role);
    Assertions.assertThat(hubUserManagementPage.roleHighlight.getText())
        .as(role + " is highlighted").isEqualTo(role);
  }

  @When("Operator click on remove user button on user modal")
  public void operatorClickOnRemoveUserButtonOnUserModal() {
    hubUserManagementPage.removeUserButton.click();
  }
}
