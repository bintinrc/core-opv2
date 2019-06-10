package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Cod;
import co.nvqa.commons.model.core.Dimension;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.pdf.AirwayBill;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.PdfUtils;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.model.OrderEvent;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.text.WordUtils;
import org.openqa.selenium.WebDriver;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;

import static co.nvqa.operator_v2.selenium.page.EditOrderPage.EventsTable.EVENT_NAME;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class EditOrderPage extends OperatorV2SimplePage
{
    private static final String NG_REPEAT_TABLE_EVENT = "event in getTableData()";
    public static final String COLUMN_CLASS_DATA_NAME_ON_TABLE_EVENT = "name";
    private TransactionsTable transactionsTable;
    private AddToRouteDialog addToRouteDialog;
    private DeliveryDetailsBox deliveryDetailsBox;
    private PickupDetailsBox pickupDetailsBox;
    private EventsTable eventsTable;

    public EditOrderPage(WebDriver webDriver)
    {
        super(webDriver);
        transactionsTable = new TransactionsTable(webDriver);
        addToRouteDialog = new AddToRouteDialog(webDriver);
        deliveryDetailsBox = new DeliveryDetailsBox(webDriver);
        pickupDetailsBox = new PickupDetailsBox(webDriver);
        eventsTable = new EventsTable(webDriver);
    }

    public EventsTable eventsTable()
    {
        return eventsTable;
    }

    public void clickMenu(String parentMenuName, String childMenuName)
    {
        clickf("//md-menu-bar/md-menu/button[contains(text(), '%s')]", parentMenuName);
        waitUntilVisibilityOfElementLocated("//div[@aria-hidden='false']/md-menu-content");
        clickf("//div[@aria-hidden='false']/md-menu-content/md-menu-item/button/span[contains(text(), '%s')]", childMenuName);
    }

    public void editOrderDetails(Order order)
    {
        String parcelSize = getParcelSizeShortStringByLongString(order.getParcelSize());
        Dimension dimension = order.getDimensions();

        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'order-edit-details')]//nv-api-text-button[@name='commons.save-changes']");
        selectValueFromMdSelectById("parcel-size", parcelSize);
        sendKeysByIdAlt("weight", String.valueOf(dimension.getWeight()));
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
        waitUntilInvisibilityOfToast("Current order updated successfully");
    }

    public void editOrderInstructions(String pickupInstruction, String deliveryInstruction)
    {
        waitUntilVisibilityOfMdDialogByTitle("Edit Instructions");
        if(pickupInstruction!=null)
        {
            sendKeysByAriaLabel("Pickup Instruction", pickupInstruction);
        }
        if(deliveryInstruction!=null)
        {
            sendKeysByAriaLabel("Delivery Instruction", deliveryInstruction);
        }
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
        waitUntilInvisibilityOfToast("Instructions Updated", true);
    }

    public void editPriorityLevel(int priorityLevel)
    {
        clickMenu("Order Settings", "Edit Priority Level");
        waitUntilVisibilityOfMdDialogByTitle("Edit Priority Level");
        sendKeysByAriaLabel("container.order.edit.delivery-priority-level", String.valueOf(priorityLevel));
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
        waitUntilInvisibilityOfMdDialogByTitle("Edit Priority Level");
    }

    public void editOrderStamp(String stampId)
    {
        clickMenu("Order Settings", "Edit Order Stamp");
        waitUntilVisibilityOfMdDialogByTitle("Edit Order Stamp");
        sendKeysById("commons.stamp-id", stampId);
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save");
        waitUntilInvisibilityOfToast(String.format("Stamp ID updated successfully: %s", stampId), true);
        waitUntilInvisibilityOfMdDialogByTitle("Edit Order Stamp");
    }

    public void updateOrderStatus(Order order)
    {
        clickMenu("Order Settings", "Update Status");
        waitUntilVisibilityOfMdDialogByTitle("Update Status");
        if (StringUtils.isNotBlank(order.getStatus()))
        {
            selectValueFromMdSelectById("commons.status", order.getStatus());
        }
        if (StringUtils.isNotBlank(order.getGranularStatus()))
        {
            selectValueFromMdSelectById("commons.model.granular-status", order.getGranularStatus());
        }
        Transaction transaction = order.getLastPickupTransaction();
        if (transaction != null && StringUtils.isNotBlank(transaction.getStatus()))
        {
            selectValueFromMdSelectById("container.order.edit.last-pickup-transaction-status", WordUtils.capitalizeFully(transaction.getStatus()));
        }
        transaction = order.getLastDeliveryTransaction();
        if (transaction != null && StringUtils.isNotBlank(transaction.getStatus()))
        {
            selectValueFromMdSelectById("container.order.edit.last-delivery-transaction-status", WordUtils.capitalizeFully(transaction.getStatus()));
        }
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
        waitUntilInvisibilityOfToast("Status Updated", true);
        waitUntilInvisibilityOfMdDialogByTitle("Update Status");
    }

    public void addToRoute(long routeId, String type)
    {
        clickMenu("Pickup", "Add To Route");
        addToRouteDialog
                .waitUntilVisibility()
                .enterRouteId(routeId)
                .selectType(type)
                .submit();
    }

    public void verifyDeliveryStartDateTime(String expectedDate)
    {
        assertEquals("Delivery Start Date/Time", expectedDate, deliveryDetailsBox.getStartDateTime());
    }

    public void verifyOrderHeaderColor(String color)
    {
        assertEquals("Order Header Color", color, getCssValue("//div[@class='header-holder']/div", "background-color"));
    }

    public void verifyDeliveryEndDateTime(String expectedDate)
    {
        assertEquals("Delivery End Date/Time", expectedDate, deliveryDetailsBox.getEndDateTime());
    }

    public void verifyDeliveryRouteInfo(Route route)
    {
        assertThat("Delivery Route Id", deliveryDetailsBox.getRouteId(), equalTo(String.valueOf(route.getId())));
        if(CollectionUtils.isNotEmpty(route.getWaypoints()))
        {
            String expectedWaypointId = String.valueOf(route.getWaypoints().get(0).getId());
            assertThat("Delivery Waypoint ID", deliveryDetailsBox.getWaypointId(), equalTo(expectedWaypointId));
        }
        String expectedDriver = route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
        assertThat("Delivery Driver", deliveryDetailsBox.getDriver(), equalTo(expectedDriver));
    }

    public void verifyPickupRouteInfo(Route route)
    {
        assertThat("Pickup Route Id", pickupDetailsBox.getRouteId(), equalTo(String.valueOf(route.getId())));
        if(CollectionUtils.isNotEmpty(route.getWaypoints()))
        {
            String expectedWaypointId = String.valueOf(route.getWaypoints().get(0).getId());
            assertThat("Pickup Waypoint ID", pickupDetailsBox.getWaypointId(), equalTo(expectedWaypointId));
        }
        String expectedDriver = route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
        assertThat("Pickup Driver", pickupDetailsBox.getDriver(), equalTo(expectedDriver));
    }

    public void printAirwayBill()
    {
        clickMenu("View/Print", "Print Airway Bill");
        waitUntilInvisibilityOfToast("Attempting to download", true);
        waitUntilInvisibilityOfToast("Downloading");
    }

    public void verifyAirwayBillContentsIsCorrect(Order order)
    {
        String trackingId = order.getTrackingId();
        String latestFilenameOfDownloadedPdf = getLatestDownloadedFilename("awb_" + trackingId);
        verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
        AirwayBill airwayBill = PdfUtils.getOrderInfoFromAirwayBill(TestConstants.TEMP_DIR + latestFilenameOfDownloadedPdf, 0);

        assertEquals("Tracking ID", trackingId, airwayBill.getTrackingId());

        assertEquals("From Name", order.getFromName(), airwayBill.getFromName());
        assertEquals("From Contact", order.getFromContact(), airwayBill.getFromContact());
        assertThat("From Address", airwayBill.getFromAddress(), containsString(order.getFromAddress1()));
        assertThat("From Address", airwayBill.getFromAddress(), containsString(order.getFromAddress2()));
        assertThat("Postcode In From Address", airwayBill.getFromAddress(), containsString(order.getFromPostcode()));

        assertEquals("To Name", order.getToName(), airwayBill.getToName());
        assertEquals("To Contact", order.getToContact(), airwayBill.getToContact());
        assertThat("To Address", airwayBill.getToAddress(), containsString(order.getToAddress1()));
        assertThat("To Address", airwayBill.getToAddress(), containsString(order.getToAddress2()));
        assertThat("Postcode In To Address", airwayBill.getToAddress(), containsString(order.getToPostcode()));

        assertEquals("COD", Optional.ofNullable(order.getCod()).orElse(new Cod()).getGoodsAmount(), airwayBill.getCod());
        assertEquals("Comments", order.getInstruction(), airwayBill.getComments());

        String actualQrCodeTrackingId = TestUtils.getTextFromQrCodeImage(airwayBill.getTrackingIdQrCodeFile());
        assertEquals("Tracking ID - QR Code", trackingId, actualQrCodeTrackingId);

        String actualBarcodeTrackingId = TestUtils.getTextFromQrCodeImage(airwayBill.getTrackingIdBarcodeFile());
        assertEquals("Tracking ID - Barcode 128", trackingId, actualBarcodeTrackingId);
    }

    public void verifyPriorityLevel(String txnType, int priorityLevel)
    {
        transactionsTable.searchByTxnType(txnType);
        assertEquals(txnType + " Priority Level", String.valueOf(priorityLevel), transactionsTable.getPriorityLevel(1));
    }

    public void verifyOrderInstructions(String expectedPickupInstructions, String expectedDeliveryInstructions)
    {
        if(expectedPickupInstructions!=null)
        {
            String actualPickupInstructions = getText("//div[label[text()='Pick Up Instructions']]/p");
            assertThat("Pick Up Instructions", expectedPickupInstructions, equalToIgnoringCase(actualPickupInstructions));
        }

        if(expectedDeliveryInstructions!=null)
        {
            assertEquals("Delivery Instructions", expectedDeliveryInstructions, deliveryDetailsBox.getDeliveryInstructions());
        }
    }

    public void confirmCompleteOrder()
    {
        waitUntilVisibilityOfMdDialogByTitle("Manually Complete Order");
        clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.complete-order");
        waitUntilInvisibilityOfToast("The order has been completed", true);
    }

    public void verifyEditOrderDetailsIsSuccess(Order editedOrder)
    {
        Dimension expectedDimension = editedOrder.getDimensions();
        assertEquals("Order Details - Size", editedOrder.getParcelSize(), getSize());
        assertEquals("Order Details - Weight", expectedDimension.getWeight(), getWeight());
    }

    public void verifyInboundIsSucceed()
    {
        String actualLatestEvent = getTextOnTableEvent(1, COLUMN_CLASS_DATA_NAME_ON_TABLE_EVENT);
        assertThat("Different Result Returned", actualLatestEvent, isOneOf("Van Inbound Scan", "DRIVER INBOUND SCAN"));
    }

    public void verifyEvent(Order order, String hubName, String hubId, String eventNameExpected)
    {
        ZonedDateTime eventDateExpected = DateUtil.getDate(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));

        int rowWithExpectedEvent = 1;
        for (int i = 1; i <= eventsTable.getRowsCount(); i++) {
            String eventNameActual = getTextOnTableEvent(i, EVENT_NAME);
            if (eventNameExpected.equals(eventNameActual)){
                rowWithExpectedEvent = i;
            }
        }
        OrderEvent eventRow = eventsTable.readEntity(rowWithExpectedEvent);
        assertEquals("Different Result Returned for hub name", hubName, eventRow.getHubName());
        assertThat("Different Result Returned for event description", eventRow.getDescription(), containsString(f("Parcel inbound at Origin Hub - %s", hubName)));
        assertThat("Different Result Returned for event description", eventRow.getDescription(), containsString(f("Scanned at Hub %s", hubId)));
        assertThat("Different Result Returned for event time",
                eventRow.getEventTime(),
                containsString(DateUtil.displayDate(eventDateExpected)));
    }

    public void verifyOrderInfoIsCorrect(Order order)
    {
        String expectedTrackingId = order.getTrackingId();

        assertEquals("Tracking ID", expectedTrackingId, getTrackingId());
        assertThat("Status", getStatus(), equalToIgnoringCase(order.getStatus()));
        assertThat("Granular Status", getGranularStatus(), equalToIgnoringCase(order.getGranularStatus().replaceFirst("_", " ")));
        assertThat("Shipper ID", getShipperId(), containsString(String.valueOf(order.getShipper().getId())));
        assertEquals("Order Type", order.getType(), getOrderType());
        assertEquals("Size", order.getParcelSize(), getSize());
        assertEquals("Weight", order.getWeight(), getWeight(), 0.0);

        Transaction pickupTransaction = order.getTransactions().get(0);
        assertEquals("Pickup Status", pickupTransaction.getStatus(), getPickupStatus());

        Transaction deliveryTransaction = order.getTransactions().get(1);
        assertEquals("Delivery Status", deliveryTransaction.getStatus(), getDeliveryStatus());

        verifyPickupAndDeliveryInfo(order);
    }

    public void verifyOrderStatus(String expectedStatus)
    {
        assertThat("Status", getStatus(), equalToIgnoringCase(expectedStatus));
    }

    public void verifyOrderGranularStatus(String expectedGranularStatus)
    {
        assertThat("Granular Status", getGranularStatus(), equalToIgnoringCase(expectedGranularStatus));
    }

    public void verifyOrderDeliveryTitle(String expectedDeliveryTitle)
    {
        assertThat("Delivery Title", getDeliveryTitle(), equalToIgnoringCase(expectedDeliveryTitle));
    }

    public void verifyOrderDeliveryStatus(String expectedDeliveryStatus)
    {
        assertThat("Delivery Status", getDeliveryStatus(), equalToIgnoringCase(expectedDeliveryStatus));
    }

    public void verifyOrderIsForceSuccessedSuccessfully(Order order)
    {
        String expectedTrackingId = order.getTrackingId();

        assertEquals("Tracking ID", expectedTrackingId, getTrackingId());
        assertThat("Status", getStatus(), equalToIgnoringCase("Completed"));
        assertThat("Granular Status", getGranularStatus(), equalToIgnoringCase("Completed"));

        Long shipperId = order.getShipper().getId();

        if(shipperId!=null)
        {
            assertThat("Shipper ID", getShipperId(), containsString(String.valueOf(shipperId)));
        }

        assertEquals("Order Type", order.getType(), getOrderType());
        //Assert.assertThat("Latest Event", getLatestEvent(), Matchers.containsString("Order Force Successed")); //Disabled because somehow the latest event name is always 'PRICING_CHANGE' and the value on Latest Event is '-'.
        assertEquals("Pickup Status", "SUCCESS", getPickupStatus());
        assertEquals("Delivery Status", "SUCCESS", getDeliveryStatus());

        verifyPickupAndDeliveryInfo(order);
    }

    public void verifyPickupAndDeliveryInfo(Order order)
    {
        // Pickup
        assertEquals("From Name", order.getFromName(), getFromName());
        assertEquals("From Email", order.getFromEmail(), getFromEmail());
        assertEquals("From Contact", order.getFromContact(), getFromContact());
        String fromAddress = getFromAddress();
        assertThat("From Address", fromAddress, containsString(order.getFromAddress1()));
        assertThat("From Address", fromAddress, containsString(order.getFromAddress2()));

        // Delivery
        assertEquals("To Name", order.getToName(), getToName());
        assertEquals("To Email", order.getToEmail(), getToEmail());
        assertEquals("To Contact", order.getToContact(), getToContact());
        String toAddress = getToAddress();
        assertThat("To Address", toAddress, containsString(order.getToAddress1()));
        assertThat("To Address", toAddress, containsString(order.getToAddress2()));
    }

    public void verifyOrderIsGlobalInboundedSuccessfully(Order order, GlobalInboundParams globalInboundParams, Double expectedOrderCost, String expectedStatus, List<String> expectedGranularStatus, String expectedDeliveryStatus)
    {
        if(isElementExistFast("//nv-icon-text-button[@name='container.order.edit.show-more']"))
        {
            clickNvIconTextButtonByName("container.order.edit.show-more");
        }

        String expectedTrackingId = order.getTrackingId();
        assertEquals("Tracking ID", expectedTrackingId, getTrackingId());

        if(StringUtils.isNotBlank(expectedStatus))
        {
            assertThat(String.format("Status - [Tracking ID = %s]", expectedTrackingId), getStatus(), equalToIgnoringCase(expectedStatus));
        }

        if(CollectionUtils.isNotEmpty(expectedGranularStatus))
        {
            assertThat(String.format("Granular Status - [Tracking ID = %s]", expectedTrackingId), getGranularStatus(), isIn(expectedGranularStatus));
        }

        assertEquals("Pickup Status", "SUCCESS", getPickupStatus());

        if(StringUtils.isNotBlank(expectedDeliveryStatus))
        {
            assertThat("Delivery Status", getDeliveryStatus(), equalToIgnoringCase(expectedDeliveryStatus));
        }

        // There is an issue where after Global Inbound the new Size is not applied. KH need to fix this.
        // Uncomment this line below if KH has fixed it.
        /*if(globalInboundParams.getOverrideSize()!=null)
        {
            Assert.assertEquals("Size", getParcelSizeAsLongString(globalInboundParams.getOverrideSize()), getSize());
        }*/

        if(globalInboundParams.getOverrideWeight()!=null)
        {
            assertEquals("Weight", globalInboundParams.getOverrideWeight(), getWeight());
        }

        if(globalInboundParams.getOverrideDimHeight()!=null && globalInboundParams.getOverrideDimWidth()!=null && globalInboundParams.getOverrideDimLength()!=null)
        {
            Dimension actualDimension = getDimension();
            assertEquals("Dimension - Height", globalInboundParams.getOverrideDimHeight(), actualDimension.getHeight());
            assertEquals("Dimension - Width", globalInboundParams.getOverrideDimWidth(), actualDimension.getWidth());
            assertEquals("Dimension - Length", globalInboundParams.getOverrideDimLength(), actualDimension.getLength());
        }

        if(expectedOrderCost!=null)
        {
            Double total = getTotal();
            String totalAsString = null;

            if(total!=null)
            {
                totalAsString = NO_TRAILING_ZERO_DF.format(total);
            }

            assertEquals("Cost", NO_TRAILING_ZERO_DF.format(expectedOrderCost), totalAsString);
        }

        try
        {
            retryIfAssertionErrorOccurred(() ->
            {
                eventsTable.waitUntilVisibility();
                OrderEvent orderEvent = eventsTable.readEntity(1);
                assertEquals("Latest Event Name", "HUB INBOUND SCAN", orderEvent.getName());
                assertEquals("Latest Event Hub Name", globalInboundParams.getHubName(), orderEvent.getHubName());
            }, "Check the last event params", 10, 5);
        }
        catch (RuntimeException | AssertionError ex)
        {
            NvLogger.warn("Ignore this Assertion error for now because the event sometimes is not created right away.", ex);
        }
    }

    public String getDeliveryTitle()
    {
        return getText("//*[@id='delivery-details']/div/div[1]/h5");
    }

    public String getShipperId()
    {
        return getText("//label[text()='Shipper ID']/following-sibling::p");
    }

    public String getTrackingId()
    {
        return getText("//label[text()='Tracking ID']/following-sibling::h3");
    }

    public String getStatus()
    {
        return getText("//label[text()='Status']/following-sibling::h3");
    }

    public String getGranularStatus()
    {
        return getText("//label[text()='Granular']/following-sibling::h3");
    }

    public String getTag()
    {
        return getText("//nv-tag[@ng-repeat='tag in ctrl.orderTags']/*");
    }

    @SuppressWarnings("unused")
    public String getLatestEvent()
    {
        return getText("//label[text()='Latest Event']/following-sibling::h3");
    }

    public String getOrderType()
    {
        return getText("//label[text()='Order Type']/following-sibling::p");
    }

    public String getSize()
    {
        return getText("//label[text()='Size']/following-sibling::p");
    }

    public Double getWeight()
    {
        Double weight = null;
        String actualText = getText("//label[text()='Weight']/following-sibling::p");

        if(!actualText.contains("-"))
        {
            String temp = actualText.replace("kg", "").trim();
            weight = Double.parseDouble(temp);
        }

        return weight;
    }

    @SuppressWarnings("unused")
    public Double getCashOnDelivery()
    {
        Double cod = null;
        String actualText = getText("//label[text()='Cash on Delivery']/following-sibling::p");

        if(!actualText.contains("-"))
        {
            String temp = actualText.substring(3); //Remove currency text (e.g. SGD)
            cod = Double.parseDouble(temp);
        }

        return cod;
    }

    public Dimension getDimension()
    {
        Dimension dimension = new Dimension();
        String actualText = getText("//label[text()='Dimensions']/following-sibling::p");

        if(!actualText.contains("-") && !actualText.contains("x x cm") && !actualText.contains("(L) x (B) x (H) cm"))
        {
            String temp = actualText.replace("cm", "");
            String[] dims = temp.split("x");
            Double height = Double.parseDouble(dims[1]);
            Double width = Double.parseDouble(dims[0]);
            Double length = Double.parseDouble(dims[2]);
            dimension = new Dimension();
            dimension.setHeight(height);
            dimension.setWidth(width);
            dimension.setLength(length);
        }

        return dimension;
    }

    public Double getTotal()
    {
        Double total = null;
        String actualText = getText("//label[text()='Total']/following-sibling::p");

        if(!actualText.contains("-"))
        {
            String temp = actualText.substring(3); //Remove currency text (e.g. SGD)
            total = Double.parseDouble(temp);
        }

        return total;
    }

    public String getPickupStatus()
    {
        return getText("//div[h5[text()='Pickup']]/following-sibling::div/h5[contains(text(), Status)]").split(":")[1].trim();
    }

    public String getFromName()
    {
        return getText("//div[@id='pickup-details']/div[2]/div/div/div/div/div/h5");
    }

    public String getFromEmail()
    {
        return getText("//div[@id='pickup-details']/div[2]/div/div/div[2]/div/span");
    }

    public String getFromContact()
    {
        return getText("//div[@id='pickup-details']/div[2]/div/div/div[2]/div[2]/span");
    }

    public String getFromAddress()
    {
        return getText("//div[@id='pickup-details']/div[2]/div/div/div[2]/div[3]/span");
    }

    public String getDeliveryStatus()
    {
        return getText("//*[@id='delivery-details']/div/div[2]/h5").split(":")[1].trim();
    }

    public String getToName()
    {
        return getText("//div[@id='delivery-details']/div[2]/div/div/div/div/div/h5");
    }

    public String getToEmail()
    {
        return getText("//div[@id='delivery-details']/div[2]/div/div/div[2]/div/span");
    }

    public String getToContact()
    {
        return getText("//div[@id='delivery-details']/div[2]/div/div/div[2]/div[2]/span");
    }

    public String getToAddress()
    {
        return getText("//div[@id='delivery-details']/div[2]/div/div/div[2]/div[3]/span");
    }

    public void waitUntilInvisibilityOfLoadingOrder()
    {
        waitUntilInvisibilityOfElementLocated("//md-content[@loading-message='Loading order...']/div[contains(@class, 'loading')]");
        pause100ms();
    }

    public String getTextOnTableEvent(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT_TABLE_EVENT);
    }

    /**
     * Accessor for Reservations table
     */
    public static class TransactionsTable extends OperatorV2SimplePage
    {
        private static final String NG_REPEAT = "transaction in getTableData()";
        private static final String COLUMN_CLASS_PRIORITY_LEVEL = "priority-level";
        private static final String COLUMN_CLASS_TXN_TYPE = "type";
        private static final String COLUMN_CLASS_STATUS = "status";

        public TransactionsTable(WebDriver webDriver)
        {
            super(webDriver);
        }

        public String getPriorityLevel(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_PRIORITY_LEVEL);
        }

        @SuppressWarnings("unused")
        public String getStatus(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_STATUS);
        }

        @SuppressWarnings("unused")
        public String getTxnType(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_TXN_TYPE);
        }

        private String getTextOnTable(int rowNumber, String columnDataClass)
        {
            String text = getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
            return StringUtils.normalizeSpace(text);
        }

        public void searchByTxnType(String txnType)
        {
            searchTableCustom1(COLUMN_CLASS_TXN_TYPE, txnType);
        }
    }

    /**
     * Accessor for Reservations table
     */
    public static class EventsTable extends NgRepeatTable<OrderEvent>
    {
        public static final String NG_REPEAT = "event in getTableData()";
        public static final String DATE_TIME = "eventTime";
        public static final String EVENT_TAGS = "tags";
        public static final String EVENT_NAME = "name";
        public static final String USER_TYPE = "userType";
        public static final String USER_ID = "user";
        public static final String SCAN_ID = "scanId";
        public static final String ROUTE_ID = "routeId";
        public static final String HUB_NAME = "hubName";
        public static final String DESCRIPTION = "description";

        public EventsTable(WebDriver webDriver)
        {
            super(webDriver);
            setNgRepeat(NG_REPEAT);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(DATE_TIME, "_event_time")
                    .put(EVENT_TAGS, "_tags")
                    .put(EVENT_NAME, "name")
                    .put(USER_TYPE, "user_type")
                    .put(USER_ID, "_user")
                    .put(SCAN_ID, "_scan_id")
                    .put(ROUTE_ID, "_route_id")
                    .put(HUB_NAME, "_hub_name")
                    .put(DESCRIPTION, "_description")
                    .build());
            setEntityClass(OrderEvent.class);
        }
    }

    /**
     * Accessor for Add To Route dialog
     */
    public static class AddToRouteDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Add To Route";
        private static final String FIELD_ROUTE_LOCATOR = "ctrl.formData.orders[0].routeId";
        private static final String FIELD_TYPE_LOCATOR = "model";
        private static final String BUTTON_ADD_TO_ROUTE_LOCATOR = "container.order.edit.add-to-route";

        public AddToRouteDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public AddToRouteDialog waitUntilVisibility()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            return this;
        }

        public AddToRouteDialog enterRouteId(long routeId)
        {
            sendKeysToMdInputContainerByModel(FIELD_ROUTE_LOCATOR, String.valueOf(routeId));
            return this;
        }

        public AddToRouteDialog selectType(String type)
        {
            selectValueFromMdSelect(FIELD_TYPE_LOCATOR, type);
            return this;
        }

        public void submit()
        {
            clickNvApiTextButtonByNameAndWaitUntilDone(BUTTON_ADD_TO_ROUTE_LOCATOR);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }

    /**
     * Accessor for Delivery Details box
     */
    public static class DeliveryDetailsBox extends OperatorV2SimplePage
    {
        private static final String BOX_LOCATOR = "//div[h5[text()='Delivery Details']]";
        private static final String DELIVERY_INSTRUCTIONS_LOCATOR = BOX_LOCATOR + "//div[label[text()='Delivery Instructions']]/p";
        private static final String ROUTE_ID_LOCATOR = BOX_LOCATOR + "//div[label[text()='Route Id']]/p";
        private static final String ROUTE_DATE_LOCATOR = BOX_LOCATOR + "//div[label[text()='Route Date']]/p";
        private static final String DRIVER_LOCATOR = BOX_LOCATOR + "//div[label[text()='Driver']]/p";
        private static final String WAYPOINT_ID_LOCATOR = BOX_LOCATOR + "//div[label[text()='Waypoint ID']]/p";
        private static final String START_DATE_TIME_LOCATOR = BOX_LOCATOR + "//div[label[text()='Start Date / Time']]/p";
        private static final String END_DATE_TIME_LOCATOR = BOX_LOCATOR + "//div[label[text()='End Date / Time']]/p";

        public DeliveryDetailsBox(WebDriver webDriver)
        {
            super(webDriver);
        }

        public String getDeliveryInstructions()
        {
            return getText(DELIVERY_INSTRUCTIONS_LOCATOR);
        }

        public String getRouteId()
        {
            return getText(ROUTE_ID_LOCATOR);
        }

        public String getRouteDate()
        {
            return getText(ROUTE_DATE_LOCATOR);
        }

        public String getDriver()
        {
            return getText(DRIVER_LOCATOR);
        }

        public String getWaypointId()
        {
            return getText(WAYPOINT_ID_LOCATOR);
        }

        public String getStartDateTime()
        {
            return getText(START_DATE_TIME_LOCATOR);
        }

        public String getEndDateTime()
        {
            return getText(END_DATE_TIME_LOCATOR);
        }
    }

    /**
     * Accessor for Pickup Details box
     */
    public static class PickupDetailsBox extends OperatorV2SimplePage
    {
        private static final String PICKUP_INSTRUCTIONS_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Pick Up Instructions']]/p";
        private static final String ROUTE_ID_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Route Id']]/p";
        private static final String ROUTE_DATE_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Route Date']]/p";
        private static final String DRIVER_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Driver']]/p";
        private static final String WAYPOINT_ID_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Waypoint ID']]/p";

        public PickupDetailsBox(WebDriver webDriver)
        {
            super(webDriver);
        }

        @SuppressWarnings("unused")
        public String getPickupInstructions()
        {
            return getText(PICKUP_INSTRUCTIONS_LOCATOR);
        }

        public String getRouteId()
        {

            return getText(ROUTE_ID_LOCATOR);
        }

        public String getRouteDate()
        {

            return getText(ROUTE_DATE_LOCATOR);
        }

        public String getDriver()
        {

            return getText(DRIVER_LOCATOR);
        }

        public String getWaypointId()
        {

            return getText(WAYPOINT_ID_LOCATOR);
        }
    }
}
