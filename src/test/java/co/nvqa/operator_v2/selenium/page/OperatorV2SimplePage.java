package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.ui.page.SimpleWebPage;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.common.utils.NvTestWaitTimeoutException;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.util.NvAllure;
import co.nvqa.operator_v2.exception.NvTestCoreWindowOrTabNotFoundError;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ToastError;
import co.nvqa.operator_v2.selenium.elements.ToastInfo;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableList;
import java.time.temporal.TemporalAccessor;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class OperatorV2SimplePage extends SimpleWebPage {

  private static final Logger LOGGER = LoggerFactory.getLogger(OperatorV2SimplePage.class);

  private static final String XPATH_FOR_MDSELECT_CONTAINS_ID = "//md-select[contains(@id,'%s')]";
  private static final String XPATH_FOR_INPUT_FIELDS_IN_EDIT_RECOVERY = "//input[contains(@id,'%s')]/../preceding-sibling::div";


  @FindBy(css = "div.toast-error")
  public List<ToastError> toastErrors;
  @FindBy(css = "div.toast-warning")
  public List<ToastError> toastWarnings;
  @FindBy(css = "div.toast-info")
  public List<ToastInfo> toastInfo;
  @FindBy(css = "div.toast-success")
  public List<ToastInfo> toastSuccess;

  @FindBy(css = "div.md-half-circle")
  public PageElement halfCircleSpinner;
  @FindBy(css = "div.load-more-data")
  public PageElement loadMoreData;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  public OperatorV2SimplePage(WebDriver webDriver) {
    super(webDriver);
    PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void goToUrl(String url) {
    getWebDriver().navigate().to(url);
  }

  public void waitWhilePageIsLoading() {
    waitUntilInvisibilityOfElementLocated("//div[@class='md-half-circle']", 60);
    waitUntilPageLoaded();
  }


  public void waitWhilePageIsLoading(int timeoutInSeconds) {
    waitUntilInvisibilityOfElementLocated("//div[@class='md-half-circle']", timeoutInSeconds);
    waitUntilPageLoaded();
  }

  public void clickAndWaitUntilDone(String xpathExpression) {
    click(xpathExpression);
    waitUntilInvisibilityOfElementLocated(xpathExpression + "//md-progress-circular");
  }

  public void clickButtonByAriaLabel(String ariaLabel) {
    String xpath = f("//button[@aria-label='%s']", ariaLabel);
    scrollIntoView(xpath, true);
    click(xpath);
  }

  public void clickButtonByAriaLabelAndWaitUntilDone(String ariaLabel) {
    String xpathExpression = f(".//button[@aria-label='%s']", ariaLabel);
    click(xpathExpression);
    waitUntilInvisibilityOfElementLocated(
        xpathExpression + "/div[contains(@class,'show')]/md-progress-circular");
  }

  public void clickNvIconButtonByName(String name) {
    clickf(".//nv-icon-button[@name='%s']", name);
  }

  public void setValueOfIconButtonByName(String name) {
    clickf("//nv-icon-button[@name='%s']", name);
  }

  public void clickNvIconButtonByNameAndWaitUntilEnabled(String name) {
    String xpathExpression = f("//nv-icon-button[@name='%s']", name);
    click(xpathExpression);
    waitUntilInvisibilityOfElementLocated(xpathExpression + "/button[@disabled='disabled']");
  }

  public void waitUntilEnabledAndClickNvIconTextButtonByName(String name) {
    String xpathExpression = f("//nv-icon-text-button[@name='%s']", name);
    waitUntilInvisibilityOfElementLocated(xpathExpression + "/button[@disabled='disabled']");
    click(xpathExpression);
  }

  public void clickNvIconTextButtonByName(String name) {
    clickf("//nv-icon-text-button[@name='%s']//button", name);
  }

  public void clickNvIconTextButtonByNameAndWaitUntilDone(String name) {
    String xpathExpression = f("//nv-icon-text-button[@name='%s']", name);
    click(xpathExpression);
    waitUntilInvisibilityOfElementLocated(
        xpathExpression + "/button/div[contains(@class,'show')]/md-progress-circular");
  }

  public void clickNvApiTextButtonByName(String name) {
    clickf("//nv-api-text-button[@name='%s']", name);
  }

  public void clickNvApiTextButtonByNameAndWaitUntilDone(String name) {
    String xpathExpression = f("//nv-api-text-button[@name='%s']", name);
    click(xpathExpression);
    waitUntilInvisibilityOfElementLocated(
        xpathExpression + "/button/div[contains(@class,'show')]/md-progress-circular");
  }

  public void clickNvApiIconButtonByName(String name) {
    clickf("//nv-api-icon-button[@name='%s']", name);
  }

  public void clickNvApiIconButtonByNameAndWaitUntilDone(String name) {
    String xpathExpression = f("//nv-api-icon-button[@name='%s']", name);
    click(xpathExpression);
    waitUntilInvisibilityOfElementLocated(
        xpathExpression + "/button/div[contains(@class,'waiting')]/md-progress-circular");
  }

  public void clickNvButtonSaveByName(String name) {
    clickf("//nv-button-save[@name='%s']", name);
  }

  public void clickNvButtonSaveByNameAndWaitUntilDone(String name) {
    String xpathExpression = f("//nv-button-save[@name='%s']/button", name);
    click(xpathExpression);
    waitUntilInvisibilityOfElementLocated(
        xpathExpression + "/div[contains(@class,'saving')]/md-progress-circular");
  }

  public void clickButtonOnMdDialogByAriaLabel(String ariaLabel) {
    clickf("//md-dialog//button[@aria-label='%s']", ariaLabel);
  }

  public void clickButtonOnMdDialogByAriaLabelIgnoreCase(String ariaLabel) {
    clickf(
        "//md-dialog//button[translate(@aria-label,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')=translate('%s','ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')]",
        ariaLabel);
  }

  public void clear(String xpathExpression) {
    WebElement we = findElementByXpath(xpathExpression);
    we.clear();
    pause100ms();
  }

  public void clearf(String xpathExpression, Object... args) {
    xpathExpression = f(xpathExpression, args);
    WebElement we = findElementByXpath(xpathExpression);
    we.clear();
    pause100ms();
  }

  public void sendKeysByIdCustom1(String id, CharSequence... keysToSend) {
    String xpathExpression = f("//*[self::input or self::textarea][starts-with(@id, '%s')]", id);
    WebElement we = findElementByXpath(xpathExpression);
    we.click();
    we.sendKeys(keysToSend);
    pause50ms();
  }

  public void sendKeysAndEnterByAriaLabel(String ariaLabel, CharSequence... keysToSend) {
    sendKeysAndEnter(f("//*[@aria-label='%s']", ariaLabel), keysToSend);
  }

  public void sendKeysToMdInputContainerByModel(String mdInputContainerModel,
      CharSequence... keysToSend) {
    sendKeys(f("//md-input-container[@model='%s']/input", mdInputContainerModel), keysToSend);
  }

  public void setMdDatepicker(String mdDatepickerNgModel, TemporalAccessor date) {
    sendKeys(f("//md-datepicker[@ng-model='%s']/div/input", mdDatepickerNgModel),
        DTF_NORMAL_DATE.format(date));
    clickf("//md-datepicker[@ng-model='%s']/parent::*", mdDatepickerNgModel);
  }

  public void setMdDatepickerById(String mdDatepickerId, TemporalAccessor date) {
    sendKeys(f("//md-datepicker[@id='%s']/div/input", mdDatepickerId),
        DTF_NORMAL_DATE.format(date));
    clickf("//md-datepicker[@id='%s']/parent::*", mdDatepickerId);
  }

  public String getValueMdDatepickerById(String mdDatepickerId) {
    return getValue(f("//md-datepicker[@id='%s']/div/input", mdDatepickerId));
  }

  public boolean isEnabledMdDatepickerById(String mdDatepickerId) {
    return isElementEnabled(f("//md-datepicker[@id='%s']/div/input", mdDatepickerId));
  }

  public void clickTabItem(String tabItemText) {
    clickf("//tab-item[contains(text(), '%s')]", tabItemText);
  }

  public void waitUntilVisibilityOfToast(String containsMessage) {
    waitUntilVisibilityOfElementLocated(
        f("//div[@id='toast-container']//div[contains(text(), '%s')]", containsMessage));
  }

  public void waitUntilNoticeMessage(String containsMessage) {
    waitUntilVisibilityOfElementLocated(
        f("//div[@class='ant-notification-notice-message' and contains(text(), '%s')]",
            containsMessage));
  }

  public void waitUntilVisibilityOfToastReact(String containsMessage) {
    waitUntilVisibilityOfElementLocated(
        f("//div[contains(@class,'notification-notice')]//div[contains(text(),'%s')]",
            containsMessage));
  }

  public Map<String, String> waitUntilVisibilityAndGetErrorToastData() {
    Map<String, String> toastData = new HashMap<>();
    String xpath = "//div[@class='toast-message']";
    waitUntilVisibilityOfElementLocated(xpath);

    String childXpath = xpath + "//strong[1]";
    if (isElementExistFast(childXpath)) {
      toastData.put("status", StringUtils.trim(getText(childXpath)));
    }
    childXpath = xpath + "//strong[2]";
    if (isElementExistFast(childXpath)) {
      toastData.put("url", StringUtils.trim(getText(childXpath)));
    }
    childXpath = xpath + "//strong[3]";
    if (isElementExistFast(childXpath)) {
      toastData.put("errorCode", StringUtils.trim(getText(childXpath)));
    }
    childXpath = xpath + "//strong[4]";
    if (isElementExistFast(childXpath)) {
      toastData.put("errorMessage", StringUtils.trim(getText(childXpath)));
    }

    return toastData;
  }

  public void waitUntilInvisibilityOfToast() {
    waitUntilInvisibilityOfToast(null);
  }

  public void waitUntilInvisibilityOfToast(boolean waitUntilElementVisibleFirst) {
    waitUntilInvisibilityOfToast(null, waitUntilElementVisibleFirst);
  }

  public void waitUntilInvisibilityOfToast(String containsMessage) {
    waitUntilInvisibilityOfToast(containsMessage, true);
  }

  public void waitUntilInvisibilityOfToast(String containsMessage,
      boolean waitUntilElementVisibleFirst) {
    String xpathExpression = StringUtils.isNotBlank(containsMessage)
        ? f("//div[@id='toast-container']//div[contains(text(), '%s')]", containsMessage)
        : "//div[@id='toast-container']";

    if (waitUntilElementVisibleFirst) {
      waitUntilVisibilityOfElementLocated(xpathExpression);
    }

    waitUntilInvisibilityOfElementLocated(xpathExpression);
  }

  public void waitUntilInvisibilityOfNotification(String containsMessage,
      boolean waitUntilElementVisibleFirst) {
    String xpathExpression = StringUtils.isNotBlank(containsMessage)
        ? f(
        "//div[contains(@class,'ant-notification')]//div[@class='ant-notification-notice-message'][contains(text(),'%s')]",
        containsMessage)
        : "//div[contains(@class,'ant-notification')]";

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

  public void confirmToast(String containsMessage, boolean waitUntilElementVisibleFirst) {
    String xpathExpression = f("//div[@id='toast-container'][.//div[contains(text(), '%s')]]",
        containsMessage);

    if (waitUntilElementVisibleFirst) {
      waitUntilVisibilityOfElementLocated(xpathExpression);
    }

    clickf(xpathExpression + "//button[text()='OK']");
    waitUntilInvisibilityOfToast(containsMessage, false);
  }

  public void clickToast(String containsMessage) {
    clickToast(containsMessage, true);
  }

  public void clickToast(String containsMessage, boolean waitUntilElementVisibleFirst) {
    String xpathExpression = f("//div[@id='toast-container']//div[contains(text(), '%s')]",
        containsMessage);

    if (waitUntilElementVisibleFirst) {
      waitUntilVisibilityOfElementLocated(xpathExpression);
    }

    clickf(xpathExpression);
  }

  public WebElement getToast() {
    String xpathExpression = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
    return waitUntilVisibilityOfElementLocated(xpathExpression);
  }

  public void closeToast() {
    String xpathExpression = "//div[@id='toast-container']//i[.='close']";
    click(xpathExpression);
  }

  public List<WebElement> getToasts() {
    String xpathExpression = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
    waitUntilVisibilityOfElementLocated(xpathExpression);
    return findElementsByXpath(xpathExpression);
  }

  public WebElement getToastTop() {
    String xpathExpression = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div";
    return waitUntilVisibilityOfElementLocated(xpathExpression);
  }

  public String getToastTopText() {
    return getToastText("//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div");
  }

  public String getAntTopText() {
    return getToastText("//div[@class='ant-message-notice']//span[2]");
  }

  public String getAntTopTextV2() {
    return getToastText("//div[@class='ant-notification-notice-message']");
  }

  public String getAntDescription() {
    return getToastText("//div[@class='ant-notification-notice-description']");
  }

  public String getAntTopRightText() {
    return getToastText("//div[contains(@class,'ant-notification-topRight')]");
  }

  public WebElement getToastBottom() {
    String xpathExpression = "//div[@id='toast-container']/div/div/div/div[@class='toast-bottom']";
    return waitUntilVisibilityOfElementLocated(xpathExpression);
  }

  public String getToastBottomText() {
    return getToastText("//div[@id='toast-container']/div/div/div/div[@class='toast-bottom']");
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
    }

    return text;
  }

  public String getTextOnTable(int rowNumber, String columnDataClass, String mdVirtualRepeat) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat);
  }

  public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass,
      String mdVirtualRepeat) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat,
        XpathTextMode.STARTS_WITH);
  }

  public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass,
      String mdVirtualRepeat, String nvTableParam) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat,
        XpathTextMode.STARTS_WITH, nvTableParam);
  }

  public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass,
      String mdVirtualRepeat, XpathTextMode xpathTextMode) {
    return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat,
        xpathTextMode, null);
  }

  public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass,
      String mdVirtualRepeat, XpathTextMode xpathTextMode, String nvTableParam) {
    String text = null;
    String nvTableXpathExpression = "";

    try {
      if (!isBlank(nvTableParam)) {
        nvTableXpathExpression = f(".//nv-table[@param='%s']", nvTableParam);
      }

      WebElement we;

      switch (xpathTextMode) {
        case EXACT:
          we = findElementByXpath(
              f("%s//tr[@md-virtual-repeat='%s'][not(contains(@class, 'last-row'))][%d]/td[normalize-space(@class)='%s']",
                  nvTableXpathExpression, mdVirtualRepeat, rowNumber, columnDataClass));
          break;
        case CONTAINS:
          we = findElementByXpath(
              f("%s//tr[@md-virtual-repeat='%s'][not(contains(@class, 'last-row'))][%d]/td[contains(@class, '%s')]",
                  nvTableXpathExpression, mdVirtualRepeat, rowNumber, columnDataClass));
          break;
        case STARTS_WITH:
          we = findElementByXpath(
              f("%s//tr[@md-virtual-repeat='%s'][not(contains(@class, 'last-row'))][%d]/td[starts-with(@class, '%s')]",
                  nvTableXpathExpression, mdVirtualRepeat, rowNumber, columnDataClass));
          break;
        default:
          we = findElementByXpath(
              f("%s//tr[@md-virtual-repeat='%s'][not(contains(@class, 'last-row'))][%d]/td[starts-with(@class, '%s')]",
                  nvTableXpathExpression, mdVirtualRepeat, rowNumber, columnDataClass));
      }

      text = we.getText().trim();
    } catch (NoSuchElementException ex) {
      LOGGER.warn("Failed to find element by XPath. XPath: {}", nvTableXpathExpression);
      NvAllure
          .addWarnAttachment(getCurrentMethodName(), "Failed to find element by XPath. XPath: %s",
              nvTableXpathExpression);
    }

    return text;
  }

  public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonName,
      String mdVirtualRepeat) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, mdVirtualRepeat,
        XpathTextMode.STARTS_WITH, null);
  }

  public void clickCustomActionButtonOnTableWithMdVirtualRepeat(int rowNumber,
      String actionButtonXpath, String mdVirtualRepeat) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, mdVirtualRepeat,
        XpathTextMode.STARTS_WITH, null, actionButtonXpath);
  }

  public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonName,
      String mdVirtualRepeat, XpathTextMode xpathTextMode) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, mdVirtualRepeat,
        xpathTextMode, null);
  }

  public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonName,
      String mdVirtualRepeat, String nvTableParam) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, mdVirtualRepeat,
        XpathTextMode.STARTS_WITH, nvTableParam);
  }

  public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonName,
      String mdVirtualRepeat, XpathTextMode xpathTextMode, String nvTableParam) {
    String actionButtonXpath = f("//nv-icon-button[@name='%s']/button", actionButtonName);
    try {
      clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, mdVirtualRepeat, xpathTextMode,
          nvTableParam, actionButtonXpath);
    } catch (RuntimeException ex) {
      throw new RuntimeException(f("Cannot find action button '%s' on table.", actionButtonName),
          ex);
    }
  }

  public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String mdVirtualRepeat,
      XpathTextMode xpathTextMode, String nvTableParam, String actionButtonXpath) {
    try {
      String nvTableXpathExpression = "";

      if (!isBlank(nvTableParam)) {
        nvTableXpathExpression = f("//nv-table[@param='%s']", nvTableParam);
      }

      String xpathExpression;

      switch (xpathTextMode) {
        case CONTAINS:
          xpathExpression = f(
              "%s//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'actions')]%s",
              nvTableXpathExpression, mdVirtualRepeat, rowNumber, actionButtonXpath);
          break;
        case STARTS_WITH:
          xpathExpression = f(
              "%s//tr[@md-virtual-repeat='%s'][%d]/td[starts-with(@class, 'actions')]%s",
              nvTableXpathExpression, mdVirtualRepeat, rowNumber, actionButtonXpath);
          break;
        default:
          xpathExpression = f(
              "%s//tr[@md-virtual-repeat='%s'][%d]/td[starts-with(@class, 'actions')]%s",
              nvTableXpathExpression, mdVirtualRepeat, rowNumber, actionButtonXpath);
      }

      simpleClick(xpathExpression);
    } catch (NoSuchElementException ex) {
      throw new RuntimeException(f("Cannot find action button '%s' on table.", actionButtonXpath),
          ex);
    }
  }

  /**
   * @param rowNumber       The row number.
   * @param columnClassName The column's class name.
   * @param buttonAriaLabel The button's aria label.
   * @param ngRepeat        Ng-Repeat used in the tag.
   */
  public void clickButtonOnTableWithMdVirtualRepeat(int rowNumber, String columnClassName,
      String buttonAriaLabel, String ngRepeat) {
    try {
      String xpathExpression = f(
          "//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, '%s')]//button[@aria-label='%s']",
          ngRepeat, rowNumber, columnClassName, buttonAriaLabel);
      WebElement we = findElementByXpath(xpathExpression);
      moveAndClick(we);
    } catch (NoSuchElementException ex) {
      throw new NvTestRuntimeException("Cannot find action button on table.", ex);
    }
  }

  public String getTextOnTableWithNgRepeat(int rowNumber, String columnDataClass, String ngRepeat) {
    return getTextOnTableWithNgRepeat(rowNumber, "class", columnDataClass, ngRepeat);
  }

  public int getRowsCountOfTableWithNgRepeat(String ngRepeat) {
    String xpath = f(".//tr[@ng-repeat='%s'][not(contains(@class,'last-row'))]", ngRepeat);

    try {
      List<WebElement> webElements = findElementsByXpath(xpath);
      return webElements.size();
    } catch (NoSuchElementException ex) {
      LOGGER.warn("Table with NgRepeat [{}] was not found. XPath: {}", ngRepeat, xpath);
      NvAllure.addWarnAttachment(getCurrentMethodName(),
          "Table with NgRepeat [%s] was not found. XPath: %s", ngRepeat, xpath);
      return 0;
    }
  }

  public int getRowsCountOfTableWithMdVirtualRepeat(String mdVirtualRepeat) {
    return getRowsCountOfTableWithMdVirtualRepeat(mdVirtualRepeat, null);
  }

  public int getRowsCountOfTableWithMdVirtualRepeat(String mdVirtualRepeat, String nvTableParam) {
    String nvTableXpathExpression = "";
    if (!isBlank(nvTableParam)) {
      nvTableXpathExpression = f(".//nv-table[@param='%s']", nvTableParam);
    }
    String xpath = f("%s//tr[@md-virtual-repeat='%s'][not(contains(@class, 'last-row'))]",
        nvTableXpathExpression, mdVirtualRepeat);

    try {
      List<WebElement> webElements = findElementsByXpath(xpath);
      return webElements.size();
    } catch (NoSuchElementException | TimeoutException ex) {
      LOGGER.warn("Table with md-virtual-repeat [{}] was not found. XPath: {}", mdVirtualRepeat,
          xpath);
      NvAllure.addWarnAttachment(getCurrentMethodName(),
          "Table with md-virtual-repeat [%s] was not found. XPath: %s", mdVirtualRepeat, xpath);
      return 0;
    }
  }

  public int getRowsCountOfTableWithMdVirtualRepeatFast(String mdVirtualRepeat) {
    String xpath = f("//tr[@md-virtual-repeat='%s']", mdVirtualRepeat);

    try {
      List<WebElement> webElements = findElementsByXpathFast(xpath);
      return webElements.size();
    } catch (NoSuchElementException | TimeoutException ex) {
      LOGGER.warn("Table with md-virtual-repeat [{}] was not found. XPath: {}", mdVirtualRepeat,
          xpath);
      NvAllure.addWarnAttachment(getCurrentMethodName(),
          "Table with md-virtual-repeat [%s] was not found. XPath: %s", mdVirtualRepeat, xpath);
      return 0;
    }
  }

  public String getSelectedValueOfMdAutocompleteOnTableWithNgRepeat(int rowNumber,
      String columnDataClass, String ngRepeat) {
    return getSelectedValueOfMdAutocompleteOnTableWithNgRepeat(rowNumber, "class", columnDataClass,
        ngRepeat);
  }

  public String getSelectedValueOfMdAutocompleteOnTableWithNgRepeat(int rowNumber,
      String columnAttributeName, String attributeValue, String ngRepeat) {
    String value = null;
    String xpath = f(
        "//tr[@ng-repeat='%s'][%d]/td[starts-with(@%s, \"%s\")]/nv-autocomplete//input", ngRepeat,
        rowNumber, columnAttributeName, attributeValue);

    try {
      WebElement we = findElementByXpath(xpath);
      value = we.getAttribute("value").trim();
    } catch (NoSuchElementException ex) {
      LOGGER.warn("Failed to getTextOnTableWithNgRepeat. XPath: {}", xpath);
      NvAllure.addWarnAttachment(getCurrentMethodName(),
          "Failed to getTextOnTableWithNgRepeat. XPath: %s", xpath);
    }

    return value;
  }

  public String getTextOnTableWithNgRepeatUsingDataTitle(int rowNumber, String columnDataTitle,
      String ngRepeat) {
    return getTextOnTableWithNgRepeat(rowNumber, "data-title", columnDataTitle, ngRepeat);
  }


  public String getTextOnTableWithNgRepeatAndCustomCellLocator(int rowNumber, String cellLocator,
      String ngRepeat) {
    String text = null;
    String xpath =
        ngRepeat.contains("'") ? ".//tr[@ng-repeat=\"%s\"][%d]" : ".//tr[@ng-repeat='%s'][%d]";
    xpath = f(xpath + cellLocator, ngRepeat, rowNumber);

    try {
      WebElement we = findElementByXpath(xpath);
      text = we.getText().trim();
    } catch (NoSuchElementException ex) {
      LOGGER.warn("Failed to getTextOnTableWithNgRepeat. XPath: {}", xpath);
      NvAllure.addWarnAttachment(getCurrentMethodName(),
          "Failed to getTextOnTableWithNgRepeat. XPath: %s", xpath);
    }

    return text;
  }

  public String getTextOnTableWithNgRepeat(int rowNumber, String columnAttributeName,
      String attributeValue, String ngRepeat) {
    String text = null;
    String xpath = f(".//tr[@ng-repeat='%s'][%d]/td[starts-with(@%s, \"%s\")]", ngRepeat, rowNumber,
        columnAttributeName, attributeValue);

    try {
      WebElement we = findElementByXpath(xpath);
      text = we.getText().trim();
    } catch (NoSuchElementException ex) {
      LOGGER.warn("Failed to getTextOnTableWithNgRepeat. XPath: {}", xpath);
      NvAllure.addWarnAttachment(getCurrentMethodName(),
          "Failed to getTextOnTableWithNgRepeat. XPath: %s", xpath);
    } catch (StaleElementReferenceException ex) {
      WebElement we = findElementByXpath(xpath);
      text = we.getText().trim();
    }

    return text;
  }

  public void clickActionButtonOnTableWithNgRepeat(int rowNumber, String actionButtonName,
      String ngRepeat) {
    try {
      final String xpathExpression = f(
          "//tr[@ng-repeat='%s'][%d]/td[starts-with(@class, 'actions')]//*[@name='%s']", ngRepeat,
          rowNumber, actionButtonName);
      final WebElement we = findElementByXpath(xpathExpression);
      moveAndClick(we);
    } catch (NoSuchElementException ex) {
      throw new RuntimeException("Cannot find action button on table.", ex);
    }
  }

  public void clickButtonOnTableWithNgRepeat(int rowNumber, String className,
      String buttonAriaLabel, String ngRepeat) {
    try {
      String xpathExpression = f(
          "//tr[@ng-repeat='%s'][%d]/td[starts-with(@class, '%s')]//button[@aria-label='%s']",
          ngRepeat, rowNumber, className, buttonAriaLabel);
      WebElement we = findElementByXpath(xpathExpression);
      moveAndClick(we);
    } catch (NoSuchElementException ex) {
      throw new NvTestRuntimeException("Cannot find action button on table.", ex);
    }
  }

  public void sendKeysToMdInputContainerOnTableWithNgRepeat(int rowNumber, String inputModel,
      String ngRepeat, CharSequence... keysToSend) {
    try {
      String xpathExpression = f(
          "//tr[@ng-repeat='%s'][%d]/td//md-input-container[@model='%s']/input", ngRepeat,
          rowNumber, inputModel);
      sendKeys(xpathExpression, keysToSend);
    } catch (NoSuchElementException ex) {
      throw new NvTestRuntimeException("Cannot find md input on table.", ex);
    }
  }

  public void checkRowWithMdVirtualRepeat(int rowNumber, String mdVirtualRepeat) {
    final WebElement mdCheckboxWe = findElementByXpath(
        f("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'column-checkbox')]//md-checkbox",
            mdVirtualRepeat, rowNumber));
    final String ariaChecked = getAttribute(mdCheckboxWe, "aria-checked");

    if ("false".equalsIgnoreCase(ariaChecked)) {
      mdCheckboxWe.click();
    }
  }

  public void checkRowWithNgRepeat(int rowNumber, String ngRepeat) {
    final WebElement mdCheckboxWe = findElementByXpath(
        f("//tr[@ng-repeat='%s'][%d]/td[contains(@class, 'selection')]//md-checkbox", ngRepeat,
            rowNumber));
    final boolean ariaChecked = Boolean.parseBoolean(getAttribute(mdCheckboxWe, "aria-checked"));

    if (!ariaChecked) {
      mdCheckboxWe.click();
    }
  }

  public void clickToggleButtonByLabel(String label, String buttonAriaLabel) {
    clickf("//label[text()='%s']/following-sibling::div//button[@aria-label='%s']", label,
        buttonAriaLabel);
  }

  public void clickToggleButtonByLabelAndModel(String label, String model, String buttonAriaLabel) {
    clickf("  //label[text()='%s']/following-sibling::div[@model='%s']//button[@aria-label='%s']",
        label, model, buttonAriaLabel);
  }

  public void clickToggleButton(String divModel, String buttonAriaLabel) {
    clickf("//div[@model='%s']//button[@aria-label='%s']", divModel, buttonAriaLabel);
  }

  public String getToggleButtonValue(String divModel) {
    return getText(f("//div[@model='%s']//button[contains(@class,'raised')]/span", divModel));
  }

  public void selectValueFromNvAutocomplete(String searchText, String value) {
    selectValueFromNvAutocompleteBy("search-text", searchText, value);
  }

  public void selectValueFromNvAutocompleteByItemTypes(String itemTypes, String value) {
    selectValueFromNvAutocompleteBy("item-types", itemTypes, value);
  }

  public void selectValueFromNvAutocompleteByItemTypesAndDismiss(String itemTypes, String value) {
    WebElement we = selectValueFromNvAutocompleteBy("item-types", itemTypes, value);
    we.sendKeys(Keys.ESCAPE);
    pause200ms();
  }

  public void selectValueFromNvAutocompleteBySearchTextAndDismiss(String searchText, String value) {
    WebElement we = selectValueFromNvAutocompleteBy("search-text", searchText, value);
    we.sendKeys(Keys.ESCAPE);
    pause200ms();
  }

  public void removeNvFilterBoxByMainTitle(String mainTitle) {
    click(
        f("//*[self::nv-filter-text-box or self::nv-filter-box][@main-title='%s']//button[i[text()='close']]",
            mainTitle));
  }

  public List<String> getSelectedValuesFromNvFilterBox(String mainTitle) {
    List<WebElement> listOfWe = findElementsByXpath(
        f("//*[self::nv-filter-text-box or self::nv-filter-box][@main-title='%s']//nv-icon-text-button[@ng-repeat='item in selectedOptions']//div",
            mainTitle));

    if (listOfWe != null) {
      return listOfWe.stream().map(this::getTextTrimmed).collect(Collectors.toList());
    }

    return null;
  }

  public void removeSelectedValueFromNvFilterBoxByAriaLabel(String nvFilterMainTitle,
      String buttonAriaLabel) {
    clickf(
        "//*[self::nv-filter-text-box or self::nv-filter-box][@main-title='%s']//button[@aria-label='%s']/i[text()='close']",
        nvFilterMainTitle, buttonAriaLabel);
  }

  public void selectValueFromNvAutocompleteByPossibleOptions(String possibleOptions, String value) {
    selectValueFromNvAutocompleteBy("possible-options", possibleOptions, value);
  }

  private WebElement selectValueFromNvAutocompleteBy(String nvAutocompleteAttribute,
      String nvAutocompleteAttributeValue, String value) {
    String baseXpath = f(".//nv-autocomplete[@%s='%s']", nvAutocompleteAttribute,
        nvAutocompleteAttributeValue);
    String inputXpath = baseXpath + "//input";
    WebElement inputElement = findElementByXpath(inputXpath);

    if (!inputElement.getAttribute("value").isEmpty()) {
      inputElement.clear();
      pause200ms();
    }

    inputElement.sendKeys(value);
    pause1s();

        /*
          Check if the value is not found on NV Autocomplete.
         */
    String noMatchingErrorText = f("\"%s\" were found.", value);

    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        WebElement noMatchingErrorWe = findElementByXpath(
            f("//span[contains(text(), '%s')]", noMatchingErrorText), WAIT_1_SECOND);
        String actualNoMatchingErrorText = getText(noMatchingErrorWe);
        throw new NvTestRuntimeException(
            f("Value not found on NV Autocomplete. Error message: %s", actualNoMatchingErrorText));
      } catch (NoSuchElementException | TimeoutException ignore) {
      }
    }, "Check if the value is not found on NV Autocomplete", 500, 25);

    inputElement.sendKeys(Keys.RETURN);
    pause200ms();
    return inputElement;
  }

  public String getNvAutocompleteValue(String searchTextAttribute) {
    return getValue(f("//nv-autocomplete[@search-text='%s']//input", searchTextAttribute));
  }

  public void selectValueFromMdAutocomplete(String placeholder, String value) {
    String xpathExpression = f("//md-autocomplete[@placeholder='%s']//input", placeholder);
    selectValueFromMdAutocompleteByXpath(xpathExpression, value);
  }

  public void selectValueFromMdAutocompleteByXpath(String xpathExpression, String value) {
    WebElement we = waitUntilElementIsClickable(xpathExpression);
    we.sendKeys(value);
    pause1s();
    List<WebElement> matchedItems = findElementsByXpath(
        "//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']");
    if (matchedItems.size() > 1) {
      String selectedItemXpath = "//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches'][contains(@class,'selected')]";
      String item = getText(selectedItemXpath).trim();
      while (!StringUtils.startsWithIgnoreCase(item, value)) {
        we.sendKeys(Keys.DOWN);
        pause100ms();
        item = getText(selectedItemXpath).trim();
      }
    }
    we.sendKeys(Keys.RETURN);
    pause100ms();
  }

  public boolean isMdSelectEnabled(String mdSelectNgModel) {
    return !Boolean.parseBoolean(
        getAttribute("aria-disabled", "//md-select[@ng-model='%s']", mdSelectNgModel));
  }

  public void selectValueFromMdSelectOrCheckCurrentIfDisabled(String selectName,
      String mdSelectNgModel, String value) {
    if (isMdSelectEnabled(mdSelectNgModel)) {
      selectValueFromMdSelect(mdSelectNgModel, value);
    } else {
      Assertions.assertThat(getMdSelectValue(mdSelectNgModel))
          .as(selectName + " select is disabled and current value is not equal to expected")
          .isEqualTo(value);
    }
  }

  public void selectValueFromMdSelectWithSearchById(String id, String value) {
    selectValueFromMdSelectWithSearch("id", id, value);
  }

  public void selectValueFromMdSelectWithSearch(String mdSelectNgModel, String value) {
    selectValueFromMdSelectWithSearch("ng-model", mdSelectNgModel, value);
  }

  public void selectValueFromMdSelectWithSearch(String attribute, String attributeValue,
      String value) {
    String xpath = f("//md-select[@%s='%s']", attribute, attributeValue);
    click(xpath);
    pause100ms();
    String menuContainerId = getAttribute(xpath, "aria-owns");
    String menuContainerXpath = f("//*[@id='%s']", menuContainerId);
    String searchBoxXpath = menuContainerXpath + "//input[@ng-model='searchTerm']";
    sendKeys(searchBoxXpath, value);
    pause100ms();
    String optionXpath = menuContainerXpath + "//md-option";
    try {
      click(optionXpath);
    } catch (NoSuchElementException ex) {
      throw new IllegalArgumentException(
          String.format("MdSelect Options were not found for search value [%s]", value), ex);
    }
    pause100ms();
  }

  public void selectValueFromMdSelect(String mdSelectNgModel, String value) {
    clickf("//md-select[@ng-model='%s']", mdSelectNgModel);
    pause100ms();
    clickf(
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%s')]",
        value, value);
    pause50ms();
  }

  public void selectMultipleValuesFromMdSelect(String mdSelectNgModel, List<String> listOfValues) {
    selectMultipleValuesFromMdSelect(mdSelectNgModel, XpathTextMode.CONTAINS, listOfValues);
  }

  public void selectMultipleValuesFromMdSelect(String mdSelectNgModel, XpathTextMode xpathTextMode,
      List<String> listOfValues) {
    if (listOfValues != null && !listOfValues.isEmpty()) {
      selectMultipleValuesFromMdSelect(mdSelectNgModel, xpathTextMode,
          listOfValues.toArray(new String[]{}));
    }
  }

  public void selectMultipleValuesFromMdSelect(String mdSelectNgModel, String... values) {
    selectMultipleValuesFromMdSelect(mdSelectNgModel, XpathTextMode.CONTAINS, values);
  }

  public void selectMultipleValuesFromMdSelect(String mdSelectNgModel, XpathTextMode xpathTextMode,
      String... values) {
    clickf("//md-select[@ng-model='%s']", mdSelectNgModel);
    pause100ms();

    for (String value : values) {
      switch (xpathTextMode) {
        case EXACT:
          clickf(
              "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[@value='%s']",
              value);
          break;
        case CONTAINS:
          clickf(
              "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s')]",
              value);
          break;
        default:
          clickf(
              "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s')]",
              value);
      }

      pause40ms();
    }

    Actions actions = new Actions(getWebDriver());
    actions.sendKeys(Keys.ESCAPE).build().perform();
    pause300ms();
  }

  public void selectMultipleValuesFromMdSelectById(String mdSelectId, List<String> listOfValues) {
    selectMultipleValuesFromMdSelectById(mdSelectId, XpathTextMode.CONTAINS, listOfValues);
  }

  public void selectMultipleValuesFromMdSelectById(String mdSelectId, XpathTextMode xpathTextMode,
      List<String> listOfValues) {
    if (listOfValues != null && !listOfValues.isEmpty()) {
      selectMultipleValuesFromMdSelectById(mdSelectId, xpathTextMode,
          listOfValues.toArray(new String[]{}));
    }
  }

  public void selectMultipleValuesFromMdSelectById(String mdSelectId, String... values) {
    selectMultipleValuesFromMdSelectById(mdSelectId, XpathTextMode.CONTAINS, values);
  }

  public void selectMultipleValuesFromMdSelectById(String mdSelectId, XpathTextMode xpathTextMode,
      String... values) {
    clickf(".//md-select[starts-with(@id, '%s')]", mdSelectId);
    pause100ms();

    for (String value : values) {
      switch (xpathTextMode) {
        case EXACT:
          clickf(
              "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[@value='%s' or ./div/text()='%<s']",
              value);
          break;
        case CONTAINS:
          clickf(
              "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%<s')]",
              value);
          break;
        default:
          clickf(
              "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%<s')]",
              value);
          break;
      }

      pause100ms();
    }

    Actions actions = new Actions(getWebDriver());
    actions.sendKeys(Keys.ESCAPE).build().perform();
    pause300ms();
  }

  public void toggleMdSwitchById(String mdSwitchId, boolean state) {
    String xpath = f("//md-switch[starts-with(@id, '%s')]", mdSwitchId);
    boolean currentState = Boolean.parseBoolean(getAttribute(xpath, "aria-checked"));

    if (currentState != state) {
      click(xpath);
    }
  }

  public void selectValueFromMdSelectById(String mdSelectId, String value) {
    clickf(".//md-select[starts-with(@id, '%s')]", mdSelectId);
    pause1s();
    clickf(
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[@value= \"%s\" or contains(./div/text(),\"%s\")]",
        value, value);
    pause50ms();
  }

  public void selectByIndexFromMdSelectById(String mdSelectId, int index) {
    clickf("//md-select[starts-with(@id, '%s')]", mdSelectId);
    pause1s();
    clickf(
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[%d]",
        index);
    pause50ms();
  }

  public void selectValueFromMdSelectByIdContains(String mdSelectId, String value) {
    clickf("//md-select[contains(@id, '%s')]", mdSelectId);
    pause100ms();
    clickf(
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%<s')]",
        value);
    pause50ms();
  }

  public void selectValueFromMdSelectByName(String mdSelectId, String value) {
    clickf(".//md-select[starts-with(@name, '%s')]", mdSelectId);
    pause100ms();
    clickf(
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,\"%s\") or contains(./div/text(),\"%<s\")]",
        value);
    pause50ms();
  }

  public void selectByIndexFromMdSelectByName(String mdSelectId, int index) {
    clickf("//md-select[starts-with(@name, '%s')]", mdSelectId);
    pause100ms();
    clickf(
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[%d]",
        index);
    pause50ms();
  }

  public void selectValueFromMdSelectByNameContains(String mdSelectId, String value) {
    clickf("//md-select[contains(@name, '%s')]", mdSelectId);
    pause100ms();
    clickf(
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%<s')]",
        value);
    pause50ms();
  }

  public void selectValueFromMdSelectByAriaLabel(String mdSelectAriaLabel, String value) {
    clickf("//md-select[contains(@aria-label, '%s')]", mdSelectAriaLabel);
    pause100ms();
    clickf(
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%<s')]",
        value);
    pause50ms();
  }

  public void selectValueFromMdSelectByMdSelectXpath(String mdSelectXpath, String value) {
    click(mdSelectXpath);
    pause100ms();
    clickf(
        "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,'%s') or contains(./div/text(),'%<s')]",
        value);
    pause50ms();
  }

  public void selectValueFromMdSelectMenu(String xpathMdSelectMenu, String xpathMdSelectOption) {
    WebElement mdSelectMenu = findElementByXpath(xpathMdSelectMenu);
    mdSelectMenu.click();
    pause300ms();
    WebElement mdSelectOption = findElementByXpath(xpathMdSelectOption);
    mdSelectOption.click();
    pause300ms();
  }

  public String getMdSelectValue(String mdSelectNgModel) {
    return getText(f("//md-select[@ng-model='%s']/md-select-value/span/div[@class='md-text']",
        mdSelectNgModel));
  }

  public String getMdSelectValueById(String mdSelectId) {
    return getText(f("//md-select[contains(@id,'%s')]/md-select-value/span/div[@class='md-text']",
        mdSelectId));
  }

  public String getMdSelectedItemValueAttributeById(String mdSelectId) {
    return getAttribute(
        f("//md-select[contains(@id,'%s')]//md-option[@selected='selected']", mdSelectId), "value");
  }

  public String getMdSelectValueTrimmed(String mdSelectNgModel) {
    String value = getMdSelectValue(mdSelectNgModel);

    if (value != null) {
      value = value.trim();
    }

    return value;
  }

  public List<String> getMdSelectMultipleValues(String mdSelectNgModel) {
    List<WebElement> listOfWe = findElementsByXpath(
        f("//md-select[@ng-model='%s']/md-select-value/span/div[@class='md-text']",
            mdSelectNgModel));

    if (listOfWe != null) {
      return listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
    }

    return null;
  }

  public List<String> getMdSelectMultipleValuesById(String mdSelectId) {
    List<WebElement> listOfWe = findElementsByXpath(
        f("//md-select[starts-with(@id,'%s')]/md-select-value/span/div[@class='md-text']",
            mdSelectId));

    if (listOfWe != null) {
      return listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
    }

    return null;
  }

  public List<String> getMdSelectMultipleValuesTrimmed(String mdSelectNgModel) {
    List<WebElement> listOfWe = findElementsByXpath(
        f("//md-select[@ng-model='%s']/md-select-value/span/div[@class='md-text']",
            mdSelectNgModel));

    if (listOfWe != null) {
      return listOfWe.stream().map(this::getTextTrimmed).collect(Collectors.toList());
    }

    return null;
  }

  public void inputListBox(String placeHolder, String searchValue) {
    String xpathExpression = f("//input[@placeholder='%s']", placeHolder);
    WebElement we = findElementByXpath(xpathExpression);
    we.clear();
    we.sendKeys(searchValue);
    pause1s();
    we.sendKeys(Keys.RETURN);
    pause100ms();
    closeModal();
  }

  public void closeModal() {
    WebElement we = findElementByXpath("//div[(contains(@class, 'nv-text-ellipsis nv-h4'))]");

    Actions actions = new Actions(getWebDriver());
    actions.moveToElement(we, 5, 5)
        .click()
        .build()
        .perform();
    pause100ms();
  }

  public void searchTable(String keyword) {
    sendKeys("//input[@type='text'][@ng-model='searchText']", keyword);
  }

  public void searchTableCustom1(String columnClass, String keywords) {
    sendKeys(f(".//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/input",
        columnClass), keywords);
    pause400ms();
  }

  public void searchTableCustom2(String columnClass, String keywords) {
    sendKeys(
        f("//th[starts-with(@class, '%s')]/nv-search-input-filter/md-input-container/div/input",
            columnClass), keywords);
    pause200ms();
  }

  public void clearSearchTableCustom1(String columnClass) {
    String xpathExpression = f(
        "//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/button[@aria-hidden='false']",
        columnClass);

    if (isElementExistWait1Second(xpathExpression)) {
      click(xpathExpression);
    }
  }

  public boolean isTableEmpty() {
    return isTableEmpty("");
  }

  public boolean isTableEmpty(String tableXpath) {
    String xpath = tableXpath + "//*[text()='No Results Found']";
    try {
      return isElementVisible(xpath, FAST_WAIT_IN_SECONDS);
    } catch (TimeoutException ex) {
      LOGGER.warn("Table is not empty. XPath: {}", xpath);
      NvAllure.addWarnAttachment(getCurrentMethodName(), "Table is not empty. XPath: %s", xpath);
      return false;
    }
  }

  public void selectAllShown(String nvTableParam) {
    clickf("//nv-table[@param='%s']//button[@aria-label='Selection']", nvTableParam);
    pause100ms();
    clickButtonByAriaLabel("Select All Shown");
    pause100ms();
  }

  private static WebElement findElement(By by, WebDriver webDriver) {
    return webDriver.findElement(by);
  }

  private static WebElement elementIfVisible(WebElement element) {
    return element.isDisplayed() ? element : null;
  }

  public void refreshPage_v1() {
    getWebDriver().navigate().refresh();
  }

  public void refreshPage() {
    acceptAlertDialogIfAppear();
    String previousUrl = getCurrentUrl().toLowerCase();
    getWebDriver().navigate().refresh();
    acceptAlertDialogIfAppear();

    try {
      waitUntil(() ->
      {
        boolean result;
        String currentUrl = getCurrentUrl();
        LOGGER
            .info("refreshPage: Current URL = [{}] - Expected URL = [{}]", currentUrl, previousUrl);

        if (previousUrl.contains("linehaul")) {
          result = currentUrl.contains("linehaul");
        } else {
          result = currentUrl.equalsIgnoreCase(previousUrl);
        }

        return result;
      }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS);
    } catch (NvTestWaitTimeoutException e) {
      throw new RuntimeException(e);
    }

    waitUntilPageLoaded(60);
    if (halfCircleSpinner.isDisplayedFast()) {
      halfCircleSpinner.waitUntilInvisible(60);
    }
    // temporary close /aaa error alert if exist
    if (isElementExist("//button[.='close']", 2)) {
      pause7s();
    }
  }

  public void waitUntilNewWindowOrTabOpened() {
    LOGGER.info("Wait until new window or tab opened.");
    try {
      waitUntil(() -> getWebDriver().getWindowHandles().size() > 1, 50_000,
          f("Window handles size is = %d.", getWebDriver().getWindowHandles().size()));
    } catch (NvTestWaitTimeoutException e) {
      throw new NvTestCoreWindowOrTabNotFoundError("New window or tab not opened", e);
    }
  }

  @SuppressWarnings("unchecked")
  public void switchToOtherWindowAndWaitWhileLoading(String expectedUrlEndWith) {
    retryIfExpectedExceptionOccurred(() -> switchToOtherWindow(expectedUrlEndWith), 4000,
        NvTestRuntimeException.class);
  }

  public void switchToOtherWindowUrlContains(String expectedUrlContains) {
    waitUntilNewWindowOrTabOpened();
    String currentWindowHandle = getWebDriver().getWindowHandle();
    boolean windowFound = false;
    int attempts = 0;

    do {
      pause1s();
      Set<String> windowHandles = getWebDriver().getWindowHandles();
      for (String windowHandle : windowHandles) {
        getWebDriver().switchTo().window(windowHandle);
        String currentWindowUrl = getCurrentUrl();

        if (currentWindowUrl.contains(expectedUrlContains)) {
          windowFound = true;
          break;
        }
      }
      attempts++;
    } while (!windowFound && attempts <= 5);

    if (!windowFound) {
      getWebDriver().switchTo().window(currentWindowHandle);
      throw new NvTestRuntimeException(
          f("Window with URL end with '%s' not found.", expectedUrlContains));
    }
  }

  public void switchToOtherWindow(String expectedUrlEndWith) {
    waitUntilNewWindowOrTabOpened();
    String currentWindowHandle = getWebDriver().getWindowHandle();
    boolean windowFound = false;
    int attempts = 0;

    do {
      pause1s();
      Set<String> windowHandles = getWebDriver().getWindowHandles();
      for (String windowHandle : windowHandles) {
        getWebDriver().switchTo().window(windowHandle);
        String currentWindowUrl = getCurrentUrl();

        if (currentWindowUrl.endsWith(expectedUrlEndWith)) {
          windowFound = true;
          break;
        }
      }
      attempts++;
    } while (!windowFound && attempts <= 5);

    if (!windowFound) {
      getWebDriver().switchTo().window(currentWindowHandle);
      throw new NvTestRuntimeException(
          f("Window with URL end with '%s' not found.", expectedUrlEndWith));
    }
  }

  public String convertTimeFrom24sHourTo12HoursAmPm(String the24HourTime) {
    return StandardTestUtils.convertTimeFrom24sHourTo12HoursAmPm(the24HourTime);
  }

  public void clickMdMenuItem(String parentMenuName, String childMenuName) {
    clickf("//md-menu-bar/md-menu/button[*[contains(text(), '%s')]]", parentMenuName);
    waitUntilVisibilityOfElementLocated("//div[@aria-hidden='false']/md-menu-content");
    clickf(
        "//div[@aria-hidden='false']/md-menu-content/md-menu-item/button/span[contains(text(), '%s')]",
        childMenuName);
  }

  public String getTextById(String id) {
    String xpathExpression = f(XPATH_FOR_MDSELECT_CONTAINS_ID, id);
    String text = getText(xpathExpression).trim();
    return text;
  }

  public String getTextByIdForInputFields(String id) {
    String xpathExpression = f(XPATH_FOR_INPUT_FIELDS_IN_EDIT_RECOVERY, id);
    String text = getText(xpathExpression).trim();
    return text;
  }

  public String getInnerTextByIdForInputFields(String id) {
    String xpathExpression = f(XPATH_FOR_INPUT_FIELDS_IN_EDIT_RECOVERY, id);
    String text = getAttribute(xpathExpression, "innerText").trim();
    return text;
  }

  private void moveAndDoubleClick(WebElement webElement) {
    Actions action = new Actions(getWebDriver());
    action.moveToElement(webElement);
    pause100ms();
    action.doubleClick();
    action.perform();
    pause100ms();
  }

  public void doubleClick(String xpathExpression) {
    WebElement we = findElementByXpath(xpathExpression);
    moveAndDoubleClick(we);
  }

  public String switchToNewWindow() {
    waitUntilNewWindowOrTabOpened();
    String currentWindowHandle = getWebDriver().getWindowHandle();
    Set<String> windowHandles = getWebDriver().getWindowHandles();

    for (String windowHandle : windowHandles) {
      if (!windowHandle.equalsIgnoreCase(currentWindowHandle)) {
        getWebDriver().switchTo().window(windowHandle);
      }
    }

    return currentWindowHandle;
  }

  public void closeDialogIfVisible() {
    String dialogXpath = "//md-dialog";
    if (isElementVisible(dialogXpath, 0)) {
      List<String> closeLocators = ImmutableList.of(
          dialogXpath + "//nv-icon-button[@name='Cancel']",
          dialogXpath + "//nv-icon-text-button[@name='Cancel']",
          dialogXpath + "//button[@aria-label='Leave']",
          dialogXpath + "//button[@aria-label='Leave Anyway']"
      );
      for (String closeLocator : closeLocators) {
        if (isElementVisible(closeLocator, 0)) {
          click(closeLocator);
          waitUntilInvisibilityOfElementLocated(closeLocator);
          break;
        }
      }
      if (isElementVisible(dialogXpath, 0)) {
        try {
          WebElement webElement = findElementByXpath(dialogXpath);
          try {
            executeScript("angular.element(arguments[0]).controller().function.cancel()",
                webElement);
          } catch (Exception ex1) {
            try {
              executeScript("angular.element(arguments[0]).controller().onCancel()", webElement);
            } catch (Exception ex2) {
              executeScript("angular.element(arguments[0]).controller().function.onCancel()",
                  webElement);
            }
          }
          waitUntilInvisibilityOfElementLocated(dialogXpath);
        } catch (Exception ex) {
          refreshPage();
        }
      }
    }
  }
}
