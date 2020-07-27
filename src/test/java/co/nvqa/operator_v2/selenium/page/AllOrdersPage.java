package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.AllOrdersAction.CANCEL_SELECTED;
import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.AllOrdersAction.PULL_FROM_ROUTE;

/**
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

    @FindBy(css = "md-autocomplete[md-input-name='searchTerm']")
    public MdAutocomplete searchTerm;

    @FindBy(name = "commons.search")
    public NvApiTextButton search;

    @FindBy(name = "container.order.list.find-orders-with-csv")
    public NvIconTextButton findOrdersWithCsv;

    @FindBy(css = "[id^='category']")
    public MdSelect categorySelect;

    @FindBy(css = "[id^='search-logic']")
    public MdSelect searchLogicSelect;

    @FindBy(css = "md-dialog")
    public FindOrdersWithCsvDialog findOrdersWithCsvDialog;

    @FindBy(css = "md-dialog")
    public ManuallyCompleteOrderDialog manuallyCompleteOrderDialog;

    @FindBy(css = "md-dialog")
    public PullSelectedFromRouteDialog pullSelectedFromRouteDialog;

    @FindBy(css = "md-dialog")
    public ResumeSelectedDialog resumeSelectedDialog;

    @FindBy(css = "div.navigation md-menu")
    public MdMenu actionsMenu;

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

            for (Category enumTemp : values())
            {
                if (enumTemp.getValue().equalsIgnoreCase(value))
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

            for (SearchLogic enumTemp : values())
            {
                if (enumTemp.getValue().equalsIgnoreCase(value))
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

    public AllOrdersPage(WebDriver webDriver)
    {
        this(webDriver, new EditOrderPage(webDriver));
    }

    public AllOrdersPage(WebDriver webDriver, EditOrderPage editOrderPage)
    {
        super(webDriver);
        this.editOrderPage = editOrderPage;
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading...']");
    }

    public void verifyItsCurrentPage()
    {
        super.waitUntilPageLoaded();
        assertTrue(getWebDriver().getCurrentUrl().endsWith("/order"));
    }

    public void downloadSampleCsvFile()
    {
        findOrdersWithCsv.click();
        findOrdersWithCsvDialog.waitUntilVisible();
        findOrdersWithCsvDialog.downloadSample.click();
        findOrdersWithCsvDialog.cancel.click();
    }

    public void verifySampleCsvFileDownloadedSuccessfully()
    {
        verifyFileDownloadedSuccessfully(SAMPLE_CSV_FILENAME, "NVSGNINJA000000001\nNVSGNINJA000000002\nNVSGNINJA000000003");
    }

    public void findOrdersWithCsv(List<String> listOfTrackingId)
    {
        String csvContents = listOfTrackingId.stream().collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
        File csvFile = createFile(String.format("find-orders-with-csv_%s.csv", generateDateUniqueString()), csvContents);

        findOrdersWithCsv.click();
        findOrdersWithCsvDialog.waitUntilVisible();
        findOrdersWithCsvDialog.selectFile.setValue(csvFile);
        findOrdersWithCsvDialog.upload.clickAndWaitUntilDone();
    }

    public void verifyAllOrdersInCsvIsFoundWithCorrectInfo(List<Order> listOfCreatedOrder)
    {
        listOfCreatedOrder.forEach(this::verifyOrderInfoOnTableOrderIsCorrect);
    }

    public void verifyInvalidTrackingIdsIsFailedToFind(List<String> listOfInvalidTrackingId)
    {
        pause1s();
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
        } finally
        {
            closeAllWindows(mainWindowHandle);
        }
    }

    public void forceSuccessSingleOrder(String trackingId)
    {
        filterTableOrderByTrackingId(trackingId);
        selectAllShown("ctrl.ordersTableParam");
        actionsMenu.selectOption("Manually Complete Selected");
        manuallyCompleteOrderDialog.waitUntilVisible();
        manuallyCompleteOrderDialog.completeOrder.clickAndWaitUntilDone();
        manuallyCompleteOrderDialog.waitUntilInvisible();
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
        } finally
        {
            closeAllWindows(mainWindowHandle);
        }
    }

    public void rtsSingleOrderNextDay(String trackingId)
    {
        filterTableOrderByTrackingId(trackingId);
        selectAllShown("ctrl.ordersTableParam");
        actionsMenu.selectOption("Set RTS to Selected");
        setMdDatepickerById("commons.model.delivery-date", TestUtils.getNextDate(1));
        selectValueFromMdSelectById("commons.timeslot", "3PM - 6PM");
        clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.set-order-to-rts");
        waitUntilInvisibilityOfToast("updated");
    }

    public void rtsMultipleOrderNextDay(List<String> listOfExpectedTrackingId)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        actionsMenu.selectOption("Set RTS to Selected");

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='order in ctrl.orders']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        setMdDatepickerById("commons.model.delivery-date", TestUtils.getNextDate(1));
        selectValueFromMdSelectById("commons.timeslot", "3PM - 6PM");

        if (listOfActualTrackingIds.size() == 1)
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.set-order-to-rts");
        } else
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.set-orders-to-rts");
        }

        waitUntilInvisibilityOfToast("updated");
    }

    public void cancelSelected(List<String> listOfExpectedTrackingId)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        actionsMenu.selectOption(CANCEL_SELECTED.getName());

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='order in ctrl.orders']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        sendKeysById("container.order.edit.cancellation-reason", String.format("This order is canceled by automation to test 'Cancel Selected' feature on All Orders page. Canceled at %s.", CREATED_DATE_SDF.format(new Date())));

        if (listOfActualTrackingIds.size() == 1)
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.cancel-order");
        } else
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
        actionsMenu.selectOption("Resume Selected");

        resumeSelectedDialog.waitUntilVisible();
        List<String> listOfActualTrackingIds = resumeSelectedDialog.trackingIds.stream().map(PageElement::getText).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        if (listOfActualTrackingIds.size() == 1)
        {
            resumeSelectedDialog.resumeOrder.clickAndWaitUntilDone();
        } else
        {
            resumeSelectedDialog.resumeOrders.clickAndWaitUntilDone();
        }
        resumeSelectedDialog.waitUntilInvisible();
        waitUntilInvisibilityOfToast("updated");
    }

    public void pullOutFromRoute(List<String> listOfExpectedTrackingId)
    {
        applyActionToOrdersByTrackingId(listOfExpectedTrackingId, PULL_FROM_ROUTE);
        pullSelectedFromRouteDialog.waitUntilVisible();
        pullSelectedFromRouteDialog.pullOrdersFromRoutes.clickAndWaitUntilDone();
        pullSelectedFromRouteDialog.waitUntilInvisible();
        waitUntilInvisibilityOfToast("updated");
    }

    public void pullOutFromRouteWithExpectedSelectionError(List<String> listOfExpectedTrackingId)
    {
        applyActionToOrdersByTrackingId(listOfExpectedTrackingId, PULL_FROM_ROUTE);
        pullSelectedFromRouteDialog.waitUntilVisible();
        selectTypeFromPullSelectedFromRouteDialog(listOfExpectedTrackingId, "Delivery");
        pullSelectedFromRouteDialog.pullOrdersFromRoutes.clickAndWaitUntilDone();
    }

    public void selectTypeFromPullSelectedFromRouteDialog(List<String> listOfExpectedTrackingId, String type)
    {
        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='processedTransactionData in ctrl.processedTransactionsData']/td[@ng-if='ctrl.settings.showTrackingId']");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, hasItems(listOfExpectedTrackingId.toArray(new String[]{})));
    }

    public void applyActionToOrdersByTrackingId(@SuppressWarnings("unused") List<String> listOfExpectedTrackingId, AllOrdersAction action)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        actionsMenu.selectOption(action.getName());
    }

    public void verifySelectionErrorDialog(List<String> listOfExpectedTrackingId, AllOrdersAction action, List<String> expectedReasons)
    {
        WebElement failedToUpdateWe = findElementByXpath("//div[contains(text(), 'Failed to update')]");
        assertNotNull("Failed to update n item(s) dialog not found.", failedToUpdateWe);
        pause3s();

        //To-Do: Enable this codes below when they fix the UI.
//        Pattern p = Pattern.compile("([^\\s]+)\\s?.*Message:(.+)].*");
//        List<String> errors = pullSelectedFromRouteDialog.errors.stream().map(PageElement::getText).collect(Collectors.toList());
//        assertEquals("Unexpected number of Orders", listOfExpectedTrackingId.size(), errors.size());
//        assertThat("Expected Tracking ID not found", errors, hasItems(errors.stream().map(error ->
//        {
//            Matcher m = p.matcher(error);
//            if (m.find())
//            {
//                return m.group(1);
//            } else
//            {
//                return null;
//            }
//        }).toArray(String[]::new)));
//
//        assertThat("Expected Error Message not found", errors, hasItems(errors.stream().map(error ->
//        {
//            Matcher m = p.matcher(error);
//            if (m.find())
//            {
//                return m.group(2);
//            } else
//            {
//                return null;
//            }
//        }).toArray(String[]::new)));

        pullSelectedFromRouteDialog.close.click();
        pullSelectedFromRouteDialog.waitUntilInvisible();
    }

    public void addToRoute(List<String> listOfExpectedTrackingId, long routeId)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        actionsMenu.selectOption(AllOrdersAction.ADD_TO_ROUTE.getName());

        List<WebElement> listOfWe = findElementsByXpath("//div[@md-virtual-repeat='order in ctrl.formData.orders']/div[@class='table-tracking-id']");
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

    private String concatDateWithTime(String date, String time)
    {
        if (time == null)
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
        } finally
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
        } finally
        {
            closeAllWindows(mainWindowHandle);
        }
    }

    public void searchTrackingId(String trackingId)
    {
        specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, trackingId);
    }

    public void verifiesTrackingIdIsCorrect(String trackingId)
    {
        String actualTrackingId = getText("//div[@id='header']//label[text()='Tracking ID']/following-sibling::h3");
        assertEquals("Tracking ID is Not the same: ", actualTrackingId, trackingId);
    }

    public void specificSearch(Category category, SearchLogic searchLogic, String searchTerm)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        waitUntilPageLoaded();

        categorySelect.selectValue(category.getValue());
        searchLogicSelect.selectValue(searchLogic.getValue());
        try
        {
            this.searchTerm.selectValue(searchTerm);
            waitUntilNewWindowOrTabOpened();
        } catch (NoSuchElementException ex)
        {
            search.click();
        }

        pause100ms();
        getWebDriver().switchTo().window(mainWindowHandle); // Force selenium to go back to the last active tab/window if new tab/window is opened.
        search.waitUntilDone();
    }

    public void specificSearch(Category category, SearchLogic searchLogic, String searchTerm, String trackingId)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        waitUntilPageLoaded();

        selectValueFromMdSelectByIdContains("category", category.getValue());
        selectValueFromMdSelectByIdContains("search-logic", searchLogic.getValue());
        sendKeys("//input[starts-with(@id, 'fl-input') or starts-with(@id, 'searchTerm')]", searchTerm);
        pause3s(); // Wait until the page finished matching the tracking ID.
        String matchedTrackingIdXpathExpression = String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope//span[text()='%s']", trackingId);
        String searchButtonXpathExpression = "//nv-api-text-button[@name='commons.search']";

        if (isElementExistFast(matchedTrackingIdXpathExpression))
        {
            click(matchedTrackingIdXpathExpression);
            waitUntilNewWindowOrTabOpened();
        } else
        {
            click(searchButtonXpathExpression);
        }

        pause100ms();
        getWebDriver().switchTo().window(mainWindowHandle); // Force selenium to go back to the last active tab/window if new tab/window is opened.
        waitUntilInvisibilityOfElementLocated(searchButtonXpathExpression + "/button/div[contains(@class,'show')]/md-progress-circular");
    }

    public void searchWithoutResult(Category category, SearchLogic searchLogic, String searchTerm)
    {
        waitUntilPageLoaded();
        selectValueFromMdSelectByIdContains("category", category.getValue());
        selectValueFromMdSelectByIdContains("search-logic", searchLogic.getValue());
        sendKeys("//input[starts-with(@id, 'fl-input') or starts-with(@id, 'searchTerm')]", searchTerm);
        pause3s(); // Wait until the page finished matching the tracking ID.
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.search");
        Actions actions = new Actions(getWebDriver());
        actions.sendKeys(Keys.ESCAPE).build().perform();
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.search");
        pause100ms();
        waitUntilVisibilityOfElementLocated("//div[@ng-message='noResult']");
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

            if (windowHandlesTemp.size() <= 1)
            {
                throw new RuntimeException("WebDriver only contains 1 Window.");
            }

            return windowHandlesTemp;
        });

        String newOpenedWindowHandle = null;

        for (String windowHandle : windowHandles)
        {
            if (!windowHandle.equals(mainWindowHandle))
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

    public void verifyLatestEvent(Order order, String latestEvent)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        Long orderId = order.getId();
        String trackingId = order.getTrackingId();
        specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, trackingId);

        try
        {
            switchToEditOrderWindow(orderId);
            String xpath = "//label[text()='Latest Event']/following-sibling::h3";
            String actualLatestEvent = getText(xpath);
            assertEquals("Latest Event is not the same", latestEvent.toLowerCase(), actualLatestEvent.toLowerCase());
        } finally
        {
            closeAllWindows(mainWindowHandle);
        }
    }

    public static class FindOrdersWithCsvDialog extends MdDialog
    {
        @FindBy(css = "[label='Select File']")
        public NvButtonFilePicker selectFile;

        @FindBy(xpath = ".//a[text()='here']")
        public Button downloadSample;

        @FindBy(name = "commons.upload")
        public NvButtonSave upload;

        @FindBy(name = "commons.cancel")
        public NvIconTextButton cancel;

        public FindOrdersWithCsvDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }
    }

    public static class ManuallyCompleteOrderDialog extends MdDialog
    {
        @FindBy(name = "container.order.edit.complete-order")
        public NvApiTextButton completeOrder;

        public ManuallyCompleteOrderDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }
    }

    public static class PullSelectedFromRouteDialog extends MdDialog
    {
        @FindBy(name = "container.order.edit.pull-orders-from-routes")
        public NvApiTextButton pullOrdersFromRoutes;

        @FindBy(xpath = "//nv-icon-text-button[@name='Close']")
        public NvIconTextButton close;

        @FindBy(xpath = "//div[@ng-repeat='error in ctrl.payload.errors track by $index']")
        public List<PageElement> errors;

        public PullSelectedFromRouteDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }
    }

    public static class ResumeSelectedDialog extends MdDialog
    {
        @FindBy(xpath = ".//tr[@ng-repeat='order in ctrl.orders']/td")
        public List<PageElement> trackingIds;

        @FindBy(name = "container.order.edit.resume-order")
        public NvApiTextButton resumeOrder;

        @FindBy(name = "container.order.edit.resume-orders")
        public NvApiTextButton resumeOrders;

        public ResumeSelectedDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }
    }
}
