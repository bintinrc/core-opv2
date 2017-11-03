package com.nv.qa.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.text.SimpleDateFormat;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AgedParcelManagementPage extends SimplePage
{
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat CREATED_DATE_SDF = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");

    private static final String MD_VIRTUAL_REPEAT = "agedParcel in getTableData()";
    private static final String CSV_FILENAME_PATTERN = "aged-parcel-list";

    public static final String COLUMN_CLASS_TRACKING_ID = "tracking_id";
    public static final String COLUMN_CLASS_SHIPPER = "shipper";

    public static final String ACTION_BUTTON_RESCHEDULE_NEXT_DAY = "container.aged-parcel-management.reschedule-next-day";
    public static final String ACTION_BUTTON_RTS = "commons.return-to-sender";

    public static final int ACTION_SET_RTS_TO_SELECTED = 1;
    public static final int ACTION_RESCHEDULE_SELECTED = 2;
    public static final int ACTION_DOWNLOAD_CSV_FILE = 3;

    public AgedParcelManagementPage(WebDriver driver)
    {
        super(driver);
    }

    public void verifyAgedParcelOrderIsListed(String trackingId, String shipperName)
    {
        searchTableByTrackingId(trackingId);

        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_TRACKING_ID);
        Assert.assertEquals("Tracking ID", trackingId, actualTrackingId);

        String actualShipper = getTextOnTable(1, COLUMN_CLASS_SHIPPER);
        Assert.assertEquals("Shipper", shipperName, actualShipper);
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

    public void loadSelection(int agedDays)
    {
        sendKeys("//input[@aria-label='Aged Days']", String.valueOf(agedDays));
        click("//button/div[text()='Load Selection']");
    }

    public boolean isTableEmpty()
    {
        WebElement we = findElementByXpath("//h5[text()='No Results Found']");
        return we!=null;
    }

    public void checkRow(int rowIndex)
    {
        click(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'column-checkbox')]/md-checkbox", MD_VIRTUAL_REPEAT, rowIndex));
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
