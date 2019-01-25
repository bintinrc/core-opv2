package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.utils.ScenarioStorage;
import co.nvqa.operator_v2.util.ScenarioStorageKeys;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Date;

/**
 *
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class OutboundMonitoringPage extends OperatorV2SimplePage implements ScenarioStorageKeys {

    private static final String COLUMN_CLASS_FILTER_ROUTE_ID = "id";
    private static final String COLUMN_CLASS_DATA_ID = "route-id";
    private  static final String COLUMN_CLASS_DATA_STATUS = "outbound-status";
    private  static final String COLUMN_CLASS_DATA_COMMENT = "comments";

    private static final String ACTION_BUTTON_EDIT = "edit";

    private static final String MD_VIRTUAL_REPEAT = "data in getTableData()";

    private ScenarioStorage scenarioStorage;
    private OutboundBreakroutePage outboundBreakroutePage;

    public OutboundMonitoringPage(WebDriver webDriver, ScenarioStorage scenarioStorage) {
        super(webDriver);
        this.scenarioStorage = scenarioStorage;
        outboundBreakroutePage = new OutboundBreakroutePage(getWebDriver());
    }

    public void selectFiltersAndClickLoadSelection(Date fromDate, Date toDate, String zoneName, String hubName) {
        setMdDatepicker("fromModel", fromDate);
        setMdDatepicker("toModel", toDate);
        selectValueFromNvAutocompleteByItemTypesAndDismiss("Zone Select", zoneName);
        selectValueFromNvAutocompleteByItemTypesAndDismiss("Hub Select", hubName);
        clickLoadSelection();
    }

    public void clickLoadSelection() {
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selection");
    }

    public void verifyRouteIdExists(String routeId) {
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ID);
        Assert.assertEquals("Route ID is not found.",routeId, actualRouteId);
    }

    public void verifyStatusInProgress() {
        String actualStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
        Assert.assertEquals("Route ID is not found.","In Progress", actualStatus);
    }

    public void verifyStatusComplete() {
        String actualStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
        Assert.assertEquals("Route ID is not found.","Complete", actualStatus);
    }

    public void clickFlagButton() {
        clickNvIconButtonByName("flag");
    }

    public void verifyStatusMarked() {
        String actualStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
        Assert.assertEquals("Route ID is not marked.","Marked", actualStatus);
    }

    public void clickCommentButtonAndSubmit() {
        clickNvIconButtonByNameAndWaitUntilEnabled("comment");
        sendKeysById("comments", "This comment is for test purpose.");
        clickNvApiTextButtonByNameAndWaitUntilDone("Submit");
        pause1s();
    }

    public void verifyCommentIsRight() {
        String actualComment = getTextOnTable(1, COLUMN_CLASS_DATA_COMMENT);
        Assert.assertEquals("Comment is different.","This comment is for test purpose.", actualComment);
    }

    public void pullOutOrderFromRoute(Order order, long routeId) {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        scenarioStorage.put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);

        searchTableByRouteId(routeId);
        Assert.assertFalse(String.format("Cannot find Route with ID = '%d' on table.", routeId), isTableEmpty());
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);

        switchToOutboundBreakrouteWindow(routeId);
        outboundBreakroutePage.pullOrderFromRoute(order.getTrackingId());
    }

    public void searchTableByRouteId(long routeId) {
        searchTableCustom1(COLUMN_CLASS_FILTER_ROUTE_ID, String.valueOf(routeId));
    }

    public void switchToOutboundBreakrouteWindow(long routeId) {
        switchToOtherWindow("outbound-breakroute/" + routeId);
        outboundBreakroutePage.waitUntilElementDisplayed();
    }

    public String getTextOnTable(int rowNumber, String columnDataClass) {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
