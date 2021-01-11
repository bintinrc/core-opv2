package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pdf.RoutePassword;
import co.nvqa.commons.util.PdfUtils;
import co.nvqa.operator_v2.model.RouteLogsParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterDateBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import java.util.Date;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class RouteLogsPage extends OperatorV2SimplePage {

  @FindBy(name = "Create Route")
  public NvIconTextButton createRoute;

  @FindBy(xpath = "//nv-filter-date-box[.//p[.='Route Date']]")
  public NvFilterDateBox routeDateFilter;

  @FindBy(xpath = "//nv-filter-box[@main-title='Hub']")
  public NvFilterBox hubFilter;

  @FindBy(name = "commons.load-selection")
  public NvApiTextButton loadSelection;

  @FindBy(name = "container.route-logs.search")
  public NvApiTextButton search;

  @FindBy(css = "md-dialog")
  public EditRoutesDialog editRoutesDialog;

  @FindBy(css = "md-dialog")
  public ArchiveSelectedRoutesDialog archiveSelectedRoutesDialog;

  @FindBy(css = "md-dialog")
  public UnarchiveSelectedRoutesDialog unarchiveSelectedRoutesDialog;

  @FindBy(css = "md-dialog")
  public BulkEditDetailsDialog bulkEditDetailsDialog;

  @FindBy(css = "md-dialog")
  public EditDetailsDialog editDetailsDialog;

  @FindBy(css = "md-dialog")
  public MergeTransactionsWithinSelectedRoutesDialog mergeTransactionsWithinSelectedRoutesDialog;

  @FindBy(css = "md-dialog")
  public DeleteRoutesDialog deleteRoutesDialog;

  @FindBy(css = "md-dialog")
  public CreateRouteDialog createRouteDialog;

  @FindBy(css = "md-dialog")
  public SelectionErrorDialog selectionErrorDialog;

  @FindBy(css = "input[ng-model='ctrl.routeId']")
  public TextBox routeIdInput;

  @FindBy(css = "div.view-container md-menu")
  public MdMenu actionsMenu;

  @FindBy(css = "[id^='container.route-logs.select-tag']")
  public MdSelect selectTag;

  public RoutesTable routesTable;

  public static final String ACTION_ARCHIVE_SELECTED = "Archive Selected";
  public static final String ACTION_UNARCHIVE_SELECTED = "Unarchive Selected";
  public static final String ACTION_BULK_EDIT_DETAILS = "Bulk Edit Details";
  public static final String ACTION_MERGE_TRANSACTIONS_OF_SELECTED = "Merge Transactions of Selected";
  public static final String ACTION_OPTIMISE_SELECTED = "Optimise Selected";
  public static final String ACTION_PRINT_PASSWORDS_OF_SELECTED = "Print Passwords of Selected";
  public static final String ACTION_PRINT_SELECTED = "Print Selected";
  public static final String ACTION_DELETE_SELECTED = "Delete Selected";

  public RouteLogsPage(WebDriver webDriver) {
    super(webDriver);
    routesTable = new RoutesTable(webDriver);
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    waitUntilInvisibilityOfElementLocated(
        "//md-progress-circular/following-sibling::div[text()='Loading data...']");
  }

  public void verifyMultipleRoutesIsOptimisedSuccessfully(
      List<Long> expectedRouteIds) {
    int sizeOfListOfCreateRouteParams = expectedRouteIds.size();
    String[] arrayOfRouteIdAsString = expectedRouteIds.stream()
        .map(String::valueOf).toArray(String[]::new);
    waitUntilVisibilityOfElementLocated(String.format(
        "//h5[contains(text(), 'Optimized Routes')]/small[contains(text(), '%d of %d route(s) completed')]",
        sizeOfListOfCreateRouteParams, sizeOfListOfCreateRouteParams));

    for (int i = 1; i <= sizeOfListOfCreateRouteParams; i++) {
      String actualRouteId = getText(
          String.format("//tr[@ng-repeat='route in optimizedRoutes'][%d]/td[1]", i));
      String actualStatus = getText(
          String.format("//tr[@ng-repeat='route in optimizedRoutes'][%d]/td[2]", i));
      assertThat("Route ID not found in optimised list.", actualRouteId,
          isOneOf(arrayOfRouteIdAsString));
      assertEquals(String.format("Route ID = %s", actualRouteId), "Optimized", actualStatus);
    }
  }

  public void verifyPrintedPasswordsOfSelectedRoutesInfoIsCorrect(
      List<RouteLogsParams> listOfCreateRouteParams) {
    String latestFilenameOfDownloadedPdf = getLatestDownloadedFilename("routes_password");
    verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
    List<RoutePassword> listOfRoutePassword = PdfUtils
        .getRoutePassword(TestConstants.TEMP_DIR + latestFilenameOfDownloadedPdf);

    for (RouteLogsParams createRouteParams : listOfCreateRouteParams) {
      long expectedRouteId = Long.parseLong(createRouteParams.getId());
      RoutePassword selectedRoutePassword = null;

      for (RoutePassword routePassword : listOfRoutePassword) {
        if (routePassword.getRouteId() != null && expectedRouteId == routePassword.getRouteId()) {
          selectedRoutePassword = routePassword;
          break;
        }
      }

      assertNotNull(
          String.format("Route password for Route ID = %d not found on PDF.", expectedRouteId),
          selectedRoutePassword);
      assertEquals(String.format("Route Password for Route ID = %d", expectedRouteId),
          createRouteParams.getRoutePassword(), selectedRoutePassword.getRoutePassword());
    }
  }

  public void verifyMultipleRoutesIsPrintedSuccessfully() {
    String latestFilenameOfDownloadedPdf = getLatestDownloadedFilename("route_printout");
    verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
  }

  public void setFilterAndLoadSelection(Date routeDateFrom, Date routeDateTo, String hubName) {
    routeDateFilter.selectDates(routeDateFrom, routeDateTo);
    if (StringUtils.isNotBlank(hubName)) {
      hubFilter.selectFilter(hubName);
    }
    loadSelection.clickAndWaitUntilDone();
  }

  public static class EditRoutesDialog extends MdDialog {

    @FindBy(name = "container.route-logs.load-wps-of-selected-routes")
    public NvIconTextButton loadWpsOfSelectedRoutes;

    @FindBy(name = "container.route-logs.load-selected-routes-and-unrouted-wps")
    public NvIconTextButton loadSelectedRoutesAndUnroutedWps;

    public EditRoutesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class RoutesTable extends MdVirtualRepeatTable<RouteLogsParams> {

    public static final String COLUMN_ROUTE_ID = "id";
    public static final String COLUMN_STATUS = "status";
    public static final String COLUMN_TAGS = "tags";
    public static final String ACTION_EDIT_DETAILS = "Edit Details";
    public static final String ACTION_EDIT_ROUTE = "Edit Route";

    public RoutesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("date", "_date")
          .put(COLUMN_ROUTE_ID, "id")
          .put(COLUMN_STATUS, "status")
          .put("driverName", "_driver-name")
          .put("routePassword", "route-password")
          .put("hub", "_hub-name")
          .put("zone", "_zone-name")
          .put("driverTypeName", "_driver-type-name")
          .put("comments", "comments")
          .put(COLUMN_TAGS, "tags")
          .build()
      );
      setEntityClass(RouteLogsParams.class);
      setMdVirtualRepeat("route in getTableData()");
      setColumnReaders(ImmutableMap.of(COLUMN_TAGS, this::getTags));
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT_DETAILS, "container.route-logs.edit-details",
          ACTION_EDIT_ROUTE, "container.route-logs.edit-route"));
    }

    public String getTags(int rowIndex) {
      String xpath = f(
          "//tr[@md-virtual-repeat='route in getTableData()'][%d]//td[contains(@class,'tags')]//md-select[contains(@aria-label, 'Select Tag:')]",
          rowIndex);
      return isElementExistFast(xpath) ? getText(xpath) : null;
    }
  }

  public static class ArchiveSelectedRoutesDialog extends MdDialog {

    @FindBy(name = "container.route-logs.archive-routes")
    public NvIconTextButton archiveRoutes;

    public ArchiveSelectedRoutesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class UnarchiveSelectedRoutesDialog extends MdDialog {

    @FindBy(name = "container.route-logs.unarchive-routes")
    public NvIconTextButton unarchiveRoutes;

    public UnarchiveSelectedRoutesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class BulkEditDetailsDialog extends MdDialog {

    @FindBy(id = "commons.model.route-date")
    public MdDatepicker routeDate;

    @FindBy(css = "[id^='commons.model.route-tags']")
    public MdSelect routeTags;

    @FindBy(xpath = "(.//md-autocomplete)[1]")
    public MdAutocomplete hub;

    @FindBy(xpath = "(.//md-autocomplete)[2]")
    public MdAutocomplete assignedDriver;

    @FindBy(xpath = "(.//md-autocomplete)[3]")
    public MdAutocomplete vehicle;

    @FindBy(id = "comments")
    public TextBox comments;

    @FindBy(name = "commons.save-changes")
    public NvButtonSave saveChanges;

    public BulkEditDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class MergeTransactionsWithinSelectedRoutesDialog extends MdDialog {

    @FindBy(css = "button[aria-label='Merge Transactions']")
    public Button mergeTransactions;

    public MergeTransactionsWithinSelectedRoutesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class EditDetailsDialog extends MdDialog {

    @FindBy(id = "commons.model.route-date")
    public MdDatepicker routeDate;

    @FindBy(css = "[id^='commons.model.route-tags']")
    public MdSelect routeTags;

    @FindBy(xpath = "(.//md-autocomplete)[1]")
    public MdAutocomplete hub;

    @FindBy(xpath = "(.//md-autocomplete)[2]")
    public MdAutocomplete assignedDriver;

    @FindBy(xpath = "(.//md-autocomplete)[3]")
    public MdAutocomplete vehicle;

    @FindBy(id = "comments")
    public TextBox comments;

    @FindBy(name = "commons.delete")
    public NvIconTextButton delete;

    @FindBy(name = "commons.save-changes")
    public NvButtonSave saveChanges;

    public EditDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class CreateRouteDialog extends MdDialog {

    @FindBy(name = "container.route-logs.duplicate-above")
    public NvIconTextButton duplicateAbove;

    @FindBy(name = "Create Route(s)")
    public NvButtonSave createRoutes;

    @FindBy(css = "nv-container-box[ng-repeat='route in fields track by $index']")
    public List<RouteDetailsForm> routeDetailsForms;

    public CreateRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public static class RouteDetailsForm extends PageElement {

      @FindBy(id = "commons.model.route-date")
      public MdDatepicker routeDate;

      @FindBy(css = "[id^='commons.model.route-tags']")
      public MdSelect routeTags;

      @FindBy(xpath = "(.//md-autocomplete)[1]")
      public MdAutocomplete zone;

      @FindBy(xpath = "(.//md-autocomplete)[2]")
      public MdAutocomplete hub;

      @FindBy(xpath = "(.//md-autocomplete)[3]")
      public MdAutocomplete assignedDriver;

      @FindBy(xpath = "(.//md-autocomplete)[4]")
      public MdAutocomplete vehicle;

      @FindBy(id = "comments")
      public TextBox comments;

      public RouteDetailsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }
    }
  }

  public static class DeleteRoutesDialog extends MdDialog {

    @FindBy(css = "button[aria-label='Delete']")
    public Button delete;

    public DeleteRoutesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class SelectionErrorDialog extends MdDialog {

    @FindBy(xpath = "//div[./label[.='Process']]/p")
    public PageElement process;

    @FindBy(xpath = ".//tr[@ng-repeat='row in ctrl.routesValidationErrorData.errors']/td[1]")
    public List<PageElement> routeIds;

    @FindBy(xpath = ".//tr[@ng-repeat='row in ctrl.routesValidationErrorData.errors']/td[2]")
    public List<PageElement> reasons;

    @FindBy(name = "commons.continue")
    public NvIconTextButton continueBtn;

    public SelectionErrorDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}