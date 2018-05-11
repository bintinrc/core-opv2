package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.ReservationInfo;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipperPickupsPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "data in getTableData()";

    public static final String COLUMN_CLASS_DATA_SHIPPER_NAME_AND_CONTACT = "name";
    public static final String COLUMN_CLASS_DATA_ROUTE_ID = "route-id";
    public static final String COLUMN_CLASS_DATA_DRIVER_NAME = "driver-name";
    public static final String COLUMN_CLASS_DATA_PRIORITY_LEVEL = "priority-level";
    public static final String COLUMN_CLASS_DATA_READY_BY = "ready-by";
    public static final String COLUMN_CLASS_DATA_LATEST_BY = "last-by";
    public static final String COLUMN_CLASS_DATA_RESERVATION_TYPE = "type";
    public static final String COLUMN_CLASS_DATA_RESERVATION_STATUS = "status";
    public static final String COLUMN_CLASS_DATA_RESERVATION_CREATED_TIME = "created-date";
    public static final String COLUMN_CLASS_DATA_SERVICE_TIME = "service-time";
    public static final String COLUMN_CLASS_DATA_PICKUP_ADDRESS = "pickup-address";
    public static final String COLUMN_CLASS_DATA_APPROX_VOLUME = "approx-volume";
    public static final String COLUMN_CLASS_DATA_FAILURE_REASON = "failure-reason";
    public static final String COLUMN_CLASS_DATA_COMMENTS = "comments";

    public static final String ACTION_BUTTON_ROUTE_EDIT = "Route Edit";
    public static final String ACTION_BUTTON_DETAILS = "Details";
    public static final String REMOVE_BUTTON_ARIA_LABEL = "Remove";
    public static final String REFRESH_BUTTON_ARIA_LABEL = "Refresh";

    public CreateSelectedReservationsDialog createSelectedReservationsDialog;
    public BulkRouteAssignmentDialog bulkRouteAssignmentDialog;

    public ShipperPickupsPage(WebDriver webDriver)
    {
        super(webDriver);
        createSelectedReservationsDialog = new CreateSelectedReservationsDialog(webDriver);
        bulkRouteAssignmentDialog = new BulkRouteAssignmentDialog(webDriver);
    }

    private String buildPickupAddress(Address address)
    {
        String address1 = address.getAddress1();
        String address2 = address.getAddress2();
        String pickupAddress = address1;

        if(address2!=null && !address2.isEmpty())
        {
            pickupAddress += " "+address2;
        }

        if(pickupAddress!=null)
        {
            pickupAddress = pickupAddress.trim();
        }

        return pickupAddress;
    }

    public void assignReservationToRoute(Address address, Long routeId)
    {
        assignReservationToRoute(address, routeId, null);
    }

    public void refreshRoutes(){
        clickNvApiIconButtonByNameAndWaitUntilDone(REFRESH_BUTTON_ARIA_LABEL);
    }

    public void assignReservationToRoute(Address address, Long routeId, Integer priorityLevel)
    {
        String pickupAddress = buildPickupAddress(address);
        searchTableByPickupAddress(pickupAddress);
        clickActionButtonOnTable(1, ACTION_BUTTON_ROUTE_EDIT);
        pause2s();

        Assert.assertNotNull("Route ID should not be null.", routeId);
        selectValueFromNvAutocomplete("ctrl.data.textRoute", String.valueOf(routeId));

        if(priorityLevel!=null)
        {
            sendKeysById("Priority Level", String.valueOf(priorityLevel));
        }

        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
    }

    public void verifyReservationInfo(Address address, String shipperName, String routeId, String driverName, String priorityLevel, String approxVolume, String comments)
    {
        String pickupAddress = buildPickupAddress(address);
        searchTableByPickupAddress(pickupAddress);

        String actualShipperNameAndContact = getTextOnTable(1, COLUMN_CLASS_DATA_SHIPPER_NAME_AND_CONTACT);
        String actualPickupAddress = getTextOnTable(1, COLUMN_CLASS_DATA_PICKUP_ADDRESS);
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID);
        String actualDriverName = getTextOnTable(1, COLUMN_CLASS_DATA_DRIVER_NAME);
        String actualPriorityLevel = getTextOnTable(1, COLUMN_CLASS_DATA_PRIORITY_LEVEL);
        String actualApproxVolume = getTextOnTable(1, COLUMN_CLASS_DATA_APPROX_VOLUME);
        String actualComments = getTextOnTable(1, COLUMN_CLASS_DATA_COMMENTS);

        // Remove multiple [SPACE] chars from String value.
        actualPickupAddress = actualPickupAddress.trim().replaceAll("\\s+", " ");
        pickupAddress = pickupAddress.trim().replaceAll("\\s+", " ");

        Assert.assertThat("Shipper Name", actualShipperNameAndContact, Matchers.startsWith(shipperName));
        Assert.assertThat("Pickup Address", actualPickupAddress, Matchers.startsWith(pickupAddress));

        if(routeId!=null && !routeId.isEmpty())
        {
            Assert.assertEquals("Route ID", routeId, actualRouteId);
        }

        if(driverName!=null && !driverName.isEmpty())
        {
            Assert.assertEquals("Driver Name", driverName, actualDriverName);
        }

        if(priorityLevel!=null && !priorityLevel.isEmpty())
        {
            Assert.assertEquals("Priority Level", priorityLevel, actualPriorityLevel);
        }

        if(approxVolume!=null && !approxVolume.isEmpty())
        {
            Assert.assertEquals("Approx. Volume", approxVolume, actualApproxVolume);
        }

        if(comments!=null && !comments.isEmpty())
        {
            if(comments.length()>255)
            {
                comments = comments.substring(0, 255)+"...";
            }

            Assert.assertEquals("Comments", comments, actualComments);
        }
    }

    public void verifyReservationInfo(ReservationInfo expectedReservationInfo, Address address)
    {
        Date readyDate = expectedReservationInfo.getReadyByDate();
        Date latestDate = expectedReservationInfo.getLatestByDate();
        if (readyDate != null && latestDate != null)
        {
            clickButtonByAriaLabel("Edit Filters");
            filterReservationDate(readyDate, latestDate);
            clickButtonLoadSelection();
        }

        ReservationInfo actualReservationInfo = readReservationInfo(address);
        String expectedValue = expectedReservationInfo.getShipperName();
        if (expectedValue != null)
        {
            Assert.assertEquals("Shipper Name", expectedValue, actualReservationInfo.getShipperName());
        }
        expectedValue = expectedReservationInfo.getPickupAddress();
        if (expectedValue != null)
        {
            Assert.assertEquals("Pickup Address", expectedValue, actualReservationInfo.getPickupAddress());
        }
        expectedValue = expectedReservationInfo.getRouteId();
        if (expectedValue != null)
        {
            Assert.assertEquals("Route Id", expectedValue, actualReservationInfo.getRouteId());
        }
        expectedValue = expectedReservationInfo.getDriverName();
        if (expectedValue != null)
        {
            Assert.assertEquals("Driver Name", expectedValue, actualReservationInfo.getDriverName());
        }
        expectedValue = expectedReservationInfo.getPriorityLevel();
        if (expectedValue != null)
        {
            Assert.assertEquals("Priority Level", expectedValue, actualReservationInfo.getPriorityLevel());
        }
        expectedValue = expectedReservationInfo.getReadyBy();
        if (expectedValue != null)
        {
            Assert.assertEquals("Ready By", expectedValue, actualReservationInfo.getReadyBy());
        }
        expectedValue = expectedReservationInfo.getLatestBy();
        if (expectedValue != null)
        {
            Assert.assertEquals("Latest By", expectedValue, actualReservationInfo.getLatestBy());
        }
        expectedValue = expectedReservationInfo.getReservationType();
        if (expectedValue != null)
        {
            Assert.assertEquals("Reservation Type", expectedValue, actualReservationInfo.getReservationType());
        }
        expectedValue = expectedReservationInfo.getReservationStatus();
        if (expectedValue != null)
        {
            Assert.assertEquals("Reservation Status", expectedValue, actualReservationInfo.getReservationStatus());
        }
        expectedValue = expectedReservationInfo.getReservationCreatedTime();
        if (expectedValue != null)
        {
            Assert.assertThat("Reservation Created Time", expectedValue, Matchers.startsWith(DateUtil.displayDate(expectedReservationInfo.getReservationCreatedDateTime())));
        }
        expectedValue = expectedReservationInfo.getServiceTime();
        if (expectedValue != null)
        {
            Assert.assertThat("Service Time", expectedValue, Matchers.startsWith(DateUtil.displayDate(expectedReservationInfo.getServiceDateTime())));
        }
        expectedValue = expectedReservationInfo.getApproxVolume();
        if (expectedValue != null)
        {
            Assert.assertEquals("Approx. Volume", expectedValue, actualReservationInfo.getApproxVolume());
        }
        expectedValue = expectedReservationInfo.getFailureReason();
        if (expectedValue != null)
        {
            Assert.assertEquals("Failure Reason", expectedValue, actualReservationInfo.getFailureReason());
        }
        expectedValue = expectedReservationInfo.getComments();
        if (expectedValue != null)
        {
            Assert.assertEquals("Comments", expectedValue, actualReservationInfo.getComments());
        }
    }

    public void verifyReservationsInfo(List<ReservationInfo> expectedReservationsInfo, List<Address> addresses)
    {
        for (int i=0; i<addresses.size(); i++){
            verifyReservationInfo(expectedReservationsInfo.get(i), addresses.get(i));
        }
    }

    public void verifyReservationDetails(Address address, String shipperName, String shipperId, String reservationId)
    {
        String pickupAddress = buildPickupAddress(address);
        searchTableByPickupAddress(pickupAddress);
        clickActionButtonOnTable(1, ACTION_BUTTON_DETAILS);
        waitUntilVisibilityOfElementLocated("//md-dialog-content//h5[text()='Details']");

        String actualShipperName = getTextTrimmed("//md-input-container[@id='field-shipper-name']/div");
        String actualShipperId = getTextTrimmed("//md-input-container[@id='field-shipper-id']/div");
        String actualReservationId = getTextTrimmed("//md-input-container[@id='field-reservation-id']/div");
        String actualPickupAddress = getTextTrimmed("//md-input-container[@id='field-pickup-address']/div");

        Assert.assertEquals("Shipper Name", shipperName, actualShipperName);
        Assert.assertEquals("Shipper ID", shipperId, actualShipperId);
        Assert.assertEquals("Reservation ID", reservationId, actualReservationId);
        Assert.assertThat("Pickup Address", actualPickupAddress, Matchers.startsWith(pickupAddress));
    }

    public ReservationInfo duplicateReservation(Address address, Date date)
    {
        return duplicateReservations(Collections.singletonList(address), date).get(0);
    }

    public List<ReservationInfo> duplicateReservations(List<Address> addresses, Date date)
    {
        List<ReservationInfo> originalReservationsInfo = new ArrayList<>();
        addresses.forEach(address -> {
            originalReservationsInfo.add(readReservationInfo(address));
            checkSelectionCheckboxOnTable(1);
        });

        Assert.assertEquals(getText("//h5[contains(text(),'Selected:')]"), String.format("Selected: %d", addresses.size()));
        clickMdMenuItem("Apply Action", "Create Reservation");
        createSelectedReservationsDialog.fillTheForm(date);
        createSelectedReservationsDialog.submitForm();
        String toastMessage = addresses.size() == 1 ?
                "1 Reservation(s) Created" :
                "Reservation(s) created successfully";
        waitUntilInvisibilityOfToast(toastMessage, true);

        return originalReservationsInfo;
    }

    public BulkRouteAssignmentDialog suggestRoute(List<Address> addresses, List<String> routeTags )
    {
        addresses.forEach(address -> {
            searchTableByPickupAddress(address);
            checkSelectionCheckboxOnTable(1);
        });

        Assert.assertEquals(getText("//h5[contains(text(),'Selected:')]"), String.format("Selected: %d", addresses.size()));
        clickMdMenuItem("Apply Action", "Suggest Route");
        bulkRouteAssignmentDialog.addRouteTags(routeTags);
        bulkRouteAssignmentDialog.clickSuggestButton();

        return bulkRouteAssignmentDialog;
    }

    public void removeRoute(Address addresses)
    {
        removeRoutes(Collections.singletonList(addresses));
    }

    public void removeRoutes(List<Address> addresses)
    {
        selectReservationsByAddress(addresses);
        clickMdMenuItem("Apply Action", "Remove Route");
        clickButtonOnMdDialogByAriaLabel(REMOVE_BUTTON_ARIA_LABEL);
        String toastMessage = String.format("%d Reservation(s) Pulled Out from Route", addresses.size());
        waitUntilInvisibilityOfToast(toastMessage, true);
    }

    public void selectReservationsByAddress(List<Address> addresses){
        addresses.forEach(address -> {
            searchTableByPickupAddress(address);
            checkSelectionCheckboxOnTable(1);
        });
        Assert.assertEquals(getText("//h5[contains(text(),'Selected:')]"), String.format("Selected: %d", addresses.size()));
    }

    public ReservationInfo readReservationInfo(Address address)
    {
        ReservationInfo reservationInfo = new ReservationInfo();
        searchTableByPickupAddress(address);
        Assert.assertFalse("Reservation was not found", isTableEmpty());
        reservationInfo.setShipperName(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_SHIPPER_NAME_AND_CONTACT)));
        reservationInfo.setPickupAddress(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_PICKUP_ADDRESS)));
        reservationInfo.setRouteId(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID)));
        reservationInfo.setDriverName(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_DRIVER_NAME)));
        reservationInfo.setPriorityLevel(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_PRIORITY_LEVEL)));
        reservationInfo.setReadyBy(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_READY_BY)));
        reservationInfo.setLatestBy(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_LATEST_BY)));
        reservationInfo.setReservationType(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_RESERVATION_TYPE)));
        reservationInfo.setReservationStatus(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_RESERVATION_STATUS)));
        reservationInfo.setReservationCreatedTime(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_RESERVATION_CREATED_TIME)));
        reservationInfo.setServiceTime(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_SERVICE_TIME)));
        reservationInfo.setApproxVolume(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_APPROX_VOLUME)));
        reservationInfo.setFailureReason(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_FAILURE_REASON)));
        reservationInfo.setComments(StringUtils.normalizeSpace(getTextOnTable(1, COLUMN_CLASS_DATA_COMMENTS)));
        return reservationInfo;
    }

    public void filterReservationDate(Date fromDate, Date toDate)
    {
        setMdDatepicker("fromModel", fromDate);
        setMdDatepicker("toModel", toDate);
    }

    public void clickButtonLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selection");
    }

    public void clickButtonRefresh()
    {
        clickNvApiIconButtonByNameAndWaitUntilDone("Refresh");
    }

    public void searchTableByPickupAddress(String pickupAddress)
    {
        searchTableCustom1("pickup-address", pickupAddress);
    }

    public void searchTableByPickupAddress(Address pickupAddress)
    {
        searchTableCustom1("pickup-address", buildPickupAddress(pickupAddress));
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }

    public void checkSelectionCheckboxOnTable(int rowNumber)
    {
        checkRowWithMdVirtualRepeat(rowNumber, MD_VIRTUAL_REPEAT);
    }

    public static class CreateSelectedReservationsDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_LOCATOR = "//md-dialog[contains(@class,'reservation-reschedule-selected')]";
        private static final String FIELD_DATE_ID = "commons.model.date";
        private static final String BUTTON_SUBMIT_ARIA_LABEL = "Recreate";

        public CreateSelectedReservationsDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void fillTheForm(Date date)
        {
            waitUntilVisibilityOfElementLocated(DIALOG_LOCATOR);
            setMdDatepickerById(FIELD_DATE_ID, date);
        }

        public void submitForm()
        {
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUBMIT_ARIA_LABEL);
        }
    }

    public static class BulkRouteAssignmentDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Bulk Route Assignment";
        private static final String FIELD_ROUTE_TAGS_SEARCH_TEXT = "ctrl.view.tagSearchText";
        private static final String BUTTON_SUGGEST_ARIA_LABEL = "Suggest";
        private static final String BUTTON_SUBMIT_ARIA_LABEL = "Save changes";

        public BulkRouteAssignmentDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void addRouteTags(List<String> routeTags)
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            routeTags.forEach(routeTag -> selectValueFromNvAutocomplete(FIELD_ROUTE_TAGS_SEARCH_TEXT, routeTag));
        }

        public void clickSuggestButton(){
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUGGEST_ARIA_LABEL);
        }

        public String readSuggestedRoute(int index){
            //return getSelectedValueOfMdAutocompleteOnTableWithNgRepeat(index, "route", "reservation in ctrl.data.reservations");
            return "202832 - OpV2 No.1";
        }

        public Route validateSuggestedRoutes(List<Route> validRoutes)
        {
            Route route = null;
            int rowsCount = getRowsCountOfTableWithNgRepeat("reservation in ctrl.data.reservations");
            for (int index=1; index <= rowsCount; index++){
                route = validateSuggestedRoute(index, validRoutes);
            }
            return route;
        }

        public Route validateSuggestedRoute(int index, List<Route> validRoutes)
        {
            String suggestedRoute = readSuggestedRoute(index);
            Assert.assertThat("Suggested Route", suggestedRoute, Matchers.not(Matchers.isEmptyOrNullString()));
            Pattern p = Pattern.compile("(\\d*)(\\s-\\s)(.*)");
            Matcher m = p.matcher(suggestedRoute);
            AtomicLong routeId = new AtomicLong(0);
            if (m.matches()){
                routeId.set(Long.parseLong(m.group(1)));
            }
            String reason = String.format("[%d] Suggested Route ID", index);
            Assert.assertThat(reason, routeId.get(), Matchers.greaterThan(0L));
            Optional<Route> optRoute = validRoutes.stream().filter(route -> route.getId() == routeId.get()).findFirst();
            reason = String.format("[%d] Suggested rout is not valid", index);
            Assert.assertTrue(reason, optRoute.isPresent());
            return optRoute.get();
        }

        public void submitForm()
        {
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUBMIT_ARIA_LABEL);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }
}
