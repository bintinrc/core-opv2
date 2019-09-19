package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.operator_v2.model.ReservationInfo;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.Color;

import java.util.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static co.nvqa.operator_v2.selenium.page.ShipperPickupsPage.ReservationsTable.*;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipperPickupsPage extends OperatorV2SimplePage
{
    public static final String REMOVE_BUTTON_ARIA_LABEL = "Remove";
    public static final String REFRESH_BUTTON_ARIA_LABEL = "Refresh";
    public static final String EDIT_FILTERS_BUTTON_ARIA_LABEL = "Edit Filters";

    private static final String CSV_FILENAME = "shipper-pickups.csv";
    private static final String SELECTED_COUNT_LABEL_LOCATOR = "//h5[contains(text(),'Selected:')]";

    private CreateSelectedReservationsDialog createSelectedReservationsDialog;
    private BulkRouteAssignmentDialog bulkRouteAssignmentDialog;
    private BulkPriorityEditDialog bulkPriorityEditDialog;
    private ApplyActionsMenu applyActionsMenu;
    private ReservationsTable reservationsTable;
    private FiltersForm filtersForm;
    private ReservationDetailsDialog reservationDetailsDialog;
    private EditRouteDialog editRouteDialog;
    private FinishReservationDialog finishReservationDialog;

    public ShipperPickupsPage(WebDriver webDriver)
    {
        super(webDriver);
        createSelectedReservationsDialog = new CreateSelectedReservationsDialog(webDriver);
        bulkRouteAssignmentDialog = new BulkRouteAssignmentDialog(webDriver);
        bulkPriorityEditDialog = new BulkPriorityEditDialog(webDriver);
        applyActionsMenu = new ApplyActionsMenu(webDriver);
        reservationsTable = new ReservationsTable(webDriver);
        filtersForm = new FiltersForm(webDriver);
        reservationDetailsDialog = new ReservationDetailsDialog(webDriver);
        editRouteDialog = new EditRouteDialog(webDriver);
        finishReservationDialog = new FinishReservationDialog(webDriver);
    }

    public BulkRouteAssignmentDialog bulkRouteAssignmentDialog()
    {
        return bulkRouteAssignmentDialog;
    }

    public FiltersForm filtersForm()
    {
        return filtersForm;
    }

    private static String buildPickupAddress(Address address)
    {
        return StringUtils.trim(address.getAddress1());
    }

    public void assignReservationToRoute(Address address, Long routeId)
    {
        assignReservationToRoute(address, routeId, null);
    }

    public void assignReservationToRoute(Address address, Long routeId, Integer priorityLevel)
    {
        reservationsTable.searchByPickupAddress(address);
        reservationsTable.clickActionButton(1, ACTION_BUTTON_ROUTE_EDIT);
        editRouteDialog.fillTheForm(routeId, priorityLevel);
        editRouteDialog.submitForm();
    }

    public void verifyReservationInfo(Address address, String shipperName, String routeId, String driverName, String priorityLevel, String approxVolume, String comments)
    {
        /*
          Reload the table to make sure the table info is updated.
         */
        openFiltersForm();
        filtersForm.clickButtonLoadSelection();

        String pickupAddress = reservationsTable.searchByPickupAddress(address);
        String actualPickupAddress = reservationsTable.getPickupAddress(1);

        if(comments!=null && comments.length()>255)
        {
            comments = comments.substring(0, 255) + "...";
        }

        // Remove multiple [SPACE] chars from String value.
        actualPickupAddress = StringUtils.normalizeSpace(actualPickupAddress).trim();
        pickupAddress = StringUtils.normalizeSpace(pickupAddress).trim();
        assertThat("Pickup Address", actualPickupAddress, startsWith(pickupAddress));

        assertThatIfExpectedValueNotBlank("Shipper Name", shipperName, reservationsTable.getShipperNameAndContact(1), startsWith(shipperName));
        assertEqualsIfExpectedValueNotBlank("Route ID", routeId, reservationsTable.getRouteId(1));
        assertEqualsIfExpectedValueNotBlank("Driver Name", driverName, reservationsTable.getDriverName(1));
        assertEqualsIfExpectedValueNotBlank("Priority Level", priorityLevel, reservationsTable.getPriorityLevel(1));
        assertEqualsIfExpectedValueNotBlank("Approx. Volume", approxVolume, reservationsTable.getApproxVolume(1));
        assertEqualsIfExpectedValueNotBlank("Comments", comments, reservationsTable.getComments(1));
    }

    public void openFiltersForm()
    {
        clickButtonByAriaLabel(EDIT_FILTERS_BUTTON_ARIA_LABEL);
    }

    public void verifyReservationInfo(ReservationInfo expectedReservationInfo, Address address)
    {
        Date readyDate = expectedReservationInfo.getReadyByDate();
        Date latestDate = expectedReservationInfo.getLatestByDate();

        if(readyDate!=null && latestDate!=null)
        {
            openFiltersForm();
            filtersForm.filterReservationDate(readyDate, latestDate);
            filtersForm.clickButtonLoadSelection();
        }

        ReservationInfo actualReservationInfo = readReservationInfo(address);
        assertEqualsIfExpectedValueNotNull("Shipper Name", expectedReservationInfo.getShipperName(), actualReservationInfo.getShipperName());
        assertEqualsIfExpectedValueNotNull("Pickup Address", expectedReservationInfo.getPickupAddress(), actualReservationInfo.getPickupAddress());
        assertEqualsIfExpectedValueNotNull("Route Id", expectedReservationInfo.getRouteId(), actualReservationInfo.getRouteId());
        assertEqualsIfExpectedValueNotNull("Driver Name", expectedReservationInfo.getDriverName(), actualReservationInfo.getDriverName());
        assertEqualsIfExpectedValueNotNull("Priority Level", expectedReservationInfo.getPriorityLevel(), actualReservationInfo.getPriorityLevel());
        assertEqualsIfExpectedValueNotNull("Ready By", expectedReservationInfo.getReadyBy(), actualReservationInfo.getReadyBy());
        assertEqualsIfExpectedValueNotNull("Latest By", expectedReservationInfo.getLatestBy(), actualReservationInfo.getLatestBy());
        assertEqualsIfExpectedValueNotNull("Reservation Type", expectedReservationInfo.getReservationType(), actualReservationInfo.getReservationType());
        assertEqualsIfExpectedValueNotNull("Reservation Status", expectedReservationInfo.getReservationStatus(), actualReservationInfo.getReservationStatus());
        assertDateIsEqualIfExpectedValueNotNullOrBlank("Reservation Created Time", expectedReservationInfo.getReservationCreatedTime(), actualReservationInfo.getReservationCreatedTime());
        assertDateIsEqualIfExpectedValueNotNullOrBlank("Service Time", expectedReservationInfo.getServiceTime(), actualReservationInfo.getServiceTime());
        assertEqualsIfExpectedValueNotNull("Approx. Volume", expectedReservationInfo.getApproxVolume(), actualReservationInfo.getApproxVolume());
        assertEqualsIfExpectedValueNotNull("Failure Reason", expectedReservationInfo.getFailureReason(), actualReservationInfo.getFailureReason());
        assertEqualsIfExpectedValueNotNull("Comments", expectedReservationInfo.getComments(), actualReservationInfo.getComments());
    }

    private void assertDateIsEqualIfExpectedValueNotNullOrBlank(String message, String expected, String actual)
    {
        if(StringUtils.isNotBlank(expected))
        {
            if(actual==null)
            {
                actual = "";
            }

            actual = actual.split(" ")[0];
            expected = expected.split(" ")[0];
            assertEquals(message, expected, actual);
        }
    }

    public void verifyReservationsInfo(List<ReservationInfo> expectedReservationsInfo, List<Address> addresses)
    {
        for (int i=0; i<addresses.size(); i++)
        {
            verifyReservationInfo(expectedReservationsInfo.get(i), addresses.get(i));
        }
    }

    public void verifyReservationDetails(Address address, String shipperName, String shipperId, String reservationId)
    {
        String pickupAddress = reservationsTable.searchByPickupAddress(address);
        reservationsTable.clickActionButton(1, ACTION_BUTTON_DETAILS);
        reservationDetailsDialog.waitUntilDialogDisplayed();

        assertEquals("Shipper Name", shipperName, reservationDetailsDialog.getShipperName());
        assertEquals("Shipper ID", shipperId, reservationDetailsDialog.getShipperId());
        assertEquals("Reservation ID", reservationId, reservationDetailsDialog.getReservationId());
        assertThat("Pickup Address", reservationDetailsDialog.getPickupAddress(), startsWith(pickupAddress));
    }

    @SuppressWarnings("unused")
    public ReservationInfo duplicateReservation(Address address, Date date)
    {
        return duplicateReservations(Collections.singletonList(address), date).get(0);
    }

    public ReservationInfo downloadCsvFile(Address address)
    {
        return downloadCsvFiles(Collections.singletonList(address)).get(0);
    }

    public List<ReservationInfo> downloadCsvFiles(List<Address> addresses)
    {
        List<ReservationInfo> reservationsInfo = selectReservationsAndStoreInfo(addresses);
        applyActionsMenu.chooseDownloadCsvFile();
        return reservationsInfo;
    }

    public void verifyCsvFileDownloadedSuccessfully(ReservationInfo reservationInfo)
    {
        verifyFileDownloadedSuccessfully(CSV_FILENAME, reservationInfo.toCsvLine(), false, true);
    }

    public List<ReservationInfo> duplicateReservations(List<Address> addresses, Date date)
    {
        List<ReservationInfo> originalReservationsInfo = selectReservationsAndStoreInfo(addresses);
        applyActionsMenu.chooseCreateReservation();
        createSelectedReservationsDialog.fillTheForm(date);
        createSelectedReservationsDialog.submitForm();
        String toastMessage = addresses.size() == 1 ?
                "1 Reservation(s) Created" :
                "Reservation(s) created successfully";
        waitUntilInvisibilityOfToast(toastMessage, true);
        //clickNvIconButtonByName("Cancel");
        waitUntilInvisibilityOfMdDialog();

        return originalReservationsInfo;
    }

    public void editPriorityLevel(Address address, int priorityLevel)
    {
        editPriorityLevel(Collections.singletonList(address), priorityLevel, false);
    }

    public void editPriorityLevel(List<Address> addresses, int priorityLevel, boolean setToAll)
    {
        selectReservationsByAddress(addresses);
        applyActionsMenu.chooseEditPriorityLevel();
        bulkPriorityEditDialog.fillTheForm(priorityLevel, setToAll);
        bulkPriorityEditDialog.submitForm();
    }

    public BulkRouteAssignmentDialog suggestRoute(List<Address> addresses, List<String> routeTags)
    {
        selectReservationsByAddress(addresses);
        applyActionsMenu.chooseSuggestRoute();
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
        applyActionsMenu.chooseRemoveRoute();
        clickButtonOnMdDialogByAriaLabel(REMOVE_BUTTON_ARIA_LABEL);
        String toastMessage = String.format("%d Reservation(s) Pulled Out from Route", addresses.size());
        waitUntilInvisibilityOfToast(toastMessage);
    }

    public void selectReservationsByAddress(List<Address> addresses)
    {
        addresses.forEach(address ->
        {
            reservationsTable.searchByPickupAddress(address);
            reservationsTable.checkSelectionCheckbox(1);
        });
        verifySelectedCount(addresses.size());
    }

    public List<ReservationInfo> selectReservationsAndStoreInfo(List<Address> addresses)
    {
        List<ReservationInfo> reservationsInfo = new ArrayList<>();
        addresses.forEach(address ->
        {
            reservationsInfo.add(readReservationInfo(address));
            reservationsTable.checkSelectionCheckbox(1);
        });
        verifySelectedCount(addresses.size());
        return reservationsInfo;
    }

    public void verifySelectedCount(int count)
    {
        assertEquals(getText(SELECTED_COUNT_LABEL_LOCATOR), String.format("Selected: %d", count));
    }

    public ReservationInfo readReservationInfo(Address address)
    {
        ReservationInfo reservationInfo = new ReservationInfo();
        reservationsTable.searchByPickupAddress(address);
        assertFalse("Reservation was not found", isTableEmpty());
        reservationInfo.setShipperName(reservationsTable.getShipperNameAndContact(1));
        reservationInfo.setPickupAddress(reservationsTable.getPickupAddress(1));
        reservationInfo.setRouteId(reservationsTable.getRouteId(1));
        reservationInfo.setDriverName(reservationsTable.getDriverName(1));
        reservationInfo.setPriorityLevel(reservationsTable.getPriorityLevel(1));
        reservationInfo.setReadyBy(reservationsTable.getReadyBy(1));
        reservationInfo.setLatestBy(reservationsTable.getLatestBy(1));
        reservationInfo.setReservationType(reservationsTable.getReservationType(1));
        reservationInfo.setReservationStatus(reservationsTable.getReservationStatus(1));
        reservationInfo.setReservationCreatedTime(reservationsTable.getReservationCreatedTime(1));
        reservationInfo.setServiceTime(reservationsTable.getServiceTime(1));
        reservationInfo.setApproxVolume(reservationsTable.getApproxVolume(1));
        reservationInfo.setFailureReason(reservationsTable.getFailureReason(1));
        reservationInfo.setComments(reservationsTable.getComments(1));
        return reservationInfo;
    }

    public void clickButtonRefresh()
    {
        clickNvApiIconButtonByNameAndWaitUntilDone(REFRESH_BUTTON_ARIA_LABEL);
    }

    public void finishReservationWithFailure(){
        reservationsTable.clickActionButton(1, ACTION_BUTTON_FINISH);
        finishReservationDialog.selectFailureAsReason();

        List<String> failureReasons = finishReservationDialog.getFailureReasonsList();
        int randomFailureReasonIndex = (int)(Math.random() * 7);
        finishReservationDialog.selectFailureReason(failureReasons.get(randomFailureReasonIndex));

        while (finishReservationDialog.isFailureReasonDetailExist()){
            finishReservationDialog.selectFailureReasonDetail();
        }

        finishReservationDialog.clickOnUpdateButton();
        finishReservationDialog.proceedWithFailureInConfirmationPopUp();
    }

    public void finishReservationWithSuccess(){
        reservationsTable.clickActionButton(1, ACTION_BUTTON_FINISH);
        finishReservationDialog.selectSuccessAsReason();
        finishReservationDialog.proceedWithSuccessInConfirmationPopUp();
    }

    public void verifyFinishedReservationHighlighted(String color){
        assertEquals("Expected another background color for finished reservation with failure",
                color,
                reservationsTable.getNotDefaultBackgroundColorOfRow(1));
    }

    public void verifyFinishedReservationHasStatus(String status){
        assertEquals("Expected another reservation status for finished reservation with failure",
                status,
                reservationsTable.getReservationStatus(1));
    }

    /**
     * Accessor for Reservation Details dialog
     */
    public static class ReservationDetailsDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Reservation Details";
        private static final String FIELD_SHIPPER_NAME_LOCATOR = "//md-input-container[@id='field-shipper-name']/div";
        private static final String FIELD_SHIPPER_ID_LOCATOR = "//md-input-container[@id='field-shipper-id']/div";
        private static final String FIELD_RESERVATION_ID_LOCATOR = "//md-input-container[@id='field-reservation-id']/div";
        private static final String FIELD_PICKUP_ADDRESS_LOCATOR = "//md-input-container[@id='field-pickup-address']/div";

        public ReservationDetailsDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void waitUntilDialogDisplayed()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }

        public String getShipperName()
        {
            return getTextTrimmed(FIELD_SHIPPER_NAME_LOCATOR);
        }

        public String getShipperId()
        {
            return getTextTrimmed(FIELD_SHIPPER_ID_LOCATOR);
        }

        public String getReservationId()
        {
            return getTextTrimmed(FIELD_RESERVATION_ID_LOCATOR);
        }

        public String getPickupAddress()
        {
            return getTextTrimmed(FIELD_PICKUP_ADDRESS_LOCATOR);
        }
    }

    /**
     * Accessor for Create Reservation dialog
     */
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

    /**
     * Accessor for Create Reservation dialog
     */
    public static class EditRouteDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Edit Route";
        private static final String FIELD_NEW_ROUTE_LOCATOR = "ctrl.data.textRoute";
        private static final String FIELD_PRIORITY_LEVEL_LOCATOR = "Priority Level";
        private static final String BUTTON_SUBMIT_LOCATOR = "commons.save-changes";

        public EditRouteDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void fillTheForm(Long routeId, Integer priorityLevel)
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            pause2s();
            assertNotNull("Route ID should not be null.", routeId);

            selectValueFromNvAutocomplete(FIELD_NEW_ROUTE_LOCATOR, String.valueOf(routeId));

            if(priorityLevel!=null)
            {
                sendKeysById(FIELD_PRIORITY_LEVEL_LOCATOR, String.valueOf(priorityLevel));
            }
        }

        public void submitForm()
        {
            clickNvApiTextButtonByNameAndWaitUntilDone(BUTTON_SUBMIT_LOCATOR);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }

    /**
     * Accessor for Bulk Priority Edit dialog
     */
    public static class BulkPriorityEditDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Bulk Priority Edit";
        private static final String FIELD_PRIORITY_LEVEL_MODEL = "data.priorityLevel";
        private static final String BUTTON_SUBMIT_ARIA_LABEL = "Save changes";
        private static final String BUTTON_SET_TO_ALL_ARIA_LABEL = "Set to all";
        private static final String RESERVATIONS_TABLE_NG_REPEAT = "data in ctrl.data.reservations";

        public BulkPriorityEditDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        @SuppressWarnings("unused")
        public void fillTheForm(int priorityLevel)
        {
            fillTheForm(priorityLevel, false);
        }

        public void fillTheForm(int priorityLevel, boolean setToAll)
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            int rowsCount = 1;

            if(setToAll)
            {
                clickButtonByAriaLabel(BUTTON_SET_TO_ALL_ARIA_LABEL);
            }
            else
            {
                rowsCount = getRowsCountOfTableWithNgRepeat(RESERVATIONS_TABLE_NG_REPEAT);
            }

            for(int index=1; index<=rowsCount; index++)
            {
                sendKeysToMdInputContainerOnTableWithNgRepeat(index, FIELD_PRIORITY_LEVEL_MODEL, RESERVATIONS_TABLE_NG_REPEAT, String.valueOf(priorityLevel));
            }
        }

        public void submitForm()
        {
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUBMIT_ARIA_LABEL);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }

    /**
     * Accessor for Bulk Route Assignment dialog
     */
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

        public void clickSuggestButton()
        {
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUGGEST_ARIA_LABEL);
        }

        public String readSuggestedRoute(int index)
        {
            return getSelectedValueOfMdAutocompleteOnTableWithNgRepeat(index, "route", "reservation in ctrl.data.reservations");
        }

        public Route validateSuggestedRoutes(List<Route> validRoutes)
        {
            Route route = null;
            int rowsCount = getRowsCountOfTableWithNgRepeat("reservation in ctrl.data.reservations");

            for(int index=1; index<=rowsCount; index++)
            {
                route = validateSuggestedRoute(index, validRoutes);
            }

            return route;
        }

        public Route validateSuggestedRoute(int index, List<Route> validRoutes)
        {
            String suggestedRoute = readSuggestedRoute(index);
            assertThat("Suggested Route", suggestedRoute, not(isEmptyOrNullString()));
            Pattern p = Pattern.compile("(\\d*)(\\s-\\s)(.*)");
            Matcher m = p.matcher(suggestedRoute);
            AtomicLong routeId = new AtomicLong(0);

            if(m.matches())
            {
                routeId.set(Long.parseLong(m.group(1)));
            }

            String reason = String.format("[%d] Suggested Route ID", index);
            assertThat(reason, routeId.get(), greaterThan(0L));
            Optional<Route> optRoute = validRoutes.stream().filter(route -> route.getId() == routeId.get()).findFirst();
            reason = String.format("[%d] Suggested route is not valid", index);
            assertTrue(reason, optRoute.isPresent());
            return optRoute.orElse(null);
        }

        public void submitForm()
        {
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUBMIT_ARIA_LABEL);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }

    /**
     * Accessor for Apply Action menu
     */
    public static class ApplyActionsMenu extends OperatorV2SimplePage
    {
        private static final String PARENT_MENU_NAME = "Apply Action";
        private static final String ITEM_DOWNLOAD_CSV_FILE = "Download CSV File";
        private static final String ITEM_CREATE_RESERVATION = "Create Reservation";
        private static final String ITEM_REMOVE_ROUTE = "Remove Route";
        private static final String ITEM_SUGGEST_ROUTE = "Suggest Route";
        private static final String ITEM_EDIT_PRIORITY_LEVEL = "Edit Priority Level";

        public ApplyActionsMenu(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void chooseDownloadCsvFile()
        {
            chooseItem(ITEM_DOWNLOAD_CSV_FILE);
        }

        public void chooseCreateReservation()
        {
            chooseItem(ITEM_CREATE_RESERVATION);
        }

        public void chooseRemoveRoute()
        {
            chooseItem(ITEM_REMOVE_ROUTE);
        }

        public void chooseSuggestRoute()
        {
            chooseItem(ITEM_SUGGEST_ROUTE);
        }

        public void chooseEditPriorityLevel()
        {
            chooseItem(ITEM_EDIT_PRIORITY_LEVEL);
        }

        private void chooseItem(String childMenuName)
        {
            clickMdMenuItem(PARENT_MENU_NAME, childMenuName);
        }
    }

    /**
     * Accessor for Reservations table
     */
    public static class ReservationsTable extends OperatorV2SimplePage
    {
        private static final String MD_VIRTUAL_REPEAT = "data in getTableData()";
        private static final String COLUMN_CLASS_DATA_SHIPPER_NAME_AND_CONTACT = "name";
        private static final String COLUMN_CLASS_DATA_ROUTE_ID = "route-id";
        private static final String COLUMN_CLASS_DATA_DRIVER_NAME = "driver-name";
        private static final String COLUMN_CLASS_DATA_PRIORITY_LEVEL = "priority-level";
        private static final String COLUMN_CLASS_DATA_READY_BY = "ready-by";
        private static final String COLUMN_CLASS_DATA_LATEST_BY = "last-by";
        private static final String COLUMN_CLASS_DATA_RESERVATION_TYPE = "type";
        private static final String COLUMN_CLASS_DATA_RESERVATION_STATUS = "status";
        private static final String COLUMN_CLASS_DATA_RESERVATION_CREATED_TIME = "created-date";
        private static final String COLUMN_CLASS_DATA_SERVICE_TIME = "service-time";
        private static final String COLUMN_CLASS_DATA_PICKUP_ADDRESS = "pickup-address";
        private static final String COLUMN_CLASS_DATA_APPROX_VOLUME = "approx-volume";
        private static final String COLUMN_CLASS_DATA_FAILURE_REASON = "failure-reason";
        private static final String COLUMN_CLASS_DATA_COMMENTS = "comments";

        public static final String ACTION_BUTTON_ROUTE_EDIT = "Route Edit";
        public static final String ACTION_BUTTON_DETAILS = "Details";
        public static final String ACTION_BUTTON_FINISH = "Finish";

        public ReservationsTable(WebDriver webDriver)
        {
            super(webDriver);
        }

        public String getShipperNameAndContact(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_SHIPPER_NAME_AND_CONTACT);
        }

        public String getRouteId(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_ROUTE_ID);
        }

        public String getDriverName(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_DRIVER_NAME);
        }

        public String getPriorityLevel(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_PRIORITY_LEVEL);
        }

        public String getReadyBy(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_READY_BY);
        }

        public String getLatestBy(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_LATEST_BY);
        }

        public String getReservationType(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_RESERVATION_TYPE);
        }

        public String getReservationStatus(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_RESERVATION_STATUS);
        }

        public String getReservationCreatedTime(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_RESERVATION_CREATED_TIME);
        }

        public String getServiceTime(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_SERVICE_TIME);
        }

        public String getPickupAddress(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_PICKUP_ADDRESS);
        }

        public String getApproxVolume(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_APPROX_VOLUME);
        }

        public String getFailureReason(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_FAILURE_REASON);
        }

        public String getComments(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DATA_COMMENTS);
        }

        private String getTextOnTable(int rowNumber, String columnDataClass)
        {
            String text = getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
            return StringUtils.normalizeSpace(text);
        }

        public void clickActionButton(int rowNumber, String actionButtonName)
        {
            clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
        }

        public void checkSelectionCheckbox(int rowNumber)
        {
            checkRowWithMdVirtualRepeat(rowNumber, MD_VIRTUAL_REPEAT);
        }

        public void searchByPickupAddress(String pickupAddress)
        {
            searchTableCustom1(COLUMN_CLASS_DATA_PICKUP_ADDRESS, pickupAddress);
        }

        public String searchByPickupAddress(Address address)
        {
            String pickupAddress = buildPickupAddress(address);
            searchByPickupAddress(pickupAddress);
            return pickupAddress;
        }

        public String getNotDefaultBackgroundColorOfRow(int rowNumber)
        {
            waitUntilVisibilityOfElementLocated(f("//tr[@md-virtual-repeat='%s' and not(contains(@class, 'row-default'))][%d]", MD_VIRTUAL_REPEAT, rowNumber));
            Color actualPriorityLevelColor = getBackgroundColor(f("//tr[@md-virtual-repeat='%s'][%d]", MD_VIRTUAL_REPEAT, rowNumber));
            return actualPriorityLevelColor.asHex();
        }
    }

    /**
     * Accessor for Filters form
     */
    public static class FiltersForm extends OperatorV2SimplePage
    {
        private static final String FIELD_FROM_NG_MODEL = "fromModel";
        private static final String FIELD_TO_NG_MODEL = "toModel";
        private static final String BUTTON_LOAD_SELECTION_NAME = "Load Selection";
        private static final String FIELD_SELECT_FILTER_PLACEHOLDER = "Select Filter";
        private static final String HUBS_ITEM_TYPE = "Hubs";
        private static final String ZONES_ITEM_TYPE = "Zones";

        public FiltersForm(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void filterReservationDate(Date fromDate, Date toDate)
        {
            setMdDatepicker(FIELD_TO_NG_MODEL, toDate); // To Date should be select first.
            setMdDatepicker(FIELD_FROM_NG_MODEL, fromDate);
        }

        public void filterByHub(String hub)
        {
            selectValueFromMdAutocomplete(FIELD_SELECT_FILTER_PLACEHOLDER, HUBS_ITEM_TYPE);
            selectValueFromNvAutocompleteByItemTypesAndDismiss(HUBS_ITEM_TYPE, hub);
        }

        public void filterByZone(String zone)
        {
            selectValueFromMdAutocomplete(FIELD_SELECT_FILTER_PLACEHOLDER, ZONES_ITEM_TYPE);
            selectValueFromNvAutocompleteByItemTypesAndDismiss(ZONES_ITEM_TYPE, zone);
        }

        public void filterByShipper(String shipperName)
        {
            selectValueFromNvAutocompleteByItemTypesAndDismiss("Shipper", shipperName);
        }

        public void filterByType(String reservationType)
        {
            List<String> valuesSelected = getSelectedValuesFromNvFilterBox("Reservation Types");

            if((Objects.nonNull(valuesSelected) && !valuesSelected.contains(reservationType)) || valuesSelected.isEmpty())
            {
                selectValueFromNvAutocompleteByItemTypesAndDismiss("Reservation Types", reservationType);
            }

            valuesSelected = getSelectedValuesFromNvFilterBox("Reservation Types");

            if(Objects.nonNull(valuesSelected) && !valuesSelected.isEmpty())
            {
                valuesSelected.stream()
                        .filter(valueSelected -> !valueSelected.equals(reservationType))
                        .forEach(valueSelected -> removeSelectedValueFromNvFilterBoxByAriaLabel("Reservation Types", valueSelected));
            }
        }

        public void clickButtonLoadSelection()
        {
            clickNvApiTextButtonByNameAndWaitUntilDone(BUTTON_LOAD_SELECTION_NAME);
        }
    }

    /**
     * Accessor for Finish reservation dialog
     */
    public static class FinishReservationDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_LOCATOR = "//md-dialog[contains(@class,'shipper-pickups-finish-reservation-dialog')]";
        private static final String DIALOG_FAIL_RESERVATION_CONFIRMATION_LOCATOR = "//md-dialog[contains(@aria-label,'Fail Reservation')]";
        private static final String DIALOG_SUCCESS_RESERVATION_CONFIRMATION_LOCATOR = "//md-dialog[contains(@aria-label,'Success Reservation')]";
        private static final String BUTTON_SUCCESS_ARIA_LABEL = "Success";
        private static final String BUTTON_FAILURE_ARIA_LABEL = "Failure";
        private static final String BUTTON_PROCEED_WITH_FINISHING_RESERVATION_ARIA_LABEL = "Proceed";
        private static final String BUTTON_UPDATE_FAILURE_ARIA_LABEL = "Update";
        private static final String SELECT_FAILURE_REASON_ARIA_LABEL = "Choose a failure reason";
        private static final String SELECT_FAILURE_REASON_ID_STARTS_WITH = "container.shipper-pickups.choose-failure-reason";
        private static final String SELECT_FAILURE_REASON_DETAIL_ID_STARTS_WITH = "container.shipper-pickups.failure-reason-detail";
        private static final String SELECT_OPTIONS_FAILURE_REASON_DETAIL = "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option/div";
        private static final String SELECT_OPTIONS_FAILURE_REASON = "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option/div";

        public FinishReservationDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void selectFailureAsReason()
        {
            waitUntilVisibilityOfElementLocated(DIALOG_LOCATOR);
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_FAILURE_ARIA_LABEL);
        }

        public void selectSuccessAsReason()
        {
            waitUntilVisibilityOfElementLocated(DIALOG_LOCATOR);
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUCCESS_ARIA_LABEL);
        }

        public void clickOnUpdateButton()
        {
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_UPDATE_FAILURE_ARIA_LABEL);
        }

        public void proceedWithFailureInConfirmationPopUp()
        {
            waitUntilVisibilityOfElementLocated(DIALOG_FAIL_RESERVATION_CONFIRMATION_LOCATOR);
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_PROCEED_WITH_FINISHING_RESERVATION_ARIA_LABEL);
        }

        public void proceedWithSuccessInConfirmationPopUp()
        {
            waitUntilVisibilityOfElementLocated(DIALOG_SUCCESS_RESERVATION_CONFIRMATION_LOCATOR);
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_PROCEED_WITH_FINISHING_RESERVATION_ARIA_LABEL);
        }

        private List<String> getFailureReasonsList(){
            clickf("//md-select[starts-with(@id,'%s')]", SELECT_FAILURE_REASON_ID_STARTS_WITH);
            pause100ms();
            List<String> textOfElements = getTextOfElements(SELECT_OPTIONS_FAILURE_REASON);
            Actions actions = new Actions(getWebDriver());
            actions.sendKeys(Keys.ESCAPE).build().perform();
            pause300ms();
            return textOfElements;
        }

        private List<String> getFailureReasonsDetailList(String elementId){
            waitUntilVisibilityOfElementLocated(f("//md-select[starts-with(@id,'%s')]", elementId));
            clickf("//md-select[starts-with(@id,'%s')]", elementId);
            pause100ms();
            List<String> textOfElements = getTextOfElements(SELECT_OPTIONS_FAILURE_REASON_DETAIL);
            Actions actions = new Actions(getWebDriver());
            actions.sendKeys(Keys.ESCAPE).build().perform();
            pause300ms();
            return textOfElements;
        }

        private void selectFailureReason(String value){
            selectValueFromMdSelectByAriaLabel(SELECT_FAILURE_REASON_ARIA_LABEL, value);
        }

        private void selectFailureReasonDetail(String elementId, String value){
            selectValueFromMdSelectById(elementId, value);
        }

        private boolean isFailureReasonDetailExist(){
            return isElementExist(f("//md-select[starts-with(@id,'%s')][md-select-value/span[contains(text(),'Failure reason detail')]]",
                    SELECT_FAILURE_REASON_DETAIL_ID_STARTS_WITH));
        }

        public void selectFailureReasonDetail() {
            List<WebElement> failureReasonDetailsList = getWebDriver()
                    .findElements(By.xpath(f("//md-select[starts-with(@id,'%s')][md-select-value/span[contains(text(),'Failure reason detail')]]",
                    SELECT_FAILURE_REASON_DETAIL_ID_STARTS_WITH)));
            String elementId = failureReasonDetailsList.get(0).getAttribute("id");
            List<String> failureReasonDetailsSecond = getFailureReasonsDetailList(elementId);
            int randomFailureReasonDetailsIndexSecond = (int) (Math.random() * failureReasonDetailsSecond.size());
            selectFailureReasonDetail(elementId, failureReasonDetailsSecond.get(randomFailureReasonDetailsIndexSecond)
                    .replace("'", "/'"));
        }
    }
}
