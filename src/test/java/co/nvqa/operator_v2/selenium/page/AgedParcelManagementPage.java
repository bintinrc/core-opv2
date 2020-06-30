package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterTextBox;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class AgedParcelManagementPage extends CommonParcelManagementPage
{
    @FindBy(xpath = "//nv-filter-autocomplete[@main-title='Shipper']")
    public NvFilterAutocomplete shipperFilter;

    @FindBy(xpath = "//nv-filter-text-box[@main-title='Aged Days']")
    public NvFilterTextBox agedDaysFilter;

    @FindBy(name = "commons.load-selection")
    public NvApiTextButton loadSelection;

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
        failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);

        String actualTrackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        assertEquals("Tracking ID", trackingId, actualTrackingId);

        if (StringUtils.isNotBlank(shipperName))
        {
            String actualShipper = getTextOnTable(1, COLUMN_CLASS_DATA_SHIPPER);
            assertEquals("Shipper", shipperName, actualShipper);
        }

        if (StringUtils.isNotBlank(daysSinceInbound))
        {
            String actualDaysSinceInbound = getTextOnTable(1, COLUMN_CLASS_DAYS_SINCE_INBOUD);
            assertThat("Days since inbound", actualDaysSinceInbound, equalToIgnoringCase(daysSinceInbound));
        }
    }

    public void verifyCsvFileDownloadedSuccessfully(String trackingId)
    {
        verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN), trackingId);
    }

    public void rescheduleNextDay(String trackingId)
    {
        failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
        clickActionButtonOnTable(1, ACTION_BUTTON_RESCHEDULE_NEXT_DAY);
        waitUntilInvisibilityOfToast("Reschedule");
    }

    public void loadSelection(String shipperName, String trackingId, Integer agedDays)
    {
        retryIfNvTestRuntimeExceptionOccurred(() ->
        {
            if (!isElementExistFast(f("//button[contains(@aria-label,'%s')]", shipperName)))
            {
                if (StringUtils.isNotBlank(shipperName))
                {
                    shipperFilter.selectFilter(shipperName);
                } else
                {
                    shipperFilter.removeFilter();
                }

                if (agedDays != null)
                {
                    agedDaysFilter.setValue(String.valueOf(agedDays));
                } else
                {
                    agedDaysFilter.removeFilter();
                }
            }
            clickButtonLoadSelection();

            if (isElementExistFast("//*[contains(@class,'toast-error')]"))
            {
                closeToast();
            }

            failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);

            if (isTableEmpty())
            {
                clickButtonByAriaLabel("Edit Conditions");
                throw new NvTestRuntimeException(f("Order with tracking ID = '%s' is not listed on table.", trackingId));
            }
        }, f("%s - [Tracking ID = %s]", getCurrentMethodName(), trackingId));
    }

    private void clickButtonLoadSelection()
    {
        loadSelection.clickAndWaitUntilDone();
    }
}