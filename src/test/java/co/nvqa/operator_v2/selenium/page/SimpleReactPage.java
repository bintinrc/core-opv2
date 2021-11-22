package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import java.util.List;
import java.util.function.Consumer;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class SimpleReactPage<T extends SimpleReactPage> extends OperatorV2SimplePage {

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(css = ".ant-notification-notice")
  public List<AntNotification> noticeNotifications;

  public SimpleReactPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void waitUntilLoaded() {
    waitUntilLoaded(10);
  }

  public void waitUntilLoaded(int timeoutInSeconds) {
    if (spinner.waitUntilVisible(timeoutInSeconds)) {
      spinner.waitUntilInvisible();
    }
  }

  public void waitUntilVisibilityOfNotification(String message) {
    waitUntilVisibilityOfNotification(message, 20000);
  }

  public void waitUntilVisibilityOfNotification(String message, int timeoutInMillis) {
    waitUntil(() ->
            noticeNotifications.stream().anyMatch(notification ->
                StringUtils.equalsIgnoreCase(notification.message.getText(), message))
        , timeoutInMillis);
  }

  @SuppressWarnings("unchecked")
  public void inFrame(Consumer<T> consumer) {
    getWebDriver().switchTo().defaultContent();
    pageFrame.waitUntilVisible();
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
    try {
      consumer.accept((T) this);
    } finally {
      getWebDriver().switchTo().defaultContent();
    }
  }

  public void inFrame(Runnable consumer) {
    getWebDriver().switchTo().defaultContent();
    pageFrame.waitUntilVisible();
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
    try {
      consumer.run();
    } finally {
      getWebDriver().switchTo().defaultContent();
    }
  }

  public void dragAndDrop(WebElement from, WebElement to) {
    Actions actions = new Actions(getWebDriver());
    actions
        .clickAndHold(from)
        .moveByOffset(-10,
            0) //need a slight movement to trigger a drag event before you try to move to your actual destination
        .moveToElement(to)
        .release()
        .perform();
    pause100ms();
  }

}
