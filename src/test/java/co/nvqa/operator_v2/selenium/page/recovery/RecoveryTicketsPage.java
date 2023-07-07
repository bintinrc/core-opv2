package co.nvqa.operator_v2.selenium.page.recovery;

import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.page.AntTableV2;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class RecoveryTicketsPage extends SimpleReactPage<RecoveryTicketsPage> {

  @FindBy(css = "[data-testid='btn-create-new-ticket-csv']")
  public Button createByCsv;

  @FindBy(xpath = "//div[@class='ant-modal-content']")
  public creatByCSVDialog creatByCSVDialog;

  @FindBy(css = "[data-testid='btn-find-ticket-csv']")
  public Button findByCsv;

  @FindBy(xpath = "//div[@class='ant-modal-content']")
  public FindTicketsByCSVDialog findTicketsByCSVDialog;
  public ResultsTable resultsTable;

  public RecoveryTicketsPage(WebDriver webDriver) {
    super(webDriver);
    resultsTable = new ResultsTable(webDriver);
  }

  public static class creatByCSVDialog extends AntModal {

    @FindBy(xpath = "//div[@class='ant-modal-title']")
    public PageElement title;

    @FindBy(xpath = "//input[@placeholder='Search' and @class='ant-input']")
    public List<PageElement> search;

    @FindBy(xpath = "//input[@type='file']")
    public FileInput fileUpload;

    @FindBy(xpath = "//button/span[.='Upload File']")
    public Button uploadFile;

    @FindBy(xpath = "//div[@class='ant-modal-body']/div[@class='ant-row']")
    public List<PageElement> message;

    @FindBy(xpath = "//div[@class='ant-modal-footer']//h4")
    public PageElement displayedUploadedFileName;

    @FindBy(xpath = "//button/span[.='Download Template']")
    public Button downloadTemplate;

    @FindBy(xpath = "//button/span[.='Done']")
    public Button done;

    @FindBy(xpath = "//button/span[.='Download Error Data']")
    public Button downloadErrorData;

    @FindBy(xpath = "//button/span[.='Upload Another File']")
    public Button uploadAnotherFile;

    @FindBy(xpath = "//button/span[.='Proceed With Valid Data']")
    public Button proceedWithValidData;

    public String typeRowResult = "//tbody//tr//td[contains(.,'%s')]";
    public static final String SAMPLE_CSV_FILENAME_PATTERN = "ticketing-csv-template.csv";
    public static final String ERROR_DATA_CSV_FILE_NAME = "invalid-data.csv";

    public creatByCSVDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void searchByTicketType(String value) {
      search.get(0).sendKeys(value);
      Assertions.assertThat(findElement(By.xpath(f(typeRowResult, value))).getText())
          .as("correct search results - ticket type").isEqualToIgnoringCase(value);
    }

    public void searchByEntrySource(String value) {
      search.get(1).sendKeys(value);
      Assertions.assertThat(findElement(By.xpath(f(typeRowResult, value))).getText())
          .as("correct search results - entry source").isEqualToIgnoringCase(value);
    }

    public void searchByInvestigationDept(String value) {
      search.get(2).sendKeys(value);
      Assertions.assertThat(findElement(By.xpath(f(typeRowResult, value))).getText())
          .as("correct search results - Investigation dept").isEqualToIgnoringCase(value);
    }

    public void generateNoHeadersFile() {
      String csvContents = "NV012345,MI,FLT-LM,1";
      File csvFile = createFile("No Headers File.csv", csvContents);
      fileUpload.setValue(csvFile);
    }
  }

  public static class FindTicketsByCSVDialog extends AntModal {

    @FindBy(xpath = "//div[@class='ant-modal-title']")
    public PageElement title;

    @FindBy(xpath = "//input[@type='file']")
    public FileInput uploadComponent;

    @FindBy(css = "[data-testid='btn-find-search']")
    public Button search;

    @FindBy(xpath = "//div[@class='ant-row error-desc']")
    public PageElement errorMessage;

    @FindBy(xpath = "//div[@class='ant-row']/ul/li")
    public PageElement invalidTrackingId;

    @FindBy(xpath = "//button[@class='ant-btn ant-btn-default']")
    public Button loadSelection;

    public FindTicketsByCSVDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ResultsTable extends AntTableV2<RecoveryTicket> {

    @FindBy(css = "[data-datakey='trackingId']")
    public PageElement trackingId;

    @FindBy(css = "[data-datakey='orderGranularStatus']")
    public PageElement orderGranularStatus;

    @FindBy(css = "[data-datakey='ticketTypeSubType']")
    public PageElement ticketType;

    public static final String ACTION_EDIT = "Edit";

    public ResultsTable(WebDriver webDriver) {
      super(webDriver);
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("daysSince", "daysSince")
          .put("created", "created")
          .put("redTickets", "redTickets")
          .put("ticketType/subType", "ticketType/subType")
          .put("status", "status")
          .put("assignee", "assignee")
          .put("investigationDept", "investigationDept")
          .put("investigationHub", "investigationHub")
          .put("investigationName", "investigationName")
          .put("trackingId", "trackingId")
          .put("shipper", "shipper")
          .put("orderGranularStatus", "orderGranularStatus")
          .put("ticketCreator", "ticketCreator")
          .build()
      );
      setEntityClass(RecoveryTicket.class);
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT, "//button[@data-pa-action='Edit Hub Missing Investigation']"
      ));
    }
  }
}
