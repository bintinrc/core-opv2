package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.operator_v2.model.FailedDelivery;
import co.nvqa.operator_v2.model.RtsDetails;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
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
public class FailedDeliveryManagementPage extends OperatorV2SimplePage {

  @FindBy(css = "md-dialog")
  public EditRtsDetailsDialog editRtsDetailsDialog;

  @FindBy(css = "md-dialog")
  public SetSelectedToReturnToSenderDialog setSelectedToReturnToSenderDialog;

  @FindBy(css = "md-dialog")
  public RescheduleSelectedOrdersDialog rescheduleSelectedOrdersDialog;

  @FindBy(css = "div.navigation md-menu")
  public MdMenu actionsMenu;

  public final FailedDeliveriesTable failedDeliveriesTable;

  private static final String CSV_FILENAME_PATTERN = "failed-delivery-list";

  public FailedDeliveryManagementPage(WebDriver webDriver) {
    super(webDriver);
    failedDeliveriesTable = new FailedDeliveriesTable(webDriver);
  }

  public void downloadCsvFile(String trackingId) {
    failedDeliveriesTable
        .filterByColumn(CommonParcelManagementPage.FailedDeliveriesTable.COLUMN_TRACKING_ID,
            trackingId);
    failedDeliveriesTable.selectRow(1);
    actionsMenu.selectOption("Download CSV File");
  }

  public void rescheduleNext2Days(String trackingId) {
    rescheduleNext2Days(Collections.singletonList(trackingId));
  }

  public void rescheduleNext2Days(List<String> trackingIds) {
    trackingIds.forEach(trackingId ->
    {
      failedDeliveriesTable
          .filterByColumn(CommonParcelManagementPage.FailedDeliveriesTable.COLUMN_TRACKING_ID,
              trackingId);
      failedDeliveriesTable.selectRow(1);
    });

    actionsMenu.selectOption("Reschedule Selected");
    rescheduleSelectedOrdersDialog.waitUntilVisible();
    rescheduleSelectedOrdersDialog.date.setDate(TestUtils.getNextDate(2));
    rescheduleSelectedOrdersDialog.reschedule.click();
    waitUntilInvisibilityOfToast("Order Rescheduling Success");
  }

  public EditRtsDetailsDialog openEditRtsDetailsDialog(String trackingId) {
    failedDeliveriesTable
        .filterByColumn(CommonParcelManagementPage.FailedDeliveriesTable.COLUMN_TRACKING_ID,
            trackingId);
    failedDeliveriesTable
        .clickActionButton(1, CommonParcelManagementPage.FailedDeliveriesTable.ACTION_RTS);
    editRtsDetailsDialog.waitUntilVisible();
    return editRtsDetailsDialog;
  }

  public void rtsSingleOrderNextDay(String trackingId) {
    failedDeliveriesTable
        .filterByColumn(CommonParcelManagementPage.FailedDeliveriesTable.COLUMN_TRACKING_ID,
            trackingId);
    failedDeliveriesTable
        .clickActionButton(1, CommonParcelManagementPage.FailedDeliveriesTable.ACTION_RTS);
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
    failedDeliveriesTable
        .filterByColumn(CommonParcelManagementPage.FailedDeliveriesTable.COLUMN_TRACKING_ID,
            trackingId);
    failedDeliveriesTable.selectRow(1);
    actionsMenu.selectOption("Set RTS to Selected");
    setSelectedToReturnToSenderDialog.waitUntilVisible();
    setSelectedToReturnToSenderDialog.deliveryDate.setDate(TestUtils.getNextDate(1));
    setSelectedToReturnToSenderDialog.timeslot.selectValue("3PM - 6PM");
    setSelectedToReturnToSenderDialog.setOrderToRts.clickAndWaitUntilDone();
    setSelectedToReturnToSenderDialog.waitUntilInvisible();
    waitUntilInvisibilityOfToast("Set Selected to Return to Sender");
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

    @FindBy(css = "[name*='-to-rts']")
    public NvApiTextButton setOrderToRts;

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

  public static class RescheduleSelectedOrdersDialog extends MdDialog {

    @FindBy(name = "commons.model.date")
    public MdDatepicker date;

    @FindBy(name = "commons.reschedule")
    public NvIconTextButton reschedule;

    public RescheduleSelectedOrdersDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public void verifyFailedDeliveryOrderIsListed(Order order, FailureReason expectedFailureReason) {
    String trackingId = order.getTrackingId();
    String orderType = order.getType();

    waitWhilePageIsLoading();
    failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
    FailedDelivery actual = failedDeliveriesTable.readEntity(1);

    assertEquals("Tracking ID", trackingId, actual.getTrackingId());
    assertEquals("Order Type", orderType, actual.getType());
    assertEquals("Failure Comments", expectedFailureReason.getDescription(),
        actual.getFailureReasonComments());
    assertEquals("Failure Reason", expectedFailureReason.getFailureReasonCodeDescription(),
        actual.getFailureReasonCodeDescription());
  }

  public void verifyFailedDeliveryOrderIsTagged(Order order, List<String> orderTags) {
    String trackingId = order.getTrackingId();

    waitWhilePageIsLoading();
    failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
    FailedDelivery actual = failedDeliveriesTable.readEntity(1);

    assertEquals("Tracking ID", trackingId, actual.getTrackingId());
    assertEquals("Tags", orderTags, actual.getOrderTags());
  }

  public void verifyCsvFileDownloadedSuccessfully(String trackingId) {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN), trackingId);
  }

  public void rescheduleNextDay(String trackingId) {
    failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
    failedDeliveriesTable.clickActionButton(1, FailedDeliveriesTable.ACTION_RESCHEDULE_NEXT_DAY);
  }

  public void verifyOrderIsRemovedFromTableAfterReschedule(String trackingId) {
    refreshPage();
    waitWhilePageIsLoading();
    failedDeliveriesTable.filterByColumn(FailedDeliveriesTable.COLUMN_TRACKING_ID, trackingId);
    assertTrue(f("Tracking ID '%s' is still listed on failed order list.", trackingId),
        failedDeliveriesTable.isEmpty());
  }
}