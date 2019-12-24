package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.CollectionSummary;
import co.nvqa.operator_v2.model.MoneyCollection;
import co.nvqa.operator_v2.model.WaypointOrderInfo;
import co.nvqa.operator_v2.model.WaypointPerformance;
import co.nvqa.operator_v2.model.WaypointReservationInfo;
import co.nvqa.operator_v2.model.WaypointShipperInfo;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.NvAutocomplete;
import com.google.common.collect.ImmutableMap;
import org.junit.Assert;
import org.junit.platform.commons.util.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.RouteInboundPage.ShippersTable.VIEW_ORDERS;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteInboundPage extends OperatorV2SimplePage
{
    private ShippersTable shippersTable;
    private ReservationsTable reservationsTable;
    private OrdersTable ordersTable;
    private RouteInboundCommentsDialog routeInboundCommentsDialog;
    private MoneyCollectionDialog moneyCollectionDialog;

    @FindBy(xpath = "//nv-autocomplete[@search-text='ctrl.hubSelection.searchText']")
    public NvAutocomplete selectHub;

    @FindBy(xpath = "//nv-autocomplete[@search-text='ctrl.driverSearch.searchText']")
    public NvAutocomplete selectDriver;

    public RouteInboundPage(WebDriver webDriver)
    {
        super(webDriver);
        PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
        shippersTable = new ShippersTable(webDriver);
        reservationsTable = new ReservationsTable(webDriver);
        ordersTable = new OrdersTable(webDriver);
        routeInboundCommentsDialog = new RouteInboundCommentsDialog(webDriver);
        moneyCollectionDialog = new MoneyCollectionDialog(webDriver);
    }

    public void fetchRouteByRouteId(String hubName, Long routeId)
    {
        selectHub.selectValue(hubName);
        sendKeysById("route-id", String.valueOf(routeId));

        String continueBtnXpath = "//md-card-content[./label[text()='Enter the route ID']]/nv-api-text-button[@name='container.route-inbound.continue']/button";
        click(continueBtnXpath);

        dismissDriverAttendanceDialog();

        waitUntilInvisibilityOfElementLocated(continueBtnXpath + "//md-progress-circular");
    }

    private void dismissDriverAttendanceDialog()
    {
        if (isElementExistWait5Seconds("//md-dialog/md-dialog-content/h2[text()='Driver Attendance']"))
        {
            click("//md-dialog[./md-dialog-content/h2[text()='Driver Attendance']]//button[@aria-label='Yes']");
        }
    }

    public void fetchRouteByTrackingId(String hubName, String trackingId, Long routeId)
    {
        selectHub.selectValue(hubName);
        sendKeysById("tracking-id", trackingId);

        String continueBtnXpath = "//md-card-content[./label[text()='Scan a tracking ID']]/nv-api-text-button[@name='container.route-inbound.continue']/button";
        click(continueBtnXpath);

        if (routeId != null)
        {
            selectRoute(routeId);
        }

        dismissDriverAttendanceDialog();

        waitUntilInvisibilityOfElementLocated(continueBtnXpath + "//md-progress-circular");
    }

    public void fetchRouteByDriver(String hubName, String driverName, Long routeId)
    {
        selectHub.selectValue(hubName);
        selectDriver.selectValue(driverName);

        String continueBtnXpath = "//md-card-content[.//label[text()='Search by driver']]/nv-api-text-button[@name='container.route-inbound.continue']/button";
        click(continueBtnXpath);

        if (routeId != null)
        {
            selectRoute(routeId);
        }

        dismissDriverAttendanceDialog();

        waitUntilInvisibilityOfElementLocated(continueBtnXpath + "//md-progress-circular");
    }

    public void selectRoute(Long routeId)
    {
        if (isElementExistWait5Seconds("//md-dialog/md-dialog-content/h2[text()='Choose a route']"))
        {
            String routeIdProceedButton = String.format("//tr[@ng-repeat='routeId in ctrl.routeIds'][td[text()='%d']]//button", routeId);
            moveToElementWithXpath(routeIdProceedButton); //This needed to make sure the button is clicked if there are many routes.
            pause200ms();
            click(routeIdProceedButton);
        }
    }

    public void verifyRouteSummaryInfoIsCorrect(long expectedRouteId, String expectedDriverName, String expectedHubName, Date expectedRouteDate, WaypointPerformance expectedWaypointPerformance, CollectionSummary expectedCollectionSummary)
    {
        String actualRouteId = getText("//div[./label[text()='Route Id']]/h3/span");
        String actualDriverName = getText("//div[./label[text()='Driver']]/h3/span");
        String actualHubName = getText("//div[./label[text()='Hub']]/h3/span");
        String actualRouteDate = getText("//div[./label[text()='Date']]/h3/span");

        assertEquals("Route ID", String.valueOf(expectedRouteId), actualRouteId);
        assertEquals("Driver Name", expectedDriverName.replaceAll(" ", ""), actualDriverName.replaceAll(" ", ""));
        assertEquals("Hub Name", expectedHubName, actualHubName);
        assertEquals("Route Date", YYYY_MM_DD_SDF.format(expectedRouteDate), actualRouteDate);

        String actualWpPending = getText("//p[./parent::div/following-sibling::div[contains(text(),'Pending')]]");
        String actualWpPartial = getText("//p[./parent::div/following-sibling::div[contains(text(),'Partial')]]");
        String actualWpFailed = getText("//p[./parent::div/following-sibling::div[contains(text(),'Failed')]]");
        String actualWpCompleted = getText("//p[./parent::div/following-sibling::div[contains(text(),'Completed')]]");
        String actualWpTotal = getText("//p[./parent::div/following-sibling::div[contains(text(),'Total')]]");

        assertEquals("Waypoint Performance - Pending", String.valueOf(expectedWaypointPerformance.getPending()), actualWpPending);
        assertEquals("Waypoint Performance - Partial", String.valueOf(expectedWaypointPerformance.getPartial()), actualWpPartial);
        assertEquals("Waypoint Performance - Failed", String.valueOf(expectedWaypointPerformance.getFailed()), actualWpFailed);
        assertEquals("Waypoint Performance - Completed", String.valueOf(expectedWaypointPerformance.getCompleted()), actualWpCompleted);
        assertEquals("Waypoint Performance - Total", String.valueOf(expectedWaypointPerformance.getTotal()), actualWpTotal);
    }

    public void openPendingWaypointsDialog()
    {
        click("//p[./parent::div/following-sibling::div[contains(text(),'Pending')]]");
        waitUntilVisibilityOfMdDialogByTitle("Pending");
    }

    public void openCompletedWaypointsDialog()
    {
        click("//p[./parent::div/following-sibling::div[contains(text(),'Completed')]]");
        waitUntilVisibilityOfMdDialogByTitle("Completed");
    }

    public void openFailedWaypointsDialog()
    {
        click("//p[./parent::div/following-sibling::div[contains(text(),'Failed')]]");
        waitUntilVisibilityOfMdDialogByTitle("Failed");
    }

    public void clickContinueToInbound()
    {
        clickNvIconTextButtonByName("container.route-inbound.continue-to-inbound");
    }

    public void clickGoBack()
    {
        clickNvIconTextButtonByName("commons.go-back");
    }

    public void scanTrackingId(String trackingId)
    {
        sendKeysAndEnterById("tracking-id", trackingId);
        String xpath = "//tr[@ng-repeat=\"row in ctrl.inboundingHistory | orderBy:'createdAt':true\"]/td[normalize-space(text())='%s']";
        waitUntilVisibilityOfElementLocated(xpath, trackingId);
    }

    public MoneyCollectionDialog openMoneyCollectionDialog()
    {
        click("//div[contains(@class,'big-button')][./*[normalize-space(.)='Money to collect']]");
        return moneyCollectionDialog;
    }

    public MoneyCollectionDialog moneyCollectionDialog()
    {
        return moneyCollectionDialog;
    }

    public String getMoneyToCollectValue()
    {
        if (isElementVisible("//*[@ng-if='ctrl.remainingCashToCollect <= 0'][.='done']"))
        {
            return "Fully Collected";
        } else
        {
            return getText("//*[@ng-if='ctrl.remainingCashToCollect > 0']").replace("$", "").trim();
        }
    }

    public void openViewOrdersOrReservationsDialog(int index)
    {
        shippersTable.clickActionButton(index, VIEW_ORDERS);
    }

    public void validateShippersTable(List<WaypointShipperInfo> expectedShippersInfo)
    {
        List<WaypointShipperInfo> actualShippersInfo = shippersTable.readAllEntities();
        assertEquals("Shippers count", expectedShippersInfo.size(), actualShippersInfo.size());

        for (int i = 0; i < actualShippersInfo.size(); i++)
        {
            expectedShippersInfo.get(i).compareWithActual(actualShippersInfo.get(i));
        }
    }

    public void validateReservationsTable(List<WaypointReservationInfo> expectedReservationsInfo)
    {
        List<WaypointReservationInfo> actualReservationsInfo = reservationsTable.readAllEntities();
        assertEquals("Reservations count", expectedReservationsInfo.size(), actualReservationsInfo.size());

        for (int i = 0; i < actualReservationsInfo.size(); i++)
        {
            expectedReservationsInfo.get(i).compareWithActual(actualReservationsInfo.get(i));
        }
    }

    public void validateOrdersTable(List<WaypointOrderInfo> expectedOrdersInfo)
    {
        List<WaypointOrderInfo> actualOrdersInfo = ordersTable.readAllEntities();
        Map<String, WaypointOrderInfo> actualOrdersInfoMap = actualOrdersInfo.stream()
                .collect(Collectors.toMap(
                        WaypointOrderInfo::getTrackingId,
                        orderInfo -> orderInfo
                ));
        assertEquals("Orders count", expectedOrdersInfo.size(), actualOrdersInfo.size());

        expectedOrdersInfo.forEach(expectedOrderInfo ->
        {
            WaypointOrderInfo actualOrderInfo = actualOrdersInfoMap.get(expectedOrderInfo.getTrackingId());
            assertThat("Order with Tracking ID = " + expectedOrderInfo.getTrackingId() + " was not found", actualOrderInfo, notNullValue());
            expectedOrderInfo.compareWithActual(actualOrderInfo);
        });
    }

    public void verifyErrorMessage(String status, String url, String errorCode, String errorMessage)
    {
        Map<String, String> toastData = waitUntilVisibilityAndGetErrorToastData();

        if (StringUtils.isNotBlank(status))
        {
            assertThat("Error toast status", toastData.get("status"), equalToIgnoringCase(status));
        }

        if (StringUtils.isNotBlank(url))
        {
            assertThat("Error toast url", toastData.get("url"), equalToIgnoringCase(url));
        }

        if (StringUtils.isNotBlank(errorCode))
        {
            assertThat("Error toast code", toastData.get("errorCode"), equalToIgnoringCase(errorCode));
        }

        if (StringUtils.isNotBlank(errorMessage))
        {
            assertThat("Error toast status", toastData.get("errorMessage"), equalToIgnoringCase(errorMessage));
        }
    }

    public void addRoutInboundComment(String comment)
    {
        click("//a[contains(@ng-click,'ctrl.routeInboundComments')]");
        routeInboundCommentsDialog
                .waitUntilVisible()
                .enterComment(comment)
                .clickAddButton();
        pause3s();
    }

    public void verifyRouteInboundComment(String expectedComment)
    {
        String actualComment = getText("//div[@ng-if='ctrl.hasComments()']");
        Pattern commentPattern = Pattern.compile("Comment by (.+):(.+)");
        Matcher matcher = commentPattern.matcher(actualComment.trim());
        if (matcher.find())
        {
            String commentText = matcher.group(2).trim();
            Assert.assertEquals("Route Inbound Comment text", expectedComment, commentText);
        } else
        {
            Assert.fail(String.format("Route Inbound Comment text [%s] has unexpected format", actualComment));
        }
    }

    public static class RouteInboundCommentsDialog extends OperatorV2SimplePage
    {
        static final String DIALOG_TITLE = "Route Inbound Comments";
        static final String LOCATOR_FIELD_NEW_COMMENT = "container.route-inbound.enter-route-comment-here";
        static final String LOCATOR_BUTTON_ADD = "Add";

        public RouteInboundCommentsDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public RouteInboundCommentsDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            return this;
        }

        public RouteInboundCommentsDialog enterComment(String value)
        {
            sendKeysById(LOCATOR_FIELD_NEW_COMMENT, value);
            return this;
        }

        public RouteInboundCommentsDialog clickAddButton()
        {
            clickNvIconTextButtonByNameAndWaitUntilDone(LOCATOR_BUTTON_ADD);
            return this;
        }
    }

    public static class MoneyCollectionDialog extends OperatorV2SimplePage
    {
        static final String DIALOG_TITLE = "Money Collection";

        public MoneyCollectionDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public String getExpectedTotal()
        {
            return getText("//*[@label='container.route-inbound.expected-total']/div").replace("S$", "").trim();
        }

        public String getOutstandingAmount()
        {
            if (isElementVisible("//*[@ng-if='ctrl.inputForm.outstandingAmount <= 0']/p[.='Fully Collected']"))
            {
                return "Fully Collected";
            } else
            {
                return getText("//*[@label='container.route-inbound.outstanding-amount']/div").replace("S$", "").trim();
            }
        }

        public MoneyCollectionDialog setCashCollected(Double cashCollected)
        {
            sendKeysById("cash-collected", String.valueOf(cashCollected));
            return this;
        }

        public MoneyCollectionDialog setCreditCollected(Double creditCollected)
        {
            sendKeysById("credit-collected", String.valueOf(creditCollected));
            return this;
        }

        public MoneyCollectionDialog setReceiptNo(String receiptNo)
        {
            sendKeysById("receipt-number", receiptNo);
            return this;
        }

        public MoneyCollectionDialog setReceiptId(String receiptId)
        {
            sendKeysById("receipt-or-transaction-id", receiptId);
            return this;
        }

        public MoneyCollectionDialog fillForm(MoneyCollection data)
        {
            if (data.getCashCollected() != null)
            {
                setCashCollected(data.getCashCollected());
            }

            if (data.getCreditCollected() != null)
            {
                setCreditCollected(data.getCreditCollected());
            }

            if (StringUtils.isNotBlank(data.getReceiptNo()))
            {
                setReceiptNo(data.getReceiptNo());
            }

            if (StringUtils.isNotBlank(data.getReceiptId()))
            {
                setReceiptId(data.getReceiptId());
            }

            return this;
        }

        public void save()
        {
            clickNvApiTextButtonByName("commons.save");
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }

    /**
     * Accessor for Shippers table
     */
    @SuppressWarnings("WeakerAccess")
    public static class ShippersTable extends NgRepeatTable<WaypointShipperInfo>
    {
        public static final String NG_REPEAT = "shipper in getTableData()";
        public static final String SHIPPER_NAME = "shipperName";
        public static final String ROUTE_INBOUNDED = "scanned";
        public static final String TOTAL = "total";
        public static final String VIEW_ORDERS = "View orders or reservations";

        public ShippersTable(WebDriver webDriver)
        {
            super(webDriver);
            setNgRepeat(NG_REPEAT);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(SHIPPER_NAME, "name")
                    .put(ROUTE_INBOUNDED, "scanned")
                    .put(TOTAL, "total")
                    .build());
            setEntityClass(WaypointShipperInfo.class);
            setActionButtonsLocators(ImmutableMap.of(VIEW_ORDERS, "container.route-inbound.view-orders-or-reservations"));
        }
    }

    /**
     * Accessor for Reservations table
     */
    @SuppressWarnings("WeakerAccess")
    public static class ReservationsTable extends NgRepeatTable<WaypointReservationInfo>
    {
        public static final String NG_REPEAT = "reservation in getTableData()";
        public static final String RESERVATION_ID = "reservationId";
        public static final String LOCATION = "location";
        public static final String READY_TO_LATEST_TIME = "readyToLatestTime";
        public static final String APPROX_VALUE = "approxVolume";
        public static final String STATUS = "status";
        public static final String RECEIVED_PARCELS = "receivedParcels";

        public ReservationsTable(WebDriver webDriver)
        {
            super(webDriver);
            setNgRepeat(NG_REPEAT);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(RESERVATION_ID, "id")
                    .put(LOCATION, "location")
                    .put(READY_TO_LATEST_TIME, "ready-to-latest-time")
                    .put(APPROX_VALUE, "approx_volume")
                    .put(STATUS, "translated-status")
                    .put(RECEIVED_PARCELS, "total-pickup-count")
                    .build());
            setEntityClass(WaypointReservationInfo.class);
        }
    }

    /**
     * Accessor for Orders table
     */
    @SuppressWarnings("WeakerAccess")
    public static class OrdersTable extends NgRepeatTable<WaypointOrderInfo>
    {
        public static final String NG_REPEAT = "order in getTableData()";
        public static final String TRACKING_ID = "trackingId";
        public static final String STAMP_ID = "stampId";
        public static final String LOCATION = "location";
        public static final String TYPE = "type";
        public static final String STATUS = "status";
        public static final String CMI_COUNT = "cmiCount";
        public static final String ROUTE_INBOUND_STATUS = "routeInboundStatus";

        public OrdersTable(WebDriver webDriver)
        {
            super(webDriver);
            setNgRepeat(NG_REPEAT);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(TRACKING_ID, "tracking_id")
                    .put(STAMP_ID, "stamp_id")
                    .put(LOCATION, "location")
                    .put(TYPE, "custom-type")
                    .put(STATUS, "translated-status")
                    .put(CMI_COUNT, "cmi_count")
                    .put(ROUTE_INBOUND_STATUS, "scan-status")
                    .build());
            setEntityClass(WaypointOrderInfo.class);
        }
    }
}
