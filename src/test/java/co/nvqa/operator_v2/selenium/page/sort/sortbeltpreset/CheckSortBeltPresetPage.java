package co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.List;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class CheckSortBeltPresetPage extends SimpleReactPage<CheckSortBeltPresetPage> {

  @FindBy(css = "[data-testid='edit-button']")
  public Button editButton;

  @FindBy(xpath = "//div[@class='preset-criteria-table']//tbody/tr")
  public List<CriteriaElement> criteriaElements;

  public CheckSortBeltPresetPage(WebDriver webDriver) {
    super(webDriver);
  }

  public static class CriteriaElement extends PageElement {

    @FindBy(xpath = "./td[1]")
    public PageElement criteria;
    @FindBy(xpath = "./td[2]")
    public PageElement description;
    @FindBy(xpath = "./td[3]")
    public PageElement filterType;
    @FindBy(xpath = "./td[4]")
    public PageElement filterValue;

    public CriteriaElement(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public CriteriaElement(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

  }
}
