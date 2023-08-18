package co.nvqa.operator_v2.cucumber.glue.mm;

import co.nvqa.common.mm.utils.MiddleMileUtils;
import co.nvqa.commons.model.core.hub.Shipment;
import co.nvqa.commons.model.core.hub.ShipmentDimensionResponse;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.model.ShipmentWeightDimensionAddInfo;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionAddPage;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionAddPage.ShipmentWeightAddState;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionPage;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionPage.ShipmentWeightState;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionTablePage;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionTablePage.Column;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionUpdateMawbPage;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightSumUpReportPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
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

import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_MM_EXISTING_SHIPMENT_SWB;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_MM_LIST_OF_CREATED_SHIPMENTS;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_MM_SHIPMENT_SWB;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_MM_LIST_OF_CREATED_MAWBS;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_MM_LIST_OF_CREATED_SWBS;
import static co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionTablePage.Column.SHIPMENT_ID;

@ScenarioScoped
public class ShipmentWeightDimensionSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(ShipmentWeightDimensionSteps.class);

  // keys
  private static final String STATE_KEY = "state";
  private static final String MESSAGE_KEY = "message";
  private static final String STATUS_KEY = "shipment status";
  private static final String FILE_NAME = " Sum Up Report - Shipment Weight Dimension.csv";

  // page object
  ShipmentWeightDimensionPage shipmentWeightDimensionPage;
  ShipmentWeightDimensionAddPage shipmentWeightDimensionAddPage;
  ShipmentWeightDimensionTablePage shipmentWeightDimensionTablePage;
  ShipmentWeightDimensionUpdateMawbPage shipmentWeightDimensionUpdateMawbPage;
  ShipmentWeightSumUpReportPage shipmentWeightSumUpreport;

  @Override
  public void init() {
    shipmentWeightDimensionPage = new ShipmentWeightDimensionPage(getWebDriver());
    shipmentWeightDimensionTablePage = new ShipmentWeightDimensionTablePage(getWebDriver());
    shipmentWeightDimensionAddPage = new ShipmentWeightDimensionAddPage(getWebDriver());
    shipmentWeightSumUpreport = new ShipmentWeightSumUpReportPage(getWebDriver());
    shipmentWeightDimensionUpdateMawbPage = new ShipmentWeightDimensionUpdateMawbPage(getWebDriver());
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
    pause1s(); // give time for ui to load
    String stateString = (String) dataTable.get(STATE_KEY);
    String messageString = (String) dataTable.get(MESSAGE_KEY);
    String shipmentIdKey = (String) dataTable.get("shipmentIdKey");
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
        Shipment shipmentData = get(KEY_CREATED_SHIPMENT) != null? ((Shipments) get(KEY_CREATED_SHIPMENT)).getShipment() : null;
        if (getScenarioStorage().containsKey(KEY_SHIPMENT_DETAILS) && null != ((Shipments)getScenarioStorage().get(KEY_SHIPMENT_DETAILS)).getShipment()) {
          shipmentData = ((Shipments)getScenarioStorage().get(KEY_SHIPMENT_DETAILS)).getShipment();
        }
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
      shipmentIdToSend = resolveValue(shipmentId);
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
    } else if (key.equalsIgnoreCase("multiple_invalid_more_300")) {
      searchTerm = IntStream.range(0, 301).mapToObj(x -> f("9999999999%d", x))
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
    Assertions.assertThat(shipmentWeightDimensionTablePage.backToMainButton.isDisplayed())
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
        .filterColumn(SHIPMENT_ID, shipmentData);
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
        .as("Able to filter by using shipment id with correct value").isNotEmpty();

    shipmentWeightDimensionTablePage.filterColumn(SHIPMENT_ID, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
        .as("Able to filter by using shipment id with invalid value").isEmpty();
    shipmentWeightDimensionTablePage.clearFilterColumn(SHIPMENT_ID);
    // 2. Shipment Status
    shipmentWeightDimensionTablePage
        .filterColumn(Column.STATUS, shipmentData);
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
        .as("Able to filter by using shipment status with correct value").isNotEmpty();

    shipmentWeightDimensionTablePage.filterColumn(Column.STATUS, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
        .as("Able to filter by using shipment status with invalid value").isEmpty();
    shipmentWeightDimensionTablePage.clearFilterColumn(Column.STATUS);
    // 3. End Hub
    shipmentWeightDimensionTablePage.filterColumn(Column.END_HUB, shipmentData);
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
        .as("Able to filter by using shipment end hub with correct value").isNotEmpty();

    shipmentWeightDimensionTablePage.filterColumn(Column.END_HUB, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
        .as("Able to filter by using shipment end hub with invalid value").isEmpty();
    shipmentWeightDimensionTablePage.clearFilterColumn(Column.END_HUB);
    // 4. Creation Date
    LOGGER.debug("Value in the table is " + shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.get(0).createdAt.getText());
    LOGGER.debug("Value from the shipment object is "+ shipmentData.getCreatedAt());

    try {
      shipmentWeightDimensionTablePage.filterColumn(Column.CREATION_DATE,
          shipmentData
      );
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
          .as("Able to filter by using shipment creation date with correct value")
          .isNotEmpty();
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
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
          .as("Able to filter by using shipment creation date with correct value")
          .isNotEmpty();
    }

    shipmentWeightDimensionTablePage.filterColumn(Column.CREATION_DATE, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
        .as("Able to filter by using shipment creation date with invalid value").isEmpty();
    shipmentWeightDimensionTablePage.clearFilterColumn(Column.CREATION_DATE);
    // 5. Billing Number
    if (shipmentData.getMawb() != null && !shipmentData.getMawb().isEmpty()) {
      shipmentWeightDimensionTablePage.filterColumn(Column.BILLING_NUMBER,
          shipmentData
      );
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
          .as("Able to filter by using shipment billing number with correct value").isNotEmpty();

      shipmentWeightDimensionTablePage.filterColumn(Column.BILLING_NUMBER, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
          .as("Able to filter by using shipment billing number with invalid value").isEmpty();
      shipmentWeightDimensionTablePage.clearFilterColumn(Column.BILLING_NUMBER);
    }

    // 6. comments
    if (shipmentData.getComments() != null && !shipmentData.getComments().isEmpty()) {
      shipmentWeightDimensionTablePage.filterColumn(Column.COMMENTS, shipmentData);
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
          .as("Able to filter by using shipment comments with correct value").isNotEmpty();

      shipmentWeightDimensionTablePage.filterColumn(Column.COMMENTS, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
          .as("Able to filter by using shipment comments with invalid value").isEmpty();
      shipmentWeightDimensionTablePage.clearFilterColumn(Column.COMMENTS);
    }

    // 7. start hub
    if (shipmentData.getOrigHubName() != null && !shipmentData.getOrigHubName().isEmpty()) {
      shipmentWeightDimensionTablePage
          .filterColumn(Column.START_HUB, shipmentData);
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
          .as("Able to filter by using shipment start hub with correct value").isNotEmpty();

      shipmentWeightDimensionTablePage.filterColumn(Column.START_HUB, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
          .as("Able to filter by using shipment start hub with invalid value").isEmpty();
      shipmentWeightDimensionTablePage.clearFilterColumn(Column.START_HUB);
    }

    // 8. shipment type
    if (shipmentData.getShipmentType() != null && !shipmentData.getShipmentType().isEmpty()) {
      shipmentWeightDimensionTablePage
          .filterColumn(Column.SHIPMENT_TYPE, shipmentData);
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
          .as("Able to filter by using shipment shipment type with correct value").isNotEmpty();

      shipmentWeightDimensionTablePage.filterColumn(Column.SHIPMENT_TYPE, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
          .as("Able to filter by using shipment shipment type with invalid value").isEmpty();
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
    String expectedNumOfRows = dataTable.getOrDefault("expectedNumOfRows", "1");
    String filterValue = dataTable.get("filterValue");
    Column col = Column.fromLabel(column);
    if (filterValue != null) {
      shipmentWeightDimensionTablePage.filterColumn(col, (String) resolveValue(filterValue));
    } else {
      List<Shipments> shipments = get(KEY_LIST_OF_CREATED_SHIPMENT);
      Shipment shipmentData = shipments.get(0).getShipment();
      if (col != SHIPMENT_ID && Integer.parseInt(expectedNumOfRows) == 1) {
        shipmentWeightDimensionTablePage
            .filterColumn(SHIPMENT_ID, shipmentData);
      }
      shipmentWeightDimensionTablePage
          .filterColumn(col, shipmentData);
    }

    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
        .as("Able to filter by using %s with correct value", column)
        .hasSize(Integer.parseInt(expectedNumOfRows));
  }

  @When("Operator filter Shipment Weight Dimension Table by {string} column with shipment {string} - migrated")
  public void operatorFilterShipmentWeightDimensionTableByColumnMigrated(String column, String shipment,
      Map<String, String> dataTable) {
    String expectedNumOfRows = dataTable.getOrDefault("expectedNumOfRows", "1");
    String filterValue = dataTable.get("filterValue");
    Column col = Column.fromLabel(column);
    Map<String, String> keyIdx = MiddleMileUtils.getKeyIndex(shipment);
    co.nvqa.common.mm.model.Shipment shipmentData = getList(keyIdx.get("key"), co.nvqa.common.mm.model.Shipment.class).get(
        Integer.parseInt(keyIdx.get("idx")));
    if (filterValue != null) {
      shipmentWeightDimensionTablePage.filterColumn(col, (String) resolveValue(filterValue));
    } else {
      if (col != SHIPMENT_ID && Integer.parseInt(expectedNumOfRows) == 1) {
        shipmentWeightDimensionTablePage
            .filterColumn(SHIPMENT_ID, shipmentData);
      }
      shipmentWeightDimensionTablePage
          .filterColumn(col, shipmentData);
    }

    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows)
        .as("Able to filter by using %s with correct value", column)
        .hasSize(Integer.parseInt(expectedNumOfRows));
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
        .as("sum up button counter is increased").isEqualTo("Sum up (%s)", counter);
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
    Assertions.assertThat(shipmentWeightDimensionPage.searchByBillinNumberButton.isEnabled())
        .as("Search by Billing Number is shown").isTrue();
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

  @Then("Operator verify disabled Selected Filter card on Shipment Weight Dimension Filter UI")
  public void operatorVerifyDisabledSelectedFilterCardOnShipmentWeightDimensionFilterUI() {
    Assertions.assertThat(shipmentWeightDimensionPage.deletePresetButton.isDisplayed())
        .as("Delete button is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.disabledShipmentTypeSelect.isDisplayed())
        .as("Shipment Type select is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.disabledStartHubSelect.isDisplayed())
        .as("Start Hub select is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.disabledEndHubSelect.isDisplayed())
        .as("End Hub select is shown").isTrue();
    Assertions.assertThat(shipmentWeightDimensionPage.disabledShipmentStatusSelect.isDisplayed())
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
    if (dimensions == null) {
      dimensions = Collections.singletonList(get(KEY_UPDATED_SHIPMENT_DIMENSIONS));
    }
    DecimalFormat df = new DecimalFormat("#.##");

    List<String> selectedShipmentIds = shipmentWeightSumUpreport.shipmentSumUpReportNvTable
        .rows
        .stream()
        .map( s -> s.shipmentId.getText())
        .collect(Collectors.toList());

    put(KEY_LIST_SELECTED_SHIPMENT_IDS, selectedShipmentIds);
    List<ShipmentDimensionResponse> selectedDimension = dimensions.stream()
        .filter(s -> selectedShipmentIds.contains(String.valueOf(s.getShipment().getId())))
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

  @Then("Operator verify Shipment Weight Sum Up report page UI for shipment {string} - migrated")
  public void operatorVerifyShipmentWeightSumUpReportPageUIMigrated(String shipment) {
    Map<String, String> keyIdx = MiddleMileUtils.getKeyIndex(shipment);
    co.nvqa.common.mm.model.Shipment shipmentData = getList(keyIdx.get("key"), co.nvqa.common.mm.model.Shipment.class).get(
        Integer.parseInt(keyIdx.get("idx")));

    shipmentWeightSumUpreport.waitUntilLoaded();
    ZonedDateTime date = get(KEY_GENERATED_SHIPMENT_WEIGHT_SUM_UP_REPORT_TIMESTAMP);
//    List<Shipments> shipments = get(KEY_LIST_OF_CREATED_SHIPMENT);
    List<ShipmentDimensionResponse> dimensions = get(KEY_UPDATED_SHIPMENTS_DIMENSIONS);
    if (dimensions == null) {
      dimensions = Collections.singletonList(get(KEY_UPDATED_SHIPMENT_DIMENSIONS));
    }
    DecimalFormat df = new DecimalFormat("#.##");

    List<String> selectedShipmentIds = shipmentWeightSumUpreport.shipmentSumUpReportNvTable
        .rows
        .stream()
        .map( s -> s.shipmentId.getText())
        .collect(Collectors.toList());

    put(KEY_LIST_SELECTED_SHIPMENT_IDS, selectedShipmentIds);
    List<ShipmentDimensionResponse> selectedDimension = dimensions.stream()
        .filter(s -> selectedShipmentIds.contains(String.valueOf(s.getShipment().getId())))
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


//    Shipment s = shipments.get(0).getShipment();
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
        .isEqualTo(shipmentData.getDestHubName());

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
    String dateFromTitle = title.substring(0, title.length() - 14);

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH_mm_ss");
    LocalDateTime date = LocalDateTime.parse(dateFromTitle, DateUtil.DATE_TIME_FORMATTER);

    String fileNameFormat = date.format(dtf) + FILE_NAME;

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
        shipmentWeightSumUpreport.updateBillingNumberBtn.getAttribute("disabled")
    ).as("Update MAWB button is disabled").isNotNull();

    Assertions.assertThat(
        shipmentWeightSumUpreport.shipmentSumUpReportNvTable.isDisplayed()
    ).as("Shipment Weight Sum Up Report table is not displayed").isFalse();
  }

  @When("Operator click update MAWB button on Shipment Weight Sum Up page")
  public void operatorClickUpdateMAWBButtonOnShipmentWeightSumUpPage() {
    //add the selected shipment ids
    List<String> selectedShipmentIds = shipmentWeightSumUpreport.shipmentSumUpReportNvTable
            .rows.stream().map(r -> r.shipmentId.getText()).collect(Collectors.toList());
    put(KEY_LIST_SELECTED_SHIPMENT_IDS, selectedShipmentIds);
    shipmentWeightSumUpreport.updateBillingNumberBtn.click();
    shipmentWeightSumUpreport.selectBillingNumberTypeDialog.waitUntilVisible();
    shipmentWeightSumUpreport.mawbBillingNumberRadio.check();
    shipmentWeightSumUpreport.continueUpdateBillingBtn.click();
  }

  @Then("Operator verify Shipment Weight Update MAWB page UI")
  public void operatorVerifyShipmentWeightUpdateMAWBPageUI() {
    shipmentWeightDimensionUpdateMawbPage.waitUntilLoaded();
    List<String> selectedShipmentIds = get(KEY_LIST_SELECTED_SHIPMENT_IDS, new ArrayList<>());
    //verify the table
    if (selectedShipmentIds.size()!=0) {
      shipmentWeightDimensionUpdateMawbPage.shipmentWeightNvTable.rows.forEach( row -> {
        Assertions.assertThat(selectedShipmentIds)
          .as(f("Shipment id %s is selected from previous page", row.shipmentId.getText()))
          .contains(row.shipmentId.getText());
      });
    }


    //verify UI component
    Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.backButton.isDisplayed())
        .as("Back button is displayed")
        .isTrue();

    Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.updateMawbBtn.isDisplayed())
        .as("Update MAWB button is displayed")
        .isTrue();

    Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.mawbInput.isDisplayed())
        .as("MAWB input is displayed")
        .isTrue();

    Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.vendorSelect.isDisplayed())
        .as("Vendor input is displayed")
        .isTrue();

    Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.originAirportSelect.isDisplayed())
        .as("Origin Airport input is displayed")
        .isTrue();

    Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.destAirportSelect.isDisplayed())
        .as("Destination Airport input is displayed")
        .isTrue();

  }

  @When("Operator update MAWB information on shipment weight dimension page with following data")
  public void operatorUpdateMAWBInformationOnShipmentWeightDimensionPageWithFollowingData(Map<String, String> dataTable) {
    dataTable = resolveKeyValues(dataTable);
    String mawb = dataTable.get("mawb");
    //filling the form
    if (mawb.equalsIgnoreCase("random")) {
      mawb = "000-"+ RandomStringUtils.randomNumeric(8, 9);
    } else if (mawb.equalsIgnoreCase("invalid")) {
      mawb = "000-123456";
    } else if (mawb.equalsIgnoreCase("alfabet")) {
      mawb ="abcdefg?";
    } else if (mawb.equalsIgnoreCase("empty")) {
      mawb = "";
    }
    put(KEY_SHIPMENT_UPDATED_AWB, mawb);
    putInList(KEY_MM_LIST_OF_CREATED_MAWBS, mawb);

    shipmentWeightDimensionUpdateMawbPage.mawbInput.sendKeys(mawb);
    shipmentWeightDimensionUpdateMawbPage.vendorSelect.selectValue(dataTable.get("vendor"));
    shipmentWeightDimensionUpdateMawbPage.originAirportSelect.selectValue(dataTable.get("origin"));
    shipmentWeightDimensionUpdateMawbPage.destAirportSelect.selectValue(dataTable.get("destination"));
  }

  @Then("Operator click update button on shipment weight update mawb page")
  public void operatorClickUpdateButtonOnShipmentWeightUpdateMawbPage() {
    Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.updateMawbBtn.getAttribute("disabled"))
        .as("Update button is enabled")
        .isNull();

    shipmentWeightDimensionUpdateMawbPage.updateMawbBtn.click();
    pause2s();
    if(shipmentWeightDimensionUpdateMawbPage.confirmSameMawbDialog.isDisplayed())
    {
      shipmentWeightDimensionUpdateMawbPage.confirmSameMawbDialog.confirm();
      shipmentWeightDimensionUpdateMawbPage.confirmSameMawbDialog.waitUntilInvisible();
    }
    shipmentWeightSumUpreport.waitUntilLoaded();
  }

  @And("Operator verify Shipment Weight Update MAWB page UI updated with new MAWB")
  public void operatorVerifyShipmentWeightUpdateMAWBPageUIUpdatedWithNewMAWB() {
    retryIfAssertionErrorOccurred(() -> {
      String newMawb = get(KEY_SHIPMENT_UPDATED_AWB);
      shipmentWeightSumUpreport.shipmentSumUpReportNvTable.rows.forEach(
              row -> {
                Assertions.assertThat(row.mawb.getText())
                        .as("MAWB is updated with new value")
                        .isEqualTo(newMawb);
              }
      );
    }, "retrying the validation", 1000, 3);
  }

  @Given("Operator take note of the existing mawb")
  public void operatorTakeNoteOfTheExistingMawb() {
    String mawb = get(KEY_SHIPMENT_AWB);
    put(KEY_EXISTING_SHIPMENT_AWB, mawb);
    putInList(KEY_MM_LIST_OF_CREATED_MAWBS, mawb);
    put(KEY_SHIPMENT_AWB, null);
    put(KEY_LIST_OF_CREATED_SHIPMENT_IDS, null);
  }

  @And("Operator click confirm on the Shipment weight update confirm dialog")
  public void operatorClickConfirmOnTheShipmentWeightUpdateConfirmDialog() {
    shipmentWeightDimensionUpdateMawbPage.confirmSameMawbDialog.confirm();
    shipmentWeightDimensionUpdateMawbPage.confirmSameMawbDialog.waitUntilInvisible();
  }

  @Then("Operator verify Shipment Weight Update MAWB page UI has error")
  public void operatorVerifyShipmentWeightUpdateMAWBPageUIHasError(Map<String, String> dataTable) {
    String errorMessage = dataTable.get("message");
    Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.updateMawbBtn.getAttribute("disabled"))
        .as("Update mawb button is disabled")
        .isNotNull();
    if (errorMessage != null && !errorMessage.isEmpty()) {
      Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.mawbErrorInfo.isDisplayed())
          .as("MAWB input has error message")
          .isTrue();
      Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.mawbErrorInfo.getText())
          .as("Show correct error message")
          .isEqualTo(errorMessage);
    }
  }

  @And("Operator click cancel on the Shipment weight update confirm dialog")
  public void operatorClickCancelOnTheShipmentWeightUpdateConfirmDialog() {
    shipmentWeightDimensionUpdateMawbPage.confirmSameMawbDialog.waitUntilVisible();
    shipmentWeightDimensionUpdateMawbPage.confirmSameMawbDialog.cancel();
    shipmentWeightDimensionUpdateMawbPage.confirmSameMawbDialog.waitUntilInvisible();
  }

  @When("Operator click update MAWB button on Shipment Weight Dimension page")
  public void operatorClickUpdateMAWBButtonOnShipmentWeightDimensionPage() {
    shipmentWeightDimensionTablePage.updateBillingNumberButton.click();
    shipmentWeightSumUpreport.selectBillingNumberTypeDialog.waitUntilVisible();
    shipmentWeightSumUpreport.mawbBillingNumberRadio.check();
    shipmentWeightSumUpreport.continueUpdateBillingBtn.click();
  }

  @Then("Operator click update button only on shipment weight update mawb page")
  public void operatorClickUpdateButtonOnlyOnShipmentWeightUpdateMawbPage() {
    Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.updateMawbBtn.getAttribute("disabled"))
        .as("Update button is enabled")
        .isNull();

    shipmentWeightDimensionUpdateMawbPage.updateMawbBtn.click();
    pause2s();
  }

  @When("Operator click Update Billing Number {string} on Shipment Weight Dimension page")
  public void operatorClickUpdateBillingNumberOnShipmentWeightDimenasionPage(String billingNumberType) {
    shipmentWeightDimensionTablePage.updateBillingNumberButton.click();
    shipmentWeightSumUpreport.selectBillingNumberTypeDialog.waitUntilVisible();
    switch(billingNumberType) {
      case "MAWB":
        shipmentWeightSumUpreport.mawbBillingNumberRadio.check();
        shipmentWeightSumUpreport.continueUpdateBillingBtn.click();
        break;
      case "SWB":
        shipmentWeightSumUpreport.swbBillingNumberRadio.check();
        shipmentWeightSumUpreport.continueUpdateBillingBtn.click();
        break;
      case "BOTH":
        shipmentWeightSumUpreport.bothBillingNumberRadio.check();
        shipmentWeightSumUpreport.continueUpdateBillingBtn.click();
        break;
    }

  }

  @Then("Operator verify Shipment Weight Update Billing Number {string} page UI")
  public void operatorVerifyShipmentWeightUpdateBillingNumberPageUI(String billingNumberType) {
    shipmentWeightDimensionUpdateMawbPage.waitUntilLoaded();
    List<String> selectedShipmentIds = get(KEY_LIST_SELECTED_SHIPMENT_IDS, new ArrayList<>());
    //verify the table
    if (selectedShipmentIds.size()!=0) {
      shipmentWeightDimensionUpdateMawbPage.shipmentWeightNvTable.rows.forEach( row -> {
        Assertions.assertThat(selectedShipmentIds)
                .as(f("Shipment id %s is selected from previous page", row.shipmentId.getText()))
                .contains(row.shipmentId.getText());
      });
    }

    switch (billingNumberType) {
      //verify UI component
      case "MAWB":
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.backButton.isDisplayed()).as("Back button is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.updateMawbBtn.isDisplayed()).as("Update button is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.mawbInput.isDisplayed()).as("MAWB input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.vendorSelect.isDisplayed()).as("Vendor input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.originAirportSelect.isDisplayed()).as("Origin Airport input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.destAirportSelect.isDisplayed()).as("Destination Airport input is displayed").isTrue();
        break;
      case "SWB":
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.backButton.isDisplayed()).as("Back button is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.updateMawbBtn.isDisplayed()).as("Update button is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.swbInput.isDisplayed()).as("SWB input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.seahaulVendorSelect.isDisplayed()).as("Seaport Vendor input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.originSeaportSelect.isDisplayed()).as("Origin Seaport input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.destinationSeaportSelect.isDisplayed()).as("Destination Seaport input is displayed").isTrue();
        break;
      case "BOTH":
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.backButton.isDisplayed()).as("Back button is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.updateMawbBtn.isDisplayed()).as("Update button is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.mawbInput.isDisplayed()).as("MAWB input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.vendorSelect.isDisplayed()).as("Vendor input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.originAirportSelect.isDisplayed()).as("Origin Airport input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.destAirportSelect.isDisplayed()).as("Destination Airport input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.swbInput.isDisplayed()).as("SWB input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.seahaulVendorSelect.isDisplayed()).as("Seaport Vendor input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.originSeaportSelect.isDisplayed()).as("Origin Seaport input is displayed").isTrue();
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.destinationSeaportSelect.isDisplayed()).as("Destination Seaport input is displayed").isTrue();
        break;
    }
  }

  @When("Operator update billing number {string} information on Shipment Weight Dimension page with following data:")
  public void operatorUpdateBillingNumberInformationOnShipmentWeightDimensionPageWithFollowingData(String billingNumberType, Map<String, String> dataTable) {
    dataTable = resolveKeyValues(dataTable);
    switch(billingNumberType) {
      case "MAWB":
        String mawb = dataTable.get("mawb");
        if (mawb.equalsIgnoreCase("random")) {
          mawb = "000-"+ RandomStringUtils.randomNumeric(8, 9);
        } else if (mawb.equalsIgnoreCase("random-6-digits")) {
          mawb = RandomStringUtils.randomNumeric(6);
        } else if (mawb.equalsIgnoreCase("random-3-10-digits")) {
          mawb = RandomStringUtils.randomNumeric(3) + "-" + RandomStringUtils.randomNumeric(10);
        }  else if (mawb.equalsIgnoreCase("random-3-4-4-digits")) {
          mawb = RandomStringUtils.randomNumeric(3) + "-" + RandomStringUtils.randomNumeric(4) + "-" + RandomStringUtils.randomNumeric(4);
        } else if (mawb.equalsIgnoreCase("invalid")) {
          mawb = "000-123456";
        } else if (mawb.equalsIgnoreCase("alfabet")) {
          mawb ="abcdefg?";
        } else if (mawb.equalsIgnoreCase("empty")) {
          mawb = "";
        } else if (mawb.equalsIgnoreCase("tbn-lower-random")) {
          mawb = "tbn-" + RandomStringUtils.randomNumeric(8);
        } else if (mawb.equalsIgnoreCase("tbn-upper-random")) {
          mawb = "TBN-" + RandomStringUtils.randomNumeric(8);
        } else if (mawb.equalsIgnoreCase("tbn-mix-random")) {
          mawb = "TBn-" + RandomStringUtils.randomNumeric(8);
        } else if (mawb.equalsIgnoreCase("ai-d-lower-random")) {
          mawb = "ai-d" + RandomStringUtils.randomNumeric(6);
        } else if (mawb.equalsIgnoreCase("ai-d-upper-random")) {
          mawb = "AI-D" + RandomStringUtils.randomNumeric(6);
        } else if (mawb.equalsIgnoreCase("ai-d-mix-random")) {
          mawb = "aI-d" + RandomStringUtils.randomNumeric(6);
        }else if (mawb.equalsIgnoreCase("ai-lower-random")) {
          mawb = "ai-" + RandomStringUtils.randomNumeric(6);
        } else if (mawb.equalsIgnoreCase("ai-upper-random")) {
          mawb = "AI-" + RandomStringUtils.randomNumeric(6);
        } else if (mawb.equalsIgnoreCase("ai-mix-random")) {
          mawb = "aI-" + RandomStringUtils.randomNumeric(6);
        }
        put(KEY_SHIPMENT_UPDATED_AWB, mawb);
        putInList(KEY_MM_LIST_OF_CREATED_MAWBS, mawb);

        shipmentWeightDimensionUpdateMawbPage.mawbInput.sendKeys(mawb);
        shipmentWeightDimensionUpdateMawbPage.vendorSelect.selectValue(dataTable.get("vendor"));
        shipmentWeightDimensionUpdateMawbPage.originAirportSelect.selectValue(dataTable.get("origin"));
        shipmentWeightDimensionUpdateMawbPage.destAirportSelect.selectValue(dataTable.get("destination"));
        break;
      case "SWB":
        String swb = dataTable.get("swb");
        if (swb.equalsIgnoreCase("random")) {
          swb = RandomStringUtils.randomNumeric(6);
        } else if (swb.equalsIgnoreCase("random-5-digits")) {
          swb = RandomStringUtils.randomNumeric(5);
        } else if (swb.equalsIgnoreCase("kmmt-upper-random")) {
          swb = "KMMT" + RandomStringUtils.randomNumeric(3);
        } else if (swb.equalsIgnoreCase("kmmt-mix-random")) {
          swb = "KMmt" + RandomStringUtils.randomNumeric(3);
        } else if (swb.equalsIgnoreCase("kmmt-lower-random")) {
          swb = "kmmt" + RandomStringUtils.randomNumeric(3);
        } else if (swb.equalsIgnoreCase("r11b-upper-random")) {
          swb = "R11B" + RandomStringUtils.randomNumeric(7);
        } else if (swb.equalsIgnoreCase("r11b-mix-random")) {
          swb = "R11b" + RandomStringUtils.randomNumeric(7);
        } else if (swb.equalsIgnoreCase("r11b-lower-random")) {
          swb = "r11b" + RandomStringUtils.randomNumeric(7);
        } else if (swb.equalsIgnoreCase("r11b-upper-8-random")) {
          swb = "R11B" + RandomStringUtils.randomNumeric(8);
        } else if (swb.equalsIgnoreCase("r11b-mix-8-random")) {
          swb = "R11b" + RandomStringUtils.randomNumeric(8);
        } else if (swb.equalsIgnoreCase("r11b-lower-8-random")) {
          swb = "r11b" + RandomStringUtils.randomNumeric(8);
        } else if (swb.equalsIgnoreCase("k14b-upper-random")) {
          swb = "K14B" + RandomStringUtils.randomNumeric(7);
        } else if (swb.equalsIgnoreCase("k14b-mix-random")) {
          swb = "K14b" + RandomStringUtils.randomNumeric(7);
        } else if (swb.equalsIgnoreCase("k14b-lower-random")) {
          swb = "k14b" + RandomStringUtils.randomNumeric(7);
        } else if (swb.equalsIgnoreCase("k14b-upper-8-random")) {
          swb = "K14B" + RandomStringUtils.randomNumeric(8);
        } else if (swb.equalsIgnoreCase("k14b-mix-8-random")) {
          swb = "K14b" + RandomStringUtils.randomNumeric(8);
        } else if (swb.equalsIgnoreCase("k14b-lower-8-random")) {
          swb = "k14b" + RandomStringUtils.randomNumeric(8);
        } else if (swb.equalsIgnoreCase("k28b-upper-8-random")) {
          swb = "K28B" + RandomStringUtils.randomNumeric(8);
        } else if (swb.equalsIgnoreCase("k28b-mix-8-random")) {
          swb = "K28b" + RandomStringUtils.randomNumeric(8);
        } else if (swb.equalsIgnoreCase("k28b-lower-8-random")) {
          swb = "k28b" + RandomStringUtils.randomNumeric(8);
        } else if (swb.equalsIgnoreCase("invalid")) {
          swb = "00112233445566";
        } else if (swb.equalsIgnoreCase("alfabet")) {
          swb = "abcdef";
        } else if (swb.equalsIgnoreCase("empty")) {
          swb = "";
        }
        put(KEY_MM_SHIPMENT_SWB, swb);
        putInList(KEY_MM_LIST_OF_CREATED_SWBS, swb);

        shipmentWeightDimensionUpdateMawbPage.swbInput.sendKeys(swb);
        shipmentWeightDimensionUpdateMawbPage.seahaulVendorSelect.selectValue(dataTable.get("seahaulVendor"));
        shipmentWeightDimensionUpdateMawbPage.originSeaportSelect.selectValue(dataTable.get("originSeahaul"));
        shipmentWeightDimensionUpdateMawbPage.destinationSeaportSelect.selectValue(dataTable.get("destinationSeahaul"));
        break;
      case "BOTH":
        mawb = dataTable.get("mawb");
        if (mawb.equalsIgnoreCase("random")) {
          mawb = "000-"+ RandomStringUtils.randomNumeric(8, 9);
        } else if (mawb.equalsIgnoreCase("invalid")) {
          mawb = "000-123456";
        } else if (mawb.equalsIgnoreCase("alfabet")) {
          mawb ="abcdefg?";
        } else if (mawb.equalsIgnoreCase("empty")) {
          mawb = "";
        }
        put(KEY_SHIPMENT_UPDATED_AWB, mawb);
        putInList(KEY_MM_LIST_OF_CREATED_MAWBS, mawb);
        shipmentWeightDimensionUpdateMawbPage.mawbInput.sendKeys(mawb);
        shipmentWeightDimensionUpdateMawbPage.vendorSelect.selectValue(dataTable.get("airhaulVendor"));
        shipmentWeightDimensionUpdateMawbPage.originAirportSelect.selectValue(dataTable.get("originAirhaul"));
        shipmentWeightDimensionUpdateMawbPage.destAirportSelect.selectValue(dataTable.get("destinationAirhaul"));

        swb = dataTable.get("swb");
        if (swb.equalsIgnoreCase("random")) {
          swb = RandomStringUtils.randomNumeric(6);
        } else if (swb.equalsIgnoreCase("invalid")) {
          swb = "00112233445566";
        } else if (swb.equalsIgnoreCase("alfabet")) {
          swb = "abcdef";
        } else if (swb.equalsIgnoreCase("empty")) {
          swb = "";
        }
        put(KEY_MM_SHIPMENT_SWB, swb);
        putInList(KEY_MM_LIST_OF_CREATED_SWBS, swb);
        shipmentWeightDimensionUpdateMawbPage.swbInput.sendKeys(swb);
        shipmentWeightDimensionUpdateMawbPage.seahaulVendorSelect.selectValue(dataTable.get("seahaulVendor"));
        shipmentWeightDimensionUpdateMawbPage.originSeaportSelect.selectValue(dataTable.get("originSeahaul"));
        shipmentWeightDimensionUpdateMawbPage.destinationSeaportSelect.selectValue(dataTable.get("destinationSeahaul"));
        break;
    }
  }

  @And("Operator verify Update Billing Number {string} has updated with new value {string}")
  public void operatorVerifyUpdateBillingNumberHasUpdatedWithNewValue(String billingNumberType, String billingNumberValue) {
    switch(billingNumberType) {
      case "MAWB":
        retryIfAssertionErrorOccurred(() -> {
          String newMawb = resolveValue(billingNumberValue);
          shipmentWeightSumUpreport.shipmentSumUpReportNvTable.rows.forEach(
                  row -> {
                    Assertions.assertThat(row.mawb.getText())
                            .as("MAWB is updated with new value")
                            .isEqualTo(newMawb);
                  }
          );
        }, "retrying the validation", 1000, 3);
      case "SWB":
        retryIfAssertionErrorOccurred(() -> {
          String newSwb = resolveValue(billingNumberValue);
          shipmentWeightSumUpreport.shipmentSumUpReportNvTable.rows.forEach(
                  row -> {
                    Assertions.assertThat(row.billingNumber.getText())
                            .as("SWB is updated with new value")
                            .contains(newSwb);
                  }
          );
        }, "retrying the validation", 1000, 3);
        break;
      case "BOTH":
        retryIfAssertionErrorOccurred(() -> {
          String mawbSwb = resolveValue(billingNumberValue);
          shipmentWeightSumUpreport.shipmentSumUpReportNvTable.rows.forEach(
                  row -> {
                    Assertions.assertThat(row.billingNumber.getText())
                            .as("MAWB and SWB is updated with new value")
                            .isEqualTo(mawbSwb);
                  }
          );
        }, "retrying the validation", 1000, 3);
        break;
    }
  }

  @Given("Operator take note of the existing {string}")
  public void operatorTakeNoteOfTheExisting(String billingNumberType) {
    switch(billingNumberType) {
      case "MAWB":
        String mawb = get(KEY_SHIPMENT_AWB);
        put(KEY_EXISTING_SHIPMENT_AWB, mawb);
        put(KEY_SHIPMENT_AWB, null);
        put(KEY_LIST_OF_CREATED_SHIPMENT_IDS, null);
        break;
      case "SWB":
        String swb = get(KEY_MM_SHIPMENT_SWB);
        put(KEY_MM_EXISTING_SHIPMENT_SWB, swb);
        put(KEY_MM_SHIPMENT_SWB, null);
        put(KEY_LIST_OF_CREATED_SHIPMENT_IDS, null);
        break;
    }
  }

  @Then("Operator verifies Update Billing Number {string} page UI has error")
  public void operatorVerifiesUpdateBillingNumberPageUIHasError(String billingNumberType, Map<String,String> dataTable) {
    switch (billingNumberType) {
      case "MAWB":
        String errorMessage = dataTable.get("airwayBillMessage");
        Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.updateMawbBtn.getAttribute("disabled")).as("Update mawb button is disabled").isNotNull();
        if (errorMessage != null && !errorMessage.isEmpty()) {
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.mawbErrorInfo.isDisplayed()).as("MAWB input has error message").isTrue();
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.mawbErrorInfo.getText()).as("Show correct error message").isEqualTo(errorMessage);
        }
        break;
      case "SWB":
        String swbErrorMessage = dataTable.get("seawayBillMessage");
        if (swbErrorMessage != null && !swbErrorMessage.isEmpty()) {
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.swbErrorInfo.isDisplayed()).as("SWB input has error message").isTrue();
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.swbErrorInfo.getText()).as("Show correct error message").isEqualTo(swbErrorMessage);
        }

        String emptySWBNumberErrorMessage = dataTable.get("emptySWBNumberErrorMessage");
        if (emptySWBNumberErrorMessage != null && emptySWBNumberErrorMessage.isEmpty()) {
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptySeaportVendorErrorInfo.isDisplayed()).as("Empty SWB Number error message is shown").isTrue();
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptySeaportVendorErrorInfo.getText()).as("Showing empty SWB Number error message").isEqualTo(emptySWBNumberErrorMessage);
        }

        String emptySeahaulVendorErrorMessage = dataTable.get("emptySeahaulVendorErrorMessage");
        if (emptySeahaulVendorErrorMessage != null && !emptySeahaulVendorErrorMessage.isEmpty()) {
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptySeaportVendorErrorInfo.isDisplayed()).as("Empty seahaul vendor error message is shown").isTrue();
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptySeaportVendorErrorInfo.getText()).as("Showing empty seahaul vendor error message").isEqualTo(emptySeahaulVendorErrorMessage);
        }

        String emptyOriginSeaportErrorMessage = dataTable.get("emptyOriginSeaportErrorMessage");
        if (emptyOriginSeaportErrorMessage != null && !emptyOriginSeaportErrorMessage.isEmpty()) {
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptyOriginSeaportErrorInfo.isDisplayed()).as("Empty origin seaport error message is shown").isTrue();
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptyOriginSeaportErrorInfo.getText()).as("Showing empty origin seaport error message").isEqualTo(emptyOriginSeaportErrorMessage);
        }

        String emptyDestinationSeaportErrorMessage = dataTable.get("emptyDestinationSeaportErrorMessage");
        if (emptyDestinationSeaportErrorMessage != null && !emptyDestinationSeaportErrorMessage.isEmpty()) {
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptyDestinationSeaportErrorInfo.isDisplayed()).as("Empty destination seaport error message is shown").isTrue();
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptyDestinationSeaportErrorInfo.getText()).as("Showing empty destination seaport error message").isEqualTo(emptyDestinationSeaportErrorMessage);
        }

        String sameOriginDestinationSeaportErrorMessage = dataTable.get("sameOriginDestinationSeaportErrorMessage");
        if (sameOriginDestinationSeaportErrorMessage != null && !sameOriginDestinationSeaportErrorMessage.isEmpty()) {
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptyOriginSeaportErrorInfo.isDisplayed()).as("Empty origin seaport error message is shown on Origin Seaport field").isTrue();
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptyOriginSeaportErrorInfo.getText()).as("Showing empty origin seaport error message on Origin Seaport field").isEqualTo(sameOriginDestinationSeaportErrorMessage);
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptyDestinationSeaportErrorInfo.isDisplayed()).as("Same origin and destination seaport error message is shown on Destination Seaport field").isTrue();
          Assertions.assertThat(shipmentWeightDimensionUpdateMawbPage.emptyDestinationSeaportErrorInfo.getText()).as("Showing same origin and destination seaport error message on Destination Seaport field").isEqualTo(sameOriginDestinationSeaportErrorMessage);
        }
        break;
    }
  }

  @And("Operator clicks clear {string} button on {string} Shipment Weight Dimension page")
  public void operatorClicksClearButtonOnShipmentWeightDimensionPage(String inputField, String billingNumberType) {
    switch (billingNumberType) {
      case "Update Seaway Bill":
        if(inputField.equalsIgnoreCase("SWB Number")) {
          shipmentWeightDimensionUpdateMawbPage.hoverUpdateBillNumberField(inputField);
          shipmentWeightDimensionUpdateMawbPage.swbInput.clear();
        } else if(inputField.equalsIgnoreCase("Sea Haul Vendor")) {
          shipmentWeightDimensionUpdateMawbPage.hoverUpdateBillNumberField(inputField);
          shipmentWeightDimensionUpdateMawbPage.clearSeahaulVendorButton.click();
        } else if(inputField.equalsIgnoreCase("Origin Seaport")) {
          shipmentWeightDimensionUpdateMawbPage.hoverUpdateBillNumberField(inputField);
          shipmentWeightDimensionUpdateMawbPage.clearOriginSeaportButton.click();
        } else if(inputField.equalsIgnoreCase("Destination Seaport")) {
          shipmentWeightDimensionUpdateMawbPage.hoverUpdateBillNumberField(inputField);
          shipmentWeightDimensionUpdateMawbPage.clearDestinationSeaportButton.click();
        }
        break;
      case "Update Airway Bill":
        if(inputField.equalsIgnoreCase("Air Haul Vendor")) {
          shipmentWeightDimensionUpdateMawbPage.hoverUpdateBillNumberField(inputField);
          shipmentWeightDimensionUpdateMawbPage.clearAirhaulVendorButton.click();
        } else if(inputField.equalsIgnoreCase("Origin Airport")) {
          shipmentWeightDimensionUpdateMawbPage.hoverUpdateBillNumberField(inputField);
          shipmentWeightDimensionUpdateMawbPage.clearOriginAirportButton.click();
        } else if(inputField.equalsIgnoreCase("Destination Airport")) {
          shipmentWeightDimensionUpdateMawbPage.hoverUpdateBillNumberField(inputField);
          shipmentWeightDimensionUpdateMawbPage.clearDestinationAirportButton.click();
        }
          break;
    }
  }

  @Then("Operator verify No Data empty description in Shipment Weight Dimension Table is shown")
  public void operatorVarifyNoDataEmptyDescriptionInShipmentWeightDimensionTableIsShown() {
    Assertions.assertThat(shipmentWeightDimensionPage.emptyDescription.isDisplayed()).as("No Data message is shown on Shipment Weight Dimension").isTrue();
  }

  @When("Operator search the {string} column with inputted data {string} on Shipment Weight Dimension Table")
  public void operatorSearchTheColumnWithInputtedDataOnShipmentWeightDimensionTable(String columnName, String inputtedData) {
    switch (columnName){
      case "SHIPMENT ID":
        shipmentWeightDimensionPage.shipmentIdSearchField.click();
        shipmentWeightDimensionPage.shipmentIdSearchField.sendKeys(inputtedData);
        break;
      case "SHIPMENT STATUS":
        shipmentWeightDimensionPage.shipmentStatusSearchField.click();
        shipmentWeightDimensionPage.shipmentStatusSearchField.sendKeys(inputtedData);
        break;
      case "END HUB":
        shipmentWeightDimensionPage.endHubSearchField.click();
        shipmentWeightDimensionPage.endHubSearchField.sendKeys(inputtedData);
        break;
      case "SHIPMENT CREATION DATE TIME":
        shipmentWeightDimensionPage.shipmentCreationDateTimeSearchField.click();
        shipmentWeightDimensionPage.shipmentCreationDateTimeSearchField.sendKeys(inputtedData);
        break;
      case "COMMENTS":
        shipmentWeightDimensionPage.commentsSearchField.click();
        shipmentWeightDimensionPage.commentsSearchField.sendKeys(inputtedData);
        break;
      case "START HUB":
        shipmentWeightDimensionPage.startHubSearchField.click();
        shipmentWeightDimensionPage.startHubSearchField.sendKeys(inputtedData);
        break;
      case "SHIPMENT TYPE":
        shipmentWeightDimensionPage.shipmentTypeSearchField.click();
        shipmentWeightDimensionPage.shipmentTypeSearchField.sendKeys(inputtedData);
        break;
      case "VENDOR":
        shipmentWeightDimensionPage.vendorSearchField.click();
        shipmentWeightDimensionPage.vendorSearchField.sendKeys(inputtedData);
        break;
      case "ORIGIN PORT":
        shipmentWeightDimensionPage.originPortSearchField.click();
        shipmentWeightDimensionPage.originPortSearchField.sendKeys(inputtedData);
        break;
      case "DESTINATION PORT":
        shipmentWeightDimensionPage.destinationPortSearchField.click();
        shipmentWeightDimensionPage.destinationPortSearchField.sendKeys(inputtedData);
        break;
    }
  }

  @Then("Operator verifies {string} error message is shown on Shipment Weight Dimension Filter UI")
  public void operatorVerifiesErrorMessageIsShownOnShipmentWeightDimensionFilterUI(String errorMessage) {
    shipmentWeightDimensionPage.duplicateNamePresetFilters.waitUntilVisible();
    Assertions.assertThat(shipmentWeightDimensionPage.duplicateNamePresetFilters.getText())
            .as("Verify duplicate name preset filter is shown").isEqualTo(errorMessage);
  }

  @Then("Operator verifies {string} popup is shown on Shipment Weight Dimension Filter UI")
  public void operatorVerifiesPopupIsShownOnShipmentWeightDimensionFilterUI(String popupMessage) {
    shipmentWeightDimensionPage.clearPresetFilterPopup.waitUntilVisible();
    Assertions.assertThat(shipmentWeightDimensionPage.clearPresetFilterPopup.getText())
            .as("Verify clear filters popup is shown").isEqualTo(popupMessage);
  }

  @Then("Operator verifies Shipment Weight Dimension page UI")
  public void operatorVerifiesShipmentWeightDimensionPageUI() {
    shipmentWeightDimensionPage.switchTo();
    shipmentWeightDimensionPage.waitUntilLoaded();
    shipmentWeightDimensionPage.verifyAddNewWeightDimensionNewUI();
  }

  @When("Operator clicks {string} button on Shipment Weight Dimension page")
  public void operatorClicksButtonOnShipmentWeightDimensionPage(String buttonName) {
    shipmentWeightDimensionPage.waitUntilLoaded();
    switch (buttonName) {
      case "Search by Billing Number":
        shipmentWeightDimensionPage.searchByBillinNumberButton.waitUntilVisible();
        shipmentWeightDimensionPage.searchByBillinNumberButton.click();
        break;
      case "New Record":
        shipmentWeightDimensionPage.newRecordBtn.waitUntilVisible();
        shipmentWeightDimensionPage.newRecordBtn.click();
        break;
      case "Load Selection":
        shipmentWeightDimensionPage.loadSelectionButton.waitUntilVisible();
        shipmentWeightDimensionPage.loadSelectionButton.click();
        break;
      case "Search Shipments":
        shipmentWeightDimensionPage.searchShipments.waitUntilVisible();
        shipmentWeightDimensionPage.searchShipments.click();
        break;
      case "Close Search by Billing Number":
        shipmentWeightDimensionPage.closeSearchBillingNumberPopup.waitUntilVisible();
        shipmentWeightDimensionPage.closeSearchBillingNumberPopup.click();
        break;
      case "Back to Main":
        shipmentWeightDimensionPage.backToMain.waitUntilVisible();
        shipmentWeightDimensionPage.backToMain.click();
        break;
    }
  }

  @Then("Operator verifies {string} popup is shown on Shipment Weight Dimension page")
  public void operatorVerifiesPopupIsShownOnShipmentWeightDimensionPage(String popupName) {
    shipmentWeightDimensionPage.headerSearchByBillingNumberPopup.waitUntilVisible(5);
    shipmentWeightDimensionPage.verifyShipmentWeightDimensionPagePopup(popupName);
  }

  @When("Operator input {string} billing number with value {string} on Shipment Weight Dimension page")
  public void operatorInputBillingNumberWithValueOnShipmentWeightDimensionPage(String billingNumberType, String billingNumberValue) {
    String newBillingNumberValue = resolveValue(billingNumberValue);
    switch (billingNumberType) {
      case "MAWB":
        shipmentWeightDimensionPage.mawbBillingNumberInput.click();

        if (newBillingNumberValue.equalsIgnoreCase("random")) {
          newBillingNumberValue = RandomStringUtils.randomNumeric(7) + "-" + RandomStringUtils.randomNumeric(6);
        }

        shipmentWeightDimensionPage.mawbBillingNumberInput.sendKeys(newBillingNumberValue);
        break;
      case "SWB":
        shipmentWeightDimensionPage.swbBillingNumberInput.click();

        if (newBillingNumberValue.equalsIgnoreCase("random-r11b")) {
          newBillingNumberValue = "R11B" + RandomStringUtils.randomNumeric(8);
        }

        shipmentWeightDimensionPage.swbBillingNumberInput.sendKeys(newBillingNumberValue);
        break;
    }
  }

  @Then("Operator verifies the popup is closed on Shipment Weight Dimension page")
  public void operatorVerifiesThePopupIsClosedOnShipmentWeightDimensionPage() {
    shipmentWeightDimensionPage.waitUntilLoaded();
    shipmentWeightDimensionPage.verifyAddNewWeightDimensionNewUI();
  }

  @Then("Operator verifies error message {string} is shown on Shipment Weight Dimension page")
  public void operatorVerifiesErrorMessageIsShownOnShipmentWeightDimensionPage(String errorMessage) {
    shipmentWeightDimensionPage.errorStatusCode404.waitUntilVisible();
    Assertions.assertThat(shipmentWeightDimensionPage.errorStatusCode404.getText())
            .as("Verify error message toast is shown").isEqualTo(errorMessage);
  }
}

