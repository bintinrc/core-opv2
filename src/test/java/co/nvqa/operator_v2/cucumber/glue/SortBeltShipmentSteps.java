package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.support.RandomUtil;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.selenium.page.SortBeltShipmentPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class SortBeltShipmentSteps extends AbstractSteps {

  private static final String KEY_SHIPMENT_COMMENT = "KEY_SHIPMENT_COMMENT";
  private static final String KEY_NUMBER_OF_SHIPMENT = "KEY_NUMBER_OF_SHIPMENT";

  private final String randomName =
      "QA-" + StandardTestConstants.COUNTRY_CODE.toUpperCase() + RandomUtil.randomString(7);

  private SortBeltShipmentPage sortBeltShipmentPage;

  public SortBeltShipmentSteps() {
  }

  @Override
  public void init() {
    sortBeltShipmentPage = new SortBeltShipmentPage(getWebDriver());
  }

  @And("Operator switches to iframe")
  public void operatorSwitchesToIframe() {
    sortBeltShipmentPage.switchTo();
  }

  @When("Operator selects {string} {string} on Sort Belt Shipment Page")
  public void operatorSelectsOnSortBeltShipmentPage(String value, String key) {
    final String HUB = "hub";
    final String DEVICE = "device";

    retryIfAssertionErrorOccurred(() -> {
          if (HUB.equalsIgnoreCase(key)) {
            sortBeltShipmentPage.selectHubComboBox.click();
          } else if (DEVICE.equalsIgnoreCase(key)) {
            sortBeltShipmentPage.selectDeviceIdComboBox.click();
          }
          assertTrue(sortBeltShipmentPage.activeDropDownInput.isDisplayed());
        }, "Clicking Dropdown"
    );

    pause1s();
    sortBeltShipmentPage.activeDropDownInput.sendKeys(value);
    sortBeltShipmentPage.selectOption(value);

    if (DEVICE.equalsIgnoreCase(key)) {
      verifiesTableStatsExist();
    }
  }

  @And("Operator clicks on Create Shipment Button")
  public void operatorClicksOnCreateShipmentButton() {
    sortBeltShipmentPage.createShipmentButton.click();
    retryIfAssertionErrorOccurred(() ->
            assertTrue("Dialog is not Showing", sortBeltShipmentPage.dialog.isDisplayed()),
        "Waiting for Dialog to Show...");
  }

  @And("Operator fills all the data correctly in Create Shipments Dialog on Sort Belt Shipment")
  public void operatorFillsAllTheDataCorrectlyInCreateShipmentsDialogOnSortBeltShipment(
      Map<String, String> mapOfData) {
    Map<String, String> map = resolveKeyValues(mapOfData);
    String comment = f("Created by %s sort belt", randomName);
    int numberOfArms = Integer.parseInt(map.get("numberOfArms"));
    String numberOfShipments = map.get("numberOfShipments");

    // Select Arm
    sortBeltShipmentPage.armOutputDropdown.click();
    for (int i = 1; i <= numberOfArms; i++) {
      sortBeltShipmentPage.selectOption(String.valueOf(i));
    }
    sortBeltShipmentPage.dialog.click();

    // Number of Shipment
    sortBeltShipmentPage.shipmentOutput.sendKeys(numberOfShipments);

    // Comment
    sortBeltShipmentPage.comment.sendKeys(comment);

    sortBeltShipmentPage.createShipment.click();

    int numberOfShipment = numberOfArms * Integer.parseInt(numberOfShipments);

    put(KEY_SHIPMENT_COMMENT, comment);
    put(KEY_NUMBER_OF_SHIPMENT, numberOfShipment);
  }

  @And("Operator fills invalid data exceeding limit of shipment number  on Sort Belt Shipment Page")
  public void operatorFillsInvalidDataExceedingLimitOfShipmentNumberOnSortBeltShipmentPage(
      Map<String, String> mapOfData) {
    Map<String, String> map = resolveKeyValues(mapOfData);
    String comment = f("Created by %s sort belt", randomName);
    int numberOfArms = Integer.parseInt(map.get("numberOfArms"));
    String numberOfShipments = map.get("numberOfShipments");
    int n = 2;

    // Select Arm
    sortBeltShipmentPage.armOutputDropdown.click();
    for (int i = 1; i <= numberOfArms; i++) {
      sortBeltShipmentPage.selectOption(String.valueOf(i));
    }
    sortBeltShipmentPage.dialog.click();

    // Number of Shipment
    sortBeltShipmentPage.shipmentOutput.sendKeys(numberOfShipments);
    String changedShipmentNumber = sortBeltShipmentPage.shipmentOutput.getText();
    assertTrue("Shipment Number is Changed to 30", "30".equalsIgnoreCase(changedShipmentNumber));
    sortBeltShipmentPage.shipmentOutput.sendKeys(String.valueOf(n));

    // Comment
    sortBeltShipmentPage.comment.sendKeys(comment);

    sortBeltShipmentPage.createShipment.click();

    int numberOfShipment = numberOfArms * n;

    put(KEY_SHIPMENT_COMMENT, comment);
    put(KEY_NUMBER_OF_SHIPMENT, numberOfShipment);
  }

  @Then("Operator verifies that the shipment is created on Sort Belt Shipment Page")
  public void operatorVerifiesThatTheShipmentIsCreatedOnSortBeltShipmentPage() {
    sortBeltShipmentPage
        .waitUntilVisibilityOfToastReact("Shipment created. Shipment label printing in progress");
    List<Long> shipmentIds = sortBeltShipmentPage.getCreatedShipmentIds();

    int numberOfShipment = get(KEY_NUMBER_OF_SHIPMENT);
    assertEquals("Number of Shipments", numberOfShipment, shipmentIds.size());

    put(KEY_LIST_OF_CREATED_SHIPMENT_ID, shipmentIds);
  }

  @Then("Operator verifies that the details of created shipments are correct")
  public void operatorVerifiesThatTheDetailsOfCreatedShipmentsAreCorrect() {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    for (Long shipmentId : shipmentIds) {
      sortBeltShipmentPage.validateShipmentDetails(shipmentId);
    }
  }

  @And("Operator left mandatory field empty in Shipment Creation Dialog on Sort Belt Shipment")
  public void operatorLeftMandatoryFieldEmptyInShipmentCreationDialogOnSortBeltShipment() {
    String comment = f("Created by %s sort belt", randomName);
    sortBeltShipmentPage.comment.sendKeys(comment);
    sortBeltShipmentPage.createShipment.click();
  }

  @Then("Operator verifies there will be empty field error notification shown")
  public void operatorVerifiesThereWillBeErrorNotificationShown() { }

  @When("Operator clicks on back button on Sort Belt Shipment Page")
  public void operatorClicksOnBackButtonOnSortBeltShipmentPage() {
    sortBeltShipmentPage.backButton.click();
  }

  @Then("Operator will be redirected to the table stats page")
  public void operatorWillBeRedirectedToTheTableStatsPage() {
    verifiesTableStatsExist();
  }

  @When("Operator selects sort belt shipment and clicks on view shipments")
  public void operatorSelectsSortBeltShipmentAndClicksOnViewShipments() {
    String comment = get(KEY_SHIPMENT_COMMENT);
    sortBeltShipmentPage.commentTextBox.sendKeys(comment);
    sortBeltShipmentPage.verifiesHighlightedFilterIsShown(comment);
    sortBeltShipmentPage.viewShipmentButton.click();
  }

  @Then("Operator verifies the shipments details are right")
  public void operatorVerifiesTheShipmentsDetailsAreRight() {
    List<Long> expectedShipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    List<Long> actualShipmentIds = sortBeltShipmentPage.getCreatedShipmentIds();

    Collections.sort(expectedShipmentIds);
    Collections.sort(actualShipmentIds);

    assertTrue("Shipments are the same", expectedShipmentIds.equals(actualShipmentIds));
  }

  private void verifiesTableStatsExist() {
    retryIfAssertionErrorOccurred(() ->
            assertTrue("Table Stat Is Not Showing", sortBeltShipmentPage.tableStats.isDisplayed()),
        "Waiting for Table Stat to Show...");
  }
}
