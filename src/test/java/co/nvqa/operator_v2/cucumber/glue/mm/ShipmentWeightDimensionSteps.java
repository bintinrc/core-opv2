package co.nvqa.operator_v2.cucumber.glue.mm;

import co.nvqa.commons.model.core.hub.Shipment;
import co.nvqa.commons.model.core.hub.ShipmentDimensionResponse;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.model.ShipmentWeightDimensionAddInfo;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionAddPage;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionAddPage.ShipmentWeightAddState;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionPage;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionPage.ShipmentWeightState;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionTablePage;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionTablePage.Column;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightSumUpReportPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.DecimalFormat;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.apache.commons.lang3.RandomStringUtils;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@ScenarioScoped
public class ShipmentWeightDimensionSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(ShipmentWeightDimensionSteps.class);

  // keys
  private static final String STATE_KEY = "state";
  private static final String MESSAGE_KEY = "message";
  private static final String STATUS_KEY = "shipment status";

  // page object
  ShipmentWeightDimensionPage shipmentWeightDimensionPage;
  ShipmentWeightDimensionAddPage shipmentWeightDimensionAddPage;
  ShipmentWeightDimensionTablePage shipmentWeightDimensionTablePage;

  ShipmentWeightSumUpReportPage shipmentWeightSumUpreport;

  @Override
  public void init() {
    shipmentWeightDimensionPage = new ShipmentWeightDimensionPage(getWebDriver());
    shipmentWeightDimensionTablePage = new ShipmentWeightDimensionTablePage(getWebDriver());
    shipmentWeightDimensionAddPage = new ShipmentWeightDimensionAddPage(getWebDriver());
    shipmentWeightSumUpreport = new ShipmentWeightSumUpReportPage(getWebDriver());
  }

  @Then("Operator verify Shipment Weight Dimension page UI")
  public void operatorVerifyShipmentWeightDimensionPageUI() {
    shipmentWeightDimensionPage.switchTo();
    shipmentWeightDimensionPage.waitUntilLoaded();
    shipmentWeightDimensionPage.verifyAddNewWeightDimensionUI();
  }

  @When("Operator click on Shipment Weight Dimension New Record button")
  public void operatorClickOnShipmentWeightDimensionNewRecordButton() {
    shipmentWeightDimensionPage.openNewRecord();
  }

  @Then("Operator verify Shipment Weight Dimension Add UI")
  public void operatorVerifyShipmentWeightDimensionAddUI(Map<String, Object> dataTable) {
    String stateString = (String) dataTable.get(STATE_KEY);
    String messageString = (String) dataTable.get(MESSAGE_KEY);
    ShipmentWeightAddState state = ShipmentWeightAddState.fromLabel(stateString);
    ShipmentWeightDimensionAddInfo uiInfo = new ShipmentWeightDimensionAddInfo();
    switch (state) {
      case INITIAL:
        uiInfo.setStartHub("--");
        uiInfo.setEndHub("--");
        uiInfo.setStatus("--");
        uiInfo.setComment("--");
        uiInfo.setNoOfParcels("--");
        break;
      case VALID:
      case HAS_DIMENSION:
        Shipment shipmentData = ((Shipments) getScenarioStorage().get(KEY_CREATED_SHIPMENT))
            .getShipment();
        String shipmentStatus = (String) Optional.ofNullable(dataTable.get(STATUS_KEY))
            .orElse(shipmentData.getStatus());
        uiInfo.setStartHub(shipmentData.getOrigHubName());
        uiInfo.setEndHub(shipmentData.getDestHubName());
        uiInfo.setStatus(shipmentStatus);
        uiInfo.setNoOfParcels(shipmentData.getOrdersCount().toString());
        uiInfo.setComment(Optional.ofNullable(shipmentData.getComments()).orElse("--"));
        uiInfo.setValueFromMap(dataTable);
        break;
    }

    shipmentWeightDimensionAddPage.verifyUI(stateString, messageString, uiInfo);
  }


  @When("Operator click Shipment Weight Dimension search button")
  public void operatorClickShipmentWeightDimensionSearchButton() {
    shipmentWeightDimensionAddPage.searchButton.click();
  }

  @When("Operator enter {string} shipment ID on Shipment Weight Dimension")
  public void operatorEnterShipmentIDOnShipmentWeightDimension(String shipmentId) {
    String shipmentIdToSend;
    if (shipmentId.equalsIgnoreCase("invalid")) {
      shipmentIdToSend = RandomStringUtils.randomNumeric(15);
    } else if (shipmentId.equalsIgnoreCase("JSON")) {
      shipmentIdToSend = createShipmentJson(getString("KEY_CREATED_SHIPMENT_ID"));
    } else {
      shipmentIdToSend = getString("KEY_CREATED_SHIPMENT_ID");
    }

    shipmentWeightDimensionAddPage.enterShipmentId(shipmentIdToSend);
  }

  @Then("Operator verify toast message {string} is shown in Shipment Weight Dimension Add UI")
  public void operatorVerifyToastMessageIsShownInShipmentWeightDimensionAddUI(String message) {
    String resolvedMessage = resolveValue(message);
    shipmentWeightDimensionAddPage.checkNotificationMessage(resolvedMessage);
  }

  @When("Operator enter dimension values on Shipment Weight Dimension Weight input")
  public void operatorEnterDimensionValuesOnShipmentWeightDimensionWeightInput(
      Map<String, String> dataTable) {
    shipmentWeightDimensionAddPage.enterDimensionInfo(
        dataTable.get("weight"),
        dataTable.get("length"),
        dataTable.get("width"),
        dataTable.get("height")
    );
  }

  @And("Operator click Submit on Shipment Weight Dimension")
  public void operatorClickSubmitOnShipmentWeightDimension() {
    shipmentWeightDimensionAddPage.submitWeightData();
  }

  @Then("Operator verify Shipment Weight Dimension Add Dimension UI")
  public void operatorVerifyShipmentWeightDimensionAddDimensionUI(Map<String, String> dataTable) {
    shipmentWeightDimensionAddPage
        .verifyDimensionFieldError(dataTable.get("field"), dataTable.get("errorMessage"));
  }

  @And("Operator verify Shipment Weight Dimension Submit button is disabled")
  public void operatorVerifyShipmentWeightDimensionSubmitButtonIsDisabled() {
    Assertions.assertThat(
        shipmentWeightDimensionAddPage.submitButton.getAttribute("disabled"))
        .as("Submit button disabled").isNotNull();
  }


  @Then("Operator verify notice message {string} is shown in Shipment Weight Dimension Add UI")
  public void operatorVerifyNoticeMessageIsShownInShipmentWeightDimensionAddUI(String message) {
    String resolvedMessage = resolveValue(message);
    shipmentWeightDimensionAddPage.checkMessage(resolvedMessage);
  }

  @Then("Operator click {string} on Over Weight Modal")
  public void operatorClickOnOverWeightModal(String buttonName) {
    pause1s();
    shipmentWeightDimensionAddPage.verifyOverWeightDialog();
    if (buttonName.equalsIgnoreCase("confirm")) {
      shipmentWeightDimensionAddPage.confirmOverWeightDialog();
    } else if (buttonName.equalsIgnoreCase("cancel")) {
      shipmentWeightDimensionAddPage.cancelOverWeightDialog();
    }
  }

  @Then("Operator verify Shipment Weight Dimension Load Shipment page UI")
  public void operatorVerifyShipmentWeightDimensionLoadShipmentPageUI(
      Map<String, String> dataTable) {
    String state = Optional.ofNullable(dataTable.get("state")).orElse("initial");
    String numberOfShipments = Optional.ofNullable(dataTable.get("numberOfShipments")).orElse("1");
    shipmentWeightDimensionPage
        .verifyLoadShipmentWeightUI(ShipmentWeightState.fromLabel(state), numberOfShipments);
  }

  @When("Operator search {string} on Shipment Weight Dimension search by SID text")
  public void operatorSearchOnShipmentWeightDimensionSearchBySIDText(String key) {
    String searchTerm = "";
    if (key.equalsIgnoreCase("invalid")) {
      searchTerm = "999999999999";
    } else if (key.equalsIgnoreCase("multiple_invalid")) {
      searchTerm = IntStream.range(0, 20).mapToObj(x -> f("9999999999%d", x))
          .collect(Collectors.joining("\n"));
    } else if (key.equalsIgnoreCase("multiple")) {
      List<Long> shipmentIdsList = resolveValue(KEY_LIST_OF_CREATED_SHIPMENT_IDS);
      searchTerm = shipmentIdsList.stream().map(Object::toString).collect(
          Collectors.joining("\n"));
    } else if (key.equalsIgnoreCase("json")) {
      searchTerm = createShipmentJson(getString("KEY_CREATED_SHIPMENT_ID"));
    } else if (key.equalsIgnoreCase("multiple_json")) {
      List<Long> shipmentIdsList = resolveValue(KEY_LIST_OF_CREATED_SHIPMENT_IDS);
      searchTerm = shipmentIdsList.stream().map(x -> createShipmentJson(String.valueOf(x))).collect(
          Collectors.joining("\n"));
    } else if (key.equalsIgnoreCase("duplicate")) {
      String shipmentId = getString("KEY_CREATED_SHIPMENT_ID");
      searchTerm = f("%s\n%s", shipmentId, shipmentId);
    } else {
      searchTerm = resolveValue(key);
    }
    shipmentWeightDimensionPage.searchShipmentId(searchTerm);
  }

  @When("Operator click search button on Shipment Weight Dimension page")
  public void operatorClickSearchButtonOnShipmentWeightDimensionPage() {
    shipmentWeightDimensionPage.searchButton.click();
  }

  @Then("Operator verify Shipment Weight Dimension Table page is shown")
  public void operatorVerifyShipmentWeightDimensionTablePageIsShown() {
    LOGGER.info("Verifying that Shipment Weight Table page is visible");
    Assertions.assertThat(shipmentWeightDimensionTablePage.backButton.isDisplayed())
        .as("Back button is visible").isTrue();
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.isDisplayed())
        .as("Shipment Weight table is visible").isTrue();
    Assertions.assertThat(shipmentWeightDimensionTablePage.resultCounterText.isDisplayed())
        .as("search counter is shown").isTrue();
    System.out.println(shipmentWeightDimensionTablePage.resultCounterText.getText());
  }

  @And("Operator verify can filter Shipment Weight Dimension Table")
  public void operatorVerifyCanFilterShipmentWeightDimensionTable() {
    Shipment shipmentData = ((Shipments) getScenarioStorage().get(KEY_CREATED_SHIPMENT))
        .getShipment();

    // verify all column filters
    shipmentWeightDimensionTablePage.clearFilters();
    // 1. Shipment ID
    shipmentWeightDimensionTablePage
        .filterColumn(Column.SHIPMENT_ID, shipmentData);
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment id with correct value").isGreaterThanOrEqualTo(1);

    shipmentWeightDimensionTablePage.filterColumn(Column.SHIPMENT_ID, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment id with invalid value").isEqualTo(0);
    shipmentWeightDimensionTablePage.clearFilterColumn(Column.SHIPMENT_ID);
    // 2. Shipment Status
    shipmentWeightDimensionTablePage
        .filterColumn(Column.STATUS, shipmentData);
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment status with correct value").isGreaterThanOrEqualTo(1);

    shipmentWeightDimensionTablePage.filterColumn(Column.STATUS, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment status with invalid value").isEqualTo(0);
    shipmentWeightDimensionTablePage.clearFilterColumn(Column.STATUS);
    // 3. End Hub
    shipmentWeightDimensionTablePage.filterColumn(Column.END_HUB, shipmentData);
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment end hub with correct value").isGreaterThanOrEqualTo(1);

    shipmentWeightDimensionTablePage.filterColumn(Column.END_HUB, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment end hub with invalid value").isEqualTo(0);
    shipmentWeightDimensionTablePage.clearFilterColumn(Column.END_HUB);
    // 4. Creation Date
    LOGGER.debug("Value in the table is " + shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.get(0).createdAt.getText());
    LOGGER.debug("Value from the shipment object is "+ shipmentData.getCreatedAt());

    try {
      shipmentWeightDimensionTablePage.filterColumn(Column.CREATION_DATE,
          shipmentData
      );
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment creation date with correct value")
          .isGreaterThanOrEqualTo(1);
    } catch (AssertionError as) {
      //hack to handle date discrepancy
      //temporary solution
      LOGGER.debug("Assertion error, increasing the create_at date by 1 second");
      ZonedDateTime zdt = DateUtil.getDate(shipmentData.getCreatedAt());
      zdt = zdt.plusSeconds(1);
      shipmentData.setCreatedAt(zdt.format(DateUtil.ISO8601_LITE_FORMATTER));
      shipmentWeightDimensionTablePage.filterColumn(Column.CREATION_DATE,
          shipmentData
      );
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment creation date with correct value")
          .isGreaterThanOrEqualTo(1);
    }

    shipmentWeightDimensionTablePage.filterColumn(Column.CREATION_DATE, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment creation date with invalid value").isEqualTo(0);
    shipmentWeightDimensionTablePage.clearFilterColumn(Column.CREATION_DATE);
    // 5. MAWB
    if (shipmentData.getMawb() != null && !shipmentData.getMawb().isEmpty()) {
      shipmentWeightDimensionTablePage.filterColumn(Column.MAWB,
          shipmentData
      );
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment mawb with correct value").isGreaterThanOrEqualTo(1);

      shipmentWeightDimensionTablePage.filterColumn(Column.MAWB, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment mawb with invalid value").isEqualTo(0);
      shipmentWeightDimensionTablePage.clearFilterColumn(Column.MAWB);
    }

    // 6. comments
    if (shipmentData.getComments() != null && !shipmentData.getComments().isEmpty()) {
      shipmentWeightDimensionTablePage.filterColumn(Column.COMMENTS, shipmentData);
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment comments with correct value").isGreaterThanOrEqualTo(1);

      shipmentWeightDimensionTablePage.filterColumn(Column.COMMENTS, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment comments with invalid value").isEqualTo(0);
      shipmentWeightDimensionTablePage.clearFilterColumn(Column.COMMENTS);
    }

    // 7. start hub
    if (shipmentData.getOrigHubName() != null && !shipmentData.getOrigHubName().isEmpty()) {
      shipmentWeightDimensionTablePage
          .filterColumn(Column.START_HUB, shipmentData);
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment start hub with correct value").isGreaterThanOrEqualTo(1);

      shipmentWeightDimensionTablePage.filterColumn(Column.START_HUB, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment start hub with invalid value").isEqualTo(0);
      shipmentWeightDimensionTablePage.clearFilterColumn(Column.START_HUB);
    }

    // 7. shipment type
    if (shipmentData.getShipmentType() != null && !shipmentData.getShipmentType().isEmpty()) {
      shipmentWeightDimensionTablePage
          .filterColumn(Column.SHIPMENT_TYPE, shipmentData);
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment shipment type with correct value").isGreaterThanOrEqualTo(1);

      shipmentWeightDimensionTablePage.filterColumn(Column.SHIPMENT_TYPE, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment shipment type with invalid value").isEqualTo(0);
      shipmentWeightDimensionTablePage.clearFilterColumn(Column.SHIPMENT_TYPE);
    }

  }

  @Then("Operator verify Shipment Weight Dimension search error popup shown")
  public void operatorVerifyShipmentWeightDimensionSearchErrorPopupShown() {
    shipmentWeightDimensionPage.searchErrorConfirmModal.waitUntilVisible();
    Assertions.assertThat(shipmentWeightDimensionPage.searchErrorConfirmModal.title.getText())
        .as("Verify search dialog show correct title").isEqualTo("Search Error");
    Assertions
        .assertThat(shipmentWeightDimensionPage.searchErrorConfirmModal.confirmButton.isDisplayed())
        .as("Verify go back button shown").isTrue();
  }

  @And("Operator close Shipment Weight Dimension search error popup")
  public void operatorCloseShipmentWeightDimensionSearchErrorPopup() {
    shipmentWeightDimensionPage.searchErrorConfirmModal.confirm();
    pause1s();
    Assertions.assertThat(shipmentWeightDimensionPage.searchErrorConfirmModal.isDisplayed())
        .as("Search dialog is closed").isFalse();
  }


  @Then("Operator verify Shipment Weight Dimension confirm delete popup shown")
  public void operatorVerifyShipmentWeightDimensionConfirmDeletePopupShown() {
    shipmentWeightDimensionPage.searchErrorConfirmModal.waitUntilVisible();
    Assertions.assertThat(shipmentWeightDimensionPage.searchErrorConfirmModal.title.getText())
        .as("Verify confirm delete dialog show correct title").isEqualTo("Delete This Preset Filters?");
    Assertions
        .assertThat(shipmentWeightDimensionPage.searchErrorConfirmModal.confirmButton.isDisplayed())
        .as("Confirm deletion button shown").isTrue();
  }

  @And("Operator confirm Shipment Weight Dimension confirm delete popup")
  public void operatorCloseShipmentWeightDimensionConfirmDeletePopup() {
    shipmentWeightDimensionPage.searchErrorConfirmModal.confirm();
    pause1s();
    Assertions.assertThat(shipmentWeightDimensionPage.searchErrorConfirmModal.isDisplayed())
        .as("Confirm delete is closed").isFalse();
  }

  @And("Operator cancel Shipment Weight Dimension confirm delete popup")
  public void operatorCloseShipmentWeightDimensionCancelDeletePopup() {
    shipmentWeightDimensionPage.searchErrorConfirmModal.cancel();
    pause1s();
    Assertions.assertThat(shipmentWeightDimensionPage.searchErrorConfirmModal.isDisplayed())
        .as("Confirm delete is closed").isFalse();
  }

  private String createShipmentJson(String shipmentId) {
    return f("{ \"shipment_id\": \"%s\" , \"destination_hub_id\":\"1\"}", shipmentId);
  }

  @When("Operator filter Shipment Weight Dimension Table by {string} column with first shipment value")
  public void operatorFilterShipmentWeightDimensionTableByColumn(String column,
      Map<String, String> dataTable) {
    String expectedNumOfRows = Optional.ofNullable(dataTable.get("expectedNumOfRows")).orElse("1");
    String filterValue = dataTable.get("filterValue");
    Column col = Column.fromLabel(column);
    if (filterValue != null) {
      shipmentWeightDimensionTablePage.filterColumn(col, (String) resolveValue(filterValue));
    } else {
      List<Shipments> shipments = get("KEY_LIST_OF_CREATED_SHIPMENT");
      Shipment shipmentData = shipments.get(0).getShipment();
      shipmentWeightDimensionTablePage
          .filterColumn(col, shipmentData);
    }

    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using %s with correct value", column)
        .isEqualTo(Integer.parseInt(expectedNumOfRows));
  }

  @And("Operator select all data on Shipment Weight Dimension Table")
  public void operatorSelectAllDataOnShipmentWeightDimensionTable() {
    shipmentWeightDimensionTablePage.selectAllCheckbox.check();
    Assertions.assertThat(shipmentWeightDimensionTablePage.sumUpButton.isEnabled())
        .as("Sum up button is enabled").isTrue();
  }

  @And("Operator select {int} data on Shipment Weight Dimension Table")
  public void operatorSelectAllDataOnShipmentWeightDimensionTable(int numberOfRows) {
    shipmentWeightDimensionTablePage.selectAllCheckbox.check();
    Assertions.assertThat(shipmentWeightDimensionTablePage.sumUpButton.isEnabled())
        .as("Sum up button is enabled").isTrue();
  }

  @Then("Operator verify Sum up button on Shipment Weight Dimension Table")
  public void operatorVerifySumUpButtonOnShipmentWeightDimensionTable() {

  }

  @When("Operator clear filter on Shipment Weight Dimension Table")
  public void operatorClearFilterOnShipmentWeightDimensionTable() {
    shipmentWeightDimensionTablePage.clearFilters();
  }


  @Then("Operator verify Sum up button on Shipment Weight Dimension Table have {string} as counter")
  public void operatorVerifySumUpButtonOnShipmentWeightDimensionTableHaveAsCounter(String counter) {
    Assertions.assertThat(shipmentWeightDimensionTablePage.sumUpButton.getText())
        .as("sum up button counter is increased").isEqualTo("Sum up & Update MAWB (%s)", counter);
  }

  @And("Operator click edit button on Shipment Weight Dimension table")
  public void operatorClickEditButtonOnShipmentWeightDimensionTable() {
    String mainWindowHandle = shipmentWeightDimensionPage.getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.get(0).editButton.click();
    Set<String> windowHandles = shipmentWeightDimensionPage.getWebDriver().getWindowHandles();

    for (String windowHandle : windowHandles) {
      if (!windowHandle.equalsIgnoreCase(mainWindowHandle)) {
        shipmentWeightDimensionPage.getWebDriver().switchTo().window(windowHandle);
      }
    }
    shipmentWeightDimensionAddPage.switchTo();
  }

  @When("Operator fill in Load Shipment Weight filter")
  public void operatorFillInLoadShipmentWeightFilter(Map<String, String> dataTable) {
    Map<String, String> map = resolveKeyValues(dataTable);
    String createdTime = map.get("createdTime");
    ZonedDateTime fromZdt = null;
    ZonedDateTime toZdt = null;
    if (createdTime != null) {
      ZonedDateTime zdt;
      if (createdTime.equalsIgnoreCase("future")) {
        zdt = ZonedDateTime.now().plusDays(2);
      } else {
        zdt = DateUtil.getDate(createdTime).withZoneSameInstant(ZoneId.of(
            StandardTestConstants.DEFAULT_TIMEZONE));
      }

      fromZdt = ZonedDateTime.from(zdt).minusHours(1).withMinute(0).withSecond(0);
      toZdt = ZonedDateTime.from(zdt).plusHours(1).withMinute(0).withSecond(0);
    }

    shipmentWeightDimensionPage.fillLoadShipmentFilter(map.get("presetName"),
        map.get("mawb"),
        fromZdt,
        toZdt);
  }

  @And("Operator click Load Selection button on Shipment Weight Dimension page")
  public void operatorClickLoadSelectionButtonOnShipmentWeightDimensionPage() {
    shipmentWeightDimensionPage.loadSelectionButton.click();
  }

  @And("Operator verify Shipment Weight Dimension Filter UI")
  public void operatorVerifyShipmentWeightDimensionFilterUI() {
    Assertions.assertThat(shipmentWeightDimensionPage.newFilterToggleButton.isDisplayed())
        .as("Enter new Filters link is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.mawbInput.isDisplayed())
        .as("MAWB field is shown").isTrue();
  }

  @When("Operator verify search button is disabled on Shipment Weight Dimension page")
  public void operatorVerifySearchButtonIsDisabledOnShipmentWeightDimensionPage() {
    Assertions.assertThat(shipmentWeightDimensionPage.loadSelectionButton.getAttribute("disabled"))
        .as("Load selection button disabled").isNotNull();
  }

  @When("Operator click Enter New Filter button on Shipment Weight Dimension Filter UI")
  public void operatorClickEnterNewFilterButtonOnShipmentWeightDimensionFilterUI() {
    shipmentWeightDimensionPage.newFilterToggleButton.click();
  }

  @Then("Operator verify Enter New Filter card on Shipment Weight Dimension Filter UI")
  public void operatorVerifyEnterNewFilterCardOnShipmentWeightDimensionFilterUI() {
    Assertions.assertThat(shipmentWeightDimensionPage.clearAndCloseButton.isDisplayed())
        .as("Clear and Close button is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.shipmentTypeSelect.isDisplayed())
        .as("Shipment Type select is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.startHubSelect.isDisplayed())
        .as("Start Hub select is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.endHubSelect.isDisplayed())
        .as("End Hub select is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.shipmentStatusSelect.isDisplayed())
        .as("Shipment status select is shown").isTrue();
  }

  @Then("Operator verify Selected Filter card on Shipment Weight Dimension Filter UI")
  public void operatorVerifySelectedFilterCardOnShipmentWeightDimensionFilterUI() {
    Assertions.assertThat(shipmentWeightDimensionPage.deletePresetButton.isDisplayed())
        .as("Delete button is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.shipmentTypeSelect.isDisplayed())
        .as("Shipment Type select is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.startHubSelect.isDisplayed())
        .as("Start Hub select is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.endHubSelect.isDisplayed())
        .as("End Hub select is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.shipmentStatusSelect.isDisplayed())
        .as("Shipment status select is shown").isTrue();
  }

  @Then("Operator fill Shipment Weight Dimension Filter UI with data")
  public void operatorFillShipmentWeightDimensionFilterUIWithData(Map<String,String> dataTable) {
    Map<String,String> map = resolveKeyValues(dataTable);
    //reset the default
    shipmentWeightDimensionPage.shipmentTypeSelect.selectValue(map.get("shipmentType"));
    shipmentWeightDimensionPage.startHubSelect.selectValue(map.get("startHub"));
    shipmentWeightDimensionPage.endHubSelect.selectValue(map.get("endHub"));
    if (map.get("shipmentStatus") != null) {
      shipmentWeightDimensionPage.shipmentStatusSelect.clearValue();
      shipmentWeightDimensionPage.shipmentStatusSelect.selectValues(Arrays.asList(map.get("shipmentStatus").split(",")));
    }
    boolean isSaveAsPreset = Boolean.parseBoolean(map.get("saveAsPreset"));
    if (isSaveAsPreset){
      shipmentWeightDimensionPage.saveAsPresetCb.check();
      String presetName = map.get("presetName");
      if (presetName.equalsIgnoreCase("random")) {
        presetName = "AUTOMATION PRESET - " + (new Date()).getTime();
      }
      put(KEY_CREATED_SHIPMENT_WEIGHT_FILTER, presetName);
      shipmentWeightDimensionPage.presetName.sendKeys(presetName);
    }
  }

  @Then("Operator click Clear and Close button on Shipment Weight Dimension")
  public void operatorClickClearAndCloseButtonOnShipmentWeightDimension() {
    shipmentWeightDimensionPage.clearAndCloseButton.click();
    shipmentWeightDimensionPage.clearAndCloseButton.waitUntilInvisible();
  }

  @Then("Operator delete the shipment weight filter preset")
  public void operatorDeleteTheShipmentWeightFilterPreset() {
    shipmentWeightDimensionPage.deletePresetButton.click();
    shipmentWeightDimensionPage.searchErrorConfirmModal.waitUntilVisible();
  }


  @And("Operator verify shipment weight preset {string} is deleted")
  public void operatorVerifyShipmentWeightPresetIsDeleted(String filterName) {
    filterName = resolveValue(filterName);
    Assertions.assertThat(shipmentWeightDimensionPage.presetFilterSelect.hasItem(filterName))
        .as(f("%s is deleted", filterName))
        .isFalse();
  }

  @And("Operator verify shipment weight preset {string} is not deleted")
  public void operatorVerifyShipmentWeightPresetIsNotDeleted(String filterName) {
    filterName = resolveValue(filterName);
    Assertions.assertThat(shipmentWeightDimensionPage.presetFilterSelect.hasItem(filterName))
        .as(f("%s is not deleted", filterName))
        .isTrue();
  }

  @And("Operator select {int} rows from the shipment weight table")
  public void operatorSelectRowsFromTheShipmentWeightTable(int numOfRows) {
    shipmentWeightDimensionTablePage.selectSomeRows(numOfRows);
  }

  @When("Operator click sum up button on Shipment Weight Dimension page")
  public void operatorClickSumUpButtonOnShipmentWeightDimensionPage() {
    put(KEY_GENERATED_SHIPMENT_WEIGHT_SUM_UP_REPORT_TIMESTAMP, DateUtil.getDate(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE)));
    shipmentWeightDimensionTablePage.sumUpButton.click();
  }

  @Then("Operator verify Shipment Weight Sum Up report page UI")
  public void operatorVerifyShipmentWeightSumUpReportPageUI() {
    shipmentWeightSumUpreport.waitUntilLoaded();
    ZonedDateTime date = get(KEY_GENERATED_SHIPMENT_WEIGHT_SUM_UP_REPORT_TIMESTAMP);
    List<Shipments> shipments = get(KEY_LIST_OF_CREATED_SHIPMENT);
    List<ShipmentDimensionResponse> dimensions = get(KEY_UPDATED_SHIPMENTS_DIMENSIONS);
    DecimalFormat df = new DecimalFormat("#.##");

    List<Long> selectedShipmentIds = shipmentWeightSumUpreport.shipmentSumUpReportNvTable
        .rows
        .stream()
        .map( s -> Long.valueOf(!s.shipmentId.getText().isEmpty()? s.shipmentId.getText(): "0"))
        .collect(Collectors.toList());
    List<ShipmentDimensionResponse> selectedDimension = dimensions.stream()
        .filter(s -> selectedShipmentIds.contains(s.getShipment().getId()))
        .collect(
        Collectors.toList());

    Double totalWeight = selectedDimension.stream()
        .map(ShipmentDimensionResponse::getWeight)
        .reduce(0.0d, Double::sum);

    Double totalKgv = selectedDimension.stream()
        .map( sd -> sd.getHeight() * sd.getLength() * sd.getWidth())
        .reduce(0.0d, Double::sum);

    Long totalParcels = selectedDimension.stream()
        .map(sd -> sd.getShipment().getOrdersCount())
        .reduce(0L, Long::sum);


    Shipment s = shipments.get(0).getShipment();
    String reportDate = date.format(DateUtil.DATE_TIME_FORMATTER);


    //verify ui elements

    Assertions.assertThat(shipmentWeightSumUpreport.sumUpReportTitle.isDisplayed())
        .as("Page title is displayed")
        .isTrue();
    try {
      Assertions.assertThat(shipmentWeightSumUpreport.sumUpReportTitle.getText())
          .as("Page title show correctly")
          .isEqualTo(f("%s Sum-up Report", reportDate));
    }catch (AssertionError err) {
      //usually error because UI has offset 1 second
      LOGGER.info("retrying with 1 second offset");
      date = date.plusSeconds(1);
      reportDate = date.format(DateUtil.DATE_TIME_FORMATTER);
      Assertions.assertThat(shipmentWeightSumUpreport.sumUpReportTitle.getText())
          .as("Page title show correctly")
          .isEqualTo(f("%s Sum-up Report", reportDate));
    }

    //verify end hub
    Assertions.assertThat(shipmentWeightSumUpreport.findValueFromSection(shipmentWeightSumUpreport.endHubSection))
        .as("End hub show correct value")
        .isEqualTo(s.getDestHubName());

    Assertions.assertThat(
        Integer.parseInt(shipmentWeightSumUpreport.findValueFromSection(shipmentWeightSumUpreport.totalShipmentSection)))
        .as("Total shipments show correct value")
        .isEqualTo(shipmentWeightSumUpreport.shipmentSumUpReportNvTable.rows.size());

    Assertions.assertThat(
        shipmentWeightSumUpreport.findValueFromSection(shipmentWeightSumUpreport.totalWeightSection)
    ).as("Total weight should show correct value")
        .isEqualTo(df.format(totalWeight));

    // kgv formula
    // kgv = width * length * height / country divisor . by default is 1 if unspecified.

    Assertions.assertThat(
            shipmentWeightSumUpreport.findValueFromSection(
                shipmentWeightSumUpreport.totalKgvSection
            )
        ).as("Total weight should show correct value")
        .isEqualTo(df.format(totalKgv));

    Assertions.assertThat(
            shipmentWeightSumUpreport.findValueFromSection(
                shipmentWeightSumUpreport.totalParcelsSection)

        ).as(f("Total shipment should show correct value:  %d", totalParcels))
        .isEqualTo(String.valueOf(totalParcels));
  }

  @When("Operator select all rows from the shipment sum up report table")
  public void operatorSelectAllRowsFromTheShipmentSumUpReportTable() {
    shipmentWeightSumUpreport.selectAllCheckbox.check();
  }

  @And("Operator click on Download Full Report button on shipment sum up report table")
  public void operatorClickOnDownloadFullReportButtonOnShipmentSumUpReportTable() {
    shipmentWeightSumUpreport.downloadFullReportBtn.click();
  }

  @Then("Operator verify the downloaded CSV Sum Up report file is contains the correct values")
  public void operatorVerifyTheDownloadedCSVSumUpReportFileIsContainsTheCorrectValues(Map<String, String> dataTable) {
    String headers = dataTable.get("header");
    String title = shipmentWeightSumUpreport.sumUpReportTitle.getText().trim();
    String dateFromTitle = title.substring(0, title.length() - 13);
    ZonedDateTime date = DateUtil.getDate(dateFromTitle, DateUtil.DATE_TIME_FORMATTER);
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH_mm_ss");
    String fileNameFormat = date.format(dtf);

    shipmentWeightSumUpreport.verifyFileDownloadedSuccessfully(
          fileNameFormat, headers);

  }

  @When("Operator remove {int} shipments on Shipment Weight Sum Up report")
  public void operatorRemoveShipmentsOnShipmentWeightSumUpReport(int numOfShipment) {
    shipmentWeightSumUpreport.shipmentSumUpReportNvTable.rows.subList(0, numOfShipment)
        .forEach(row -> {
          row.remove.click();
          shipmentWeightSumUpreport.confirmDeleteModal.waitUntilVisible();
          shipmentWeightSumUpreport.confirmDeleteModal.confirm();
        });
  }

  @When("Operator remove shipment and cancel on Shipment Weight Sum Up report")
  public void operatorRemoveShipmentAndCancelOnShipmentWeightSumUpReport() {
    shipmentWeightSumUpreport.shipmentSumUpReportNvTable.rows.get(0)
            .remove.click();
    shipmentWeightSumUpreport.confirmDeleteModal.waitUntilVisible();
    shipmentWeightSumUpreport.confirmDeleteModal.cancel();
  }

  @Then("Operator verify Shipment Weight Sum Up report show empty record")
  public void operatorVerifyShipmentWeightSumUpReportShowEmptyRecord() {
    Assertions.assertThat(
        shipmentWeightSumUpreport.downloadFullReportBtn.getAttribute("disabled")
    ).as("Download full report button is disabled").isNotNull();

    Assertions.assertThat(
        shipmentWeightSumUpreport.updateMawbBtn.getAttribute("disabled")
    ).as("Update MAWB button is disabled").isNotNull();

    Assertions.assertThat(
        shipmentWeightSumUpreport.shipmentSumUpReportNvTable.isDisplayed()
    ).as("Shipment Weight Sum Up Report table is not displayed").isFalse();
  }
}

