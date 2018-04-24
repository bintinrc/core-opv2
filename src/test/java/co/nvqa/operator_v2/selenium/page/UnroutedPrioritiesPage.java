package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.utils.NvTestRuntimeException;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class UnroutedPrioritiesPage extends OperatorV2SimplePage
{
    private static final SimpleDateFormat TRANSACTION_END_DATE_SDF = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    private static final String MD_VIRTUAL_REPEAT = "unroutedPriority in getTableData()";
    public static final String COLUMN_ClASS_DATA_TRACKING_ID = "tracking_id";
    public static final String COLUMN_ClASS_DATA_SHIPPER_NAME = "shipper_name";
    public static final String COLUMN_ClASS_DATA_TRANSACTION_END_TIME = "transaction_end_time";
    public static final String COLUMN_ClASS_DATA_GRANULAR_STATUS = "order_granular_status";

    public UnroutedPrioritiesPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void filterAndClickLoadSelection(Date routeDate)
    {
        setMdDatepicker("ctrl.date", routeDate);
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }

    public void verifyOrderIsListedAndContainsCorrectInfo(Order order)
    {
        Long orderId = order.getId();
        String trackingId = order.getTrackingId();

        searchTableByTrackingId(trackingId);
        Assert.assertFalse(String.format("Order (ID = %d - Tracking ID = %s) not found on table.", orderId, trackingId), isTableEmpty());

        String actualTrackingId = getTextOnTable(1, COLUMN_ClASS_DATA_TRACKING_ID);
        String actualShipperName = getTextOnTable(1, COLUMN_ClASS_DATA_SHIPPER_NAME);
        String actualGranularStatus = getTextOnTable(1, COLUMN_ClASS_DATA_GRANULAR_STATUS);
        String actualTransactionEndTime = getTextOnTable(1, COLUMN_ClASS_DATA_TRANSACTION_END_TIME);

        Assert.assertEquals("Tracking ID", order.getTrackingId(), actualTrackingId);
        Assert.assertEquals("Shipper Name", order.getShipper().getName(), actualShipperName);
        Assert.assertThat("Granular Status", actualGranularStatus, Matchers.equalToIgnoringCase(order.getGranularStatus().replace("_", " ")));

        try
        {
            Date transactionEndDate = ISO_8601_WITHOUT_MILLISECONDS.parse(order.getTransactions().get(order.getTransactions().size()-1).getEndTime());
            String expectedTransactionEndDate = TRANSACTION_END_DATE_SDF.format(transactionEndDate);
            Assert.assertEquals("Transaction End Time", expectedTransactionEndDate, actualTransactionEndTime);
        }
        catch(ParseException ex)
        {
            throw new NvTestRuntimeException("Failed to parse transaction end date.");
        }
    }

    public void verifyOrderIsNotListed(Order order)
    {
        Long orderId = order.getId();
        String trackingId = order.getTrackingId();

        searchTableByTrackingId(trackingId);
        Assert.assertTrue(String.format("Order (ID = %d - Tracking ID = %s) should not be listed on table.", orderId, trackingId), isTableEmpty());
    }

    public void searchTableByTrackingId(String trackingId)
    {
        searchTableCustom1("tracking_id", trackingId);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }
}
