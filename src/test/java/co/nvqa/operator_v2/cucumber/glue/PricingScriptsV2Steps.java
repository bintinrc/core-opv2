package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.pricing.Script;
import co.nvqa.commons.model.pricing.ScriptVersion;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.RunCheckParams;
import co.nvqa.operator_v2.model.RunCheckResult;
import co.nvqa.operator_v2.model.VerifyDraftParams;
import co.nvqa.operator_v2.selenium.page.PricingScriptsV2CreateEditDraftPage;
import co.nvqa.operator_v2.selenium.page.PricingScriptsV2Page;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.utils.StandardTestUtils.generateDateUniqueString;
import static co.nvqa.operator_v2.selenium.page.PricingScriptsV2Page.COLUMN_CLASS_DATA_DESCRIPTION_ON_TABLE;
import static co.nvqa.operator_v2.selenium.page.PricingScriptsV2Page.COLUMN_CLASS_DATA_ID_ON_TABLE;
import static co.nvqa.operator_v2.selenium.page.PricingScriptsV2Page.COLUMN_CLASS_DATA_LAST_MODIFIED_BY_ON_TABLE;
import static co.nvqa.operator_v2.selenium.page.PricingScriptsV2Page.COLUMN_CLASS_DATA_LAST_MODIFIED_ON_TABLE;
import static co.nvqa.operator_v2.selenium.page.PricingScriptsV2Page.COLUMN_CLASS_DATA_NAME_ON_TABLE;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class PricingScriptsV2Steps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(PricingScriptsV2Steps.class);

  private PricingScriptsV2Page pricingScriptsV2Page;
  private PricingScriptsV2CreateEditDraftPage pricingScriptsV2CreateEditDraftPage;

  public PricingScriptsV2Steps() {
  }

  @Override
  public void init() {
    pricingScriptsV2Page = new PricingScriptsV2Page(getWebDriver());
    pricingScriptsV2CreateEditDraftPage = new PricingScriptsV2CreateEditDraftPage(getWebDriver());
  }

  @When("^Operator create new Draft Script using data below:$")
  public void operatorCreateNewDraftScript(Map<String, String> mapOfData) {
    Script script = setScriptData(mapOfData);
    pricingScriptsV2Page.createDraftAndSave(script);
    put(KEY_CREATED_PRICING_SCRIPT, script);
    takesScreenshot();
  }

  @When("^Operator send below data to create new Draft Script:$")
  public void operatorSendDataToCreateNewDraftScript(Map<String, String> mapOfData) {
    Script script = setScriptData(mapOfData);
    pricingScriptsV2Page.createDraft(script);
    put(KEY_CREATED_PRICING_SCRIPT, script);
    takesScreenshot();
  }

  private Script setScriptData(Map<String, String> mapOfData) {
    String dateUniqueString = generateDateUniqueString();

    String createdDate = DTF_CREATED_DATE.format(ZonedDateTime.now());
    String name = mapOfData.get("name");
    String description = mapOfData.get("description");

    if (StringUtils.isEmpty(name)) {
      name = "Dummy Script #" + dateUniqueString;
    }
    if (StringUtils.isEmpty(description)) {
      description = f(
          "This script is created for testing purpose only. Ignore this script. Created at %s.",
          createdDate);
    }
    LOGGER.info("Created Pricing Script Name :" + name);

    Script script = new Script();
    script.setName(name);
    script.setDescription(description);
    if (Objects.nonNull(mapOfData.get("hasTemplate"))) {
      String hasTemplate = mapOfData.get("hasTemplate");
      String templateName = mapOfData.get("templateName");
      script.setHasTemplate(hasTemplate);
      script.setTemplateName(templateName);
    }
    if (Objects.nonNull(mapOfData.get("isCsvFile"))) {
      String isCSVFile = mapOfData.get("isCsvFile");
      String fileContent = mapOfData.get("fileContent");
      script.setIsCsvFile(isCSVFile);
      script.setFileContent(fileContent);
    }
    if (Objects.nonNull(mapOfData.get("source"))) {
      String source = mapOfData.get("source");
      script.setSource(source);
    }
    if (Objects.nonNull(mapOfData.get("activeParameters"))) {
      String activeParameters = mapOfData.get("activeParameters");
      List<String> listOfActiveParameters = Stream.of(activeParameters.split(","))
          .map(String::trim)
          .collect(Collectors.toList());
      script.setActiveParameters(listOfActiveParameters);
    }
    if (Objects.nonNull(mapOfData.get("setUpdatedAt"))) {
      script.setUpdatedAt(DTF_NORMAL_DATE.format(ZonedDateTime.now()));
    }
    return script;
  }

  @Then("Operator verify error message in header with {string}")
  public void operatorVerifyErrorMessage(String message) {
    pricingScriptsV2Page.checkErrorHeader(message);
  }

  @Then("^Operator verify the new Script is created successfully on Drafts$")
  public void operatorVerifyTheNewScriptIsCreatedSuccessfullyOnDrafts() {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    pricingScriptsV2Page.verifyTheNewScriptIsCreatedOnDrafts(script);
    put(KEY_ACTIVE_SCRIPT_ID, script.getId());
  }

  @Then("Operator edit the created Draft Script using data below:")
  public void operatorEditCreatedDraft(Map<String, String> mapOfData) {
    Script script = editCreatedDraftOrActiveScript(mapOfData);
    pricingScriptsV2Page.editCreatedDraft(script);
    pricingScriptsV2CreateEditDraftPage.checkSuccessfulSyntax();
    pricingScriptsV2CreateEditDraftPage.clickNvIconTextButtonByName("Verify Draft");
    pricingScriptsV2CreateEditDraftPage.validateDraft();
  }

  @And("Operator send below data to created Draft Script:")
  public void operatorSendBelowDataToCreatedDraftScript(Map<String, String> mapOfData) {
    Script script = editCreatedDraftOrActiveScript(mapOfData);
    pricingScriptsV2Page.editCreatedDraft(script);
  }

  @Then("Operator edit the created Active Script using data below:")
  public void operatorEditCreatedActiveScript(Map<String, String> mapOfData) {
    Script script = editCreatedDraftOrActiveScript(mapOfData);
    pricingScriptsV2Page.editCreatedActive(script);
  }

  @When("Operator search according Active Script name")
  public void operatorSearchActiveScriptName() {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    pricingScriptsV2Page.searchActiveScriptName(script.getName());
  }

  @When("^Operator delete Draft Script$")
  public void operatorDeleteDraftScript() {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    pricingScriptsV2Page.deleteDraftScript(script);
  }

  @Then("^Operator verify the Draft Script is deleted successfully$")
  public void operatorVerifyTheDraftScriptIsDeletedSuccessfully() {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    pricingScriptsV2Page.verifyDraftScriptIsDeleted(script);
  }

  @When("Operator search custom script id {string}")
  public void operatorSearchAccordingScriptId(String scriptId) {
    Script script = new Script();
    script.setId(Long.parseLong(scriptId));
    pricingScriptsV2Page.searchAccordingScriptId(script);
    put(KEY_CREATED_PRICING_SCRIPT, script);
  }

  @When("Operator do Run Check on specific Draft Script using this data below:")
  public void operatorDoRunCheckOnSpecificDraftScriptUsingThisDataBelow(
      Map<String, String> mapOfData) {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    RunCheckParams runCheckParams = runCheckScriptDraftAndActive(mapOfData);
    pricingScriptsV2Page.runCheckDraftScript(script, runCheckParams);
  }

  @When("Operator do Run Check on specific Active Script using this data below:")
  public void operatorDoRunCheckOnSpecificActiveScriptUsingThisDataBelow(
      Map<String, String> mapOfData) {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    RunCheckParams runCheckParams = runCheckScriptDraftAndActive(mapOfData);
    pricingScriptsV2Page.runCheckActiveScript(script, runCheckParams);
  }

  @Then("Operator verify error message")
  public void verifyErrorMessage(Map<String, String> mapOfData) {
    String message = mapOfData.get("message");
    String response = mapOfData.get("response");
    pricingScriptsV2Page.verifyErrorMessage(message, response);
  }

  @Then("Operator verify the Run Check Result is correct using data below:")
  public void operatorVerifyTheRunCheckResultIsCorrectUsingDataBelow(
      Map<String, String> mapOfData) {
    Double grandTotal = Double.parseDouble(mapOfData.get("grandTotal"));
    Double gst = Double.parseDouble(mapOfData.get("gst"));
    Double deliveryFee = Double.parseDouble(mapOfData.get("deliveryFee"));
    Double insuranceFee = Double.parseDouble(mapOfData.get("insuranceFee"));
    Double codFee = Double.parseDouble(mapOfData.get("codFee"));
    Double handlingFee = Double.parseDouble(mapOfData.get("handlingFee"));
    String comments = mapOfData.get("comments");

    RunCheckResult runCheckResult = new RunCheckResult();
    runCheckResult.setGrandTotal(grandTotal);
    runCheckResult.setGst(gst);
    runCheckResult.setDeliveryFee(deliveryFee);
    runCheckResult.setInsuranceFee(insuranceFee);
    runCheckResult.setCodFee(codFee);
    runCheckResult.setHandlingFee(handlingFee);
    runCheckResult.setComments(comments);
    pricingScriptsV2Page.verifyTheRunCheckResultIsCorrect(runCheckResult);
  }

  @Then("Operator close page")
  public void operatorCloseScreen() {
    pricingScriptsV2Page.closeScreen();
  }

  @Then("Operator clicks validate and release Draft Script")
  @Then("Operator validate and release Draft Script")
  public void operatorValidateAndReleaseDraft() {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    pricingScriptsV2Page.validateDraftAndReleaseScript(script);
  }

  @Then("Operator release Draft Script")
  public void operatorReleaseDraft() {
    pricingScriptsV2Page.releaseScript();
  }

  @Then("Operator clicks validate and verify warning message {string}")
  public void operatorValidateAndVerifyErrors(String warningMessage) {
    SoftAssertions softAssertions = new SoftAssertions();
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    softAssertions.assertThat(warningMessage).as("Error text is correct")
        .contains(pricingScriptsV2Page.validateDraftAndReturnWarnings(script));
  }

  @When("Operator validate and release Draft Script using this data below:")
  public void operatorValidateAndReleaseDraftScriptUsingThisDataBelow(
      Map<String, String> mapOfData) {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);

    Double startWeight = Double.parseDouble(mapOfData.get("startWeight"));
    Double endWeight = Double.parseDouble(mapOfData.get("endWeight"));

    VerifyDraftParams verifyDraftParams = new VerifyDraftParams();
    verifyDraftParams.setStartWeight(startWeight);
    verifyDraftParams.setEndWeight(endWeight);
    pricingScriptsV2Page.validateDraftAndReleaseScript(script, verifyDraftParams);
  }

  @When("Operator verify Draft Script is released successfully")
  @Then("Operator verify the script is saved successfully")
  public void operatorVerifyDraftScriptIsReleasedSuccessfully() {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    pricingScriptsV2Page.verifyDraftScriptIsReleased(script);
  }

  @Then("Operator verify Active Script data is correct")
  public void operatorVerifyActiveScriptDataIsCorrect() {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    verifyScriptDetailsInActiveScriptPage(pricingScriptsV2Page, script);
  }

  @Then("Operator verify Draft Script data is correct")
  public void operatorVerifyDraftScriptDataIsCorrect() {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    verifyScriptDetailsInDraftScriptPage(pricingScriptsV2Page, script);
  }

  @Then("Operator search according to {string} and verify search result")
  public void operatorSearch(String searchType) {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    Script dbScript = get(KEY_PRICING_SCRIPT_DETAILS);
    script.setLastModifiedUser(dbScript.getLastModifiedUser());
    script.setLastModifiedEmail(dbScript.getLastModifiedEmail());
    pricingScriptsV2Page.verifyDraftScriptIsReleased(script, searchType);
    verifyScriptDetailsInActiveScriptPage(pricingScriptsV2Page, script);
  }

  @Then("Operator search according to {string} and verify search result in Draft Script page")
  public void operatorSearchDraftScript(String searchType) {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    Script dbScript = get(KEY_PRICING_SCRIPT_DETAILS);
    script.setLastModifiedUser(dbScript.getLastModifiedUser());
    script.setLastModifiedEmail(dbScript.getLastModifiedEmail());
    pricingScriptsV2Page.searchInDraftScript(script, searchType);
    verifyScriptDetailsInDraftScriptPage(pricingScriptsV2Page, script);
  }


  private void verifyScriptDetailsInActiveScriptPage(PricingScriptsV2Page pricingScriptsV2Page,
      Script script) {
    SoftAssertions softAssertions = new SoftAssertions();
    String actualId = pricingScriptsV2Page.getTextOnTableActiveScripts(1,
        COLUMN_CLASS_DATA_ID_ON_TABLE);
    softAssertions.assertThat(actualId).as("Script ID is empty. Script is not created.")
        .isNotNull();

    String actualScriptName = pricingScriptsV2Page.getTextOnTableActiveScripts(1,
        COLUMN_CLASS_DATA_NAME_ON_TABLE);
    softAssertions.assertThat(actualScriptName).as("Script Name is correct")
        .isEqualTo(script.getName());

    String actualDescription = pricingScriptsV2Page.getTextOnTableActiveScripts(1,
        COLUMN_CLASS_DATA_DESCRIPTION_ON_TABLE);
    softAssertions.assertThat(actualDescription).as("Script Description is correct")
        .isEqualTo(script.getDescription());

    String lastModified = pricingScriptsV2Page.getTextOnTableActiveScripts(1,
        COLUMN_CLASS_DATA_LAST_MODIFIED_ON_TABLE);
    ScriptVersion scriptVersion = get(KEY_PRICING_SCRIPT_LATEST_VERSION_DETAILS);
    softAssertions.assertThat(lastModified).as("Last Modified date is correct")
        .isEqualTo(DateUtil.getDefaultDateTimeFromUTC(scriptVersion.getCreatedAt()));

    String lastModifiedBy = pricingScriptsV2Page.getTextOnTableActiveScripts(1,
        COLUMN_CLASS_DATA_LAST_MODIFIED_BY_ON_TABLE);
    softAssertions.assertThat(lastModifiedBy).as("Last Modified By date is correct")
        .isEqualTo(scriptVersion.getLastModifiedUser() + " (" + scriptVersion.getLastModifiedEmail()
            + ")");

    softAssertions.assertAll();
  }

  private void verifyScriptDetailsInDraftScriptPage(PricingScriptsV2Page pricingScriptsV2Page,
      Script script) {
    SoftAssertions softAssertions = new SoftAssertions();
    String actualId = pricingScriptsV2Page.getTextOnTableDrafts(1,
        COLUMN_CLASS_DATA_ID_ON_TABLE);
    softAssertions.assertThat(actualId).as("Script ID is empty. Script is not created.")
        .isNotNull();

    String actualScriptName = pricingScriptsV2Page.getTextOnTableDrafts(1,
        COLUMN_CLASS_DATA_NAME_ON_TABLE);
    softAssertions.assertThat(actualScriptName).as("Script Name is correct")
        .isEqualTo(script.getName());

    String actualDescription = pricingScriptsV2Page.getTextOnTableDrafts(1,
        COLUMN_CLASS_DATA_DESCRIPTION_ON_TABLE);
    softAssertions.assertThat(actualDescription).as("Script Description is correct")
        .isEqualTo(script.getDescription());

    String lastModified = pricingScriptsV2Page.getTextOnTableDrafts(1,
        COLUMN_CLASS_DATA_LAST_MODIFIED_ON_TABLE);
    ScriptVersion scriptVersion = get(KEY_PRICING_SCRIPT_LATEST_VERSION_DETAILS);
    softAssertions.assertThat(lastModified).as("Last Modified date is correct")
        .isEqualTo(DateUtil.getDefaultDateTimeFromUTC(scriptVersion.getCreatedAt()));

    String lastModifiedBy = pricingScriptsV2Page.getTextOnTableDrafts(1,
        COLUMN_CLASS_DATA_LAST_MODIFIED_BY_ON_TABLE);
    softAssertions.assertThat(lastModifiedBy).as("Last Modified By date is correct")
        .isEqualTo(scriptVersion.getLastModifiedUser() + " (" + scriptVersion.getLastModifiedEmail()
            + ")");

    softAssertions.assertAll();
  }

  @When("^Operator link Script to Shipper with ID = \"([^\"]*)\"$")
  public void operatorLinkShipperToTheScript(String shipperId) {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);

    Shipper shipper = new Shipper();
    shipper.setLegacyId(Long.parseLong(shipperId));

    pricingScriptsV2Page.linkShippers(script, shipper);
    put(KEY_CREATED_SHIPPER, shipper);
  }

  @When("^Operator link Script to Shipper with ID and Name = \"([^\"]*)\"$")
  public void operatorLinkShipperWithIdAndNameToTheScript(String shipperIdAndName) {
    shipperIdAndName = resolveValue(shipperIdAndName);
    Script script = get(KEY_CREATED_PRICING_SCRIPT);

    Shipper shipper = new Shipper();
    String shipperId = shipperIdAndName.split("-", 2)[0];
    String shipperName = shipperIdAndName.split("-", 2)[1];
    shipper.setLegacyId(Long.parseLong(shipperId));
    shipper.setName(shipperName);

    pricingScriptsV2Page.linkShippersWithIdAndName(script, shipper);
    put(KEY_CREATED_SHIPPER, shipper);
  }

  @When("^Operator link Script with name = \"([^\"]*)\" to Shipper with name = \"([^\"]*)\"$")
  public void operatorLinkScriptWithNameToShipperWithName(String scriptName, String shipperName) {
    Script script = new Script();
    script.setName(scriptName);

    Shipper shipper = new Shipper();
    shipper.setName(shipperName);

    pricingScriptsV2Page.linkShippers(script, shipper);
  }

  @When("Operator delete Active Script")
  public void operatorDeleteActiveScript() {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    pricingScriptsV2Page.deleteActiveScript(script);
  }

  @Then("Operator verify the Active Script is deleted successfully")
  public void operatorVerifyTheActiveScriptIsDeletedSuccessfully() {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    pricingScriptsV2Page.verifyActiveScriptIsDeleted(script);
  }

  @When("^Operator create and release new Time-Bounded Script using data below:$")
  public void operatorCreateAndReleaseNewTimeBoundedScriptUsingDataBelow(
      Map<String, String> mapOfData) {
    Script parentScript = get(KEY_CREATED_PRICING_SCRIPT);

    String source = mapOfData.get("source");
    String activeParameters = mapOfData.get("activeParameters");
    Double startWeight = Double.parseDouble(mapOfData.get("startWeight"));
    Double endWeight = Double.parseDouble(mapOfData.get("endWeight"));
    String dateUniqueString = generateDateUniqueString();

    List<String> listOfActiveParameters = Stream.of(activeParameters.split(",")).map(String::trim)
        .collect(Collectors.toList());
    String name = parentScript.getName() + " - " + dateUniqueString;

    Script script = new Script();
    script.setName(name);
    script.setSource(source);
    script.setActiveParameters(listOfActiveParameters);
    script.setVersionEffectiveStartDate(StandardTestUtils.getBeforeDate(1));
    script.setVersionEffectiveEndDate(
        Date.from(getNextDate(1).atZone(ZoneId.systemDefault()).toInstant()));

    VerifyDraftParams verifyDraftParams = new VerifyDraftParams();
    verifyDraftParams.setStartWeight(startWeight);
    verifyDraftParams.setEndWeight(endWeight);

    pricingScriptsV2Page
        .createAndReleaseNewTimeBoundedScripts(parentScript, script, verifyDraftParams);
    put(KEY_CREATED_PRICING_SCRIPT_CHILD_1, script);
  }

  @Then("^Operator verify the new Time-Bounded Script is created and released successfully$")
  public void operatorVerifyTheNewTimeBoundedScriptIsCreatedAndReleasedSuccessfully() {
    Script parentScript = get(KEY_CREATED_PRICING_SCRIPT);
    Script script = get(KEY_CREATED_PRICING_SCRIPT_CHILD_1);
    pricingScriptsV2Page
        .verifyTheNewTimeBoundedScriptIsCreatedAndReleasedSuccessfully(parentScript, script);
  }

  @When("Operator delete the Time-Bounded Script")
  public void operatorDeleteTheTimeBoundedScript() {
    Script parentScript = get(KEY_CREATED_PRICING_SCRIPT);
    Script script = get(KEY_CREATED_PRICING_SCRIPT_CHILD_1);
    pricingScriptsV2Page.deleteTimeBoundedScript(parentScript, script);
  }

  @Then("Operator verify the Time-Bounded Script is deleted successfully")
  public void operatorVerifyTheTimeBoundedScriptIsDeletedSuccessfully() {
    Script parentScript = get(KEY_CREATED_PRICING_SCRIPT);
    Script script = get(KEY_CREATED_PRICING_SCRIPT_CHILD_1);
    pricingScriptsV2Page.verifyTimeBoundedScriptIsDeleted(parentScript, script);
  }

  public RunCheckParams runCheckScriptDraftAndActive(Map<String, String> mapOfData) {
    RunCheckParams runCheckParams = new RunCheckParams();

    String orderFields = mapOfData.get("orderFields");
    String deliveryType = mapOfData.get("deliveryType");
    String orderType = mapOfData.get("orderType");
    String serviceLevel = mapOfData.get("serviceLevel");
    String serviceType = mapOfData.get("serviceType");
    String timeslotType = mapOfData.get("timeslotType");
    String isRts = mapOfData.get("isRts");
    String size = mapOfData.get("size");
    double weight = Double.parseDouble(mapOfData.get("weight"));
    double insuredValue = Double.parseDouble(mapOfData.get("insuredValue"));
    double codValue = Double.parseDouble(mapOfData.get("codValue"));
    String fromZone = mapOfData.get("fromZone");
    String toZone = mapOfData.get("toZone");
    String originPricingZone = mapOfData.get("originPricingZone");
    String destinationPricingZone = mapOfData.get("destinationPricingZone");
    String fromL1 = mapOfData.get("fromL1");
    String toL1 = mapOfData.get("toL1");
    String fromL2 = mapOfData.get("fromL2");
    String toL2 = mapOfData.get("toL2");
    String fromL3 = mapOfData.get("fromL3");
    String toL3 = mapOfData.get("toL3");

    runCheckParams.setOrderFields(orderFields);
    runCheckParams.setDeliveryType(deliveryType);
    runCheckParams.setOrderType(orderType);
    runCheckParams.setServiceLevel(serviceLevel);
    runCheckParams.setServiceType(serviceType);
    runCheckParams.setTimeslotType(timeslotType);
    runCheckParams.setIsRts(isRts);
    runCheckParams.setSize(size);
    runCheckParams.setWeight(weight);
    runCheckParams.setInsuredValue(insuredValue);
    runCheckParams.setCodValue(codValue);
    if (Objects.nonNull("fromZone")) {
      runCheckParams.setFromZone(fromZone);
    }
    if (Objects.nonNull("toZone")) {
      runCheckParams.setToZone(toZone);
    }
    if (Objects.nonNull("fromL1")) {
      runCheckParams.setFromL1(fromL1);
    }
    if (Objects.nonNull("fromL2")) {
      runCheckParams.setFromL2(fromL2);
    }
    if (Objects.nonNull("fromL3")) {
      runCheckParams.setFromL3(fromL3);
    }
    if (Objects.nonNull("toL1")) {
      runCheckParams.setToL1(toL1);
    }
    if (Objects.nonNull("toL2")) {
      runCheckParams.setToL2(toL2);
    }
    if (Objects.nonNull("toL3")) {
      runCheckParams.setToL3(toL3);
    }
    if (Objects.nonNull("originPricingZone")) {
      runCheckParams.setOriginPricingZone(originPricingZone);
    }
    if (Objects.nonNull("destinationPricingZone")) {
      runCheckParams.setDestinationPricingZone(destinationPricingZone);
    }
    return runCheckParams;
  }

  public Script editCreatedDraftOrActiveScript(Map<String, String> mapOfData) {
    Script script = get(KEY_CREATED_PRICING_SCRIPT);
    if (Objects.nonNull(mapOfData.get("source"))) {
      String source = mapOfData.get("source");
      script.setSource(source);
    }
    return script;
  }

  @Then("Operator clicks Create Draft button")
  public void operatorClicksCreateDraftButton() {
    pricingScriptsV2Page.createDraftBtn.click();
    takesScreenshot();
  }

  @Then("Operator verifies that error toast is displayed on Pricing Scripts V2 page:")
  public void operatorVerifiesThatErrorToastIsDisplayedOnPricingScriptsVPage(
      Map<String, String> mapOfData) {
    pricingScriptsV2Page.getWebDriver().switchTo().defaultContent();
    if (mapOfData.containsKey("top")) {
      Assertions.assertThat(pricingScriptsV2Page.toastErrorTopText.getText())
          .as("Error top text is correct")
          .isEqualTo(mapOfData.get("top"));
    }
    if (mapOfData.containsKey("bottom")) {
      Assertions.assertThat(pricingScriptsV2Page.toastErrorBottomText.getText())
          .as("Error bottom text is correct").contains(mapOfData.get("bottom"));
    }
  }

  @When("Operator verifies Save button is inactive")
  public void operatorVerifiesSaveButtonIsInactive() {
    Assertions.assertThat(pricingScriptsV2Page.saveBtn.isDisabled()).as("Save Btn is disabled")
        .isTrue();
  }

  @When("Operator verifies Save Draft button is inactive")
  public void operatorVerifiesSaveDraftButtonIsInactive() {
    Assertions.assertThat(pricingScriptsV2CreateEditDraftPage.saveDraftBtn.isDisabled())
        .as("Save Btn is disabled")
        .isTrue();
  }

  @When("Operator link Script to Shipper with ID and Name = {string} and undo the changes")
  public void operatorLinkScriptToShipperWithIDAndNameAndUndoTheChanges(String shipperIdAndName) {
    shipperIdAndName = resolveValue(shipperIdAndName);
    Script script = get(KEY_CREATED_PRICING_SCRIPT);

    Shipper shipper = new Shipper();
    String shipperId = shipperIdAndName.split("-", 2)[0];
    String shipperName = shipperIdAndName.split("-", 2)[1];
    shipper.setLegacyId(Long.parseLong(shipperId));
    shipper.setName(shipperName);

    pricingScriptsV2Page.searchAndSelectShipper(script, shipper);
    pricingScriptsV2Page.clickUndoBtn();
  }

  @Then("Operator clicks Check Syntax")
  public void operatorClicksCheckScript() {
    pricingScriptsV2CreateEditDraftPage.checkSyntaxBtn.clickAndWaitUntilDone();
    takesScreenshot();
  }

  @Then("Operator clicks Verify Draft")
  public void operatorClicksVerifyDraft() {
    pricingScriptsV2CreateEditDraftPage.clickNvIconTextButtonByName("Verify Draft");
    takesScreenshot();
  }

  @Then("Operator clicks Check Syntax, Verify Draft and Validate Draft")
  public void operatorClicksCheckScriptSaveDraft() {
    pricingScriptsV2CreateEditDraftPage.checkSyntaxBtn.clickAndWaitUntilDone();
    pricingScriptsV2CreateEditDraftPage.clickNvIconTextButtonByName("Verify Draft");
    pricingScriptsV2CreateEditDraftPage.validateDraft();
    takesScreenshot();
  }
}
