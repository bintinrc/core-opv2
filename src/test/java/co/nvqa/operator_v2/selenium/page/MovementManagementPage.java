package co.nvqa.operator_v2.selenium.page;

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
import com.google.common.collect.ImmutableMap;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
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

    @FindBy(css = "div.ant-modal")
    public EditStationRelationsModal editStationRelationsModal;

    @FindBy(id = "originHubId")
    public AntSelect originCrossdockHub;

    @FindBy(id = "destinationHubId")
    public AntSelect destinationCrossdockHub;

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

    @FindBy(xpath = "//label[.='Relations']")
    public PageElement relationsTab;

    @FindBy(xpath = "//label[starts-with(.,'Pending')]")
    public PageElement pendingTab;

    @FindBy(xpath = "//th[contains(.,'Station')]//input")
    public TextBox stationFilter;

    //region Stations tab
    @FindBy(xpath = "//label[starts-with(.,'Stations')]")
    public PageElement stationsTab;

    @FindBy(xpath = "//button[.='Add Schedule']")
    public Button addSchedule;

    @FindBy(css = "div.ant-modal")
    public AddStationMovementScheduleModal addStationMovementScheduleModal;

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

    public void loadSchedules(String originHub, String destinationHub)
    {
        if (editFilters.isDisplayedFast())
        {
            editFilters.click();
        }

        if (StringUtils.isNotBlank(originHub))
        {
            originCrossdockHub.selectValue(originHub);
        }

        if (StringUtils.isNotBlank(destinationHub))
        {
            destinationCrossdockHub.selectValue(destinationHub);
        }

        loadSchedules.click();
        originCrossdockHubFilter.waitUntilClickable();
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

    public static class ScheduleRow extends NvTable.NvRow
    {
        public ScheduleRow(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        public ScheduleRow(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
        {
            super(webDriver, searchContext, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(className = "originHubName")
        public PageElement originHubName;

        @FindBy(className = "destinationHubName")
        public PageElement destinationHubName;
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
        public PageElement editRelation;
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
    }

}
