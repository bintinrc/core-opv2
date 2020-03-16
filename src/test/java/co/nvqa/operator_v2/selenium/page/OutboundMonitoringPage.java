package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.cucumber.ScenarioStorage;
import co.nvqa.commons.model.DataEntity;
import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.Date;

import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.*;

/**
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class OutboundMonitoringPage extends OperatorV2SimplePage implements ScenarioStorageKeys
{
    private ScenarioStorage scenarioStorage;
    private OutboundBreakroutePage outboundBreakroutePage;

    public RoutesTable routesTable;

    @FindBy(tagName = "md-dialog")
    public PutCommentsModal putCommentsModal;

    public OutboundMonitoringPage(WebDriver webDriver, ScenarioStorage scenarioStorage)
    {
        super(webDriver);
        this.scenarioStorage = scenarioStorage;
        outboundBreakroutePage = new OutboundBreakroutePage(getWebDriver());
        routesTable = new RoutesTable(webDriver);
    }

    public void selectFiltersAndClickLoadSelection(Date fromDate, Date toDate, String zoneName, String hubName)
    {
        setMdDatepicker("fromModel", fromDate);
        setMdDatepicker("toModel", toDate);
        selectValueFromNvAutocompleteByItemTypesAndDismiss("Zone Select", zoneName);
        selectValueFromNvAutocompleteByItemTypesAndDismiss("Hub Select", hubName);
        clickLoadSelection();
    }

    public void clickLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selection");
    }

    public void verifyRouteIdExists(String routeId)
    {
        String actualRouteId = routesTable.getColumnText(1, COLUMN_ROUTE_ID);
        assertEquals("Route ID is not found.", routeId, actualRouteId);
    }

    public void verifyStatusInProgress()
    {
        String actualStatus = routesTable.getColumnText(1, COLUMN_OUTBOUND_STATUS);
        assertEquals("Route ID is not found.", "In Progress", actualStatus);
    }

    public void verifyStatusComplete()
    {
        String actualStatus = routesTable.getColumnText(1, COLUMN_OUTBOUND_STATUS);
        assertEquals("Route ID is not found.", "Complete", actualStatus);
    }

    public void clickFlagButton()
    {
        routesTable.clickActionButton(1, ACTION_FLAG);
    }

    public void verifyStatusMarked()
    {
        String actualStatus = routesTable.getColumnText(1, COLUMN_OUTBOUND_STATUS);
        assertEquals("Route ID is not marked.", "Marked", actualStatus);
    }

    public void clickCommentButtonAndSubmit()
    {
        routesTable.clickActionButton(1, ACTION_COMMENT);
        putCommentsModal.waitUntilVisible();
        putCommentsModal.comments.setValue("This comment is for test purpose.");
        putCommentsModal.submit.clickAndWaitUntilDone();
        pause1s();
    }

    public void verifyCommentIsRight()
    {
        String actualComment = routesTable.getColumnText(1, COLUMN_COMMENTS);
        assertEquals("Comment is different.", "This comment is for test purpose.", actualComment);
    }

    public void pullOutOrderFromRoute(Order order, long routeId)
    {
        String mainWindowHandle = getWebDriver().getWindowHandle();
        scenarioStorage.put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);

        searchTableByRouteId(routeId);
        assertFalse(String.format("Cannot find Route with ID = '%d' on table.", routeId), isTableEmpty());
        routesTable.clickActionButton(1, ACTION_EDIT);

        switchToOutboundBreakrouteWindow(routeId);
        outboundBreakroutePage.pullOrderFromRoute(order.getTrackingId());
    }

    public void searchTableByRouteId(long routeId)
    {
        routesTable.filterByColumn(COLUMN_ROUTE_ID, String.valueOf(routeId));
    }

    public void switchToOutboundBreakrouteWindow(long routeId)
    {
        switchToOtherWindow("outbound-breakroute/" + routeId);
        outboundBreakroutePage.waitUntilElementDisplayed();
    }

    /**
     * Accessor for Routes table
     */
    public static class RoutesTable extends MdVirtualRepeatTable<DataEntity<?>>
    {
        public static final String COLUMN_ROUTE_ID = "route-id";
        public static final String COLUMN_OUTBOUND_STATUS = "outbound-status";
        public static final String COLUMN_COMMENTS = "comments";
        public static final String ACTION_FLAG = "flag";
        public static final String ACTION_COMMENT = "comment";
        public static final String ACTION_EDIT = "edit";

        public RoutesTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_ROUTE_ID, "route-id")
                    .put(COLUMN_OUTBOUND_STATUS, "outbound-status")
                    .put(COLUMN_COMMENTS, "comments")
                    .build()
            );
            setActionButtonsLocators(ImmutableMap.of(ACTION_FLAG, "flag", ACTION_COMMENT, "comment", ACTION_EDIT, "edit"));
        }
    }

    public static class PutCommentsModal extends MdDialog
    {
        public PutCommentsModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        public PutCommentsModal(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
        {
            super(webDriver, searchContext, webElement);
        }

        @FindBy(css = "[id ^= 'comments']")
        public TextBox comments;

        @FindBy(name = "Submit")
        public NvApiTextButton submit;
    }
}