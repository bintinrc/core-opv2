package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.operator_v2.util.TestUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

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
    public static final String COLUMN_CLASS_DATA_FAILURE_COMMENTS = "_failure-reason-comments";

    public static final String ACTION_BUTTON_RESCHEDULE_NEXT_DAY = "container.failed-pickup-management.reschedule-next-day";

    public static final int ACTION_CANCEL_SELECTED = 1;
    public static final int ACTION_RESCHEDULE_SELECTED = 2;
    public static final int ACTION_DOWNLOAD_CSV_FILE = 3;

    public FailedPickupManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void verifyTheFailedC2cOrReturnOrderIsListed(String trackingId, FailureReason expectedFailureReason)
    {
        searchTableByTrackingId(trackingId);
        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        assertEquals("Tracking ID", trackingId, actualTrackingId);
        String actualFailureComments = getTextOnTable(1, COLUMN_CLASS_DATA_FAILURE_COMMENTS);
        assertEquals("Failure Comments", expectedFailureReason.getDescription(), actualFailureComments);
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

    public void cancelSelected(List<String> listOfExpectedTrackingId)
    {
        listOfExpectedTrackingId.forEach(trackingId ->
        {
            searchTableByTrackingId(trackingId);
            checkRow(1);
        });

        selectAction(ACTION_CANCEL_SELECTED);

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='order in ctrl.orders']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        sendKeysById("container.order.edit.cancellation-reason", String.format("This order is canceled by automation to test 'Cancel Selected' feature on Failed Pickup Management. Canceled at %s.", CREATED_DATE_SDF.format(new Date())));

        if(listOfActualTrackingIds.size()==1)
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.cancel-order");
        }
        else
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.cancel-orders");
        }

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
            searchTableByTrackingId(trackingId);
            checkRow(1);
        });

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
        assertTrue(f("Tracking ID '%s' is still listed on failed order list.", trackingId), isTableEmpty);
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
