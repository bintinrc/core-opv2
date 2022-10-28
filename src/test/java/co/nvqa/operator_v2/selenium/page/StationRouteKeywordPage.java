package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
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

  @FindBy(css = ".ant-modal")
  public CreateNewCoverageDialog createNewCoverageDialog;

  @FindBy(css = ".ant-modal")
  public NewCoverageCreatedDialog newCoverageCreatedDialog;
  public AreasTable areasTable;

  public StationRouteKeywordPage(WebDriver webDriver) {
    super(webDriver);
    areasTable = new AreasTable(webDriver);
  }

  public static class AreasTable extends AntTableV2<Coverage> {

    public static final String COLUMN_AREA = "area";

    public static final String ACTION_ACTION = "Action";

    public AreasTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(
          ImmutableMap.<String, String>builder()
              .put(COLUMN_AREA, "area")
              .put("keywords", "keywordString")
              .put("primaryDriverName", "primaryDriverName")
              .put("fallbackDriverName", "fallbackDriverName")
              .build());
      setEntityClass(Coverage.class);
      setActionButtonsLocators(ImmutableMap.of(ACTION_ACTION, "Action"));
    }
  }

  public static class Coverage extends DataEntity<Coverage> {

    private String area;
    private String primaryDriverName;
    private String fallbackDriverName;
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

    public String getPrimaryDriverName() {
      return primaryDriverName;
    }

    public void setPrimaryDriverName(String primaryDriverName) {
      this.primaryDriverName = primaryDriverName;
    }

    public String getFallbackDriverName() {
      return fallbackDriverName;
    }

    public void setFallbackDriverName(String fallbackDriverName) {
      this.fallbackDriverName = fallbackDriverName;
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

    @FindBy(xpath = ".//div[@data-testid='inner-element']//div[@role='gridcell']//span[@class]")
    public List<PageElement> keywords;

    @FindBy(css = "button[data-pa-label='Close']")
    public Button close;

  }
}