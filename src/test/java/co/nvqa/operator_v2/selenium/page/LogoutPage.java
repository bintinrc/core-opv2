package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

/**
 *
 * @author Soewandi Wirjawan
 */
public class LogoutPage extends SimplePage
{
    public LogoutPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void logout()
    {
        WebElement elm = getwebDriver().findElement(By.xpath("//span[(contains(@class, 'nv-text-ellipsis nv-p-med name'))]"));

        Actions acts = new Actions(getwebDriver());
        acts.moveToElement(elm).click().perform();
        pause1s();

        elm = getwebDriver().findElement(By.xpath("//button[@class='nv-button flat alternate md-button md-ink-ripple'][@ng-click='logout()']"));
        acts.moveToElement(elm).click().perform();
    }
}
