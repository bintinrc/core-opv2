package co.nvqa.operator_v2.selenium.elements;

import co.nvqa.common_selenium.page.SimplePage;
import java.util.Arrays;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.ElementClickInterceptedException;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
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

  public void clearAndSendKeys(CharSequence keysToSend) {
    waitUntilClickable();
    clear();
    sendKeys(getWebElement(), keysToSend);
  }

  public WebElement getWebElement() {
    try {
      webElement.getTagName();
    } catch (StaleElementReferenceException ex) {
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
}
