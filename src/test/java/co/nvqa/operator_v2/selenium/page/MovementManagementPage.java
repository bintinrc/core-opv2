package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.sort.hub.movement_trips.HubRelationSchedule;
import co.nvqa.operator_v2.model.MovementSchedule;
import co.nvqa.operator_v2.model.StationMovementSchedule;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextWithLabel;
import co.nvqa.operator_v2.selenium.elements.ant.AntTimePicker;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Sergey Mishanin
 */
public class MovementManagementPage extends SimpleReactPage<MovementManagementPage> {

  private static final Logger LOGGER = LoggerFactory.getLogger(MovementManagementPage.class);
  /*
   MS: Movement Schedules
   */
  private static final String MS_PAGE_DEPARTURE_TIME_LIST_XPATH = "//tbody[@class='ant-table-tbody']/tr//td[contains(@class,'start-time')]//input";
  private static final String MS_PAGE_DURATION_TIME_LIST_XPATH = "//tbody[@class='ant-table-tbody']/tr//td[contains(@class,'duration')]//input[@placeholder='Select time']";
  private static final String MS_PAGE_DURATION_DATE_LIST_XPATH = "//tbody[@class='ant-table-tbody']/tr//td[contains(@class,'duration')]//input[@type='search']";
  private static final String MS_PAGE_ERROR_NOTIFICATION_XPATH = "//div[contains(@class,'ant-notification-notice-error')]//div[@class='ant-notification-notice-message']";
  private static final String MS_PAGE_PICKER_HOUR_DROPDOWN_XPATH = "//div[contains(@class,'ant-picker-dropdown') and not(contains(@class,'ant-picker-dropdown-hidden'))]//ul[1]//div[text()='%s']";
  private static final String MS_PAGE_PICKER_MIN_DROPDOWN_XPATH = "//div[contains(@class,'ant-picker-dropdown') and not(contains(@class,'ant-picker-dropdown-hidden'))]//ul[2]//div[text()='%s']";
  private static final String MS_PAGE_NOTIFICATION_XPATH = "//div[@class='ant-notification-notice-message']";
  private static final String MS_PAGE_NOTIFICATION_CLOSE_ICON_XPATH = "//div[contains(@class,'ant-notification')]//span[@class='ant-notification-notice-close-x']";
  private static final String MS_PAGE_LOADING_ICON_XPATH = "//span[@class='ant-spin-dot ant-spin-dot-spin']";
  private static final String MS_PAGE_ITEM_CHECKBOX_XPATH = "//td//label[@class='ant-checkbox-wrapper']//input[@class='ant-checkbox-input'][%d]";

  private static final String MS_PAGE_ASSIGN_DRIVER_XPATH = "//input[@id ='schedules_%d_drivers']";
  private static final String MS_PAGE_ORIGIN_HUB_XPATH = "//input[@id='schedules_0_originHub']";
  private static final String MS_PAGE_DESTINATION_HUB_XPATH = "//input[@id='schedules_0_destinationHub']";
  private static final String MS_PAGE_DROPDOWN_LIST_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class, 'ant-select-dropdown-hidden'))]//div[contains(text(),'%s')]";

  private static final String MS_PAGE_DRIVERS_COLUMN_XPATH = "//td[contains(@class,'ant-table-cell drivers')]";
  private static final String MS_PAGE_CONFIRM_DIALOG_XPATH = "//div[@class='ant-modal-confirm-content']";
  private static final String MS_PAGE_DAY_OF_WEEK_XPATH = "//td[contains(@class,'ant-table-cell day')]//input[@value='%d']";

  public static List<Driver> middleMileDrivers;

  @FindBy(xpath = "//button[.='Close']")
  public Button closeButton;
  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(className = "ant-modal-wrap")
  public AddMovementScheduleModal addMovementScheduleModal;

  @FindBy(className = "ant-modal-wrap")
  public MovementScheduleModal movementScheduleModal;

  @FindBy(className = "ant-modal")
  public UpdateSchedulesConfirmationModal updateSchedulesConfirmationModal;

  @FindBy(css = "div.ant-modal")
  public EditStationRelationsModal editStationRelationsModal;

  @FindBy(id = "originHub")
  public AntSelect originCrossdockHub;

  @FindBy(id = "originHub")
  public AntSelect originStationHub;

  @FindBy(id = "crossdockHub")
  public AntSelect crossdockHub;

  @FindBy(id = "destinationHub")
  public AntSelect destinationCrossdockHub;

  @FindBy(id = "destinationHub")
  public AntSelect destinationStationHub;

  @FindBy(xpath = "//button[.='Load Schedules']")
  public Button loadSchedules;

  @FindBy(xpath = "//button[.='Edit Filters']")
  public Button editFilters;

  @FindBy(xpath = "//div[contains(@class,'ant-table-body')]//table")
  public NvTable<RelationRow> relationsTable;

  @FindBy(xpath = "(//th//input)[1]")
  public TextBox originCrossdockHubFilter;

  @FindBy(xpath = "(//th//input)[2]")
  public TextBox destinationCrossdockHubFilter;

  @FindBy(xpath = "//div[@class='ant-popover-buttons']//button[.='Delete']")
  public Button popoverDeleteButton;

  @FindBy(xpath = "//label[.='Crossdock']")
  public PageElement crossdockHubsTab;

  @FindBy(xpath = "//label[.='Relations']")
  public PageElement relationsTab;

  @FindBy(xpath = "//label[starts-with(.,'All')]")
  public PageElement allTab;

  @FindBy(xpath = "//label[starts-with(.,'Complete')]")
  public PageElement completedTab;

  @FindBy(xpath = "//label[starts-with(.,'Pending')]")
  public PageElement pendingTab;

  @FindBy(xpath = "//label[starts-with(.,'Pending')]")
  public PageElement inputOfPendingTab;

  @FindBy(xpath = "//input[@aria-label='input-hub_name']")
  public ForceClearTextBox stationFilter;

  @FindBy(css = "input[data-testid='column-search-field-crossdock-hub-name']")
  public ForceClearTextBox hubFilter;

  @FindBy(xpath = "//div[.='Crossdock Hub']//span[contains(@class,'ant-table-column-sorter-up')]")
  public PageElement hubFilterSortUp;

  @FindBy(xpath = "//div[.='Crossdock Hub']//span[contains(@class,'ant-table-column-sorter-down')]")
  public PageElement hubFilterSortDown;

  @FindBy(xpath = "//div[.='Station']//span[contains(@class,'ant-table-column-sorter-up')]")
  public PageElement stationFilterSortUp;

  @FindBy(xpath = "//div[.='Station']//span[contains(@class,'ant-table-column-sorter-down')]")
  public PageElement stationFilterSortDown;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement toastOnMovementSchedule;


  //region Stations tab
  @FindBy(xpath = "//input[@data-testid='station-tab']/parent::span")
  public PageElement stationsTab;

  @FindBy(xpath = "//button/span[contains(text(),'Add Schedule')]/parent::button")
  public Button addSchedule;

  @FindBy(xpath = "//button[.='Delete']")
  public Button delete;

  @FindBy(xpath = "//button[.='Modify']")
  public Button modify;

  @FindBy(xpath = "//button[.='Delete']")
  public List<Button> deleteSchedule;

  @FindBy(xpath = "//button[.='Save']")
  public Button save;

  @FindBy(xpath = "//button[.='Close']")
  public Button close;

  @FindBy(css = "div.ant-modal")
  public AddStationMovementScheduleModal addStationMovementScheduleModal;

  @FindBy(xpath = "//tr[2]//td[last()]//button")
  public PageElement assignDriverButton;

  @FindBy(className = "ant-modal-wrap")
  public TripManagementPage.AssignTripModal assignDriverModal;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message' and .='Relation created']")
  public PageElement successCreateRelation;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message' and .='Relation updated']")
  public PageElement successUpdateRelation;

  @FindBy(xpath = "//tr[2]//td[1]//input")
  public CheckBox rowCheckBox;

  @FindBy(xpath = "//tr[3]//td[1]//input")
  public CheckBox rowCheckBoxSecond;

  @FindBy(xpath = "//div[contains(@class,'ant-modal-confirm')]//button[contains(@class,'ant-btn-primary')]")
  public Button modalDeleteButton;

  @FindBy(xpath = "//div[@class='ant-modal-confirm-btns']//button[contains(@class, 'ant-btn-primary')]")
  public Button modalUpdateButton;

  @FindBy(xpath = "//div[@class='ant-modal-confirm-btns']//button[contains(@class, 'ant-btn-primary')]")
  public Button modalOkButton;

  @FindBy(xpath = "//div[@class='ant-modal-body']//div//span")
  public TextBox effectingPathText;

  @FindBy(xpath = "(//div[@class='ant-modal-content']//button[@aria-label='Close'])[2]")
  public Button effectingPathClose;

  @FindBy(xpath = "//span[.='No Results Found']")
  public TextBox noResultsFoundText;

  @FindBy(xpath = "//td[contains(@class,'start-time')]//div[@class='ant-picker-input']//input")
  public List<WebElement> departureTimeInputs;

  @FindBy(xpath = "//td[contains(@class,'duration')]//div[@class='ant-picker-input']//input")
  public List<WebElement> durationInputs;

  @FindBy(xpath = "//td[contains(@class,'comments')]//textarea")
  public List<TextBox> commentInputs;

  @FindBy(xpath = "//td[@class='startTime']")
  public List<TextBox> departureTimes;

  @FindBy(xpath = "//td[@class='duration']")
  public List<TextBox> durations;

  @FindBy(xpath = "//td[@class='comment']")
  public List<TextBox> comments;

  @FindBy(xpath = "(//span[text()='OK'])[last()]")
  public Button OK;

  //endregion
  public String stationsCrossdockHub = "crossdockHub";
  public SchedulesTable schedulesTable;
  public HubRelationSchedulesTable hubRelationScheduleTable;
  public StationMovementSchedulesTable stationMovementSchedulesTable;
  public String StartTime = "";

  public MovementManagementPage(WebDriver webDriver) {
    super(webDriver);
    schedulesTable = new SchedulesTable(webDriver);
    hubRelationScheduleTable = new HubRelationSchedulesTable(webDriver);
    stationMovementSchedulesTable = new StationMovementSchedulesTable(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().defaultContent();
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void loadSchedules(String crossdockHubValue, String originHub, String destinationHub) {
    if (editFilters.isDisplayedFast()) {
      editFilters.click();
    }

    if (StringUtils.isNotBlank(crossdockHubValue)) {
      this.crossdockHub.selectValue(crossdockHubValue, crossdockHub.getWebElement());
      pause1s();

      if (StringUtils.isNotBlank(originHub)) {
        originStationHub.selectValue(originHub, originStationHub.getWebElement());
      }

      if (StringUtils.isNotBlank(destinationHub)) {
        destinationStationHub.selectValue(destinationHub, destinationStationHub.getWebElement());
      }
    } else {
      if (StringUtils.isNotBlank(originHub)) {
        originCrossdockHub.selectValue(originHub, originCrossdockHub.getWebElement());
      }

      if (StringUtils.isNotBlank(destinationHub)) {
        destinationCrossdockHub.selectValue(destinationHub,
            destinationCrossdockHub.getWebElement());
      }
    }
    Assertions.assertThat(loadSchedules.isEnabled())
        .as("Load Schedules button is enable and clickable").isTrue();
    loadSchedules.click();
    originCrossdockHubFilter.waitUntilClickable();
  }

  public void EditFilter(String crossdockHubValue, String originHub, String destinationHub) {
    pause1s();
    if (StringUtils.isNotBlank(crossdockHubValue)) {
      this.crossdockHub.selectValue(crossdockHubValue, crossdockHub.getWebElement());
      pause1s();

      if (StringUtils.isNotBlank(originHub)) {
        originStationHub.selectValue(originHub, originStationHub.getWebElement());
      }

      if (StringUtils.isNotBlank(destinationHub)) {
        destinationStationHub.selectValue(destinationHub, destinationStationHub.getWebElement());
      }
    } else {
      if (StringUtils.isNotBlank(originHub)) {
        originCrossdockHub.selectValue(originHub, originCrossdockHub.getWebElement());
      }

      if (StringUtils.isNotBlank(destinationHub)) {
        destinationCrossdockHub.selectValue(destinationHub,
            destinationCrossdockHub.getWebElement());
      }
    }
    OK.click();
  }

  public void clickAssignDriverIcon() {
    assignDriverButton.waitUntilClickable();
    assignDriverButton.click();
  }

  public void assignDriver(String username) {
    waitUntilVisibilityOfElementLocated("//div[.='Assign Driver']");
    assignDriverModal.addDriver.click();
    assignDriverModal.assignDriver(username);
    assignDriverModal.saveButton.click();
    assignDriverModal.waitUntilInvisible();
  }

  public void assignDriverWithAdditional(String primaryDriver, String additionalDriver) {
    assignDriverModal.waitUntilVisible();
    assignDriverModal.assignDriverWithAdditional(primaryDriver, additionalDriver);
    assignDriverModal.saveDriver.click();
    assignDriverModal.waitUntilInvisible();
  }

  public void verifyNotificationWithMessage(String containsMessage) {
    waitUntilVisibilityOfElementLocated(MS_PAGE_NOTIFICATION_XPATH);
    WebElement notificationElement = findElementByXpath(MS_PAGE_NOTIFICATION_XPATH);
    Assertions.assertThat(notificationElement.getText()).as("Toast message is the same")
        .isEqualTo(containsMessage);
    waitUntilInvisibilityOfElementLocated(MS_PAGE_NOTIFICATION_XPATH);
  }

  public void verifyDeleteScheduleMessage(String containsMessage) {
    toastOnMovementSchedule.waitUntilVisible();
    Assertions.assertThat(toastOnMovementSchedule.getText()).as("Toast message is the same")
        .isEqualTo(containsMessage);
    toastOnMovementSchedule.waitUntilInvisible();
  }

  public void verifyNotificationWithMessage(List<String> containsMessages) {
    waitUntilVisibilityOfElementLocated(MS_PAGE_NOTIFICATION_XPATH);
    List<WebElement> notificationElements = findElementsByXpath(MS_PAGE_NOTIFICATION_XPATH);
    List<String> errorList = new ArrayList<String>();
    notificationElements.forEach((element) -> errorList.add(element.getText()));
    errorList.sort(Comparator.naturalOrder());
    containsMessages.sort(Comparator.naturalOrder());
    for (int i = 0; i < errorList.size(); i++) {
      Assertions.assertThat(errorList.get(i).equalsIgnoreCase(containsMessages.get(i)))
          .as("Toast message is the same: \n" + errorList.get(i)).isTrue();
    }

  }

  public void closeNotificationMessage() {
    List<WebElement> notificationElements = findElementsByXpath(
        MS_PAGE_NOTIFICATION_CLOSE_ICON_XPATH);
    notificationElements.forEach((element) -> {
      element.click();
      pause1s();
    });
  }

  public void verifyMovementSchedulesPageIsLoaded() {
    switchTo();
    addSchedule.waitUntilVisible(10);
    addSchedule.waitUntilClickable(60);
    stationsTab.waitUntilVisible(10);
  }

  public void fillInMovementScheduleForm(Map<String, String> finalData, int i) {
    if (i <= 0) {
      stationsTab.click();
      addSchedule.click();
      addStationMovementScheduleModal.waitUntilVisible();
    } else {
      addStationMovementScheduleModal.addAnotherSchedule.click();
    }
    addStationMovementScheduleModal.fill(finalData, String.valueOf(i));
  }

  public static class EditStationRelationsModal extends AntModal {

    public EditStationRelationsModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void fill(String value) {
      crossdockHub.selectValue(value);
    }

    @FindBy(css = ".ant-select")
    public AntSelect3 crossdockHub;

    @FindBy(css = ".ant-form-item-explain-error")
    public PageElement error;

    @FindBy(xpath = "//button[.='Save']")
    public Button save;

    @FindBy(xpath = "//button[.='Cancel']")
    public Button cancel;
  }

  public static class AddMovementScheduleModal extends AntModal {

    public AddMovementScheduleModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//button[.='Add another schedule']")
    public Button addAnotherSchedule;

    @FindBy(xpath = "//button[.='OK']")
    public Button create;

    @FindBy(xpath = "//div[contains(@class,'ant-form-item-explain-error')]")
    public PageElement errorMessage;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    @Deprecated
    public void fill(MovementSchedule schedule) {
      for (int i = 1; i <= schedule.getSchedules().size(); i++) {
        ScheduleForm scheduleForm = getScheduleForm(i);
        scheduleForm.fill(schedule.getSchedules().get(i - 1), i - 1);
        if (i < schedule.getSchedules().size()) {
          addAnotherSchedule.click();
        }
      }
    }

    public void fill(Map<String, String> schedule) {
      int idx = Integer.parseInt(schedule.get("index"));
      if (idx > 1) addAnotherSchedule.click();
      ScheduleForm scheduleForm = getScheduleForm(idx);
      scheduleForm.fill(schedule, idx - 1);
    }

    public ScheduleForm getScheduleForm(int index) {
      WebElement webElement = findElementByXpath(
          f("//div[contains(@class,'schedule-form')][%d]", index));
      return new ScheduleForm(getWebDriver(), getWebElement(), webElement);
    }

    public static class ScheduleForm extends PageElement {

      public ScheduleForm(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      }

      @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='schedules_0_originHub']]")
      public AntSelect originHub;

      @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='schedules_0_destinationHub']]")
      public AntSelect destinationHub;

      @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='schedules_0_movementType']]")
      public AntSelect movementType;

      @FindBy(xpath = "(./following-sibling::div//span[@class='ant-time-picker'])[1]")
      public AntTimePicker departureTime;

      @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='schedules_0_durationDay']]")
      public AntSelect durationDays;

      @FindBy(xpath = "(./following-sibling::div//span[@class='ant-time-picker'])[2]")
      public AntTimePicker durationTime;

      @FindBy(xpath = "//div//input[@type='checkbox'][@value='1']")
      public CheckBox monday;

      @FindBy(xpath = "//div//input[@type='checkbox'][@value='2']")
      public CheckBox tuesday;

      @FindBy(xpath = "//div//input[@type='checkbox'][@value='3']")
      public CheckBox wednesday;

      @FindBy(xpath = "//div//input[@type='checkbox'][@value='4']")
      public CheckBox thursday;

      @FindBy(xpath = "//div//input[@type='checkbox'][@value='5']")
      public CheckBox friday;

      @FindBy(xpath = "//div//input[@type='checkbox'][@value='6']")
      public CheckBox saturday;

      @FindBy(xpath = "//div//input[@type='checkbox'][@value='7']")
      public CheckBox sunday;

      @FindBy(xpath = "./following-sibling::div//*[contains(@id,'schedules_0_comment')]")
      public TextBox comment;

      public String scheduleOriginHubId = "schedules_%s_originHub";
      public String scheduleDestinationHubId = "schedules_%s_destinationHub";
      public String scheduleMovementTypeId = "schedules_%s_movementType";
      public String scheduleStartTimeId = "schedules_%s_startTime";
      public String scheduleDepartureTimeXpath = "//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//div[@class='ant-picker-content']//ul[%s]//div[text()= '%s']";
      public String scheduleDurationDayId = "schedules_%s_durationDay";
      public String scheduleDurationTimeId = "schedules_%s_durationTime";
      public String scheduleDurationTimeXpath = "//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//ul[%s]//div[text()= '%s']";
      public String scheduleDaysId = "schedules_%s_days";
      public String scheduleDriversId = "schedules_%s_drivers";
      public String scheduleCommentId = "schedules_%s_comment";
      public String antpickerdropdownhidden = "//div[contains(@class,'ant-picker-dropdown') and not(contains(@class,'ant-picker-dropdown-hidden'))]";
      public String daysOfWeekXpath = "//div[@id='schedules_%s_days']//input[@type='checkbox'][@value='%s']";
      public String hubValueXpath = "//span[contains(@class,'ant-select-selection-item') and contains(@title,'%s')]";

      public void callJavaScriptExecutor(String argument, WebElement element) {
        JavascriptExecutor jse = ((JavascriptExecutor) getWebDriver());
        jse.executeScript(argument, element);
      }

      @Deprecated
      public void fill(MovementSchedule.Schedule schedule, int scheduleNo) {
        scrollIntoView(findElement(By.id(f(scheduleCommentId, scheduleNo))));
        if (StringUtils.isNotBlank(schedule.getOriginHub())) {
          sendKeysAndEnterById(f(scheduleOriginHubId, scheduleNo), schedule.getOriginHub());
        }
        if (StringUtils.isNotBlank(schedule.getDestinationHub())) {
          sendKeysAndEnterById(f(scheduleDestinationHubId, scheduleNo),
              schedule.getDestinationHub());
        }
        if (StringUtils.isNotBlank(schedule.getMovementType())) {
          sendKeysAndEnterById(f(scheduleMovementTypeId, scheduleNo), schedule.getMovementType());
        }
        if (StringUtils.isNotBlank(schedule.getDepartureTime())) {
          String[] hourtime = schedule.getDepartureTime().split(":");
          TestUtils.findElementAndClick(f(scheduleStartTimeId, scheduleNo), "id", getWebDriver());
          pause1s();
          String hour = f(scheduleDepartureTimeXpath, 1, hourtime[0]);
          String time = f(scheduleDepartureTimeXpath, 2, hourtime[1]);
          moveToElementWithXpath(
              antpickerdropdownhidden + "//div[@class='ant-picker-content']//ul[1]");
          TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
          moveToElementWithXpath(
              antpickerdropdownhidden + "//div[@class='ant-picker-content']//ul[2]");
          TestUtils.findElementAndClick(time, "xpath", getWebDriver());
          TestUtils.findElementAndClick(antpickerdropdownhidden + "//li[@class='ant-picker-ok']",
              "xpath", getWebDriver());
        }
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
        {
          setDurationDays(schedule, scheduleNo);
        }, 3);
        if (StringUtils.isNotBlank(schedule.getDurationTime())) {
          String[] hourtime = schedule.getDurationTime().split(":");
          TestUtils.findElementAndClick(f(scheduleDurationTimeId, scheduleNo), "id",
              getWebDriver());
          String hour = f(scheduleDurationTimeXpath, 1, hourtime[0]);
          String time = f(scheduleDurationTimeXpath, 2, hourtime[1]);
          moveToElementWithXpath(hour);
          TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
          moveToElementWithXpath(time);
          TestUtils.findElementAndClick(time, "xpath", getWebDriver());
          TestUtils.findElementAndClick(
              antpickerdropdownhidden + "//span[text()='Ok']",
              "xpath", getWebDriver());
        }
        if (CollectionUtils.isNotEmpty(schedule.getDaysOfWeek())) {
          setDaysOfWeek(schedule.getDaysOfWeek(), scheduleNo);
        }
        if (StringUtils.isNotBlank(schedule.getComment())) {
          WebElement element = getWebDriver().findElement(By.id(f(scheduleCommentId, scheduleNo)));
          element.sendKeys(schedule.getComment());
        }
        if (schedule.getNumberOfDrivers() != null && schedule.getNumberOfDrivers() > 0) {
          MovementManagementPage movementPage = new MovementManagementPage(getWebDriver());
          movementPage.assignDrivers(middleMileDrivers.size(), middleMileDrivers, scheduleNo);
        }
      }

      public void fill(Map<String, String> schedule, int scheduleNo) {
        scrollIntoView(findElement(By.id(f(scheduleCommentId, scheduleNo))));

        doWithRetry(() -> {
          if (StringUtils.isNotBlank(schedule.get("originHub"))) {
            sendKeysAndEnterById(f(scheduleOriginHubId, scheduleNo), schedule.get("originHub"));
          }
          waitUntilVisibilityOfElementLocated(f(hubValueXpath, schedule.get("originHub")), 1);
        }, "Selecting origin hub...", 1000, 5);

        doWithRetry(() -> {
          if (StringUtils.isNotBlank(schedule.get("destinationHub"))) {
            sendKeysAndEnterById(f(scheduleDestinationHubId, scheduleNo), schedule.get("destinationHub"));
          }
          waitUntilVisibilityOfElementLocated(f(hubValueXpath, schedule.get("destinationHub")), 1);
        }, "Selecting destination hub...", 1000, 5);

        if (StringUtils.isNotBlank(schedule.get("movementType"))) {
          sendKeysAndEnterById(f(scheduleMovementTypeId, scheduleNo), schedule.get("movementType"));
        }
        if (StringUtils.isNotBlank(schedule.get("departureTime"))) {
          String[] hourTime = schedule.get("departureTime").split(":");
          TestUtils.findElementAndClick(f(scheduleStartTimeId, scheduleNo), "id", getWebDriver());
          pause1s();
          String hour = f(scheduleDepartureTimeXpath, 1, hourTime[0]);
          String time = f(scheduleDepartureTimeXpath, 2, hourTime[1]);
          moveToElementWithXpath(
              antpickerdropdownhidden + "//div[@class='ant-picker-content']//ul[1]");
          TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
          moveToElementWithXpath(
              antpickerdropdownhidden + "//div[@class='ant-picker-content']//ul[2]");
          TestUtils.findElementAndClick(time, "xpath", getWebDriver());
          TestUtils.findElementAndClick(antpickerdropdownhidden + "//li[@class='ant-picker-ok']",
              "xpath", getWebDriver());
        }

        doWithRetry(() -> {
          setDurationDays(schedule, scheduleNo);
        }, "Setting durations...", 1000, 5);

        if (StringUtils.isNotBlank(schedule.get("durationTime"))) {
          String[] hourTime = schedule.get("durationTime").split(":");
          TestUtils.findElementAndClick(f(scheduleDurationTimeId, scheduleNo), "id",
              getWebDriver());
          String hour = f(scheduleDurationTimeXpath, 1, hourTime[0]);
          String time = f(scheduleDurationTimeXpath, 2, hourTime[1]);
          moveToElementWithXpath(hour);
          TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
          moveToElementWithXpath(time);
          TestUtils.findElementAndClick(time, "xpath", getWebDriver());
          TestUtils.findElementAndClick(
              antpickerdropdownhidden + "//span[text()='Ok']",
              "xpath", getWebDriver());
        }
        if (StringUtils.isNotBlank(schedule.get("daysOfWeek"))) {
          String days = schedule.get("daysOfWeek");
          if (schedule.get("daysOfWeek").equalsIgnoreCase("all")) {
            days = "monday,tuesday,wednesday,thursday,friday,saturday,sunday";
          }
          setDaysOfWeek(Set.of(days.split(",")), scheduleNo);
        }
        if (StringUtils.isNotBlank(schedule.get("comment"))) {
          WebElement element = getWebDriver().findElement(By.id(f(scheduleCommentId, scheduleNo)));
          element.sendKeys(schedule.get("comment"));
        }

        if (schedule.containsKey("drivers")) {
          List<String> usernames = List.of(schedule.get("drivers").split(","));
          usernames.forEach(username -> {
            doWithRetry(() -> {
              Assertions.assertThat(isElementEnabled(f(MS_PAGE_ASSIGN_DRIVER_XPATH, scheduleNo))).as("Assign drivers dropdown is enabled.").isTrue();
            }, "Waiting until drivers dropdown is enabled...", 5000, 10);
            TestUtils.findElementAndClick(f(MS_PAGE_ASSIGN_DRIVER_XPATH, scheduleNo), "xpath", getWebDriver());
            sendKeys(f(MS_PAGE_ASSIGN_DRIVER_XPATH, scheduleNo), username);
            click(f(MS_PAGE_DROPDOWN_LIST_XPATH, username));
          });
        }
      }

      @Deprecated
      public void setDurationDays(MovementSchedule.Schedule schedule, int scheduleNo) {
        if (schedule.getDurationDays() != null) {
          TestUtils.findElementAndClick(
              "//input[@id='" + f(scheduleDurationDayId, scheduleNo) + "']", "xpath",
              getWebDriver());
          pause1s();
          TestUtils.findElementAndClick("//div[@id='schedules_" + scheduleNo
              + "_durationDay_list']/following-sibling::div//div[contains(@text,"
              + schedule.getDurationDays() + ")]", "xpath", getWebDriver());
          assertTrue("duration days input is wrong", findElement(
              By.xpath("//span[@title='" + schedule.getDurationDays() + "']")).isDisplayed());
        }
      }

      public void setDurationDays(Map<String, String> schedule, int scheduleNo) {
        if (schedule.get("durationDays") != null) {
          TestUtils.findElementAndClick(
              "//input[@id='" + f(scheduleDurationDayId, scheduleNo) + "']", "xpath",
              getWebDriver());
          pause1s();
          TestUtils.findElementAndClick("//div[@id='schedules_" + scheduleNo
              + "_durationDay_list']/following-sibling::div//div[contains(@text,"
              + schedule.get("durationDays") + ")]", "xpath", getWebDriver());
          assertTrue("duration days input is wrong", findElement(
              By.xpath("//span[@title='" + schedule.get("durationDays") + "']")).isDisplayed());
        }
      }

      public void setDaysOfWeek(Set<String> daysOfWeek, int scheduleNo) {
        List list = new ArrayList<>(daysOfWeek);
        for (String day : daysOfWeek) {
          int dayNo = DayOfWeek.valueOf(day.toUpperCase()).getValue();
          TestUtils.findElementAndClick(f(daysOfWeekXpath, scheduleNo, dayNo), "xpath",
              getWebDriver());
        }
      }
    }
  }

  public static class AddStationMovementScheduleModal extends AntModal {

    private AbstractTable abstractUtilities;

    public AddStationMovementScheduleModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String weekdaysXpath = "//div[@id='schedules_%s_days']//input[@type='checkbox'][@value='%s']";

    public void setDaysOfWeek(Set<String> daysOfWeek, String id) {
      if (daysOfWeek.contains("monday")) {
        TestUtils.findElementAndClick(f(weekdaysXpath, id, 1), "xpath", getWebDriver());
      }
      if (daysOfWeek.contains("tuesday")) {
        TestUtils.findElementAndClick(f(weekdaysXpath, id, 2), "xpath", getWebDriver());
      }
      if (daysOfWeek.contains("wednesday")) {
        TestUtils.findElementAndClick(f(weekdaysXpath, id, 3), "xpath", getWebDriver());
      }
      if (daysOfWeek.contains("thursday")) {
        TestUtils.findElementAndClick(f(weekdaysXpath, id, 4), "xpath", getWebDriver());
      }
      if (daysOfWeek.contains("friday")) {
        TestUtils.findElementAndClick(f(weekdaysXpath, id, 5), "xpath", getWebDriver());
      }
      if (daysOfWeek.contains("saturday")) {
        TestUtils.findElementAndClick(f(weekdaysXpath, id, 6), "xpath", getWebDriver());
      }
      if (daysOfWeek.contains("sunday")) {
        TestUtils.findElementAndClick(f(weekdaysXpath, id, 7), "xpath", getWebDriver());
      }
    }

    public String scheduleOriginHubId = "schedules_%s_originHub";
    public String scheduleDestinationHubId = "schedules_%s_destinationHub";
    public String scheduleMovementTypeId = "schedules_%s_movementType";
    public String scheduleStartTimeId = "schedules_%s_startTime";
    public String scheduleDepartureTimeXpath = "//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//ul[%s]//div[text()= '%s']";//"//div[@class='ant-picker-content']//ul[%s]//div[text()= '%s']";
    public String scheduleDurationDayId = "schedules_%s_durationDay";
    public String scheduleDurationTimeId = "schedules_%s_durationTime";
    public String scheduleDurationTimeXpath = "//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//ul[%s]//div[text()= '%s']";
    public String scheduleCommentId = "schedules_%s_comment";

    @FindBy(xpath = ".//button[.='Add another schedule']")
    public Button addAnotherSchedule;

    public String crossdockHub = "crossdockHubAddModal";

    @FindBy(xpath = ".//button[.='OK']")
    public Button create;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    @Deprecated
    public void fill(StationMovementSchedule stationMovementSchedule, String scheduleNo) {
      if (scheduleNo.equals("0")) {
        Optional.ofNullable(stationMovementSchedule.getCrossdockHub())
            .ifPresent(value -> sendKeysAndEnterById(crossdockHub, value));
      }

      Optional.ofNullable(stationMovementSchedule.getOriginHub())
          .ifPresent(value -> sendKeysAndEnterById(f(scheduleOriginHubId, scheduleNo), value));

      Optional.ofNullable(stationMovementSchedule.getDestinationHub())
          .ifPresent(value -> sendKeysAndEnterById(f(scheduleDestinationHubId, scheduleNo), value));

      Optional.ofNullable(stationMovementSchedule.getMovementType())
          .ifPresent(value -> sendKeysAndEnterById(f(scheduleMovementTypeId, scheduleNo), value));

      if (StringUtils.isNotBlank(stationMovementSchedule.getDepartureTime())) {
        String[] hourtime = stationMovementSchedule.getDepartureTime().split(":");
        TestUtils.findElementAndClick(f(scheduleStartTimeId, scheduleNo), "id", getWebDriver());
        String hour = f(scheduleDepartureTimeXpath, 1, hourtime[0]);
        String time = f(scheduleDepartureTimeXpath, 2, hourtime[1]);
        WebElement hourEle = findElementByXpath(hour, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            hourEle);
        hourEle.click();
        WebElement timeEle = findElementByXpath(time, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            timeEle);
        timeEle.click();
        TestUtils.findElementAndClick("ant-picker-ok", "class", getWebDriver());
      }

      if (stationMovementSchedule.getDuration() != null) {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
        {
          TestUtils.findElementAndClick(f(scheduleDurationDayId, scheduleNo), "id", getWebDriver());
          pause1s();
          TestUtils.findElementAndClick(
              "//div[contains(@text," + stationMovementSchedule.getDuration() + ")]", "xpath",
              getWebDriver());
          pause500ms();
          assertTrue("duration days input is wrong", findElement(
              By.xpath(
                  "//span[@title='" + stationMovementSchedule.getDuration() + "']")).isDisplayed());
        }, 3);

      }

      if (StringUtils.isNotBlank(stationMovementSchedule.getEndTime())) {
        String[] hourtime = stationMovementSchedule.getEndTime().split(":");
        TestUtils.findElementAndClick(f(scheduleDurationTimeId, scheduleNo), "id", getWebDriver());
        String hour = f(scheduleDurationTimeXpath, 1, hourtime[0]);
        String time = f(scheduleDurationTimeXpath, 2, hourtime[1]);
        WebElement hourEle = findElementByXpath(hour, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            hourEle);
        hourEle.click();

        WebElement timeEle = findElementByXpath(time, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            timeEle);
        timeEle.click();
        TestUtils.findElementAndClick(
            "//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//span[text()='Ok']",
            "xpath", getWebDriver());
      }

      if (CollectionUtils.isNotEmpty(stationMovementSchedule.getDaysOfWeek())) {
        setDaysOfWeek(stationMovementSchedule.getDaysOfWeek(), scheduleNo);
      }

      if (StringUtils.isNotBlank(stationMovementSchedule.getComment())) {
        WebElement element = getWebDriver().findElement(By.id(f(scheduleCommentId, scheduleNo)));
        element.sendKeys(stationMovementSchedule.getComment());
      }
    }

    public void fill(Map<String, String> stationMovementSchedule, String scheduleNo) {
      if (scheduleNo.equals("0")) {
        Optional.ofNullable(stationMovementSchedule.get("crossdockHub"))
            .ifPresent(value -> sendKeysAndEnterById(crossdockHub, value));
      }

      Optional.ofNullable(stationMovementSchedule.get("originHub"))
          .ifPresent(value -> sendKeysAndEnterById(f(scheduleOriginHubId, scheduleNo), value));

      Optional.ofNullable(stationMovementSchedule.get("destinationHub"))
          .ifPresent(value -> sendKeysAndEnterById(f(scheduleDestinationHubId, scheduleNo), value));

      Optional.ofNullable(stationMovementSchedule.get("movementType"))
          .ifPresent(value -> sendKeysAndEnterById(f(scheduleMovementTypeId, scheduleNo), value));

      if (StringUtils.isNotBlank(stationMovementSchedule.get("departureTime"))) {
        String[] hourTime = stationMovementSchedule.get("departureTime").split(":");
        TestUtils.findElementAndClick(f(scheduleStartTimeId, scheduleNo), "id", getWebDriver());
        String hour = f(scheduleDepartureTimeXpath, 1, hourTime[0]);
        String time = f(scheduleDepartureTimeXpath, 2, hourTime[1]);
        WebElement hourEle = findElementByXpath(hour, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            hourEle);
        hourEle.click();
        WebElement timeEle = findElementByXpath(time, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            timeEle);
        timeEle.click();
        findElementsByXpath("//li[@class='ant-picker-ok']").get(0).click();
      }

      if (stationMovementSchedule.get("duration") != null) {
        doWithRetry(() ->
        {
          TestUtils.findElementAndClick(f(scheduleDurationDayId, scheduleNo), "id", getWebDriver());
          pause1s();
          TestUtils.findElementAndClick(
              "//div[contains(@text," + stationMovementSchedule.get("duration") + ")]", "xpath",
              getWebDriver());
          pause500ms();
          assertTrue("duration days input is wrong", findElement(
              By.xpath(
                  "//span[@title='" + stationMovementSchedule.get("duration") + "']")).isDisplayed());
        }, "Filling durations...", 1000, 5);
      }

      if (StringUtils.isNotBlank(stationMovementSchedule.get("endTime"))) {
        String[] hourTime = stationMovementSchedule.get("endTime").split(":");
        TestUtils.findElementAndClick(f(scheduleDurationTimeId, scheduleNo), "id", getWebDriver());
        String hour = f(scheduleDurationTimeXpath, 1, hourTime[0]);
        String time = f(scheduleDurationTimeXpath, 2, hourTime[1]);
        WebElement hourEle = findElementByXpath(hour, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            hourEle);
        hourEle.click();

        WebElement timeEle = findElementByXpath(time, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            timeEle);
        timeEle.click();
        findElementsByXpath("//li[@class='ant-picker-ok']").get(1).click();
      }

      if (StringUtils.isNotBlank(stationMovementSchedule.get("daysOfWeek"))) {
        String days = stationMovementSchedule.get("daysOfWeek");
        if (stationMovementSchedule.get("daysOfWeek").equalsIgnoreCase("all")) {
          days = "monday,tuesday,wednesday,thursday,friday,saturday,sunday";
        }
        setDaysOfWeek(Set.of(days.split(",")), scheduleNo);
      }

      if (StringUtils.isNotBlank(stationMovementSchedule.get("comment"))) {
        WebElement element = getWebDriver().findElement(By.id(f(scheduleCommentId, scheduleNo)));
        element.sendKeys(stationMovementSchedule.get("comment"));
      }
    }

    @Deprecated
    public void fillAnother(StationMovementSchedule stationMovementSchedule, String scheduleNo) {
      Optional.ofNullable(stationMovementSchedule.getOriginHub())
          .ifPresent(value -> sendKeysAndEnterById(f(scheduleOriginHubId, scheduleNo), value));

      Optional.ofNullable(stationMovementSchedule.getDestinationHub())
          .ifPresent(value -> sendKeysAndEnterById(f(scheduleDestinationHubId, scheduleNo), value));

      Optional.ofNullable(stationMovementSchedule.getMovementType())
          .ifPresent(value -> sendKeysAndEnterById(f(scheduleMovementTypeId, scheduleNo), value));

      if (StringUtils.isNotBlank(stationMovementSchedule.getDepartureTime())) {
        String[] hourtime = stationMovementSchedule.getDepartureTime().split(":");
        TestUtils.findElementAndClick(f(scheduleStartTimeId, scheduleNo), "id", getWebDriver());
        String hour = f(scheduleDepartureTimeXpath, 1, hourtime[0]);
        String time = f(scheduleDepartureTimeXpath, 2, hourtime[1]);
        WebElement hourEle = findElementByXpath(hour, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            hourEle);
        hourEle.click();

        WebElement timeEle = findElementByXpath(time, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            timeEle);
        timeEle.click();
        TestUtils.findElementAndClick(
            "//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//span[text()='Ok']",
            "xpath", getWebDriver());
      }

      if (stationMovementSchedule.getDuration() != null) {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
        {
          TestUtils.findElementAndClick(f(scheduleDurationDayId, scheduleNo), "id", getWebDriver());
          pause500ms();
          TestUtils.findElementAndClick(
              "//div[contains(@class, 'ant-select-dropdown') and not(contains(@class , 'ant-select-dropdown-hidden'))]//div[@title='"
                  + stationMovementSchedule.getDuration() + "']", "xpath", getWebDriver());
        }, 3);
      }

      if (StringUtils.isNotBlank(stationMovementSchedule.getEndTime())) {
        String[] hourtime = stationMovementSchedule.getEndTime().split(":");
        TestUtils.findElementAndClick(f(scheduleDurationTimeId, scheduleNo), "id", getWebDriver());
        String hour = f(scheduleDurationTimeXpath, 1, hourtime[0]);
        String time = f(scheduleDurationTimeXpath, 2, hourtime[1]);
        WebElement hourEle = findElementByXpath(hour, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            hourEle);
        hourEle.click();

        WebElement timeEle = findElementByXpath(time, 1L);
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
            timeEle);
        timeEle.click();
        TestUtils.findElementAndClick(
            "//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//span[text()='Ok']",
            "xpath", getWebDriver());
      }

      if (CollectionUtils.isNotEmpty(stationMovementSchedule.getDaysOfWeek())) {
        setDaysOfWeek(stationMovementSchedule.getDaysOfWeek(), scheduleNo);
      }

      if (StringUtils.isNotBlank(stationMovementSchedule.getComment())) {
        WebElement element = getWebDriver().findElement(By.id(f(scheduleCommentId, scheduleNo)));
        element.sendKeys(stationMovementSchedule.getComment());
      }
    }
  }

  public static class RelationRow extends NvTable.NvRow {

    public RelationRow(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public RelationRow(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//td[contains(@class,'ant-table-cell hub-name')]")
    public PageElement station;

    @FindBy(xpath = "//td[contains(@class,'ant-table-cell crossdock-hub-name')]")
    public PageElement crossdock;

    @FindBy(xpath = "//td//button[.='Edit Relations']")
    public PageElement editRelations;
  }

  public static class MovementScheduleModal extends AntModal {

    public MovementScheduleModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public MovementScheduleModal(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//div[label[.='Origin Crossdock Hub']]")
    public AntTextWithLabel originCrossdockHub;

    @FindBy(xpath = ".//div[label[.='Destination Crossdock Hub']]")
    public AntTextWithLabel destinationCrossdockHub;

    @FindBy(xpath = ".//button[.='Edit Schedule']")
    public Button editSchedule;
  }

  public static class SchedulesTable extends AntTableV3<MovementSchedule.Schedule> {

    @FindBy(xpath = "//td[@class='start-time']//span[@class='ant-time-picker']")
    public AntTimePicker departureTime;

    @FindBy(xpath = "//td[@class='day']//input[@class='ant-input-number-input']")
    public TextBox durationDays;

    @FindBy(xpath = "//td[@class='duration']//span[@class='ant-time-picker']")
    public AntTimePicker durationTime;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='1']")
    public CheckBox monday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='2']")
    public CheckBox tuesday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='3']")
    public CheckBox wednesday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='4']")
    public CheckBox thursday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='5']")
    public CheckBox friday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='6']")
    public CheckBox saturday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='7']")
    public CheckBox sunday;

    @FindBy(xpath = "//td[@class='comments']//textarea")
    public TextBox comment;

    @FindBy(xpath = "//th[contains(@class,'origin-hub-name')]//input")
    public TextBox filterOriginHubName;

    @FindBy(xpath = "//th[contains(@class,'destination-hub-name')]//input")
    public TextBox filterDestHubName;

    private static final Pattern DURATION_PATTERN = Pattern
        .compile("(\\d{2})d\\s(\\d{2})h\\s(\\d{2})m");
    private static final String DAY_OF_WEEK_LOCATOR = ".//tbody/tr[%d]/td[contains(@class,'day')]//input[@value='%d']";
    public static final String COLUMN_ORIGIN_HUB = "originHub";
    public static final String COLUMN_DESTINATION_HUB = "destinationHub";
    public static final String COLUMN_DURATION = "durationDays";
    public static final String COLUMN_DURATION_TIME = "durationTime";
    public static final String COLUMN_DAYS_OF_WEEK = "daysOfWeek";
    public static final String COLUMN_DRIVERS = "numberOfDrivers";

    public SchedulesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ORIGIN_HUB, "origin-hub-name")
          .put(COLUMN_DESTINATION_HUB, "destination-hub-name")
          .put("movementType", "movement-type")
          .put("departureTime", "start-time")
          .put(COLUMN_DURATION, "duration")
          .put(COLUMN_DURATION_TIME, "duration")
          .put(COLUMN_DAYS_OF_WEEK, "day")
          .put(COLUMN_DRIVERS, "drivers")
          .put("comment", "comments")
          .build()
      );
      setColumnValueProcessors(ImmutableMap.of(
          COLUMN_DURATION, value ->
          {
            Matcher m = DURATION_PATTERN.matcher(value);
            return m.matches() ? m.group(1) : null;
          },
          COLUMN_DURATION_TIME, value ->
          {
            Matcher m = DURATION_PATTERN.matcher(value);
            return m.matches() ? m.group(2) + ":" + m.group(3) : null;
          },
          COLUMN_DRIVERS, value ->
          {
            String[] values = value.split(",");
            return Integer.toString(values.length);

          }
      ));
      setColumnReaders(ImmutableMap.of(COLUMN_DAYS_OF_WEEK, this::getDaysOfWeek));
      setEntityClass(MovementSchedule.Schedule.class);
    }

    public String getDaysOfWeek(int rowNumber) {
      rowNumber++;
      WebElement checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 1));
      Set<String> days = new LinkedHashSet<>();
      if (checkbox.isSelected()) {
        days.add("monday");
      }
      checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 2));
      if (checkbox.isSelected()) {
        days.add("tuesday");
      }
      checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 3));
      if (checkbox.isSelected()) {
        days.add("wednesday");
      }
      checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 4));
      if (checkbox.isSelected()) {
        days.add("thursday");
      }
      checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 5));
      if (checkbox.isSelected()) {
        days.add("friday");
      }
      checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 6));
      if (checkbox.isSelected()) {
        days.add("saturday");
      }
      checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 7));
      if (checkbox.isSelected()) {
        days.add("sunday");
      }
      return String.join(",", days);
    }

    public void editSchedule(MovementSchedule.Schedule schedule) {
      if (StringUtils.isNotBlank(schedule.getDepartureTime())) {
        departureTime.setValue(schedule.getDepartureTime());
      }
      if (schedule.getDurationDays() != null) {
        durationDays.sendKeys(Keys.BACK_SPACE + String.valueOf(schedule.getDurationDays()));
      }
      if (StringUtils.isNotBlank(schedule.getDurationTime())) {
        durationTime.setValue(schedule.getDurationTime());
      }
      if (CollectionUtils.isNotEmpty(schedule.getDaysOfWeek())) {
        setDaysOfWeek(schedule.getDaysOfWeek());
      }
      if (StringUtils.isNotBlank(schedule.getComment())) {
        comment.setValue(schedule.getComment());
      }
    }

    public void setDaysOfWeek(Set<String> daysOfWeek) {
      monday.setValue(daysOfWeek.contains("monday"));
      tuesday.setValue(daysOfWeek.contains("tuesday"));
      wednesday.setValue(daysOfWeek.contains("wednesday"));
      thursday.setValue(daysOfWeek.contains("thursday"));
      friday.setValue(daysOfWeek.contains("friday"));
      saturday.setValue(daysOfWeek.contains("saturday"));
      sunday.setValue(daysOfWeek.contains("sunday"));
    }

    @Override
    protected String getTableLocator() {
      return StringUtils.isNotBlank(tableLocator) ? tableLocator
          : "//div[contains(@class,'ant-table-body')]//table";
    }

    @Override
    public int getRowsCount() {
      if (StringUtils.isNotBlank(getTableLocator())) {
        return executeInContext(getTableLocator(),
            () -> getElementsCount(".//tbody/tr[not(@aria-hidden='true')]"));
      } else {
        return getElementsCount(
            "//tbody//tr[not(@aria-hidden='true')][contains(@class,'ant-table-row')]");
      }
    }
  }

  public static class HubRelationSchedulesTable extends AntTableV3<HubRelationSchedule> {

    @FindBy(xpath = "//td[contains(@class,'start-time')]")
    public AntTimePicker departureTime;

    @FindBy(xpath = "//td[contains(@class,'duration')]")
    public TextBox durationDays;

    @FindBy(xpath = "//td[@class='duration']")
    public AntTimePicker durationTime;

    @FindBy(xpath = "//td[contains(@class,'day')]//input[@type='checkbox'][@value='1']")
    public CheckBox monday;

    @FindBy(xpath = "//td[contains(@class,'day')]//input[@type='checkbox'][@value='2']")
    public CheckBox tuesday;

    @FindBy(xpath = "//td[contains(@class,'day')]//input[@type='checkbox'][@value='3']")
    public CheckBox wednesday;

    @FindBy(xpath = "//td[contains(@class,'day')]//input[@type='checkbox'][@value='4']")
    public CheckBox thursday;

    @FindBy(xpath = "//td[contains(@class,'day')]//input[@type='checkbox'][@value='5']")
    public CheckBox friday;

    @FindBy(xpath = "//td[contains(@class,'day')]//input[@type='checkbox'][@value='6']")
    public CheckBox saturday;

    @FindBy(xpath = "//td[contains(@class,'day')]//input[@type='checkbox'][@value='7']")
    public CheckBox sunday;

    @FindBy(xpath = "//td[contains(@class,'comment')]")
    public TextBox comment;

    private static final Pattern DURATION_PATTERN = Pattern
        .compile("(\\d{2})d\\s(\\d{2})h\\s(\\d{2})m");

    public HubRelationSchedulesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("originHubName", "origin-hub-name")
          .put("destinationHubName", "destination-hub-name")
          .put("movementType", "movement-type")
          .put("departureTime", "start-time")
          .put("duration", "duration")
          .put("comment", "comments")
          .build()
      );
      setColumnValueProcessors(ImmutableMap.of(
          "movementType", value ->
          {
            value = value.toLowerCase();
            return String.join("_", value.split(" "));
          },
          "duration", value ->
          {
            Matcher m = DURATION_PATTERN.matcher(value);
            return m.matches() ? m.group(1) + ":" + m.group(2) + ":" + m.group(3) : null;
          }
      ));
      setEntityClass(HubRelationSchedule.class);
    }

    public void editSchedule(MovementSchedule.Schedule schedule) {
      if (StringUtils.isNotBlank(schedule.getDepartureTime())) {
        departureTime.setValue(schedule.getDepartureTime());
      }
      if (schedule.getDurationDays() != null) {
        durationDays.sendKeys(Keys.BACK_SPACE + String.valueOf(schedule.getDurationDays()));
      }
      if (StringUtils.isNotBlank(schedule.getDurationTime())) {
        durationTime.setValue(schedule.getDurationTime());
      }
      if (CollectionUtils.isNotEmpty(schedule.getDaysOfWeek())) {
        setDaysOfWeek(schedule.getDaysOfWeek());
      }
      if (StringUtils.isNotBlank(schedule.getComment())) {
        comment.setValue(schedule.getComment());
      }
    }

    public void setDaysOfWeek(Set<String> daysOfWeek) {
      monday.setValue(daysOfWeek.contains("monday"));
      tuesday.setValue(daysOfWeek.contains("tuesday"));
      wednesday.setValue(daysOfWeek.contains("wednesday"));
      thursday.setValue(daysOfWeek.contains("thursday"));
      friday.setValue(daysOfWeek.contains("friday"));
      saturday.setValue(daysOfWeek.contains("saturday"));
      sunday.setValue(daysOfWeek.contains("sunday"));
    }

    public void filterStationsColumn() {
      String filterXPATH = "//th[contains(@class,'%s')]//button";
      String filterInputXPATH = "//th[contains(@class,'%s')]//input";
      String filterConfirmXPATH = "//th[contains(@class,'%s')]//button[.='OK']";

      findElementByXpath(f(filterXPATH, "movementType")).click();
      findElementByXpath(f(filterInputXPATH, "movementType")).click();
      findElementByXpath(f(filterConfirmXPATH, "movementType")).click();

      findElementByXpath(f(filterXPATH, "wave")).click();
      findElementByXpath(f(filterInputXPATH, "wave")).click();
      findElementByXpath(f(filterConfirmXPATH, "wave")).click();

      findElementByXpath(f(filterXPATH, "duration")).click();
      findElementByXpath(f(filterInputXPATH, "duration")).click();
      findElementByXpath(f(filterConfirmXPATH, "duration")).click();

      executeScript("arguments[0].click()", findElementByXpath(f(filterXPATH, "daysofweek")));
      findElementByXpath(f(filterInputXPATH, "daysofweek")).click();
      findElementByXpath(f(filterConfirmXPATH, "daysofweek")).click();
    }
  }

  public static class StationMovementSchedulesTable extends AntTable<StationMovementSchedule> {

    @FindBy(xpath = "//td[@class='startTime']//span[@class='ant-time-picker']")
    public AntTimePicker departureTime;

    @FindBy(xpath = "//td[@class='duration']//input[@class='ant-input-number-input']")
    public TextBox durationDays;

    @FindBy(xpath = "//td[@class='duration']//span[@class='ant-time-picker']")
    public AntTimePicker durationTime;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='1']")
    public CheckBox monday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='2']")
    public CheckBox tuesday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='3']")
    public CheckBox wednesday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='4']")
    public CheckBox thursday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='5']")
    public CheckBox friday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='6']")
    public CheckBox saturday;

    @FindBy(xpath = "//td[@class='daysofweek']//input[@type='checkbox'][@value='7']")
    public CheckBox sunday;

    @FindBy(xpath = "//td[@class='comment']//textarea")
    public TextBox comment;

    private static final Pattern DURATION_PATTERN = Pattern
        .compile("(\\d{2})d\\s(\\d{2})h\\s(\\d{2})m");

    public StationMovementSchedulesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("originHub", "origin-hub-name")
          .put("destinationHub", "destination-hub-name")
          .put("movementType", "movement-type")
          .put("departureTime", "start-time")
          .put("endTime", "duration")
          .put("comment", "comments")
          .build()
      );
      setColumnValueProcessors(ImmutableMap.of(
          "endTime", value ->
          {
            Matcher m = DURATION_PATTERN.matcher(value);
            return m.matches() ? m.group(2) + ":" + m.group(3) : null;
          }
      ));
      setEntityClass(StationMovementSchedule.class);
    }

    public void editSchedule(MovementSchedule.Schedule schedule) {
      if (StringUtils.isNotBlank(schedule.getDepartureTime())) {
        departureTime.setValue(schedule.getDepartureTime());
      }
      if (schedule.getDurationDays() != null) {
        durationDays.sendKeys(Keys.BACK_SPACE + String.valueOf(schedule.getDurationDays()));
      }
      if (StringUtils.isNotBlank(schedule.getDurationTime())) {
        durationTime.setValue(schedule.getDurationTime());
      }
      if (CollectionUtils.isNotEmpty(schedule.getDaysOfWeek())) {
        setDaysOfWeek(schedule.getDaysOfWeek());
      }
      if (StringUtils.isNotBlank(schedule.getComment())) {
        comment.setValue(schedule.getComment());
      }
    }

    public void setDaysOfWeek(Set<String> daysOfWeek) {
      monday.setValue(daysOfWeek.contains("monday"));
      tuesday.setValue(daysOfWeek.contains("tuesday"));
      wednesday.setValue(daysOfWeek.contains("wednesday"));
      thursday.setValue(daysOfWeek.contains("thursday"));
      friday.setValue(daysOfWeek.contains("friday"));
      saturday.setValue(daysOfWeek.contains("saturday"));
      sunday.setValue(daysOfWeek.contains("sunday"));
    }

    public void filterStationsColumn() {
      String filterXPATH = "//th[contains(@class,'%s')]//button";
      String filterInputXPATH = "//th[contains(@class,'%s')]//input";
      String filterConfirmXPATH = "//th[contains(@class,'%s')]//button[.='OK']";

      findElementByXpath(f(filterXPATH, "movement-type")).click();
      findElementByXpath(f(filterInputXPATH, "movement-type")).click();
      findElementByXpath(f(filterConfirmXPATH, "movement-type")).click();

      findElementByXpath(f(filterXPATH, "wave")).click();
      findElementByXpath(f(filterInputXPATH, "wave")).click();
      findElementByXpath(f(filterConfirmXPATH, "wave")).click();

      findElementByXpath(f(filterXPATH, "duration")).click();
      findElementByXpath(f(filterInputXPATH, "duration")).click();
      findElementByXpath(f(filterConfirmXPATH, "duration")).click();

      executeScript("arguments[0].click()", findElementByXpath(f(filterXPATH, "day")));
      findElementByXpath(f(filterInputXPATH, "day")).click();
      findElementByXpath(f(filterConfirmXPATH, "day")).click();
    }
  }

  public static class UpdateSchedulesConfirmationModal extends AntModal {

    public UpdateSchedulesConfirmationModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//button[.='Update']")
    public Button update;
  }

  public void UpdatesdepartureTime(String value) {
    departureTimeInputs = findElementsByXpath(MS_PAGE_DEPARTURE_TIME_LIST_XPATH);
    departureTimeInputs.forEach((element) -> dateTimeInput(element, value));
  }

  public void UpdatesdepartureTime(String value, int index) {
    departureTimeInputs = findElementsByXpath(MS_PAGE_DEPARTURE_TIME_LIST_XPATH);
    dateTimeInput(departureTimeInputs.get(index), value);
  }

  public void UpdatesdurationTime(String value) {
    durationInputs = findElementsByXpath(MS_PAGE_DURATION_TIME_LIST_XPATH);
    durationInputs.forEach((element) -> dateTimeInput(element, value));
  }

  public void UpdatesdurationTime(String value, int index) {
    durationInputs = findElementsByXpath(MS_PAGE_DURATION_TIME_LIST_XPATH);
    dateTimeInput(durationInputs.get(index), value);
  }

  public void dateTimeInput(WebElement element, String value) {
    executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});", element);
    element.click();
    pause500ms();
    String[] times = value.split(":");
    WebElement timeElement = findElementByXpath(f(MS_PAGE_PICKER_HOUR_DROPDOWN_XPATH, times[0]));
    executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
        timeElement);
    timeElement.click();
    pause300ms();
    timeElement = findElementByXpath(f(MS_PAGE_PICKER_MIN_DROPDOWN_XPATH, times[1]));
    executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
        timeElement);
    timeElement.click();
    element.sendKeys(Keys.RETURN);

  }

  public void updateDaysOfWeek(Set<String> daysOfWeek, int index) {
    String weekdaysXpath = "(//td[contains(@class,'ant-table-cell day')]//input[@value='%d'])[%d]";
    WebElement day = findElementByXpath(f(MS_PAGE_DAY_OF_WEEK_XPATH, 1));
    executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});", day);
    if (!daysOfWeek.contains("monday")) {
      TestUtils.findElementAndClick(f(weekdaysXpath, 1, index), "xpath", getWebDriver());
    }
    if (!daysOfWeek.contains("tuesday")) {
      TestUtils.findElementAndClick(f(weekdaysXpath, 2, index), "xpath", getWebDriver());
    }
    if (!daysOfWeek.contains("wednesday")) {
      TestUtils.findElementAndClick(f(weekdaysXpath, 3, index), "xpath", getWebDriver());
    }
    if (!daysOfWeek.contains("thursday")) {
      TestUtils.findElementAndClick(f(weekdaysXpath, 4, index), "xpath", getWebDriver());
    }
    if (!daysOfWeek.contains("friday")) {
      TestUtils.findElementAndClick(f(weekdaysXpath, 5, index), "xpath", getWebDriver());
    }
    if (!daysOfWeek.contains("saturday")) {
      TestUtils.findElementAndClick(f(weekdaysXpath, 6, index), "xpath", getWebDriver());
    }
    if (!daysOfWeek.contains("sunday")) {
      TestUtils.findElementAndClick(f(weekdaysXpath, 7, index), "xpath", getWebDriver());
    }
  }

  public String getValueInLastItem(String xpath, String attribute) {
    switch (xpath) {
      case "start time":
        xpath = MS_PAGE_DEPARTURE_TIME_LIST_XPATH;
        break;
      case "duration":
        xpath = MS_PAGE_DURATION_TIME_LIST_XPATH;
        break;
    }

    List<WebElement> elements = findElementsByXpath(xpath);
    executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});",
        elements.get(elements.size() - 1));
    return elements.get(elements.size() - 1).getAttribute(attribute);
  }

  public void verifyPageInViewMode() {
    Assertions.assertThat(modify.isEnabled()).as("Page is in View Mode").isTrue();
  }

  public void waitForLoadingIconDisappear() {
    waitUntilInvisibilityOfElementLocated(MS_PAGE_LOADING_ICON_XPATH, 10);
  }

  public void deleteMovementSchedule(int index) {
    modify.click();
    findElementByXpath(f(MS_PAGE_ITEM_CHECKBOX_XPATH, index)).click();
    delete.click();
    modalUpdateButton.click();
  }

  public void verifyInvalidItem(String name, String value, int index) {
    switch (name) {
      case "origin hub":
        String originHubName = value;
        TestUtils.findElementAndClick(MS_PAGE_ORIGIN_HUB_XPATH, "xpath", getWebDriver());
        sendKeys(MS_PAGE_ORIGIN_HUB_XPATH, originHubName);
        Assertions.assertThat(
                isElementExist(f(MS_PAGE_DROPDOWN_LIST_XPATH, originHubName), 1L))
            .as("Disable Origin Hub is not displayed").isFalse();
        findElementByXpath(MS_PAGE_ORIGIN_HUB_XPATH).clear();
        break;

      case "destination hub":
        String destinationHubName = value;
        TestUtils.findElementAndClick(MS_PAGE_DESTINATION_HUB_XPATH, "xpath",
            getWebDriver());
        sendKeys(MS_PAGE_DESTINATION_HUB_XPATH, destinationHubName);
        Assertions.assertThat(
                isElementExist(f(MS_PAGE_DROPDOWN_LIST_XPATH, destinationHubName), 1L))
            .as("Disable Destination Hub is not displayed").isFalse();
        findElementByXpath(MS_PAGE_DESTINATION_HUB_XPATH).clear();
        break;

      case "driver":
        String driverUsername = value;
        TestUtils.findElementAndClick(f(MS_PAGE_ASSIGN_DRIVER_XPATH, index), "xpath",
            getWebDriver());
        sendKeys(f(MS_PAGE_ASSIGN_DRIVER_XPATH, index), driverUsername);
        Assertions.assertThat(
                isElementExist(f(MS_PAGE_DROPDOWN_LIST_XPATH, driverUsername), 1L))
            .as("Invalid Driver has not been displayed").isFalse();
        break;
    }
  }

  public void assignDrivers(int numberOfDrivers, List<Driver> middleMileDrivers, int index) {
    int maxAssignDrivers = numberOfDrivers > 4 ? 4 : numberOfDrivers;
    for (int i = 0; i < maxAssignDrivers; i++) {
      TestUtils.findElementAndClick(f(MS_PAGE_ASSIGN_DRIVER_XPATH, index), "xpath", getWebDriver());
      sendKeys(f(MS_PAGE_ASSIGN_DRIVER_XPATH, index), middleMileDrivers.get(i).getUsername());
      click(f(MS_PAGE_DROPDOWN_LIST_XPATH, middleMileDrivers.get(i).getUsername()));
    }
    if (numberOfDrivers > 4) {
      verifyCanNotAssignMoreThan4Drivers(middleMileDrivers, index);
    }
  }

  public void verifyCanNotAssignMoreThan4Drivers(List<Driver> middleMileDrivers, int index) {
    TestUtils.findElementAndClick(f(MS_PAGE_ASSIGN_DRIVER_XPATH, index), "xpath", getWebDriver());
    sendKeys(f(MS_PAGE_ASSIGN_DRIVER_XPATH, index),
        middleMileDrivers.get(middleMileDrivers.size() - 1).getUsername());
    click(f(MS_PAGE_DROPDOWN_LIST_XPATH,
        middleMileDrivers.get(middleMileDrivers.size() - 1).getUsername()));
    Boolean isDriverSelected = findElementByXpath(f(MS_PAGE_DROPDOWN_LIST_XPATH,
        middleMileDrivers.get(middleMileDrivers.size() - 1).getUsername())).isSelected();

    Assertions.assertThat(isDriverSelected).as(" Can not select more than 4 drivers").isFalse();
  }

  public void verifyListDriver(List<Driver> middleMileDrivers) {
    Boolean result = true;
    List<WebElement> ActualDrivers = findElementsByXpath(MS_PAGE_DRIVERS_COLUMN_XPATH);
    List<String[]> AcutalDriversUsername = new ArrayList<>();
    ActualDrivers.forEach((element) -> {
      AcutalDriversUsername.add(element.getText().split(","));
    });
    List<String> ExpectedDriverUsename = getListDriverUsername(middleMileDrivers);
    for (String[] element : AcutalDriversUsername) {
      for (String s : element) {
        s = s.replace("(main)", "").trim();
        if (!ExpectedDriverUsename.contains(s)) {
          result = false;
        }
      }
    }
    Assertions.assertThat(result).as("Drivers are show on Movement Schedule page as expected")
        .isTrue();
  }

  public List<String> getListDriverUsername(List<Driver> middleMileDrivers) {
    List<String> ExpectedList = new ArrayList<>();
    middleMileDrivers.forEach((e) -> {
      ExpectedList.add(e.getFullName());
    });
    return ExpectedList;
  }

  public void verifyConfirmDialog(String expectedMessage) {
    waitUntilVisibilityOfElementLocated(MS_PAGE_CONFIRM_DIALOG_XPATH);
    String actualMessage = findElementByXpath(MS_PAGE_CONFIRM_DIALOG_XPATH).getText();
    Assertions.assertThat(actualMessage).as(f("Message %s display", expectedMessage))
        .isEqualToIgnoringCase(expectedMessage);
  }

  public void closeIfConfirmDialogAppear() {
    if (!isElementVisible(MS_PAGE_CONFIRM_DIALOG_XPATH, 2)) return;

    modalOkButton.click();
    waitUntilInvisibilityOfElementLocated(MS_PAGE_CONFIRM_DIALOG_XPATH);
  }

}