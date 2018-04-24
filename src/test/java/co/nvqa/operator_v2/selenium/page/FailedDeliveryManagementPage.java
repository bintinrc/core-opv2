package co.nvqa.operator_v2.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class FailedDeliveryManagementPage extends CommonParcelManagementPage
{
    private static final String MD_VIRTUAL_REPEAT = "failedDelivery in getTableData()";
    private static final String CSV_FILENAME_PATTERN = "failed-delivery-list";

    public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
    public static final String COLUMN_CLASS_DATA_TYPE = "type";
    public static final String COLUMN_CLASS_DATA_FAILURE_COMMENTS = "last_attempt_comments";
    public static final String COLUMN_CLASS_DATA_FAILURE_REASON = "failure_reason_code";

    public static final String ACTION_BUTTON_RESCHEDULE_NEXT_DAY = "container.failed-delivery-management.reschedule-next-day";

    public FailedDeliveryManagementPage(WebDriver webDriver)
    {
        super(webDriver, MD_VIRTUAL_REPEAT);
    }

    public void verifyFailedDeliveryOrderIsListed(String trackingId, String orderType)
    {
        searchTableByTrackingId(trackingId);

        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        Assert.assertEquals("Tracking ID", trackingId, actualTrackingId);

        String actualOrderType = getTextOnTable(1, COLUMN_CLASS_DATA_TYPE);
        Assert.assertEquals("Order Type", orderType, actualOrderType);

        String actualFailureComments = getTextOnTable(1, COLUMN_CLASS_DATA_FAILURE_COMMENTS);
        Assert.assertEquals("Failure Comments", "Package is defective - Damaged", actualFailureComments);

        String actualFailureReason = getTextOnTable(1, COLUMN_CLASS_DATA_FAILURE_REASON);
        Assert.assertEquals("Failure Comments", "RECOVERY", actualFailureReason);
    }

    public void verifyCsvFileDownloadedSuccessfully(String trackingId)
    {
        verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN), trackingId);
    }

    public void rescheduleNextDay(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        clickActionButtonOnTable(1, ACTION_BUTTON_RESCHEDULE_NEXT_DAY);
    }

    public void verifyOrderIsRemovedFromTableAfterReschedule(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        boolean isTableEmpty = isTableEmpty();
        Assert.assertTrue(String.format("Tracking ID '%s' is still listed on failed order list.", trackingId), isTableEmpty);
    }
}
