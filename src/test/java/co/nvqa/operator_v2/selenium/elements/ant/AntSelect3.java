package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

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

  @FindBy(css = ".ant-select-selection-item")
  public List<PageElement> selectedValues;

  @FindBy(css = ".ant-select-selection-item")
  public PageElement selectedValue;

  @FindBy(css = ".ant-select-selection-item")
  public List<SelectedItem> selectedItems;

  @FindBy(css = ".ant-select-selection-search-input")
  public TextBox searchInput;

  @FindBy(css = ".ant-select-clear > span")
  public PageElement clearIcon;

  public void selectValue(String value) {
    if (!StringUtils.equals(value, getValue())) {
      enterSearchTerm(value);
      clickMenuItem(value);
    }
  }

  public void selectValues(Iterable<String> values) {
    values.forEach(this::selectValue);
  }

  public void selectByIndex(int index) {
    openMenu();
    clickMenuItemByIndex(index);
  }

  public void selectValueWithoutSearch(String value) {
    openMenu();
    clickMenuItem(value);
  }

  public void clickMenuItem(String value) {
    String xpath = getItemEqualsLocator(value);
    if (isElementVisible(xpath, 1)) {
      click(xpath);
    } else {
      xpath = getItemContainsLocator(value);
      click(xpath);
    }
  }

  public void clickMenuItemByIndex(int index) {
    String xpath = getItemIndexLocator(index);
    click(xpath);
  }

  public void clearValue() {
    openMenu();
    if (clearIcon.isDisplayedFast()) {
      clearIcon.click();
    } else {
      searchInput.forceClear();
    }
  }

  public void removeSelected(List<String> items) {
    selectedItems.stream()
        .filter(i -> items.contains(i.getContent()))
        .forEach(SelectedItem::remove);
  }

  public void removeSelected(String item) {
    removeSelected(Collections.singletonList(item));
  }

  private String getItemIndexLocator(int index) {
    return getListBoxLocator() + "/div[" + index + "]";
  }

  private String getItemContainsLocator(String value) {
    return getListBoxLocator() + "/div[contains(normalize-space(@title),'"
        + StringUtils.normalizeSpace(value) + "')]";
  }

  private String getItemEqualsLocator(String value) {
    return getListBoxLocator() + "/div[normalize-space(@title)='" + StringUtils.normalizeSpace(
        value) + "']";
  }

  private String getListBoxLocator() {
    String listId = searchInput.getAttribute("aria-owns");
    return "//div[./div[@id='" + listId + "']]//div[@class='rc-virtual-list-holder-inner']";
  }

  private void openMenu() {
    if (!isElementVisible(getListBoxLocator(), 0)) {
      searchInput.click();
    }
  }

  public void enterSearchTerm(String value) {
    searchInput.sendKeys(value);
    pause500ms();
  }

  public String getValue() {
    return selectedValue.isDisplayedFast() ?
        selectedValue.getAttribute("title") :
        null;
  }

  public List<String> getValues() {
    return selectedValues.stream()
        .map(e -> e.getAttribute("title"))
        .collect(Collectors.toList());
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
}