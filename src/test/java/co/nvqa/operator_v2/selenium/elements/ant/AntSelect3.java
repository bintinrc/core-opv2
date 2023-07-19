package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.apache.commons.lang3.StringUtils.normalizeSpace;

public class AntSelect3 extends PageElement {

  public AntSelect3(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntSelect3(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  public AntSelect3(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntSelect3(WebDriver webDriver, SearchContext searchContext, String xpath) {
    super(webDriver, searchContext, xpath);
  }

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(css = ".ant-select-selection-item")
  public List<PageElement> selectedValues;

  @FindBy(css = ".ant-select-selection-item")
  public PageElement selectedValue;

  @FindBy(css = ".ant-select-selection-placeholder")
  public PageElement selectionPlaceholder;

  @FindBy(css = ".ant-select-selection-item")
  public List<SelectedItem> selectedItems;

  @FindBy(css = ".ant-select-selection-search-input")
  public ForceClearTextBox searchInput;

  @FindBy(css = ".ant-select-clear > span")
  public PageElement clearIcon;

  private Boolean isMultiple;
  private static final Logger LOGGER = LoggerFactory.getLogger(AntSelect3.class);

  private boolean isMultiple() {
    if (isMultiple == null) {
      isMultiple = StringUtils.contains(getAttribute("class"), "ant-select-multiple");
    }
    return isMultiple;
  }

  public void selectValue(String value) {
    if (!StringUtils.equals(value, getValue())) {
      enterSearchTerm(value);
      clickMenuItem(value);
      pause500ms();
      closeMenu();
    }
  }

  public void selectValues(Iterable<String> values) {
    clearValue();
    values.forEach(v -> {
      enterSearchTerm(v);
      clickMenuItem(v);
    });
    closeMenu();
  }

  public void selectByIndex(int index) {
    openMenu();
    clickMenuItemByIndex(index);
    closeMenu();
  }

  public void selectValueWithoutSearch(String value) {
    if (!StringUtils.equals(getValue(), value)) {
      openMenu();
      clickMenuItem(value);
      closeMenu();
    }
  }

  public void clickMenuItem(String value) {
    String xpath = getItemEqualsLocator(value);
    if (isElementVisible(xpath, 1)) {
      click(xpath);
    } else {
      xpath = getItemIgnoreCaseLocator(value);
      if (isElementVisible(xpath, 1)) {
        click(xpath);
      } else {
        xpath = getItemContainsLocator(value);
        if (isElementVisible(xpath, 1)) {
          click(xpath);
        } else {
          xpath = getItemValueLocator(value);
          click(xpath);
        }
      }
    }
  }

  public void clickMenuItemByIndex(int index) {
    String xpath = getItemIndexLocator(index);
    click(xpath);
  }

  public void clearValue() {
    if (StringUtils.isNotBlank(getValue())) {
      openMenu();
      if (clearIcon.isDisplayedFast()) {
        clearIcon.click();
      } else {
        searchInput.forceClear();
      }
      closeMenu();
    }
  }

  public void removeSelected(List<String> items) {
    selectedItems.stream().filter(i -> items.contains(i.getContent()))
        .forEach(SelectedItem::remove);
  }

  public void removeSelected(String item) {
    removeSelected(Collections.singletonList(item));
  }

  public void removeAllSelected() {
    selectedItems.forEach(SelectedItem::remove);
  }

  private String getItemIndexLocator(int index) {
    return getListBoxLocator() + "//div[@class='rc-virtual-list-holder-inner']/div[" + index + "]";
  }

  private String getItemContainsLocator(String value) {
    return getListBoxLocator()
        + "//div[@class='rc-virtual-list-holder-inner']//*[contains(normalize-space(@title),'"
        + normalizeSpace(value) + "')]";
  }
  private String getItemValueLocator(String value) {
    return getListBoxLocator() + "//div[@class='rc-virtual-list-holder-inner']/div[div[contains(@class, 'ant-select-item-option-content')  and .//*[contains(text(), '"+ value +"')]]]";
  }

  private String getItemEqualsLocator(String value) {
    return getListBoxLocator()
        + "//div[@class='rc-virtual-list-holder-inner']//*[normalize-space(@title)='"
        + normalizeSpace(
        value) + "']";
  }

  private String getItemIgnoreCaseLocator(String value) {
    return getListBoxLocator()
        + "//div[@class='rc-virtual-list-holder-inner']//*[normalize-space(translate(@title, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))='"
        + normalizeSpace(value.toLowerCase(Locale.ROOT)) + "']";
  }

  private String getListBoxLocator() {
    String listId = searchInput.isDisplayedFast() ?
        searchInput.getAttribute("aria-owns") : searchInput.getAttribute("aria-controls");
    return "//div[./div/div[@id='" + listId + "']]";
  }

  private void openMenu() {
    String listBoxLocator = getListBoxLocator();
    if (!isElementVisible(listBoxLocator, 0)) {
      searchInput.moveAndClick();
    }
    if (!isElementVisible(listBoxLocator, 0)) {
      searchInput.click();
    }

  }

  public void closeMenu() {
    String listBoxLocator = getListBoxLocator();
    try {
      waitUntilInvisibilityOfElementLocated(listBoxLocator, 1);
    } catch (Exception ignored) {
    }
    if (isElementVisible(listBoxLocator, 0)) {
      jsClick();
    }
    if (isElementVisible(listBoxLocator, 0)) {
      new Actions(getWebDriver()).sendKeys(Keys.ESCAPE).perform();
    }
    try {
      waitUntilInvisibilityOfElementLocated(listBoxLocator, 1);
    } catch (Exception ex) {
      LOGGER.error(ex.toString());
    }
  }

  public void enterSearchTerm(String value) {
    searchInput.setValue(value);
    waitUntilLoaded();
  }

  public void fillSearchTermAndEnter(String value) {
    searchInput.sendKeysAndEnterNoXpath(value);
  }

  public String getValue() {
    return selectedValue.isDisplayedFast() ? selectedValue.getAttribute("title")
        : selectionPlaceholder.isDisplayed() ? selectionPlaceholder.getText() : null;
  }

  public List<String> getValues() {
    return selectedValues.stream().map(e -> e.getAttribute("title")).collect(Collectors.toList());
  }

  public boolean hasItem(String value) {
    openMenu();
    return isElementExistFast(getItemContainsLocator(value));
  }

  public static class SelectedItem extends PageElement {

    public SelectedItem(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public SelectedItem(WebDriver webDriver, String xpath) {
      super(webDriver, xpath);
    }

    public SelectedItem(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }

    public SelectedItem(WebDriver webDriver, SearchContext searchContext, String xpath) {
      super(webDriver, searchContext, xpath);
    }

    @FindBy(css = ".ant-select-selection-item-content")
    public PageElement content;

    @FindBy(css = ".ant-select-selection-item-remove")
    public PageElement remove;

    public String getContent() {
      return content.getText();
    }

    public void remove() {
      remove.click();
    }

  }

  public void waitUntilEnabled() {
    searchInput.waitUntilClickable();
  }

  private void waitUntilLoaded() {
    if (spinner.waitUntilVisible(1)) {
      spinner.waitUntilInvisible();
    }
  }
}