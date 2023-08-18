package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commonsort.constants.SortScenarioStorageKeys;
import co.nvqa.commonsort.model.sort_vendor.LogicForm;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.SortBeltManagerPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;

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
    sortBeltManagerPage.hubSelector.waitUntilVisible(60);
  }

  @And("Operator selects hub {string} and device {string} of Sort Belt Manager")
  public void operatorSelectsHubAndDeviceOfSortBeltManager(String hub, String device) {
    sortBeltManagerPage.waitUntilPageLoaded();
    sortBeltManagerPage.selectHubAndDevice(hub, device);
  }

  @When("Operator selects hub and device of Sort Belt Manager")
  public void operatorSelectsHubAndDeviceOfSortBeltManager() {
    String hub = TestConstants.SORT_BELT_MANAGER_HUB;
    String device = TestConstants.SORT_BELT_MANAGER_DEVICE;
    operatorSelectsHubAndDeviceOfSortBeltManager(hub, device);
  }

  @Then("Operator make sure redirected to Sort Belt Manager main page")
  public void operatorMakeSureRedirectedToSortBeltManagerMainPage() {
    sortBeltManagerPage.waitUntilVisibilityOfElementLocated(
        By.xpath(SortBeltManagerPage.SUMMARY_XPATH), 120);
    Assertions.assertThat(sortBeltManagerPage.isElementExist(SortBeltManagerPage.SUMMARY_XPATH))
        .as("Sort Belt Manager page is fully loaded.")
        .isTrue();
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
    sortBeltManagerPage.createNew.waitUntilVisible();
    sortBeltManagerPage.createNew.click();
  }

  @When("Operator clicks Create Logic -> {string}")
  public void operatorClicksCreateLogicButton(String action) {
    sortBeltManagerPage.create.click();
    PageElement actionButton = action.equalsIgnoreCase("create new") ? sortBeltManagerPage.createNew
        : sortBeltManagerPage.createCopy;
    actionButton.waitUntilVisible();
    actionButton.click();
  }


  @Then("Operator selects {string} logic to copy")
  public void operatorSelectsLogicToCopy(String logicName) {
    // Check every necessary elements exists
    sortBeltManagerPage.waitUntilVisibilityOfElementLocated(
        SortBeltManagerPage.CREATE_COPY_DIALOG_XPATH);
    sortBeltManagerPage.copyLogicInput.waitUntilVisible();
    Assertions.assertThat(
            sortBeltManagerPage.isElementExist(SortBeltManagerPage.CREATE_COPY_DIALOG_XPATH))
        .as("Select logic dialog is displayed")
        .isTrue();
    Assertions.assertThat(sortBeltManagerPage.copyLogicInput.isDisplayed())
        .as("Select logic input is displayed")
        .isTrue();

    // Get created logic name
    String createdLogicName = resolveValue(logicName);
    sortBeltManagerPage.copyLogicInput.click();
    pause500ms();
    sortBeltManagerPage.copyLogicInput.sendKeys(createdLogicName);
    pause500ms();
    sortBeltManagerPage.copyLogicInput.sendKeys(Keys.ENTER);
    pause500ms();
    sortBeltManagerPage.copyLogicConfirm.waitUntilClickable();
    sortBeltManagerPage.copyLogicConfirm.click();
  }

  @Then("Operator make sure redirected to {string} logic page")
  public void operatorMakeSureRedirectedToCreateLogicPage(String action) {
    sortBeltManagerPage.waitUntilVisibilityOfElementLocated(
        String.format(SortBeltManagerPage.SUB_PAGE_HEADER_XPATH, action + " Logic"));
    Assertions.assertThat(sortBeltManagerPage.isElementExist(
            String.format(SortBeltManagerPage.SUB_PAGE_HEADER_XPATH, action + " Logic")))
        .as("Redirected to " + action + " Logic page")
        .isTrue();
  }

  @And("Operator clicks close button in logic detail page")
  public void operatorClicksCloseButtonInLogicDetailPage() {
    sortBeltManagerPage.closeLogicDetail.waitUntilClickable();
    sortBeltManagerPage.closeLogicDetail.click();
  }

  @When("Operator search {string} logic in Sort Belt Manager page")
  public void operatorSearchLogicInSortBeltManagerPage(String selection) {
    String createdLogicName;
    if (selection.equals("default")) {
      createdLogicName = TestConstants.SORT_BELT_MANAGER_DEFAULT_LOGIC;
    } else {
      createdLogicName = resolveValue(selection);
    }
    sortBeltManagerPage.searchAndSelectALogic(createdLogicName);
  }

  @And("Operator edits the selected logic")
  public void operatorEditsTheSelectedLogic() {
    sortBeltManagerPage.editLogicDetail.waitUntilClickable();
    sortBeltManagerPage.editLogicDetail.click();
  }

  @And("Operator make sure there are no arms available")
  public void operatorMakeSureThereAreNoArmsAvailable() {
    Assertions.assertThat(sortBeltManagerPage.checkIfThereIsNoAvailableArm())
        .as("No arm is available to select")
        .isTrue();
  }

  @And("Operator fills logic basic information")
  public void operatorFillsLogicBasicInformation(Map<String, String> dataTableAsMap) {
    Map<String, String> inputMap = resolveKeyValues(dataTableAsMap);
    sortBeltManagerPage.fillLogicBasicInformation(inputMap, false);
  }

  @And("Operator edits logic basic information")
  public void operatorEditsLogicBasicInformation(Map<String, String> dataTableAsMap) {
    Map<String, String> inputMap = resolveKeyValues(dataTableAsMap);
    if ("CREATED".equals(inputMap.get("name"))) {
      inputMap.replace("name",
          inputMap.get("createdName"));
    }
    sortBeltManagerPage.fillLogicBasicInformation(inputMap, true);
  }

  @And("Operator fills logic rules")
  public void operatorFillsLogicRules(Map<String, String> dataTableAsMap) {
    List<Map<String, String>> filtersAsList = fromJsonToList(dataTableAsMap.get("rules"),
        Object.class).stream().map(f -> convertValueToMap(f, String.class, String.class)).collect(
        Collectors.toList());
    sortBeltManagerPage.fillLogicRules(filtersAsList);
    put(SortScenarioStorageKeys.KEY_SORT_SBM_CREATED_LOGIC_FORM,
        sortBeltManagerPage.getUpdatedFormState());
  }

  @And("Operator edits logic rules")
  public void operatorEditsLogicRules(Map<String, String> dataTableAsMap) {
    List<Map<String, String>> filtersAsList = fromJsonToList(dataTableAsMap.get("rules"),
        Object.class).stream().map(f -> convertValueToMap(f, String.class, String.class)).collect(
        Collectors.toList());
    sortBeltManagerPage.fillLogicRules(filtersAsList, true);
    put(SortScenarioStorageKeys.KEY_SORT_SBM_CREATED_LOGIC_FORM,
        sortBeltManagerPage.getUpdatedFormState());
  }

  @And("Operator deletes extra rules in create logic")
  public void operatorDeletesExtraRulesInCreateLogic() {
    sortBeltManagerPage.deleteRulesExceptTheFirstOne();
    put(SortScenarioStorageKeys.KEY_SORT_SBM_CREATED_LOGIC_FORM,
        sortBeltManagerPage.getUpdatedFormState());
  }

  @And("Operator clicks next button in create logic")
  public void operatorClicksNextButtonInCreateLogic() {
    sortBeltManagerPage.nextCreateLogic.waitUntilClickable();
    sortBeltManagerPage.nextCreateLogic.click();
  }

  @Then("Operator make sure redirected to check logic page")
  public void operatorMakeSureRedirectedToCheckLogicPage() {
    sortBeltManagerPage.waitUntilVisibilityOfElementLocated(
        String.format(SortBeltManagerPage.SUB_PAGE_HEADER_XPATH, "Check Logic"));
    Assertions.assertThat(sortBeltManagerPage.isElementExist(
            String.format(SortBeltManagerPage.SUB_PAGE_HEADER_XPATH, "Check Logic")))
        .as("Redirected to Check Logic page")
        .isTrue();
  }

  @And("Operator clicks save button in check logic")
  public void operatorClicksSaveButtonInCheckLogic(Map<String, String> data) {
    data = resolveKeyValues(data);
    String logicName = data.get("logicName");
    sortBeltManagerPage.saveLogic.click();
    sortBeltManagerPage.waitUntilVisibilityOfElementLocated(
        String.format(SortBeltManagerPage.SUB_PAGE_HEADER_XPATH, logicName));
    Assertions.assertThat(sortBeltManagerPage.isElementExist(
            String.format(SortBeltManagerPage.SUB_PAGE_HEADER_XPATH, logicName)))
        .as("Redirected to Logic Detail page")
        .isTrue();
  }

  @And("Operator make sure logic form is pre-populated")
  public void operatorMakeSureLogicFormIsPrePopulated() {
    sortBeltManagerPage.waitUntilPageLoaded();
    Assertions.assertThat(sortBeltManagerPage.checkAllFieldIsPrePopulated())
        .as("All fields are PRE-POPULATED")
        .isTrue();
  }

  @And("Operator make sure can not select arm filters anymore")
  public void operatorMakeSureCanNotSelectArmFiltersAnymore() {
    sortBeltManagerPage.logicArmFiltersInput.click();
    Assertions.assertThat(
            sortBeltManagerPage.findElementsByXpath(SortBeltManagerPage.ARM_FILTERS_DISABLED_XPATH)
                .size())
        .as("Other arm filters options are DISABLED")
        .isNotZero();
  }

  @And("Operator make sure can not create logic")
  public void operatorMakeSureCanNotCreateLogic() {
    sortBeltManagerPage.waitUntilVisibilityOfElementLocated(
        SortBeltManagerPage.CAN_NOT_SAVE_POPUP_XPATH);
    Assertions.assertThat(
            sortBeltManagerPage.isElementExist(SortBeltManagerPage.CAN_NOT_SAVE_POPUP_XPATH))
        .as("Pop up warning appears and operator can not proceed")
        .isTrue();
  }

  @When("Operator clicks cancel button in create logic")
  public void operatorClicksCancelButtonInCreateLogic() {
    sortBeltManagerPage.cancelCreateLogic.waitUntilClickable();
    sortBeltManagerPage.cancelCreateLogic.click();
  }

  @And("Operator confirms on cancel creating logic")
  public void operatorConfirmsOnCancelCreatingLogic() {
    Assertions.assertThat(
            sortBeltManagerPage.isElementExist(SortBeltManagerPage.CANCEL_CREATE_DIALOG_XPATH))
        .as("Confirmation dialog to cancel logic creation shows up")
        .isTrue();
    sortBeltManagerPage.cancelConfirmCreateLogic.waitUntilClickable();
    sortBeltManagerPage.cancelConfirmCreateLogic.click();
  }

  @And("Operator make sure rules that have multiple arms with the same rules are correct")
  public void operatorMakeSureRulesThatHaveMultipleArmsWithTheSameRulesAreCorrect() {
    LogicForm logic = get(KEY_SBM_CREATED_LOGIC_FORM);
    Assertions.assertThat(sortBeltManagerPage.checkIfMultipleArmsWithTheSameRulesAreCorrect(logic))
        .as("Multiple arms with the same rules summary is CORRECT")
        .isTrue();
  }

  @And("Operator make sure unique rules and arms are correct")
  public void operatorMakeSureUniqueRulesAndArmsAreCorrect() {
    LogicForm logic = get(SortScenarioStorageKeys.KEY_SORT_SBM_CREATED_LOGIC_FORM);
    Assertions.assertThat(sortBeltManagerPage.checkIfUniqueRulesAndArmsAreCorrect(logic))
        .as("Unique rules and arms summary is CORRECT")
        .isTrue();
  }
  @And("Operator make sure can not click save button in check logic")
  public void operatorMakeSureCanNotClickSaveButtonInCheckLogic() {
    Assertions.assertThat(sortBeltManagerPage.saveLogic.isEnabled())
        .as("Operator can not save logic with duplicate rules")
        .isFalse();
  }
  @When("Operator activates the selected logic")
  public void operatorActivatesTheSelectedLogic() {
    Map<String, String> selectedLogic = sortBeltManagerPage.getLogicDetailFromPage();
    sortBeltManagerPage.activateLogic.waitUntilClickable();
    sortBeltManagerPage.activateLogic.click();

    Assertions.assertThat(
            sortBeltManagerPage.isElementExist(SortBeltManagerPage.ACTIVATED_LOGIC_POPUP_XPATH))
        .as(String.format("Pop up success appears, notifying that the logic %s has been activated",
            selectedLogic.get("name")))
        .isTrue();
    operatorMakeSureRedirectedToSortBeltManagerMainPage();

    Assertions.assertThat(sortBeltManagerPage.activeLogicNameSummary.getText())
        .as("Active logic name is CORRECT")
        .isEqualTo(selectedLogic.get("name"));
    Assertions.assertThat(sortBeltManagerPage.activeLogicDescSummary.getText())
        .as("Active logic description is CORRECT")
        .isEqualTo(selectedLogic.get("desc"));
    Assertions.assertThat(sortBeltManagerPage.activeLogicArmFiltersSummary.getText())
        .as("Active logic arm filters are CORRECT")
        .isEqualTo(String.join(", ", selectedLogic.get("armFilters")));
  }

  @Then("Operator make sure can not reactivate logic")
  public void operatorMakeSureCanNotReactivateLogic() {
    Assertions.assertThat(sortBeltManagerPage.activateLogic.isEnabled())
        .as("Activate logic button is DISABLED for currently active logic")
        .isFalse();
  }
  @And("Operator verify created logic is correct")
  public void operatorVerifyCreatedLogicIsCorrect(List<Map<String, String>> data) {
    List<String> opv2 = new ArrayList<>();
    List<String> db = new ArrayList<>();
    for (Map<String, String> entry : data) {
      opv2.add(resolveValue(entry.get("actualOpv2")));
      db.add(resolveValue(entry.get("expectedDb")));
    }
    Assertions.assertThat(opv2).as("Created Logic is Correct").isEqualTo(db);
  }

  @Then("Operator make sure correct logic is activated:")
  public void operatorMakeSureCorrectLogicIsActivated(Map<String, String> data) {
    data = resolveKeyValues(data);
Long activeLogicId = Long.parseLong(data.get("activeLogicId"));
Long createdLogicId = Long.parseLong(data.get("createdLogicId"));
Assertions.assertThat(activeLogicId).as("Created Logic Activated").isEqualTo(createdLogicId);
  }

  @And("Operator make sure Logic is correct as data below:")
  public void operatorMakeSureLogicIsCorrectAsDataBelow(Map<String, String> data) {
    sortBeltManagerPage.waitUntilPageLoaded();
    String xpath;
    int numberOfRules = 0;
    String condition = (data.get("condition"));
    int numberOfArms = Integer.parseInt((data.get("numberOfArms")));
    if (StringUtils.isNotBlank(data.get("numberOfRules"))) {
      numberOfRules = Integer.parseInt((data.get("numberOfRules")));
    }
    if ("no rules".equals(condition)) {
      xpath = f(SortBeltManagerPage.NO_RULE_XPATH, numberOfArms);
      sortBeltManagerPage.waitUntilVisibilityOfElementLocated(xpath);
      Assertions.assertThat(sortBeltManagerPage.isElementExist(xpath)).isTrue()
          .as("There is %d Arm with no rules", numberOfArms);
    } else if ("same rules".equals(condition)) {
      xpath = f(SortBeltManagerPage.MULTIPLE_RULE_XPATH, numberOfRules, numberOfArms);
      sortBeltManagerPage.waitUntilVisibilityOfElementLocated(xpath);
      Assertions.assertThat(sortBeltManagerPage.isElementExist(xpath)).isTrue()
          .as("Multiple arms with the same rules: %d rule(s) across %d arm(s)", numberOfRules,
              numberOfArms);
    } else if ("unique".equals(condition)) {
      xpath = f(SortBeltManagerPage.UNIQUE_RULE_XPATH, numberOfArms);
      sortBeltManagerPage.waitUntilVisibilityOfElementLocated(xpath);
      Assertions.assertThat(sortBeltManagerPage.isElementExist(xpath)).isTrue()
          .as("Unique rules and arms: %d Results", numberOfArms);
    } else if ("conflicting shipment destination".equals(condition)) {
      xpath = f(SortBeltManagerPage.CONFLICTING_SHIPMENT_DESTINATION_RULE_XPATH, numberOfRules,
          numberOfArms);
      sortBeltManagerPage.waitUntilVisibilityOfElementLocated(xpath);
      Assertions.assertThat(sortBeltManagerPage.isElementExist(xpath)).isTrue()
          .as("Conflicting shipment destination & type: %d rule(s) across %d arm(s)", numberOfRules,
              numberOfArms);
    }
  }
}