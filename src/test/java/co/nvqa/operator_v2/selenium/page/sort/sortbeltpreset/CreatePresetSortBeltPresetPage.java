package co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntMenu;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.List;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class CreatePresetSortBeltPresetPage extends SimpleReactPage<CreatePresetSortBeltPresetPage> {

  @FindBy(css = "[data-testid='cancel-button']")
  public Button cancelBtn;
  @FindBy(css = "[data-testid='next-button']")
  public Button nextBtn;
  @FindBy(css = "[data-testid='add-criteria-button']")
  public Button addCriteriaBtn;
  @FindBy(css = "[data-testid='preset-name-input']")
  public TextBox presetName;
  @FindBy(css = "[data-testid='preset-description-input']")
  public TextBox description;
  @FindBy(css = ".preset-card-container")
  public List<CriteriaCard> cards;

  @FindBy(css = ".ant-notification")
  public AntNotification notification;

  public CreatePresetSortBeltPresetPage(WebDriver webDriver) {
    super(webDriver);
  }


  public static class CriteriaCard extends PageElement {
    @FindBy(css = "[data-testid='criteria-description']")
    public TextBox description;

    @FindBy(css = "[data-testid='add-filter-button']")
    public AntMenu addFilterMenu;

    @FindBy(css=".ant-select")
    public List<AntSelect> selectInputs;

    @FindBy(css = ".remove-button")
    public Button clearBtn;

    public CriteriaCard(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public CriteriaCard(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }


  }
}
