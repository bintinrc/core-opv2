package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.model.ChangeDeliveryTiming;
import co.nvqa.operator_v2.util.TestUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.File;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author Tristania Siagian
 */
public class AllOrdersPage extends SimplePage
{
    private static final String SAMPLE_CSV_FILENAME = "find-orders-with-csv.csv";

    private static final String MD_VIRTUAL_REPEAT_TABLE_ORDER = "order in getTableData()";
    public static final String COLUMN_CLASS_TRACKING_ID_ON_TABLE_ORDER = "tracking-id";
    public static final String COLUMN_CLASS_FROM_NAME_ON_TABLE_ORDER = "from-name";
    public static final String COLUMN_CLASS_FROM_CONTACT_ON_TABLE_ORDER = "from-contact";
    public static final String COLUMN_CLASS_FROM_ADDRESS_ON_TABLE_ORDER = "_from-address";
    public static final String COLUMN_CLASS_FROM_POSTCODE_ON_TABLE_ORDER = "from-postcode";
    public static final String COLUMN_CLASS_TO_NAME_ON_TABLE_ORDER = "to-name";
    public static final String COLUMN_CLASS_TO_CONTACT_ON_TABLE_ORDER = "to-contact";
    public static final String COLUMN_CLASS_TO_ADDRESS_ON_TABLE_ORDER = "_to-address";
    public static final String COLUMN_CLASS_TO_POSTCODE_ON_TABLE_ORDER = "to-postcode";
    public static final String COLUMN_CLASS_GRANULAR_STATUS_ON_TABLE_ORDER = "_granular-status";


    private static final String NG_REPEAT_TABLE_EVENT = "event in getTableData()";
    public static final String COLUMN_CLASS_NAME_ON_TABLE_EVENT = "name";

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

    public AllOrdersPage(WebDriver webDriver)
    {
        super(webDriver);
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

    public void verifyAllOrdersInCsvIsFoundWithCorrectInfo(List<OrderRequestV2> listOfOrderRequestV2, List<Order> listOfOrderDetails)
    {
        pause100ms();
        String toastTopText = getToastTopText();
        Assert.assertEquals("Toast message is different.", "Matches with file shown in table", toastTopText);
        waitUntilInvisibilityOfToast("Matches with file shown in table", false);

        for(OrderRequestV2 orderRequestV2 : listOfOrderRequestV2)
        {
            String createdOrderTrackingId = orderRequestV2.getTrackingId();
            Optional<Order> matchedOrderDetailsOptional = listOfOrderDetails.stream().filter(o -> o.getTrackingId().equals(createdOrderTrackingId)).findFirst();

            if(matchedOrderDetailsOptional.isPresent())
            {
                Order matchedOrderDetails = matchedOrderDetailsOptional.get();
                verifyOrderInfoOnTableOrderIsCorrect(orderRequestV2, matchedOrderDetails);
            }
            else
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

    public void verifyOrderInfoOnTableOrderIsCorrect(OrderRequestV2 orderRequestV2, Order order)
    {
        String trackingId = orderRequestV2.getTrackingId();
        filterTableOrderByTrackingId(trackingId);

        String actualTrackingId = getTextOnTableOrder(1, COLUMN_CLASS_TRACKING_ID_ON_TABLE_ORDER);
        String actualFromName = getTextOnTableOrder(1, COLUMN_CLASS_FROM_NAME_ON_TABLE_ORDER);
        String actualFromContact = getTextOnTableOrder(1, COLUMN_CLASS_FROM_CONTACT_ON_TABLE_ORDER);
        String actualFromAddress = getTextOnTableOrder(1, COLUMN_CLASS_FROM_ADDRESS_ON_TABLE_ORDER);
        String actualFromPostcode = getTextOnTableOrder(1, COLUMN_CLASS_FROM_POSTCODE_ON_TABLE_ORDER);
        String actualToName = getTextOnTableOrder(1, COLUMN_CLASS_TO_NAME_ON_TABLE_ORDER);
        String actualToContact = getTextOnTableOrder(1, COLUMN_CLASS_TO_CONTACT_ON_TABLE_ORDER);
        String actualToAddress = getTextOnTableOrder(1, COLUMN_CLASS_TO_ADDRESS_ON_TABLE_ORDER);
        String actualToPostcode = getTextOnTableOrder(1, COLUMN_CLASS_TO_POSTCODE_ON_TABLE_ORDER);
        String actualGranularStatus = getTextOnTableOrder(1, COLUMN_CLASS_GRANULAR_STATUS_ON_TABLE_ORDER);

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

        Assert.assertThat("Granular Status", actualGranularStatus, Matchers.equalToIgnoringCase(order.getGranularStatus().replaceFirst("_", " ")));
    }

    public void verifyOrderInfoIsCorrect(OrderRequestV2 orderRequestV2, Order order)
    {
        String mainWindowHandle = getwebDriver().getWindowHandle();
        String expectedTrackingId = orderRequestV2.getTrackingId();
        specificSearch(Category.TRACKING_OR_STAMP_ID, SearchLogic.EXACTLY_MATCHES, expectedTrackingId);

        try
        {
            switchToNewOpenedWindow(mainWindowHandle);
            waitUntilInvisibilityOfLoadingOrder();

            String actualTrackingId = getText("//label[text()='Tracking ID']/following-sibling::h3");
            String actualStatus = getText("//label[text()='Status']/following-sibling::p");
            String actualGranularStatus = getText("//label[text()='Granular']/following-sibling::p");
            String actualShipperId = getText("//label[text()='Shipper ID']/following-sibling::p");
            String actualOrderType = getText("//label[text()='Order Type']/following-sibling::p");
            String actualSize = getText("//label[text()='Size']/following-sibling::p");
            String actualWeight = getText("//label[text()='Weight']/following-sibling::p");

            Assert.assertEquals("Tracking ID", expectedTrackingId, actualTrackingId);
            Assert.assertThat("Status", actualStatus, Matchers.equalToIgnoringCase(order.getStatus()));
            Assert.assertThat("Granular Status", actualGranularStatus, Matchers.equalToIgnoringCase(order.getGranularStatus().replaceFirst("_", " ")));
            Assert.assertThat("Shipper ID", actualShipperId, Matchers.containsString(String.valueOf(orderRequestV2.getShipperId())));
            Assert.assertEquals("Order Type", orderRequestV2.getType(), actualOrderType);
            Assert.assertEquals("Size", order.getParcelSize(), actualSize);
            Assert.assertEquals("Weight", order.getWeight()+" kg", actualWeight);

            /**
             * Pickup
             */
            String actualPickupStatus = getText("//div[h5[text()='Pickup']]/following-sibling::div/h5[contains(text(), Status)]").split(":")[1].trim();
            String actualFromName = getText("//div[@id='pickup-details']/div[2]/div/div/div/div/div/h5");
            String actualFromEmail = getText("//div[@id='pickup-details']/div[2]/div/div/div[2]/div/span");
            String actualFromContact = getText("//div[@id='pickup-details']/div[2]/div/div/div[2]/div[2]/span");
            String actualFromAddress = getText("//div[@id='pickup-details']/div[2]/div/div/div[2]/div[3]/span");

            Transaction pickupTransaction = order.getTransactions().get(0);
            Assert.assertEquals("Pickup Status", pickupTransaction.getStatus(), actualPickupStatus);
            Assert.assertEquals("From Name", orderRequestV2.getFromName(), actualFromName);
            Assert.assertEquals("From Email", orderRequestV2.getFromEmail(), actualFromEmail);
            Assert.assertEquals("From Contact", orderRequestV2.getFromContact(), actualFromContact);
            Assert.assertThat("From Address", actualFromAddress, Matchers.containsString(orderRequestV2.getFromAddress1()));
            Assert.assertThat("From Address", actualFromAddress, Matchers.containsString(orderRequestV2.getFromAddress2()));

            /**
             * Delivery
             */
            String actualDeliveryStatus = getText("//div[h5[text()='Delivery']]/following-sibling::div/h5[contains(text(), Status)]").split(":")[1].trim();
            String actualToName = getText("//div[@id='delivery-details']/div[2]/div/div/div/div/div/h5");
            String actualToEmail = getText("//div[@id='delivery-details']/div[2]/div/div/div[2]/div/span");
            String actualToContact = getText("//div[@id='delivery-details']/div[2]/div/div/div[2]/div[2]/span");
            String actualToAddress = getText("//div[@id='delivery-details']/div[2]/div/div/div[2]/div[3]/span");

            Transaction deliveryTransaction = order.getTransactions().get(1);
            Assert.assertEquals("Delivery Status", deliveryTransaction.getStatus(), actualDeliveryStatus);
            Assert.assertEquals("To Name", orderRequestV2.getToName(), actualToName);
            Assert.assertEquals("To Email", orderRequestV2.getToEmail(), actualToEmail);
            Assert.assertEquals("To Contact", orderRequestV2.getToContact(), actualToContact);
            Assert.assertThat("To Address", actualToAddress, Matchers.containsString(orderRequestV2.getToAddress1()));
            Assert.assertThat("To Address", actualToAddress, Matchers.containsString(orderRequestV2.getToAddress2()));
        }
        finally
        {
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
        }
    }

    public void verifyDeliveryTimingIsUpdatedSuccessfully(ChangeDeliveryTiming changeDeliveryTiming)
    {
        String mainWindowHandle = getwebDriver().getWindowHandle();

        try
        {
            searchTrackingId(changeDeliveryTiming.getTrackingId());
            switchToNewOpenedWindow(mainWindowHandle);
            waitUntilInvisibilityOfLoadingOrder();

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
                Assert.assertEquals("Start Date does not match.", expectedStartDateWithTime, actualStartDate);
                Assert.assertEquals("End Date does not match.", expectedEndDateWithTime, actualEndDate);
            }
            else
            {
                /**
                 * If date is empty, check only the start/end time.
                 */
                String actualStartTime = actualStartDate.substring(11, 19);
                String actualEndTime = actualEndDate.substring(11, 19);

                Assert.assertEquals("Start Date does not match.", expectedStartDateWithTime, actualStartTime);
                Assert.assertEquals("End Date does not match.", expectedEndDateWithTime, actualEndTime);
            }
        }
        finally
        {
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
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
        String mainWindowHandle = getwebDriver().getWindowHandle();

        try
        {
            searchTrackingId(trackingId);
            switchToNewOpenedWindow(mainWindowHandle);
            waitUntilVisibilityOfElementLocated("//div[text()='Edit Order']");

            pause3s();
            String actualLatestEvent = getTextOnTableEvent(1, COLUMN_CLASS_NAME_ON_TABLE_EVENT);
            Assert.assertTrue("Different Result Returned", actualLatestEvent.contains("Van Inbound Scan"));
        }
        finally
        {
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
        }
    }

    public void searchTrackingId(String trackingId)
    {
        sendKeysById("searchTerm", trackingId);
        clickNvApiTextButtonByName("commons.search");
    }

    public void specificSearch(Category category, SearchLogic searchLogic, String searchTerm)
    {
        String mainWindowHandle = getwebDriver().getWindowHandle();

        selectValueFromMdSelectById("category", category.getValue());
        selectValueFromMdSelectById("search-logic", searchLogic.getValue());
        sendKeysById("searchTerm", searchTerm);


        String searchButtonXpathExpression = String.format("//nv-api-text-button[@name='%s']", "commons.search");
        click(searchButtonXpathExpression);
        pause100ms();
        getwebDriver().switchTo().window(mainWindowHandle); // Force selenium to go back to the last active tab/window if new tab/window is opened.
        waitUntilInvisibilityOfElementLocated(searchButtonXpathExpression + "/button/div[contains(@class,'show')]/md-progress-circular");
    }

    public void filterTableOrderByTrackingId(String trackingId)
    {
        searchTableCustom1("tracking-id", trackingId);
    }

    public void switchToNewOpenedWindow(String mainWindowHandle)
    {
        Set<String> windowHandles = TestUtils.retryIfRuntimeExceptionOccurred(()->
        {
            pause100ms();
            Set<String> windowHandlesTemp = getwebDriver().getWindowHandles();

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

        getwebDriver().switchTo().window(newOpenedWindowHandle);
    }

    public void closeAllWindowsAcceptTheMainWindow(String mainWindowHandle)
    {
        Set<String> windowHandles = getwebDriver().getWindowHandles();

        for(String windowHandle : windowHandles)
        {
            if(!windowHandle.equals(mainWindowHandle))
            {
                getwebDriver().switchTo().window(windowHandle);
                getwebDriver().close();
            }
        }

        getwebDriver().switchTo().window(mainWindowHandle);
    }

    public void waitUntilInvisibilityOfLoadingOrder()
    {
        waitUntilInvisibilityOfElementLocated("//md-content[@loading-message='Loading order...']/div[contains(@class, 'loading')]");
        pause100ms();
    }

    public String getTextOnTableOrder(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT_TABLE_ORDER);
    }

    public String getTextOnTableEvent(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT_TABLE_EVENT);
    }
}
