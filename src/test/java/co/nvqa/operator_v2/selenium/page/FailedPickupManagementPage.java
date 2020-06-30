package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.operator_v2.model.FailedDelivery;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.FailedPickupManagementPage.FailedPickupsTable.ACTION_RESCHEDULE_NEXT_DAY;
import static co.nvqa.operator_v2.selenium.page.FailedPickupManagementPage.FailedPickupsTable.COLUMN_TRACKING_ID;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class FailedPickupManagementPage extends OperatorV2SimplePage
{
    private static final String CSV_FILENAME_PATTERN = "failed-pickup-list";

    @FindBy(css = "md-dialog")
    public RescheduleSelectedOrdersDialog rescheduleSelectedOrdersDialog;

    @FindBy(css = "md-dialog")
    public CancelSelectedDialog cancelSelectedDialog;

    @FindBy(css = "div.navigation md-menu")
    public MdMenu actionsMenu;

    public final FailedPickupsTable failedPickupsTable;

    public FailedPickupManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        failedPickupsTable = new FailedPickupsTable(webDriver);
    }

    public void verifyTheFailedC2cOrReturnOrderIsListed(String trackingId, FailureReason expectedFailureReason)
    {
        failedPickupsTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
        FailedDelivery actual = failedPickupsTable.readEntity(1);
        assertEquals("Tracking ID", trackingId, actual.getTrackingId());
        assertEquals("Failure Comments", expectedFailureReason.getFailureReasonCodeDescription(), actual.getFailureReasonCodeDescription());
    }

    public void downloadCsvFile(String trackingId)
    {
        failedPickupsTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
        failedPickupsTable.selectRow(1);
        actionsMenu.selectOption("Download CSV File");
    }

    public void verifyCsvFileDownloadedSuccessfully(String trackingId)
    {
        verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN), trackingId);
    }

    public void rescheduleNextDay(String trackingId)
    {
        failedPickupsTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
        failedPickupsTable.clickActionButton(1, ACTION_RESCHEDULE_NEXT_DAY);
    }

    public void cancelSelected(List<String> listOfExpectedTrackingId)
    {
        listOfExpectedTrackingId.forEach(trackingId ->
        {
            failedPickupsTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
            failedPickupsTable.selectRow(1);
        });

        actionsMenu.selectOption("Cancel Selected");

        cancelSelectedDialog.waitUntilVisible();
        List<String> listOfActualTrackingIds = cancelSelectedDialog.trackingIds.stream().map(PageElement::getText).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));
        cancelSelectedDialog.cancellationReason.setValue(f("This order is canceled by automation to test 'Cancel Selected' feature on Failed Pickup Management. Canceled at %s.", CREATED_DATE_SDF.format(new Date())));

        if (listOfActualTrackingIds.size() == 1)
        {
            cancelSelectedDialog.cancelOrder.clickAndWaitUntilDone();
        } else
        {
            cancelSelectedDialog.cancelOrders.clickAndWaitUntilDone();
        }
        cancelSelectedDialog.waitUntilInvisible();
        waitUntilInvisibilityOfToast("updated");
    }

    public void rescheduleNext2Days(String trackingId)
    {
        rescheduleNext2Days(Collections.singletonList(trackingId));
    }

    public void rescheduleNext2Days(List<String> trackingIds)
    {
        trackingIds.forEach(trackingId ->
        {
            failedPickupsTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
            failedPickupsTable.selectRow(1);
        });

        actionsMenu.selectOption("Reschedule Selected");
        rescheduleSelectedOrdersDialog.waitUntilVisible();
        rescheduleSelectedOrdersDialog.date.setDate(TestUtils.getNextDate(2));
        rescheduleSelectedOrdersDialog.reschedule.click();
        rescheduleSelectedOrdersDialog.waitUntilInvisible();
    }

    public void verifyOrderIsRemovedFromTableAfterReschedule(String trackingId)
    {
        failedPickupsTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
        assertTrue(f("Tracking ID '%s' is still listed on failed order list.", trackingId), failedPickupsTable.isEmpty());
    }

    public static class FailedPickupsTable extends MdVirtualRepeatTable<FailedDelivery>
    {
        public static final String MD_VIRTUAL_REPEAT = "failedPickup in getTableData()";
        public static final String COLUMN_TRACKING_ID = "trackingId";
        public static final String ACTION_RESCHEDULE_NEXT_DAY = "Reschedule Next Day";

        private FailedPickupsTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_TRACKING_ID, "tracking_id")
                    .put("shipperName", "_shipper-name")
                    .put("lastAttemptTime", "_last-attempt-time")
                    .put("failureReasonComments", "_failure-reason-comments")
                    .put("attemptCount", "attempt_count")
                    .put("invalidFailureCount", "_invalid-failure-count")
                    .put("validFailureCount", "_valid-failure-count")
                    .put("failureReasonCodeDescription", "_failure-reason-code-descriptions")
                    .put("daysSinceLastAttempt", "_days-since-last-attempt")
                    .put("priorityLevel", "_priority-level")
                    .build()
            );
            setActionButtonsLocators(ImmutableMap.of(ACTION_RESCHEDULE_NEXT_DAY, "container.failed-pickup-management.reschedule-next-day"));
            setEntityClass(FailedDelivery.class);
            setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
        }
    }

    public static class RescheduleSelectedOrdersDialog extends MdDialog
    {
        @FindBy(id = "commons.model.date")
        public MdDatepicker date;

        @FindBy(name = "commons.reschedule")
        public NvIconTextButton reschedule;

        public RescheduleSelectedOrdersDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }
    }

    public static class CancelSelectedDialog extends MdDialog
    {
        @FindBy(css = "[id^='container.order.edit.cancellation-reason']")
        public TextBox cancellationReason;

        @FindBy(css = "tr[ng-repeat='order in ctrl.orders'] td:nth-of-type(1)")
        public List<PageElement> trackingIds;

        @FindBy(name = "container.order.edit.cancel-order")
        public NvApiTextButton cancelOrder;

        @FindBy(name = "container.order.edit.cancel-orders")
        public NvApiTextButton cancelOrders;

        public CancelSelectedDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }
    }
}