package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.SortBeltManagerPage;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Map;

/**
 * @author Niko Susanto
 */
@ScenarioScoped
public class SortBeltManagerSteps extends AbstractSteps {

  private SortBeltManagerPage sortBeltManagerPage;

  public SortBeltManagerSteps() {
  }

  @Override
  public void init() {
    sortBeltManagerPage = new SortBeltManagerPage(getWebDriver());
  }

  @When("Sort Belt Manager page is loaded")
  public void movementManagementPageIsLoaded() {
    sortBeltManagerPage.switchTo();
    sortBeltManagerPage.proceed.waitUntilClickable(60);
  }

  @When("^Operator select the hub of Sort Belt Manager$")
  public void operatorSelectTheHubOfSortBeltManager(Map<String, String> data) {
    data = resolveKeyValues(data);
    String hubName = data.get("hubName");
    sortBeltManagerPage.waitUntilPageLoaded();
    sortBeltManagerPage.selectHub.selectValue(hubName);
  }

  @When("^Operator select the device id of Sort Belt Manager$")
  public void operatorSelectTheDeviceIdOfSortBeltManager(Map<String, String> data) {
    data = resolveKeyValues(data);
    String deviceId = data.get("deviceId");
    sortBeltManagerPage.selectDeviceId.selectValue(deviceId);
  }

  @When("^Operator click Create Configuration button$")
  public void operatorClickCreateConfigurationButton() {
    sortBeltManagerPage.clickCreateConfig();
  }

  @When("^Operator click Proceed button on Sort Belt Manager page$")
  public void operatorClickProceedButton() {
    sortBeltManagerPage.proceed.click();
  }

  @When("^Operator select Filters$")
  public void operatorSelectFilters(Map<String, String> data) {
    String firstFilter = data.get("firstFilter");
    String secondFilter = data.get("secondFilter");
    String thirdFilter = data.get("thirdFilter");

    sortBeltManagerPage.selectFilters(firstFilter, secondFilter, thirdFilter);
  }

  @When("^Operator input Configuration name and description$")
  public void operatorInputConfigurationNameAndDescription(Map<String, String> data) {
    String name = data.get("configName");
    String description = data.get("description");

    String uniqueCode = generateDateUniqueString();

    if ("GENERATED".equals(name)) {
      name = "AUTO " + uniqueCode;
    }

    sortBeltManagerPage.inputName(name, description);
    put(KEY_CREATED_SORT_BELT_CONFIG, name);
  }

  @When("^Operator verify Incomplete form submission toast is shown$")
  public void operatorVerifyIncompleteFormSubmissionToastIsShown() {
    sortBeltManagerPage.waitUntilInvisibilityOfNotification("Incomplete Form Submission", true);
  }

  @When("^Operator verify Configuration created toast is shown$")
  public void operatorVerifyConfigurationCreatedToastIsShown() {
    sortBeltManagerPage.waitUntilInvisibilityOfNotification("Configuration Created", true);
  }

  @When("^Make sure new configuration is not created$")
  public void makeSureNewConfigurationIsNotCreated() {
    String configName = get(KEY_CREATED_SORT_BELT_CONFIG);
    sortBeltManagerPage.verifyConfigNotCreated(configName);
  }

  @Given("^Operator select combination value for \"([^\"]*)\"$")
  public void operatorSelectCombinationValue(String armNumber, Map<String, String> data) {
    String status = data.get("status");
    String destinationHubs = data.get("destinationHubs");
    String orderTags = data.get("orderTags");

    sortBeltManagerPage.setFilter(armNumber, status, destinationHubs, orderTags);
  }

  @Given("^Operator add combination value for \"([^\"]*)\"$")
  public void operatorAddCombinationValue(String armNumber, Map<String, String> data) {
    String destinationHubs = data.get("destinationHubs");
    String orderTags = data.get("orderTags");

    sortBeltManagerPage.addCombination(armNumber, destinationHubs, orderTags);
  }

  @Given("^Operator click Confirm button on Configuration Summary page$")
  public void operatorClickConfirmButton() {
    sortBeltManagerPage.clickConfirm();
  }

  @When("^Make sure duplicate combination is appears under Duplicate Combination table$")
  public void makeSureDuplicateCombinationIsAppears(Map<String, String> data) {
    String armOutput = data.get("armOutput");
    String destinationHubs = data.get("destinationHubs");
    String orderTags = data.get("orderTags");

    sortBeltManagerPage
        .verifyDuplicateConfigIsExistAndDataIsCorrect(armOutput, destinationHubs, orderTags);
  }
}