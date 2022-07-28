package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.elements.mm.AntNotice;
import java.time.Duration;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Function;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.NoSuchWindowException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;

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

  @FindBy(css = ".ant-message-notice")
  public List<AntNotice> notices;

  public SimpleReactPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void waitUntilLoaded() {
    waitUntilLoaded(10);
  }

  public String waitAndGetNoticeText(String message) {
    return waitAndGetNoticeText(message, false);
  }

  public String waitAndGetNoticeText(String message, boolean waitUntilInvisible) {
    Wait<List<AntNotice>> fWait = new FluentWait<>(notices)
        .withTimeout(Duration.ofSeconds(15))
        .pollingEvery(Duration.ofMillis(100))
        .withMessage("Notice with [" + message + "] text was not found")
        .ignoring(NoSuchElementException.class);
    String result = fWait.until(notices -> notices.stream()
        .map(AntNotice::getNoticeMessage)
        .filter(noticeMessage -> noticeMessage.matches(message))
        .findFirst()
        .orElse(null));
    if (waitUntilInvisible) {
      try {
        setImplicitTimeout(0);
        fWait.until(notices -> notices.size() == 0);
      } finally {
        resetImplicitTimeout();
      }
    }
    return result;
  }

  public void waitUntilLoaded(int timeoutInSeconds) {
    if (spinner.waitUntilVisible(timeoutInSeconds)) {
      spinner.waitUntilInvisible();
    }
  }

  public void waitUntilLoaded(int timeoutInSeconds, int waitTimeoutInSeconds) {
    if (spinner.waitUntilVisible(timeoutInSeconds)) {
      spinner.waitUntilInvisible(waitTimeoutInSeconds);
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
    } catch (NoSuchWindowException ex) {
      waitUntilLoaded();
      consumer.accept((T) this);
    } finally {
      getWebDriver().switchTo().defaultContent();
    }
  }

  @SuppressWarnings("unchecked")
  public <R> R returnFromFrame(Function<T, R> consumer) {
    getWebDriver().switchTo().defaultContent();
    pageFrame.waitUntilVisible();
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
    try {
      return consumer.apply((T) this);
    } catch (NoSuchWindowException ex) {
      waitUntilLoaded();
      return consumer.apply((T) this);
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
    } catch (NoSuchWindowException ex) {
      waitUntilLoaded();
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
