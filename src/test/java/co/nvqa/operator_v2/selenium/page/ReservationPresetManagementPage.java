package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ReservationGroup;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.ReservationPresetManagementPage.ReservationPresetTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.ReservationPresetManagementPage.ReservationPresetTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.ReservationPresetManagementPage.ReservationPresetTable.COLUMN_NAME;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class ReservationPresetManagementPage extends OperatorV2SimplePage {

  @FindBy(css = "md-dialog")
  public ConfirmDeleteDialog confirmDeleteDialog;

  @FindBy(css = "md-dialog")
  public AddNewGroupDialog addNewGroupDialog;

  @FindBy(css = "md-dialog")
  public EditGroupDialog editGroupDialog;

  @FindBy(css = "md-dialog")
  public AssignShipperDialog assignShipperDialog;

  @FindBy(css = "md-dialog")
  public UnassignShipperDialog unassignShipperDialog;

  @FindBy(css = "md-dialog")
  public CreateRouteDialog createRouteDialog;

  @FindBy(css = "md-dialog")
  public UploadCsvDialog uploadCsvDialog;

  @FindBy(xpath = "(//div[contains(@class,'title')]//md-menu)[2]")
  public MdMenu actionsMenu;

  @FindBy(css = "div.route-date")
  public MdDatepicker routeDate;

  @FindBy(xpath = "//md-tab-item[contains(.,'Pending')]")
  public PageElement pendingTab;

  @FindBy(xpath = "//md-tab-item[contains(.,'Overview')]")
  public PageElement overviewTab;

  @FindBy(css = "div[ng-repeat='pendingTask in ctrl.pendingTasks']")
  public List<PendingTaskBlock> pendingTasks;

  @FindBy(xpath = "(//div[contains(@class,'title')]//md-menu)[1]")
  public MdMenu moreActions;

  public static final String LOCATOR_SPINNER_LOADING_FILTERS = "//md-progress-circular/following-sibling::div[text()='Loading filters...']";

  public ReservationPresetTable reservationPresetTable;

  public ReservationPresetManagementPage(WebDriver webDriver) {
    super(webDriver);
    reservationPresetTable = new ReservationPresetTable(webDriver);
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER_LOADING_FILTERS);
    pause3s();
  }

  public void addNewGroup(ReservationGroup reservationPreset) {
    waitUntilPageLoaded();
    overviewTab.click();
    moreActions.selectOption("Add New Group");
    addNewGroupDialog.waitUntilVisible();
    addNewGroupDialog.fillForm(reservationPreset);
  }

  public void editGroup(String groupName, ReservationGroup reservationPreset) {
    reservationPresetTable.filterByColumn(COLUMN_NAME, groupName);
    reservationPresetTable.clickActionButton(1, ACTION_EDIT);
    editGroupDialog.fillForm(reservationPreset);
  }

  public void deleteGroup(String groupName) {
    reservationPresetTable.filterByColumn(COLUMN_NAME, groupName);
    reservationPresetTable.clickActionButton(1, ACTION_DELETE);
    confirmDeleteDialog.confirmDelete();
    waitUntilInvisibilityOfToast("Group Deleted");
  }

  public void verifyGroupProperties(String groupName, ReservationGroup expectedGroup) {
    reservationPresetTable.filterByColumn(COLUMN_NAME, groupName);
    ReservationGroup actualGroup = reservationPresetTable.readEntity(1);
    expectedGroup.compareWithActual(actualGroup, "id");
  }

  public void verifyGroupDeleted(String groupName) {
    reservationPresetTable.filterByColumn(COLUMN_NAME, groupName);
   Assertions.assertThat(        reservationPresetTable.isTableEmpty()).as("Group with Name [" + groupName + "] was not deleted").isTrue();
  }

  /**
   * Accessor for Add New Group dialog
   */
  @SuppressWarnings("UnusedReturnValue")
  public static class AddNewGroupDialog extends MdDialog {

    @FindBy(css = "[id^='commons.name']")
    public TextBox name;

    @FindBy(css = "nv-autocomplete[possible-options='ctrl.driversSelectionOptions']")
    public NvAutocomplete driver;

    @FindBy(css = "nv-autocomplete[possible-options='ctrl.hubsSelectionOptions']")
    public NvAutocomplete hub;

    @FindBy(name = "Submit")
    public NvApiTextButton submit;

    public AddNewGroupDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void setName(String value) {
      if (StringUtils.isNotBlank(value)) {
        name.setValue(value);
      }
    }

    public void setDriver(String value) {
      if (StringUtils.isNotBlank(value)) {
        driver.selectValue(value);
      }
    }

    public void setHub(String value) {
      if (StringUtils.isNotBlank(value)) {
        hub.selectValue(value);
      }
    }

    public void submitForm() {
      submit.clickAndWaitUntilDone();
      waitUntilInvisible();
    }

    public void fillForm(ReservationGroup reservationPreset) {
      setName(reservationPreset.getName());
      setDriver(reservationPreset.getDriver());
      setHub(reservationPreset.getHub());
      submitForm();
    }
  }

  /**
   * Accessor for Edit Group dialog
   */
  public static class EditGroupDialog extends AddNewGroupDialog {

    @FindBy(name = "Update")
    public NvApiTextButton update;

    public EditGroupDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @Override
    public void submitForm() {
      update.clickAndWaitUntilDone();
      waitUntilInvisible();
    }
  }

  /**
   * Accessor for Reservation Presets table
   */
  public static class ReservationPresetTable extends MdVirtualRepeatTable<ReservationGroup> {

    public static final String COLUMN_NAME = "name";
    public static final String COLUMN_DRIVER = "driver";
    public static final String COLUMN_HUB = "hub";
    public static final String COLUMN_NUMBER_OF_PICKUP_LOCATIONS = "number of pickup locations";

    public static final String ACTION_EDIT = "edit";
    public static final String ACTION_DELETE = "delete";

    public ReservationPresetTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_NAME, "name")
          .put(COLUMN_DRIVER, "c_driver-name")
          .put(COLUMN_HUB, "c_hub-name")
          .put(COLUMN_NUMBER_OF_PICKUP_LOCATIONS, "c_address-count")
          .build()
      );
      setActionButtonsLocators(
          ImmutableMap.of(ACTION_EDIT, "container.reservation-preset-management.edit-group",
              ACTION_DELETE, "container.reservation-preset-management.delete-group"));
      setEntityClass(ReservationGroup.class);
      setMdVirtualRepeat("group in getTableData()");
    }
  }

  public static class PendingTaskBlock extends PageElement {

    @FindBy(css = "span.status")
    public PageElement shipper;

    @FindBy(css = "div.address")
    public PageElement address;

    @FindBy(name = "container.reservation-preset-management.assign")
    public NvIconTextButton assign;

    @FindBy(name = "container.reservation-preset-management.unassign")
    public NvIconTextButton unassign;

    public PendingTaskBlock(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class AssignShipperDialog extends MdDialog {

    @FindBy(css = "md-autocomplete")
    public NvAutocomplete group;

    @FindBy(name = "Assign Shipper")
    public NvApiTextButton assignShipper;

    public AssignShipperDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class UnassignShipperDialog extends MdDialog {

    @FindBy(name = "Unassign Shipper")
    public NvApiTextButton unassignShipper;

    public UnassignShipperDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class CreateRouteDialog extends MdDialog {

    @FindBy(name = "commons.confirm")
    public NvApiTextButton confirm;

    public CreateRouteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class UploadCsvDialog extends MdDialog {

    @FindBy(css = "[label='Choose']")
    public NvButtonFilePicker selectFile;

    @FindBy(name = "Submit")
    public NvButtonSave submit;

    public UploadCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

}