package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterDateBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.Map;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.ACTION_COMMENT;
import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.COLUMN_COMMENTS;
import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.COLUMN_OUTBOUND_STATUS;
import static co.nvqa.operator_v2.selenium.page.OutboundMonitoringPage.RoutesTable.COLUMN_ROUTE_ID;

/**
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class OutboundMonitoringPage extends OperatorV2SimplePage implements ScenarioStorageKeys {

  public OutboundBreakroutePage outboundBreakroutePage;
  public OutboundBreakrouteV2Page outboundBreakrouteV2Page;

  public RoutesTable routesTable;

  @FindBy(tagName = "md-dialog")
  public PutCommentsModal putCommentsModal;

  @FindBy(xpath = "//nv-filter-date-box[.//p[.='Date']]")
  public NvFilterDateBox dateFilter;

  @FindBy(css = "nv-filter-box[item-types='Hubs Select']")
  public NvFilterBox hubsSelect;

  @FindBy(css = "nv-filter-box[item-types='Zones Select']")
  public NvFilterBox zonesSelect;

  @FindBy(name = "Load Selection")
  public NvApiTextButton loadSelection;

  @FindBy(name = "container.outbound-routebreak.pull-out")
  public NvIconTextButton pullOut;


  public OutboundMonitoringPage(WebDriver webDriver) {
    super(webDriver);
    outboundBreakroutePage = new OutboundBreakroutePage(getWebDriver());
    outboundBreakrouteV2Page = new OutboundBreakrouteV2Page(getWebDriver());
    routesTable = new RoutesTable(webDriver);
  }

  public void verifyRouteIdExists(String routeId) {
    assertFalse("Routes table is empty", routesTable.isTableEmpty());
    String actualRouteId = routesTable.getColumnText(1, COLUMN_ROUTE_ID);
    assertEquals("Route ID is not found.", routeId, actualRouteId);
  }

  public void verifyStatusInProgress() {
    String actualStatus = routesTable.getColumnText(1, COLUMN_OUTBOUND_STATUS);
    assertEquals("Route ID is not found.", "In Progress", actualStatus);
  }

  public void verifyStatusComplete() {
    String actualStatus = routesTable.getColumnText(1, COLUMN_OUTBOUND_STATUS);
    assertEquals("Route ID is not found.", "Complete", actualStatus);
  }

  public void verifyStatusMarked() {
    String actualStatus = routesTable.getColumnText(1, COLUMN_OUTBOUND_STATUS);
    assertEquals("Route ID is not marked.", "Marked", actualStatus);
  }

  public void clickCommentButtonAndSubmit() {
    routesTable.clickActionButton(1, ACTION_COMMENT);
    putCommentsModal.waitUntilVisible();
    putCommentsModal.comments.setValue("This comment is for test purpose.");
    putCommentsModal.submit.clickAndWaitUntilDone();
    pause2s();
  }

  public void verifyCommentIsRight() {
    String actualComment = routesTable.getColumnText(1, COLUMN_COMMENTS);
    assertEquals("Comment is different.", "This comment is for test purpose.", actualComment);
  }

  public void searchTableByRouteId(long routeId) {
    routesTable.filterByColumn(COLUMN_ROUTE_ID, String.valueOf(routeId));
  }

  public void switchToOutboundBreakrouteWindow(long routeId) {
    switchToOtherWindow("outbound-breakroute/" + routeId);
    outboundBreakroutePage.waitUntilElementDisplayed();
  }

  public static class RouteInfo extends DataEntity<RouteInfo> {

    String id;
    String unscannedInternal;
    String outboundStatus;
    String comments;

    public RouteInfo() {
    }

    public RouteInfo(Map<String, ?> data) {
      super(data);
    }

    public String getId() {
      return id;
    }

    public void setId(String id) {
      this.id = id;
    }

    public String getUnscannedInternal() {
      return unscannedInternal;
    }

    public void setUnscannedInternal(String unscannedInternal) {
      this.unscannedInternal = unscannedInternal;
    }

    public String getOutboundStatus() {
      return outboundStatus;
    }

    public void setOutboundStatus(String outboundStatus) {
      this.outboundStatus = outboundStatus;
    }

    public String getComments() {
      return comments;
    }

    public void setComments(String comments) {
      this.comments = comments;
    }
  }

  /**
   * Accessor for Routes table
   */
  public static class RoutesTable extends MdVirtualRepeatTable<RouteInfo> {

    public static final String COLUMN_ROUTE_ID = "id";
    public static final String COLUMN_OUTBOUND_STATUS = "outboundStatus";
    public static final String COLUMN_COMMENTS = "comments";
    public static final String ACTION_FLAG = "flag";
    public static final String ACTION_COMMENT = "comment";
    public static final String ACTION_EDIT = "edit";

    public RoutesTable(WebDriver webDriver) {
      super(webDriver);
      setMdVirtualRepeat("data in getTableData()");
      setEntityClass(RouteInfo.class);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ROUTE_ID, "route-id")
          .put("unscannedInternal", "unscanned-internal")
          .put(COLUMN_OUTBOUND_STATUS, "outbound-status")
          .put(COLUMN_COMMENTS, "comments")
          .build()
      );
      setActionButtonsLocators(
          ImmutableMap.of(ACTION_FLAG, "flag", ACTION_COMMENT, "comment", ACTION_EDIT, "edit"));
    }
  }

  public static class PutCommentsModal extends MdDialog {

    public PutCommentsModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[id ^= 'comments']")
    public TextBox comments;

    @FindBy(name = "Submit")
    public NvApiTextButton submit;
  }
}