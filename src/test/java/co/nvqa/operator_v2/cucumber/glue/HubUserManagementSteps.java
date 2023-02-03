package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.HubUserManagementPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.Map;
import java.util.Objects;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

public class HubUserManagementSteps extends AbstractSteps {

  private HubUserManagementPage hubUserManagementPage;

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
}
