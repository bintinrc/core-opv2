package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.ArmCombination;
import co.nvqa.operator_v2.selenium.page.SortBeltManagerPage;
import co.nvqa.operator_v2.selenium.page.SortBeltManagerPage.ArmCombinationContainer;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;

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
    sortBeltManagerPage.proceed.waitUntilVisible(60);
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
    sortBeltManagerPage.create.click();
  }

  @When("^Operator click Proceed button on Sort Belt Manager page$")
  public void operatorClickProceedButton() {
    sortBeltManagerPage.proceed.clickAndWaitUntilDone();
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
    data = resolveKeyValues(data);
    String name = data.get("configName");
    String description = data.get("description");

    sortBeltManagerPage.nameInput.setValue(name);
    sortBeltManagerPage.descriptionInput.setValue(description);
    put(KEY_CREATED_SORT_BELT_CONFIG, name);
  }

  @When("^Make sure new configuration is not created$")
  public void makeSureNewConfigurationIsNotCreated() {
    String configName = get(KEY_CREATED_SORT_BELT_CONFIG);
    sortBeltManagerPage.verifyConfigNotCreated(configName);
  }

  @Given("^Operator select combination value for \"([^\"]*)\"$")
  public void operatorSelectCombinationValue(String armName, Map<String, String> data) {
    data = resolveKeyValues(data);
    armName = resolveValue(armName);
    String status = data.get("status");
    String destinationHubs = data.get("destinationHubs");
    String orderTags = data.get("orderTags");
    ArmCombinationContainer container = sortBeltManagerPage.getArmCombinationContainer(armName);
    container.enable.setValue(StringUtils.equalsAnyIgnoreCase(status, "enable", "enabled"));
    if (StringUtils.isNotBlank(destinationHubs)) {
      container.getFilterSelect("Destination Hub", 1).selectValue(destinationHubs);
    }
    if (StringUtils.isNotBlank(orderTags)) {
      container.getFilterSelect("Order Tag", 1).selectValue(orderTags);
    }
  }

  @Given("^Operator add combination value for \"([^\"]*)\"$")
  public void operatorAddCombinationValue(String armName, Map<String, String> data) {
    data = resolveKeyValues(data);
    armName = resolveValue(armName);
    String destinationHubs = data.get("destinationHubs");
    String orderTags = data.get("orderTags");
    ArmCombinationContainer container = sortBeltManagerPage.getArmCombinationContainer(armName);
    container.addCombination.click();
    int index = container.getCombinationsCount();
    if (StringUtils.isNotBlank(destinationHubs)) {
      container.getFilterSelect("Destination Hub", index).selectValue(destinationHubs);
    }
    if (StringUtils.isNotBlank(orderTags)) {
      container.getFilterSelect("Order Tag", index).selectValue(orderTags);
    }
  }

  @Given("^Operator click Confirm button on Configuration Summary page$")
  @When("^Operator click Confirm button on Create Configuration page$")
  public void operatorClickConfirmButton() {
    sortBeltManagerPage.confirm.click();
  }

  @When("^Operator verifies combination appears under Duplicate Combination table:$")
  public void makeSureDuplicateCombinationIsAppears(Map<String, String> data) {
    data = resolveKeyValues(data);
    ArmCombination expectedCombination = new ArmCombination(data);

    List<ArmCombination> actualList = sortBeltManagerPage.duplicatedCombinationsTable
        .readAllEntities();
    assertThat("List of duplicated arm combinations", actualList, Matchers.hasSize(1));
    expectedCombination.compareWithActual(actualList.get(0));
  }

  @When("^Operator verifies combination appears under Unique Combination table:$")
  public void makeSureUniqueCombinationIsAppears(Map<String, String> data) {
    data = resolveKeyValues(data);
    ArmCombination expectedCombination = new ArmCombination(data);

    List<ArmCombination> actualList = sortBeltManagerPage.uniqueCombinationsTable
        .readAllEntities();
    assertThat("List of unique arm combinations", actualList, Matchers.hasSize(1));
    expectedCombination.compareWithActual(actualList.get(0));
  }

  @When("^Operator verifies combinations appear under Unique Combination table:$")
  public void makeSureUniqueCombinationsIsAppears(List<Map<String, String>> data) {
    List<ArmCombination> actualList = sortBeltManagerPage.uniqueCombinationsTable
        .readAllEntities();
    assertThat("List of unique arm combinations", actualList, Matchers.hasSize(data.size()));
    data.forEach(map -> {
      ArmCombination expectedCombination = new ArmCombination(resolveKeyValues(map));
      boolean found = actualList.stream().anyMatch(actual -> {
        try {
          expectedCombination.compareWithActual(actual);
          return true;
        } catch (Throwable ex) {
          return false;
        }
      });
      assertTrue(f("Not found unique arm combination " + expectedCombination.toMap()), found);
    });
  }

  @When("^Operator verify there are no result under Duplicate Combination table$")
  public void makeSureThereAreNoDuplicateCombinations() {
    assertTrue("Duplicate Combination table is empty",
        sortBeltManagerPage.duplicatedCombinationsTable.isEmpty());
  }

  @When("Operator verifies that \"(.+)\" success notification is displayed")
  @And("Operator verifies that \"(.+)\" error notification is displayed")
  public void operatorVerifiesToast(String message) {
    message = resolveValue(message);
    sortBeltManagerPage.waitUntilInvisibilityOfNotification(message, true);
  }
}