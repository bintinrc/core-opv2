package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import co.nvqa.commons.model.pdf.AirwayBill;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.PdfUtils;
import co.nvqa.operator_v2.model.ChangeDeliveryTiming;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.AllOrdersPage.ApplyActionsMenu.AllOrdersAction.*;

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

    private final EditOrderPage editOrderPage;

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

    public ApplyActionsMenu applyActionsMenu;

    public AllOrdersPage(WebDriver webDriver)
    {
        this(webDriver, new EditOrderPage(webDriver));
    }

    public AllOrdersPage(WebDriver webDriver, EditOrderPage editOrderPage)
    {
        super(webDriver);
        this.editOrderPage = editOrderPage;
        applyActionsMenu = new ApplyActionsMenu(webDriver);
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
        waitUntilInvisibilityOfElementLocated("//div[@id='toast-container']");
    }

    public void verifyAllOrdersInCsvIsFoundWithCorrectInfo(List<OrderRequestV2> listOfOrderRequestV2, List<Order> listOfOrderDetails)
    {
        pause100ms();
        String toastTopText = getToastTopText();
        Assert.assertEquals("Toast message is different.", "Matches with file shown in table", toastTopText);
        waitUntilInvisibilityOfToast("Matches with file shown in table", false);

        for (OrderRequestV2 orderRequestV2 : listOfOrderRequestV2)
        {
            String createdOrderTrackingId = orderRequestV2.getTrackingId();
            Optional<Order> matchedOrderDetailsOptional = listOfOrderDetails.stream().filter(o -> o.getTrackingId().equals(createdOrderTrackingId)).findFirst();

            if (matchedOrderDetailsOptional.isPresent())
            {
                Order matchedOrderDetails = matchedOrderDetailsOptional.get();
                verifyOrderInfoOnTableOrderIsCorrect(orderRequestV2, matchedOrderDetails);
            } else
            {
                throw new NvTestRuntimeException(String.format("Order details for Tracking ID = '%s' not found.", createdOrderTrackingId));
            }
        }
    }

    public void verifyInvalidTrackingIdsIsFailedToFind(List<String> listOfInvalidTrackingId)
    {
        List<WebElement> listOfWe = findElementsByXpath("//div[@ng-repeat='error in ctrl.payload.errors track by $index']");
        List<String> listOfActualInvalidTrackingId = listOfWe.stream().map(we -> we.getText().split("\\.")[1].trim()).collect(Collectors.toList());
        Assert.assertThat("Expected Tracking ID not found.", listOfActualInvalidTrackingId, Matchers.hasItems(listOfInvalidTrackingId.toArray(new String[]{})));
    }

    public void verifyOrderStatus(String trackingId, String expectedOrderStatus)
    {
        filterTableOrderByTrackingId(trackingId);
        String actualGranularStatus = getTextOnTableOrder(1, COLUMN_CLASS_DATA_GRANULAR_STATUS_ON_TABLE_ORDER);
        Assert.assertThat("Granular Status", actualGranularStatus, Matchers.equalToIgnoringCase(expectedOrderStatus));
    }

    public void verifyOrderInfoOnTableOrderIsCorrect(OrderRequestV2 orderRequestV2, Order order)
    {
        String trackingId = orderRequestV2.getTrackingId();
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

        Assert.assertEquals("Tracking ID", trackingId, actualTrackingId);

        Assert.assertEquals("From Name", orderRequestV2.getFromName(), actualFromName);
        Assert.assertEquals("From Contact", orderRequestV2.getFromContact(), actualFromContact);
        Assert.assertThat("From Address", actualFromAddress, Matchers.containsString(orderRequestV2.getFromAddress1()));
        Assert.assertThat("From Address", actualFromAddress, Matchers.containsString(orderRequestV2.getFromAddress2()));
        Assert.assertEquals("From Postcode", orderRequestV2.getFromPostcode(), actualFromPostcode);

        Assert.assertEquals("To Name", orderRequestV2.getToName(), actualToName);
        Assert.assertEquals("To Contact", orderRequestV2.getToContact(), actualToContact);
        Assert.assertThat("To Address", actualToAddress, Matchers.containsString(orderRequestV2.getToAddress1()));
        Assert.assertThat("To Address", actualToAddress, Matchers.containsString(orderRequestV2.getToAddress2()));
        Assert.assertEquals("To Postcode", orderRequestV2.getToPostcode(), actualToPostcode);

        Assert.assertThat("Granular Status", actualGranularStatus, Matchers.equalToIgnoringCase(order.getGranularStatus().replaceAll("_", " ")));
    }

    public void verifyOrderInfoIsCorrect(OrderRequestV2 orderRequestV2, Order order)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        Long orderId = TestUtils.getOrderId(orderRequestV2);
        String expectedTrackingId = orderRequestV2.getTrackingId();
        specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, expectedTrackingId);

        try
        {
            switchToEditOrderWindow(orderId);
            editOrderPage.waitUntilInvisibilityOfLoadingOrder();
            editOrderPage.verifyOrderInfoIsCorrect(orderRequestV2, order);
        } finally
        {
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
        }
    }

    public void forceSuccessSingleOrder(String trackingId)
    {
        filterTableOrderByTrackingId(trackingId);
        selectAllShown("ctrl.ordersTableParam");
        applyActionsMenu.chooseItem(MANUALLY_COMPLETE_SELECTED);
        waitUntilVisibilityOfElementLocated("//md-dialog//div[contains(text(), \"Proceed to set the order status to 'Completed'?\")]");
        clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.complete-order");
        waitUntilInvisibilityOfToast("The order has been completed");
    }

    public void verifyOrderIsForceSuccessedSuccessfully(OrderRequestV2 orderRequestV2)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        Long orderId = TestUtils.getOrderId(orderRequestV2);
        String trackingId = orderRequestV2.getTrackingId();
        specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, trackingId);

        try
        {
            switchToEditOrderWindow(orderId);
            editOrderPage.waitUntilInvisibilityOfLoadingOrder();
            editOrderPage.verifyOrderIsForceSuccessedSuccessfully(orderRequestV2);
        } finally
        {
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
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
        Assert.assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, Matchers.hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

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
        applyActionsMenu.chooseItem(RESUME_SELECTED);

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='order in ctrl.orders']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        Assert.assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, Matchers.hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        if (listOfActualTrackingIds.size() == 1)
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.resume-order");
        } else
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
        Assert.assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, Matchers.hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.pull-orders-from-routes");
        waitUntilInvisibilityOfToast("updated");
    }

    public void applyActionToOrdersByTrackingId(List<String> listOfExpectedTrackingId, AllOrdersAction action)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        applyActionsMenu.chooseItem(action);
    }

    public void verifySelectionErrorDialog(List<String> listOfExpectedTrackingId, AllOrdersAction action, List<String> expectedReasons)
    {
        waitUntilVisibilityOfMdDialogByTitle("Selection Error");

        String actualAction = getText("//div[label[text()='Process']]/p");
        Assert.assertThat("Unexpected Process", actualAction, Matchers.equalToIgnoringCase(action.getName()));

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='row in ctrl.ordersValidationErrorData.errors']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        Assert.assertEquals("Unexpected number of Orders", listOfExpectedTrackingId.size(), listOfActualTrackingIds.size());
        Assert.assertThat("Expected Tracking ID not found", listOfActualTrackingIds, Matchers.hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

        listOfWe = findElementsByXpath("//tr[@ng-repeat='row in ctrl.ordersValidationErrorData.errors']/td[2]");
        List<String> listOfFailureReason = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        Assert.assertThat("Unexpected Failure Reason", listOfFailureReason, Matchers.hasItems(expectedReasons.toArray(new String[]{})));

        clickNvIconTextButtonByNameAndWaitUntilDone("commons.continue");

        String toastTopText = getToastTopText();
        String toastBottomText = getToastBottomText();
        Assert.assertEquals("Toast top text", "Unable to apply actions", toastTopText);
        Assert.assertEquals("Toast bottom text", "No valid selection", toastBottomText);
    }

    public void addToRoute(List<String> listOfExpectedTrackingId, long routeId)
    {
        clearFilterTableOrderByTrackingId();
        selectAllShown("ctrl.ordersTableParam");
        applyActionsMenu.chooseItem(ADD_TO_ROUTE);

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='order in ctrl.formData.orders']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        Assert.assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, Matchers.hasItems(listOfExpectedTrackingId.toArray(new String[]{})));

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

    public void verifyWaybillContentsIsCorrect(OrderRequestV2 orderRequestV2)
    {
        String trackingId = orderRequestV2.getTrackingId();
        String latestFilenameOfDownloadedPdf = getLatestDownloadedFilename("awb_" + trackingId);
        verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
        AirwayBill airwayBill = PdfUtils.getOrderInfoFromAirwayBill(TestConstants.TEMP_DIR + latestFilenameOfDownloadedPdf, 0);

        Assert.assertEquals("Tracking ID", trackingId, airwayBill.getTrackingId());

        Assert.assertEquals("From Name", orderRequestV2.getFromName(), airwayBill.getFromName());
        Assert.assertEquals("From Contact", orderRequestV2.getFromContact(), airwayBill.getFromContact());
        Assert.assertThat("From Address", airwayBill.getFromAddress(), Matchers.containsString(orderRequestV2.getFromAddress1()));
        Assert.assertThat("From Address", airwayBill.getFromAddress(), Matchers.containsString(orderRequestV2.getFromAddress2()));
        Assert.assertThat("Postcode In From Address", airwayBill.getFromAddress(), Matchers.containsString(orderRequestV2.getFromPostcode()));

        Assert.assertEquals("To Name", orderRequestV2.getToName(), airwayBill.getToName());
        Assert.assertEquals("To Contact", orderRequestV2.getToContact(), airwayBill.getToContact());
        Assert.assertThat("To Address", airwayBill.getToAddress(), Matchers.containsString(orderRequestV2.getToAddress1()));
        Assert.assertThat("To Address", airwayBill.getToAddress(), Matchers.containsString(orderRequestV2.getToAddress2()));
        Assert.assertThat("Postcode In To Address", airwayBill.getToAddress(), Matchers.containsString(orderRequestV2.getToPostcode()));

        Assert.assertEquals("COD", orderRequestV2.getCodGoods(), airwayBill.getCod());
        Assert.assertEquals("Comments", orderRequestV2.getInstruction(), airwayBill.getComments());

        String actualQrCodeTrackingId = TestUtils.getTextFromQrCodeImage(airwayBill.getTrackingIdQrCodeFile());
        Assert.assertEquals("Tracking ID - QR Code", trackingId, actualQrCodeTrackingId);

        String actualBarcodeTrackingId = TestUtils.getTextFromQrCodeImage(airwayBill.getTrackingIdBarcodeFile());
        Assert.assertEquals("Tracking ID - Barcode 128", trackingId, actualBarcodeTrackingId);
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

            if (timewindow == null)
            {
                actualStartDate = actualStartDate.substring(0, 10);
                actualEndDate = actualEndDate.substring(0, 10);
            } else
            {
                expectedStartTime = TestUtils.getStartTime(timewindow);
                expectedEndTime = TestUtils.getEndTime(timewindow);
            }

            String expectedStartDateWithTime = concatDateWithTime(expectedStartDate, expectedStartTime);
            String expectedEndDateWithTime = concatDateWithTime(expectedEndDate, expectedEndTime);

            boolean isDateEmpty = isBlank(changeDeliveryTiming.getStartDate()) || isBlank(changeDeliveryTiming.getEndDate());

            if (!isDateEmpty)
            {
                Assert.assertEquals("Start Date does not match.", expectedStartDateWithTime, actualStartDate);
                Assert.assertEquals("End Date does not match.", expectedEndDateWithTime, actualEndDate);
            } else
            {
                /*
                  If date is empty, check only the start/end time.
                 */
                String actualStartTime = actualStartDate.substring(11, 19);
                String actualEndTime = actualEndDate.substring(11, 19);

                Assert.assertEquals("Start Date does not match.", expectedStartDateWithTime, actualStartTime);
                Assert.assertEquals("End Date does not match.", expectedEndDateWithTime, actualEndTime);
            }
        } finally
        {
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
        }
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
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
        }
    }

    public void verifyOrderInfoAfterGlobalInbound(OrderRequestV2 orderRequestV2, GlobalInboundParams globalInboundParams, Double expectedOrderCost, String expectedStatus, List<String> expectedGranularStatus, String expectedDeliveryStatus)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        Long orderId = TestUtils.getOrderId(orderRequestV2);
        String trackingId = orderRequestV2.getTrackingId();
        specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, trackingId);

        try
        {
            switchToEditOrderWindow(orderId);
            editOrderPage.waitUntilInvisibilityOfLoadingOrder();
            editOrderPage.verifyOrderIsGlobalInboundedSuccessfully(orderRequestV2, globalInboundParams, expectedOrderCost, expectedStatus, expectedGranularStatus, expectedDeliveryStatus);
        } finally
        {
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
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
        sendKeysById("fl-input", searchTerm);
        pause2s(); // Wait until the page finished matching the tracking ID.
        String matchedTrackingIdXpathExpression = String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope//span[text()='%s']", searchTerm);
        String searchButtonXpathExpression = "//nv-api-text-button[@name='commons.search']";

        ////div[contains(@ng-messages, 'ctrl.specificSearch.form.searchTerm.$error')]/div[text()='No Results Found']

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
    }

    public void switchToNewOpenedWindow(String mainWindowHandle)
    {
        Set<String> windowHandles = TestUtils.retryIfRuntimeExceptionOccurred(() ->
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
