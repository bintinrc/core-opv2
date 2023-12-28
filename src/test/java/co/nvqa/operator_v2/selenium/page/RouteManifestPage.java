package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails.Reservation;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntTableV2;
import co.nvqa.operator_v2.selenium.elements.ant.AntTableV3;
import co.nvqa.operator_v2.selenium.elements.ant.AntTableV4;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;

import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class RouteManifestPage extends SimpleReactPage<RouteManifestPage> {

    public static final String COLUMN_STATUS = "status";
    public static final String COLUMN_COUNT_DELIVERY = "count-d";
    public static final String COLUMN_COMMENTS = "comments";
    public static final String ACTION_BUTTON_EDIT = "container.route-manifest.choose-outcome-for-waypoint";
    private static final String MD_VIRTUAL_REPEAT = "waypoint in getTableData()";
    public static final String ROUTE_DETAIL_ITEMS_XPATH = "//div[text()='%s']/following-sibling::div";

    @FindBy(css = "span.nv-mask")
    public PageElement mask;
    @FindBy(css = ".ant-modal")
    public WaypointDetailsDialog waypointDetailsDialog;
    public final WaypointsTable waypointsTable;

    @FindBy(css = ".ant-modal")
    public ChooseAnOutcomeForTheWaypointDialog chooseAnOutcomeForTheWaypointDialog;

    @FindBy(css = ".ant-modal")
    public CodCollectionDialog codCollectionDialog;

    @FindBy(css = ".ant-modal")
    public ProofOfPickupDialog proofOfPickupDialog;

    @FindBy(css = ".ant-modal")
    public ProofOfDeliveryDialog proofOfDeliveryDialog;

    @FindBy(xpath = "//div[.='Route ID']/following-sibling::div")
    public PageElement routeId;
    @FindBy(xpath = "//div[.='Driver ID']/following-sibling::div")
    public PageElement driverId;
    @FindBy(xpath = "//div[.='Driver name']/following-sibling::div")
    public PageElement driverName;

    @FindBy(xpath = "//div[@class='header'][.='Pending']/following-sibling::div")
    public PageElement codCollectionPending;

    @FindBy(xpath = "//*[text()='Tracking ID(s)']/parent::th//input")
    public PageElement trackingIDFilter;

    @FindBy(xpath = "//div[contains(@class,'ant-modal ')][contains(.,'Are you sure?')]")
    public ConfirmationDialog confirmationDialog;

    @FindBy(xpath = "//button[contains(text(),'View POA/POH')]")
    private PageElement viewPoaPohButton;

    public RouteManifestPage(WebDriver webDriver) {
        super(webDriver);
        waypointsTable = new WaypointsTable(webDriver);
    }

    public void openPage(long routeId) {
        getWebDriver().get(f("%s/%s/route-manifest/%d", TestConstants.OPERATOR_PORTAL_BASE_URL,
                StandardTestConstants.NV_SYSTEM_ID.toLowerCase(), routeId));
        inFrame(() -> waitUntilLoaded());
    }

    public void waitUntilPageLoaded() {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated(
                "//md-progress-circular/following-sibling::div[text()='Loading...']");
    }

    public String getParcelCountValue(String type, String status) {
        String xpath =
                "//div[translate(., ' ','')='" + StringUtils.capitalize(type.toLowerCase())
                        + "']/following-sibling::div[%d]";
        int index;
        switch (status.toLowerCase()) {
            case "pending":
                index = 1;
                break;
            case "success":
                index = 2;
                break;
            case "failure":
                index = 3;
                break;
            default:
                index = 4;
        }
        return new PageElement(getWebDriver(), f(xpath, index)).getText();
    }

    public String getWpTypeValue(String type, String status) {
        return getParcelCountValue(type, status);
    }

      public String getTimeslotValue(String timeslot, String status) {
        String xpath =
                "//div[translate(., ' ','')='" + StringUtils.capitalize(timeslot)
                        + "']/following-sibling::div[%d]";
        int index;
        switch (status.toLowerCase()) {
            case "pending":
                index = 1;
                break;
            case "early":
                index = 2;
                break;
             case "onTime":
                 index = 3;
                 break;
             default:
                 index = 4;
        }
        return new PageElement(getWebDriver(), f(xpath, index)).getText();
    }

    public void verifyWaypointDetails(RouteManifestWaypointDetails expectedWaypointDetails) {
        RouteManifestWaypointDetails.Reservation expectedReservation = expectedWaypointDetails
                .getReservation();
        RouteManifestWaypointDetails.Pickup expectedPickup = expectedWaypointDetails.getPickup();
        RouteManifestWaypointDetails.Delivery expectedDelivery = expectedWaypointDetails.getDelivery();
        expectedWaypointDetails.setReservation(null);
        expectedWaypointDetails.setPickup(null);
        expectedWaypointDetails.setDelivery(null);

        waitUntilPageLoaded();

        waypointsTable.clearColumnFilters();
        if (StringUtils.isNotBlank(expectedWaypointDetails.getTrackingIds())) {
            waypointsTable
                    .filterByColumn("trackingIds", String.valueOf(expectedWaypointDetails.getTrackingIds()));
        } else if (expectedWaypointDetails.getId() != null) {
            waypointsTable.filterByColumn("id", String.valueOf(expectedWaypointDetails.getId()));
        } else if (StringUtils.isNotBlank(expectedWaypointDetails.getAddress())) {
            waypointsTable
                    .filterByColumn("address", String.valueOf(expectedWaypointDetails.getAddress()));
        }

        RouteManifestWaypointDetails actualWaypointDetails = waypointsTable.readEntity(1);
        expectedWaypointDetails.compareWithActual(actualWaypointDetails);

        if (expectedReservation != null || expectedPickup != null || expectedDelivery != null) {
            waypointsTable.clickActionButton(1, "details");
            waypointDetailsDialog.waitUntilVisible();

            if (expectedReservation != null) {
                RouteManifestWaypointDetails.Reservation actualReservation = waypointDetailsDialog.reservationsTable
                        .readEntity(1);
                expectedReservation.compareWithActual(actualReservation);
            }
            if (expectedPickup != null) {
                RouteManifestWaypointDetails.Pickup actualPickup = waypointDetailsDialog.pickupsTable
                        .readEntity(1);
                expectedPickup.compareWithActual(actualPickup);
            }
            if (expectedDelivery != null) {
                RouteManifestWaypointDetails.Delivery actualDelivery = waypointDetailsDialog.deliveryTable
                        .readEntity(1);
                expectedDelivery.compareWithActual(actualDelivery);
            }
            waypointDetailsDialog.closeDialogIfVisible();
        }
    }

    public String failDeliveryWaypoint(Map<String, String> failureReason) {
        waypointsTable.clickActionButton(1, "edit");
        chooseAnOutcomeForTheWaypointDialog.waitUntilVisible();
        chooseAnOutcomeForTheWaypointDialog.failure.click();
        String description = failureReason.get("failureReasonDescription");
        chooseAnOutcomeForTheWaypointDialog.chooseFailureReason
                .selectValue(description);
        String childFailureReason = failureReason.get("failureReasonSubDescription");
        chooseAnOutcomeForTheWaypointDialog.failureReasonDetail.selectValue(
                childFailureReason);
        description = childFailureReason;

        chooseAnOutcomeForTheWaypointDialog.update.click();
        confirmationDialog.waitUntilVisible();
        confirmationDialog.proceed.click();
        confirmationDialog.waitUntilInvisible();
        chooseAnOutcomeForTheWaypointDialog.waitUntilInvisible();
//  FE logic to truncate if failure reason for `- return`/`- normal`
        String replace = failureReason.get("replace");
        if (description.contains(replace)) {
            description = description.replace(replace, "");
        }
        return description;
    }

    public void failWaypointWithFailureDetails(Map<String, String> mapOfData, String trackingID) {
        String failureReason = mapOfData.get("Failure Reason");
        String failureReasonDetail1 = mapOfData.get("Failure Reason Detail 1");
        String failureReasonDetail2 = mapOfData.get("Failure Reason Detail 2");
        trackingIDFilter.clearAndSendKeys(trackingID);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        chooseAnOutcomeForTheWaypointDialog.waitUntilVisible();
        pause1s();
        chooseAnOutcomeForTheWaypointDialog.failure.click();
        chooseAnOutcomeForTheWaypointDialog.chooseFailureReason.selectValue(failureReason);
        if (StringUtils.isNotBlank(failureReasonDetail1)) {
            chooseAnOutcomeForTheWaypointDialog.selectFailureReasonDetails(1, failureReasonDetail1);
        }
        if (StringUtils.isNotBlank(failureReasonDetail2)) {
            chooseAnOutcomeForTheWaypointDialog.selectFailureReasonDetails(2, failureReasonDetail2);
        }
        chooseAnOutcomeForTheWaypointDialog.update.click();
        confirmationDialog.waitUntilVisible();
        confirmationDialog.proceed.click();
        confirmationDialog.waitUntilInvisible();
        chooseAnOutcomeForTheWaypointDialog.waitUntilInvisible();
    }

    public void successDeliveryWaypoint() {
        waypointsTable.clickActionButton(1, "edit");
        chooseAnOutcomeForTheWaypointDialog.success.click();
        confirmationDialog.waitUntilVisible();
        confirmationDialog.proceed.click();
        confirmationDialog.waitUntilInvisible();
        chooseAnOutcomeForTheWaypointDialog.waitUntilInvisible();
    }

    public void successReservationWaypoint() {
        waypointsTable.clickActionButton(1, "edit");
        chooseAnOutcomeForTheWaypointDialog.success.click();
        confirmationDialog.waitUntilVisible();
        confirmationDialog.proceed.click();
        confirmationDialog.waitUntilInvisible();
        chooseAnOutcomeForTheWaypointDialog.waitUntilInvisible();
    }

    public void searchTableByTrackingId(String trackingId) {
        searchTableCustom1("tracking-ids", trackingId);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass) {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
    /**
     * Accessor for Waypoint Details dialog
     */
    public static class WaypointDetailsDialog extends AntModal {

        @FindBy(xpath = ".//label[.='Waypoint ID']/following-sibling::div")
        public PageElement waypointId;

        @FindBy(xpath = ".//label[.='Waypoint status']/following-sibling::div")
        public PageElement waypointStatus;

        @FindBy(xpath = ".//label[.='Highest priority']/following-sibling::div")
        public PageElement highestPriority;

        @FindBy(xpath = ".//label[.='Service type(s)']/following-sibling::div")
        public PageElement serviceTypes;

        @FindBy(xpath = ".//label[.='Addressee']/following-sibling::div")
        public PageElement addressee;

        @FindBy(xpath = ".//label[.='Contact']/following-sibling::div")
        public PageElement contact;

        @FindBy(xpath = ".//label[.='Recipient']/following-sibling::div")
        public PageElement recipient;

        @FindBy(xpath = ".//label[.='Relationship']/following-sibling::div")
        public PageElement relationship;

        public ReservationsTable reservationsTable;
        public PickupsTable pickupsTable;
        public DeliveryTable deliveryTable;

        public WaypointDetailsDialog(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            reservationsTable = new ReservationsTable(webDriver);
            pickupsTable = new PickupsTable(webDriver);
            deliveryTable = new DeliveryTable(webDriver);
        }

        public static class ReservationsTable extends
                AntTableV4<Reservation> {

            public ReservationsTable(WebDriver webDriver) {
                super(webDriver);
                setColumnLocators(ImmutableMap.of(
                        "id", "1",
                        "status", "2",
                        "expectedNo", "3",
                        "collectedNo", "4",
                        "failureReason", "5"
                ));
                setActionButtonsLocators(Map.of(
                        "view pop",
                        "(//div[contains(@class,'virtual-table')]//div[@data-datakey='6'])[%d]//button[@data-pa-label='View POP']")
                );
                setEntityClass(RouteManifestWaypointDetails.Reservation.class);
            }
        }

        public static class PickupsTable extends AntTableV4<RouteManifestWaypointDetails.Pickup> {

            public PickupsTable(WebDriver webDriver) {
                super(webDriver);
                setColumnLocators(ImmutableMap.of(
                        "trackingId", "1",
                        "status", "2",
                        "failureReason", "3"
                ));
                setActionButtonsLocators(Map.of(
                        "view pop",
                        "(//div[contains(@class,'virtual-table')]//div[@data-datakey='4'])[%d]//button[@data-pa-label='View POP']")
                );
                setEntityClass(RouteManifestWaypointDetails.Pickup.class);
            }
        }

        public static class DeliveryTable extends AntTableV4<RouteManifestWaypointDetails.Delivery> {

            public DeliveryTable(WebDriver webDriver) {
                super(webDriver);
                setColumnLocators(ImmutableMap.of(
                        "trackingId", "1",
                        "status", "2",
                        "codCollected", "3",
                        "failureReason", "4"
                ));
                setActionButtonsLocators(Map.of(
                        "view pod",
                        "(//div[contains(@class,'virtual-table')]//div[@data-datakey='5'])[%d]//button[@data-pa-label='View POD']")
                );
                setEntityClass(RouteManifestWaypointDetails.Delivery.class);
            }
        }
    }

    public static class WaypointsTable extends AntTableV2<RouteManifestWaypointDetails> {

        public static final String COLUMN_ORDER_TAGS = "orderTags";
        public static final String COLUMN_TRACKING_IDS = "trackingIds";
        @FindBy(xpath = "//div[@data-datakey='_address']//span[.='Click to reveal (tracked)']")
        public PageElement addressReveal;

        @FindBy(xpath = "//div[@data-datakey='_contact']//span[.='Click to reveal (tracked)']")
        public PageElement contactReveal;

        public WaypointsTable(WebDriver webDriver) {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put("address", "_address")
                    .put("status", "_status")
                    .put(COLUMN_ORDER_TAGS, "_orderTags")
                    .put("id", "id")
                    .put("deliveriesCount", "_countD")
                    .put("pickupsCount", "_countP")
                    .put("comments", "_comments")
                    .put(COLUMN_TRACKING_IDS, "_trackingIds")
                    .put("contact", "_contact")
                    .build()
            );
            setActionButtonsLocators(ImmutableMap.of("details", "Waypoint details", "edit",
                    "Choose an outcome for the waypoint"));
            setEntityClass(RouteManifestWaypointDetails.class);
        }
    }

    public static class ChooseAnOutcomeForTheWaypointDialog extends AntModal {

        public ChooseAnOutcomeForTheWaypointDialog(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }

        @FindBy(css = "[data-testid='route-manifest-testid.choose-waypoint-outcome.success.button']")
        public Button success;

        @FindBy(css = "[data-testid='route-manifest-testid.choose-waypoint-outcome.failure.button']")
        public Button failure;

        @FindBy(css = "[data-pa-label='Go back']")
        public Button goBack;

        @FindBy(css = "[data-pa-label='Update']")
        public Button update;

        @FindBy(css = "[data-testid='route-manifest-testid.choose-waypoint-outcome.failure-reason.field-0']")
        public AntSelect3 chooseFailureReason;

        @FindBy(css = "[data-testid='route-manifest-testid.choose-waypoint-outcome.failure-reason.field-1']")
        public AntSelect3 failureReasonDetail;

        public void selectFailureReasonDetails(int index, String reason) {
            String xpath;
            if (index == 1) {
                xpath = ".//md-select[contains(@id, 'container.route-manifest.failure-reason-detail')]";
            } else {
                xpath = f(
                        ".//md-select[contains(@id, 'container.route-manifest.failure-reason-detail-%s')]",
                        index);
            }
            new MdSelect(this, xpath).selectValue(reason);
        }
    }

    public static class CodCollectionDialog extends AntModal {

        public CodCollectionDialog(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }

        @FindBy(xpath = ".//tr[@class='simple-table-row'][position()>=2]/td[1]")
        public List<PageElement> trackingId;

        @FindBy(xpath = ".//tr[@class='simple-table-row'][position()>=2]/td[2]")
        public List<PageElement> amount;

        @FindBy(xpath = ".//tr[@class='simple-table-row'][position()>=2]/td[3]//input")
        public List<CheckBox> collected;

        @FindBy(css = "[data-pa-label='Ok']")
        public Button ok;
    }

    public static class ConfirmationDialog extends AntModal {

        public ConfirmationDialog(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }

        @FindBy(xpath = ".//button[.='Proceed']")
        public Button proceed;
    }

    public String getRouteDetailItem(String itemName) {
        waitUntilVisibilityOfElementLocated(f(ROUTE_DETAIL_ITEMS_XPATH, itemName));
        return findElementByXpath(f(ROUTE_DETAIL_ITEMS_XPATH, itemName)).getText();
    }

    public static class ProofOfPickupDialog extends AntModal {

        @FindBy(xpath = ".//span[contains(.,'Reservation ID')]")
        public PageElement reservationId;

        @FindBy(xpath = ".//span[contains(.,'Pickup appointment job ID:')]")
        public PageElement pickupAppointmentJobId;

        @FindBy(xpath = ".//span[contains(.,'Tracking ID:')]")
        public PageElement trackingId;

        @FindBy(xpath = ".//label[.='Shipper']/following-sibling::div")
        public PageElement shipper;

        @FindBy(xpath = ".//label[.='Phone']/following-sibling::div")
        public PageElement phone;

        @FindBy(xpath = ".//label[.='Email']/following-sibling::div")
        public PageElement email;

        @FindBy(xpath = ".//span[contains(.,'Status')]/span")
        public PageElement status;

        @FindBy(xpath = ".//label[.='Received from']/following-sibling::div")
        public PageElement receivedFrom;

        @FindBy(xpath = ".//label[.='Relationship']/following-sibling::div")
        public PageElement relationship;

        @FindBy(xpath = ".//label[.='Receipt date/time']/following-sibling::div")
        public PageElement receiptDateTime;

        @FindBy(xpath = ".//label[.='Pickup quantity']/following-sibling::div")
        public PageElement pickupQuantity;

        @FindBy(css = "[data-pa-label='Download Signature']")
        public Button downloadSignature;

        @FindBy(xpath = "//tr[position()>1]/td[2]")
        public List<PageElement> trackingIds;

        public ProofOfPickupDialog(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }
    }

    public static class ProofOfDeliveryDialog extends AntModal {

        @FindBy(xpath = ".//span[contains(.,'Tracking ID:')]")
        public PageElement trackingId;

        @FindBy(xpath = ".//label[.='Phone']/following-sibling::div")
        public PageElement phone;

        @FindBy(xpath = ".//label[.='Email']/following-sibling::div")
        public PageElement email;

        @FindBy(xpath = ".//span[contains(.,'Status')]/span")
        public PageElement status;

        @FindBy(xpath = ".//label[.='Received by']/following-sibling::div")
        public PageElement receivedBy;

        @FindBy(xpath = ".//label[.='Relationship']/following-sibling::div")
        public PageElement relationship;

        @FindBy(xpath = ".//label[.='Code']/following-sibling::div")
        public PageElement code;

        @FindBy(xpath = ".//label[.='Hidden location']/following-sibling::div")
        public PageElement hiddenLocation;

        @FindBy(xpath = ".//label[.='Receipt date/time']/following-sibling::div")
        public PageElement receiptDateTime;

        @FindBy(xpath = ".//label[.='Delivery quantity']/following-sibling::div")
        public PageElement deliveryQuantity;

        @FindBy(css = "[data-pa-label='Download Signature']")
        public Button downloadSignature;

        public ProofOfDeliveryDialog(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }
    }
}