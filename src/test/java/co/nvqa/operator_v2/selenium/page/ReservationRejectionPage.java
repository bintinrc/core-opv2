package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.driver.RejectReservationRequest;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.ReservationRejectionEntity;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;

import java.time.ZoneId;
import java.time.ZonedDateTime;

import static co.nvqa.operator_v2.selenium.page.ReservationRejectionPage.ReservationRejectionEntityTable.COLUMN_PICKUP_INFO;
import static co.nvqa.operator_v2.selenium.page.ReservationRejectionPage.ReservationRejectionEntityTable.COLUMN_REASON_FOR_REJECTION;

/**
 * @author Kateryna Skakunova
 */
public class ReservationRejectionPage extends OperatorV2SimplePage
{
    private static final String FAIL_PICKUP_MD_DIALOG_TITLE = "Fail Pickup";
    private static final String FAIL_PICKUP_MD_DIALOG_BUTTON_ARIA_LABEL = "Fail Pickup";
    private static final String FAIL_PICKUP_MD_DIALOG_REASON_FOR_FAILURE = "Testing the app - Hyperlocal";
    private static final String FAIL_PICKUP_TOAST_MESSAGE = "Pick up has been failed";

    private ReservationRejectionEntityTable reservationRejectionEntityTable;

    public ReservationRejectionPage(WebDriver webDriver)
    {
        super(webDriver);
        reservationRejectionEntityTable = new ReservationRejectionEntityTable(webDriver);
    }

    /**
     * Accessor for Reservation Rejection table
     */
    public static class ReservationRejectionEntityTable extends MdVirtualRepeatTable<ReservationRejectionEntity>
    {
        public static final String MD_VIRTUAL_REPEAT = "rejectedReservation in getTableData()";

        static final String COLUMN_TIME_REJECTED = "timeRejected";
        static final String COLUMN_PICKUP_INFO = "pickupInfo";
        static final String COLUMN_PRIORITY_LEVEL = "priorityLevel";
        static final String COLUMN_TIMESLOT = "timeslot";
        static final String COLUMN_REASON_FOR_REJECTION = "reasonForRejection";
        static final String COLUMN_DRIVER_INFO = "driverInfo";
        static final String COLUMN_ROUTE = "route";
        static final String COLUMN_HUB = "hub";

        private ReservationRejectionEntityTable(WebDriver webDriver)
        {
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
            setActionButtonsLocators(ImmutableMap.of("failPickup", "//button[@aria-label='Fail Pickup']"));
            setEntityClass(ReservationRejectionEntity.class);
            setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
        }
    }

    public ReservationRejectionEntity filterTableByReasonForRejection(String rejectionReason)
    {
        return reservationRejectionEntityTable.filterByColumn(COLUMN_REASON_FOR_REJECTION, rejectionReason).readEntity(1);
    }

    public ReservationRejectionEntity filterTableByPickup(String address)
    {
        return reservationRejectionEntityTable.filterByColumn(COLUMN_PICKUP_INFO, address).readEntity(1);
    }

    public void clickActionFailPickupForRow(int rowNumber)
    {
        reservationRejectionEntityTable.clickActionButton(rowNumber, "failPickup");
    }

    public void failPickUpInPopup()
    {
        waitUntilVisibilityOfMdDialogByTitle(FAIL_PICKUP_MD_DIALOG_TITLE);
        selectValueFromMdSelect("model", FAIL_PICKUP_MD_DIALOG_REASON_FOR_FAILURE);
        clickButtonOnMdDialogByAriaLabel(FAIL_PICKUP_MD_DIALOG_BUTTON_ARIA_LABEL);
        waitUntilInvisibilityOfMdDialogByTitle(FAIL_PICKUP_MD_DIALOG_TITLE);
    }

    public void validateReservationInTable(String pickupInfo, RejectReservationRequest rejectReservationRequest, ReservationRejectionEntity reservationRejectionEntity)
    {
        ZonedDateTime timeRejectionExpected = DateUtil.getDate(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));

        assertThat("Time Rejection is not as expected in Reservation Rejection",
                reservationRejectionEntity.getTimeRejected(),
                containsString(DateUtil.displayDate(timeRejectionExpected)));
        assertThat("Pickup info is not as expected in Reservation Rejection",
                reservationRejectionEntity.getPickupInfo(), containsString(pickupInfo));
        assertEquals("Rejection Reason is not as expected in Reservation Rejection",
                rejectReservationRequest.getRejectionReason(), reservationRejectionEntity.getReasonForRejection());
        assertEquals("Route Id is not as expected in Reservation Rejection",
                String.valueOf(rejectReservationRequest.getRouteId()), reservationRejectionEntity.getRoute());
    }

    public void verifyRecordIsNotPresentInTableByPickup(String pickup)
    {
        reservationRejectionEntityTable.filterByColumn(COLUMN_PICKUP_INFO, pickup);
        assertTrue(reservationRejectionEntityTable.isTableEmpty());
    }

    public void verifyToastAboutFailedPickupIsPresent()
    {
        waitUntilVisibilityOfToast(FAIL_PICKUP_TOAST_MESSAGE);
    }
}
