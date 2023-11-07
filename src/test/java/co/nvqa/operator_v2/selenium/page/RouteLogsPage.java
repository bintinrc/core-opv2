package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.pdf.RoutePassword;
import co.nvqa.commons.util.PdfUtils;
import co.nvqa.operator_v2.model.RouteLogsParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSwitch;
import co.nvqa.operator_v2.selenium.elements.ant.AntMenu;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntPicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextBox;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import java.util.Date;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class RouteLogsPage extends SimpleReactPage<RouteLogsPage> {

  @FindBy(css = "[data-testid='create-route-button']")
  public Button createRoute;

  @FindBy(css = "[data-testid='route-logs.clear-all-filters']")
  public Button clearAllFilters;

  @FindBy(xpath = "//div[@class='ant-modal-content'][.//div[contains(.,'Create route')]]")
  public CreateRouteDialog createRouteDialog;

  @FindBy(css = "[data-testid='route-logs.load-selection']")
  public AntButton loadSelection;

  @FindBy(css = "[data-testid='specific-search-submit-button']")
  public Button search;

  @FindBy(css = "div.ant-modal")
  public EditRoutesDialog editRoutesDialog;

  @FindBy(css = "div.ant-modal")
  public ArchiveSelectedRoutesDialog archiveSelectedRoutesDialog;

  @FindBy(css = "div.ant-modal")
  public UnarchiveSelectedRoutesDialog unarchiveSelectedRoutesDialog;

  @FindBy(css = "div.ant-modal")
  public BulkEditDetailsDialog bulkEditDetailsDialog;

  @FindBy(css = "div.ant-modal")
  public BulkRouteOptimisationDialog bulkRouteOptimisationDialog;

  @FindBy(css = "div.ant-modal")
  public EditDetailsDialog editDetailsDialog;

  @FindBy(css = "div.ant-modal")
  public MergeTransactionsWithinSelectedRoutesDialog mergeTransactionsWithinSelectedRoutesDialog;

  @FindBy(css = "div.ant-modal")
  public DeleteRoutesDialog deleteRoutesDialog;

  @FindBy(css = "div.ant-modal")
  public SelectionErrorDialog selectionErrorDialog;

  @FindBy(css = "div.ant-modal")
  public EditTagsDialog editTagsDialog;

  @FindBy(css = "[data-testid='specific-search-input']")
  public TextBox routeIdInput;

  @FindBy(css = "[data-testid='apply-action']")
  public AntMenu actionsMenu;

  @FindBy(xpath = "//div[./label[@for='routeDate']]/div")
  public AntRangePicker routeDateFilter;

  @FindBy(xpath = "//div[contains(@class,'FilterContainer')][.//div[contains(.,'Hub')]]")
  public AntFilterSelect3 hubFilter;

  @FindBy(xpath = "//div[contains(@class,'FilterContainer')][.//div[contains(.,'Driver')]]")
  public AntFilterSelect3 driverFilter;

  @FindBy(xpath = "//div[contains(@class,'FilterContainer')][.//div[contains(.,'Zone')]]")
  public AntFilterSelect3 zoneFilter;

  @FindBy(xpath = "//div[contains(@class,'FilterContainer')][.//div[contains(.,'Archived routes')]]")
  public AntFilterSwitch archivedRoutesFilter;

  @FindBy(id = "crossdock_hub")
  public AntSelect crossdockHub;

  @FindBy(xpath = "//div[text()='Add Filter']//div[contains(@class,'ant-select')]")
  public AntSelect3 addFilter;

  @FindBy(css = "div.preset-select div.ant-select")
  public AntSelect3 filterPreset;

  @FindBy(css = "[data-pa-label='Preset Actions']")
  public AntMenu presetActions;

  @FindBy(css = "div.ant-modal-content")
  public SavePresetDialog savePresetDialog;

  @FindBy(css = "div.ant-modal-content")
  public DeletePresetDialog deletePresetDialog;

  @FindBy(css = "div.ant-modal-content")
  public AddressVerifyRouteDialog addressVerifyRouteDialog;

  @FindBy(css = "div.ant-modal-content")
  public OptimizeSelectedRouteDialog optimizeSelectedRouteDialog;

  public RoutesTable routesTable;

  public static final String ACTION_ARCHIVE_SELECTED = "Archive selected";
  public static final String ACTION_UNARCHIVE_SELECTED = "Unarchive selected";
  public static final String ACTION_BULK_EDIT_DETAILS = "Bulk edit details";
  public static final String ACTION_MERGE_TRANSACTIONS_OF_SELECTED = "Merge transactions of selected";
  public static final String ACTION_OPTIMISE_SELECTED = "Optimise selected";
  public static final String ACTION_PRINT_PASSWORDS_OF_SELECTED = "Print passwords of selected";
  public static final String ACTION_PRINT_SELECTED = "Print selected";
  public static final String ACTION_DELETE_SELECTED = "Delete selected";
  public static final String EDIT_ROUTES_OF_SELECTED = "Edit routes of selected";

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
        expectedStatus), 100_000, "Did not get message: " + expectedStatus);
    pause2s();

    for (int i = 0; i < sizeOfListOfCreateRouteParams; i++) {
      Long actualRouteId = Long.valueOf(
          bulkRouteOptimisationDialog.optimizedRouteIds.get(i).getText());
      String actualStatus = bulkRouteOptimisationDialog.optimizedRouteStatuses.get(i).getText();
      Assertions.assertThat(expectedRouteIds).as("Route ID not found in optimised list.")
          .contains(actualRouteId);
      Assertions.assertThat(actualStatus).as(String.format("Route ID = %s", actualRouteId))
          .isEqualTo("PENDING");
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
      Assertions.assertThat(selectedRoutePassword.getRoutePassword())
          .as(String.format("Route Password for Route ID = %d", expectedRouteId))
          .isEqualTo(createRouteParams.getRoutePassword());
    }
  }

  public void addFilter(String name) {
    addFilter.selectValue(name);
  }

  public void setFilterAndLoadSelection(Date routeDateFrom, Date routeDateTo, String hubName) {
    waitUntilLoaded(60);
    routeDateFilter.setInterval(routeDateFrom, routeDateTo);
    if (StringUtils.isNotBlank(hubName)) {
      hubFilter.selectFilter(hubName);
    }
    loadSelection.clickAndWaitUntilDone();
  }

  @Override
  public void waitUntilLoaded() {
    if (createRoute.isDisplayedFast()) {
      super.waitUntilLoaded(1);
    } else {
      super.waitUntilLoaded(10);
    }
  }

  public void waitUntilLoaded(int timeoutInSeconds) {
    if (createRoute.isDisplayedFast()) {
      super.waitUntilLoaded(1, timeoutInSeconds);
    } else {
      super.waitUntilLoaded(10, timeoutInSeconds);
    }
  }

  public static class EditRoutesDialog extends AntModal {

    @FindBy(css = "[data-pa-label='Load Waypoints of Selected Route(s) Only']")
    public Button loadWpsOfSelectedRoutes;

    @FindBy(css = "[data-pa-label='Load Selected Route(s) and Unrouted Waypoints']")
    public Button loadSelectedRoutesAndUnroutedWps;

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
    public static final String ACTION_OPTIMIZE_ROUTE = "Optimize Route";
    public static final String ACTION_VERIFY_ADDRESS = "Verify Address";

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
          .put("comments", "route_comments")
          .put(COLUMN_TAGS, "tagNames")
          .build()
      );
      setEntityClass(RouteLogsParams.class);
      setColumnReaders(ImmutableMap.of(COLUMN_TAGS, this::getTags));
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT_DETAILS,
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='id']//button[@data-pa-label='Edit Detail']",
          ACTION_EDIT_ROUTE,
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='id']//button[@data-pa-label='Edit Route']",
          ACTION_OPTIMIZE_ROUTE,
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='id']//button[@data-pa-label='Optimise Route']",
          ACTION_VERIFY_ADDRESS,
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='id']//button[@data-pa-label='Address Verify Route']"));
    }

    public String getTags(int rowIndex) {
      String xpath = f(
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='tagNames']//span[contains(@class,'ant-select-selection-item-content')]",
          rowIndex);
      return isElementExistFast(xpath) ? StringUtils.join(getTextOfElements(xpath), ",") : null;
    }
  }

  public static class ArchiveSelectedRoutesDialog extends AntModal {

    @FindBy(css = "[data-pa-label='Archive Routes']")
    public AntButton archiveRoutes;

    @FindBy(css = "[data-pa-label='Continue Archive']")
    public AntButton continueBtn;

    public ArchiveSelectedRoutesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class UnarchiveSelectedRoutesDialog extends AntModal {

    @FindBy(css = "[data-pa-label='Unarchive Routes']")
    public AntButton unarchiveRoutes;

    public UnarchiveSelectedRoutesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class BulkEditDetailsDialog extends AntModal {

    @FindBy(css = "div.route-date")
    public AntPicker routeDate;

    @FindBy(css = "[data-testid='route-form.route-tags.field']")
    public AntSelect3 routeTags;

    @FindBy(css = "[data-testid='route-form.route-zone.field']")
    public AntSelect3 zone;

    @FindBy(css = "[data-testid='route-form.route-hub.field']")
    public AntSelect3 hub;

    @FindBy(css = "[data-testid='route-form.route-driver.field']")
    public AntSelect3 assignedDriver;

    @FindBy(xpath = ".//div[contains(@class,'create-route-field')][.//label[.='Vehicle']]//div[contains(@class,'ant-select')]")
    public AntSelect3 vehicle;

    @FindBy(css = "[data-testid='route-form.route-comment.field']")
    public ForceClearTextBox comments;

    @FindBy(css = "button[data-testid='create-button']")
    public AntButton saveChanges;

    @FindBy(xpath = ".//div[@class='ant-alert-message']//td[2]")
    public List<PageElement> errors;

    @FindBy(css = "[data-testid='bulk-progress-cancel.button']")
    public AntButton cancel;

    public BulkEditDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class MergeTransactionsWithinSelectedRoutesDialog extends AntModal {

    @FindBy(css = "[data-pa-label='Merge Transactions']")
    public AntButton mergeTransactions;

    public MergeTransactionsWithinSelectedRoutesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class EditDetailsDialog extends AntModal {

    @FindBy(css = "div.route-date")
    public AntPicker routeDate;

    @FindBy(css = "[data-testid='route-form.route-tags.field']")
    public AntSelect3 routeTags;

    @FindBy(css = "[data-testid='route-form.route-zone.field']")
    public AntSelect3 zone;

    @FindBy(css = "[data-testid='route-form.route-hub.field']")
    public AntSelect3 hub;

    @FindBy(css = "[data-testid='route-form.route-driver.field']")
    public AntSelect3 assignedDriver;

    @FindBy(xpath = ".//div[contains(@class,'create-route-field')][.//label[.='Vehicle']]//div[contains(@class,'ant-select')]")
    public AntSelect3 vehicle;

    @FindBy(css = "[data-testid='route-form.route-comment.field']")
    public ForceClearTextBox comments;

    @FindBy(css = "[data-pa-label='Delete']")
    public AntButton delete;

    @FindBy(css = "[data-pa-label='Save Changes']")
    public AntButton saveChanges;

    public EditDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class CreateRouteDialog extends AntModal {

    @FindBy(css = "[data-testid='duplicate']")
    public Button duplicateAbove;

    @FindBy(css = "[data-testid='create-button']")
    public Button createRoutes;

    @FindBy(css = ".ant-card-body")
    public List<RouteDetailsForm> routeDetailsForms;

    public CreateRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public static class RouteDetailsForm extends PageElement {

      @FindBy(css = "div.route-date")
      public AntPicker routeDate;

      @FindBy(xpath = ".//div[contains(@class,'create-route-field')][.//label[.='Route tags']]//div[contains(@class,'ant-select')]")
      public AntSelect3 routeTags;

      @FindBy(xpath = ".//div[contains(@class,'create-route-field')][.//label[.='Zone']]//div[contains(@class,'ant-select')]")
      public AntSelect3 zone;

      @FindBy(xpath = ".//div[contains(@class,'create-route-field')][.//label[.='Hub']]//div[contains(@class,'ant-select')]")
      public AntSelect3 hub;

      @FindBy(xpath = ".//div[contains(@class,'create-route-field')][.//label[.='Assigned driver']]//div[contains(@class,'ant-select')]")
      public AntSelect3 assignedDriver;

      @FindBy(xpath = ".//div[contains(@class,'create-route-field')][.//label[.='Vehicle']]//div[contains(@class,'ant-select')]")
      public AntSelect3 vehicle;

      @FindBy(xpath = ".//span[./input[@placeholder='Comment']]")
      public AntTextBox comments;

      public RouteDetailsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }
    }
  }

  public static class BulkRouteOptimisationDialog extends AntModal {

    @FindBy(xpath = ".//div[./span[.='Optimised routes']]/span[2]")
    public PageElement optimizedRoutesStatus;

    @FindBy(xpath = "(.//div[@class='BaseTable__body'])[1]//div[@role='row']/div[@role='gridcell'][1]")
    public List<PageElement> optimizedRouteIds;

    @FindBy(xpath = "(.//div[@class='BaseTable__body'])[1]//div[@role='row']/div[@role='gridcell'][2]")
    public List<PageElement> optimizedRouteStatuses;

    public BulkRouteOptimisationDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class DeleteRoutesDialog extends AntModal {

    @FindBy(css = "[data-pa-label='Delete']")
    public Button delete;

    public DeleteRoutesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class SelectionErrorDialog extends AntModal {

    @FindBy(xpath = ".//div[./div[.='Process:']]/div[2]")
    public PageElement process;

    @FindBy(xpath = ".//div[@class='BaseTable__body']//div[@role='row']/div[@role='gridcell'][1]")
    public List<PageElement> routeIds;

    @FindBy(xpath = ".//div[@class='BaseTable__body']//div[@role='row']/div[@role='gridcell'][2]")
    public List<PageElement> reasons;

    @FindBy(xpath = ".//button[.='Continue']")
    public Button continueBtn;

    public SelectionErrorDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class SavePresetDialog extends AntModal {

    @FindBy(xpath = "(.//div[contains(@class,'FilterPresetSaveDialogue')])[2]/div")
    public List<PageElement> selectedFilters;

    @FindBy(css = "input.ant-input")
    public TextBox presetName;

    @FindBy(css = "span.ant-typography")
    public PageElement helpText;

    @FindBy(css = "svg[data-icon='check-circle']")
    public PageElement confirmedIcon;

    @FindBy(css = "[data-pa-label='Cancel']")
    public Button cancel;

    @FindBy(css = "[data-pa-label='Save']")
    public Button save;

    @FindBy(css = "[data-pa-label='Update']")
    public Button update;

    public SavePresetDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class DeletePresetDialog extends AntModal {

    @FindBy(css = "div.ant-select")
    public AntSelect3 preset;

    @FindBy(css = "div[class*='NvAlert'] > div:nth-of-type(2)")
    public PageElement message;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    @FindBy(xpath = ".//button[.='Delete']")
    public Button delete;

    public DeletePresetDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class AddressVerifyRouteDialog extends AntModal {

    @FindBy(css = "[data-pa-label='Address Verify Route']")
    public Button addressVerifyRoute;

    public AddressVerifyRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class OptimizeSelectedRouteDialog extends AntModal {

    @FindBy(css = "div > p")
    public List<PageElement> message;

    @FindBy(css = "[data-pa-label='Cancel']")
    public Button cancel;

    @FindBy(css = "[data-testid='ok-button']")
    public Button optimizeRoute;

    public OptimizeSelectedRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class EditTagsDialog extends AntModal {

    @FindBy(css = "div.ant-select")
    public AntSelect3 tags;

    @FindBy(css = "[data-pa-label='Cancel']")
    public Button cancel;

    @FindBy(css = "[data-testid='update-tags.ok']")
    public Button updateTags;

    public EditTagsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}