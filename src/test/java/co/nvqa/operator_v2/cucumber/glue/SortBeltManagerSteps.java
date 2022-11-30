package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.sort.sort_belt_manager.LogicForm;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.ArmCombination;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.SortBeltManagerPage;
import co.nvqa.operator_v2.selenium.page.SortBeltManagerPage.ArmCombinationContainer;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.hamcrest.Matchers;
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
    String hub = StandardTestConstants.SORT_BELT_MANAGER_HUB;
    String device = StandardTestConstants.SORT_BELT_MANAGER_DEVICE;
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


  @Then("Operator selects a logic to copy")
  public void operatorSelectsALogicToCopy() {
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
    String createdLogicName = ((LogicForm) get(KEY_SBM_CREATED_LOGIC_FORM)).getName();
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
      createdLogicName = StandardTestConstants.SORT_BELT_MANAGER_DEFAULT_LOGIC;
    } else {
      createdLogicName = ((LogicForm) get(KEY_SBM_CREATED_LOGIC_FORM)).getName();
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
      inputMap.replace("name", ((LogicForm) get(KEY_SBM_CREATED_LOGIC_FORM)).getName());
    }
    sortBeltManagerPage.fillLogicBasicInformation(inputMap, true);
  }

  @And("Operator fills logic rules")
  public void operatorFillsLogicRules(Map<String, String> dataTableAsMap) {
    List<Map<String, String>> filtersAsList = fromJsonToList(dataTableAsMap.get("rules"),
        Object.class).stream().map(f -> convertValueToMap(f, String.class, String.class)).collect(
        Collectors.toList());
    sortBeltManagerPage.fillLogicRules(filtersAsList);
    put(KEY_SBM_CREATED_LOGIC_FORM, sortBeltManagerPage.getUpdatedFormState());
  }

  @And("Operator edits logic rules")
  public void operatorEditsLogicRules(Map<String, String> dataTableAsMap) {
    List<Map<String, String>> filtersAsList = fromJsonToList(dataTableAsMap.get("rules"),
        Object.class).stream().map(f -> convertValueToMap(f, String.class, String.class)).collect(
        Collectors.toList());
    sortBeltManagerPage.fillLogicRules(filtersAsList, true);
    put(KEY_SBM_CREATED_LOGIC_FORM, sortBeltManagerPage.getUpdatedFormState());
  }

  @And("Operator deletes extra rules in create logic")
  public void operatorDeletesExtraRulesInCreateLogic() {
    sortBeltManagerPage.deleteRulesExceptTheFirstOne();
    put(KEY_SBM_CREATED_LOGIC_FORM, sortBeltManagerPage.getUpdatedFormState());
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

  @And("Operator make sure logic checking is correct")
  public void operatorMakeSureLogicCheckingIsCorrect() {
    LogicForm logicForm = get(KEY_SBM_CREATED_LOGIC_FORM);
    sortBeltManagerPage.checkLogicValuesInCheckLogicPage(logicForm);
  }

  @And("Operator clicks save button in check logic")
  public void operatorClicksSaveButtonInCheckLogic() {
    LogicForm logic = get(KEY_SBM_CREATED_LOGIC_FORM);
    sortBeltManagerPage.saveLogic.click();
    sortBeltManagerPage.waitUntilVisibilityOfElementLocated(
        String.format(SortBeltManagerPage.SUB_PAGE_HEADER_XPATH, logic.getName()));
    Assertions.assertThat(sortBeltManagerPage.isElementExist(
            String.format(SortBeltManagerPage.SUB_PAGE_HEADER_XPATH, logic.getName())))
        .as("Redirected to Logic Detail page")
        .isTrue();
  }

  @And("Operator make sure logic form is pre-populated")
  public void operatorMakeSureLogicFormIsPrePopulated() {
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
    LogicForm logic = get(KEY_SBM_CREATED_LOGIC_FORM);
    Assertions.assertThat(sortBeltManagerPage.checkIfUniqueRulesAndArmsAreCorrect(logic))
        .as("Unique rules and arms summary is CORRECT")
        .isTrue();
  }

  @And("Operator make sure duplicate rules are correct")
  public void operatorMakeSureDuplicateRulesAreCorrect() {
    LogicForm logic = get(KEY_SBM_CREATED_LOGIC_FORM);
    Assertions.assertThat(sortBeltManagerPage.checkIfDuplicateRulesAreCorrect(logic))
        .as("Duplicate rules checking is CORRECT")
        .isTrue();
  }

  @And("Operator make sure conflicting shipment rules are correct")
  public void operatorMakeSureConflictingShipmentRulesAreCorrect() {
    LogicForm logic = get(KEY_SBM_CREATED_LOGIC_FORM);
    Assertions.assertThat(sortBeltManagerPage.checkIfConflictingShipmentRulesAreCorrect(logic))
        .as("Conflicting rules checking is CORRECT")
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

  /* =================================================================================== */
  /* ====================================== SBMv1 ====================================== */
  /* =================================================================================== */

  @When("^Operator select the hub of Sort Belt Manager$")
  public void operatorSelectTheHubOfSortBeltManager(Map<String, String> data) {
    data = resolveKeyValues(data);
    String hubName = data.get("hubName");
    sortBeltManagerPage.waitUntilPageLoaded();
    sortBeltManagerPage.selectHub.selectValue(hubName);
  }

  @When("^Operator click Proceed button on Sort Belt Manager page$")
  public void operatorClickProceedButton() {
    sortBeltManagerPage.proceed.clickAndWaitUntilDone();
  }

  @When("^Operator fill data in Create Configuration modal:$")
  public void operatorFillDataInCreateConfigurationModal(Map<String, String> data) {
    data = resolveKeyValues(data);
    sortBeltManagerPage.createConfigurationModal.waitUntilVisible();
    String value = data.get("firstFilter");
    if (StringUtils.isNotBlank(value)) {
      sortBeltManagerPage.createConfigurationModal.firstFilter.selectValue(value.toLowerCase());
    }
    value = data.get("secondFilter");
    if (StringUtils.isNotBlank(value)) {
      sortBeltManagerPage.createConfigurationModal.secondFilter.selectValue(value.toLowerCase());
    }
    value = data.get("thirdFilter");
    if (StringUtils.isNotBlank(value)) {
      sortBeltManagerPage.createConfigurationModal.thirdFilter.selectValue(value.toLowerCase());
    }
    value = data.get("unassignedParcelArm");
    if (StringUtils.isNotBlank(value)) {
      sortBeltManagerPage.createConfigurationModal.unassignedParcelArm.selectValue(value);
    }
    sortBeltManagerPage.createConfigurationModal.confirm.click();
    sortBeltManagerPage.createConfigurationModal.waitUntilInvisible();
  }

  @When("^Operator input Configuration name and description$")
  public void operatorInputConfigurationNameAndDescription(Map<String, String> data) {
    data = resolveKeyValues(data);
    String name = data.get("configName");
    String description = data.get("description");

    sortBeltManagerPage.nameInput.setValue(name);
    Optional.ofNullable(description).ifPresent(value -> {
      sortBeltManagerPage.descriptionInput.setValue(value);
    });

    put(KEY_CREATED_SORT_BELT_CONFIG, name);
    putInList(KEY_LIST_OF_CREATED_SORT_BELT_CONFIGS, name);
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
    String sameAs = data.get("sameAs");
    ArmCombinationContainer container = sortBeltManagerPage.getArmCombinationContainer(armName);
    container.enable.setValue(StringUtils.equalsAnyIgnoreCase(status, "enable", "enabled"));
    if (StringUtils.isNotBlank(destinationHubs)) {
      container.getFilterSelect("Destination Hub", 1).selectValue(destinationHubs);
    }
    if (StringUtils.isNotBlank(orderTags)) {
      container.getFilterSelect("Order Tag", 1).selectValue(orderTags);
    }
    if (StringUtils.isNotBlank(sameAs)) {
      container.sameAs.selectValues(splitAndNormalize(sameAs.replaceAll("Arm ", "")));
    }
  }

  @Given("Operator remove {string} Same As value from {string} arm")
  public void operatorRemoveSameAsValue(String sameAsArmName, String armName) {
    sameAsArmName = resolveValue(sameAsArmName);
    armName = resolveValue(armName);
    ArmCombinationContainer container = sortBeltManagerPage.getArmCombinationContainer(armName);
    container.removeSameAs(sameAsArmName);
  }

  @Given("Operator verify {string} arm is enabled on Create Configuration page")
  public void operatorVerifyArmEnabled(String armName) {
    armName = resolveValue(armName);
    ArmCombinationContainer container = sortBeltManagerPage.getArmCombinationContainer(armName);
    Assertions.assertThat(container.enable.isEnabled()).as(armName + " is enabled").isTrue();
  }

  @Given("Operator verify {string} arm is disabled on Create Configuration page")
  public void operatorVerifyArmDisabled(String armName) {
    armName = resolveValue(armName);
    ArmCombinationContainer container = sortBeltManagerPage.getArmCombinationContainer(armName);
    Assertions.assertThat(container.enable.isEnabled()).as(armName + " is enabled").isFalse();
  }

  @Given("Operator remove {int} combination for {string}")
  public void operatorRemoveCombination(int index, String armName) {
    armName = resolveValue(armName);
    sortBeltManagerPage.getArmCombinationContainer(armName).getRemoveButton(index).click();
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
  @Then("^Operator click Confirm button on Edit Configuration page$")
  public void operatorClickConfirmButton() {
    sortBeltManagerPage.confirm.click();
  }

  @When("^Operator verifies combination appears under Duplicate Combination table:$")
  public void makeSureDuplicateCombinationIsAppears(Map<String, String> data) {
    data = resolveKeyValues(data);
    ArmCombination expectedCombination = new ArmCombination(data);

    List<ArmCombination> actualList = sortBeltManagerPage.duplicatedCombinationsTable
        .readAllEntities();
    Assertions.assertThat(actualList).as("List of duplicated arm combinations").hasSize(1);
    expectedCombination.compareWithActual(actualList.get(0));
  }

  @When("^Operator verifies combination appears under Unique Combination table:$")
  public void makeSureUniqueCombinationIsAppears(Map<String, String> data) {
    data = resolveKeyValues(data);
    ArmCombination expectedCombination = new ArmCombination(data);

    List<ArmCombination> actualList = sortBeltManagerPage.uniqueCombinationsTable
        .readAllEntities();
    Assertions.assertThat(actualList).as("List of unique arm combinations").hasSize(1);
    expectedCombination.compareWithActual(actualList.get(0));
  }

  @When("^Operator verifies combinations appear under Unique Combination table:$")
  public void makeSureUniqueCombinationsIsAppears(List<Map<String, String>> data) {
    List<ArmCombination> actualList = sortBeltManagerPage.uniqueCombinationsTable
        .readAllEntities();
    Assertions.assertThat(actualList).as("List of unique arm combinations").hasSize(data.size());
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
      Assertions.assertThat(found)
          .as(f("Not found unique arm combination " + expectedCombination.toMap())).isTrue();
    });
  }

  @When("^Operator verify there are no result under Duplicate Combination table$")
  public void makeSureThereAreNoDuplicateCombinations() {
    Assertions.assertThat(sortBeltManagerPage.duplicatedCombinationsTable.isEmpty())
        .as("Duplicate Combination table is empty").isTrue();
  }

  @When("^Operator verify there are no result under Unique Combination table$")
  public void makeSureThereAreNoUniqueCombinations() {
    Assertions.assertThat(sortBeltManagerPage.uniqueCombinationsTable.isEmpty())
        .as("Unique Combination table is empty").isTrue();
  }

  @When("^Operator verifies that \"(.+)\" success notification is displayed$")
  @And("^Operator verifies that \"(.+)\" error notification is displayed$")
  public void operatorVerifiesToast(String message) {
    message = resolveValue(message);
    pause2s();
    sortBeltManagerPage.waitUntilInvisibilityOfNotification(message, true);
  }

  @When("Operator verifies Unassigned Parcel Arm is {string} on Sort Belt Manager page")
  public void verifyUnassignedParcelArmValue(String expected) {
    Assertions.assertThat(sortBeltManagerPage.unassignedParcelArm.getText())
        .as("Unassigned Parcel Arm").isEqualTo(expected);
  }

  @When("^Operator click Edit Configuration button on Sort Belt Manager page$")
  public void operatorClickEditConfigurationButton() {
    sortBeltManagerPage.editConfiguration.click();
  }

  @When("Operator Change Unassigned Parcel Arm to {string} on Edit Configuration page")
  public void operatorChangeUnassignedParcelArm(String value) {
    operatorOpensChangeUnassignedParcelArmModal();
    operatorSelectsUnassignedParcelArmModal(value);
    sortBeltManagerPage.changeUnassignedParcelArmModal.confirm.click();
    sortBeltManagerPage.changeUnassignedParcelArmModal.waitUntilInvisible();
  }

  @When("Operator opens Change Unassigned Parcel Arm modal on Edit Configuration page")
  public void operatorOpensChangeUnassignedParcelArmModal() {
    sortBeltManagerPage.editUnassignedParcelsArm.click();
    sortBeltManagerPage.changeUnassignedParcelArmModal.waitUntilVisible();
  }

  @When("Operator selects {string} Unassigned Parcel Arm on Edit Configuration page")
  public void operatorSelectsUnassignedParcelArmModal(String value) {
    value = resolveValue(value);
    if (StringUtils.equalsIgnoreCase(value, "none")) {
      sortBeltManagerPage.changeUnassignedParcelArmModal.unassignedParcelArm.selectByIndex(0);
    } else {
      sortBeltManagerPage.changeUnassignedParcelArmModal.unassignedParcelArm.selectValue(value);
    }
  }

  @When("Operator verifies filter values in Change Unassigned Parcel Arm modal:")
  public void operatorVerifyFilterValues(Map<String, String> data) {
    data = resolveKeyValues(data);
    String value = data.get("Destination Hub");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              sortBeltManagerPage.changeUnassignedParcelArmModal.getFilterValue("Destination Hub"))
          .as("Destination Hub").isEqualTo(value);
    }
    value = data.get("Order Tag");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              sortBeltManagerPage.changeUnassignedParcelArmModal.getFilterValue("Order Tag"))
          .as("Order Tag").isEqualTo(value);
    }
  }

  @When("Operator verifies {string} message is displayed in Change Unassigned Parcel Arm modal")
  public void operatorVerifyNoteMessage(String value) {
    Assertions.assertThat(sortBeltManagerPage.changeUnassignedParcelArmModal.note.isDisplayedFast())
        .as("Note message is displayed").isTrue();
    Assertions.assertThat(sortBeltManagerPage.changeUnassignedParcelArmModal.note.getText())
        .as("Note message").isEqualTo(value);
  }

  @When("Operator click Confirm button in Change Unassigned Parcel Arm modal")
  public void operatorClickConfirmButtonInChangeUnassignedParcelArmModal() {
    sortBeltManagerPage.changeUnassignedParcelArmModal.confirm.click();
  }

  @When("Operator save active configuration value on Sort Belt Manager page")
  public void operatorSaveActiveConfigurationValue() {
    put(KEY_ACTIVE_SORT_BELT_CONFIG, sortBeltManagerPage.getActiveConfiguration());
  }

  @When("Operator change active configuration to {string} on Sort Belt Manager page")
  public void operatorChangeActiveConfigurationValue(String value) {
    value = resolveValue(value);
    sortBeltManagerPage.change.click();
    sortBeltManagerPage.changeActiveConfigurationModal.waitUntilClickable();
    sortBeltManagerPage.changeActiveConfigurationModal.configuration.selectValue(value);
    sortBeltManagerPage.changeActiveConfigurationModal.confirm.click();
    sortBeltManagerPage.changeActiveConfigurationModal.waitUntilInvisible();
  }

  @When("Operator verify active configuration values on Sort Belt Manager page:")
  public void operatorVerifyActiveConfigurationValueS(Map<String, String> data) {
    data = resolveKeyValues(data);
    String expected = data.get("activeConfiguration");
    if (StringUtils.isNotBlank(expected)) {
      Assertions.assertThat(sortBeltManagerPage.getActiveConfiguration()).as("Active Configuration")
          .isEqualTo(expected);
    }
    expected = data.get("previousConfiguration");
    if (StringUtils.isNotBlank(expected)) {
      Assertions.assertThat(sortBeltManagerPage.getPreviousConfiguration())
          .as("Previous Configuration").isEqualTo(expected);
    }
    expected = data.get("lastChangedAt");
    if (StringUtils.isNotBlank(expected)) {
      Assertions.assertThat(sortBeltManagerPage.getLastChangedAt()).as("Last Changed At")
          .startsWith(expected);
    }
  }
}