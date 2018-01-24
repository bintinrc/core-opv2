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
        waitUntilInvisibilityOfToast("Reschedule");
    }

    @SuppressWarnings("unchecked")
    public void loadSelection(String shipperName, String trackingId, int agedDays)
    {
        TestUtils.retryIfRuntimeExceptionOccurred(()->
        {
            if(!isElementExistFast(String.format("//button[contains(@aria-label,'%s')]", TestConstants.SHIPPER_V2_NAME)))
            {
                selectValueFromMdAutocomplete("Search or Select...", shipperName);
                sendKeysByAriaLabel("Aged Days", String.valueOf(agedDays));
            }

            clickButtonLoadSelection();
            searchTableByTrackingId(trackingId);

            if(isTableEmpty())
            {
                clickButtonByAriaLabel("Edit Conditions");
                throw new RuntimeException(String.format("Order with tracking ID = '%s' is not listed on table.", trackingId));
            }
        }, String.format("%s - [Tracking ID = %s]", getCurrentMethodName(), trackingId));
    }

    private void clickButtonLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }
}
