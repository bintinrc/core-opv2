package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.pdf.RoutePassword;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.PdfUtils;
import co.nvqa.commons.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.CreateRouteParams;
import co.nvqa.operator_v2.model.DriverTypeParams;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class RouteLogsPage extends OperatorV2SimplePage
{
    private static final int ACTION_BULK_EDIT_DETAILS = 1;
    private static final int ACTION_EDIT_DRIVER_TYPES_OF_SELECTED = 2;
    private static final int ACTION_MERGE_TRANSACTIONS_OF_SELECTED = 3;
    private static final int ACTION_OPTIMISE_SELECTED = 4;
    private static final int ACTION_PRINT_PASSWORDS_OF_SELECTED = 5;
    private static final int ACTION_PRINT_SELECTED = 6;
    private static final int ACTION_ARCHIVE_SELECTED = 7;
    private static final int ACTION_UNARCHIVE_SELECTED = 8;
    private static final int ACTION_DELETE_SELECTED = 9;

    private static final String MD_VIRTUAL_REPEAT = "route in getTableData()";

    public static final String COLUMN_CLASS_FILTER_ROUTE_ID = "id";
    public static final String COLUMN_CLASS_DATA_ROUTE_DATE = "_date";
    public static final String COLUMN_CLASS_DATA_ROUTE_ID = "id";
    public static final String COLUMN_CLASS_DATA_DRIVER_NAME = "_driver-name";
    public static final String COLUMN_CLASS_DATA_STATUS = "status";
    public static final String COLUMN_CLASS_DATA_ROUTE_PASSWORD = "route-password";
    public static final String COLUMN_CLASS_DATA_HUB_NAME = "_hub-name";
    public static final String COLUMN_CLASS_DATA_ZONE_NAME = "_zone-name";
    public static final String COLUMN_CLASS_DATA_COMMENTS = "comments";


    public static final String ACTION_BUTTON_EDIT_ROUTE = "container.route-logs.edit-route";
    public static final String ACTION_BUTTON_EDIT_DETAILS = "container.route-logs.edit-details";

    public static final String SELECT_TAG_XPATH = "//md-select[contains(@aria-label, 'Select Tag:')]";

    public RouteLogsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading data...']");
    }

    private void fillCreateRouteFormExceptComments(CreateRouteParams createRouteParams)
    {
        setMdDatepickerById("commons.model.route-date", createRouteParams.getRouteDate());
        selectMultipleValuesFromMdSelectById("commons.model.route-tags", createRouteParams.getRouteTags());
        selectValueFromNvAutocompleteByPossibleOptions("zonesSelectionOptions", createRouteParams.getZoneName());
        selectValueFromNvAutocompleteByPossibleOptions("hubsSelectionOptions", createRouteParams.getHubName());
        pause2s(); // We put delay here because sometimes when typing on Driver Selection, the cursor is jumping to Hub Selection and this delay help to avoid that issue.

        if(TestConstants.COUNTRY_CODE.equals("SG"))
        {
            selectValueFromNvAutocompleteByPossibleOptions("driversSelectionOptions", createRouteParams.getNinjaDriverName());
        }
        else
        {
            selectValueFromNvAutocompleteByPossibleOptions("driversSelectionOptions", createRouteParams.getNinjaDriverName().replaceAll(" ", ""));
        }

        selectValueFromNvAutocompleteByPossibleOptions("vehiclesSelectionOptions", createRouteParams.getVehicleName());
    }

    /**
     * This method will create object Route and put it to CreateRouteParams
     * if the route is created successfully.
     *
     * @param createRouteParams The object of CreateRouteParams.
     */
    public void createNewRoute(CreateRouteParams createRouteParams)
    {
        waitUntilPageLoaded();
        setFilterAndLoadSelection(createRouteParams.getRouteDate(), createRouteParams.getRouteDate(), createRouteParams.getHubName());
        clickNvIconTextButtonByName("Create Route");
        fillCreateRouteFormExceptComments(createRouteParams);
        sendKeysById("comments", createRouteParams.getComments());
        clickNvButtonSaveByNameAndWaitUntilDone("Create Route(s)");

        String toastBottomText = getToastBottomText();

        if(toastBottomText==null)
        {
            throw new NvTestRuntimeException("Failed to create new Route.");
        }
        else
        {
            String routeIdAsString = toastBottomText.split("Route")[1].trim();
            long routeId = Long.parseLong(routeIdAsString);

            Route createdRoute = new Route();
            createdRoute.setId(routeId);
            createdRoute.setComments(createRouteParams.getComments());
            createRouteParams.setCreatedRoute(createdRoute);
        }

        waitUntilInvisibilityOfToast("1 Route(s) Created");
    }

    /**
     * This method will create object Route and put it to CreateRouteParams
     * if the route is created successfully.
     *
     * @param listOfCreateRouteParams The object of List<CreateRouteParams>.
     */
    public void createMultipleRoute(List<CreateRouteParams> listOfCreateRouteParams)
    {
        waitUntilPageLoaded();

        if(listOfCreateRouteParams==null || listOfCreateRouteParams.isEmpty())
        {
            throw new NvTestRuntimeException("List of CreateRouteParams should not be empty.");
        }

        CreateRouteParams createRouteParams = listOfCreateRouteParams.get(0);

        setFilterAndLoadSelection(createRouteParams.getRouteDate(), createRouteParams.getRouteDate(), createRouteParams.getHubName());
        clickNvIconTextButtonByName("Create Route");
        fillCreateRouteFormExceptComments(createRouteParams);

        int listOfCreateRouteParamsSize = listOfCreateRouteParams.size();

        for(int i=1; i<listOfCreateRouteParamsSize; i++)
        {
            clickNvIconTextButtonByName("container.route-logs.duplicate-above");
        }

        for(int i=0; i<listOfCreateRouteParamsSize; i++)
        {
            sendKeys(String.format("(//textarea[@id='comments'])[%d]", (i+1)), listOfCreateRouteParams.get(i).getComments());
        }

        clickNvButtonSaveByNameAndWaitUntilDone("Create Route(s)");
        String toastBottomText = getToastBottomText();

        if(toastBottomText==null)
        {
            throw new NvTestRuntimeException("Failed to create new Route.");
        }
        else
        {
            String[] listOfRouteIdAsString = toastBottomText.split("\\n");
            int sizeOfListOfRouteIdAsString = listOfRouteIdAsString.length;

            for(int i=0; i<sizeOfListOfRouteIdAsString; i++)
            {
                String routeIdAsString = listOfRouteIdAsString[i].split("Route")[1].trim();
                Long routeId = Long.parseLong(routeIdAsString);

                Route createdRoute = new Route();
                createdRoute.setId(routeId);
                createdRoute.setComments(createRouteParams.getComments());
                listOfCreateRouteParams.get(i).setCreatedRoute(createdRoute);
            }
        }

        waitUntilInvisibilityOfToast("Route(s) Created");
    }

    public void verifyNewRouteIsCreatedSuccessfully(CreateRouteParams createRouteParams)
    {
        verifyRouteIsFoundAndInfoIsCorrect(createRouteParams);
    }

    public void verifyRouteIsFoundAndInfoIsCorrect(CreateRouteParams createRouteParams)
    {
        Route createdRoute = createRouteParams.getCreatedRoute();
        Long createdRouteId = createdRoute.getId();
        searchTableByRouteIdUntilFoundAndPasswordIsNotEmpty(createdRouteId);

        String actualRouteDate = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_DATE);
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID, XpathTextMode.EXACT);
        String actualDriverName = getTextOnTable(1, COLUMN_CLASS_DATA_DRIVER_NAME);
        String actualRoutePassword = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_PASSWORD);
        String actualHubName = getTextOnTable(1, COLUMN_CLASS_DATA_HUB_NAME);
        String actualZoneName = getTextOnTable(1, COLUMN_CLASS_DATA_ZONE_NAME);
        String actualComments = getTextOnTable(1, COLUMN_CLASS_DATA_COMMENTS);

        createdRoute.setRoutePassword(actualRoutePassword);

        Assert.assertEquals("Route Date", YYYY_MM_DD_SDF.format(createRouteParams.getRouteDate()), actualRouteDate);
        Assert.assertEquals("Route ID", String.valueOf(createdRouteId), actualRouteId);
        Assert.assertEquals("Driver Name", createRouteParams.getNinjaDriverName(), actualDriverName);
        Assert.assertEquals("Hub Name", createRouteParams.getHubName(), actualHubName);
        Assert.assertEquals("Zone Name", createRouteParams.getZoneName(), actualZoneName);
        Assert.assertEquals("Comments", createRouteParams.getComments(), actualComments);
    }

    public void bulkEditDetails(List<CreateRouteParams> listOfCreateRouteParams)
    {
        checkMultipleRows(listOfCreateRouteParams);
        selectAction(ACTION_BULK_EDIT_DETAILS);

        CreateRouteParams createRouteParams = listOfCreateRouteParams.get(0);
        setMdDatepickerById("commons.model.route-date", createRouteParams.getRouteDate());
        selectMultipleValuesFromMdSelectById("commons.model.route-tags", createRouteParams.getRouteTags());
        selectValueFromNvAutocompleteByPossibleOptions("hubsSelectionOptions", createRouteParams.getHubName());
        selectValueFromNvAutocompleteByPossibleOptions("driversSelectionOptions", createRouteParams.getNinjaDriverName());
        selectValueFromNvAutocompleteByPossibleOptions("vehiclesSelectionOptions", createRouteParams.getVehicleName());
        clickNvButtonSaveByNameAndWaitUntilDone("commons.save-changes");
        waitUntilInvisibilityOfToast("Route(s) Edited");
    }

    public void editDriverTypesOfSelectedRoute(List<CreateRouteParams> listOfCreateRouteParams, DriverTypeParams driverTypeParams)
    {
        checkMultipleRows(listOfCreateRouteParams);
        selectAction(ACTION_EDIT_DRIVER_TYPES_OF_SELECTED);
        String driverTypeNameFormatted = driverTypeParams.getDriverTypeName().replaceAll(" - ", " ").toLowerCase();
        selectMultipleValuesFromMdSelectById("container.route-logs.select-driver-types", driverTypeNameFormatted);
        clickNvIconTextButtonByNameAndWaitUntilDone("container.route-logs.edit-routes");
        waitUntilInvisibilityOfToast("Route(s) Edited");
    }

    public void mergeTransactionsOfMultipleRoutes(List<CreateRouteParams> listOfCreateRouteParams)
    {
        checkMultipleRows(listOfCreateRouteParams);
        selectAction(ACTION_MERGE_TRANSACTIONS_OF_SELECTED);
        clickButtonOnMdDialogByAriaLabel("Merge Transactions");
    }

    public void verifyTransactionsOfMultipleRoutesIsMergedSuccessfully(List<CreateRouteParams> listOfCreateRouteParams)
    {
        waitUntilVisibilityOfToast("Routes Merged");
        String toastBottomText = getToastBottomText();
        Assert.assertNotNull("Failed to merge transactions of multiple routes.", toastBottomText);
        waitUntilInvisibilityOfToast("Routes Merged", false);

        String[] arrayOfRouteIdAsString = listOfCreateRouteParams.stream().map(createRouteParams -> String.valueOf(createRouteParams.getCreatedRoute().getId())).toArray(String[]::new);
        String[] actualMergedRoutes = toastBottomText.replaceFirst("Route ", "").split(", ");
        Assert.assertThat("Expected Tracking ID not found.", Arrays.asList(actualMergedRoutes), Matchers.hasItems(arrayOfRouteIdAsString));
    }

    public void optimiseMultipleRoutes(List<CreateRouteParams> listOfCreateRouteParams)
    {
        checkMultipleRows(listOfCreateRouteParams);
        selectAction(ACTION_OPTIMISE_SELECTED);
    }

    public void verifyMultipleRoutesIsOptimisedSuccessfully(List<CreateRouteParams> listOfCreateRouteParams)
    {
        int sizeOfListOfCreateRouteParams = listOfCreateRouteParams.size();
        String[] arrayOfRouteIdAsString = listOfCreateRouteParams.stream().map(createRouteParams -> String.valueOf(createRouteParams.getCreatedRoute().getId())).toArray(String[]::new);
        waitUntilVisibilityOfElementLocated(String.format("//h5[contains(text(), 'Optimized Routes')]/small[contains(text(), '%d of %d route(s) completed')]", sizeOfListOfCreateRouteParams, sizeOfListOfCreateRouteParams));

        for(int i=1; i<=sizeOfListOfCreateRouteParams; i++)
        {
            String actualRouteId = getText(String.format("//tr[@ng-repeat='route in optimizedRoutes'][%d]/td[1]", i));
            String actualStatus = getText(String.format("//tr[@ng-repeat='route in optimizedRoutes'][%d]/td[2]", i));
            Assert.assertThat("Route ID not found in optimised list.", actualRouteId, Matchers.isOneOf(arrayOfRouteIdAsString));
            Assert.assertEquals(String.format("Route ID = %s", actualRouteId), "Optimized", actualStatus);
        }
    }

    public void printPasswordsOfSelectedRoutes(List<CreateRouteParams> listOfCreateRouteParams)
    {
        checkMultipleRows(listOfCreateRouteParams);
        selectAction(ACTION_PRINT_PASSWORDS_OF_SELECTED);
        waitUntilInvisibilityOfToast("Downloading routes_password");
    }

    public void verifyPrintedPasswordsOfSelectedRoutesInfoIsCorrect(List<CreateRouteParams> listOfCreateRouteParams)
    {
        String latestFilenameOfDownloadedPdf = getLatestDownloadedFilename("routes_password");
        verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
        List<RoutePassword> listOfRoutePassword = PdfUtils.getRoutePassword(TestConstants.TEMP_DIR + latestFilenameOfDownloadedPdf);

        for(CreateRouteParams createRouteParams : listOfCreateRouteParams)
        {
            Route route = createRouteParams.getCreatedRoute();
            long expectedRouteId = route.getId();
            RoutePassword selectedRoutePassword = null;

            for(RoutePassword routePassword : listOfRoutePassword)
            {
                if(expectedRouteId==routePassword.getRouteId())
                {
                    selectedRoutePassword = routePassword;
                    break;
                }
            }

            Assert.assertNotNull(String.format("Route password for Route ID = %d not found on PDF.", expectedRouteId), selectedRoutePassword);
            Assert.assertEquals(String.format("Route Password for Route ID = %d", expectedRouteId), route.getRoutePassword(), selectedRoutePassword.getRoutePassword());
        }
    }

    public void printMultipleRoutes(List<CreateRouteParams> listOfCreateRouteParams)
    {
        checkMultipleRows(listOfCreateRouteParams);
        selectAction(ACTION_PRINT_SELECTED);
        waitUntilInvisibilityOfToast("Downloading route_printout");
    }

    public void verifyMultipleRoutesIsPrintedSuccessfully()
    {
        String latestFilenameOfDownloadedPdf = getLatestDownloadedFilename("route_printout");
        verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
    }

    public void archiveMultipleRoutes(List<CreateRouteParams> listOfCreateRouteParams)
    {
        checkMultipleRows(listOfCreateRouteParams);
        selectAction(ACTION_ARCHIVE_SELECTED);
        clickNvIconTextButtonByNameAndWaitUntilDone("container.route-logs.archive-routes");
        waitUntilInvisibilityOfToast("Route(s) Archived");
    }

    public void verifyMultipleRoutesIsArchivedSuccessfully(List<CreateRouteParams> listOfCreateRouteParams)
    {
        for(CreateRouteParams createRouteParams : listOfCreateRouteParams)
        {
            StandardTestUtils.retryIfRuntimeExceptionOccurred(() ->
            {
                Route route = createRouteParams.getCreatedRoute();
                Long routeId = route.getId();
                searchTableByRouteId(routeId);
                boolean isTableEmpty = isTableEmpty();

                try
                {
                    Assert.assertFalse("Table is empty.", isTableEmpty);
                    String actualRouteStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
                    Assert.assertEquals("Route Status", "ARCHIVED", actualRouteStatus);
                }
                catch(AssertionError ex)
                {
                    editFilterAndLoadSelection();
                    throw new NvTestRuntimeException("Route status is not 'ARCHIVED'.", ex);
                }
            }, getCurrentMethodName());
        }
    }

    public void unarchiveMultipleRoutes(List<CreateRouteParams> listOfCreateRouteParams)
    {
        checkMultipleRows(listOfCreateRouteParams);
        selectAction(ACTION_UNARCHIVE_SELECTED);
        clickNvIconTextButtonByNameAndWaitUntilDone("container.route-logs.unarchive-routes");
        waitUntilInvisibilityOfToast("Route(s) Unarchived");
    }

    public void verifyMultipleRoutesIsUnarchivedSuccessfully(List<CreateRouteParams> listOfCreateRouteParams)
    {
        for(CreateRouteParams createRouteParams : listOfCreateRouteParams)
        {
            StandardTestUtils.retryIfRuntimeExceptionOccurred(() ->
            {
                Route route = createRouteParams.getCreatedRoute();
                Long routeId = route.getId();
                searchTableByRouteId(routeId);
                boolean isTableEmpty = isTableEmpty();

                try
                {
                    Assert.assertFalse("Table is empty.", isTableEmpty);
                    String actualRouteStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
                    Assert.assertNotEquals("Route Status", "ARCHIVED", actualRouteStatus);
                }
                catch(AssertionError ex)
                {
                    editFilterAndLoadSelection();
                    throw new NvTestRuntimeException("Route status is still 'ARCHIVED'.", ex);
                }
            }, getCurrentMethodName());
        }
    }

    public void deleteMultipleRoutes(List<CreateRouteParams> listOfCreateRouteParams)
    {
        checkMultipleRows(listOfCreateRouteParams);
        selectAction(ACTION_DELETE_SELECTED);
        clickButtonOnMdDialogByAriaLabel("Delete");
        waitUntilInvisibilityOfToast("Route(s) Deleted");
    }

    public void verifyMultipleRoutesIsDeletedSuccessfully(List<CreateRouteParams> listOfCreateRouteParams)
    {
        for(CreateRouteParams createRouteParams : listOfCreateRouteParams)
        {
            StandardTestUtils.retryIfRuntimeExceptionOccurred(() ->
            {
                Route route = createRouteParams.getCreatedRoute();
                Long routeId = route.getId();
                searchTableByRouteId(routeId);
                boolean isTableEmpty = isTableEmpty();

                try
                {
                    Assert.assertTrue(String.format("Route with ID = %d is still exists on table.", routeId), isTableEmpty);
                }
                catch(AssertionError ex)
                {
                    editFilterAndLoadSelection();
                    throw new NvTestRuntimeException(ex);
                }
            }, getCurrentMethodName());
        }
    }

    public void selectRouteDateFilter(Date routeDateFrom, Date routeDateTo)
    {
        setMdDatepicker("fromModel", routeDateFrom);
        setMdDatepicker("toModel", routeDateTo);
    }

    public boolean isLoadSelectionVisible()
    {
        return isElementExist("//button[@aria-label='Load Selection']");
    }

    public void setFilterAndLoadSelection(Date routeDateFrom, Date routeDateTo, String hubName)
    {
        selectRouteDateFilter(routeDateFrom, routeDateTo);
        selectValueFromNvAutocompleteByItemTypesAndDismiss("Hub", hubName);
        clickLoadSelection();
    }

    private void editFilterAndLoadSelection()
    {
        clickButtonByAriaLabel("Edit Filters");
        pause1s();
        clickLoadSelection();
        pause200ms();
    }

    public void clickLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }

    public void clickEditFilter()
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("container.route-logs.edit-filters");
    }

    public void clickLoadWaypointsOfSelectedRoutesOnly()
    {
        click("//div[text()='Load Waypoints of Selected Route(s) Only']");
    }

    @SuppressWarnings("unused")
    public void clickLoadSelectedRoutesAndUnroutedWaypoints()
    {
        click("//div[text()='Load Selected Route(s) and Unrouted Waypoints']");
    }

    public void clickCancelOnEditRoutesDialog()
    {
        clickButtonByAriaLabel("Cancel");
    }

    public void editAssignedDriver(String newDriverName)
    {
        sendKeys("//div/label[text()='Assigned Driver']/following-sibling::nv-autocomplete//input", newDriverName);
        pause1s();
        clickf("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", newDriverName);
        pause100ms();
    }

    public void clickSaveButtonOnEditDetailsDialog()
    {
        clickNvButtonSaveByNameAndWaitUntilDone("commons.save-changes");
    }

    public void deleteRoute(long routeId)
    {
        searchAndVerifyRouteExist(routeId);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT_DETAILS);
        pause200ms();
        click("//button[@ng-class='ngClazz'][@aria-label='Delete']");
        pause200ms();

        TestUtils.retryIfStaleElementReferenceExceptionOccurred(()->
        {
            clickButtonByAriaLabel("Delete");
            pause200ms();
        }, getCurrentMethodName());
    }

    public void selectAction(int actionType)
    {
        click("//span[text()='Apply Action']");

        switch(actionType)
        {
            case ACTION_BULK_EDIT_DETAILS: clickButtonByAriaLabel("Bulk Edit Details"); break;
            case ACTION_EDIT_DRIVER_TYPES_OF_SELECTED: clickButtonByAriaLabel("Edit Driver Types of Selected"); break;
            case ACTION_MERGE_TRANSACTIONS_OF_SELECTED: clickButtonByAriaLabel("Merge Transactions of Selected"); break;
            case ACTION_OPTIMISE_SELECTED: clickButtonByAriaLabel("Optimise Selected"); break;
            case ACTION_PRINT_PASSWORDS_OF_SELECTED: clickButtonByAriaLabel("Print Passwords of Selected"); break;
            case ACTION_PRINT_SELECTED: clickButtonByAriaLabel("Print Selected"); break;
            case ACTION_ARCHIVE_SELECTED: clickButtonByAriaLabel("Archive Selected"); break;
            case ACTION_UNARCHIVE_SELECTED: clickButtonByAriaLabel("Unarchive Selected"); break;
            case ACTION_DELETE_SELECTED: clickButtonByAriaLabel("Delete Selected"); break;
        }

        pause500ms();
    }

    public void searchTableByRouteIdUntilFoundAndPasswordIsNotEmpty(long routeId)
    {
        StandardTestUtils.retryIfRuntimeExceptionOccurred(() ->
        {
            searchTableByRouteId(routeId);
            boolean isTableEmpty = isTableEmpty();

            boolean isReloadNeeded = false;
            String message = null;

            if(isTableEmpty)
            {
                isReloadNeeded = true;
                message = "Table is empty. Route not found.";
            }
            else
            {
                String actualRoutePassword = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_PASSWORD);

                if(actualRoutePassword==null || actualRoutePassword.isEmpty())
                {
                    isReloadNeeded = true;
                    message = "Route is found but the password is empty.";
                }
            }

            if(isReloadNeeded)
            {
                editFilterAndLoadSelection();
                throw new NvTestRuntimeException(message);
            }
        }, getCurrentMethodName());
    }

    public void searchTableByRouteId(long routeId)
    {
        searchTableCustom1(COLUMN_CLASS_FILTER_ROUTE_ID, String.valueOf(routeId));
    }

    public void searchAndVerifyRouteExist(long routeId)
    {
        searchTableByRouteId(routeId);
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID, XpathTextMode.EXACT);
        Assert.assertEquals("Route ID not found in table.", String.valueOf(routeId), actualRouteId);
        pause200ms();
    }

    public void selectTag(long routeId, String newTag)
    {
        searchAndVerifyRouteExist(routeId);
        click(SELECT_TAG_XPATH);
        pause100ms();
        clickf("//div[contains(@class,'md-select-menu-container') and @aria-hidden='false']/md-select-menu/md-content/md-option/div[@class='md-text' and contains(text(), '%s')]", newTag);
        pause100ms();
        click("//nv-table-description/div/div/span[text()='Showing']"); //Click on random element to close 'Select Tag' dialog.
        pause200ms();
    }

    public String getRouteTag(long routeId)
    {
        searchAndVerifyRouteExist(routeId);
        return getText(SELECT_TAG_XPATH);
    }

    public void loadAndVerifyRoute(Date filterRouteDateFrom, Date filterRouteDateTo, String filterHubName, long routeId)
    {
        setFilterAndLoadSelection(filterRouteDateFrom, filterRouteDateTo, filterHubName);
        searchTableByRouteId(routeId);
        String actualRouteStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
        Assert.assertEquals("Track is not routed.","IN_PROGRESS", actualRouteStatus);
    }

    private void checkMultipleRows(List<CreateRouteParams> listOfCreateRouteParams)
    {
        for(CreateRouteParams createRouteParams : listOfCreateRouteParams)
        {
            Route createdRoute = createRouteParams.getCreatedRoute();
            Long createdRouteId = createdRoute.getId();
            searchTableByRouteId(createdRouteId);
            checkRow(1);
        }
    }

    public void checkRow(int rowNumber)
    {
        checkRowWithMdVirtualRepeat(rowNumber, MD_VIRTUAL_REPEAT);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass, XpathTextMode xpathTextMode)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT, xpathTextMode);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
