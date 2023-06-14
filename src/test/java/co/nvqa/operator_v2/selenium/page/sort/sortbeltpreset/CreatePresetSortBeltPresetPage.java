package co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntMenu;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.List;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class CreatePresetSortBeltPresetPage extends
    SimpleReactPage<CreatePresetSortBeltPresetPage> {

  @FindBy(css = "[data-testid='cancel-button']")
  public Button cancelBtn;
  @FindBy(css = "[data-icon='loading']")
  public PageElement loadingIcon;
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

  @FindBy(xpath = "//div[contains(@class, 'title')]")
  public PageElement title;

  public CreatePresetSortBeltPresetPage(WebDriver webDriver) {
    super(webDriver);
  }


  public static class CriteriaCard extends PageElement {

    public static String SELECTOR_XPATH = ".//form[.//label[text()='%s']]//div[contains(concat(' ',normalize-space(@class),' '),'logic-selection-field')]";
    public static String INCLUDE_SELECTOR_XPATH = ".//form[.//label[text()='%s']]//div[contains(concat(' ',normalize-space(@class),' '),' ant-select ')][1]";
    public static final String FILTER_OPTION = "//div[contains(@class, 'ant-dropdown') and not(contains(@class, 'ant-dropdown-hidden'))]//li[@ data-testid ='%s']";

    @FindBy(css = "[data-testid='criteria-description']")
    public TextBox description;
    @FindBy(css = "[data-testid='add-filter-button']")
    public AntMenu addFilterMenu;
    @FindBy(css = ".remove-button")
    public Button clearBtn;
    @FindBy(xpath = "//div[contains(@class, 'ant-dropdown') and not(contains(@class, 'ant-dropdown-hidden'))]//li[@ data-testid ='%s']")
    public AntMenu filterOption;

    public CriteriaCard(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public CriteriaCard(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String getFilterTestId(String fields) {
      String filterDataId = null;
      switch (fields) {
        case "Order Tag":
          filterDataId = "menu-tags";
          break;
        case "DP IDs":
          filterDataId = "menu-dp_ids";
          break;
        case "Zones":
          filterDataId = "menu-zones";
          break;
        case "Destination Hub":
          filterDataId = "menu-dest_hub_ids";
          break;
        case "Granular Status":
          filterDataId = "menu-granular_statuses";
          break;
        case "RTS":
          filterDataId = "menu-rts";
          break;
        case "Service Level":
          filterDataId = "menu-service_levels";
          break;
        case "Shipper":
          filterDataId = "menu-shipper_ids";
          break;
        case "Master Shipper":
          filterDataId = "menu-master_shipper_ids";
          break;
        case "Transaction End Day":
          filterDataId = "menu-txn_end_in_days";
          break;
      }
      return filterDataId;
    }


  }
}
