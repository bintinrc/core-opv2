package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.UpdateDeliveryAddressWithCsvPage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import cucumber.api.java.en.And;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.junit.jupiter.api.Assertions;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.UpdateDeliveryAddressWithCsvPage.AddressesTable.COLUMN_TRACKING_ID;
import static co.nvqa.operator_v2.selenium.page.UpdateDeliveryAddressWithCsvPage.AddressesTable.COLUMN_VALIDATION;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class UpdateDeliveryAddressWithCsvSteps extends AbstractSteps
{
    private UpdateDeliveryAddressWithCsvPage updateDeliveryAddressWithCsvPage;

    @Override
    public void init()
    {
        updateDeliveryAddressWithCsvPage = new UpdateDeliveryAddressWithCsvPage(getWebDriver());
    }

    @When("^Operator update delivery address of created orders on Update Delivery Address with CSV page$")
    public void operatorUpdateDeliveryAddresses()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        operatorUpdateDeliveryAddresses(trackingIds);
    }

    @When("^Operator update delivery addresses of given orders on Update Delivery Address with CSV page:$")
    public void operatorUpdateDeliveryAddresses(List<String> trackingIds)
    {
        Map<String, Address> addresses = trackingIds == null ?
                new HashMap<>() :
                trackingIds.stream().collect(Collectors.toMap(
                        this::resolveValue,
                        trackingId -> generateAddress("RANDOM")
                ));

        File file = createUpdateDeliveryAddressCsvFile(addresses);
        updateDeliveryAddressWithCsvPage.updateAddressWithCsvButton.click();
        updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.waitUntilVisible();
        updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.selectFile.setValue(file);
        updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.uploadButton.clickAndWaitUntilDone();
        updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.waitUntilInvisible();

        put(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES, addresses);
    }

    @When("^Operator update delivery addresses of given order with empty value on Update Delivery Address with CSV page:$")
    public void operatorUpdateDeliveryAddressesWithEmptyValue(String trackingId)
    {
        trackingId = resolveValue(trackingId);
        File file = createEmptyUpdateDeliveryAddressCsvFile(trackingId);
        updateDeliveryAddressWithCsvPage.updateAddressWithCsvButton.click();
        updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.waitUntilVisible();
        updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.selectFile.setValue(file);
        updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.uploadButton.clickAndWaitUntilDone();
        updateDeliveryAddressWithCsvPage.updateAddressWithCsvDialog.waitUntilInvisible();

        put(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES, ImmutableMap.of(trackingId, new Address()));
    }

    @When("^Operator verify updated addresses on Update Delivery Address with CSV page$")
    public void operatorVerifyUpdatedAddresses() throws InstantiationException, IllegalAccessException
    {
        Map<String, Address> addresses = get(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES);

        int tableSize = updateDeliveryAddressWithCsvPage.addressesTable.getRowsCount();
        Assertions.assertEquals(addresses.size(), tableSize, "Number of updated addresses");

        for (int i = 1; i <= tableSize; i++)
        {
            String trackingId = updateDeliveryAddressWithCsvPage.addressesTable.getColumnText(i, COLUMN_TRACKING_ID);
            Assertions.assertTrue(addresses.containsKey(trackingId), "Unexpected Tracking ID");
            Address actualAddress = updateDeliveryAddressWithCsvPage.addressesTable.readEntity(i);
            Address expectedAddress = addresses.get(trackingId);
            expectedAddress.compareWithActual(actualAddress);
        }
    }

    @When("^Operator verify validation statuses on Update Delivery Address with CSV page:$")
    public void operatorVerifyValidationStatuses(List<Map<String, String>> dataList)
    {
        Map<String, String> data = dataList.stream().collect(Collectors.toMap(
                map -> resolveValue(map.get("trackingId")),
                map -> resolveValue(map.get("status"))
        ));
        int tableSize = updateDeliveryAddressWithCsvPage.addressesTable.getRowsCount();
        Assertions.assertEquals(data.size(), tableSize, "Number of updated addresses");

        for (int i = 1; i <= tableSize; i++)
        {
            String trackingId = updateDeliveryAddressWithCsvPage.addressesTable.getColumnText(i, COLUMN_TRACKING_ID);
            Assertions.assertTrue(data.containsKey(trackingId), f("Unexpected Tracking ID [%s]", trackingId));
            String actualStatus = updateDeliveryAddressWithCsvPage.addressesTable.getColumnText(i, COLUMN_VALIDATION);
            String expectedAddress = data.get(trackingId);
            Assert.assertThat(f("Validation status for Tracking ID", trackingId), actualStatus, Matchers.equalToIgnoringCase(expectedAddress));
        }
    }

    @When("^Operator confirm addresses update on Update Delivery Address with CSV page$")
    public void operatorConfirmAddressesUpdate()
    {
        updateDeliveryAddressWithCsvPage.confirmUpdatesButton.click();
        updateDeliveryAddressWithCsvPage.confirmUpdatesDialog.waitUntilVisible();
        updateDeliveryAddressWithCsvPage.confirmUpdatesDialog.proceedButton.click();
        pause2s();
    }

    @When("^Operator verify addresses were updated successfully on Update Delivery Address with CSV page$")
    public void operatorVerifyAddressesUpdatedSuccessfully()
    {
        Map<String, Address> addresses = get(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES);
        retryIfAssertionErrorOccurred(
                () -> Assertions.assertEquals(f("All %d records updated", addresses.size()), updateDeliveryAddressWithCsvPage.tableDescription.getText(), "Number of updated addresses"),
                "Assert Addresses table description after addresses update");
    }

    @And("^Operator verify orders info after address update$")
    public void apiOperatorVerifyOrdersInfoAfterAddressUpdate()
    {
        List<Order> orders = get(KEY_LIST_OF_ORDER_DETAILS);
        Map<String, Address> addresses = get(KEY_MAP_OF_UPDATED_DELIVERY_ADDRESSES);
        addresses.forEach((trackingId, toAddress) ->
        {
            Order order = orders.stream()
                    .filter(o -> StringUtils.equals(o.getTrackingId(), trackingId))
                    .findFirst()
                    .orElseThrow(() -> new AssertionError(f("Could not find order with Tracking ID [%s]", trackingId)));

            toAddress.compareWithActual(order.getToAddress());
        });
    }

    private File createUpdateDeliveryAddressCsvFile(Map<String, Address> addresses)
    {
        StringBuilder addressSb = new StringBuilder();
        addresses.forEach((trackingId, toAddress) ->
                {
                    if (StringUtils.startsWith(toAddress.getContact(), "+"))
                    {
                        toAddress.setContact(StringUtils.stripStart(toAddress.getContact(), "+"));
                    }
                    if (StringUtils.startsWith(toAddress.getPostcode(), "0"))
                    {
                        toAddress.setPostcode(StringUtils.stripStart(toAddress.getPostcode(), "0"));
                    }

                    addressSb
                            .append(getNonOptionalValue(trackingId)).append(",")
                            .append(getNonOptionalValue(toAddress.getName())).append(",")
                            .append(getNonOptionalValue(toAddress.getEmail())).append(",")
                            .append(getNonOptionalValue(toAddress.getContact())).append(",")
                            .append(getNonOptionalValue(toAddress.getAddress1())).append(",")
                            .append(getNonOptionalValue(toAddress.getAddress2())).append(",")
                            .append(getNonOptionalValue(toAddress.getPostcode())).append(",")
                            .append(getNonOptionalValue(toAddress.getCity())).append(",")
                            .append(getNonOptionalValue(toAddress.getCountry())).append(",")
                            .append(getNonOptionalValue(toAddress.getState())).append(",")
                            .append(getNonOptionalValue(toAddress.getDistrict())).append(",")
                            .append(getOptionalValue(toAddress.getLatitude() != null ? String.valueOf(toAddress.getLatitude()) : null)).append(",")
                            .append(getOptionalValue(toAddress.getLongitude() != null ? String.valueOf(toAddress.getLongitude()) : null))
                            .append(System.lineSeparator());
                }
        );
        try
        {
            File file = TestUtils.createFileOnTempFolder(String.format("update-delivery-address-request_%s.csv", generateDateUniqueString()));

            PrintWriter pw = new PrintWriter(new FileOutputStream(file));
            pw.write("Fill in '-' for non-optional fields that are blank");
            pw.write(System.lineSeparator());
            pw.write("tracking_id,to.name,to.email,to.phone_number,to.address.address1,to.address.address2,to.address.postcode,to.address.city,to.address.country,to.address.state,to.address.district,to.address.latitude,to.address.longitude");
            pw.write(System.lineSeparator());
            pw.write(addressSb.toString());
            pw.close();

            return file;
        } catch (IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }
    }

    private File createEmptyUpdateDeliveryAddressCsvFile(String trackingId)
    {
        try
        {
            File file = TestUtils.createFileOnTempFolder(String.format("update-delivery-address-request_%s.csv", generateDateUniqueString()));

            PrintWriter pw = new PrintWriter(new FileOutputStream(file));
            pw.write("Fill in '-' for non-optional fields that are blank");
            pw.write(System.lineSeparator());
            pw.write("tracking_id,to.name,to.email,to.phone_number,to.address.address1,to.address.address2,to.address.postcode,to.address.city,to.address.country,to.address.state,to.address.district,to.address.latitude,to.address.longitude");
            pw.write(System.lineSeparator());
            pw.write(f("%s,,,,,,,,,,,,", trackingId));
            pw.close();

            return file;
        } catch (IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }
    }

    private static String getNonOptionalValue(Object value)
    {
        if (value == null)
        {
            return "-";
        } else
        {
            return StringUtils.isBlank(String.valueOf(value)) ?
                    "-" :
                    StringUtils.normalizeSpace(String.valueOf(value));
        }
    }

    private static String getOptionalValue(Object value)
    {
        return value == null ? "" : StringUtils.normalizeSpace(String.valueOf(value));
    }
}
