package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.DriverTypeParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.commons.util.NvMatchers.hasItemIgnoreCase;
import static co.nvqa.commons.util.NvMatchers.hasItemsIgnoreCase;
import static org.hamcrest.Matchers.anyOf;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;

/**
 * Modified by Sergey Mishanin
 *
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public class DriverTypeManagementPage extends OperatorV2SimplePage {

  private static final String MD_VIRTUAL_REPEAT = "driverTypeProp in ctrl.tableData";
  private static final String CSV_FILENAME_PATTERN = "driver-types";
  private static final String PRIORITY_LEVEL = "Priority Level";
  private static final String DELIVERY_TYPE = "Delivery Type";
  private static final String RESERVATION_SIZE = "Reservation Size";
  private static final String PARCEL_SIZE = "Parcel Size";
  private static final String TIMESLOT = "Timeslot";

  public DriverTypesTable driverTypesTable;
  private AddDriverTypeDialog addDriverTypeDialog;
  public EditDriverTypeDialog editDriverTypeDialog;
  private FiltersForm filtersForm;

  @FindBy(name = "Create Driver Type")
  public NvIconTextButton createDriverType;

  @FindBy(css = "input[placeholder='Search Driver Types...']")
  public TextBox searchDriverType;

  @FindBy(css = "ng-pluralize")
  public PageElement rowsCount;

  @FindBy(css = "md-dialog")
  public ConfirmDeleteDialog confirmDeleteDialog;

  public DriverTypeManagementPage(WebDriver webDriver) {
    super(webDriver);
    driverTypesTable = new DriverTypesTable(webDriver);
    addDriverTypeDialog = new AddDriverTypeDialog(webDriver);
    editDriverTypeDialog = new EditDriverTypeDialog(webDriver);
    filtersForm = new FiltersForm(webDriver);
  }

  public FiltersForm filtersForm() {
    return filtersForm;
  }

  public void downloadFile() {
    clickNvApiTextButtonByName("Download CSV File");
  }

  public void verifyDownloadedFileContent(List<DriverTypeParams> expectedDriverTypeParams) {
    String fileName = CSV_FILENAME_PATTERN + ".csv";
    verifyFileDownloadedSuccessfully(fileName);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    NvLogger.info("FILE_NAME = " + fileName);
    List<DriverTypeParams> actualDriverTypeParams = DriverTypeParams.fromCsvFile(pathName, true);

    assertThat("Unexpected number of lines in CSV file", actualDriverTypeParams.size(),
        greaterThanOrEqualTo(expectedDriverTypeParams.size()));

    Map<Long, DriverTypeParams> actualMap = actualDriverTypeParams.stream()
        .collect(Collectors.toMap(
            DriverTypeParams::getDriverTypeId,
            params -> params
        ));

    for (DriverTypeParams expectedParams : expectedDriverTypeParams) {
      DriverTypeParams actualParams = actualMap.get(expectedParams.getDriverTypeId());

      assertThat("Driver Type with Id", actualParams, notNullValue());
      assertEquals("Driver Type Name", expectedParams.getDriverTypeName(),
          actualParams.getDriverTypeName());
      assertEquals(DELIVERY_TYPE, expectedParams.getDeliveryType(), actualParams.getDeliveryType());
      assertEquals(PRIORITY_LEVEL, expectedParams.getPriorityLevel(),
          actualParams.getPriorityLevel());
      assertEquals(RESERVATION_SIZE, expectedParams.getReservationSize(),
          actualParams.getReservationSize());
      assertEquals(PARCEL_SIZE, expectedParams.getParcelSize(), actualParams.getParcelSize());
    }
  }

  public void verifyFilterResults(DriverTypeParams filterParams) {
    List<DriverTypeParams> filterResults = driverTypesTable.readAllEntities();

    filterResults.forEach(driverTypeParams ->
    {
      if (StringUtils.isNotBlank(filterParams.getDeliveryType())) {
        assertThat(DELIVERY_TYPE,
            driverTypeParams.getDeliveryTypes(),
            anyOf(hasItemsIgnoreCase(filterParams.getDeliveryTypes()), hasItemIgnoreCase("All")));
      }
      if (StringUtils.isNotBlank(filterParams.getPriorityLevel())) {
        List<String> expectedItems = filterParams.getPriorityLevels().stream().map(item -> {
          if (!StringUtils.containsAny(item, "Only", "All", "Both")) {
            item += " Only";
          }
          return item;
        }).collect(Collectors.toList());
        assertThat(PRIORITY_LEVEL, driverTypeParams.getPriorityLevels(),
            anyOf(hasItemsIgnoreCase(expectedItems), hasItemIgnoreCase("All")));
      }
      if (StringUtils.isNotBlank(filterParams.getReservationSize())) {
        assertThat(RESERVATION_SIZE, driverTypeParams.getReservationSizes(),
            anyOf(hasItemsIgnoreCase(filterParams.getReservationSizes()),
                hasItemIgnoreCase("All")));
      }
      if (StringUtils.isNotBlank(filterParams.getParcelSize())) {
        assertThat(PARCEL_SIZE, driverTypeParams.getParcelSizes(),
            anyOf(hasItemsIgnoreCase(filterParams.getParcelSizes()), hasItemIgnoreCase("All")));
      }
      if (StringUtils.isNotBlank(filterParams.getTimeslot())) {
        assertThat(TIMESLOT, driverTypeParams.getTimeslots(),
            anyOf(hasItemsIgnoreCase(filterParams.getTimeslots()), hasItemIgnoreCase("All")));
      }
    });
  }

  public void createDriverType(DriverTypeParams driverTypeParams) {
    createDriverType.click();
    addDriverTypeDialog.fillForm(driverTypeParams);
    addDriverTypeDialog.submitForm();
  }

  public static class ConfirmDeleteDialog extends MdDialog {

    public ConfirmDeleteDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public ConfirmDeleteDialog(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }

    @FindBy(xpath = "//md-dialog//button[@aria-label='Delete']")
    public Button delete;
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
  }

  public static class DriverTypesTable extends MdVirtualRepeatTable<DriverTypeParams> {

    public static final String COLUMN_ID = "driverTypeId";
    public static final String COLUMN_NAME = "driverTypeName";
    private static final String COLUMN_DELIVERY_TYPE = "deliveryType";
    private static final String COLUMN_PRIORITY_LEVEL = "priorityLevel";
    private static final String COLUMN_RESERVATION_SIZE = "reservationSize";
    private static final String COLUMN_PARCEL_SIZE = "parcelSize";
    private static final String COLUMN_TIMESLOT = "timeslot";

    public static final String ACTION_EDIT = "Edit";
    public static final String ACTION_DELETE = "Delete";

    public DriverTypesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ID, "id")
          .put(COLUMN_NAME, "name")
          .put(COLUMN_DELIVERY_TYPE, "delivery-type")
          .put(COLUMN_PRIORITY_LEVEL, "priority-level")
          .put(COLUMN_RESERVATION_SIZE, "reservation-size")
          .put(COLUMN_PARCEL_SIZE, "parcel-size")
          .put(COLUMN_TIMESLOT, "timeslot")
          .build()
      );
      setActionButtonsLocators(ImmutableMap
          .of(ACTION_EDIT, "Edit", ACTION_DELETE, "Delete"));
      setEntityClass(DriverTypeParams.class);
      setMdVirtualRepeat("driverTypeProp in ctrl.tableData");
    }
  }

  /**
   * Accessor for Create Reservation dialog
   */
  public static class AddDriverTypeDialog extends FiltersForm {

    private static final String DIALOG_TITLE = "Add Driver Type";
    private static final String FIELD_NAME_LOCATOR = "Name";
    private static final String BUTTON_SUBMIT_LOCATOR = "Submit";
    private static final String LOCATOR_BUTTON_PRIORITY_LEVEL_BOTH = "Both";

    public AddDriverTypeDialog(WebDriver webDriver) {
      super(webDriver);
    }

    @SuppressWarnings("UnusedReturnValue")
    public AddDriverTypeDialog waitUntilVisible() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    public AddDriverTypeDialog setName(String name) {
      if (StringUtils.isNotBlank(name)) {
        sendKeysByAriaLabel(FIELD_NAME_LOCATOR, name);
      }
      return this;
    }

    public void submitForm() {
      clickNvButtonSaveByNameAndWaitUntilDone(BUTTON_SUBMIT_LOCATOR);
      waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
    }

    @Override
    public void selectDeliveryTypeNormal() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_NORMAL);
    }

    @Override
    public void selectDeliveryTypeC2C() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_C2C);
    }

    @Override
    public void selectDeliveryTypeReservationPickUp() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_RESERVATION_PICK_UP);
    }

    @Override
    public void clearDeliveryTypeSelection() {
      findElementsByXpathFast(
          "//nv-button-group[@label='" + DELIVERY_TYPE + "']//button[contains(@class, 'active')]")
          .forEach(WebElement::click);
    }

    @Override
    public void selectPriorityLevelPriority() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PRIORITY_LEVEL_PRIORITY + " Only");
    }

    @Override
    public void selectPriorityLevelNonPriority() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PRIORITY_LEVEL_NON_PRIOROTY + " Only");
    }

    @SuppressWarnings("unused")
    public void selectPriorityLevelBoth() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PRIORITY_LEVEL_BOTH);
    }

    @Override
    public void clearPriorityLevelSelection() {
      findElementsByXpathFast("//nv-button-group-radio[@label='" + PRIORITY_LEVEL
          + "']//button[contains(@class, 'active')]")
          .forEach(WebElement::click);
    }

    @Override
    public void selectReservationSizeLessThan3Parcels() {
      clickButtonOnMdDialogByAriaLabelIgnoreCase(
          LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_3_PARCELS);
    }

    @Override
    public void selectReservationSizeLessThan10Parcels() {
      clickButtonOnMdDialogByAriaLabelIgnoreCase(
          LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_10_PARCELS);
    }

    @Override
    public void selectReservationSizeTrolleyRequired() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_TROLLEY_REQUIRED);
    }

    @Override
    public void selectReservationSizeHalfVanLoad() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_HALF_VAN_LOAD);
    }

    @Override
    public void selectReservationSizeFullVanLoad() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_FULL_VAN_LOAD);
    }

    @Override
    public void selectReservationSizeLargerThanVanLoad() {
      clickButtonOnMdDialogByAriaLabelIgnoreCase(
          LOCATOR_BUTTON_RESERVATION_SIZE_LARGER_THAN_VAN_LOAD);
    }

    @Override
    public void clearReservationSizeSelection() {
      findElementsByXpathFast("//nv-button-group[@label='" + RESERVATION_SIZE
          + "']//button[contains(@class, 'active')]")
          .forEach(WebElement::click);
    }

    @Override
    public void selectParcelSizeSmall() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_SMALL);
    }

    @Override
    public void selectParcelSizeMedium() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_MEDIUM);
    }

    @Override
    public void selectParcelSizeLarge() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_LARGE);
    }

    @Override
    public void selectParcelSizeExtraLarge() {
      clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_EXTRA_LARGE);
    }

    @Override
    public void clearParcelSizeSelection() {
      findElementsByXpathFast(
          "//nv-button-group[@label='" + PARCEL_SIZE + "']//button[contains(@class, 'active')]")
          .forEach(WebElement::click);
    }

    @Override
    public void selectTimeslot9amTo6pm() {
      clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_9AM_TO_6PM);
    }

    @Override
    public void selectTimeslot9amTo10pm() {
      clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_9AM_TO_10PM);
    }

    @Override
    public void selectTimeslot9amTo12pm() {
      clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_9AM_TO_12PM);
    }

    @Override
    public void selectTimeslot12pmTo3pm() {
      clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_12PM_TO_3PM);
    }

    @Override
    public void selectTimeslot3pmTo6pm() {
      clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_3PM_TO_6PM);
    }

    @Override
    public void selectTimeslot6pmTo10pm() {
      clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_6PM_TO_10PM);
    }

    @Override
    public void clearTimeslotSelection() {
      findElementsByXpathFast(
          "//nv-button-group[@label='" + TIMESLOT + "']//button[contains(@class, 'active')]")
          .forEach(WebElement::click);
    }

    @Override
    public void fillForm(DriverTypeParams driverTypeParams) {
      waitUntilVisible();
      setName(driverTypeParams.getDriverTypeName());
      if (StringUtils.isNotBlank(driverTypeParams.getDeliveryType())) {
        selectDeliveryType(driverTypeParams.getDeliveryTypes());
      }
      if (StringUtils.isNotBlank(driverTypeParams.getPriorityLevel())) {
        selectPriorityLevel(driverTypeParams.getPriorityLevels());
      }
      if (StringUtils.isNotBlank(driverTypeParams.getReservationSize())) {
        selectReservationSize(driverTypeParams.getReservationSizes());
      }
      if (StringUtils.isNotBlank(driverTypeParams.getParcelSize())) {
        selectParcelSize(driverTypeParams.getParcelSizes());
      }
      if (StringUtils.isNotBlank(driverTypeParams.getTimeslot())) {
        selectTimeslot(driverTypeParams.getTimeslots());
      }
    }
  }

  /**
   * Accessor for Create Reservation dialog
   */
  public static class EditDriverTypeDialog extends AddDriverTypeDialog {

    private static final String DIALOG_TITLE = "Edit Driver Type";
    private static final String BUTTON_SUBMIT_LOCATOR = "Submit Changes";

    public EditDriverTypeDialog(WebDriver webDriver) {
      super(webDriver);
    }

    @Override
    public EditDriverTypeDialog waitUntilVisible() {
      waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
      return this;
    }

    public void submitForm() {
      clickNvButtonSaveByNameAndWaitUntilDone(BUTTON_SUBMIT_LOCATOR);
      waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
    }
  }

  /**
   * Accessor for Create Reservation dialog
   */
  public static class FiltersForm extends OperatorV2SimplePage {

    static final String LOCATOR_BUTTON_DELIVERY_TYPE_NORMAL = "Normal Delivery";
    static final String LOCATOR_BUTTON_DELIVERY_TYPE_C2C = "C2C + Return Pick Up";
    static final String LOCATOR_BUTTON_DELIVERY_TYPE_RESERVATION_PICK_UP = "Reservation Pick Up";
    static final String LOCATOR_BUTTON_DELIVERY_TYPE_CLEAR_ALL = "//div[contains(@class,'delivery-type')]//button[@aria-label='Clear All']";

    static final String LOCATOR_BUTTON_PRIORITY_LEVEL_PRIORITY = "Priority";
    static final String LOCATOR_BUTTON_PRIORITY_LEVEL_NON_PRIOROTY = "Non-Priority";
    static final String LOCATOR_BUTTON_PRIORITY_LEVEL_CLEAR_ALL = "//div[contains(@class,'priority-level')]//button[@aria-label='Clear All']";

    static final String LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_3_PARCELS = "Less Than 3 Parcels";
    static final String LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_10_PARCELS = "Less Than 10 Parcels";
    static final String LOCATOR_BUTTON_RESERVATION_SIZE_TROLLEY_REQUIRED = "Trolley Required";
    static final String LOCATOR_BUTTON_RESERVATION_SIZE_HALF_VAN_LOAD = "Half Van Load";
    static final String LOCATOR_BUTTON_RESERVATION_SIZE_FULL_VAN_LOAD = "Full Van Load";
    static final String LOCATOR_BUTTON_RESERVATION_SIZE_LARGER_THAN_VAN_LOAD = "Larger Than Van Load";
    static final String LOCATOR_BUTTON_RESERVATION_SIZE_CLEAR_ALL = "//div[contains(@class,'reservation-size')]//button[@aria-label='Clear All']";

    static final String LOCATOR_BUTTON_PARCEL_SIZE_SMALL = "Small";
    static final String LOCATOR_BUTTON_PARCEL_SIZE_MEDIUM = "Medium";
    static final String LOCATOR_BUTTON_PARCEL_SIZE_LARGE = "Large";
    static final String LOCATOR_BUTTON_PARCEL_SIZE_EXTRA_LARGE = "Extra Large";
    static final String LOCATOR_BUTTON_PARCEL_SIZE_CLEAR_ALL = "//div[contains(@class,'parcel-size')]//button[@aria-label='Clear All']";

    static final String LOCATOR_BUTTON_TIMESLOT_9AM_TO_6PM = "9AM To 6PM";
    static final String LOCATOR_BUTTON_TIMESLOT_9AM_TO_10PM = "9AM TO 10PM";
    static final String LOCATOR_BUTTON_TIMESLOT_9AM_TO_12PM = "9AM TO 12PM";
    static final String LOCATOR_BUTTON_TIMESLOT_12PM_TO_3PM = "12PM TO 3PM";
    static final String LOCATOR_BUTTON_TIMESLOT_3PM_TO_6PM = "3PM TO 6PM";
    static final String LOCATOR_BUTTON_TIMESLOT_6PM_TO_10PM = "6PM TO 10PM";
    static final String LOCATOR_BUTTON_TIMESLOT_CLEAR_ALL = "//div[contains(@class,'timeslot')]//button[@aria-label='Clear All']";

    public FiltersForm(WebDriver webDriver) {
      super(webDriver);
    }

    public void selectDeliveryTypeNormal() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_NORMAL);
    }

    public void selectDeliveryTypeC2C() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_C2C);
    }

    public void selectDeliveryTypeReservationPickUp() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_RESERVATION_PICK_UP);
    }

    public void clearDeliveryTypeSelection() {
      click(LOCATOR_BUTTON_DELIVERY_TYPE_CLEAR_ALL);
    }

    public void selectDeliveryType(String deliveryType) {
      switch (deliveryType.trim().toLowerCase()) {
        case "normal delivery":
          selectDeliveryTypeNormal();
          break;
        case "c2c + return pick up":
          selectDeliveryTypeC2C();
          break;
        case "reservation pick up":
          selectDeliveryTypeReservationPickUp();
          break;
        case "all":
          clearDeliveryTypeSelection();
          selectDeliveryTypeNormal();
          selectDeliveryTypeC2C();
          selectDeliveryTypeReservationPickUp();
          break;
      }
    }

    public void selectDeliveryType(Set<String> deliveryTypes) {
      clearDeliveryTypeSelection();
      deliveryTypes.forEach(this::selectDeliveryType);
    }

    public void selectPriorityLevelPriority() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_PRIORITY_LEVEL_PRIORITY);
    }

    public void selectPriorityLevelNonPriority() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_PRIORITY_LEVEL_NON_PRIOROTY);
    }

    public void clearPriorityLevelSelection() {
      click(LOCATOR_BUTTON_PRIORITY_LEVEL_CLEAR_ALL);
    }

    public void selectPriorityLevel(String priorityLevel) {
      switch (priorityLevel.trim().toLowerCase()) {
        case "priority":
        case "priority only":
          selectPriorityLevelPriority();
          break;
        case "non-priority":
        case "non-priority only":
          selectPriorityLevelNonPriority();
          break;
        case "both":
        case "all":
          clearPriorityLevelSelection();
          selectPriorityLevelPriority();
          selectPriorityLevelNonPriority();
          break;
      }
    }

    public void selectPriorityLevel(Set<String> priorityLevels) {
      clearPriorityLevelSelection();
      priorityLevels.forEach(this::selectPriorityLevel);
    }

    public void selectReservationSizeLessThan3Parcels() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_3_PARCELS);
    }

    public void selectReservationSizeLessThan10Parcels() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_10_PARCELS);
    }

    public void selectReservationSizeTrolleyRequired() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_TROLLEY_REQUIRED);
    }

    public void selectReservationSizeHalfVanLoad() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_HALF_VAN_LOAD);
    }

    public void selectReservationSizeFullVanLoad() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_FULL_VAN_LOAD);
    }

    public void selectReservationSizeLargerThanVanLoad() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_LARGER_THAN_VAN_LOAD);
    }

    public void clearReservationSizeSelection() {
      click(LOCATOR_BUTTON_RESERVATION_SIZE_CLEAR_ALL);
    }

    public void selectReservationSize(String reservationSize) {
      switch (reservationSize.trim().toLowerCase()) {
        case "less than 3 parcels":
          selectReservationSizeLessThan3Parcels();
          break;
        case "less than 10 parcels":
          selectReservationSizeLessThan10Parcels();
          break;
        case "trolley required":
          selectReservationSizeTrolleyRequired();
          break;
        case "half van load":
          selectReservationSizeHalfVanLoad();
          break;
        case "full van load":
          selectReservationSizeFullVanLoad();
          break;
        case "larger than van load":
          selectReservationSizeLargerThanVanLoad();
          break;
        case "all":
          clearReservationSizeSelection();
          selectReservationSizeLessThan3Parcels();
          selectReservationSizeLessThan10Parcels();
          selectReservationSizeTrolleyRequired();
          selectReservationSizeHalfVanLoad();
          selectReservationSizeFullVanLoad();
          selectReservationSizeLargerThanVanLoad();
          break;
      }
    }

    public void selectReservationSize(Set<String> reservationSizes) {
      clearReservationSizeSelection();
      reservationSizes.forEach(this::selectReservationSize);
    }

    public void selectParcelSizeSmall() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_SMALL);
    }

    public void selectParcelSizeMedium() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_MEDIUM);
    }

    public void selectParcelSizeLarge() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_LARGE);
    }

    public void selectParcelSizeExtraLarge() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_EXTRA_LARGE);
    }

    public void clearParcelSizeSelection() {
      click(LOCATOR_BUTTON_PARCEL_SIZE_CLEAR_ALL);
    }

    public void selectParcelSize(String parcelSize) {
      switch (parcelSize.trim().toLowerCase()) {
        case "small":
          selectParcelSizeSmall();
          break;
        case "medium":
          selectParcelSizeMedium();
          break;
        case "large":
          selectParcelSizeLarge();
          break;
        case "extra large":
          selectParcelSizeExtraLarge();
          break;
        case "all":
          clearParcelSizeSelection();
          selectParcelSizeSmall();
          selectParcelSizeMedium();
          selectParcelSizeLarge();
          selectParcelSizeExtraLarge();
          break;
      }
    }

    public void selectParcelSize(Set<String> parcelSizes) {
      clearParcelSizeSelection();
      parcelSizes.forEach(this::selectParcelSize);
    }

    public void selectTimeslot9amTo6pm() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_9AM_TO_6PM);
    }

    public void selectTimeslot9amTo10pm() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_9AM_TO_10PM);
    }

    public void selectTimeslot9amTo12pm() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_9AM_TO_12PM);
    }

    public void selectTimeslot12pmTo3pm() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_12PM_TO_3PM);
    }

    public void selectTimeslot3pmTo6pm() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_3PM_TO_6PM);
    }

    public void selectTimeslot6pmTo10pm() {
      clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_6PM_TO_10PM);
    }

    public void clearTimeslotSelection() {
      click(LOCATOR_BUTTON_TIMESLOT_CLEAR_ALL);
    }

    public void selectTimeslot(String timeslot) {
      switch (timeslot.trim().toLowerCase()) {
        case "9am to 6pm":
          selectTimeslot9amTo6pm();
          break;
        case "9am to 10pm":
          selectTimeslot9amTo10pm();
          break;
        case "9am to 12pm":
          selectTimeslot9amTo12pm();
          break;
        case "12pm to 3pm":
          selectTimeslot12pmTo3pm();
          break;
        case "3pm to 6pm":
          selectTimeslot3pmTo6pm();
          break;
        case "6pm to 10pm":
          selectTimeslot6pmTo10pm();
          break;
        case "all":
          clearTimeslotSelection();
          selectTimeslot9amTo6pm();
          selectTimeslot9amTo10pm();
          selectTimeslot9amTo10pm();
          selectTimeslot9amTo12pm();
          selectTimeslot12pmTo3pm();
          selectTimeslot3pmTo6pm();
          selectTimeslot6pmTo10pm();
          break;
      }
    }

    public void selectTimeslot(Set<String> timeslots) {
      clearTimeslotSelection();
      timeslots.forEach(this::selectTimeslot);
    }

    public void fillForm(DriverTypeParams driverTypeParams) {
      selectDeliveryType(driverTypeParams.getDeliveryTypes());
      selectPriorityLevel(driverTypeParams.getPriorityLevels());
      selectReservationSize(driverTypeParams.getReservationSizes());
      selectParcelSize(driverTypeParams.getParcelSizes());
      selectTimeslot(driverTypeParams.getTimeslots());
    }
  }
}