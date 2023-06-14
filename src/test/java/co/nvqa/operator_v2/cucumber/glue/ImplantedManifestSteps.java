package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.model.DataEntity;
import co.nvqa.commons.support.OrderHelper;
import co.nvqa.operator_v2.model.ImplantedManifestOrder;
import co.nvqa.operator_v2.selenium.page.ImplantedManifestPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.ZonedDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;

import static co.nvqa.operator_v2.selenium.page.ImplantedManifestPage.ImplantedManifestOrderTable.ACTION_REMOVE;
import static co.nvqa.operator_v2.selenium.page.ImplantedManifestPage.ImplantedManifestOrderTable.COLUMN_TRACKING_ID;

/**
 * @author Kateryna Skakunova
 */
@ScenarioScoped
public class ImplantedManifestSteps extends AbstractSteps {

  private ImplantedManifestPage page;

  public ImplantedManifestSteps() {
  }

  @Override
  public void init() {
    page = new ImplantedManifestPage(getWebDriver());
  }

  @When("^Operator selects Hub ([^\"]*) and clicks on \"Create Manifest\" button$")
  public void operatorSelectsHubAndClicksOnButton(String hubName) {
    page.inFrame(() -> {
      page.selectHub(hubName);
      page.clickCreateManifestButtonToInitiateCreation();
    });
  }

  @When("Operator clicks 'Download CSV File' on Implanted Manifest page")
  public void operatorClicksOnImplantedManifest() {
    page.inFrame(() -> page.downloadCsvFile.click());
  }

  @Then("Operator verifies CSV file for {value} hub is downloaded successfully on Implanted Manifest page:")
  public void operatorVerifiesTheFileIsDownloadedSuccessfully(String hubName,
      List<Map<String, String>> data) {
    page.inFrame(() ->
        resolveListOfMaps(data).forEach(order -> page.csvDownloadSuccessfullyAndContainsOrderInfo(
            order.get("trackingId"),
            order.get("address"),
            order.get("rackSector"),
            order.get("toName"),
            hubName))
    );
  }

  @Then("Operator verify scanned orders on Implanted Manifest page:")
  public void operatorVerifiesScannedOrders(List<Map<String, String>> data) {
    page.inFrame(() -> {
      page.waitUntil(() -> page.implantedManifestOrderTable.getRowsCount() >= data.size(), 20000);
      var actual = page.implantedManifestOrderTable.readAllEntities();
      resolveListOfMaps(data).forEach(row -> {
        var expected = new ImplantedManifestOrder(row);
        DataEntity.assertListContains(actual, expected, "Scanned order data");
      });
    });
  }


  @Then("Operator verifies orders are removed on Implanted Manifest page:")
  public void operatorVerifiesAllScannedOrdersIsRemovedFromTheManifestTable(
      List<String> trackingIds) {
    page.inFrame(() -> {
      var actual = page.implantedManifestOrderTable.readColumn(
          COLUMN_TRACKING_ID);
      Assertions.assertThat(actual)
          .as("List of scanned tracking ids")
          .doesNotContainAnyElementsOf(resolveValues(trackingIds));
    });
  }

  @Then("Operator removes scanned orders on Implanted Manifest page:")
  public void removeOrders(List<String> trackingIds) {
    page.inFrame(() -> {
      page.waitUntil(() -> page.implantedManifestOrderTable.getRowsCount() >= trackingIds.size(),
          20000);
      resolveValues(trackingIds).forEach(trackingId -> {
        int count = page.implantedManifestOrderTable.getRowsCount();
        for (int i = 1; i <= count; i++) {
          if (trackingId.equals(
              page.implantedManifestOrderTable.getColumnText(i, COLUMN_TRACKING_ID))) {
            page.implantedManifestOrderTable.clickActionButton(i, ACTION_REMOVE);
            return;
          }
        }
        Assertions.fail("Scanned order with Tracking ID [%s] wa not found", trackingId);
      });

    });
  }

  @When("Operator remove all scanned orders on Implanted Manifest page")
  public void operatorClicksButtonOnImplementedManifestPage() {
    page.inFrame(() -> {
      page.removeAll.click();
      page.confirmRemoveAll.click();
    });
  }

  @When("^Operator clicks \"Actions X\" button on Manifest table for all created orders on Implanted Manifest page$")
  public void operatorClicksButtonOnManifestTableForAllCreatedOrdersOnImplementedManifestPage() {
    List<Order> orders = getListOfCreatedOrders();
    int ordersSize = orders.size();

    for (int i = 0; i < ordersSize; i++) {
      page.clickActionXForRow(1);
    }
  }

  @When("Operator creates Manifest for Hub {value} and scan barcodes:")
  public void operatorSelectsCreateManifestForHubHubNameAndScanBarcodes(String hubName,
      List<String> trackingIds) {
    operatorSelectsHubOnImplantedManifestPage(hubName);
    operatorClicksCreateManifestOnImplantedManifestPage();

    Map<String, ZonedDateTime> barcodeToScannedAtTime = new HashMap<>();

    page.inFrame(() ->
        resolveValues(trackingIds).forEach(
            trackingId -> page.scanBarCodeAndSaveTime(barcodeToScannedAtTime, trackingId))
    );
  }

  @When("Operator removes order by scan on Implanted Manifest page:")
  public void removeByScan(List<String> trackingIds) {
    page.inFrame(() ->
        resolveValues(trackingIds).forEach(trackingId -> {
          page.removeOrderByScanInput.setValue(trackingId + Keys.ENTER);
          pause2s();
        })
    );
  }

  @When("Operator selects {value} hub on Implanted Manifest page")
  public void operatorSelectsHubOnImplantedManifestPage(String hubName) {
    page.inFrame(() -> page.hubSelect.selectValue(hubName));
  }

  @When("^Operator clicks Create Manifest on Implanted Manifest page$")
  public void operatorClicksCreateManifestOnImplantedManifestPage() {
    page.inFrame(() -> page.createManifest.click());
  }

  @When("Operator scans {value} barcode on Implanted Manifest page")
  public void operatorScansBarcodeOnImplantedManifestPage(String barcode) {
    page.inFrame(() -> {
      page.scanBarcodeInput.click();
      page.scanBarcodeInput.setValue(barcode + Keys.ENTER);
      page.waitUntilLoaded();
    });
  }

  @When("^Operator saves created orders Tracking IDs without prefix$")
  public void removeTrackingIdsPrefix() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    String prefix = OrderHelper.getCountryPrefix(TestConstants.NV_SYSTEM_ID);
    List<String> prefixlessTrackingIds = trackingIds.stream()
        .map(s -> s.replaceFirst(prefix, ""))
        .collect(Collectors.toList());
    put(KEY_LIST_OF_CREATED_ORDER_PREFIXLESS_TRACKING_ID, prefixlessTrackingIds);
  }

  @When("Operator creates manifest for {value} reservation on Implanted Manifest page")
  public void operatorCreatesManifestForReservationOnImplantedManifestPage(String reservationId) {
    page.inFrame(() -> {
      page.bigCreateManifest.click();
      page.createManifestDialog.waitUntilVisible();
      page.createManifestDialog.reservationId.setValue(reservationId);
      page.createManifestDialog.createManifestButton.click();
      pause5s();
    });
  }

  @When("^Operator adds country prefix on Implanted Manifest page$")
  public void operatorAddsPrefixOnImplantedManifestPage() {
    page.addPrefix.click();
    page.setPrefixDialog.waitUntilVisible();
    page.setPrefixDialog.prefix
        .setValue(OrderHelper.getCountryPrefix(TestConstants.NV_SYSTEM_ID));
    page.setPrefixDialog.save.click();
    page.setPrefixDialog.waitUntilInvisible();
  }

  @When("^Operator closes Create Manifest dialog on Implanted Manifest page$")
  public void operatorClosesCreateManifestDialogOnImplantedManifestPage() {
    page.createManifestDialog.close();
    page.createManifestDialog.waitUntilInvisible();
  }

  @When("^Operator verifies that \"(.+)\" success toast message is displayed$")
  @And("^Operator verifies that \"(.+)\" error toast message is displayed$")
  public void operatorVerifiesErrorToast(String message) {
    message = resolveValue(message);
    page.waitUntilInvisibilityOfToast(message);
  }
}
