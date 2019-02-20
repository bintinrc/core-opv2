package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.model.ChangeDeliveryTiming;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction;
import co.nvqa.operator_v2.util.TestUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction.ADD_TO_ROUTE;
import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction.CANCEL_SELECTED;
import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction.MANUALLY_COMPLETE_SELECTED;
import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction.PULL_FROM_ROUTE;
import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction.RESUME_SELECTED;
import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction.SET_RTS_TO_SELECTED;

/**
 *
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class AllOrdersPage extends OperatorV2SimplePage
{
    private static final String SAMPLE_CSV_FILENAME = "find-orders-with-csv.csv";
    private static final String MD_VIRTUAL_REPEAT_TABLE_ORDER = "order in getTableData()";

    public static final String COLUMN_CLASS_DATA_TRACKING_ID_ON_TABLE_ORDER = "tracking-id";
    public static final String COLUMN_CLASS_DATA_FROM_NAME_ON_TABLE_ORDER = "from-name";
    public static final String COLUMN_CLASS_DATA_FROM_CONTACT_ON_TABLE_ORDER = "from-contact";
    public static final String COLUMN_CLASS_DATA_FROM_ADDRESS_ON_TABLE_ORDER = "_from-address";
    public static final String COLUMN_CLASS_DATA_FROM_POSTCODE_ON_TABLE_ORDER = "from-postcode";
    public static final String COLUMN_CLASS_DATA_TO_NAME_ON_TABLE_ORDER = "to-name";
    public static final String COLUMN_CLASS_DATA_TO_CONTACT_ON_TABLE_ORDER = "to-contact";
    public static final String COLUMN_CLASS_DATA_TO_ADDRESS_ON_TABLE_ORDER = "_to-address";
    public static final String COLUMN_CLASS_DATA_TO_POSTCODE_ON_TABLE_ORDER = "to-postcode";
    public static final String COLUMN_CLASS_DATA_GRANULAR_STATUS_ON_TABLE_ORDER = "_granular-status";

    public static final String ACTION_BUTTON_PRINT_WAYBILL_ON_TABLE_ORDER = "container.order.list.print-waybill";

    public enum Category
    {
        TRACKING_OR_STAMP_ID("Tracking / Stamp ID"),
        NAME("Name"),
        CONTACT_NUMBER("Contact Number"),
        RECIPIENT_ADDRESS_LINE_1("Recipient Address (Line 1)");

        private final String value;

        Category(String value)
        {
            this.value = value;
        }

        public static Category findByValue(String value)
        {
            Category result = TRACKING_OR_STAMP_ID;

            for(Category enumTemp : values())
            {
                if(enumTemp.getValue().equalsIgnoreCase(value))
                {
                    result = enumTemp;
                    break;
                }
            }

            return result;
        }

        public String getValue()
        {
            return value;
        }
    }

    public enum SearchLogic
    {
        EXACTLY_MATCHES("exactly matches"),
        CONTAINS("contains");

        private final String value;

        SearchLogic(String value)
        {
            this.value = value;
        }

        public static SearchLogic findByValue(String value)
        {
            SearchLogic result = EXACTLY_MATCHES;

            for(SearchLogic enumTemp : values())
            {
                if(enumTemp.getValue().equalsIgnoreCase(value))
                {
                    result = enumTemp;
                    break;
                }
            }

            return result;
        }

        public String getValue()
        {
            return value;
        }
    }

    private final EditOrderPage editOrderPage;
    public ApplyActionsMenu applyActionsMenu;

    public AllOrdersPage(WebDriver webDriver)
    {
        this(webDriver, new EditOrderPage(webDriver));
    }

    public AllOrdersPage(WebDriver webDriver, EditOrderPage editOrderPage)
    {
        super(webDriver);
        this.editOrderPage = editOrderPage;
        this.applyActionsMenu = new ApplyActionsMenu(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading...']");
    }

    public void downloadSampleCsvFile()
    {
        clickNvIconTextButtonByName("container.order.list.find-orders-with-csv");
        waitUntilVisibilityOfElementLocated("//md-dialog//h2[text()='Find Orders with CSV']");
        click("//a[@filename='find-orders-with-csv.csv']");
    }

    public void verifySampleCsvFileDownloadedSuccessfully()
    {
        verifyFileDownloadedSuccessfully(SAMPLE_CSV_FILENAME, "NVSGNINJA000000001\nNVSGNINJA000000002\nNVSGNINJA000000003");
    }

    public void findOrdersWithCsv(List<String> listOfTrackingId)
    {
        clickNvIconTextButtonByName("container.order.list.find-orders-with-csv");
        waitUntilVisibilityOfElementLocated("//md-dialog//h2[text()='Find Orders with CSV']");

        String csvContents = listOfTrackingId.stream().collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
        File csvFile = createFile(String.format("find-orders-with-csv_%s.csv", generateDateUniqueString()), csvContents);

        sendKeysByAriaLabel("Choose", csvFile.getAbsolutePath());
        waitUntilVisibilityOfElementLocated(String.format("//span[contains(text(), '%s')]", csvFile.getName()));
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.upload");
    }

    public void findOrdersWithCsvAndWaitUntilToastDisappear(List<String> listOfTrackingId)
    {
        findOrdersWithCsv(listOfTrackingId);
        waitUntilInvisibilityOfToast("Matches with file shown in table", false);
    }

    public void verifyAllOrdersInCsvIsFoundWithCorrectInfo(List<Order> listOfCreatedOrder)
    {
        pause100ms();
        String toastTopText = getToastTopText();
        assertEquals("Toast message is different.", "Matches with file shown in table", toastTopText);
        waitUntilInvisibilityOfToast("Matches with file shown in table", false);
        listOfCreatedOrder.forEach(this::verifyOrderInfoOnTableOrderIsCorrect);
    }

    public void verifyInvalidTrackingIdsIsFailedToFind(List<String> listOfInvalidTrackingId)
    {
        List<WebElement> listOfWe = findElementsByXpath("//div[@ng-repeat='error in ctrl.payload.errors track by $index']");
        List<String> listOfActualInvalidTrackingId = listOfWe.stream().map(we -> we.getText().split("\\.")[1].trim()).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualInvalidTrackingId, hasItems(listOfInvalidTrackingId.toArray(new String[]{})));
    }

    public void verifyOrderStatus(String trackingId, String expectedOrderStatus)
    {
        filterTableOrderByTrackingId(trackingId);
        String actualGranularStatus = getTextOnTableOrder(1, COLUMN_CLASS_DATA_GRANULAR_STATUS_ON_TABLE_ORDER);
        assertThat("Granular Status", actualGranularStatus, equalToIgnoringCase(expectedOrderStatus));
    }

    public void verifyOrderInfoOnTableOrderIsCorrect(Order order)
    {
        String trackingId = order.getTrackingId();
        filterTableOrderByTrackingId(trackingId);

        String actualTrackingId = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TRACKING_ID_ON_TABLE_ORDER);
        String actualFromName = getTextOnTableOrder(1, COLUMN_CLASS_DATA_FROM_NAME_ON_TABLE_ORDER);
        String actualFromContact = getTextOnTableOrder(1, COLUMN_CLASS_DATA_FROM_CONTACT_ON_TABLE_ORDER);
        String actualFromAddress = getTextOnTableOrder(1, COLUMN_CLASS_DATA_FROM_ADDRESS_ON_TABLE_ORDER);
        String actualFromPostcode = getTextOnTableOrder(1, COLUMN_CLASS_DATA_FROM_POSTCODE_ON_TABLE_ORDER);
        String actualToName = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_NAME_ON_TABLE_ORDER);
        String actualToContact = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_CONTACT_ON_TABLE_ORDER);
        String actualToAddress = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_ADDRESS_ON_TABLE_ORDER);
        String actualToPostcode = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_POSTCODE_ON_TABLE_ORDER);
        String actualGranularStatus = getTextOnTableOrder(1, COLUMN_CLASS_DATA_GRANULAR_STATUS_ON_TABLE_ORDER);

        assertEquals("Tracking ID", trackingId, actualTrackingId);

        assertEquals("From Name", order.getFromName(), actualFromName);
        assertEquals("From Contact", order.getFromContact(), actualFromContact);
        assertThat("From Address", actualFromAddress, containsString(order.getFromAddress1()));
        assertThat("From Address", actualFromAddress, containsString(order.getFromAddress2()));
        assertEquals("From Postcode", order.getFromPostcode(), actualFromPostcode);

        assertEquals("To Name", order.getToName(), actualToName);
        assertEquals("To Contact", order.getToContact(), actualToContact);
        assertThat("To Address", actualToAddress, containsString(order.getToAddress1()));
        assertThat("To Address", actualToAddress, containsString(order.getToAddress2()));
        assertEquals("To Postcode", order.getToPostcode(), actualToPostcode);

        assertThat("Granular Status", actualGranularStatus, equalToIgnoringCase(order.getGranularStatus().replaceAll("_", " ")));
    }

    public void verifyOrderInfoIsCorrect(Order order)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        Long orderId = order.getId();
        String expectedTrackingId = order.getTrackingId();
        specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, expectedTrackingId);

        try
        {
            switchToEditOrderWindow(orderId);
            editOrderPage.verifyOrderInfoIsCorrect(order);
        }
        finally
        {
            closeAllWindows(mainWindowHandle);
        }
    }

    public void forceSuccessSingleOrder(String trackingId)
    {
        filterTableOrderByTrackingId(trackingId);
        selectAllShown("ctrl.ordersTableParam");
        applyActionsMenu.chooseItem(MANUALLY_COMPLETE_SELECTED);
        waitUntilVisibilityOfElementLocated("//md-dialog//div[contains(text(), \"Proceed to set the order status to 'Completed'?\")]");
        clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.complete-order");
        waitUntilInvisibilityOfToast("Complete Order");
    }

    public void verifyOrderIsForceSuccessedSuccessfully(Order order)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        Long orderId = order.getId();
        String trackingId = order.getTrackingId();
        specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, trackingId);

        try
        {
            switchToEditOrderWindow(orderId);
            editOrderPage.verifyOrderIsForceSuccessedSuccessfully(order);
        }
        finally
        {
            closeAllWindows(mainWindowHandle);
        }
    }

    public void rtsSingleOrderNextDay(String trackingId)
    {
        filterTableOrderByTrackingId(trackingId);
        selectAllShown("ctrl.ordersTableParam");
        applyActionsMenu.chooseItem(SET_RTS_TO_SELECTED);
        setMdDatepickerById("commons.model.delivery-date", TestUtils.getNextDate(1));
        selectValueFromMdSelectById("commons.timeslot", "3PM - 6PM");
        clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.set-order-to-rts");
        waitUntilInvisibilityOfToast("updated");
    }

    public void cancelSelected(List<String> listOfExpectedTrackingId)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        applyActionsMenu.chooseItem(CANCEL_SELECTED);

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='order in ctrl.orders']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        sendKeysById("container.order.edit.cancellation-reason", String.format("This order is canceled by automation to test 'Cancel Selected' feature on All Orders page. Canceled at %s.", CREATED_DATE_SDF.format(new Date())));

        if(listOfActualTrackingIds.size()==1)
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.cancel-order");
        }
        else
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.cancel-orders");
        }

        waitUntilInvisibilityOfToast("updated");
    }

    public void openFiltersForm()
    {
        clickButtonByAriaLabel("Edit Conditions");
    }

    public void resumeSelected(List<String> listOfExpectedTrackingId)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        applyActionsMenu.chooseItem(RESUME_SELECTED);

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='order in ctrl.orders']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        if(listOfActualTrackingIds.size()==1)
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.resume-order");
        }
        else
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.resume-orders");
        }

        waitUntilInvisibilityOfToast("updated");
    }

    public void pullOutFromRoute(List<String> listOfExpectedTrackingId)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        applyActionsMenu.chooseItem(PULL_FROM_ROUTE);

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='processedTransactionData in ctrl.processedTransactionsData']/td[@ng-if='ctrl.settings.showTrackingId']");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.pull-orders-from-routes");
        waitUntilInvisibilityOfToast("updated");
    }

    public void applyActionToOrdersByTrackingId(@SuppressWarnings("unused") List<String> listOfExpectedTrackingId, AllOrdersAction action)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        applyActionsMenu.chooseItem(action);
    }

    public void verifySelectionErrorDialog(List<String> listOfExpectedTrackingId, AllOrdersAction action, List<String> expectedReasons)
    {
        waitUntilVisibilityOfMdDialogByTitle("Selection Error");

        String actualAction = getText("//div[label[text()='Process']]/p");
        assertThat("Unexpected Process", actualAction, equalToIgnoringCase(action.getName()));

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='row in ctrl.ordersValidationErrorData.errors']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        assertEquals("Unexpected number of Orders", listOfExpectedTrackingId.size(), listOfActualTrackingIds.size());
        assertThat("Expected Tracking ID not found", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        listOfWe = findElementsByXpath("//tr[@ng-repeat='row in ctrl.ordersValidationErrorData.errors']/td[2]");
        List<String> listOfFailureReason = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        assertThat("Unexpected Failure Reason", listOfFailureReason, hasItems(expectedReasons.toArray(new String[]{})));

        clickNvIconTextButtonByNameAndWaitUntilDone("commons.continue");

        String toastTopText = getToastTopText();
        String toastBottomText = getToastBottomText();
        assertEquals("Toast top text", "Unable to apply actions", toastTopText);
        assertEquals("Toast bottom text", "No valid selection", toastBottomText);
    }

    public void addToRoute(List<String> listOfExpectedTrackingId, long routeId)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        applyActionsMenu.chooseItem(ADD_TO_ROUTE);

        List<WebElement> listOfWe = findElementsByXpath("//tr[@md-virtual-repeat='order in ctrl.formData.orders']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        clickNvIconTextButtonByName("container.order.edit.set-to-all");
        sendKeysById("container.order.edit.route", String.valueOf(routeId));
        clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.add-selected-to-routes");
        waitUntilInvisibilityOfToast("updated");
    }

    public void printWaybill(String trackingId)
    {
        filterTableOrderByTrackingId(trackingId);
        clickActionButtonOnTable(1, ACTION_BUTTON_PRINT_WAYBILL_ON_TABLE_ORDER);
        waitUntilInvisibilityOfToast("Attempting to download");
        waitUntilInvisibilityOfToast("Downloading");
    }

    public void verifyWaybillContentsIsCorrect(Order order)
    {
        editOrderPage.verifyAirwayBillContentsIsCorrect(order);
    }

    public void verifyDeliveryTimingIsUpdatedSuccessfully(ChangeDeliveryTiming changeDeliveryTiming)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();

        try
        {
            searchTrackingId(changeDeliveryTiming.getTrackingId());
            switchToNewOpenedWindow(mainWindowHandle);
            editOrderPage.waitUntilInvisibilityOfLoadingOrder();

            String actualStartDate = getText("//div[@id='delivery-details']//div[label/text()='Start Date / Time']/p");
            String actualEndDate = getText("//div[@id='delivery-details']//div[label/text()='End Date / Time']/p");

            String expectedStartDate = changeDeliveryTiming.getStartDate();
            String expectedEndDate = changeDeliveryTiming.getEndDate();
            String expectedStartTime = "";
            String expectedEndTime = "";
            Integer timewindow = changeDeliveryTiming.getTimewindow();

            if(timewindow==null)
            {
                actualStartDate = actualStartDate.substring(0, 10);
                actualEndDate = actualEndDate.substring(0, 10);
            }
            else
            {
                expectedStartTime = TestUtils.getStartTime(timewindow);
                expectedEndTime = TestUtils.getEndTime(timewindow);
            }

            String expectedStartDateWithTime = concatDateWithTime(expectedStartDate, expectedStartTime);
            String expectedEndDateWithTime = concatDateWithTime(expectedEndDate, expectedEndTime);

            boolean isDateEmpty = isBlank(changeDeliveryTiming.getStartDate()) || isBlank(changeDeliveryTiming.getEndDate());

            if(!isDateEmpty)
            {
                assertEquals("Start Date does not match.", expectedStartDateWithTime, actualStartDate);
                assertEquals("End Date does not match.", expectedEndDateWithTime, actualEndDate);
            }
            else
            {
                /*
                  If date is empty, check only the start/end time.
                 */
                String actualStartTime = actualStartDate.substring(11, 19);
                String actualEndTime = actualEndDate.substring(11, 19);

                assertEquals("Start Date does not match.", expectedStartDateWithTime, actualStartTime);
                assertEquals("End Date does not match.", expectedEndDateWithTime, actualEndTime);
            }
        }
        finally
        {
            closeAllWindows(mainWindowHandle);
        }
    }

    private String concatDateWithTime(String date, String time)
    {
        if(time==null)
        {
            time = "";
        }

        return (date + " " + time).trim();
    }

    public void verifyInboundIsSucceed(String trackingId)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();

        try
        {
            searchTrackingId(trackingId);
            switchToNewOpenedWindow(mainWindowHandle);
            editOrderPage.waitUntilInvisibilityOfLoadingOrder();
            editOrderPage.verifyInboundIsSucceed();
        }
        finally
        {
            closeAllWindows(mainWindowHandle);
        }
    }

    public void verifyOrderInfoAfterGlobalInbound(Order order, GlobalInboundParams globalInboundParams, Double expectedOrderCost, String expectedStatus, List<String> expectedGranularStatus, String expectedDeliveryStatus)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        Long orderId = order.getId();
        String trackingId = order.getTrackingId();
        specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, trackingId);

        try
        {
            switchToEditOrderWindow(orderId);
            editOrderPage.verifyOrderIsGlobalInboundedSuccessfully(order, globalInboundParams, expectedOrderCost, expectedStatus, expectedGranularStatus, expectedDeliveryStatus);
        }
        finally
        {
            closeAllWindows(mainWindowHandle);
        }
    }

    public void searchTrackingId(String trackingId)
    {
        specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, trackingId);
    }

    public void specificSearch(Category category, SearchLogic searchLogic, String searchTerm)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        waitUntilPageLoaded();

        selectValueFromMdSelectByIdContains("category", category.getValue());
        selectValueFromMdSelectByIdContains("search-logic", searchLogic.getValue());
        sendKeys("//input[starts-with(@id, 'fl-input') or starts-with(@id, 'searchTerm')]", searchTerm);
        pause2s(); // Wait until the page finished matching the tracking ID.
        String matchedTrackingIdXpathExpression = String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope//span[text()='%s']", searchTerm);
        String searchButtonXpathExpression = "//nv-api-text-button[@name='commons.search']";

        if(isElementExistFast(matchedTrackingIdXpathExpression))
        {
            click(matchedTrackingIdXpathExpression);
            waitUntilNewWindowOrTabOpened();
        }
        else
        {
            click(searchButtonXpathExpression);
        }

        pause100ms();
        getWebDriver().switchTo().window(mainWindowHandle); // Force selenium to go back to the last active tab/window if new tab/window is opened.
        waitUntilInvisibilityOfElementLocated(searchButtonXpathExpression + "/button/div[contains(@class,'show')]/md-progress-circular");
    }

    public void filterTableOrderByTrackingId(String trackingId)
    {
        searchTableCustom1("tracking-id", trackingId);
    }

    public void clearFilterTableOrderByTrackingId()
    {
        clearSearchTableCustom1("tracking-id");
    }

    public void switchToEditOrderWindow(Long orderId)
    {
        switchToOtherWindow("order/" + orderId);
        editOrderPage.waitUntilInvisibilityOfLoadingOrder();
    }

    public void switchToNewOpenedWindow(String mainWindowHandle)
    {
        Set<String> windowHandles = retryIfRuntimeExceptionOccurred(() ->
        {
            pause100ms();
            Set<String> windowHandlesTemp = getWebDriver().getWindowHandles();

            if(windowHandlesTemp.size()<=1)
            {
                throw new RuntimeException("WebDriver only contains 1 Window.");
            }

            return windowHandlesTemp;
        });

        String newOpenedWindowHandle = null;

        for(String windowHandle : windowHandles)
        {
            if(!windowHandle.equals(mainWindowHandle))
            {
                newOpenedWindowHandle = windowHandle; // Do not break, because we need to get the latest one.
            }
        }

        getWebDriver().switchTo().window(newOpenedWindowHandle);
    }

    public String getTextOnTableOrder(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT_TABLE_ORDER);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT_TABLE_ORDER);
    }

    /**
     * Accessor for Apply Action menu
     */
    public static class ApplyActionsMenu extends OperatorV2SimplePage
    {
        public enum AllOrdersAction
        {
            SET_RTS_TO_SELECTED("Set RTS to Selected"),
            CANCEL_SELECTED("Cancel Selected"),
            RESUME_SELECTED("Resume Selected"),
            MANUALLY_COMPLETE_SELECTED("Manually Complete Selected"),
            PULL_FROM_ROUTE("Pull from Route"),
            ADD_TO_ROUTE("Add To Route");

            private String name;

            public String getName()
            {
                return name;
            }

            AllOrdersAction(String name)
            {
                this.name = name;
            }
        }

        private static final String PARENT_MENU_NAME = "Apply Action";

        public ApplyActionsMenu(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void chooseItem(AllOrdersAction action)
        {
            clickMdMenuItem(PARENT_MENU_NAME, action.getName());
        }
    }
}
