package co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class SortBeltPresetDetailPage extends SimpleReactPage<SortBeltPresetDetailPage> {

  @FindBy(css = ".title")
  public PageElement presetTitle;

  @FindBy(css = "[data-testid='cancel-button']")
  public Button cancelBtn;

  @FindBy(css = "[data-testid='edit-button']")
  public Button editButton;

  @FindBy(css = ".preset-details")
  public PageElement description;

  @FindBy(xpath = "//tr[contains(@class,'ant-table-row')]")
  public List<CriteriaTableRow> rows;


  public SortBeltPresetDetailPage(WebDriver webDriver) {
    super(webDriver);
  }

  public static class CriteriaTableRow extends PageElement {

    @FindBy(xpath = "./td")
    public List<PageElement> tableCells;

    public CriteriaTableRow(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public CriteriaTableRow(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String getTitle() {
      if (isCriteriaRow()) {
        PageElement pe = tableCells.get(0);
        return pe.getText();
      }
      return null;
    }

    public String getDescription() {
      if (isCriteriaRow()) {
        PageElement pe = tableCells.get(1);
        return pe.getText();
      }
      return null;
    }

    public String getFilterType() {
      PageElement pe;
      if (isCriteriaRow()) {
        pe = tableCells.get(2);
        return pe.getText();
      }
      pe = tableCells.get(0);
      return pe.getText();
    }

    public String getFilterValue() {
      WebElement pe;
      if (isCriteriaRow()) {
        pe = this.findElement(By.xpath("./td[4]"));
        return pe.getText();
      }
      pe = this.findElement(By.xpath("./td[2]"));
      return pe.getText();
    }
    public boolean isCriteriaRow() {
      return tableCells.size() == 4;
    }
  }
}
