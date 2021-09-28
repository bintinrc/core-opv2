package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntCalendarPicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.RouteCashInboundPage.RouteCashInboundTable.COLUMN_RECEIPT_NUMBER;

/**
 * @author Sergey Mishanin
 */
public class RouteCashInboundPage extends SimpleReactPage {

  private static final String CSV_FILENAME = "cods.csv";

  @FindBy(css = ".date-picker-container:nth-of-type(1)")
  public AntCalendarPicker fromDateFilter;

  @FindBy(css = ".date-picker-container:nth-of-type(2)")
  public AntCalendarPicker toDateFilter;

  @FindBy(xpath = "//button[.='Fetch COD']")
  public Button fetchCod;

  @FindBy(css = "div.cod-top-button-row > button")
  public Button addCod;

  @FindBy(xpath = "//button[.='Download CSV']")
  public Button downloadCsv;

  @FindBy(css = ".ant-modal")
  public AddCodDialog addCodDialog;

  @FindBy(css = ".ant-modal")
  public EditCodDialog editCodDialog;

  @FindBy(css = ".ant-modal")
  public DeleteCodDialog confirmDeleteDialog;

  public RouteCashInboundTable routeCashInboundTable;

  public RouteCashInboundPage(WebDriver webDriver) {
    super(webDriver);
    routeCashInboundTable = new RouteCashInboundTable(webDriver);
  }

  public void verifyFilterWorkFine(RouteCashInboundCod routeCashInboundCod) {
    searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
    verifyCodInfoIsCorrect(routeCashInboundCod);
  }

  public void verifyCodIsUpdatedSuccessfully(RouteCashInboundCod routeCashInboundCod) {
    searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
    verifyCodInfoIsCorrect(routeCashInboundCod);
  }

  public void verifyCodInfoIsCorrect(RouteCashInboundCod expected) {
    RouteCashInboundCod actual = routeCashInboundTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  public void deleteCod(RouteCashInboundCod routeCashInboundCod) {
    searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
    routeCashInboundTable.clickActionButton(1, RouteCashInboundTable.ACTION_DELETE);
    confirmDeleteDialog.delete.click();
  }

  public void verifyCodIsDeletedSuccessfully(RouteCashInboundCod routeCashInboundCod) {
    fetchCod.click();

        /*
          First attempt to check after button 'Fetch COD' is clicked.
         */
    boolean isTableEmpty = routeCashInboundTable.isEmpty();

    if (!isTableEmpty) {
            /*
              If the table is not empty, then filter table by receiptNo
              and re-verify that the table is empty.
             */
      routeCashInboundTable
          .filterByColumn(COLUMN_RECEIPT_NUMBER, routeCashInboundCod.getReceiptNumber());
      pause2s();
      isTableEmpty = routeCashInboundTable.isEmpty();
    }

    assertTrue("Table should be empty.", isTableEmpty);
  }

  public void verifyCsvFileDownloadedSuccessfully(RouteCashInboundCod routeCashInboundCod) {
    verifyFileDownloadedSuccessfully(CSV_FILENAME, routeCashInboundCod.getReceiptNumber());
  }

  public void searchAndVerifyTableIsNotEmpty(RouteCashInboundCod routeCashInboundCod) {
    fromDateFilter.setValue(TestUtils.getNextDate(0));
    toDateFilter.setValue(TestUtils.getNextDate(1));
    fetchCod.click();
    waitUntilLoaded(2);

        /*
          First attempt to check after button 'Fetch COD' is clicked.
         */
    assertFalse("Table should not be empty.", routeCashInboundTable.isTableEmpty());

        /*
          If the table is not empty, then filter table by receiptNo
          and re-verify that the table is not empty.
         */
    routeCashInboundTable
        .filterByColumn(COLUMN_RECEIPT_NUMBER, routeCashInboundCod.getReceiptNumber());
    assertFalse("Table should not be empty.", routeCashInboundTable.isTableEmpty());
  }

  public static class RouteCashInboundTable extends AntTableV2<RouteCashInboundCod> {

    public static final String COLUMN_ROUTE_ID = "routeId";
    public static final String COLUMN_TOTAL_COLLECTED = "totalCollected";
    public static final String COLUMN_AMOUNT_COLLECTED = "amountCollected";
    public static final String COLUMN_RECEIPT_NUMBER = "receiptNumber";
    public static final String ACTION_EDIT = "edit";
    public static final String ACTION_DELETE = "delete";

    public RouteCashInboundTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.of(
          COLUMN_ROUTE_ID, "routeID",
          COLUMN_TOTAL_COLLECTED, "totalCollected",
          COLUMN_AMOUNT_COLLECTED, "amountCollected",
          COLUMN_RECEIPT_NUMBER, "receiptNumber"
      ));
      setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "edit", ACTION_DELETE, "delete"));
      setEntityClass(RouteCashInboundCod.class);
    }
  }

  public static class AddCodDialog extends AntModal {

    @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][./div[text()='Route ID']]//input")
    public TextBox routeId;

    @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][./div[text()='Amount Collected']]//input")
    public TextBox amountCollected;

    @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][./div[text()='Receipt Number']]//input")
    public TextBox receiptNumber;

    @FindBy(xpath = ".//button[.='Submit']")
    public AntButton submit;

    public AddCodDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class EditCodDialog extends AntModal {

    @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][./div[text()='Route ID']]//input")
    public TextBox routeId;

    @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][./div[text()='Amount Collected']]//input")
    public TextBox amountCollected;

    @FindBy(xpath = ".//div[contains(@class,'nv-input-field')][./div[text()='Receipt Number']]//input")
    public TextBox receiptNumber;

    @FindBy(xpath = ".//button[.='Submit']")
    public AntButton submit;

    public EditCodDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class DeleteCodDialog extends AntModal {

    @FindBy(xpath = ".//button[.='Delete']")
    public AntButton delete;

    public DeleteCodDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
