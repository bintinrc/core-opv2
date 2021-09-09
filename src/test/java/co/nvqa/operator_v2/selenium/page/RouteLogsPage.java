package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pdf.RoutePassword;
import co.nvqa.commons.util.PdfUtils;
import co.nvqa.operator_v2.model.RouteLogsParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntCalendarPicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSwitch;
import co.nvqa.operator_v2.selenium.elements.ant.AntIntervalCalendarPicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntMenu;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntMultiselect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import java.util.Date;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class RouteLogsPage extends SimpleReactPage {

  @FindBy(name = "Create Route")
  public NvIconTextButton createRoute;

  @FindBy(css = "[data-testid='create-route-button']")
  public Button createRouteReact;

  @FindBy(xpath = "//button[.='Clear All Filters']")
  public Button clearAllFilters;

  @FindBy(xpath = "//div[@class='ant-modal-content'][.//div[contains(.,'Create Route')]]")
  public CreateRouteReactDialog createRouteReactDialog;

  @FindBy(css = ".load-selection button")
  public AntButton loadSelection;

  @FindBy(xpath = "//button[.='Search']")
  public Button search;

  @FindBy(css = "md-dialog")
  public EditRoutesDialog editRoutesDialog;

  @FindBy(css = "md-dialog")
  public ArchiveSelectedRoutesDialog archiveSelectedRoutesDialog;

  @FindBy(css = "md-dialog")
  public UnarchiveSelectedRoutesDialog unarchiveSelectedRoutesDialog;

  @FindBy(css = "div.ant-modal")
  public BulkEditDetailsDialog bulkEditDetailsDialog;

  @FindBy(css = "div.ant-modal")
  public BulkRouteOptimisationDialog bulkRouteOptimisationDialog;

  @FindBy(css = "md-dialog")
  public EditDetailsDialog editDetailsDialog;

  @FindBy(css = "div.ant-modal")
  public MergeTransactionsWithinSelectedRoutesDialog mergeTransactionsWithinSelectedRoutesDialog;

  @FindBy(css = "md-dialog")
  public DeleteRoutesDialog deleteRoutesDialog;

  @FindBy(css = "md-dialog")
  public CreateRouteDialog createRouteDialog;

  @FindBy(css = "md-dialog")
  public SelectionErrorDialog selectionErrorDialog;

  @FindBy(css = "input[placeholder='Search for route ID']")
  public TextBox routeIdInput;

  @FindBy(xpath = "//button[normalize-space(.)='Apply Action']")
  public AntMenu actionsMenu;

  @FindBy(css = "div[data-datakey='tags'] div.ant-dropdown-trigger")
  public AntMultiselect selectTag;

  @FindBy(xpath = "//div[contains(@class,'StyledFilterWrapper')][.//div[contains(.,'Route Date')]]")
  public AntIntervalCalendarPicker routeDateFilter;

  @FindBy(xpath = "//div[contains(@class,'StyledFilterWrapper')][.//div[contains(.,'Hub')]]")
  public AntFilterSelect hubFilter;

  @FindBy(xpath = "//div[contains(@class,'StyledFilterWrapper')][.//div[contains(.,'Driver')]]")
  public AntFilterSelect driverFilter;

  @FindBy(xpath = "//div[contains(@class,'StyledFilterWrapper')][.//div[contains(.,'Zone')]]")
  public AntFilterSelect zoneFilter;

  @FindBy(xpath = "//div[contains(@class,'StyledFilterWrapper')][.//div[contains(.,'Archived Routes')]]")
  public AntFilterSwitch archivedRoutesFilter;

  @FindBy(id = "crossdock_hub")
  public AntSelect crossdockHub;

  @FindBy(xpath = "//div[text()='Add Filter']//div[@role='combobox']")
  public AntSelect2 addFilter;

  @FindBy(css = "div.preset-select div[role='combobox']")
  public AntSelect2 filterPreset;

  @FindBy(xpath = "//button[normalize-space(.)='Preset Actions']")
  public AntMenu presetActions;

  @FindBy(css = "div.ant-modal-content")
  public SavePresetDialog savePresetDialog;

  @FindBy(css = "div.ant-modal-content")
  public DeletePresetDialog deletePresetDialog;

  public RoutesTable routesTable;

  public static final String ACTION_ARCHIVE_SELECTED = "Archive Selected";
  public static final String ACTION_UNARCHIVE_SELECTED = "Unarchive Selected";
  public static final String ACTION_BULK_EDIT_DETAILS = "Bulk Edit Details";
  public static final String ACTION_MERGE_TRANSACTIONS_OF_SELECTED = "Merge Transactions Of Selected";
  public static final String ACTION_OPTIMISE_SELECTED = "Optimise Selected";
  public static final String ACTION_PRINT_PASSWORDS_OF_SELECTED = "Print Passwords of Selected";
  public static final String ACTION_PRINT_SELECTED = "Print Selected";
  public static final String ACTION_DELETE_SELECTED = "Delete Selected";

  public RouteLogsPage(WebDriver webDriver) {
    super(webDriver);
    routesTable = new RoutesTable(webDriver);
  }

  public void verifyMultipleRoutesIsOptimisedSuccessfully(
      List<Long> expectedRouteIds) {
    int sizeOfListOfCreateRouteParams = expectedRouteIds.size();

    bulkRouteOptimisationDialog.waitUntilVisible();
    String expectedStatus = f("%1$d of %1$d route(s) completed", sizeOfListOfCreateRouteParams);
    waitUntil(() -> StringUtils.equalsIgnoreCase(
        bulkRouteOptimisationDialog.optimizedRoutesStatus.getText(),
        expectedStatus), 10000);
    pause2s();

    for (int i = 0; i < sizeOfListOfCreateRouteParams; i++) {
      Long actualRouteId = Long.valueOf(bulkRouteOptimisationDialog.optimizedRouteIds.get(i).getText());
      String actualStatus = bulkRouteOptimisationDialog.optimizedRouteStatuses.get(i).getText();
      assertThat("Route ID not found in optimised list.", expectedRouteIds,
          Matchers.hasItem(actualRouteId));
      assertEquals(String.format("Route ID = %s", actualRouteId), "PENDING", actualStatus);
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

  public void addFilter(String name) {
    addFilter.selectValue(name);
  }

  public void verifyMultipleRoutesIsPrintedSuccessfully() {
    String latestFilenameOfDownloadedPdf = getLatestDownloadedFilename("route_printout");
    verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
  }

  public void setFilterAndLoadSelection(Date routeDateFrom, Date routeDateTo, String hubName) {
    inFrame(page -> {
      waitUntilLoaded();
      routeDateFilter.setInterval(routeDateFrom, routeDateTo);
      if (StringUtils.isNotBlank(hubName)) {
        hubFilter.selectFilter(hubName);
      }
      loadSelection.clickAndWaitUntilDone();
    });
  }

  @Override
  public void waitUntilLoaded() {
    super.waitUntilLoaded(3);
    clearAllFilters.waitUntilClickable();
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

  public static class RoutesTable extends AntTableV2<RouteLogsParams> {

    public static final String COLUMN_ROUTE_ID = "id";
    public static final String COLUMN_STATUS = "status";
    public static final String COLUMN_TAGS = "tags";
    public static final String ACTION_EDIT_DETAILS = "Edit Details";
    public static final String ACTION_EDIT_ROUTE = "Edit Route";

    public RoutesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("date", "date")
          .put(COLUMN_ROUTE_ID, "id")
          .put(COLUMN_STATUS, "status")
          .put("driverName", "driver_name")
          .put("routePassword", "route_password")
          .put("hub", "hub_name")
          .put("zone", "zone_name")
          .put("driverTypeName", "driver_type")
          .put("comments", "comments")
          .put(COLUMN_TAGS, "tags")
          .build()
      );
      setEntityClass(RouteLogsParams.class);
      setColumnReaders(ImmutableMap.of(COLUMN_TAGS, this::getTags));
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT_DETAILS, "container.route-logs.edit-details",
          ACTION_EDIT_ROUTE, "container.route-logs.edit-route"));
    }

    public String getTags(int rowIndex) {
      String xpath = f(
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='tags']//div[contains(@class,'SelectTag')]",
          rowIndex);
      return isElementExistFast(xpath) ? StringUtils.join(getTextOfElements(xpath), ",") : null;
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

  public static class BulkEditDetailsDialog extends AntModal {

    @FindBy(css = ".ant-calendar-picker")
    public AntCalendarPicker routeDate;

    @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][.//div[contains(text(),'Route Tags')]]//div[contains(@class,'ant-dropdown-trigger')]")
    public AntMultiselect routeTags;

    @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][.//div[.='Zone']]//div[contains(@class,'ant-select')]")
    public AntSelect2 zone;

    @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][.//div[.='Hub']]//div[contains(@class,'ant-select')]")
    public AntSelect2 hub;

    @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][.//div[.='Assigned Driver']]//div[contains(@class,'ant-select')]")
    public AntSelect2 assignedDriver;

    @FindBy(xpath = ".//div[contains(@class,'ant-select-selection')][.//div[.='Vehicle']]")
    public AntSelect2 vehicle;

    @FindBy(css = "[placeholder='Comment']")
    public TextBox comments;

    @FindBy(css = "button[data-testid='create-button']")
    public AntButton saveChanges;

    public BulkEditDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class MergeTransactionsWithinSelectedRoutesDialog extends AntModal {

    @FindBy(xpath = ".//button[.='Merge Transactions']")
    public AntButton mergeTransactions;

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

  public static class CreateRouteReactDialog extends AntModal {

    @FindBy(css = "[data-testid='duplicate']")
    public Button duplicateAbove;

    @FindBy(css = "[data-testid='create-button']")
    public Button createRoutes;

    @FindBy(css = ".ant-card-body")
    public List<RouteDetailsForm> routeDetailsForms;

    public CreateRouteReactDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public static class RouteDetailsForm extends PageElement {

      @FindBy(css = ".ant-calendar-picker")
      public AntCalendarPicker routeDate;

      @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][.//div[contains(text(),'Route Tags')]]//div[contains(@class,'ant-dropdown-trigger')]")
      public AntMultiselect routeTags;

      @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][.//div[.='Zone']]//div[contains(@class,'ant-select')]")
      public AntSelect2 zone;

      @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][.//div[.='Hub']]//div[contains(@class,'ant-select')]")
      public AntSelect2 hub;

      @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][.//div[.='Assigned Driver']]//div[contains(@class,'ant-select')]")
      public AntSelect2 assignedDriver;

      @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][4]//div[contains(@class,'ant-select')]")
      public AntSelect2 vehicle;

      @FindBy(css = "[placeholder='Comment']")
      public TextBox comments;

      public RouteDetailsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }
    }
  }

  public static class BulkRouteOptimisationDialog extends AntModal {

    @FindBy(css = "div[class*='OptimiseSelected'] > h4 + div")
    public PageElement optimizedRoutesStatus;

    @FindBy(xpath = "(.//div[@class='BaseTable__body'])[1]//div[@role='row']/div[@role='gridcell'][1]")
    public List<PageElement> optimizedRouteIds;

    @FindBy(xpath = "(.//div[@class='BaseTable__body'])[1]//div[@role='row']/div[@role='gridcell'][2]")
    public List<PageElement> optimizedRouteStatuses;

    public BulkRouteOptimisationDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
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

  public static class SavePresetDialog extends AntModal {

    @FindBy(css = "div.description-row")
    public List<PageElement> selectedFilters;

    @FindBy(css = "input.ant-input")
    public TextBox presetName;

    @FindBy(css = "div.nv-input-field-wrapper > span[class*='FieldWrapper']")
    public PageElement helpText;

    @FindBy(css = "svg[data-icon='check-circle']")
    public PageElement confirmedIcon;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    @FindBy(xpath = ".//button[.='Save']")
    public AntButton save;

    @FindBy(xpath = "//button[.='Update']")
    public Button update;

    public SavePresetDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class DeletePresetDialog extends AntModal {

    @FindBy(css = "div.ant-select")
    public AntSelect preset;

    @FindBy(css = "div.ant-typography")
    public PageElement message;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    @FindBy(xpath = ".//button[.='Delete']")
    public Button delete;

    public DeletePresetDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}