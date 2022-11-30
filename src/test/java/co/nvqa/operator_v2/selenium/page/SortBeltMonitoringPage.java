package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.mm.AntDateTimeRangePicker;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.FluentWait;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SortBeltMonitoringPage extends SimpleReactPage<SortBeltMonitoringPage> {

  @FindBy(xpath = ".//input[@placeholder='Search Hub ID']")
  public TextBox hubIDTextBox;

  @FindBy(xpath = ".//input[@placeholder='Search Device ID']")
  public TextBox deviceIdTextBox;

  @FindBy(xpath = ".//div[contains(@class,'SessionFilters_sessionFilter')]")
  public AntDateTimeRangePicker dateTimeRangePicker;

  @FindBy(css = "li.ant-list-item")
  public List<SessionItem> listSessionItems;

  @FindBy(css = ".ant-list-empty-text")
  public PageElement emptySessionListText;

  @FindBy(css = ".ant-empty")
  public PageElement emptyTrackingListText;

  @FindBy(css = ".ant-skeleton")
  public PageElement loadingIndicator;

  @FindBy(css = ".ant-select-multiple .ant-select-selector")
  public AntSelect3 trackingIDSearchSelect;

  @FindBy(xpath = ".//input[@placeholder='Search Arm ID']")
  public TextBox armIDTextBox;

  @FindBy(css = "div.ant-table tr.ant-table-row td.ant-table-cell:nth-of-type(1)")
  public List<PageElement> trackingIDCells;

  @FindBy(css = "div.ant-table tr.ant-table-row td.ant-table-cell:nth-of-type(2)")
  public List<PageElement> armIDCells;

  private static final Logger LOGGER = LoggerFactory.getLogger(SortBeltMonitoringPage.class);

  public SortBeltMonitoringPage(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  public void waitUntilLoaded() {
    super.waitUntilLoaded();
    loadingIndicator.waitUntilInvisible(10);
  }

  public static class SessionItem extends PageElement {

    @FindBy(xpath = "//li[contains(@class,'ant-list-item')]//div[contains(@class,'sessionItem')]/div[1]/div[1]")
    public PageElement sessionNameText;

    @FindBy(xpath = "//li[contains(@class,'ant-list-item')]//div[contains(@class,'sessionItem')]/div[1]/div[2]")
    public PageElement noOfParcelsText;

    @FindBy(xpath = "//li[contains(@class,'ant-list-item')]//div[contains(@class,'sessionItem')]/div[2]/div[1]")
    public PageElement startTimeText;

    @FindBy(xpath = "//li[contains(@class,'ant-list-item')]//div[contains(@class,'sessionItem')]/div[2]/div[2]")
    public PageElement completedTimeText;

    @FindBy(xpath = "//li[contains(@class,'ant-list-item')]//div[contains(@class,'sessionItem')]/div[3]/div[1]")
    public PageElement hubText;

    @FindBy(xpath = "//li[contains(@class,'ant-list-item')]//div[contains(@class,'sessionItem')]/div[3]/div[2]")
    public PageElement deviceText;

    public SessionItem(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public Date getStartTime() throws ParseException {
      String strStartTime = startTimeText.getText().split("time:")[1];
      return new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(strStartTime);
    }

    public Date getCompletedTime() throws ParseException {
      String strCompletedTime = completedTimeText.getText().split("time:")[1];
      return new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(strCompletedTime);
    }

    private String getSessionName() {
      return sessionNameText.getText();
    }
  }

  public List<String> getListOfTrackingIDs() {
    return trackingIDCells.stream().
        map(PageElement::getText).collect(Collectors.toList());
  }

  public List<String> getListOfArmIDs() {
    return armIDCells.stream().
        map(PageElement::getText).collect(Collectors.toList());
  }

  public void enterHubIDOrName(String value) {
    hubIDTextBox.forceClear();
    hubIDTextBox.sendKeys(value);
    loadingIndicator.waitUntilInvisible(10);
  }

  public void enterDeviceIDOrName(String value) {
    deviceIdTextBox.forceClear();
    deviceIdTextBox.sendKeys(value);
    loadingIndicator.waitUntilInvisible(10);
  }

  public void enterTrackingID(String value) {
    trackingIDSearchSelect.fillSearchTermAndEnter(value);
    loadingIndicator.waitUntilInvisible(10);
  }

  public void enterArmID(String value) {
    armIDTextBox.forceClear();
    armIDTextBox.sendKeys(value);
    loadingIndicator.waitUntilInvisible(10);
  }

  public void setFromDate(String from) {
    dateTimeRangePicker.clearAndSetFromDate(from);
  }

  public void setToDate(String to) {
    dateTimeRangePicker.clearAndSetToDate(to);
  }

  public void clearAllFields() {
    if (StringUtils.isNotBlank(hubIDTextBox.getValue())) {
      hubIDTextBox.forceClear();
    }
    if (StringUtils.isNotBlank(deviceIdTextBox.getValue())) {
      deviceIdTextBox.forceClear();
    }
    if (StringUtils.isNotBlank(dateTimeRangePicker.fromInput.getAttribute("title"))) {
      dateTimeRangePicker.clearFromDate();
    }
    if (StringUtils.isNotBlank(dateTimeRangePicker.toInput.getAttribute("title"))) {
      dateTimeRangePicker.clearToDate();
    }
    if (StringUtils.isNotBlank(armIDTextBox.getValue())) {
      armIDTextBox.forceClear();
    }
    if (!(trackingIDSearchSelect.selectedItems.isEmpty())) {
      trackingIDSearchSelect.removeAllSelected();
    }
  }

  public void selectSessionItemByIndex(int index) {
    listSessionItems.get(index).click();
    loadingIndicator.waitUntilInvisible(10);
  }

  public void selectSessionItemByName(String sessionName) {
    waitForSessionItemDisplayed(sessionName);
    SessionItem session = listSessionItems.stream()
        .filter(item -> StringUtils.equals(item.getSessionName(), sessionName))
        .findFirst().orElseThrow(() -> new IllegalArgumentException(String.format("No session [%s] found", sessionName)));
    session.click();
    loadingIndicator.waitUntilInvisible(10);
  }

  public void waitForSessionItemDisplayed(String sessionName) {
    new FluentWait<>(getWebDriver())
        .pollingEvery(Duration.ofSeconds(5))
        .withTimeout(Duration.ofMinutes(2))
        .ignoring(NoSuchElementException.class)
        .until(webDriver -> {
          LOGGER.info(String.format("Wait for the Session [%s] displayed..", sessionName));
          SessionItem session = listSessionItems.stream()
              .filter(item -> StringUtils.equals(item.getSessionName(), sessionName))
              .findAny().orElse(null);
          if (session != null) {
           LOGGER.info(String.format("The Session [%s] is displayed!!", sessionName));
            return true;
          }
          refreshPage_v1();
          switchTo();
          return false;
        });
  }
}
