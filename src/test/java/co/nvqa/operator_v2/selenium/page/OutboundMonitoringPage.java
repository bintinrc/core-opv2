package co.nvqa.operator_v2.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Tristania Siagian
 */
public class OutboundMonitoringPage extends OperatorV2SimplePage
{

    private static final String COLUMN_CLASS_FILTER_ROUTE_ID = "id";
    private static final String COLUMN_CLASS_ID = "route-id";
    private  static final String COLUMN_CLASS_STATUS = "outbound-status";
    private  static final String COLUMN_CLASS_COMMENT = "comments";

    private static final String MD_VIRTUAL_REPEAT_NAME = "data in getTableData()";

    public OutboundMonitoringPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void clickLoadSelection() {
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selection");
    }

    public void searchRouteId(String routeId) {
        searchTableByRouteId(routeId);
    }

    public void verifyRouteIdExists(String routeId) {
        String actualRouteId = getTextOnTableWithMdVirtualRepeat(1, COLUMN_CLASS_ID, MD_VIRTUAL_REPEAT_NAME);
        Assert.assertEquals("Route ID is not found.",routeId, actualRouteId);
    }

    public void verifyStatusInProgress() {
        String actualStatus = getTextOnTableWithMdVirtualRepeat(1, COLUMN_CLASS_STATUS, MD_VIRTUAL_REPEAT_NAME);
        Assert.assertEquals("Route ID is not found.","In Progress", actualStatus);
    }

    public void verifyStatusComplete() {
        String actualStatus = getTextOnTableWithMdVirtualRepeat(1, COLUMN_CLASS_STATUS, MD_VIRTUAL_REPEAT_NAME);
        Assert.assertEquals("Route ID is not found.","Complete", actualStatus);
    }

    public void clickFlagButton() {
        clickNvIconButtonByName("flag");
    }

    public void verifyStatusMarked() {
        String actualStatus = getTextOnTableWithMdVirtualRepeat(1, COLUMN_CLASS_STATUS, MD_VIRTUAL_REPEAT_NAME);
        Assert.assertEquals("Route ID is not marked.","Marked", actualStatus);
    }

    public void clickCommentButtonAndSubmit() {
        clickNvIconButtonByNameAndWaitUntilEnabled("comment");
        sendKeysById("comments", "This comment is for test purpose.");
        clickNvApiTextButtonByNameAndWaitUntilDone("Submit");
        pause1s();
    }

    public void verifyCommentIsRight() {
        String actualComment = getTextOnTableWithMdVirtualRepeat(1, COLUMN_CLASS_COMMENT, MD_VIRTUAL_REPEAT_NAME);
        Assert.assertEquals("Comment is different.","This comment is for test purpose.", actualComment);
    }

    public void searchTableByRouteId(String routeId) {
        searchTableCustom1(COLUMN_CLASS_FILTER_ROUTE_ID, routeId);
    }
}
