package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.MovementSchedule;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntCheckbox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntTimePicker;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

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
    public AddMovementScheduleDialog addMovementScheduleDialog;

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
        if (editFilters.isDisplayedFast()){
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
    }

    public static class AddMovementScheduleDialog extends AntModal
    {
        public AddMovementScheduleDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        public AddMovementScheduleDialog(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
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
                    MovementForm form = getMovementFormForDay(schedule.getDay());
                    form.addAMovement.click();
                    form.fill(schedule);
                });
            }
        }

        public MovementForm getMovementFormForDay(String day)
        {
            WebElement webElement = findElementByXpath(f("//div[contains(@class,'DailyMovementContainer')][.//span[.='%s']]", day));
            return new MovementForm(getWebDriver(), getWebElement(), webElement);
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

            @FindBy(xpath = ".//button[.='Add a Movement']")
            public Button addAMovement;

            @FindBy(xpath = "(.//span[@class='ant-time-picker'])[1]")
            public AntTimePicker startTime;

            @FindBy(css = "input[id*='dayDuration']")
            public TextBox duration;

            @FindBy(xpath = "(.//span[@class='ant-time-picker'])[2]")
            public AntTimePicker endTime;

            public void fill(MovementSchedule.Schedule schedule)
            {
                if (isNotBlank(schedule.getStartTime()))
                {
                    startTime.setValue(schedule.getStartTime());
                }
                if (schedule.getDuration() != null)
                {
                    duration.setValue(String.valueOf(schedule.getDuration()));
                }
                if (isNotBlank(schedule.getEndTime()))
                {
                    endTime.setValue(schedule.getEndTime());
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

}
