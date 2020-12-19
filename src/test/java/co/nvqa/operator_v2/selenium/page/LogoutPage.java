package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

/**
 * @author Soewandi Wirjawan
 */
public class LogoutPage extends OperatorV2SimplePage {

  public LogoutPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void logout() {
    WebElement elm = getWebDriver()
        .findElement(By.xpath("//span[(contains(@class, 'nv-text-ellipsis nv-p-med name'))]"));

    Actions acts = new Actions(getWebDriver());
    acts.moveToElement(elm).click().perform();
    pause1s();

    elm = getWebDriver().findElement(By.xpath(
        "//button[@class='nv-button flat alternate md-button md-ink-ripple'][@ng-click='logout()']"));
    acts.moveToElement(elm).click().perform();
  }
}
