package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvAllure;
import co.nvqa.operator_v2.exception.NvTestCoreNotificationNotVisibleError;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.akira.AkiraNotification;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Function;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchWindowException;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SimpleAkiraPage<T extends SimpleAkiraPage> extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(SimpleAkiraPage.class);

  @FindBy(tagName = "iframe")
  protected PageElement pageFrame;

  @FindBy(css = ".[role='progressbar']")
  public PageElement spinner;

  @FindBy(xpath = "//div[contains(@class,'inline-block') and contains(@class,'break-words')]")
  public List<AkiraNotification> noticeNotifications;

  public SimpleAkiraPage(WebDriver webDriver) {
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

  public void waitUntilLoaded(int timeoutInSeconds, int waitTimeoutInSeconds) {
    if (spinner.waitUntilVisible(timeoutInSeconds)) {
      spinner.waitUntilInvisible(waitTimeoutInSeconds);
    }
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

  public void clickButtonByText(String name) {
    doWithRetry(() -> {
      String xpathExpression = f("//span[text()='%s']/parent::button", name);
      waitUntilVisibilityOfElementLocated(xpathExpression);
      simpleClick(xpathExpression);
    }, "Wait until page is properly loaded...", 1000, 3);
  }

  public void clickButtonByTextAndWaitUntilDone(String name) {
    String xpathExpression = f("//span[text()='%s']/parent::button", name);
    simpleClick(xpathExpression);
    waitUntilInvisibilityOfElementLocated(
        xpathExpression + "/div[contains(@class,'show')]/md-progress-circular");
  }

  public void deleteText(String xpathExpression) {
    WebElement we = findElementByXpath(xpathExpression);
    if (System.getProperty("os.name").toLowerCase().contains("mac")) {
      we.sendKeys(Keys.COMMAND + "a" + Keys.DELETE);
    } else {
      we.sendKeys(Keys.CONTROL + "a" + Keys.DELETE);
    }
    pause100ms();
  }

  public void clickTabItem(String tabItemText) {
    String xpathExpression = f("//div[@role='tab' and contains(text(), '%s')]", tabItemText);
    waitUntilVisibilityOfElementLocated(xpathExpression);
    simpleClick(xpathExpression);
  }

  public boolean isTableEmpty(String tableXpath) {
    String xpath = tableXpath + "//*[text()='No Data']";
    try {
      return isElementVisible(xpath, FAST_WAIT_IN_SECONDS);
    } catch (TimeoutException ex) {
      LOGGER.warn("Table is not empty. XPath: {}", xpath);
      NvAllure.addWarnAttachment(getCurrentMethodName(), "Table is not empty. XPath: %s", xpath);
      return false;
    }
  }

  public String getToastDescription() {
    return getToastText(
        "//div[@id='toast-container']/div/div/div/div[contains(@class,'inline-block')]//div[2]");
  }

  public String getToastText(String toastXpathExpression) {
    String text = null;

    try {
      WebElement webElement = waitUntilVisibilityOfElementLocated(toastXpathExpression);
      text = webElement.getText();
    } catch (RuntimeException ex) {
      LOGGER.warn("Failed to get text from element Toast. XPath: %s", toastXpathExpression);
      NvAllure.addWarnAttachment(getCurrentMethodName(),
          "Failed to get text from element Toast. XPath: %s", toastXpathExpression);
      throw new NvTestCoreNotificationNotVisibleError(ex.getMessage());
    }

    return text;
  }
}

