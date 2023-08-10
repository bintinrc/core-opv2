package co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.List;
import org.junit.jupiter.api.Assertions;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class SortBeltPresetPage extends SimpleReactPage<SortBeltPresetPage> {

  @FindBy(css = ".ant-list-empty-text")
  public PageElement emptyTableIndicator;

  private String SEARCHED_PRESET_NAME_XPATH = "//div[@class='title'][contains(text(),'%s')]";
  @FindBy(css = ".ant-skeleton")
  public PageElement loadingIndicator;

  @FindBy(css = "[data-testid='create-new-menu-item']")
  public PageElement createNewMenu;

  @FindBy(css = "[data-testid='create-a-copy-menu-item']")
  public PageElement createACopyMenu;

  @FindBy(xpath = "//input[@placeholder='Search Name or Description']")
  public TextBox searchInput;

  @FindBy(xpath = "//div[@class='ant-empty-description']")
  public PageElement noData;
  @FindBy(css = "[data-testid='create-preset-button']")
  public Button createPresetBtn;

  @FindBy(xpath = "//li[@class='ant-list-item']")
  public List<SBPresetListElement> listItems;

  @FindBy(css = ".ant-modal")
  public PresetBaseModal presetBaseModal;


  public SortBeltPresetPage(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  public void waitUntilLoaded() {
    super.waitUntilLoaded();
    loadingIndicator.waitUntilInvisible(60);
  }

  public void assertSortBeltCreated(String name, String isExist) {
    searchInput.forceClear();
    searchInput.sendKeys(name);
    String xpath = f(SEARCHED_PRESET_NAME_XPATH,name);
    if (isExist.equalsIgnoreCase("not exist")) {
      Assertions.assertTrue(noData.isDisplayed());
    } else {
      Assertions.assertTrue(findElementByXpath(xpath).isDisplayed());
    }
  }


  public static class SBPresetListElement extends PageElement {

    public SBPresetListElement(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public SBPresetListElement(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }


    @FindBy(xpath = "//div[@class='title']")
    public PageElement title;

    @FindBy(xpath = "//div[@class='description']")
    public PageElement description;

  }

  public static class PresetBaseModal extends AntModal {

    @FindBy(xpath = ".//div[contains(@class,'ant-select')]")
    public AntSelect presetBaseSelect;

    @FindBy(css = "[data-testid='confirm-button']")
    public Button confirmBtn;

    public PresetBaseModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public PresetBaseModal(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
  }

}
