package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class NvApiTextButton extends PageElement
{
    public NvApiTextButton(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public NvApiTextButton(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(tagName = "button")
    private Button button;

    @FindBy(css = "md-progress-circular")
    private PageElement spinner;

    public void click()
    {
        button.scrollIntoView();
        button.click();
    }

    public void waitUntilDone()
    {
        spinner.waitUntilInvisible();
    }

    public void clickAndWaitUntilDone()
    {
        click();
        waitUntilDone();
    }

    public boolean isDisabled()
    {
        return StringUtils.equalsIgnoreCase(getAttribute("disabled"), "disabled");
    }
}