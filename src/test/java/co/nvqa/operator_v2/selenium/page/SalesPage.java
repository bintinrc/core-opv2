package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.SalesPerson;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.util.List;
import java.util.stream.Collectors;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class SalesPage extends OperatorV2SimplePage {

  @FindBy(name = "container.sales-person.create-by-csv-upload")
  public NvIconTextButton createByCsvUpload;

  @FindBy(css = "md-dialog")
  public FindOrdersWithCsvDialog findOrdersWithCsvDialog;

  @FindBy(css = "md-dialog")
  public EditSalesPersonDialog editSalesPersonDialog;

  public SalesPersonsTable salesPersonsTable;

  private static final String SAMPLE_CSV_FILENAME = "sample-data-sales-person-upload.csv";

  public SalesPage(WebDriver webDriver) {
    super(webDriver);
    salesPersonsTable = new SalesPersonsTable(webDriver);
  }

  public void downloadSampleCsvFile() {
    createByCsvUpload.click();
    findOrdersWithCsvDialog.waitUntilVisible();
    findOrdersWithCsvDialog.downloadTemplate.click();
    findOrdersWithCsvDialog.cancel.click();
  }

  public void verifySampleCsvFileDownloadedSuccessfully() {
    verifyFileDownloadedSuccessfully(SAMPLE_CSV_FILENAME, "NAME-A,NA\nNAME-B,NB\nNAME-C,NC");
  }

  public void uploadCsvSales(List<SalesPerson> listOfSalesPerson) {
    createByCsvUpload.click();
    findOrdersWithCsvDialog.waitUntilVisible();

    String csvContents = listOfSalesPerson.stream().map(it -> it.getName() + "," + it.getCode())
        .collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
    File csvFile = createFile(
        f("sample-data-sales-person-upload_%s.csv", generateDateUniqueString()), csvContents);

    findOrdersWithCsvDialog.selectFile.setValue(csvFile);
    findOrdersWithCsvDialog.fileName.waitUntilVisible();
    assertEquals("Uploaded file name", csvFile.getName(),
        findOrdersWithCsvDialog.fileName.getText());
    findOrdersWithCsvDialog.upload.clickAndWaitUntilDone();
  }

  public static class FindOrdersWithCsvDialog extends MdDialog {

    public FindOrdersWithCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "div[translate='container.sales-person.download-template'] a")
    public PageElement downloadTemplate;

    @FindBy(css = "[label='Select File']")
    public NvButtonFilePicker selectFile;

    @FindBy(css = "h5")
    public PageElement fileName;

    @FindBy(name = "commons.cancel")
    public NvIconTextButton cancel;

    @FindBy(name = "commons.upload")
    public NvApiTextButton upload;

    @FindBy(xpath = "//div[@ng-repeat='error in ctrl.payload.errors track by $index']")
    public List<PageElement> errorRecords;
  }

  public static class EditSalesPersonDialog extends MdDialog {

    public EditSalesPersonDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(id = "commons.name")
    public TextBox name;

    @FindBy(id = "commons.code")
    public TextBox code;

    @FindBy(name = "commons.save")
    public NvApiTextButton save;
  }

  public static class SalesPersonsTable extends MdVirtualRepeatTable<SalesPerson> {

    public static final String COLUMN_CODE = "code";
    public static final String COLUMN_NAME = "name";
    public static final String ACTION_EDIT = "edit";

    public SalesPersonsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_CODE, "code")
          .put(COLUMN_NAME, "name")
          .build()
      );
      setEntityClass(SalesPerson.class);
      setActionButtonsLocators(
          ImmutableMap.of(ACTION_EDIT, "container.sales-person.edit-sales-person"));
    }
  }
}