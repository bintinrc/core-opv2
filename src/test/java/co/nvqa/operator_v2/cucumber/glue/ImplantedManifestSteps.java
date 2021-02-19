package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.ImplantedManifestPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.time.ZonedDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.openqa.selenium.Keys;

/**
 * @author Kateryna Skakunova
 */
@ScenarioScoped
public class ImplantedManifestSteps extends AbstractSteps {

  private ImplantedManifestPage implantedManifestPage;

  public ImplantedManifestSteps() {
  }

  @Override
  public void init() {
    implantedManifestPage = new ImplantedManifestPage(getWebDriver());
  }

  @When("^Operator selects Hub ([^\"]*) and clicks on \"Create Manifest\" button$")
  public void operatorSelectsHubAndClicksOnButton(String hubName) {
    put(KEY_IMPLANTED_MANIFEST_HUB_NAME, hubName);
    implantedManifestPage.selectHub(hubName);
    implantedManifestPage.clickCreateManifestButtonToInitiateCreation();
  }

  @When("^Operator do \"Scan Barcode\" for all created orders on Implanted Manifest page$")
  public void operatorDoScanBarCodeForAllCreatedOrdersOnImplementedManifestPage() {
    List<Order> orders = getListOfCreatedOrders();
    Map<String, ZonedDateTime> barcodeToScannedAtTime = new HashMap<>();

    for (Order order : orders) {
      String trackingId = order.getTrackingId();
      implantedManifestPage.scanBarCodeAndSaveTime(barcodeToScannedAtTime, trackingId);
    }

    put(KEY_IMPLANTED_MANIFEST_ORDER_SCANNED_AT, barcodeToScannedAtTime);
  }

  @When("^Operator clicks \"Download CSV File\" on Implanted Manifest$")
  public void operatorClicksOnImplantedManifest() {
    implantedManifestPage.clickDownloadCsvFile();
  }

  @Then("^Operator verifies the file is downloaded successfully and contains all scanned orders with correct info$")
  public void operatorVerifiesTheFileIsDownloadedSuccessfully() {
    List<Order> orders = getListOfCreatedOrders();
    String hubName = get(KEY_IMPLANTED_MANIFEST_HUB_NAME);

    for (Order order : orders) {
      implantedManifestPage.csvDownloadSuccessfullyAndContainsOrderInfo(order, hubName);
    }
  }

  @Then("^Operator verifies all scanned orders is listed on Manifest table and the info is correct$")
  public void operatorVerifiesAllScannedOrdersIsListedOnManifestTableAndTheInfoIsCorrect() {
    List<Order> orders = getListOfCreatedOrders();
    implantedManifestPage.scrollToBottom();

    for (Order order : orders) {
      implantedManifestPage
          .verifyInfoInManifestTableForOrder(order, get(KEY_IMPLANTED_MANIFEST_ORDER_SCANNED_AT));
    }

    implantedManifestPage.verifyRowsCountEqualsOrdersCountInManifestTable(orders.size());
  }

  @When("^Operator do \"Remove order by Scan\" for all created orders on Implanted Manifest page$")
  public void operatorDoForAllCreatedOrdersOnImplementedManifestPage() {
    List<Order> orders = getListOfCreatedOrders();

    for (Order order : orders) {
      String trackingId = order.getTrackingId();
      implantedManifestPage.removeOrderByScan(trackingId);
    }
  }

  @Then("^Operator verifies all scanned orders is removed from the Manifest table$")
  public void operatorVerifiesAllScannedOrdersIsRemovedFromTheManifestTable() {
    implantedManifestPage.verifyManifestTableIsEmpty();
  }

  @When("^Operator clicks \"Remove All\" button on Implanted Manifest page$")
  public void operatorClicksButtonOnImplementedManifestPage() {
    implantedManifestPage.clickRemoveAllButtonAndConfirm();
  }

  @When("^Operator clicks \"Actions X\" button on Manifest table for all created orders on Implanted Manifest page$")
  public void operatorClicksButtonOnManifestTableForAllCreatedOrdersOnImplementedManifestPage() {
    List<Order> orders = getListOfCreatedOrders();
    int ordersSize = orders.size();

    for (int i = 0; i < ordersSize; i++) {
      implantedManifestPage.clickActionXForRow(1);
    }
  }

  @When("^Operator creates Manifest for Hub ([^\"]*) and scan barcodes$")
  public void operatorSelectsCreateManifestForHubHubNameAndScanBarcodes(String hubName) {
    operatorSelectsHubOnImplantedManifestPage(hubName);
    operatorClicksCreateManifestOnImplantedManifestPage();

    List<Order> orders = getListOfCreatedOrders();
    Map<String, ZonedDateTime> barcodeToScannedAtTime = new HashMap<>();

    for (Order order : orders) {
      String trackingId = order.getTrackingId();
      implantedManifestPage.scanBarCodeAndSaveTime(barcodeToScannedAtTime, trackingId);
    }

    put(KEY_IMPLANTED_MANIFEST_ORDER_SCANNED_AT, barcodeToScannedAtTime);
  }

  @When("^Operator selects \"([^\"]*)\" hub on Implanted Manifest page$")
  public void operatorSelectsHubOnImplantedManifestPage(String hubName) {
    hubName = resolveValue(hubName);
    put(KEY_IMPLANTED_MANIFEST_HUB_NAME, hubName);
    implantedManifestPage.hubSelect.searchAndSelectValue(hubName);
  }

  @When("^Operator clicks Create Manifest on Implanted Manifest page$")
  public void operatorClicksCreateManifestOnImplantedManifestPage() {
    implantedManifestPage.createManifest.clickAndWaitUntilDone();
  }

  @When("^Operator scans \"(.+)\" barcode on Implanted Manifest page$")
  public void operatorScansBarcodeOnImplantedManifestPage(String barcode) {
    barcode = resolveValue(barcode);
    implantedManifestPage.scanBarcodeInput.click();
    implantedManifestPage.scanBarcodeInput.setValue(barcode + Keys.ENTER);
    pause1s();
  }

  @When("^Operator creates manifest for \"(.+)\" reservation on Implanted Manifest page$")
  public void operatorCreatesManifestForReservationOnImplantedManifestPage(String reservationId) {
    reservationId = resolveValue(reservationId);
    implantedManifestPage.createManifest.click();
    implantedManifestPage.createManifestDialog.waitUntilVisible();
    implantedManifestPage.createManifestDialog.reservationId.setValue(reservationId);
    implantedManifestPage.createManifestDialog.createManifestButton.click();
    pause1s();
  }

  @When("^Operator closes Create Manifest dialog on Implanted Manifest page$")
  public void operatorClosesCreateManifestDialogOnImplantedManifestPage() {
    implantedManifestPage.createManifestDialog.close();
    implantedManifestPage.createManifestDialog.waitUntilInvisible();
  }

  @When("Operator verifies that \"(.+)\" success toast message is displayed")
  @And("Operator verifies that \"(.+)\" error toast message is displayed")
  public void operatorVerifiesErrorToast(String message) {
    message = resolveValue(message);
    implantedManifestPage.waitUntilInvisibilityOfToast(message);
  }
}
