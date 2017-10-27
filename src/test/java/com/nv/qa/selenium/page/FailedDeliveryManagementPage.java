package com.nv.qa.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.text.SimpleDateFormat;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class FailedDeliveryManagementPage extends SimplePage
{
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

    private static final String MD_VIRTUAL_REPEAT = "failedDelivery in getTableData()";
    private static final String CSV_FILENAME_PATTERN = "failed-delivery-list";

    public static final String COLUMN_CLASS_TRACKING_ID = "tracking_id";
    public static final String COLUMN_CLASS_TYPE = "type";
    public static final String COLUMN_CLASS_FAILURE_COMMENTS = "last_attempt_comments";
    public static final String COLUMN_CLASS_FAILURE_REASON = "failure_reason_code";

    public static final String ACTION_BUTTON_RESCHEDULE_NEXT_DAY = "container.failed-delivery-management.reschedule-next-day";

    public static final int ACTION_SET_RTS_TO_SELECTED = 1;
    public static final int ACTION_RESCHEDULE_SELECTED = 2;
    public static final int ACTION_DOWNLOAD_CSV_FILE = 3;

    public FailedDeliveryManagementPage(WebDriver driver)
    {
        super(driver);
    }

    public void verifyFailedDeliveryOrderIsListed(String trackingId, String orderType)
    {
        searchTableByTrackingId(trackingId);

        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_TRACKING_ID);
        Assert.assertEquals("Tracking ID", trackingId, actualTrackingId);

        String actualOrderType = getTextOnTable(1, COLUMN_CLASS_TYPE);
        Assert.assertEquals("Order Type", orderType, actualOrderType);

        String actualFailureComments = getTextOnTable(1, COLUMN_CLASS_FAILURE_COMMENTS);
        Assert.assertEquals("Failure Comments", "Package is defective - Damaged", actualFailureComments);

        String actualFailureReason = getTextOnTable(1, COLUMN_CLASS_FAILURE_REASON);
        Assert.assertEquals("Failure Comments", "RECOVERY", actualFailureReason);
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

    public void verifyOrderIsRemovedFromTableAfterReschedule(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        boolean isTableEmpty = isTableEmpty();
        Assert.assertTrue(String.format("Tracking ID '%s' is still listed on failed order list.", trackingId), isTableEmpty);
    }

    public boolean isTableEmpty()
    {
        WebElement we = findElementByXpath("//h5[text()='No Results Found']");
        return we!=null;
    }

    public void checkRow(int rowIndex)
    {
        click(String.format("//tr[@md-virtual-repeat='failedDelivery in getTableData()'][%d]/td[contains(@class, 'column-checkbox')]/md-checkbox", rowIndex));
    }

    public void selectAction(int actionType)
    {
        click("//span[text()='Apply Action']");

        switch(actionType)
        {
            case ACTION_SET_RTS_TO_SELECTED: click("//button[@aria-label='Set RTS to Selected']"); break;
            case ACTION_RESCHEDULE_SELECTED: click("//button[@aria-label='Reschedule Selected']"); break;
            case ACTION_DOWNLOAD_CSV_FILE: click("//button[@aria-label='Download CSV File']"); break;
        }
    }

    public void searchTableByTrackingId(String trackingId)
    {
        searchTable("tracking_id", trackingId);
    }

    private void searchTable(String filterColumnClass, String value)
    {
        sendKeys(String.format("//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/input", filterColumnClass), value);
        pause100ms();
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
