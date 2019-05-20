package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.driver.FailureReason;
import org.openqa.selenium.WebDriver;

import java.util.List;

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
    public static final String COLUMN_CLASS_DATA_FAILURE_COMMENTS = "_failure-reason-comments";
    public static final String COLUMN_CLASS_DATA_FAILURE_REASON = "_failure-reason-code-descriptions";

    public static final String ACTION_BUTTON_RESCHEDULE_NEXT_DAY = "container.failed-delivery-management.reschedule-next-day";

    public static final String ORDER_TAGS_LIST_XPATH = "//nv-table//tr[not(contains(@class, 'last-row'))][1]/td[normalize-space(@class)='_order-tags']/nv-fdm-pills/div";

    public FailedDeliveryManagementPage(WebDriver webDriver)
    {
        super(webDriver, MD_VIRTUAL_REPEAT);
    }

    public void verifyFailedDeliveryOrderIsListed(Order order, FailureReason expectedFailureReason)
    {
        String trackingId = order.getTrackingId();
        String orderType = order.getType();

        searchTableByTrackingId(trackingId);

        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        assertEquals("Tracking ID", trackingId, actualTrackingId);

        String actualOrderType = getTextOnTable(1, COLUMN_CLASS_DATA_TYPE);
        assertEquals("Order Type", orderType, actualOrderType);

        String actualFailureComments = getTextOnTable(1, COLUMN_CLASS_DATA_FAILURE_COMMENTS);
        assertEquals("Failure Comments", expectedFailureReason.getDescription(), actualFailureComments);

        String actualFailureReason = getTextOnTable(1, COLUMN_CLASS_DATA_FAILURE_REASON);
        assertEquals("Failure Reason", actualFailureReason, expectedFailureReason.getFailureReasonCodeDescription());
    }

    public void verifyFailedDeliveryOrderIsTagged(Order order, List<String> orderTags)
    {
        String trackingId = order.getTrackingId();

        searchTableByTrackingId(trackingId);

        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        assertEquals("Tracking ID", trackingId, actualTrackingId);

        List<String> actualTags = getTextOfElements(ORDER_TAGS_LIST_XPATH);
        assertEquals("Tags", actualTags, orderTags);
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
        refreshPage();
        searchTableByTrackingId(trackingId);
        boolean isTableEmpty = isTableEmpty();
        assertTrue(f("Tracking ID '%s' is still listed on failed order list.", trackingId), isTableEmpty);
    }
}
