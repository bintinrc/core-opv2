package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import com.google.common.collect.ImmutableMap;
import java.util.Map;
import org.assertj.core.api.Assertions;
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
public class OutboundMonitoringPage extends SimpleReactPage<OutboundMonitoringPage> implements
    ScenarioStorageKeys {

  public OutboundBreakrouteV2Page outboundBreakrouteV2Page;

  public RoutesTable routesTable;

  @FindBy(css = ".ant-modal")
  public PutCommentsModal putCommentsModal;

  @FindBy(css = "[placeholder='Select date']")
  public PageElement dateFilter;

  @FindBy(css = "[data-testid='hubIds.hubIds']")
  public AntSelect3 hubsSelect;

  @FindBy(css = "[data-testid='zoneIds.zoneIds']")
  public AntSelect3 zonesSelect;

  @FindBy(css = "[data-testid='outbound-monitoring-filter_load-selection-button']")
  public Button loadSelection;

  @FindBy(css = "[data-testid='outbound-details_pull-out-button']")
  public Button pullOut;


  public OutboundMonitoringPage(WebDriver webDriver) {
    super(webDriver);
    outboundBreakrouteV2Page = new OutboundBreakrouteV2Page(getWebDriver());
    routesTable = new RoutesTable(webDriver);
  }

  public void verifyRouteIdExists(String routeId) {
    Assertions.assertThat(routesTable.isTableEmpty()).as("Routes table is empty").isFalse();
    String actualRouteId = routesTable.getColumnText(1, COLUMN_ROUTE_ID);
    Assertions.assertThat(actualRouteId).as("Route ID is not found.").isEqualTo(routeId);
  }

  public void verifyStatusInProgress() {
    String actualStatus = routesTable.getColumnText(1, COLUMN_OUTBOUND_STATUS);
    Assertions.assertThat(actualStatus).as("Route ID is not found.").isEqualTo("In Progress");
  }

  public void verifyStatusComplete() {
    String actualStatus = routesTable.getColumnText(1, COLUMN_OUTBOUND_STATUS);
    Assertions.assertThat(actualStatus).as("Route ID is not found.").isEqualTo("Complete");
  }

  public void verifyStatusMarked() {
    String actualStatus = routesTable.getColumnText(1, COLUMN_OUTBOUND_STATUS);
    Assertions.assertThat(actualStatus).as("Route ID is not marked.").isEqualTo("Marked");
  }

  public void clickCommentButtonAndSubmit() {
    routesTable.clickActionButton(1, ACTION_COMMENT);
    putCommentsModal.waitUntilVisible();
    putCommentsModal.comments.setValue("This comment is for test purpose.");
    putCommentsModal.submit.click();
    pause2s();
  }

  public void verifyCommentIsRight() {
    String actualComment = routesTable.getColumnText(1, COLUMN_COMMENTS);
    Assertions.assertThat(actualComment).as("Comment is different.")
        .isEqualTo("This comment is for test purpose.");
  }

  public void searchTableByRouteId(long routeId) {
    routesTable.filterByColumn(COLUMN_ROUTE_ID, String.valueOf(routeId));
  }

  public void switchToOutboundBreakrouteWindow(long routeId) {
    switchToOtherWindow("outbound-breakroute-v2?routeIds=" + routeId);
    pause5s();
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
  public static class RoutesTable extends AntTableV2<RouteInfo> {

    public static final String COLUMN_ROUTE_ID = "id";
    public static final String COLUMN_OUTBOUND_STATUS = "outboundStatus";
    public static final String COLUMN_COMMENTS = "comments";
    public static final String ACTION_FLAG = "flag";
    public static final String ACTION_COMMENT = "comment";
    public static final String ACTION_EDIT = "edit";

    public RoutesTable(WebDriver webDriver) {
      super(webDriver);
      setEntityClass(RouteInfo.class);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ROUTE_ID, "route_id")
          .put("unscannedInternal", "parcels_not_scanned_in_hub")
          .put(COLUMN_OUTBOUND_STATUS, "outbound_status")
          .put(COLUMN_COMMENTS, "comments")
          .build()
      );
      setActionButtonsLocators(
          Map.of(
              ACTION_FLAG,
              "//div[@role='row'][%d]//div[@role='gridcell']//button[contains(@data-testid,'flag')]",
              ACTION_COMMENT,
              "//div[@role='row'][%d]//div[@role='gridcell']//button[contains(@data-testid,'comment')]",
              ACTION_EDIT,
              "//div[@role='row'][%d]//div[@role='gridcell']//button[contains(@data-testid,'edit')]")
      );
    }
  }

  public static class PutCommentsModal extends AntModal {

    public PutCommentsModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='outbound-monitoring_comments-input']")
    public TextBox comments;

    @FindBy(css = "[data-testid='edit-comment-submit-button']")
    public Button submit;
  }
}