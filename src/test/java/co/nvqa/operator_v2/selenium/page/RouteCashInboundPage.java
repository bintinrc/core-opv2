package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntTableV2;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntCalendarPicker;
import com.google.common.collect.ImmutableMap;
import java.time.ZonedDateTime;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.RouteCashInboundPage.RouteCashInboundTable.COLUMN_RECEIPT_NUMBER;

/**
 * @author Sergey Mishanin
 */
public class RouteCashInboundPage extends SimpleReactPage<RouteCashInboundPage> {

  private static final String CSV_FILENAME = "cods.csv";

  @FindBy(xpath = "//div[contains(@class,'ant-picker')][1]")
  public AntCalendarPicker fromDateFilter;

  @FindBy(xpath = "//div[contains(@class,'ant-picker')][2]")
  public AntCalendarPicker toDateFilter;

  @FindBy(xpath = "//button[.='Fetch COD']")
  public Button fetchCod;

  @FindBy(css = "button[data-testid='cod.create']")
  public Button addCod;

  @FindBy(xpath = "//button[.='Download CSV File']")
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
    waitUntilLoaded(2);

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

    Assertions.assertThat(isTableEmpty).as("Table should be empty.").isTrue();
  }

  public void verifyCsvFileDownloadedSuccessfully(RouteCashInboundCod routeCashInboundCod) {
    verifyFileDownloadedSuccessfully(CSV_FILENAME, routeCashInboundCod.getReceiptNumber());
  }

  public void searchAndVerifyTableIsNotEmpty(RouteCashInboundCod routeCashInboundCod) {
    fromDateFilter.setValue(ZonedDateTime.now());
    toDateFilter.setValue(ZonedDateTime.now().plusDays(1));
    fetchCod.click();
    waitUntilLoaded(2);

        /*
          First attempt to check after button 'Fetch COD' is clicked.
         */
    Assertions.assertThat(routeCashInboundTable.isTableEmpty()).as("Table should not be empty.")
        .isFalse();

        /*
          If the table is not empty, then filter table by receiptNo
          and re-verify that the table is not empty.
         */
    routeCashInboundTable
        .filterByColumn(COLUMN_RECEIPT_NUMBER, routeCashInboundCod.getReceiptNumber());
    Assertions.assertThat(routeCashInboundTable.isTableEmpty()).as("Table should not be empty.")
        .isFalse();
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
      setActionButtonsLocators(
          ImmutableMap.of(ACTION_EDIT, "Edit COD", ACTION_DELETE, "Delete COD"));
      setEntityClass(RouteCashInboundCod.class);
    }
  }

  public static class AddCodDialog extends AntModal {

    @FindBy(css = "input[placeholder='Route ID']")
    public ForceClearTextBox routeId;

    @FindBy(css = "input[label='Amount Collected']")
    public ForceClearTextBox amountCollected;

    @FindBy(css = "input[placeholder='Receipt Number']")
    public ForceClearTextBox receiptNumber;

    @FindBy(xpath = ".//button[.='Submit']")
    public AntButton submit;

    public AddCodDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class EditCodDialog extends AntModal {

    @FindBy(css = "[label='Route ID']")
    public ForceClearTextBox routeId;

    @FindBy(css = "[label='Amount Collected']")
    public ForceClearTextBox amountCollected;

    @FindBy(css = "[placeholder='Receipt Number']")
    public ForceClearTextBox receiptNumber;

    @FindBy(css = "[data-testid='cod.edit.submit']")
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
