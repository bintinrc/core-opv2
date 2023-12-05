package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.model.DataEntity;
import co.nvqa.common.model.address.Address;
import co.nvqa.common.ordercreate.cucumber.glue.KeyStorage;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.common.utils.StandardTestUtils;
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
import org.assertj.core.api.Assertions;

import static co.nvqa.operator_v2.selenium.page.UpdateDeliveryAddressWithCsvPage.AddressesTable.COLUMN_TRACKING_ID;
import static co.nvqa.operator_v2.selenium.page.UpdateDeliveryAddressWithCsvPage.AddressesTable.COLUMN_VALIDATION;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class UpdateDeliveryAddressWithCsvSteps extends AbstractSteps {

  private static final String KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES = "KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES";
  private UpdateDeliveryAddressWithCsvPage page;

  @Override
  public void init() {
    page = new UpdateDeliveryAddressWithCsvPage(getWebDriver());
  }

  @When("Operator update delivery addresses of given orders on Update Delivery Address with CSV page:")
  public void operatorUpdateDeliveryAddresses(List<String> trackingIds) {
    List<Map<String, String>> data = CollectionUtils.isEmpty(trackingIds) ?
        new ArrayList<>() :
        trackingIds.stream().map(val -> ImmutableMap.of("trackingId", val))
            .collect(Collectors.toList());
    operatorUpdateDeliveryAddresses2(data);
  }

  @When("Operator update delivery addresses of with empty CSV file:")
  public void operatorUpdateDeliveryAddressesEmptyCsv() {
    List<String> emptyTids = new ArrayList<>();
    operatorUpdateDeliveryAddresses(emptyTids);
  }

  @When("Operator update delivery addresses on Update Delivery Address with CSV page:")
  public void operatorUpdateDeliveryAddresses2(List<Map<String, String>> data) {
    List<UpdateDeliveryAddressRecord> records = data.stream()
        .map(map -> {
          Address address = StandardTestUtils.generateAddress("RANDOM");
          address.setName("TEST CUSTOMER");
          UpdateDeliveryAddressRecord record = new UpdateDeliveryAddressRecord(address);
          map = resolveKeyValues(map);
          map.values().removeIf(StringUtils::isBlank);
          record.fromMap(map);
          return record;
        })
        .collect(Collectors.toList());
    File file = createUpdateDeliveryAddressCsvFile(records);
    page.inFrame(() -> {
      page.updateAddressWithCsvButton.click();
      page.updateAddressWithCsvDialog.waitUntilVisible();
      page.updateAddressWithCsvDialog.selectFile.setValue(file);
      page.updateAddressWithCsvDialog.uploadButton.click();
    });
    put(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES, records);
  }

  @When("Operator verify updated addresses on Update Delivery Address with CSV page")
  public void operatorVerifyUpdatedAddresses() {
    List<UpdateDeliveryAddressRecord> expected = get(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES);

    page.inFrame(() -> {
      int tableSize = page.addressesTable.getRowsCount();
      Assertions.assertThat(tableSize).as("Number of updated addresses").isEqualTo(expected.size());
      List<UpdateDeliveryAddressRecord> actual = page.addressesTable
          .readAllEntities();

      expected.forEach(expectedRecord -> {
        DataEntity.assertListContains(actual, expectedRecord,
            "Changed address " + expectedRecord.getTrackingId());
      });
    });

  }

  @When("Operator verify validation statuses on Update Delivery Address with CSV page:")
  public void operatorVerifyValidationStatuses(List<Map<String, String>> dataList) {
    Map<String, String> data = dataList.stream().collect(Collectors.toMap(
        map -> resolveValue(map.get("trackingId")),
        map -> resolveValue(map.get("status"))
    ));
    page.inFrame(() -> {
      int tableSize = page.addressesTable.getRowsCount();
      Assertions.assertThat(tableSize).as("Number of updated addresses").isEqualTo(data.size());

      for (int i = 1; i <= tableSize; i++) {
        String trackingId = page.addressesTable
            .getColumnText(i, COLUMN_TRACKING_ID);
        Assertions.assertThat(data).containsKey(trackingId);
        String actualStatus = page.addressesTable
            .getColumnText(i, COLUMN_VALIDATION);
        String status = data.get(trackingId);
        Assertions.assertThat(actualStatus).as("Validation status for Tracking ID " + trackingId)
            .isEqualToIgnoringCase(status);
      }
    });
  }

  @When("Operator confirm addresses update on Update Delivery Address with CSV page")
  public void operatorConfirmAddressesUpdate() {
    page.inFrame(() -> {
      page.confirmUpdatesButton.click();
      page.confirmUpdatesDialog.waitUntilVisible();
      page.confirmUpdatesDialog.proceedButton.click();
      page.confirmUpdatesDialog.proceedButton.waitUntilInvisible();
    });
  }

  @When("Operator verify addresses were updated successfully on Update Delivery Address with CSV page")
  public void operatorVerifyAddressesUpdatedSuccessfully() {
    List<UpdateDeliveryAddressRecord> addresses = get(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES);
    page.inFrame(() -> {
      doWithRetry(
          () -> Assertions.assertThat(page.tableDescription.getText())
              .as("Number of updated addresses")
              .isEqualTo(f("All %d records updated", addresses.size())),
          "Assert Addresses table description after addresses update");
    });
  }

  @And("Operator verify created orders info after address update")
  public void apiOperatorVerifyOrdersInfoAfterAddressUpdate() {
    List<String> trackingIds = get(KeyStorage.KEY_LIST_OF_CREATED_TRACKING_IDS);
    apiOperatorVerifyOrdersInfoAfterAddressUpdate(trackingIds);
  }

  @And("Operator verify orders info after address update:")
  public void apiOperatorVerifyOrdersInfoAfterAddressUpdate(List<String> values) {
    List<String> trackingIds = resolveValues(values);
    List<Order> orders = getList(CoreScenarioStorageKeys.KEY_LIST_OF_CREATED_ORDERS, Order.class);
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

      UpdateDeliveryAddressRecord actual = new UpdateDeliveryAddressRecord(getToAddress(order));
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
          String.format("update-delivery-address-request_%s.csv",
              StandardTestUtils.generateDateUniqueString()));

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
    page.inFrame(() -> {
      page.confirmUpdatesDialog.close.click();
      page.confirmUpdatesDialog.waitUntilInvisible();
    });
  }
}
