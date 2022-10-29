package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class StationRouteKeywordPage extends SimpleReactPage<StationRouteKeywordPage> {

  @FindBy(xpath = "//div[./label[.='Select your hub']]//div[contains(@class,'ant-select')]")
  public AntSelect3 hub;

  @FindBy(xpath = ".//button[.='Create new coverage']")
  public Button createNewCoverage;

  @FindBy(css = "label[title='Add keywords']")
  public Button addKeywords;

  @FindBy(css = "label[title='Remove coverage']")
  public Button removeCoverage;

  @FindBy(css = "label[title='Remove keywords']")
  public Button removeKeywords;

  @FindBy(css = "button[data-pa-label='Yes, remove']")
  public Button yesRemove;

  @FindBy(xpath = "(.//div[@data-testid='page-wrapper'])[2]")
  public AddKeywordsTab addKeywordsTab;

  @FindBy(xpath = "(.//div[@data-testid='page-wrapper'])[2]")
  public RemoveKeywordsTab removeKeywordsTab;

  @FindBy(css = ".ant-modal")
  public CreateNewCoverageDialog createNewCoverageDialog;

  @FindBy(css = ".ant-modal")
  public NewCoverageCreatedDialog newCoverageCreatedDialog;

  @FindBy(css = ".ant-modal")
  public TransferDuplicateKeywordsDialog transferDuplicateKeywordsDialog;

  @FindBy(css = ".ant-modal")
  public RemoveKeywordsDialog removeKeywordsDialog;

  public AreasTable areasTable;

  public StationRouteKeywordPage(WebDriver webDriver) {
    super(webDriver);
    areasTable = new AreasTable(webDriver);
  }

  public static class AreasTable extends AntTableV2<Coverage> {

    public static final String COLUMN_AREA = "area";
    public static final String COLUMN_KEYWORDS = "keywords";
    public static final String COLUMN_PRIMARY_DRIVER = "primaryDriver";
    public static final String COLUMN_FALLBACK_DRIVER = "fallbackDriver";

    public static final String ACTION_ACTION = "Action";

    public AreasTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(
          ImmutableMap.<String, String>builder()
              .put(COLUMN_AREA, "area")
              .put(COLUMN_KEYWORDS, "keywordString")
              .put(COLUMN_PRIMARY_DRIVER, "primaryDriverName")
              .put(COLUMN_FALLBACK_DRIVER, "fallbackDriverName")
              .build());
      setEntityClass(Coverage.class);
      setActionButtonsLocators(ImmutableMap.of(ACTION_ACTION, "Action"));
    }
  }

  public static class Coverage extends DataEntity<Coverage> {

    private String area;
    private String primaryDriver;
    private String fallbackDriver;
    private List<String> keywords;

    public Coverage() {
    }

    public Coverage(Map<String, ?> data) {
      super(data);
    }

    public String getArea() {
      return area;
    }

    public void setArea(String area) {
      this.area = area;
    }

    public String getPrimaryDriver() {
      return primaryDriver;
    }

    public void setPrimaryDriver(String primaryDriver) {
      this.primaryDriver = primaryDriver;
    }

    public String getFallbackDriver() {
      return fallbackDriver;
    }

    public void setFallbackDriver(String fallbackDriver) {
      this.fallbackDriver = fallbackDriver;
    }

    public List<String> getKeywords() {
      return keywords;
    }

    public void setKeywords(List<String> keywords) {
      this.keywords = keywords;
    }

    public void setKeywords(String keywords) {
      setKeywords(splitAndNormalize(keywords));
    }
  }

  public static class CreateNewCoverageDialog extends AntModal {

    public CreateNewCoverageDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[./div/label[.='Area']]//input")
    public ForceClearTextBox area;

    @FindBy(xpath = ".//div[./div/label[.='Area Variation']]//textarea")
    public ForceClearTextBox areaVariation;

    @FindBy(xpath = ".//div[./div/label[.='Keyword']]//textarea")
    public ForceClearTextBox keyword;

    @FindBy(xpath = ".//div[./label[.='Primary driver']]//div[contains(@class,'ant-select')]")
    public AntSelect3 primaryDriver;

    @FindBy(xpath = ".//div[./label[.='Fallback driver']]//div[contains(@class,'ant-select')]")
    public AntSelect3 fallbackDriver;

    @FindBy(css = "button[data-pa-label='Add']")
    public Button add;

  }

  public static class NewCoverageCreatedDialog extends AntModal {

    public NewCoverageCreatedDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//table[@data-testid='simple-table']//tr[1]/td[2]")
    public PageElement area;

    @FindBy(xpath = ".//table[@data-testid='simple-table']//tr[2]/td[2]")
    public PageElement primaryDriver;

    @FindBy(xpath = ".//table[@data-testid='simple-table']//tr[3]/td[2]")
    public PageElement fallbackDriver;

    @FindBy(xpath = ".//label[contains(.,'keywords added')]")
    public PageElement keywordsAdded;

    @FindBy(xpath = ".//div[@data-testid='inner-element']//div[@role='gridcell']//span[@class]")
    public List<PageElement> keywords;

    @FindBy(css = "button[data-pa-label='Close']")
    public Button close;

  }

  public static class TransferDuplicateKeywordsDialog extends AntModal {

    public TransferDuplicateKeywordsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[@data-datakey='0']")
    public PageElement area;

    @FindBy(xpath = ".//div[@data-datakey='1']")
    public PageElement keyword;

    @FindBy(xpath = ".//div[@data-datakey='2']")
    public PageElement primaryDriver;

    @FindBy(xpath = ".//div[@data-datakey='3']")
    public PageElement fallbackDriver;

    @FindBy(css = "button[data-pa-label='Back']")
    public Button back;

    @FindBy(css = "button[data-pa-label='No, don\\'t transfer']")
    public Button no;

    @FindBy(css = "button[data-pa-label='Yes, transfer']")
    public Button yes;

  }

  public static class AddKeywordsTab extends PageElement {

    public AddKeywordsTab(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public AddKeywordsTab(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }

    @FindBy(css = "div[data-datakey='data']")
    public List<PageElement> keywords;

    @FindBy(css = "textarea")
    public TextBox newKeywords;

    @FindBy(css = "button[data-pa-label='Save']")
    public Button save;

  }

  public static class RemoveKeywordsTab extends PageElement {

    public RemoveKeywordsTab(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public RemoveKeywordsTab(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }

    @FindBy(css = "div[data-datakey='value']")
    public List<PageElement> keywords;

    @FindBy(css = "div[data-datakey='__checkbox__'] input")
    public List<CheckBox> checkboxes;

    @FindBy(css = "button[data-pa-action='Remove keywords']")
    public Button remove;

  }

  public static class RemoveKeywordsDialog extends AntModal {

    public RemoveKeywordsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "div[data-datakey='0']")
    public List<PageElement> keywords;

    @FindBy(css = "button[data-pa-label='Yes, remove']")
    public Button yes;

  }
}