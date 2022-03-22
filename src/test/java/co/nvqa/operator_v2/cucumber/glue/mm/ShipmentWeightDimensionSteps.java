package co.nvqa.operator_v2.cucumber.glue.mm;

import co.nvqa.commons.model.core.hub.Shipment;
import co.nvqa.commons.model.core.hub.ShipmentDimensionResponse;
import co.nvqa.commons.model.core.hub.ShipmentDimensions;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.model.ShipmentWeightDimensionAddInfo;
import co.nvqa.operator_v2.selenium.page.mm.ShipmentWeightDimensionAddPage;
import co.nvqa.operator_v2.selenium.page.mm.ShipmentWeightDimensionAddPage.ShipmentWeightAddState;
import co.nvqa.operator_v2.selenium.page.mm.ShipmentWeightDimensionPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.text.StringSubstitutor;
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

  @Override
  public void init() {
    shipmentWeightDimensionPage = new ShipmentWeightDimensionPage(getWebDriver());
  }

  @Then("Operator verify Shipment Weight Dimension page UI")
  public void operatorVerifyShipmentWeightDimensionPageUI() {
    shipmentWeightDimensionPage.switchTo();
    shipmentWeightDimensionPage.waitUntilLoaded();
    shipmentWeightDimensionPage.verifyUI();
  }

  @When("Operator click on Shipment Weight Dimension New Record button")
  public void operatorClickOnShipmentWeightDimensionNewRecordButton() {
    shipmentWeightDimensionAddPage = shipmentWeightDimensionPage.openNewRecord();
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
        Shipment shipmentData = ((Shipments) getScenarioStorage().get(KEY_CREATED_SHIPMENT)).getShipment();
        String shipmentStatus = (String) Optional.ofNullable(dataTable.get(STATUS_KEY)).orElse(shipmentData.getStatus());
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
      shipmentIdToSend  = RandomStringUtils.randomNumeric(15);
    } else if (shipmentId.equalsIgnoreCase("JSON")){
      shipmentIdToSend = f("{ \"shipment_id\": \"%s\" , \"destination_hub_id\":\"1\"}", getString("KEY_CREATED_SHIPMENT_ID"));
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
  public void operatorEnterDimensionValuesOnShipmentWeightDimensionWeightInput(Map<String, Double> dataTable) {
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
  public void operatorVerifyShipmentWeightDimensionAddDimensionUI(Map<String,String> dataTable) {
    shipmentWeightDimensionAddPage.verifyDimensionFieldError(dataTable.get("field"), dataTable.get("errorMessage"));
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
}
