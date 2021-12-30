package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.commons.model.sort.hub.movement_trips.HubRelationSchedule;
import co.nvqa.operator_v2.model.MovementSchedule;
import co.nvqa.operator_v2.model.StationMovementSchedule;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextWithLabel;
import co.nvqa.operator_v2.selenium.elements.ant.AntTimePicker;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
/**
 * @author Sergey Mishanin
 */
public class MovementManagementPage extends OperatorV2SimplePage {

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

  @FindBy(id = "originHubId")
  public AntSelect originCrossdockHub;

  @FindBy(id = "orig_station_hub")
  public AntSelect originStationHub;

  @FindBy(id = "crossdock_hub")
  public AntSelect crossdockHub;

  @FindBy(id = "destinationHubId")
  public AntSelect destinationCrossdockHub;

  @FindBy(id = "dest_station_hub")
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

  @FindBy(xpath = "//th[contains(.,'Station')]//input")
  public TextBox stationFilter;

  //region Stations tab
  @FindBy(xpath = "//label[starts-with(.,'Station')]")
  public PageElement stationsTab;

  @FindBy(xpath = "//button[.='Add Schedule']")
  public Button addSchedule;

  @FindBy(xpath = "//button[.='Delete']")
  public Button delete;

  @FindBy(xpath = "//button[.='Modify']")
  public Button modify;

  @FindBy(xpath = "//button[.='Save']")
  public Button save;

  @FindBy(css = "div.ant-modal")
  public AddStationMovementScheduleModal addStationMovementScheduleModal;

  @FindBy(xpath = "//tr[1]//td[contains(@class,'action')]/i[1]")
  public PageElement assignDriverButton;

  @FindBy(className = "ant-modal-wrap")
  public TripManagementPage.AssignTripModalOld assignDriverModal;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message' and .='Relation created']")
  public PageElement successCreateRelation;

  @FindBy(xpath = "//tr[1]//td[1]//input")
  public CheckBox rowCheckBox;

  @FindBy(xpath = "//tr[2]//td[1]//input")
  public CheckBox rowCheckBoxSecond;

  @FindBy(xpath = "//button[.='Delete' and contains(@class, 'ant-btn-primary')]")
  public Button modalDeleteButton;

  @FindBy(xpath = "//button[.='Update' and contains(@class, 'ant-btn-primary')]")
  public Button modalUpdateButton;

  @FindBy(xpath = "//div[@class='ant-modal-body']//div//span")
  public TextBox effectingPathText;

  @FindBy(xpath = "(//div[@class='ant-modal-content']//button[@aria-label='Close'])[2]")
  public Button effectingPathClose;

  @FindBy(xpath = "//span[.='No Results Found']")
  public TextBox noResultsFoundText;

  @FindBy(xpath = "//td[@class='startTime']//span[@class='ant-time-picker']")
  public List<AntTimePicker> departureTimeInputs;

  @FindBy(xpath = "//td[@class='duration']//span[@class='ant-time-picker']")
  public List<AntTimePicker> durationInputs;

  @FindBy(xpath = "//td[@class='comment']//textarea")
  public List<TextBox> commentInputs;

  @FindBy(xpath = "//td[@class='startTime']")
  public List<TextBox> departureTimes;

  @FindBy(xpath = "//td[@class='duration']")
  public List<TextBox> durations;

  @FindBy(xpath = "//td[@class='comment']")
  public List<TextBox> comments;
  //endregion

  public SchedulesTable schedulesTable;
  public HubRelationSchedulesTable hubRelationScheduleTable;
  public StationMovementSchedulesTable stationMovementSchedulesTable;

  public MovementManagementPage(WebDriver webDriver) {
    super(webDriver);
    schedulesTable = new SchedulesTable(webDriver);
    hubRelationScheduleTable = new HubRelationSchedulesTable(webDriver);
    stationMovementSchedulesTable = new StationMovementSchedulesTable(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void loadSchedules(String crossdockHub, String originHub, String destinationHub) {
    if (editFilters.isDisplayedFast()) {
      editFilters.click();
    }

    if (StringUtils.isNotBlank(crossdockHub)) {
      this.crossdockHub.selectValue(crossdockHub);
      pause2s();

      if (StringUtils.isNotBlank(originHub)) {
        originStationHub.selectValue(originHub);
      }

      if (StringUtils.isNotBlank(destinationHub)) {
        destinationStationHub.selectValue(destinationHub);
      }
    } else {
      if (StringUtils.isNotBlank(originHub)) {
        originCrossdockHub.selectValue(originHub);
      }

      if (StringUtils.isNotBlank(destinationHub)) {
        destinationCrossdockHub.selectValue(destinationHub);
      }
    }

    loadSchedules.click();
    originCrossdockHubFilter.waitUntilClickable();
  }

  public void clickAssignDriverIcon() {
    assignDriverButton.waitUntilClickable();
    assignDriverButton.click();
  }

  public void assignDriver(String driverId) {
    assignDriverModal.waitUntilVisible();
    assignDriverModal.addDriver.click();
    assignDriverModal.assignDriver(driverId);
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
    String notificationXpath = "//div[contains(@class,'ant-notification')]//div[@class='ant-notification-notice-message']";
    waitUntilVisibilityOfElementLocated(notificationXpath);
    WebElement notificationElement = findElementByXpath(notificationXpath);
    assertThat("Toast message is the same", notificationElement.getText(),
        equalTo(containsMessage));
    waitUntilInvisibilityOfNotification(notificationXpath, false);
  }

  public static class EditStationRelationsModal extends AntModal {

    public EditStationRelationsModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String crossdockHub = "crossdock_hub_id";

    public void fill(String value) {
      sendKeysAndEnterById(crossdockHub, value);
    }

    @FindBy(xpath = "//button[.='Save']")
    public Button save;
  }

  public static class AddMovementScheduleModal extends AntModal {

    public AddMovementScheduleModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//button[.='Add another schedule']")
    public Button addAnotherSchedule;

    @FindBy(xpath = ".//button[.='OK']")
    public Button create;

    @FindBy(css = "div.has-error")
    public PageElement errorMessage;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    public void fill(MovementSchedule schedule) {
      for (int i = 1; i <= schedule.getSchedules().size(); i++) {
        ScheduleForm scheduleForm = getScheduleForm(i);
        scheduleForm.fill(schedule.getSchedules().get(i - 1), i-1);
        if (i < schedule.getSchedules().size()) {
          addAnotherSchedule.click();
        }
      }
    }

    public ScheduleForm getScheduleForm(int index) {
      WebElement webElement = findElementByXpath(
          f(".//div[contains(@class,'ant-divider')][%d]", index));
      return new ScheduleForm(getWebDriver(), getWebElement(), webElement);
    }

    public static class ScheduleForm extends PageElement {

      public ScheduleForm(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      }

      @FindBy(xpath = "./following-sibling::div//*[contains(@id,'origin_hub_id')]")
      public AntSelect originHub;

      @FindBy(xpath = "./following-sibling::div//*[contains(@id,'destination_hub_id')]")
      public AntSelect destinationHub;

      @FindBy(xpath = "./following-sibling::div//*[contains(@id,'movement_type')]")
      public AntSelect movementType;

      @FindBy(xpath = "(./following-sibling::div//span[@class='ant-time-picker'])[1]")
      public AntTimePicker departureTime;

      @FindBy(xpath = "./following-sibling::div//input[contains(@id,'duration_day')]")
      public TextBox durationDays;

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

      @FindBy(xpath = "./following-sibling::div//textarea[contains(@id,'comment')]")
      public TextBox comment;

      public String scheduleOriginHubId = "schedules_%s_originHub";
      public String scheduleDestinationHubId = "schedules_%s_destinationHub";
      public String scheduleMovementTypeId = "schedules_%s_movementType";
      public String scheduleStartTimeId = "schedules_%s_startTime";
      public String scheduleDepartureTimeXpath = "//div[@class='ant-picker-content']//ul[%s]//div[text()= '%s']";
      public String scheduleDurationDayId = "schedules_%s_durationDay";
      public String scheduleDurationTimeId = "schedules_%s_durationTime";
      public String scheduleDurationTimeXpath = "//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//ul[%s]//div[text()= '%s']";
      public String scheduleDaysId = "schedules_%s_days";
      public String scheduleDriversId = "schedules_%s_drivers";
      public String scheduleCommentId = "schedules_%s_comment";

      public void callJavaScriptExecutor(String argument, WebElement element){
        JavascriptExecutor jse = ((JavascriptExecutor)getWebDriver());
        jse.executeScript(argument, element);
      }

      public void fill(MovementSchedule.Schedule schedule, int scheduleNo) {
        if (StringUtils.isNotBlank(schedule.getOriginHub())) {
          sendKeysAndEnterById(f(scheduleOriginHubId, scheduleNo), schedule.getOriginHub());
        }
        if (StringUtils.isNotBlank(schedule.getDestinationHub())) {
          sendKeysAndEnterById(f(scheduleDestinationHubId, scheduleNo), schedule.getDestinationHub());
        }
        if (StringUtils.isNotBlank(schedule.getMovementType())) {
          sendKeysAndEnterById(f(scheduleMovementTypeId, scheduleNo), schedule.getMovementType());
        }
        if (StringUtils.isNotBlank(schedule.getDepartureTime())) {
          String[] hourtime = schedule.getDepartureTime().split(":");
          TestUtils.findElementAndClick(f(scheduleStartTimeId, scheduleNo), "id", getWebDriver());
          String hour = f(scheduleDepartureTimeXpath, 1, hourtime[0]);
          String time = f(scheduleDepartureTimeXpath, 2, hourtime[1]);
          moveToElementWithXpath("//div[@class='ant-picker-content']//ul[1]");
          TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
          moveToElementWithXpath("//div[@class='ant-picker-content']//ul[2]");
          TestUtils.findElementAndClick(time, "xpath", getWebDriver());
          TestUtils.findElementAndClick("ant-picker-ok", "class", getWebDriver());
        }
        if (schedule.getDurationDays() != null) {
          TestUtils.findElementAndClick(f(scheduleDurationDayId, scheduleNo), "id", getWebDriver());
          TestUtils.findElementAndClick("//div[@title='"+schedule.getDurationDays()+"']", "xpath", getWebDriver());
        }
        if (StringUtils.isNotBlank(schedule.getDurationTime())) {
          String[] hourtime = schedule.getDurationTime().split(":");
          TestUtils.findElementAndClick(f(scheduleDurationTimeId, scheduleNo), "id", getWebDriver());
          String hour = f(scheduleDurationTimeXpath, 1, hourtime[0]);
          String time = f(scheduleDurationTimeXpath, 2, hourtime[1]);
          moveToElementWithXpath(hour);
          TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
          moveToElementWithXpath(time);
          TestUtils.findElementAndClick(time, "xpath", getWebDriver());
          TestUtils.findElementAndClick("//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//span[text()='Ok']", "xpath", getWebDriver());
        }
        if (CollectionUtils.isNotEmpty(schedule.getDaysOfWeek())) {
          setDaysOfWeek(schedule.getDaysOfWeek());
        }
        if (StringUtils.isNotBlank(schedule.getComment())) {
          WebElement element = getWebDriver().findElement(By.id(f(scheduleCommentId, scheduleNo)));
          element.sendKeys(schedule.getComment());
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
      if (daysOfWeek.contains("monday")) TestUtils.findElementAndClick(f(weekdaysXpath, id, 1), "xpath", getWebDriver());
      if (daysOfWeek.contains("tuesday")) TestUtils.findElementAndClick(f(weekdaysXpath, id, 2), "xpath", getWebDriver());
      if (daysOfWeek.contains("wednesday")) TestUtils.findElementAndClick(f(weekdaysXpath, id, 3), "xpath", getWebDriver());
      if (daysOfWeek.contains("thursday")) TestUtils.findElementAndClick(f(weekdaysXpath, id, 4), "xpath", getWebDriver());
      if (daysOfWeek.contains("friday")) TestUtils.findElementAndClick(f(weekdaysXpath, id, 5), "xpath", getWebDriver());
      if (daysOfWeek.contains("saturday")) TestUtils.findElementAndClick(f(weekdaysXpath, id, 6), "xpath", getWebDriver());
      if (daysOfWeek.contains("sunday")) TestUtils.findElementAndClick(f(weekdaysXpath, id, 7), "xpath", getWebDriver());
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

    public void fill(StationMovementSchedule stationMovementSchedule, String scheduleNo) {
      if(scheduleNo.equals("0")){
        Optional.ofNullable(stationMovementSchedule.getCrossdockHub()).ifPresent(value -> sendKeysAndEnterById(crossdockHub, value));
      }

      Optional.ofNullable(stationMovementSchedule.getOriginHub()).ifPresent(value -> sendKeysAndEnterById(f(scheduleOriginHubId, scheduleNo), value));

      Optional.ofNullable(stationMovementSchedule.getDestinationHub()).ifPresent(value -> sendKeysAndEnterById(f(scheduleDestinationHubId, scheduleNo), value));

      Optional.ofNullable(stationMovementSchedule.getMovementType()).ifPresent(value -> sendKeysAndEnterById(f(scheduleMovementTypeId, scheduleNo), value));

      if (StringUtils.isNotBlank(stationMovementSchedule.getDepartureTime())) {
        String[] hourtime = stationMovementSchedule.getDepartureTime().split(":");
        TestUtils.findElementAndClick(f(scheduleStartTimeId, scheduleNo), "id", getWebDriver());
        String hour = f(scheduleDepartureTimeXpath, 1, hourtime[0]);
        String time = f(scheduleDepartureTimeXpath, 2, hourtime[1]);
        moveToElementWithXpath(hour);
        TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
        moveToElementWithXpath(time);
        TestUtils.findElementAndClick(time, "xpath", getWebDriver());
        TestUtils.findElementAndClick("ant-picker-ok", "class", getWebDriver());
      }

      if (stationMovementSchedule.getDuration() != null) {
        TestUtils.findElementAndClick(f(scheduleDurationDayId, scheduleNo), "id", getWebDriver());
        TestUtils.findElementAndClick("//div[@title='"+stationMovementSchedule.getDuration()+"']", "xpath", getWebDriver());
      }

      if (StringUtils.isNotBlank(stationMovementSchedule.getEndTime())) {
        String[] hourtime = stationMovementSchedule.getEndTime().split(":");
        TestUtils.findElementAndClick(f(scheduleDurationTimeId, scheduleNo), "id", getWebDriver());
        String hour = f(scheduleDurationTimeXpath, 1, hourtime[0]);
        String time = f(scheduleDurationTimeXpath, 2, hourtime[1]);
        moveToElementWithXpath(hour);
        TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
        moveToElementWithXpath(time);
        TestUtils.findElementAndClick(time, "xpath", getWebDriver());
        TestUtils.findElementAndClick("//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//span[text()='Ok']", "xpath", getWebDriver());
      }

      if (CollectionUtils.isNotEmpty(stationMovementSchedule.getDaysOfWeek())) {
        setDaysOfWeek(stationMovementSchedule.getDaysOfWeek(), scheduleNo);
      }

      if (StringUtils.isNotBlank(stationMovementSchedule.getComment())) {
        WebElement element = getWebDriver().findElement(By.id(f(scheduleCommentId, scheduleNo)));
        element.sendKeys(stationMovementSchedule.getComment());
      }
    }

    public void fillAnother(StationMovementSchedule stationMovementSchedule, String scheduleNo) {
      Optional.ofNullable(stationMovementSchedule.getOriginHub()).ifPresent(value -> sendKeysAndEnterById(f(scheduleOriginHubId, scheduleNo), value));

      Optional.ofNullable(stationMovementSchedule.getDestinationHub()).ifPresent(value -> sendKeysAndEnterById(f(scheduleDestinationHubId, scheduleNo), value));

      Optional.ofNullable(stationMovementSchedule.getMovementType()).ifPresent(value -> sendKeysAndEnterById(f(scheduleMovementTypeId, scheduleNo), value));

      if (StringUtils.isNotBlank(stationMovementSchedule.getDepartureTime())) {
        String[] hourtime = stationMovementSchedule.getDepartureTime().split(":");
        TestUtils.findElementAndClick(f(scheduleStartTimeId, scheduleNo), "id", getWebDriver());
        String hour = f(scheduleDepartureTimeXpath, 1, hourtime[0]);
        String time = f(scheduleDepartureTimeXpath, 2, hourtime[1]);
        moveToElementWithXpath(hour);
        TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
        moveToElementWithXpath(time);
        TestUtils.findElementAndClick(time, "xpath", getWebDriver());
        TestUtils.findElementAndClick("//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//span[text()='Ok']", "xpath", getWebDriver());
      }

      if (stationMovementSchedule.getDuration() != null) {
        TestUtils.findElementAndClick(f(scheduleDurationDayId, scheduleNo), "id", getWebDriver());
        TestUtils.findElementAndClick("//div[contains(@class, 'ant-select-dropdown') and not(contains(@class , 'ant-select-dropdown-hidden'))]//div[@title='"+stationMovementSchedule.getDuration()+"']", "xpath", getWebDriver());
      }

      if (StringUtils.isNotBlank(stationMovementSchedule.getEndTime())) {
        String[] hourtime = stationMovementSchedule.getEndTime().split(":");
        TestUtils.findElementAndClick(f(scheduleDurationTimeId, scheduleNo), "id", getWebDriver());
        String hour = f(scheduleDurationTimeXpath, 1, hourtime[0]);
        String time = f(scheduleDurationTimeXpath, 2, hourtime[1]);
        moveToElementWithXpath(hour);
        TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
        moveToElementWithXpath(time);
        TestUtils.findElementAndClick(time, "xpath", getWebDriver());
        TestUtils.findElementAndClick("//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//span[text()='Ok']", "xpath", getWebDriver());
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

    @FindBy(className = "hubName")
    public PageElement sation;

    @FindBy(className = "crossdockHubName")
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

  public static class SchedulesTable extends AntTable<MovementSchedule.Schedule> {

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
    private static final String DAY_OF_WEEK_LOCATOR = ".//tbody/tr[%d]/td[contains(@class,'daysofweek')]//input[@value='%d']";
    public static final String COLUMN_ORIGIN_HUB = "originHub";
    public static final String COLUMN_DESTINATION_HUB = "destinationHub";
    public static final String COLUMN_DURATION = "durationDays";
    public static final String COLUMN_DURATION_TIME = "durationTime";
    public static final String COLUMN_DAYS_OF_WEEK = "daysOfWeek";

    public SchedulesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ORIGIN_HUB, "originHubName")
          .put(COLUMN_DESTINATION_HUB, "destinationHubName")
          .put("movementType", "movementType")
          .put("departureTime", "startTime")
          .put(COLUMN_DURATION, "duration")
          .put(COLUMN_DURATION_TIME, "duration")
          .put(COLUMN_DAYS_OF_WEEK, "daysofweek")
          .put("comment", "comment")
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
          }
      ));
      setColumnReaders(ImmutableMap.of(COLUMN_DAYS_OF_WEEK, this::getDaysOfWeek));
      setEntityClass(MovementSchedule.Schedule.class);
    }

    public String getDaysOfWeek(int rowNumber) {
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
  }

  public static class HubRelationSchedulesTable extends AntTable<HubRelationSchedule> {

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

    public HubRelationSchedulesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("originHubName", "originHubName")
          .put("destinationHubName", "destinationHubName")
          .put("movementType", "movementType")
          .put("startTime", "startTime")
          .put("duration", "duration")
          .put("comment", "comment")
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
          .put("originHub", "originHubName")
          .put("destinationHub", "destinationHubName")
          .put("movementType", "movementType")
          .put("departureTime", "startTime")
          .put("endTime", "duration")
          .put("comment", "comment")
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

  public static class UpdateSchedulesConfirmationModal extends AntModal {

    public UpdateSchedulesConfirmationModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//button[.='Update']")
    public Button update;
  }
}
