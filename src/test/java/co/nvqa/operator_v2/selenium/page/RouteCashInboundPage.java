package co.nvqa.operator_v2.selenium.page;

import static co.nvqa.operator_v2.selenium.page.RouteCashInboundPage.RouteCashInboundTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.RouteCashInboundPage.RouteCashInboundTable.COLUMN_RECEIPT_NUMBER;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class RouteCashInboundPage extends OperatorV2SimplePage {

  private static final String CSV_FILENAME = "cods.csv";
  private static final String XPATH_OF_TOAST_ERROR_MESSAGE = "//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-bottom']/strong[4]";

  @FindBy(name = "fromDateField")
  public MdDatepicker fromDateFilter;

  @FindBy(name = "toDateField")
  public MdDatepicker toDateFilter;

  @FindBy(name = "container.cod-list.cod-get")
  public NvApiTextButton fetchCod;

  @FindBy(css = "md-dialog")
  public ConfirmDeleteDialog confirmDeleteDialog;

  public RouteCashInboundTable routeCashInboundTable;

  public RouteCashInboundPage(WebDriver webDriver) {
    super(webDriver);
    routeCashInboundTable = new RouteCashInboundTable(webDriver);
  }

  public void addCod(RouteCashInboundCod routeCashInboundCod) {
    clickNvIconTextButtonByName("Add COD");
    waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'cod-add')]");
    fillTheFormAndSubmit(routeCashInboundCod);
    waitUntilToastErrorDisappear();
  }

  public void editCod(RouteCashInboundCod routeCashInboundCodOld,
      RouteCashInboundCod routeCashInboundCodEdited) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      searchAndVerifyTableIsNotEmpty(routeCashInboundCodOld);
      routeCashInboundTable.clickActionButton(1, ACTION_EDIT);
      waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'cod-edit')]");
      fillTheFormAndSubmit(routeCashInboundCodEdited);

      try {
        WebElement toastErrorMessageWe = waitUntilVisibilityOfElementLocated(
            XPATH_OF_TOAST_ERROR_MESSAGE, FAST_WAIT_IN_SECONDS);
        String toastErrorMessage = toastErrorMessageWe.getText();
        NvLogger.warnf("Error when submitting COD on Route Cash Inbound page. Cause: %s",
            toastErrorMessage);
        waitUntilToastErrorDisappear();
        closeModal();

                /*
                  If toast error message found, that's means updated the zone is failed.
                  Throw runtime exception so the code will retry again until success or max retry is reached.
                 */
        throw new NvTestRuntimeException(toastErrorMessage);
      } catch (TimeoutException ex) {
                /*
                  If TimeoutException occurred that means the toast error message is not found
                  and that means zone is updated successfully.
                 */
        NvLogger.infof("Expected exception occurred. Cause: %s", ex.getMessage());
      }
    });
  }

  public void fillTheFormAndSubmit(RouteCashInboundCod routeCashInboundCod) {
    sendKeysById("route-id", String.valueOf(routeCashInboundCod.getRouteId()));
    sendKeysById("amount-collected", String.valueOf(routeCashInboundCod.getAmountCollected()));
    sendKeysById("receipt-number", routeCashInboundCod.getReceiptNumber());
    clickNvButtonSaveByNameAndWaitUntilDone("Submit");
  }

  public void verifyNewCodIsCreatedSuccessfully(RouteCashInboundCod routeCashInboundCod) {
    searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
    verifyCodInfoIsCorrect(routeCashInboundCod);
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
    confirmDeleteDialog.confirmDelete();
  }

  public void verifyCodIsDeletedSuccessfully(RouteCashInboundCod routeCashInboundCod) {
    fetchCod.clickAndWaitUntilDone();

        /*
          First attempt to check after button 'Fetch COD' is clicked.
         */
    boolean isTableEmpty = routeCashInboundTable.isTableEmpty();

    if (!isTableEmpty) {
            /*
              If the table is not empty, then filter table by receiptNo
              and re-verify that the table is empty.
             */
      routeCashInboundTable
          .filterByColumn(COLUMN_RECEIPT_NUMBER, routeCashInboundCod.getReceiptNumber());
      isTableEmpty = routeCashInboundTable.isTableEmpty();
    }

    assertTrue("Table should be empty.", isTableEmpty);
  }

  public void downloadCsvFile() {
    clickNvApiTextButtonByName("Download CSV File");
  }

  public void verifyCsvFileDownloadedSuccessfully(RouteCashInboundCod routeCashInboundCod) {
    verifyFileDownloadedSuccessfully(CSV_FILENAME, routeCashInboundCod.getReceiptNumber());
  }

  public void clickButtonFetchCod() {
    clickNvApiTextButtonByNameAndWaitUntilDone("container.cod-list.cod-get");
  }

  public void searchAndVerifyTableIsNotEmpty(RouteCashInboundCod routeCashInboundCod) {
    fromDateFilter.setDate(TestUtils.getNextDate(0));
    toDateFilter.setDate(TestUtils.getNextDate(1));
    fetchCod.clickAndWaitUntilDone();

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

  public void waitUntilToastErrorDisappear() {
    waitUntilInvisibilityOfToast("Cannot read property", false);
  }

  public static class RouteCashInboundTable extends MdVirtualRepeatTable<RouteCashInboundCod> {

    public static final String COLUMN_ROUTE_ID = "routeId";
    public static final String COLUMN_TOTAL_COLLECTED = "totalCollected";
    public static final String COLUMN_AMOUNT_COLLECTED = "amountCollected";
    public static final String COLUMN_RECEIPT_NUMBER = "receiptNumber";
    public static final String ACTION_EDIT = "edit";
    public static final String ACTION_DELETE = "delete";

    public RouteCashInboundTable(WebDriver webDriver) {
      super(webDriver);
      setMdVirtualRepeat("cod in getTableData()");
      setColumnLocators(ImmutableMap.of(
          COLUMN_ROUTE_ID, "route_id",
          COLUMN_TOTAL_COLLECTED, "total_collected",
          COLUMN_AMOUNT_COLLECTED, "amount_collected",
          COLUMN_RECEIPT_NUMBER, "receipt_no"
      ));
      setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "Edit", ACTION_DELETE, "Delete"));
      setEntityClass(RouteCashInboundCod.class);
    }
  }
}
