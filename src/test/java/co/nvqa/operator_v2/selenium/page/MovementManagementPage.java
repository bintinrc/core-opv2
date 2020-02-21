package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.MovementSchedule;
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

    @FindBy(xpath = "(//th//input)[1]")
    public TextBox originCrossdockHubFilter;

    @FindBy(xpath = "(//th//input)[2]")
    public TextBox destinationCrossdockHubFilter;

    @FindBy(xpath = "//div[@class='ant-popover-buttons']//button[.='Delete']")
    public Button popoverDeleteButton;

    public MovementManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
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

    public static class AddMovementScheduleModal extends AntModal
    {
        public AddMovementScheduleModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        public AddMovementScheduleModal(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
        {
            super(webDriver, searchContext, webElement);
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
