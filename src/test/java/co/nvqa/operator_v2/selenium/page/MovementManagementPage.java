package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.MovementSchedule;
import co.nvqa.operator_v2.model.StationMovementSchedule;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.*;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.LinkedHashSet;
import java.util.Optional;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Sergey Mishanin
 */
public class MovementManagementPage extends OperatorV2SimplePage
{
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

    @FindBy(xpath = "//div[contains(@class,'StationMovementTableContainer')]//table")
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

    @FindBy(xpath = "//label[starts-with(.,'Completed')]")
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

    @FindBy(xpath = "//button[.='Modify']")
    public Button modify;

    @FindBy(xpath = "//button[.='Save']")
    public Button save;

    @FindBy(css = "div.ant-modal")
    public AddStationMovementScheduleModal addStationMovementScheduleModal;

    @FindBy(xpath = "//td//i")
    public PageElement assignDriverButton;

    @FindBy(className = "ant-modal-wrap")
    public AssignDriverModal assignDriverModal;

    @FindBy(xpath = "//div[@class='ant-notification-notice-message' and .='Relation created']")
    public PageElement successCreateRelation;

    //endregion

    public SchedulesTable schedulesTable;

    public MovementManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        schedulesTable = new SchedulesTable(webDriver);
    }

    public void switchTo()
    {
        getWebDriver().switchTo().frame(pageFrame.getWebElement());
    }

    public void loadSchedules(String crossdockHub, String originHub, String destinationHub)
    {
        if (editFilters.isDisplayedFast())
        {
            editFilters.click();
        }

        if (StringUtils.isNotBlank(crossdockHub))
        {
            this.crossdockHub.selectValue(crossdockHub);
            pause2s();

            if (StringUtils.isNotBlank(originHub))
            {
                originStationHub.selectValue(originHub);
            }

            if (StringUtils.isNotBlank(destinationHub))
            {
                destinationStationHub.selectValue(destinationHub);
            }
        } else
        {
            if (StringUtils.isNotBlank(originHub))
            {
                originCrossdockHub.selectValue(originHub);
            }

            if (StringUtils.isNotBlank(destinationHub))
            {
                destinationCrossdockHub.selectValue(destinationHub);
            }
        }

        loadSchedules.click();
        originCrossdockHubFilter.waitUntilClickable();
    }

    public void assignDriver(String driverUsername)
    {
        assignDriverButton.click();
        assignDriverModal.waitUntilVisible();
        assignDriverModal.driverSelect.enterSearchTerm(driverUsername);
        assignDriverModal.driverSelect.sendReturnButton();
        assignDriverModal.save.click();
        assignDriverModal.waitUntilInvisible();
    }

    public static class AssignDriverModal extends AntModal
    {
        public AssignDriverModal(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(xpath = ".//div[contains(@class,'ant-select')]")
        public AntSelect driverSelect;

        @FindBy(xpath = "//button[.='Save Driver']")
        public Button save;

        @FindBy(xpath = "//button[.='Cancel']")
        public Button cancel;
    }

    public static class EditStationRelationsModal extends AntModal
    {
        public EditStationRelationsModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(id = "crossdockHubId")
        public AntSelect crossdockHub;

        @FindBy(xpath = "//button[.='Save']")
        public Button save;
    }

    public static class AddMovementScheduleModal extends AntModal
    {
        public AddMovementScheduleModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(xpath = ".//button[.='Add Another Schedule']")
        public Button addAnotherSchedule;

        @FindBy(xpath = ".//button[.='Create']")
        public Button create;

        @FindBy(css = "div.has-error")
        public PageElement errorMessage;

        @FindBy(xpath = ".//button[.='Cancel']")
        public Button cancel;

        public void fill(MovementSchedule schedule)
        {
            for (int i = 1; i <= schedule.getSchedules().size(); i++)
            {
                ScheduleForm scheduleForm = getScheduleForm(i);
                scheduleForm.fill(schedule.getSchedules().get(i - 1));
                if (i < schedule.getSchedules().size())
                {
                    addAnotherSchedule.click();
                }
            }
        }

        public ScheduleForm getScheduleForm(int index)
        {
            WebElement webElement = findElementByXpath(f(".//div[contains(@class,'ant-divider')][%d]", index));
            return new ScheduleForm(getWebDriver(), getWebElement(), webElement);
        }

        public static class ScheduleForm extends PageElement
        {
            public ScheduleForm(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
            {
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

            @FindBy(xpath = "./following-sibling::div//input[@type='checkbox'][@value='1']")
            public CheckBox monday;

            @FindBy(xpath = "./following-sibling::div//input[@type='checkbox'][@value='2']")
            public CheckBox tuesday;

            @FindBy(xpath = "./following-sibling::div//input[@type='checkbox'][@value='3']")
            public CheckBox wednesday;

            @FindBy(xpath = "./following-sibling::div//input[@type='checkbox'][@value='4']")
            public CheckBox thursday;

            @FindBy(xpath = "./following-sibling::div//input[@type='checkbox'][@value='5']")
            public CheckBox friday;

            @FindBy(xpath = "./following-sibling::div//input[@type='checkbox'][@value='6']")
            public CheckBox saturday;

            @FindBy(xpath = "./following-sibling::div//input[@type='checkbox'][@value='7']")
            public CheckBox sunday;

            @FindBy(xpath = "./following-sibling::div//textarea[contains(@id,'comment')]")
            public TextBox comment;

            public void fill(MovementSchedule.Schedule schedule)
            {
                if (StringUtils.isNotBlank(schedule.getOriginHub()))
                {
                    originHub.selectValue(schedule.getOriginHub());
                }
                if (StringUtils.isNotBlank(schedule.getDestinationHub()))
                {
                    destinationHub.selectValue(schedule.getDestinationHub());
                }
                if (StringUtils.isNotBlank(schedule.getMovementType()))
                {
                    movementType.selectValue(schedule.getMovementType());
                }
                if (StringUtils.isNotBlank(schedule.getDepartureTime()))
                {
                    departureTime.setValue(schedule.getDepartureTime());
                }
                if (schedule.getDurationDays() != null)
                {
                    durationDays.setValue(schedule.getDurationDays());
                }
                if (StringUtils.isNotBlank(schedule.getDurationTime()))
                {
                    durationTime.setValue(schedule.getDurationTime());
                }
                if (CollectionUtils.isNotEmpty(schedule.getDaysOfWeek()))
                {
                    setDaysOfWeek(schedule.getDaysOfWeek());
                }
                if (StringUtils.isNotBlank(schedule.getComment()))
                {
                    comment.setValue(schedule.getComment());
                }
            }

            public void setDaysOfWeek(Set<String> daysOfWeek)
            {
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

    public static class AddStationMovementScheduleModal extends AntModal
    {
        public AddStationMovementScheduleModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(id = "crossdock_id")
        public AntSelect crossdockHub;

        @FindBy(css = "[id*='origin_hub_id']")
        public AntSelect originHub;

        @FindBy(css = "[id*='destination_hub_id']")
        public AntSelect destinationHub;

        @FindBy(css = "[id*='movement_type']")
        public AntSelect movementType;

        @FindBy(xpath = "(.//span[@class='ant-time-picker'])[1]")
        public AntTimePicker departureTime;

        @FindBy(css = "input[id*='duration_day']")
        public TextBox duration;

        @FindBy(xpath = "(.//span[@class='ant-time-picker'])[2]")
        public AntTimePicker endTime;

        @FindBy(css = "input[id*='comment']")
        public TextBox comment;

        @FindBy(xpath = ".//button[.='Create']")
        public Button create;

        @FindBy(xpath = ".//button[.='Cancel']")
        public Button cancel;

        public void fill(StationMovementSchedule stationMovementSchedule)
        {
            Optional.ofNullable(stationMovementSchedule.getCrossdockHub())
                    .ifPresent(value -> crossdockHub.selectValue(value));
            Optional.ofNullable(stationMovementSchedule.getOriginHub())
                    .ifPresent(value -> originHub.selectValue(value));
            Optional.ofNullable(stationMovementSchedule.getDestinationHub())
                    .ifPresent(value -> destinationHub.selectValue(value));
            Optional.ofNullable(stationMovementSchedule.getMovementType())
                    .ifPresent(value -> movementType.selectValue(value));
            Optional.ofNullable(stationMovementSchedule.getDepartureTime())
                    .ifPresent(value -> departureTime.setValue(value));
            Optional.ofNullable(stationMovementSchedule.getDuration())
                    .ifPresent(value -> duration.setValue(value));
            Optional.ofNullable(stationMovementSchedule.getEndTime())
                    .ifPresent(value -> endTime.setValue(value));
            Optional.ofNullable(stationMovementSchedule.getComment())
                    .ifPresent(value -> comment.setValue(value));
        }
    }

    public static class RelationRow extends NvTable.NvRow
    {
        public RelationRow(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        public RelationRow(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
        {
            super(webDriver, searchContext, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(className = "hubName")
        public PageElement sation;

        @FindBy(className = "crossdockHubName")
        public PageElement crossdock;

        @FindBy(css = "td.actions a")
        public PageElement editRelations;
    }

    public static class MovementScheduleModal extends AntModal
    {
        public MovementScheduleModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        public MovementScheduleModal(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
        {
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

    public static class SchedulesTable extends AntTable<MovementSchedule.Schedule>
    {
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

        private static final Pattern DURATION_PATTERN = Pattern.compile("(\\d{2})d\\s(\\d{2})h\\s(\\d{2})m");
        private static final String DAY_OF_WEEK_LOCATOR = ".//tbody/tr[%d]/td[contains(@class,'daysofweek')]//input[@value='%d']";
        public static final String COLUMN_ORIGIN_HUB = "originHub";
        public static final String COLUMN_DESTINATION_HUB = "destinationHub";
        public static final String COLUMN_DURATION = "durationDays";
        public static final String COLUMN_DURATION_TIME = "durationTime";
        public static final String COLUMN_DAYS_OF_WEEK = "daysOfWeek";

        public SchedulesTable(WebDriver webDriver)
        {
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

        public String getDaysOfWeek(int rowNumber)
        {
            WebElement checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 1));
            Set<String> days = new LinkedHashSet<>();
            if (checkbox.isSelected())
            {
                days.add("monday");
            }
            checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 2));
            if (checkbox.isSelected())
            {
                days.add("tuesday");
            }
            checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 3));
            if (checkbox.isSelected())
            {
                days.add("wednesday");
            }
            checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 4));
            if (checkbox.isSelected())
            {
                days.add("thursday");
            }
            checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 5));
            if (checkbox.isSelected())
            {
                days.add("friday");
            }
            checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 6));
            if (checkbox.isSelected())
            {
                days.add("saturday");
            }
            checkbox = findElementByXpath(f(DAY_OF_WEEK_LOCATOR, rowNumber, 7));
            if (checkbox.isSelected())
            {
                days.add("sunday");
            }
            return String.join(",", days);
        }

        public void editSchedule(MovementSchedule.Schedule schedule)
        {
            if (StringUtils.isNotBlank(schedule.getDepartureTime()))
            {
                departureTime.setValue(schedule.getDepartureTime());
            }
            if (schedule.getDurationDays() != null)
            {
                durationDays.sendKeys(Keys.BACK_SPACE + String.valueOf(schedule.getDurationDays()));
            }
            if (StringUtils.isNotBlank(schedule.getDurationTime()))
            {
                durationTime.setValue(schedule.getDurationTime());
            }
            if (CollectionUtils.isNotEmpty(schedule.getDaysOfWeek()))
            {
                setDaysOfWeek(schedule.getDaysOfWeek());
            }
            if (StringUtils.isNotBlank(schedule.getComment()))
            {
                comment.setValue(schedule.getComment());
            }
        }

        public void setDaysOfWeek(Set<String> daysOfWeek)
        {
            monday.setValue(daysOfWeek.contains("monday"));
            tuesday.setValue(daysOfWeek.contains("tuesday"));
            wednesday.setValue(daysOfWeek.contains("wednesday"));
            thursday.setValue(daysOfWeek.contains("thursday"));
            friday.setValue(daysOfWeek.contains("friday"));
            saturday.setValue(daysOfWeek.contains("saturday"));
            sunday.setValue(daysOfWeek.contains("sunday"));
        }
    }

    public static class UpdateSchedulesConfirmationModal extends AntModal
    {
        public UpdateSchedulesConfirmationModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(xpath = "//button[.='Update']")
        public Button update;
    }
}
