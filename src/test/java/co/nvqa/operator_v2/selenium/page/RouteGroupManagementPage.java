package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RouteGroupInfo;
import co.nvqa.operator_v2.model.RouteGroupJobDetails;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntMenu;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextBox;
import com.beust.jcommander.Strings;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
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

  @FindBy(xpath = "//div[./label[.='Creation Date']]/div")
  public AntRangePicker creationDate;

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

    @FindBy(xpath = ".//span[./input[@placeholder='Group Name']]")
    public AntTextBox groupName;

    @FindBy(xpath = ".//span[./input[@placeholder='Description']]")
    public AntTextBox description;

    @FindBy(xpath = ".//div[.//label[contains(text(),'Hub')]]//div[contains(@class,'ant-select')]")
    public AntSelect3 hub;

    public JobDetailsTable jobDetailsTable;

    public EditRouteGroupDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      jobDetailsTable = new JobDetailsTable(webDriver);
    }

    /**
     * Accessor for Jobs table
     */
    public static class JobDetailsTable extends AntTableV2<RouteGroupJobDetails> {

      private static final String TAG_LOCATOR = "//div[@class='BaseTable__body']//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='jobTags']//*[contains(@class,'ant-tag')]";
      public static final String COLUMN_TRACKING_ID = "trackingId";
      public static final String COLUMN_ID = "id";
      public static final String COLUMN_TYPE = "type";

      public JobDetailsTable(WebDriver webDriver) {
        super(webDriver);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put("sn", "__index__")
            .put(COLUMN_ID, "id")
            .put("orderId", "orderId")
            .put(COLUMN_TRACKING_ID, "trackingId")
            .put(COLUMN_TYPE, "type")
            .put("shipper", "shipper")
            .put("address", "address")
            .put("routeId", "routeId")
            .put("status", "status")
            .put("jobTags", "jobTags")
            .put("priorityLevel", "priorityLevel")
            .put("startDateTime", "startDateTime")
            .put("endDateTime", "endDateTime")
            .put("dp", "dpName")
            .put("pickupSize", "pickupSize")
            .put("comments", "comments")
            .build()
        );
        setEntityClass(RouteGroupJobDetails.class);
        setTableLocator("//div[contains(@class,'edit-route-group-table')]");
        setColumnReaders(Map.of("jobTags", this::readJobTags));
      }

      public String readJobTags(int index) {
        var xpath = f(TAG_LOCATOR, index);
        return Strings.join(",", getTextOfElements(xpath));
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

    @FindBy(xpath = ".//div[contains(.,'Password')]//input")
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

    @FindBy(xpath = ".//div[./div/label[contains(text(),'Group Name')]]//input")
    public TextBox groupName;

    @FindBy(xpath = ".//div[./div/label[contains(text(),'Description')]]//input")
    public TextBox description;

    @FindBy(xpath = ".//div[.//label[contains(text(),'Hub')]]//div[contains(@class,'ant-select')]")
    public AntSelect3 hub;

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
          .put("noPaJobs", "noPaJobs")
          .put("noRoutedPaJobs", "noRoutedPaJobs")
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
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='id']//button[@data-pa-label='Edit']",
          ACTION_DELETE,
          "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='id']//button[@data-pa-label='Delete']"
      ));
    }

    public String getName(int rowIndex) {
      String xpath = f(
          "//div[@class='BaseTable__body']//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='name']/div/div/div",
          rowIndex);
      return isElementExistFast(xpath) ? getText(xpath) : null;
    }

    public String getDescription(int rowIndex) {
      String xpath = f(
          "//div[@class='BaseTable__body']//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='name']/div/div/span",
          rowIndex);
      return isElementExistFast(xpath) ? getText(xpath) : null;
    }
  }
}