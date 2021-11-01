package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.cucumber.ScenarioStorage;
import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;
import co.nvqa.operator_v2.util.TestConstants;
import java.util.Date;
import java.util.List;
import org.openqa.selenium.WebDriver;

/**
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class OutboundAndRouteLoadMonitoringPage extends OperatorV2SimplePage implements
    ScenarioStorageKeys {

  private static final String COLUMN_CLASS_FILTER_ROUTE_ID = "id";
  private static final String COLUMN_CLASS_DATA_ID = "route-id";
  private static final String COLUMN_CLASS_DATA_STATUS = "outbound-status";
  private static final String COLUMN_CLASS_DATA_COMMENT = "comments";

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
  public void clickCheckboxByAriaLabel(String label) {
    click(f("//md-checkbox[@aria-label='%s']", label));
  }

  public void selectFilter(String label) {
    clickCheckboxByAriaLabel(label);
  }

  public void clickOnTab(String label) {
    click(f("//md-tab-item/span[contains(text(), '%s')]", label));
  }

  public void selectFiltersAndClickLoadSelection(Date fromDate, Date toDate, String zoneName,
      String hubName) {
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
    assertEquals("Route ID is not found.", routeId, actualRouteId);
  }

  public void searchTableByRouteId(String routeId) {
    searchTableCustom1("id", routeId);
  }


  public void verifyRouteIdDoesNotExists(String routeId) {
    searchTableByRouteId(routeId);
    assertTrue("Route id not found", isTableEmpty());
  }

  public void verifyStatusInProgress() {
    String actualStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
    assertEquals("Route ID is not found.", "In Progress", actualStatus);
  }

  public void verifyStatusComplete() {
    String actualStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
    assertEquals("Route ID is not found.", "Complete", actualStatus);
  }

  public void clickFlagButton() {
    clickNvIconButtonByName("flag");
  }

  public void verifyStatusMarked() {
    String actualStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
    assertEquals("Route ID is not marked.", "Marked", actualStatus);
  }

  public void clickCommentButtonAndSubmit() {
    clickNvIconButtonByNameAndWaitUntilEnabled("comment");
    sendKeysById("comments", "This comment is for test purpose.");
    clickNvApiTextButtonByNameAndWaitUntilDone("Submit");
    pause1s();
  }

  public void verifyCommentIsRight() {
    String actualComment = getTextOnTable(1, COLUMN_CLASS_DATA_COMMENT);
    assertEquals("Comment is different.", "This comment is for test purpose.", actualComment);
  }

  public void searchTableByRouteId(long routeId) {
    searchTableCustom1(COLUMN_CLASS_FILTER_ROUTE_ID, String.valueOf(routeId));
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
  }

  private String getTextOnTable(String columnClass) {
    return getText(f("//td[@class='%s']", columnClass));
  }

  public void verifyRouteIdAndInfo(String routeId, Integer assigned, Integer loaded,
      Integer passedBack, Integer missing) {
    String actualRouteId = getTextOnTable("id");
    assertEquals("RouteId must match", routeId, actualRouteId);
    ////# Note, please verify this:
    ////# - Driver Name is correct: You can get the expected driver name from this properties {ninja-driver-name}
    ////# - Parcels Assigned = 2
    ////# - Parcels Loaded = 2
    ////# - Parcels Passed Back = 2
    ////# - Parcels Missing Parcels = 0
    String driverName = TestConstants.NINJA_DRIVER_NAME;
    String actualName = getTextOnTable("driver_name");
    assertEquals("Driver name must match", driverName, actualName);

    String actualParcelsAssigned = getTextOnTable("total_parcels_count");
    assertEquals("Parcels Assigned must match", actualParcelsAssigned, assigned.toString());

    String actualParcelsLoaded = getTextOnTable("van_parcels_count");
    assertEquals("Parcels Loaded must match", actualParcelsLoaded, loaded.toString());

    String actualParcelsPassedBack = getTextOnTable("truck_parcels_count");
    assertEquals("Parcels Passed Back  must match", actualParcelsPassedBack, passedBack.toString());

    String actualParcelsMissingParcels = getTextOnTable("missing_parcels_count");
    assertEquals("Parcels Missing must match", actualParcelsMissingParcels, missing.toString());
  }


  //TODO: Should be moved to common
  public void clickInTableByClass(String className) {
    click(f("//td[@class='%s']/a", className));
  }

  public void verifyTrackingIds(List<String> ids) {
    Integer found = 0;
    List<String> actualIds = getTextOfElementsTrimmed(
        "//md-dialog-content//td[@class='tracking-id']");
    for (int idx = 0; idx < ids.size(); idx++) {
      String tranId = ids.get(idx);
      if (actualIds.stream().anyMatch(str -> str.trim().equals(tranId))) {
        found++;
      }
    }
    assertEquals("Tracking IDs must match", found, ids.size());
    closeModal();
  }
}
