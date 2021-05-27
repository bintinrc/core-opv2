package co.nvqa.operator_v2.selenium.elements;

import co.nvqa.common_selenium.page.SimplePage;
import java.util.Arrays;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.ElementClickInterceptedException;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.PageFactory;

public class PageElement extends SimplePage {

  protected WebElement webElement;

  public PageElement(PageElement parent, String xpath) {
    this(parent.webDriver, parent.webElement,
        parent.findElementBy(By.xpath(xpath), parent.webElement));
  }

  public PageElement(WebDriver webDriver, String xpath) {
    this(webDriver, webDriver.findElement(By.xpath(xpath)));
  }

  public PageElement(WebDriver webDriver) {
    super(webDriver);
  }

  public PageElement(WebDriver webDriver, SearchContext searchContext) {
    super(webDriver, searchContext);
  }

  public PageElement(WebDriver webDriver, SearchContext searchContext, String xpath) {
    this(webDriver, searchContext.findElement(By.xpath(xpath)));
  }

  public PageElement(WebDriver webDriver, WebElement webElement) {
    this(webDriver);
    this.webElement = webElement;
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public PageElement(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    this(webDriver, searchContext);
    this.webElement = webElement;
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public void moveAndClick() {
    moveAndClick(getWebElement());
  }

  public void moveToElement() {
    moveToElement(getWebElement());
  }

  public void click() {
    try {
      scrollIntoView();
      getWebElement().click();
    } catch (ElementClickInterceptedException ex) {
      jsClick();
    }
  }

  public void dragAndDropBy(int x, int y) {
    Actions actions = new Actions(getWebDriver());
    actions
        .moveToElement(getWebElement())
        .clickAndHold()
        .pause(2000)
        .moveByOffset(x, y)
        .pause(2000)
        .release()
        .perform();
  }

  public void jsClick() {
    executeScript("arguments[0].click()", getWebElement());
  }

  public String getAttribute(String attributeName) {
    return getAttribute(getWebElement(), attributeName);
  }

  public String getValue() {
    return getAttribute("value");
  }

  public String getCssValue(String propertyName) {
    return getWebElement().getCssValue(propertyName);
  }

  public String getText() {
    return getWebElement().getText();
  }

  public String getTextContent() {
    return executeScript("return arguments[0].textContent", getWebElement());
  }

  public String getNormalizedText() {
    return StringUtils.normalizeSpace(getText());
  }

  public void clear() {
    getWebElement().clear();
  }

  public void sendKeys(CharSequence keysToSend) {
    sendKeysWithoutClear(webElement, keysToSend);
  }

  public void sendKeys(Object value) {
    sendKeys(String.valueOf(value));
  }

  public void sendKeysAndEnterNoXpath(CharSequence... keysToSend) {
    WebElement we = this.webElement;
    sendKeys(we, keysToSend);
    we.sendKeys(Keys.RETURN);
    pause300ms();
  }

  public void clearAndSendKeys(CharSequence keysToSend) {
    waitUntilClickable();
    clear();
    sendKeys(getWebElement(), keysToSend);
  }

  public WebElement getWebElement() {
    try {
      webElement.getTagName();
    } catch (StaleElementReferenceException ex) {
      webElement = refreshWebElement(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
    return webElement;
  }

  public SearchContext getSearchContext() {
    return searchContext;
  }

  public boolean isDisplayed() {
    try {
      return getWebElement().isDisplayed();
    } catch (Exception ex) {
      return false;
    }
  }

  public boolean isDisplayedFast() {
    try {
      setImplicitTimeout(0);
      return getWebElement().isDisplayed();
    } catch (Exception ex) {
      return false;
    } finally {
      resetImplicitTimeout();
    }
  }

  public void scrollIntoView() {
    scrollIntoView(false);
  }

  public void scrollIntoView(boolean alignToTop) {
    scrollIntoView(getWebElement(), alignToTop);
  }

  public void waitUntilClickable() {
    waitUntilElementIsClickable(getWebElement());
  }

  public void waitUntilClickable(int timeoutInSeconds) {
    waitUntilElementIsClickable(webElement, timeoutInSeconds);
  }

  public void waitUntilInvisible() {
    waitUntilInvisibilityOfElementLocated(webElement);
  }

  public boolean waitUntilInvisible(int timeout) {
    try {
      waitUntilInvisibilityOfElementLocated(getWebElement(), timeout);
      return true;
    } catch (Throwable ex) {
      return false;
    }
  }

  public void waitUntilVisible() {
    waitUntilVisibilityOfElementLocated(webElement);
  }

  public boolean waitUntilVisible(int timeout) {
    try {
      waitUntilVisibilityOfElementLocated(getWebElement(), timeout);
      return true;
    } catch (Throwable ex) {
      return false;
    }
  }

  public boolean isEnabled() {
    return getWebElement().isEnabled();
  }

  public WebElement findElement(By by) {
    return getWebElement().findElement(by);
  }

  protected String escapeValue(String value) {
    return value.replace("'", "\\'");
  }

  public boolean hasClass(String className) {
    return Arrays.asList(getAttribute("class").split(" ")).contains(className);
  }

  public int getElementsCountFast(By by) {
    try {
      setImplicitTimeout(0);
      return getWebElement().findElements(by).size();
    } catch (Exception ex) {
      return 0;
    } finally {
      resetImplicitTimeout();
    }
  }

  public <T> T executeScript(String script) {
    return executeScript(script, getWebElement());
  }

  private WebElement refreshWebElement(WebDriver webDriver, WebElement webEl) {
    String elementInfo = webEl.toString();
    if (elementInfo.contains("->")) {
      elementInfo = elementInfo.substring(elementInfo.indexOf("->"));
      String elementLocator = elementInfo.substring(elementInfo.indexOf(": "));
      elementLocator = elementLocator.substring(2, elementLocator.length() - 1);

      WebElement retWebEl = null;
      if (elementInfo.contains("-> link text:")) {
        retWebEl = webDriver.findElement(By.linkText(elementLocator));
      } else if (elementInfo.contains("-> name:")) {
        retWebEl = webDriver.findElement(By.name(elementLocator));
      } else if (elementInfo.contains("-> id:")) {
        retWebEl = webDriver.findElement(By.id(elementLocator));
      } else if (elementInfo.contains("-> xpath:")) {
        retWebEl = webDriver.findElement(By.xpath(elementLocator));
      } else if (elementInfo.contains("-> class name:")) {
        retWebEl = webDriver.findElement(By.className(elementLocator));
      } else if (elementInfo.contains("-> css selector:")) {
        retWebEl = webDriver.findElement(By.cssSelector(elementLocator));
      } else if (elementInfo.contains("-> partial link text:")) {
        retWebEl = webDriver.findElement(By.partialLinkText(elementLocator));
      } else if (elementInfo.contains("-> tag name:")) {
        retWebEl = webDriver.findElement(By.tagName(elementLocator));
      } else {
        System.out.println("No valid locator found. Couldn't refresh element");
      }
      return retWebEl;
    } else {
      return refreshProxyWebElement(webDriver, elementInfo);
    }
  }

  private WebElement refreshProxyWebElement(WebDriver webDriver, String webElementStr) {
    String elementInfo = webElementStr.substring(webElementStr.indexOf("By"));
    String elementLocator = elementInfo.substring(elementInfo.indexOf(": "));
    elementLocator = elementLocator.substring(2, elementLocator.length() - 1);

    WebElement retWebEl = null;
    if (elementInfo.contains("linkText:")) {
      retWebEl = webDriver.findElement(By.linkText(elementLocator));
    } else if (elementInfo.contains("name:")) {
      retWebEl = webDriver.findElement(By.name(elementLocator));
    } else if (elementInfo.contains("id:")) {
      retWebEl = webDriver.findElement(By.id(elementLocator));
    } else if (elementInfo.contains("xpath:")) {
      retWebEl = webDriver.findElement(By.xpath(elementLocator));
    } else if (elementInfo.contains("className:")) {
      retWebEl = webDriver.findElement(By.className(elementLocator));
    } else if (elementInfo.contains("cssSelector:")) {
      retWebEl = webDriver.findElement(By.cssSelector(elementLocator));
    } else if (elementInfo.contains("partialLinkText:")) {
      retWebEl = webDriver.findElement(By.partialLinkText(elementLocator));
    } else if (elementInfo.contains("tagName:")) {
      retWebEl = webDriver.findElement(By.tagName(elementLocator));
    } else {
      System.out.println("No valid locator found. Couldn't refresh element");
    }
    return retWebEl;
  }

}
