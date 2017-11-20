package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AgedParcelManagementPage extends CommonParcelManagementPage
{
    private static final String MD_VIRTUAL_REPEAT = "agedParcel in getTableData()";
    private static final String CSV_FILENAME_PATTERN = "aged-parcel-list";

    public static final String COLUMN_CLASS_TRACKING_ID = "tracking_id";
    public static final String COLUMN_CLASS_SHIPPER = "shipper";

    public static final String ACTION_BUTTON_RESCHEDULE_NEXT_DAY = "container.aged-parcel-management.reschedule-next-day";

    public AgedParcelManagementPage(WebDriver webDriver)
    {
        super(webDriver, MD_VIRTUAL_REPEAT);
    }

    public void verifyAgedParcelOrderIsListed(String trackingId, String shipperName)
    {
        searchTableByTrackingId(trackingId);

        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_TRACKING_ID);
        Assert.assertEquals("Tracking ID", trackingId, actualTrackingId);

        String actualShipper = getTextOnTable(1, COLUMN_CLASS_SHIPPER);
        Assert.assertEquals("Shipper", shipperName, actualShipper);
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

    @SuppressWarnings("unchecked")
    public void loadSelection(String trackingId, int agedDays)
    {
        TestUtils.retryIfRuntimeExceptionOccurred(()->
        {
            if(!isElementExist(String.format("//button[contains(@aria-label,'%s')]", TestConstants.SHIPPER_V2_NAME), 1))
            {
                inputListBox("Search or Select...", TestConstants.SHIPPER_V2_NAME);
                sendKeys("//input[@aria-label='Aged Days']", String.valueOf(agedDays));
            }

            clickBtnLoadSelection();
            searchTableByTrackingId(trackingId);

            if(isTableEmpty())
            {
                click("//button[@aria-label='Edit Conditions']");
                throw new RuntimeException(String.format("Order with tracking ID = '%s' is not listed on table.", trackingId));
            }
        }, String.format("loadSelection - [Tracking ID = %s]", trackingId));
    }

    private void clickBtnLoadSelection()
    {
        clickAndWaitUntilDone("//button[@aria-label='Load Selection']");
    }
}
