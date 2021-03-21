package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.FailedDelivery;
import co.nvqa.operator_v2.model.RtsDetails;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public abstract class CommonParcelManagementPage extends OperatorV2SimplePage {

  @FindBy(css = "md-dialog")
  public EditRtsDetailsDialog editRtsDetailsDialog;

  @FindBy(css = "md-dialog")
  public SetSelectedToReturnToSenderDialog setSelectedToReturnToSenderDialog;

  public final FailedDeliveriesTable failedDeliveriesTable;

  protected static final int ACTION_SET_RTS_TO_SELECTED = 1;
  protected static final int ACTION_RESCHEDULE_SELECTED = 2;
  protected static final int ACTION_DOWNLOAD_CSV_FILE = 3;
  private final String mdVirtualRepeat;


  public CommonParcelManagementPage(WebDriver webDriver, String mdVirtualRepeat) {
    super(webDriver);
    this.mdVirtualRepeat = mdVirtualRepeat;
    failedDeliveriesTable = new FailedDeliveriesTable(webDriver);
  }

  public void downloadCsvFile(String trackingId) {
    failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
    failedDeliveriesTable.selectRow(1);
    selectAction(ACTION_DOWNLOAD_CSV_FILE);
  }

  public void rescheduleNext2Days(String trackingId) {
    rescheduleNext2Days(Collections.singletonList(trackingId));
  }

  public void rescheduleNext2Days(List<String> trackingIds) {
    trackingIds.forEach(trackingId ->
    {
      failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
      failedDeliveriesTable.selectRow(1);
    });

    selectAction(ACTION_RESCHEDULE_SELECTED);
    setMdDatepickerById("commons.model.date", TestUtils.getNextDate(2));
    clickNvIconTextButtonByNameAndWaitUntilDone("commons.reschedule");
    waitUntilInvisibilityOfToast("Order Rescheduling Success");
  }

  public EditRtsDetailsDialog openEditRtsDetailsDialog(String trackingId) {
    failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
    failedDeliveriesTable.clickActionButton(1, FailedDeliveriesTable.ACTION_RTS);
    editRtsDetailsDialog.waitUntilVisible();
    return editRtsDetailsDialog;
  }

  public void rtsSingleOrderNextDay(String trackingId) {
    failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
    failedDeliveriesTable.clickActionButton(1, FailedDeliveriesTable.ACTION_RTS);
    editRtsDetailsDialog.waitUntilVisible();
    editRtsDetailsDialog.reason.selectValue("Other Reason");
    editRtsDetailsDialog.description.setValue(
        f("Reason created by OpV2 automation on %s.", CREATED_DATE_SDF.format(new Date())));
    editRtsDetailsDialog.internalNotes.setValue(
        f("Internal notes created by OpV2 automation on %s.", CREATED_DATE_SDF.format(new Date())));
    editRtsDetailsDialog.deliveryDate.setDate(TestUtils.getNextDate(1));
    editRtsDetailsDialog.timeslot.selectValue("3PM - 6PM");
    editRtsDetailsDialog.saveChanges.clickAndWaitUntilDone();
    editRtsDetailsDialog.waitUntilInvisible();
    waitUntilInvisibilityOfToast("RTS-ed");
  }

  public void rtsSelectedOrderNextDay(String trackingId) {
    failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
    failedDeliveriesTable.selectRow(1);
    selectAction(ACTION_SET_RTS_TO_SELECTED);
    setSelectedToReturnToSenderDialog.waitUntilVisible();
    setSelectedToReturnToSenderDialog.deliveryDate.setDate(TestUtils.getNextDate(1));
    setSelectedToReturnToSenderDialog.timeslot.selectValue("3PM - 6PM");
    setSelectedToReturnToSenderDialog.setOrderToRts.clickAndWaitUntilDone();
    setSelectedToReturnToSenderDialog.waitUntilInvisible();
    waitUntilInvisibilityOfToast("Set Selected to Return to Sender");
  }

  public void rtsSelectedOrderNext2Days(List<String> trackingIds) {
    trackingIds.forEach(trackingId ->
    {
      failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
      failedDeliveriesTable.selectRow(1);
    });

    selectAction(ACTION_SET_RTS_TO_SELECTED);
    setMdDatepickerById("commons.model.delivery-date", TestUtils.getNextDate(2));
    selectValueFromMdSelectById("commons.timeslot", "3PM - 6PM");
    String suitButtonLocator = trackingIds.size() > 1 ? "container.order.edit.set-orders-to-rts"
        : "container.order.edit.set-order-to-rts";
    clickNvApiTextButtonByNameAndWaitUntilDone(suitButtonLocator);
    waitUntilInvisibilityOfToast("Set Selected to Return to Sender");
  }

  public void selectAction(int actionType) {
    click("//span[text()='Apply Action']");

    switch (actionType) {
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

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTable(rowNumber, columnDataClass, mdVirtualRepeat);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, mdVirtualRepeat);
  }

  /**
   * Accessor for Edit RTS Details dialog
   */
  public static class EditRtsDetailsDialog extends MdDialog {

    @FindBy(css = "[id^='commons.reason']")
    public MdSelect reason;

    @FindBy(css = "[id^='commons.description']")
    public TextBox description;

    @FindBy(css = "[id^='commons.recipient-name']")
    public TextBox recipientName;

    @FindBy(css = "[id^='commons.recipient-contact']")
    public TextBox recipientContact;

    @FindBy(css = "[id^='commons.recipient-email']")
    public TextBox recipientEmail;

    @FindBy(css = "[id^='container.order.edit.internal-notes']")
    public TextBox internalNotes;

    @FindBy(id = "commons.model.delivery-date")
    public MdDatepicker deliveryDate;

    @FindBy(css = "[id^='commons.timeslot']")
    public MdSelect timeslot;

    @FindBy(name = "container.order.edit.change-address")
    public NvIconTextButton changeAddress;

    @FindBy(css = "[id^='commons.country']")
    public TextBox country;

    @FindBy(css = "[id^='commons.city']")
    public TextBox city;

    @FindBy(css = "[id^='commons.address1']")
    public TextBox address1;

    @FindBy(css = "[id^='commons.address2']")
    public TextBox address2;

    @FindBy(css = "[id^='commons.postcode']")
    public TextBox postcode;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;

    public EditRtsDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void changeAddress(RtsDetails.RtsAddress address) {
      changeAddress.click();

      if (StringUtils.isNotBlank(address.getCountry())) {
        country.setValue(address.getCountry());
      }
      if (StringUtils.isNotBlank(address.getCity())) {
        city.setValue(address.getCity());
      }
      if (StringUtils.isNotBlank(address.getAddress1())) {
        address1.setValue(address.getAddress1());
      }
      if (StringUtils.isNotBlank(address.getAddress2())) {
        address2.setValue(address.getAddress1());
      }
      if (StringUtils.isNotBlank(address.getPostcode())) {
        postcode.setValue(address.getPostcode());
      }
    }

    public EditRtsDetailsDialog fillForm(RtsDetails rtsDetails) {
      if (StringUtils.isNotBlank(rtsDetails.getReason())) {
        reason.selectValue(rtsDetails.getReason());
      }
      if (StringUtils.isNotBlank(rtsDetails.getInternalNotes())) {
        internalNotes.setValue(rtsDetails.getInternalNotes());
      }
      if (rtsDetails.getDeliveryDate() != null) {
        deliveryDate.setDate(rtsDetails.getDeliveryDate());
      }
      if (StringUtils.isNotBlank(rtsDetails.getTimeSlot())) {
        timeslot.selectValue(rtsDetails.getTimeSlot());
      }
      if (rtsDetails.getAddress() != null) {
        changeAddress(rtsDetails.getAddress());
      }
      return this;
    }

    public void submitForm() {
      saveChanges.clickAndWaitUntilDone();
    }
  }

  public static class FailedDeliveriesTable extends MdVirtualRepeatTable<FailedDelivery> {

    public static final String MD_VIRTUAL_REPEAT = "failedDelivery in getTableData()";
    public static final String COLUMN_TRACKING_ID = "trackingId";
    public static final String ACTION_RESCHEDULE_NEXT_DAY = "Reschedule Next Day";
    public static final String ACTION_RTS = "RTS";

    private FailedDeliveriesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_TRACKING_ID, "tracking_id")
          .put("type", "type")
          .put("shipperName", "_shipper-name")
          .put("lastAttemptTime", "_last-attempt-time")
          .put("failureReasonComments", "_failure-reason-comments")
          .put("attemptCount", "attempt_count")
          .put("invalidFailureCount", "_invalid-failure-count")
          .put("validFailureCount", "_valid-failure-count")
          .put("failureReasonCodeDescription", "_failure-reason-code-descriptions")
          .put("daysSinceLastAttempt", "_days-since-last-attempt")
          .put("priorityLevel", "_priority-level")
          .put("lastScannedHubName", "_last-scanned-hub-name")
          .put("String", "_order-tags")
          .build()
      );
      setActionButtonsLocators(ImmutableMap.of(ACTION_RESCHEDULE_NEXT_DAY,
          "container.failed-delivery-management.reschedule-next-day", ACTION_RTS,
          "commons.return-to-sender"));
      setEntityClass(FailedDelivery.class);
      setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
    }
  }

  public static class SetSelectedToReturnToSenderDialog extends MdDialog {

    @FindBy(css = "[id^='commons.reason']")
    public MdSelect reason;

    @FindBy(id = "commons.model.delivery-date")
    public MdDatepicker deliveryDate;

    @FindBy(css = "[id^='commons.timeslot']")
    public MdSelect timeslot;

    @FindBy(name = "container.order.edit.set-order-to-rts")
    public NvApiTextButton setOrderToRts;

    public SetSelectedToReturnToSenderDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
