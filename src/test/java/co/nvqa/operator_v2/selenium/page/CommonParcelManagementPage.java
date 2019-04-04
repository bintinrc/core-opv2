package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RtsDetails;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;

import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public abstract class CommonParcelManagementPage extends OperatorV2SimplePage
{
    public static final String ACTION_BUTTON_RTS = "commons.return-to-sender";
    protected static final int ACTION_SET_RTS_TO_SELECTED = 1;
    protected static final int ACTION_RESCHEDULE_SELECTED = 2;
    protected static final int ACTION_DOWNLOAD_CSV_FILE = 3;
    private final String mdVirtualRepeat;

    private EditRtsDetailsDialog editRtsDetailsDialog;

    public CommonParcelManagementPage(WebDriver webDriver, String mdVirtualRepeat)
    {
        super(webDriver);
        this.mdVirtualRepeat = mdVirtualRepeat;
        this.editRtsDetailsDialog = new EditRtsDetailsDialog(webDriver);
    }

    public void downloadCsvFile(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        checkRow(1);
        selectAction(ACTION_DOWNLOAD_CSV_FILE);
    }

    public void rescheduleNext2Days(String trackingId)
    {
        rescheduleNext2Days(Collections.singletonList(trackingId));
    }

    public void rescheduleNext2Days(List<String> trackingIds)
    {
        trackingIds.forEach(trackingId -> {
                    searchTableByTrackingId(trackingId);
                    checkRow(1);
                }
        );
        selectAction(ACTION_RESCHEDULE_SELECTED);
        setMdDatepickerById("commons.model.date", TestUtils.getNextDate(2));
        clickNvIconTextButtonByNameAndWaitUntilDone("commons.reschedule");
        waitUntilInvisibilityOfToast("Order Rescheduling Success");
    }

    public EditRtsDetailsDialog openEditRtsDetailsDialog(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        clickActionButtonOnTable(1, ACTION_BUTTON_RTS);
        pause500ms(); // To make sure the reasons is loaded
        return editRtsDetailsDialog.waitUntilVisible();
    }

    public void rtsSingleOrderNextDay(String trackingId)
    {
        searchTableByTrackingId(trackingId);
        clickActionButtonOnTable(1, ACTION_BUTTON_RTS);
        pause500ms(); // To make sure the reasons is loaded
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

    public void rtsSelectedOrderNext2Days(List<String> trackingIds)
    {
        trackingIds.forEach(trackingId -> {
                    searchTableByTrackingId(trackingId);
                    checkRow(1);
                }
        );
        selectAction(ACTION_SET_RTS_TO_SELECTED);
        setMdDatepickerById("commons.model.delivery-date", TestUtils.getNextDate(2));
        selectValueFromMdSelectById("commons.timeslot", "3PM - 6PM");
        String suitButtonLocator = trackingIds.size() > 1 ? "container.order.edit.set-orders-to-rts" : "container.order.edit.set-order-to-rts";
        clickNvApiTextButtonByNameAndWaitUntilDone(suitButtonLocator);
        waitUntilInvisibilityOfToast("Set Selected to Return to Sender");
    }

    public void selectAction(int actionType)
    {
        click("//span[text()='Apply Action']");

        switch (actionType)
        {
            case ACTION_SET_RTS_TO_SELECTED:
                clickButtonByAriaLabel("Set RTS to Selected");
                break;
            case ACTION_RESCHEDULE_SELECTED:
                clickButtonByAriaLabel("Reschedule Selected");
                break;
            case ACTION_DOWNLOAD_CSV_FILE:
                clickButtonByAriaLabel("Download CSV File");
                break;
        }

        pause500ms();
    }

    public void searchTableByTrackingId(String trackingId)
    {
        searchTableCustom1("tracking_id", trackingId);
    }

    public void checkRow(int rowIndex)
    {
        clickf("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'column-checkbox')]/md-checkbox", mdVirtualRepeat, rowIndex);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, mdVirtualRepeat);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, mdVirtualRepeat);
    }

    /**
     * Accessor for Edit RTS Details dialog
     */
    public static class EditRtsDetailsDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Edit RTS Details";
        private static final String BUTTON_SUBMIT_ARIA_LABEL = "Save changes";

        public EditRtsDetailsDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public EditRtsDetailsDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            return this;
        }

        public void setReason(String reason)
        {
            selectValueFromMdSelectById("commons.reason", reason);
        }

        public void setInternalNotes(String internalNotes)
        {
            sendKeysByAriaLabel("Internal Notes", internalNotes);
        }

        public void setDeliveryDate(Date deliveryDate)
        {
            setMdDatepickerById("commons.model.delivery-date", deliveryDate);
        }

        public void setTimeSlot(String timeSlot)
        {
            selectValueFromMdSelectById("commons.timeslot", timeSlot);
        }

        public void changeAddress(RtsDetails.RtsAddress address)
        {
            clickNvIconTextButtonByName("container.order.edit.change-address");

            if (StringUtils.isNotBlank(address.getCountry()))
            {
                sendKeysById("commons.country", address.getCountry());
            }
            if (StringUtils.isNotBlank(address.getCity()))
            {
                sendKeysById("commons.city", address.getCity());
            }
            if (StringUtils.isNotBlank(address.getAddress1()))
            {
                sendKeysById("commons.address1", address.getAddress1());
            }
            if (StringUtils.isNotBlank(address.getAddress2()))
            {
                sendKeysById("commons.address2", address.getAddress2());
            }
            if (StringUtils.isNotBlank(address.getPostcode()))
            {
                sendKeysById("commons.postcode", address.getPostcode());
            }
        }

        public EditRtsDetailsDialog fillForm(RtsDetails rtsDetails)
        {
            if (StringUtils.isNotBlank(rtsDetails.getReason()))
            {
                setReason(rtsDetails.getReason());
            }
            if (StringUtils.isNotBlank(rtsDetails.getInternalNotes()))
            {
                setInternalNotes(rtsDetails.getInternalNotes());
            }
            if (rtsDetails.getDeliveryDate() != null)
            {
                setDeliveryDate(rtsDetails.getDeliveryDate());
            }
            if (StringUtils.isNotBlank(rtsDetails.getTimeSlot()))
            {
                setTimeSlot(rtsDetails.getTimeSlot());
            }
            if (rtsDetails.getAddress() != null)
            {
                changeAddress(rtsDetails.getAddress());
            }
            return this;
        }

        public void submitForm()
        {
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUBMIT_ARIA_LABEL);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }
}
