package co.nvqa.operator_v2.selenium.page;

import static co.nvqa.operator_v2.selenium.page.HubsGroupManagementPage.HubsGroupTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.HubsGroupManagementPage.HubsGroupTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.HubsGroupManagementPage.HubsGroupTable.COLUMN_NAME;

import co.nvqa.operator_v2.model.ReservationGroup;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

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

  @FindBy(name = "container.reservation-preset-management.add-new-group")
  public NvIconTextButton addNewGroup;

  public static final String LOCATOR_SPINNER_LOADING_FILTERS = "//md-progress-circular/following-sibling::div[text()='Loading filters...']";

  private ReservationPresetTable reservationPresetTable;

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
    addNewGroup.click();
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
    assertTrue("Group with Name [" + groupName + "] was not deleted",
        reservationPresetTable.isTableEmpty());
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
}