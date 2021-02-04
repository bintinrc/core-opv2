package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RouteGroupJobDetails;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.util.Date;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class RouteGroupManagementPage extends OperatorV2SimplePage {

  private static final String MD_VIRTUAL_REPEAT = "routeGroup in getTableData()";
  public static final String COLUMN_CLASS_DATA_NAME = "name";

  public static final String ACTION_BUTTON_EDIT = "commons.edit";
  public static final String ACTION_BUTTON_DELETE = "commons.delete";

  private final CreateRouteGroupsPage createRouteGroupsPage;

  @FindBy(css = "div.action-toolbar  md-menu")
  public MdMenu actionsMenu;

  @FindBy(css = "md-dialog")
  public EditRouteGroupDialog editRouteGroupDialog;

  @FindBy(css = "md-dialog")
  public DeleteRouteGroupsDialog deleteRouteGroupsDialog;

  @FindBy(css = "md-dialog")
  public ClearRouteGroupsDialog clearRouteGroupsDialog;

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
    retryIfRuntimeExceptionOccurred(createRouteGroupsPage::waitUntilRouteGroupPageIsLoaded, 3);
  }

  public void selectRouteGroups(List<String> routeGroupNames) {
    routeGroupNames.forEach(this::selectRouteGroup);
  }

  public void selectRouteGroup(String routeGroupName) {
    searchTable(routeGroupName);
    pause100ms();
    checkRowWithMdVirtualRepeat(1, "routeGroup in getTableData()");
  }

  public void openEditRouteGroupDialog(String filterRouteGroupName) {
    searchTable(filterRouteGroupName);
    pause100ms();
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
    editRouteGroupDialog.waitUntilVisible();
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
  public static class EditRouteGroupDialog extends MdDialog {

    @FindBy(name = "container.route-group.dialogs.save-changes")
    public NvButtonSave saveChanges;

    @FindBy(name = "container.route-group.dialogs.remove-selected")
    public NvIconTextButton removeSelected;

    @FindBy(name = "commons.delete")
    public NvIconTextButton delete;

    @FindBy(name = "Download Selected")
    public NvApiTextButton downloadSelected;

    @FindBy(css = "[id^='commons.model.group-name']")
    public TextBox groupName;

    public JobDetailsTable jobDetailsTable;

    public EditRouteGroupDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      jobDetailsTable = new JobDetailsTable(webDriver);
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
            .put("shipper", "shipper")
            .put("address", "address")
            .put("routeId", "route-id")
            .put("status", "status")
            .put("startDateTime", "sdt")
            .put("endDateTime", "edt")
            .put("dp", "dp")
            .put("pickupSize", "pickup-size")
            .put("comments", "comments")
            .put("priorityLevel", "priority-level")
            .build()
        );
        setEntityClass(RouteGroupJobDetails.class);
        setMdVirtualRepeat("job in getTableData()");
      }
    }
  }

  /**
   * Accessor for Delete Route Group(s) dialog
   */
  public static class DeleteRouteGroupsDialog extends MdDialog {

    public DeleteRouteGroupsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(name = "container.route-group.delete-route-groups")
    public NvApiTextButton deleteRouteGroups;

    public void enterPassword(String password) {
      sendKeysById("password", password);
    }

    public List<String> getRouteGroupNames() {
      return getTextOfElements("//tr[@ng-repeat='routeGroup in ctrl.routeGroups']/td[2]");
    }
  }

  public static class ClearRouteGroupsDialog extends MdDialog {

    public ClearRouteGroupsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(name = "container.route-group.clear-route-groups")
    public NvApiTextButton clearRouteGroups;

    public List<String> getRouteGroupNames() {
      return getTextOfElements("//tr[@ng-repeat='routeGroup in ctrl.routeGroups']/td[2]");
    }
  }
}