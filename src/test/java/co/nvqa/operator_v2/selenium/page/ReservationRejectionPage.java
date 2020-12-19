package co.nvqa.operator_v2.selenium.page;

import static co.nvqa.operator_v2.selenium.page.ReservationRejectionPage.ReservationRejectionEntityTable.COLUMN_PICKUP_INFO;
import static co.nvqa.operator_v2.selenium.page.ReservationRejectionPage.ReservationRejectionEntityTable.COLUMN_REASON_FOR_REJECTION;

import co.nvqa.commons.model.driver.RejectReservationRequest;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.ReservationRejectionEntity;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import com.google.common.collect.ImmutableMap;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Kateryna Skakunova
 */
public class ReservationRejectionPage extends OperatorV2SimplePage {

  private static final String FAIL_PICKUP_TOAST_MESSAGE_SUCCESSFULLY = "Pick up has been failed";

  private static final String REASSIGN_RESERVATION_MD_DIALOG_TITLE = "Reassign Reservation";
  private static final String REASSIGN_RESERVATION_MD_DIALOG_BUTTON_ARIA_LABEL = "Reassign";
  private static final String REASSIGN_RESERVATION_TOAST_MESSAGE_SUCCESSFULLY = "Reassigned Successfully";

  private ReservationRejectionEntityTable reservationRejectionEntityTable;

  @FindBy(css = "md-dialog.reservation-rejection-form")
  public RejectReservationDialog rejectReservationDialog;

  public ReservationRejectionPage(WebDriver webDriver) {
    super(webDriver);
    reservationRejectionEntityTable = new ReservationRejectionEntityTable(webDriver);
  }

  /**
   * Accessor for Reservation Rejection table
   */
  public static class ReservationRejectionEntityTable extends
      MdVirtualRepeatTable<ReservationRejectionEntity> {

    public static final String MD_VIRTUAL_REPEAT = "rejectedReservation in getTableData()";

    static final String COLUMN_TIME_REJECTED = "timeRejected";
    static final String COLUMN_PICKUP_INFO = "pickupInfo";
    static final String COLUMN_PRIORITY_LEVEL = "priorityLevel";
    static final String COLUMN_TIMESLOT = "timeslot";
    static final String COLUMN_REASON_FOR_REJECTION = "reasonForRejection";
    static final String COLUMN_DRIVER_INFO = "driverInfo";
    static final String COLUMN_ROUTE = "route";
    static final String COLUMN_HUB = "hub";

    private ReservationRejectionEntityTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_TIME_REJECTED, "c_time-rejected")
          .put(COLUMN_PICKUP_INFO, "c_pickup")
          .put(COLUMN_PRIORITY_LEVEL, "priority_level")
          .put(COLUMN_TIMESLOT, "c_timeslot")
          .put(COLUMN_REASON_FOR_REJECTION, "rejection_reason")
          .put(COLUMN_DRIVER_INFO, "c_driver")
          .put(COLUMN_ROUTE, "route_id")
          .put(COLUMN_HUB, "c_hub-name")
          .build()
      );
      setActionButtonsLocators(
          ImmutableMap.of("failPickup", "//button[@aria-label='Fail Pickup']"));
      setActionButtonsLocators(
          ImmutableMap.of("reassignReservation", "//button[@aria-label='Reassign Reservation']"));
      setEntityClass(ReservationRejectionEntity.class);
      setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
    }
  }

  public ReservationRejectionEntity filterTableByReasonForRejection(String rejectionReason) {
    return reservationRejectionEntityTable
        .filterByColumn(COLUMN_REASON_FOR_REJECTION, rejectionReason).readEntity(1);
  }

  public ReservationRejectionEntity filterTableByPickup(String address) {
    return reservationRejectionEntityTable.filterByColumn(COLUMN_PICKUP_INFO, address)
        .readEntity(1);
  }

  public void clickActionFailPickupForRow(int rowNumber) {
    reservationRejectionEntityTable.clickActionButton(rowNumber, "failPickup");
  }

  public void failPickUpInPopup() {
    rejectReservationDialog.selectFailureReason();
  }

  public void clickActionReassignReservationForRow(int rowNumber) {
    reservationRejectionEntityTable.clickActionButton(rowNumber, "reassignReservation");
  }

  public void reassignReservationInPopup(String routeForReassigning) {
    waitUntilVisibilityOfMdDialogByTitle(REASSIGN_RESERVATION_MD_DIALOG_TITLE);
    selectValueFromMdAutocomplete("Search or Select...", routeForReassigning);
    clickButtonOnMdDialogByAriaLabel(REASSIGN_RESERVATION_MD_DIALOG_BUTTON_ARIA_LABEL);
    waitUntilInvisibilityOfMdDialogByTitle(REASSIGN_RESERVATION_MD_DIALOG_TITLE);
  }

  public void validateReservationInTable(String pickupInfo,
      RejectReservationRequest rejectReservationRequest,
      ReservationRejectionEntity reservationRejectionEntity) {
    ZonedDateTime timeRejectionExpected = DateUtil
        .getDate(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));

    assertThat("Time Rejection is not as expected in Reservation Rejection",
        reservationRejectionEntity.getTimeRejected(),
        containsString(DateUtil.displayDate(timeRejectionExpected)));
    assertThat("Pickup info is not as expected in Reservation Rejection",
        reservationRejectionEntity.getPickupInfo(), containsString(pickupInfo));
    assertEquals("Rejection Reason is not as expected in Reservation Rejection",
        rejectReservationRequest.getRejectionReason(),
        reservationRejectionEntity.getReasonForRejection());
    assertEquals("Route Id is not as expected in Reservation Rejection",
        String.valueOf(rejectReservationRequest.getRouteId()),
        reservationRejectionEntity.getRoute());
  }

  public void verifyRecordIsNotPresentInTableByPickup(String pickup) {
    reservationRejectionEntityTable.filterByColumn(COLUMN_PICKUP_INFO, pickup);
    assertTrue(reservationRejectionEntityTable.isTableEmpty());
  }

  public void verifyToastAboutFailedPickupIsPresent() {
    waitUntilVisibilityOfToast(FAIL_PICKUP_TOAST_MESSAGE_SUCCESSFULLY);
  }

  public void verifyToastAboutReassignReservationIsPresent() {
    waitUntilVisibilityOfToast(REASSIGN_RESERVATION_TOAST_MESSAGE_SUCCESSFULLY);
  }

  public static class RejectReservationDialog extends MdDialog {

    public RejectReservationDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[id^='container.reservation-rejection.reason-for-failure']")
    public MdSelect reasonForFailure;

    @FindBy(css = "[id^='container.reservation-rejection.failure-detail']")
    public List<MdSelect> failureReasonDetail;

    @FindBy(name = "Fail Pickup")
    public NvApiTextButton failPickupButton;

    public void selectFailureReason() {
      waitUntilVisible();

      List<String> failureReasons = reasonForFailure.getOptions();
      int randomFailureReasonIndex = (int) (Math.random() * 7);
      reasonForFailure.selectValue(failureReasons.get(randomFailureReasonIndex));

      int detailsCount;
      do {
        detailsCount = failureReasonDetail.size();
        selectFailureReasonDetail(detailsCount - 1);
      } while (failureReasonDetail.size() > detailsCount);

      failPickupButton.clickAndWaitUntilDone();
      waitUntilInvisible();
    }

    public void selectFailureReasonDetail(int index) {
      List<String> failureReasonDetailsSecond = failureReasonDetail.get(index).getOptions();
      int randomFailureReasonDetailsIndexSecond = (int) (Math.random() * failureReasonDetailsSecond
          .size());
      failureReasonDetail.get(index)
          .selectValue(failureReasonDetailsSecond.get(randomFailureReasonDetailsIndexSecond));
    }

  }
}