package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class AgedParcelManagementPage extends CommonParcelManagementPage
{
    private static final String MD_VIRTUAL_REPEAT = "agedParcel in getTableData()";
    private static final String CSV_FILENAME_PATTERN = "aged-parcel-list";

    public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
    public static final String COLUMN_CLASS_DATA_SHIPPER = "shipper";
    public static final String COLUMN_CLASS_DAYS_SINCE_INBOUD = "custom_days_since_inbound";

    public static final String ACTION_BUTTON_RESCHEDULE_NEXT_DAY = "container.aged-parcel-management.reschedule-next-day";

    public AgedParcelManagementPage(WebDriver webDriver)
    {
        super(webDriver, MD_VIRTUAL_REPEAT);
    }

    public void verifyAgedParcelOrderIsListed(String trackingId, String shipperName, String daysSinceInbound)
    {
        searchTableByTrackingId(trackingId);

        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        Assert.assertEquals("Tracking ID", trackingId, actualTrackingId);

        if(StringUtils.isNotBlank(shipperName))
        {
            String actualShipper = getTextOnTable(1, COLUMN_CLASS_DATA_SHIPPER);
            Assert.assertEquals("Shipper", shipperName, actualShipper);
        }

        if(StringUtils.isNotBlank(daysSinceInbound))
        {
            String actualDaysSinceInbound = getTextOnTable(1, COLUMN_CLASS_DAYS_SINCE_INBOUD);
            Assert.assertThat("Days since inbound", actualDaysSinceInbound, Matchers.equalToIgnoringCase(daysSinceInbound));
        }
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
    public void loadSelection(String shipperName, String trackingId, Integer agedDays)
    {
        TestUtils.retryIfNvTestRuntimeExceptionOccurred(()->
        {
            if(!isElementExistFast(String.format("//button[contains(@aria-label,'%s')]", shipperName)))
            {
                if(StringUtils.isNotBlank(shipperName))
                {
                    selectValueFromNvAutocompleteByItemTypesAndDismiss("Shipper", shipperName);
                }
                else
                {
                    removeNvFilterBoxByMainTitle("Shipper");
                }

                if(agedDays!=null)
                {
                    sendKeysByAriaLabel("Aged Days", String.valueOf(agedDays));
                }
                else
                {
                    removeNvFilterBoxByMainTitle("Aged Days");
                }
            }

            clickButtonLoadSelection();
            searchTableByTrackingId(trackingId);

            if(isTableEmpty())
            {
                clickButtonByAriaLabel("Edit Conditions");
                throw new NvTestRuntimeException(String.format("Order with tracking ID = '%s' is not listed on table.", trackingId));
            }
        }, String.format("%s - [Tracking ID = %s]", getCurrentMethodName(), trackingId));
    }

    private void clickButtonLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }
}
