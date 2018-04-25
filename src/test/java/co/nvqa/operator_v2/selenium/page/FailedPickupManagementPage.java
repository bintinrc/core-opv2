package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class FailedPickupManagementPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "failedPickup in getTableData()";
    private static final String CSV_FILENAME_PATTERN = "failed-pickup-list";

    public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
    public static final String COLUMN_CLASS_DATA_FAILURE_COMMENTS = "last_attempt_comments";

    public static final String ACTION_BUTTON_RESCHEDULE_NEXT_DAY = "container.failed-pickup-management.reschedule-next-day";

    public static final int ACTION_CANCEL_SELECTED = 1;
    public static final int ACTION_RESCHEDULE_SELECTED = 2;
    public static final int ACTION_DOWNLOAD_CSV_FILE = 3;

    public FailedPickupManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void verifyTheFailedC2cOrReturnOrderIsListed(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        Assert.assertEquals("Tracking ID", trackingId, actualTrackingId);
        String actualFailureComments = getTextOnTable(1, COLUMN_CLASS_DATA_FAILURE_COMMENTS);
        Assert.assertEquals("Failure Comments", "Rejected - damaged items", actualFailureComments);
    }

    public void downloadCsvFile(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        checkRow(1);
        selectAction(ACTION_DOWNLOAD_CSV_FILE);
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

    public void rescheduleNext2Days(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        checkRow(1);
        selectAction(ACTION_RESCHEDULE_SELECTED);
        setRescheduleDate(TestUtils.getNextDate(2));
        click("//button[@aria-label='Reschedule']");
    }

    public void setRescheduleDate(Date date)
    {
        setMdDatepickerById("commons.model.date", date);
    }

    public void verifyOrderIsRemovedFromTableAfterReschedule(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        boolean isTableEmpty = isTableEmpty();
        Assert.assertTrue(String.format("Tracking ID '%s' is still listed on failed order list.", trackingId), isTableEmpty);
    }

    public void checkRow(int rowIndex)
    {
        clickf("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'column-checkbox')]/md-checkbox", MD_VIRTUAL_REPEAT, rowIndex);
    }

    public void selectAction(int actionType)
    {
        click("//span[text()='Apply Action']");

        switch(actionType)
        {
            case ACTION_CANCEL_SELECTED: clickButtonByAriaLabel("Cancel Selected"); break;
            case ACTION_RESCHEDULE_SELECTED: clickButtonByAriaLabel("Reschedule Selected"); break;
            case ACTION_DOWNLOAD_CSV_FILE: clickButtonByAriaLabel("Download CSV File"); break;
        }

        pause500ms();
    }

    public void searchTableByTrackingId(String trackingId)
    {
        searchTableCustom1("tracking_id", trackingId);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
