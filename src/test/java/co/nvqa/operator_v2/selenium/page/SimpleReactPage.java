package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvAllure;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.elements.mm.AntNotice;
import java.time.Duration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;
import java.util.function.Function;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.NoSuchWindowException;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Sergey Mishanin
 */
public class SimpleReactPage<T extends SimpleReactPage> extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(SimpleReactPage.class);

  @FindBy(tagName = "iframe")
  protected PageElement pageFrame;

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

  public void clickButtonByText(String name) {
    String xpathExpression = f("//span[text()='%s']/parent::button", name);
    waitUntilVisibilityOfElementLocated(xpathExpression);
    simpleClick(xpathExpression);
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

  public void waitUntilVisibilityOfToast(String containsMessage) {
    waitUntilVisibilityOfElementLocated(
        f("//div[@class='ant-notification ant-notification-topRight']//div[contains(text(), '%s')]",
            containsMessage));
  }

  public Map<String, String> waitUntilVisibilityAndGetErrorToastData() {
    Map<String, String> toastData = new HashMap<>();
    waitUntilVisibilityOfElementLocated("//div[contains(@class,'ant-notification-notice-')]");
    if (getElementsCount("//div[@class='ant-notification-notice-description']/div") == 0) {
      toastData.put("errorMessage",
          StringUtils.trim(getText("//div[@class='ant-notification-notice-message']")));
      return toastData;
    }
    String xpath = "//div[@class='ant-notification-notice-description']/div";

    String childXpath = xpath + "/div[1]";
    if (isElementExistFast(childXpath)) {
      toastData.put("status", StringUtils.trim(getText(childXpath)));
    }
    childXpath = xpath + "/div[2]";
    if (isElementExistFast(childXpath)) {
      toastData.put("url", StringUtils.trim(getText(childXpath)));
    }
    childXpath = xpath + "/div[3]";
    if (isElementExistFast(childXpath)) {
      toastData.put("errorCode", StringUtils.trim(getText(childXpath)));
    }
    childXpath = xpath + "/div[4]";
    if (isElementExistFast(childXpath)) {
      toastData.put("errorMessage", StringUtils.trim(getText(childXpath)));
    }

    return toastData;
  }

  public void waitUntilInvisibilityOfToast(String containsMessage,
      boolean waitUntilElementVisibleFirst) {
    String xpathExpression = StringUtils.isNotBlank(containsMessage) ? f(
        "//div[@class='ant-notification ant-notification-topRight']//div[contains(text(), '%s')]",
        containsMessage) : "//div[@class='ant-notification ant-notification-topRight']";

    if (waitUntilElementVisibleFirst) {
      waitUntilVisibilityOfElementLocated(xpathExpression);
    }

    waitUntilInvisibilityOfElementLocated(xpathExpression);
  }

  public void waitUntilInvisibilityOfNotification(String containsMessage,
      boolean waitUntilElementVisibleFirst) {
    String xpathExpression = StringUtils.isNotBlank(containsMessage) ? f(
        "//div[contains(@class,'ant-notification')]//div[@class='ant-notification-notice-message'][contains(text(),'%s')]",
        containsMessage) : "//div[contains(@class,'ant-notification')]";

    if (waitUntilElementVisibleFirst) {
      waitUntilVisibilityOfElementLocated(xpathExpression);
    }
    if (isElementExistFast(xpathExpression)) {
      waitUntilElementIsClickable(
          "//div[contains(@class,'ant-notification')]//a[@class='ant-notification-notice-close']");
      click(
          "//div[contains(@class,'ant-notification')]//a[@class='ant-notification-notice-close']");
    }
    waitUntilInvisibilityOfElementLocated(xpathExpression);
  }

  public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass,
      String mdVirtualRepeat, XpathTextMode xpathTextMode, String nvTableParam) {
    String text = null;
    String nvTableXpathExpression = "";

    try {
      if (!isBlank(nvTableParam)) {
        nvTableXpathExpression = f(
            "//div[@role='tabpanel' and @aria-hidden='false' and contains(@id,'%s')]//div[contains(@class,'table-main')]/div[@class='BaseTable__body']",
            nvTableParam);
      }

      WebElement we = findElementByXpath(
          f("%s//div[@role='row' and @class='BaseTable__row'][%d]/div[@role='gridcell'][%s]",
              nvTableXpathExpression, rowNumber, columnDataClass));
      text = we.getText().trim();
    } catch (NoSuchElementException ex) {
      LOGGER.warn("Failed to find element by XPath. XPath: {}", nvTableXpathExpression);
      NvAllure.addWarnAttachment(getCurrentMethodName(),
          "Failed to find element by XPath. XPath: %s", nvTableXpathExpression);
    }

    return text;
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonXpath) {
    try {
      String actionButtonXpathXpression = f("//button[contains(@data-testid,'%s')]",
          actionButtonXpath);
      String xpathExpression = f("//div[@aria-hidden='false']//div[@role='row'][%d]%s", rowNumber,
          actionButtonXpathXpression);

      simpleClick(xpathExpression);
    } catch (NoSuchElementException ex) {
      throw new RuntimeException(f("Cannot find action button '%s' on table.", actionButtonXpath),
          ex);
    }
  }

  public void selectValueFromMdSelectById(String mdSelectId, String value) {
    scrollIntoView(f("//div[@name='%s']//input", mdSelectId));
    clickf("//div[@name='%s']//input", mdSelectId);
    pause1s();
    clickf("//div[text()='%s' and contains(@class,'option')]", value);
    pause50ms();
  }

  public void selectValueFromMdSelectByName(String mdSelectId, String value) {
    scrollIntoView(f("//div[@name='%s']//input", mdSelectId));
    clickf("//div[@name='%s']//input", mdSelectId);
    pause1s();
    clickf("//div[text()='%s' and contains(@class,'option')]", value);
    pause50ms();
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

  public void operatorClickMaskingText(List<WebElement> masking) {
    masking.forEach(m -> {
      try {
        m.click();
      } catch (Exception ex) {
        LOGGER.debug("mask element not found");
      }
    });
  }
}
