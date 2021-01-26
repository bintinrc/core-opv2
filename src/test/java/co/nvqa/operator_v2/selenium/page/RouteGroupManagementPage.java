package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RouteGroupJobDetails;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class RouteGroupManagementPage extends OperatorV2SimplePage {

  private static final SimpleDateFormat DATE_FILTER_SDF = new SimpleDateFormat("EEEE MMMM d yyyy");

  private static final String MD_VIRTUAL_REPEAT = "routeGroup in getTableData()";
  public static final String COLUMN_CLASS_DATA_NAME = "name";

  public static final String ACTION_BUTTON_EDIT = "commons.edit";
  public static final String ACTION_BUTTON_DELETE = "commons.delete";

  private CreateRouteGroupsPage createRouteGroupsPage;
  private EditRouteGroupDialog editRouteGroupDialog;

  @FindBy(css = "md-dialog")
  public DeleteRouteGroupsDialog deleteRouteGroupsDialog;

  @FindBy(css = "md-dialog")
  public ConfirmDeleteDialog confirmDeleteRouteGroupDialog;

  @FindBy(xpath = "//div[.='Loading route groups...']")
  public PageElement loadingMessage;

  @FindBy(name = "container.route-group.create-route-group")
  public NvIconTextButton createRouteGroup;

  @FindBy(name = "Create Route Group & Add Transactions")
  public NvButtonSave createRouteGroupAndAddTransaction;

  @FindBy(css = "md-datepicker[ng-model='ctrl.filter.frDate']")
  public MdDatepicker fromDateFilter;

  @FindBy(css = "md-datepicker[ng-model='ctrl.filter.toDate']")
  public MdDatepicker toDateFilter;

  @FindBy(css = "input[ng-model='searchText']")
  public TextBox searchText;

  public RouteGroupManagementPage(WebDriver webDriver) {
    super(webDriver);
    createRouteGroupsPage = new CreateRouteGroupsPage(webDriver);
    editRouteGroupDialog = new EditRouteGroupDialog(webDriver);
  }

  public void createRouteGroup(String routeGroupName, String hubName) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        loadingMessage.waitUntilInvisible();
        createRouteGroup.click();
      } catch (Throwable ex) {
        refreshPage();
        throw ex;
      }
    }, 5);

    setRouteGroupNameValue(routeGroupName);
    setRouteGroupDescriptionValue(String
        .format("This Route Group is created by automation test from Operator V2. Created at %s.",
            CREATED_DATE_SDF.format(new Date())));

    if (hubName != null) {
      selectValueFromNvAutocompleteByPossibleOptions("fields.hub.options", hubName);
    }

    createRouteGroupAndAddTransaction.clickAndWaitUntilDone();
    retryIfRuntimeExceptionOccurred(() -> createRouteGroupsPage.waitUntilRouteGroupPageIsLoaded(),
        3);
  }

  public void editRouteGroup(String filterRouteGroupName, String newRouteGroupName) {
    searchTable(filterRouteGroupName);
    pause100ms();
    String actualName = getTextOnTable(1, RouteGroupManagementPage.COLUMN_CLASS_DATA_NAME);
    assertTrue("Route Group name not matched.", actualName
        .startsWith(filterRouteGroupName)); //Route Group name is concatenated with description.

    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
    setRouteGroupNameValue(newRouteGroupName);
    clickNvButtonSaveByName("container.route-group.dialogs.save-changes");
    waitUntilInvisibilityOfToast("Route Group Updated");
  }

  public void deleteRouteGroup(String filterRouteGroupName) {
    searchTable(filterRouteGroupName);
    pause100ms();
    clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
    confirmDeleteRouteGroupDialog.confirmDelete();
    waitUntilInvisibilityOfToast("Route Group Deleted");
  }

  public DeleteRouteGroupsDialog openDeleteRouteGroupsDialog() {
    clickMdMenuItem("Apply Action", "Delete Selected");
    deleteRouteGroupsDialog.waitUntilVisible();
    return deleteRouteGroupsDialog;
  }

  public void selectRouteGroups(List<String> routeGroupNames) {
    routeGroupNames.forEach(this::selectRouteGroup);
  }

  public void selectRouteGroup(String routeGroupName) {
    searchTable(routeGroupName);
    pause100ms();
    checkRowWithMdVirtualRepeat(1, "routeGroup in getTableData()");
  }

  public EditRouteGroupDialog openEditRouteGroupDialog(String filterRouteGroupName) {
    searchTable(filterRouteGroupName);
    pause100ms();
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
    return editRouteGroupDialog.waitUntilVisible();
  }

  public void setRouteGroupNameValue(String value) {
    sendKeysById("commons.model.group-name", value);
  }

  public void setRouteGroupDescriptionValue(String value) {
    sendKeysById("commons.description", value);
  }

  public void searchTable(String keyword) {
    toDateFilter.setDate(TestUtils.getNextDate(1));
    pause1s();
    searchText.clearAndSendKeys(keyword);
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
  }

  public void waitUntilRouteGroupPageIsLoaded() {
    waitUntilInvisibilityOfElementLocated(
        "//div[contains(@class,'message') and text()='Loading route groups...']");
  }

  /**
   * Accessor for Edit Route Group dialog
   */
  public static class EditRouteGroupDialog extends OperatorV2SimplePage {

    private static final String DIALOG_TITLE = "Edit Route Group";

    private JobDetailsTable jobDetailsTable;

    public EditRouteGroupDialog(WebDriver webDriver) {
      super(webDriver);
      jobDetailsTable = new JobDetailsTable(webDriver);
    }

    public EditRouteGroupDialog waitUntilVisible() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    public JobDetailsTable jobDetailsTable() {
      return jobDetailsTable;
    }

    public EditRouteGroupDialog clickRemoveSelected() {
      clickNvIconTextButtonByName("container.route-group.dialogs.remove-selected");
      return this;
    }

    /**
     * Accessor for Jobs table
     */
    public static class JobDetailsTable extends MdVirtualRepeatTable<RouteGroupJobDetails> {

      public static final String COLUMN_TRACKING_ID = "trackingId";
      public static final String COLUMN_TYPE = "type";

      public JobDetailsTable(WebDriver webDriver) {
        super(webDriver);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put("sn", "_idx")
            .put("id", "id")
            .put("orderId", "order-id")
            .put(COLUMN_TRACKING_ID, "tracking-id")
            .put(COLUMN_TYPE, "type")
            .build()
        );
        setEntityClass(RouteGroupJobDetails.class);
        setMdVirtualRepeat("job in getTableData()");
      }
    }

    public void saveChanges() {
      clickNvButtonSaveByNameAndWaitUntilDone("container.route-group.dialogs.save-changes");
      waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
    }
  }

  /**
   * Accessor for Delete Route Group(s) dialog
   */
  public static class DeleteRouteGroupsDialog extends MdDialog {

    private static final String DIALOG_TITLE = "Delete Route Group(s)";

    public DeleteRouteGroupsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public DeleteRouteGroupsDialog(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }

    @FindBy(name = "container.route-group.delete-route-groups")
    public NvApiTextButton deleteRouteGroups;

    public DeleteRouteGroupsDialog enterPassword(String password) {
      sendKeysById("password", password);
      return this;
    }

    public List<String> getRouteGroupNames() {
      return getTextOfElements("//tr[@ng-repeat='routeGroup in ctrl.routeGroups']/td[2]");
    }

    public void clickDeleteRouteGroups() {
      deleteRouteGroups.clickAndWaitUntilDone();
      waitUntilInvisible();
    }
  }
}
