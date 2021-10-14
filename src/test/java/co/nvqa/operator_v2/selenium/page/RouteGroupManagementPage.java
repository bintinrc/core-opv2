package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RouteGroupInfo;
import co.nvqa.operator_v2.model.RouteGroupJobDetails;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntIntervalCalendarPicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntMenu;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntCalendarPicker;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class RouteGroupManagementPage extends SimpleReactPage<RouteGroupManagementPage> {

  @FindBy(xpath = "//button[.='Create Route Group']")
  public Button createRouteGroup;

  @FindBy(xpath = "//button[normalize-space(.)='Apply Action']")
  public AntMenu actionsMenu;

  @FindBy(xpath = "//div[contains(@class,'StyledFilterDateBox')][.//div[.='Creation Date']]")
  public AntIntervalCalendarPicker creationDate;

  @FindBy(css = "div.ant-modal")
  public CreateRouteGroupsDialog createRouteGroupsDialog;

  @FindBy(css = "div.ant-modal")
  public EditRouteGroupDialog editRouteGroupDialog;

  @FindBy(css = "div.ant-modal")
  public ConfirmDeleteRouteGroupDialog confirmDeleteRouteGroupDialog;

  @FindBy(css = "div.ant-modal")
  public DeleteRouteGroupsDialog deleteRouteGroupsDialog;

  @FindBy(css = "div.ant-modal")
  public ClearRouteGroupsDialog clearRouteGroupsDialog;

  public RouteGroupsTable routeGroupsTable;

  public RouteGroupManagementPage(WebDriver webDriver) {
    super(webDriver);
    routeGroupsTable = new RouteGroupsTable(webDriver);
  }

  public static class EditRouteGroupDialog extends AntModal {

    @FindBy(xpath = ".//button[.='Save Changes']")
    public Button saveChanges;

    @FindBy(xpath = ".//button[.='Remove Selected']")
    public Button removeSelected;

    @FindBy(xpath = ".//button[.='Delete']")
    public Button delete;

    @FindBy(xpath = ".//button[.='Download Selected']")
    public Button downloadSelected;

    @FindBy(css = "input[placeholder='Group Name']")
    public TextBox groupName;

    @FindBy(css = "input[placeholder='Description']")
    public TextBox description;

    @FindBy(xpath = ".//div[./div[contains(text(),'Hub')]]//div[@role='combobox']")
    public AntSelect2 hub;

    public JobDetailsTable jobDetailsTable;

    public EditRouteGroupDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      jobDetailsTable = new JobDetailsTable(webDriver);
    }

    /**
     * Accessor for Jobs table
     */
    public static class JobDetailsTable extends AntTableV2<RouteGroupJobDetails> {

      public static final String COLUMN_TRACKING_ID = "trackingId";
      public static final String COLUMN_TYPE = "type";

      public JobDetailsTable(WebDriver webDriver) {
        super(webDriver);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put("sn", "__index__")
            .put("id", "id")
            .put("orderId", "orderId")
            .put(COLUMN_TRACKING_ID, "trackingId")
            .put(COLUMN_TYPE, "type")
            .put("shipper", "shipper")
            .put("address", "address")
            .put("routeId", "routeId")
            .put("status", "status")
            .put("priorityLevel", "priorityLevel")
            .put("startDateTime", "startDateTime")
            .put("endDateTime", "endDateTime")
            .put("dp", "dpName")
            .put("pickupSize", "pickupSize")
            .put("comments", "comments")
            .build()
        );
        setEntityClass(RouteGroupJobDetails.class);
        setTableLocator("//div[contains(@class,'EditRouteGroupFormTable')]");
      }
    }
  }

  public static class DeleteRouteGroupsDialog extends AntModal {

    public DeleteRouteGroupsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[@class='BaseTable__body']//div[@role='row']/div[@role='gridcell'][1]")
    public List<PageElement> groupIds;

    @FindBy(xpath = ".//div[@class='BaseTable__body']//div[@role='row']/div[@role='gridcell'][2]")
    public List<PageElement> groupNames;

    @FindBy(css = "input[type='password']")
    public TextBox password;

    @FindBy(xpath = ".//button[.='Delete Route Group(s)']")
    public Button delete;

  }

  public static class ConfirmDeleteRouteGroupDialog extends AntModal {

    @FindBy(xpath = ".//button[.='Delete']")
    public AntButton delete;

    public ConfirmDeleteRouteGroupDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ClearRouteGroupsDialog extends AntModal {

    public ClearRouteGroupsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[@class='BaseTable__body']//div[@role='row']/div[@role='gridcell'][1]")
    public List<PageElement> groupIds;

    @FindBy(xpath = ".//div[@class='BaseTable__body']//div[@role='row']/div[@role='gridcell'][2]")
    public List<PageElement> groupNames;

    @FindBy(css = "input[type='password']")
    public TextBox password;

    @FindBy(xpath = ".//button[.='Clear Route Group(s)']")
    public Button clear;

  }

  public static class CreateRouteGroupsDialog extends AntModal {

    public CreateRouteGroupsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[./div[contains(text(),'Group Name')]]/input")
    public TextBox groupName;

    @FindBy(xpath = ".//div[./div[contains(text(),'Description')]]/input")
    public TextBox description;

    @FindBy(xpath = ".//div[./div[contains(text(),'Hub')]]//div[@role='combobox']")
    public AntSelect2 hub;

    @FindBy(xpath = ".//button[.='Create Route Group & Add Transactions']")
    public Button create;
  }

  public static class RouteGroupsTable extends AntTableV2<RouteGroupInfo> {

    public static final String COLUMN_NAME = "name";
    public static final String COLUMN_DESCRIPTION = "description";
    public static final String COLUMN_CREATION_DATE_TIME = "createDateTime";
    public static final String ACTION_EDIT = "edit";
    public static final String ACTION_DELETE = "delete";

    public RouteGroupsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("id", "id")
          .put(COLUMN_NAME, "name")
          .put(COLUMN_DESCRIPTION, "name")
          .put(COLUMN_CREATION_DATE_TIME, "createDateTime")
          .put("noTransactions", "noTransactions")
          .put("noRoutedTransactions", "noRoutedTransactions")
          .put("noReservations", "noReservations")
          .put("noRoutedReservations", "noRoutedReservations")
          .put("hubName", "hubName")
          .build()
      );
      setEntityClass(RouteGroupInfo.class);
      setColumnReaders(ImmutableMap.of(
          COLUMN_NAME, this::getName,
          COLUMN_DESCRIPTION, this::getDescription
      ));
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT,
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='id']//i[@aria-label='icon: edit']",
          ACTION_DELETE,
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='id']//i[@aria-label='icon: delete']"
      ));
    }

    public String getName(int rowIndex) {
      String xpath = f(
          "//div[@class='BaseTable__body']//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='name']/div/div/div[1]",
          rowIndex);
      return isElementExistFast(xpath) ? getText(xpath) : null;
    }

    public String getDescription(int rowIndex) {
      String xpath = f(
          "//div[@class='BaseTable__body']//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='name']/div/div/div[2]",
          rowIndex);
      return isElementExistFast(xpath) ? getText(xpath) : null;
    }
  }
}