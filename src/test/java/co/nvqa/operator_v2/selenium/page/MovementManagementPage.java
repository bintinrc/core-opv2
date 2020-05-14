package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.MovementSchedule;
import co.nvqa.operator_v2.model.StationMovementSchedule;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntCheckbox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextWithLabel;
import co.nvqa.operator_v2.selenium.elements.ant.AntTimePicker;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.List;
import java.util.Optional;

import static org.apache.commons.lang3.StringUtils.isNotBlank;

/**
 * @author Sergey Mishanin
 */
public class MovementManagementPage extends OperatorV2SimplePage
{
    @FindBy(xpath = "//button[.='New Crossdock Movement Schedule']")
    public Button newCrossdockMovementSchedule;

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

    @FindBy(xpath = "//div[contains(@class,'CrossdockMovementTableContainer')]//table")
    public NvTable<ScheduleRow> schedulesTable;

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


    public MovementManagementPage(WebDriver webDriver)
    {
        super(webDriver);
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

        @FindBy(id = "originHubId")
        public AntSelect originCrossdockHub;

        @FindBy(id = "destinationHubId")
        public AntSelect destinationCrossdockHub;

        @FindBy(xpath = "//label[.='Apply to all days']/span[@class='ant-checkbox']")
        public AntCheckbox applyToAllDays;

        @FindBy(xpath = ".//button[.='Save Schedule']")
        public Button saveSchedule;

        @FindBy(xpath = ".//button[.='Cancel']")
        public Button cancel;

        public void fill(MovementSchedule movementSchedule)
        {
            if (isNotBlank(movementSchedule.getOriginHub()))
            {
                originCrossdockHub.selectValue(movementSchedule.getOriginHub());
            }

            if (isNotBlank(movementSchedule.getDestinationHub()))
            {
                destinationCrossdockHub.selectValue(movementSchedule.getDestinationHub());
            }

            applyToAllDays.setValue(movementSchedule.isApplyToAllDays());

            if (CollectionUtils.isNotEmpty(movementSchedule.getSchedules()))
            {
                movementSchedule.getSchedules().forEach(schedule ->
                {
                    ScheduleForm form = getScheduleFormForDay(schedule.getDay());
                    form.fill(schedule);
                });
            }
        }

        public ScheduleForm getScheduleFormForDay(String day)
        {
            WebElement webElement = findElementByXpath(f("//div[contains(@class,'DailyMovementContainer')][.//span[.='%s']]", day));
            return new ScheduleForm(getWebDriver(), getWebElement(), webElement);
        }

        public static class ScheduleForm extends PageElement
        {
            public ScheduleForm(WebDriver webDriver, WebElement webElement)
            {
                super(webDriver, webElement);
                PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
            }

            public ScheduleForm(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
            {
                super(webDriver, searchContext, webElement);
                PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
            }

            @FindBy(xpath = ".//button[.='Add a Movement']")
            public Button addAMovement;

            @FindBy(xpath = ".//button[.='Add Another Movement']")
            public Button addAnotherMovement;

            @FindBy(xpath = "(.//span[@class='ant-time-picker'])[1]")
            public AntTimePicker startTime;

            @FindBy(css = "input[id*='dayDuration']")
            public TextBox duration;

            @FindBy(xpath = "(.//span[@class='ant-time-picker'])[2]")
            public AntTimePicker endTime;

            @FindBy(css = "div[class*='ScheduleMovementContainer']")
            public List<MovementForm> movementForms;

            public void fill(MovementSchedule.Schedule schedule)
            {
                for (int i = 0; i < schedule.getMovements().size(); i++)
                {
                    if (i == 0)
                    {
                        addAMovement.click();
                    } else
                    {
                        addAnotherMovement.click();
                    }
                    MovementSchedule.Schedule.Movement movement = schedule.getMovement(i);
                    movementForms.get(i).fill(movement);
                }
            }

            public static class MovementForm extends PageElement
            {
                public MovementForm(WebDriver webDriver, WebElement webElement)
                {
                    super(webDriver, webElement);
                    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
                }

                public MovementForm(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
                {
                    super(webDriver, searchContext, webElement);
                    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
                }

                @FindBy(xpath = "(.//span[@class='ant-time-picker'])[1]")
                public AntTimePicker startTime;

                @FindBy(css = "input[id*='dayDuration']")
                public TextBox duration;

                @FindBy(xpath = "(.//span[@class='ant-time-picker'])[2]")
                public AntTimePicker endTime;

                public void fill(MovementSchedule.Schedule.Movement movement)
                {
                    if (isNotBlank(movement.getStartTime()))
                    {
                        startTime.setValue(movement.getStartTime());
                    }
                    if (movement.getDuration() != null)
                    {
                        duration.setValue(String.valueOf(movement.getDuration()));
                    }
                    if (isNotBlank(movement.getEndTime()))
                    {
                        endTime.setValue(movement.getEndTime());
                    }
                }
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

}
