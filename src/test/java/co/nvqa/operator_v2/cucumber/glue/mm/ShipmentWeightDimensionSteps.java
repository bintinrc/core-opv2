package co.nvqa.operator_v2.cucumber.glue.mm;

import co.nvqa.commons.model.core.hub.Shipment;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.model.ShipmentWeightDimensionAddInfo;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionAddPage;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionAddPage.ShipmentWeightAddState;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionPage;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionPage.ShipmentWeightState;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionTablePage;
import co.nvqa.operator_v2.selenium.page.mm.shipmentweight.ShipmentWeightDimensionTablePage.Column;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
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

  @Override
  public void init() {
    shipmentWeightDimensionPage = new ShipmentWeightDimensionPage(getWebDriver());
    shipmentWeightDimensionTablePage = new ShipmentWeightDimensionTablePage(getWebDriver());
    shipmentWeightDimensionAddPage = new ShipmentWeightDimensionAddPage(getWebDriver());
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

    // 1. Shipment ID
    shipmentWeightDimensionTablePage.clearFilters();
    shipmentWeightDimensionTablePage
        .filterColumn(Column.SHIPMENT_ID, shipmentData);
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment id with correct value").isEqualTo(1);

    shipmentWeightDimensionTablePage.filterColumn(Column.SHIPMENT_ID, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment id with invalid value").isEqualTo(0);

    // 2. Shipment Status
    shipmentWeightDimensionTablePage.clearFilters();
    shipmentWeightDimensionTablePage
        .filterColumn(Column.STATUS, shipmentData);
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment status with correct value").isEqualTo(1);

    shipmentWeightDimensionTablePage.filterColumn(Column.STATUS, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment status with invalid value").isEqualTo(0);

    // 3. End Hub
    shipmentWeightDimensionTablePage.clearFilters();
    shipmentWeightDimensionTablePage.filterColumn(Column.END_HUB, shipmentData);
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment end hub with correct value").isEqualTo(1);

    shipmentWeightDimensionTablePage.filterColumn(Column.END_HUB, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment end hub with invalid value").isEqualTo(0);

    // 4. Creation Date
    shipmentWeightDimensionTablePage.clearFilters();
    shipmentWeightDimensionTablePage.filterColumn(Column.CREATION_DATE,
        shipmentData
    );
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment creation date with correct value").isEqualTo(1);

    shipmentWeightDimensionTablePage.filterColumn(Column.CREATION_DATE, "wrong value");
    Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
        .as("Able to filter by using shipment creation date with invalid value").isEqualTo(0);

    // 5. MAWB
    if (shipmentData.getMawb() != null && !shipmentData.getMawb().isEmpty()) {
      shipmentWeightDimensionTablePage.clearFilters();
      shipmentWeightDimensionTablePage.filterColumn(Column.MAWB,
          shipmentData
      );
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment mawb with correct value").isEqualTo(1);

      shipmentWeightDimensionTablePage.filterColumn(Column.MAWB, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment mawb with invalid value").isEqualTo(0);
    }

    // 6. comments
    if (shipmentData.getComments() != null && !shipmentData.getComments().isEmpty()) {
      shipmentWeightDimensionTablePage.clearFilters();
      shipmentWeightDimensionTablePage.filterColumn(Column.COMMENTS, shipmentData);
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment comments with correct value").isEqualTo(1);

      shipmentWeightDimensionTablePage.filterColumn(Column.COMMENTS, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment comments with invalid value").isEqualTo(0);
    }

    // 7. start hub
    if (shipmentData.getOrigHubName() != null && !shipmentData.getOrigHubName().isEmpty()) {
      shipmentWeightDimensionTablePage.clearFilters();
      shipmentWeightDimensionTablePage
          .filterColumn(Column.START_HUB, shipmentData);
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment start hub with correct value").isEqualTo(1);

      shipmentWeightDimensionTablePage.filterColumn(Column.START_HUB, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment start hub with invalid value").isEqualTo(0);
    }

    // 7. shipment type
    if (shipmentData.getShipmentType() != null && !shipmentData.getShipmentType().isEmpty()) {
      shipmentWeightDimensionTablePage.clearFilters();
      shipmentWeightDimensionTablePage
          .filterColumn(Column.SHIPMENT_TYPE, shipmentData);
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment shipment type with correct value").isEqualTo(1);

      shipmentWeightDimensionTablePage.filterColumn(Column.SHIPMENT_TYPE, "wrong value");
      Assertions.assertThat(shipmentWeightDimensionTablePage.shipmentWeightNvTable.rows.size())
          .as("Able to filter by using shipment shipment type with invalid value").isEqualTo(0);
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

  private String createShipmentJson(String shipmentId) {
    return f("{ \"shipment_id\": \"%s\" , \"destination_hub_id\":\"1\"}", shipmentId);
  }

  @When("Operator filter Shipment Weight Dimension Table by {string} column with first shipment value")
  public void operatorFilterShipmentWeightDimensionTableByColumn(String column,  Map<String, String> dataTable) {
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
        .as("Able to filter by using %s with correct value", column).isEqualTo(Integer.parseInt(expectedNumOfRows));
    Assertions.assertThat(shipmentWeightDimensionTablePage.resultCounterText.getText())
        .as("Counter text should show 'Showing %s from 2 results", expectedNumOfRows)
        .isEqualTo("Showing %s from 2 results", expectedNumOfRows);
  }

  @And("Operator select all data on Shipment Weight Dimension Table")
  public void operatorSelectAllDataOnShipmentWeightDimensionTable() {
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
}

