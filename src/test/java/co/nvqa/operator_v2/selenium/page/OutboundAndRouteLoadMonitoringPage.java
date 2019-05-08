package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.cucumber.ScenarioStorage;
import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;
import org.openqa.selenium.WebDriver;

import java.util.Date;
import java.util.List;

/**
 *
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class OutboundAndRouteLoadMonitoringPage extends OperatorV2SimplePage implements ScenarioStorageKeys {
    private static final String COLUMN_CLASS_FILTER_ROUTE_ID = "id";
    private static final String COLUMN_CLASS_DATA_ID = "route-id";
    private  static final String COLUMN_CLASS_DATA_STATUS = "outbound-status";
    private  static final String COLUMN_CLASS_DATA_COMMENT = "comments";

    private static final String ACTION_BUTTON_EDIT = "edit";
    private static final String MD_VIRTUAL_REPEAT = "data in getTableData()";

    private ScenarioStorage scenarioStorage;
    private OutboundBreakroutePage outboundBreakroutePage;

    public OutboundAndRouteLoadMonitoringPage(WebDriver webDriver, ScenarioStorage scenarioStorage) {
        super(webDriver);
        this.scenarioStorage = scenarioStorage;
        outboundBreakroutePage = new OutboundBreakroutePage(getWebDriver());
    }


    //TODO: MOVE TO COMMON LATER
    public void clickCheckboxByAriaLabel(String label){
        click(f("//md-checkbox[@aria-label='%s']", label));
    }
    public void selectFilter(String label){
        clickCheckboxByAriaLabel(label);
    }

    public void clickOnTab(String label){
        click(f("//md-tab-item/span[contains(text(), '%s')]", label));
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
        searchTableByRouteId(routeId);
        String actualRouteId = getText("//td[@class='id']//span[@class='highlight']");
        assertEquals("Route ID is not found.",routeId, actualRouteId);
    }

    public void searchTableByRouteId(String routeId)
    {
        searchTableCustom1("id", routeId);
    }


    public void verifyRouteIdDoesNotExists(String routeId) {
        searchTableByRouteId(routeId);
        assertTrue("Route id not found", isTableEmpty());
    }

    public void verifyStatusInProgress() {
        String actualStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
        assertEquals("Route ID is not found.","In Progress", actualStatus);
    }

    public void verifyStatusComplete() {
        String actualStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
        assertEquals("Route ID is not found.","Complete", actualStatus);
    }

    public void clickFlagButton() {
        clickNvIconButtonByName("flag");
    }

    public void verifyStatusMarked() {
        String actualStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
        assertEquals("Route ID is not marked.","Marked", actualStatus);
    }

    public void clickCommentButtonAndSubmit() {
        clickNvIconButtonByNameAndWaitUntilEnabled("comment");
        sendKeysById("comments", "This comment is for test purpose.");
        clickNvApiTextButtonByNameAndWaitUntilDone("Submit");
        pause1s();
    }

    public void verifyCommentIsRight() {
        String actualComment = getTextOnTable(1, COLUMN_CLASS_DATA_COMMENT);
        assertEquals("Comment is different.","This comment is for test purpose.", actualComment);
    }

    public void pullOutOrderFromRoute(Order order, long routeId) {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        scenarioStorage.put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);

        searchTableByRouteId(routeId);
        assertFalse(String.format("Cannot find Route with ID = '%d' on table.", routeId), isTableEmpty());
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

    public void verifyRouteIdAndInfo() {
    }

    public void clickInTableByClass(String className) {
        click(f("//td[@class='%s']/a", className));
    }

    public void verifyTrackingIds(List<String> ids) {
        Integer found = 0;
        List<String> actualIds = getTextOfElementsTrimmed("//md-dialog-content//td[@class='tracking-id']");
        for (int idx=0; idx<ids.size(); idx++){
            String tranId = ids.get(idx);
            if(actualIds.stream().anyMatch(str -> str.trim().equals(tranId)))
                found++;
        }
        assertTrue("All match found", found==ids.size());
    }
}
