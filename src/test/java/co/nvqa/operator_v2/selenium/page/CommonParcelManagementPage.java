package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestUtils;
import org.openqa.selenium.WebDriver;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public abstract class CommonParcelManagementPage extends SimplePage
{
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat CREATED_DATE_SDF = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");

    protected static final int ACTION_SET_RTS_TO_SELECTED = 1;
    protected static final int ACTION_RESCHEDULE_SELECTED = 2;
    protected static final int ACTION_DOWNLOAD_CSV_FILE = 3;

    public static final String ACTION_BUTTON_RTS = "commons.return-to-sender";

    private String mdVirtualRepeat;

    public CommonParcelManagementPage(WebDriver webDriver, String mdVirtualRepeat)
    {
        super(webDriver);
        this.mdVirtualRepeat = mdVirtualRepeat;
    }

    public void downloadCsvFile(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        checkRow(1);
        selectAction(ACTION_DOWNLOAD_CSV_FILE);
    }

    public void rescheduleNext2Days(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        checkRow(1);
        selectAction(ACTION_RESCHEDULE_SELECTED);
        sendKeys("//md-datepicker[@name='commons.model.date']/div/input", DATE_FORMAT.format(TestUtils.getNextDate(2)));
        click("//button[@aria-label='Reschedule']");
    }

    public void rtsSingleOrderNextDay(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        clickActionButtonOnTable(1, ACTION_BUTTON_RTS);
        click("//md-select[@placeholder='Reason']");
        pause50ms();
        click("//md-option/div[contains(text(), 'Other Reason')]");
        pause50ms();
        sendKeys("//input[@aria-label='Description']", String.format("Reason created by OpV2 automation on %s.", CREATED_DATE_SDF.format(new Date())));
        sendKeys("//input[@aria-label='Internal Notes']", String.format("Internal notes created by OpV2 automation on %s.", CREATED_DATE_SDF.format(new Date())));
        sendKeys("//md-datepicker[@name='commons.model.delivery-date']/div/input", DATE_FORMAT.format(TestUtils.getNextDate(1)));
        click("//md-select[@aria-label='Timeslot']");
        pause50ms();
        click("//md-option/div[contains(text(), '3PM - 6PM')]");
        click("//button[@aria-label='Save changes']");
    }

    public void rtsSelectedOrderNextDay(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        checkRow(1);
        selectAction(ACTION_SET_RTS_TO_SELECTED);
        sendKeys("//md-datepicker[@name='commons.model.delivery-date']/div/input", DATE_FORMAT.format(TestUtils.getNextDate(1)));
        click("//md-select[@aria-label='Timeslot']");
        pause50ms();
        click("//md-option/div[contains(text(), '3PM - 6PM')]");
        click("//button[@aria-label='Set Order to RTS']");
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
        searchTableCustom1("tracking_id", trackingId);
    }

    public void checkRow(int rowIndex)
    {
        click(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'column-checkbox')]/md-checkbox", mdVirtualRepeat, rowIndex));
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, mdVirtualRepeat);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, mdVirtualRepeat);
    }
}
