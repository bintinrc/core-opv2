package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import javax.xml.soap.Text;

public class ToastError extends PageElement
{
    @FindBy(css = "div.toast-bottom")
    public Text toastBottom;

    public ToastError(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
    }


}
