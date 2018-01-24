package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestUtils;
import org.openqa.selenium.WebDriver;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public abstract class CommonParcelManagementPage extends SimplePage
{
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
        setMdDatepickerById("commons.model.date", TestUtils.getNextDate(2));
        clickNvIconTextButtonByNameAndWaitUntilDone("commons.reschedule");
        waitUntilInvisibilityOfToast("Order Rescheduling Success");
    }

    public void rtsSingleOrderNextDay(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        clickActionButtonOnTable(1, ACTION_BUTTON_RTS);
        selectValueFromMdSelectById("commons.reason", "Other Reason");
        sendKeysByAriaLabel("Description", String.format("Reason created by OpV2 automation on %s.", CREATED_DATE_SDF.format(new Date())));
        sendKeysByAriaLabel("Internal Notes", String.format("Internal notes created by OpV2 automation on %s.", CREATED_DATE_SDF.format(new Date())));
        setMdDatepickerById("commons.model.delivery-date", TestUtils.getNextDate(1));
        selectValueFromMdSelectById("commons.timeslot", "3PM - 6PM");
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
        waitUntilInvisibilityOfToast("RTS-ed");
    }

    public void rtsSelectedOrderNextDay(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        checkRow(1);
        selectAction(ACTION_SET_RTS_TO_SELECTED);
        setMdDatepickerById("commons.model.delivery-date", TestUtils.getNextDate(1));
        selectValueFromMdSelectById("commons.timeslot", "3PM - 6PM");
        clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.set-order-to-rts");
        waitUntilInvisibilityOfToast("Set Selected to Return to Sender");
    }

    public void selectAction(int actionType)
    {
        click("//span[text()='Apply Action']");

        switch(actionType)
        {
            case ACTION_SET_RTS_TO_SELECTED: clickButtonByAriaLabel("Set RTS to Selected"); break;
            case ACTION_RESCHEDULE_SELECTED: clickButtonByAriaLabel("Reschedule Selected"); break;
            case ACTION_DOWNLOAD_CSV_FILE: clickButtonByAriaLabel("Download CSV File"); break;
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
