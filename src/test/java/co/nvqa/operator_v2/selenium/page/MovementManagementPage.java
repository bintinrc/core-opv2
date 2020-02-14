package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

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

    public MovementManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
    }

    public void switchTo(){
        getWebDriver().switchTo().frame(pageFrame.getWebElement());
    }

    public static class AddMovementScheduleDialog extends AntModal {
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

    }

}
