package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.UpdateDeliveryAddressRecord;
import co.nvqa.operator_v2.selenium.page.UpdateDeliveryAddressWithCsvPage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;

import static co.nvqa.operator_v2.selenium.page.UpdateDeliveryAddressWithCsvPage.AddressesTable.COLUMN_TRACKING_ID;
import static co.nvqa.operator_v2.selenium.page.UpdateDeliveryAddressWithCsvPage.AddressesTable.COLUMN_VALIDATION;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class UpdateDeliveryAddressWithCsvSteps extends AbstractSteps {

  private UpdateDeliveryAddressWithCsvPage updateDeliveryAddressWithCsvPage;

  @Override
  public void init() {
    updateDeliveryAddressWithCsvPage = new UpdateDeliveryAddressWithCsvPage(getWebDriver());
  }

  @When("^Operator update delivery address of created orders on Update Delivery Address with CSV page$")
  public void operatorUpdateDeliveryAddresses() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    operatorUpdateDeliveryAddresses(trackingIds);
  }

  @When("^Operator update delivery addresses of given orders on Update Delivery Address with CSV page:$")
  public void operatorUpdateDeliveryAddresses(List<String> trackingIds) {
    List<Map<String, String>> data = CollectionUtils.isEmpty(trackingIds) ?
        new ArrayList<>() :
        trackingIds.stream().map(val -> ImmutableMap.of("trackingId", val))
            .collect(Collectors.toList());
    operatorUpdateDeliveryAddresses2(data);
  }

  @When("^Operator update delivery addresses on Update Delivery Address with CSV page:$")
  public void operatorUpdateDeliveryAddresses2(List<Map<String, String>> data) {
    List<UpdateDeliveryAddressRecord> records = data.stream()
        .map(map -> {
          Address address = generateAddress("RANDOM");
          address.setName("TEST CUSTOMER");
          UpdateDeliveryAddressRecord record = new UpdateDeliveryAddressRecord(address);
          map = resolveKeyValues(map);
          map.values().removeIf(StringUtils::isBlank);
          record.fromMap(map);
          return record;
        })
        .collect(Collectors.toList());
    File file = createUpdateDeliveryAddressCsvFile(records);
    updateDeliveryAddressWithCsvPage.updateAddressWithCsvButton.click();
    updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.waitUntilVisible();
    updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.selectFile.setValue(file);
    updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.uploadButton
        .clickAndWaitUntilDone();
    updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.waitUntilInvisible();

    put(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES, records);
  }

  @When("^Operator verify updated addresses on Update Delivery Address with CSV page$")
  public void operatorVerifyUpdatedAddresses() {
    List<UpdateDeliveryAddressRecord> expected = get(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES);

    int tableSize = updateDeliveryAddressWithCsvPage.addressesTable.getRowsCount();
    assertEquals("Number of updated addresses", expected.size(), tableSize);

    List<UpdateDeliveryAddressRecord> actual = updateDeliveryAddressWithCsvPage.addressesTable
        .readAllEntities();

    expected.forEach(expectedRecord -> {
      UpdateDeliveryAddressRecord actualRecord = actual.stream()
          .filter(atc -> StringUtils.equals(atc.getTrackingId(), expectedRecord.getTrackingId()))
          .findFirst()
          .orElseThrow(() -> new AssertionError(
              "Record with Tracking ID " + expectedRecord.getTrackingId() + " was not found"));
      expectedRecord.compareWithActual(actualRecord);
    });
  }

  @When("^Operator verify validation statuses on Update Delivery Address with CSV page:$")
  public void operatorVerifyValidationStatuses(List<Map<String, String>> dataList) {
    Map<String, String> data = dataList.stream().collect(Collectors.toMap(
        map -> resolveValue(map.get("trackingId")),
        map -> resolveValue(map.get("status"))
    ));
    int tableSize = updateDeliveryAddressWithCsvPage.addressesTable.getRowsCount();
    assertEquals("Number of updated addresses", data.size(), tableSize);

    for (int i = 1; i <= tableSize; i++) {
      String trackingId = updateDeliveryAddressWithCsvPage.addressesTable
          .getColumnText(i, COLUMN_TRACKING_ID);
      assertTrue("Unexpected Tracking ID " + trackingId, data.containsKey(trackingId));
      String actualStatus = updateDeliveryAddressWithCsvPage.addressesTable
          .getColumnText(i, COLUMN_VALIDATION);
      String status = data.get(trackingId);
      assertThat("Validation status for Tracking ID " + trackingId, actualStatus,
          Matchers.equalToIgnoringCase(status));
    }
  }

  @When("^Operator confirm addresses update on Update Delivery Address with CSV page$")
  public void operatorConfirmAddressesUpdate() {
    updateDeliveryAddressWithCsvPage.confirmUpdatesButton.click();
    updateDeliveryAddressWithCsvPage.confirmUpdatesDialog.waitUntilVisible();
    updateDeliveryAddressWithCsvPage.confirmUpdatesDialog.proceedButton.click();
    updateDeliveryAddressWithCsvPage.confirmUpdatesDialog.proceedButton.waitUntilInvisible();
  }

  @When("^Operator verify addresses were updated successfully on Update Delivery Address with CSV page$")
  public void operatorVerifyAddressesUpdatedSuccessfully() {
    List<UpdateDeliveryAddressRecord> addresses = get(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES);
    retryIfAssertionErrorOccurred(
        () -> assertEquals("Number of updated addresses",
            f("All %d records updated", addresses.size()),
            updateDeliveryAddressWithCsvPage.tableDescription.getText()),
        "Assert Addresses table description after addresses update");
  }

  @And("^Operator verify created orders info after address update$")
  public void apiOperatorVerifyOrdersInfoAfterAddressUpdate() {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    apiOperatorVerifyOrdersInfoAfterAddressUpdate(trackingIds);
  }

  @And("^Operator verify orders info after address update:$")
  public void apiOperatorVerifyOrdersInfoAfterAddressUpdate(List<String> values) {
    List<String> trackingIds = resolveValues(values);
    List<Order> orders = get(KEY_LIST_OF_ORDER_DETAILS);
    List<UpdateDeliveryAddressRecord> expected = get(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES);
    expected = expected.stream().filter(exp -> trackingIds.contains(exp.getTrackingId()))
        .collect(Collectors.toList());
    expected.forEach(record ->
    {
      Order order = orders.stream()
          .filter(o -> StringUtils.equals(o.getTrackingId(), record.getTrackingId()))
          .findFirst()
          .orElseThrow(() -> new AssertionError(
              f("Could not find order with Tracking ID [%s]", record.getTrackingId())));

      UpdateDeliveryAddressRecord actual = new UpdateDeliveryAddressRecord(order.getToAddress());
      record.compareWithActual(actual, "trackingId");
    });
  }

  private File createUpdateDeliveryAddressCsvFile(List<UpdateDeliveryAddressRecord> data) {
    StringBuilder addressSb = new StringBuilder();
    data.forEach(record ->
        addressSb
            .append(record.toCsvLine())
            .append(System.lineSeparator())
    );
    try {
      File file = TestUtils.createFileOnTempFolder(
          String.format("update-delivery-address-request_%s.csv", generateDateUniqueString()));

      PrintWriter pw = new PrintWriter(new FileOutputStream(file));
      pw.write("Fill in '-' for non-optional fields that are blank");
      pw.write(System.lineSeparator());
      pw.write(
          "tracking_id,to.name,to.email,to.phone_number,to.address.address1,to.address.address2,to.address.postcode,to.address.city,to.address.country,to.address.state,to.address.district,to.address.latitude,to.address.longitude");
      pw.write(System.lineSeparator());
      pw.write(addressSb.toString());
      pw.close();

      return file;
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }
  }

  @Then("Operator closes the modal for unsuccessful update")
  public void operatorVerifiesTheModalForUnsuccessfulUpdateAndClosesIt() {
    updateDeliveryAddressWithCsvPage.confirmUpdatesDialog.closeButton.click();
    updateDeliveryAddressWithCsvPage.confirmUpdatesDialog.waitUntilInvisible();
  }
}
