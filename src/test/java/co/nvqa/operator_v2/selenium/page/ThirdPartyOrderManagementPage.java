package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.ThirdPartyOrderMapping;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import org.junit.platform.commons.util.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class ThirdPartyOrderManagementPage extends OperatorV2SimplePage {

  @FindBy(css = "md-dialog")
  public DeleteThirdPartyOrderDialog deleteThirdPartyOrderDialog;

  @FindBy(css = "md-dialog")
  public EditMappingDialog editMappingDialog;

  @FindBy(css = "md-dialog")
  public UploadSingleMappingDialog uploadSingleMappingDialog;

  @FindBy(css = "md-dialog")
  public UploadBulkMappingDialog uploadBulkMappingDialog;

  @FindBy(name = "container.third-party-order.create-single-mapping")
  public NvIconTextButton uploadSingle;

  @FindBy(name = "container.third-party-order.create-multiple-mapping")
  public NvIconTextButton uploadBulk;

  @FindBy(name = "commons.load-orders")
  public NvApiTextButton loadOrders;

  @FindBy(css = "md-progress-linear")
  public PageElement loadingBar;

  private static final String MD_VIRTUAL_REPEAT = "order in getTableData()";

  public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking-id";
  public static final String COLUMN_CLASS_DATA_THIRD_PARTY_TRACKING_ID = "third-party-order-third-party-tracking-id";
  public static final String COLUMN_CLASS_DATA_SHIPPER_NAME = "third-party-order-third-party-shipper-name";

  public static final String ACTION_BUTTON_EDIT = "commons.edit";
  public static final String ACTION_BUTTON_DELETE = "commons.delete";
  public static final String ACTION_BUTTON_COMPLETE = "container.third-party-order.complete-order";
  public static final String CONFIRM_BUTTON_ARIA_LABEL = "Confirm";

  public UploadResultsPage uploadResultsPage;

  public ThirdPartyOrderManagementPage(WebDriver webDriver) {
    super(webDriver);
    uploadResultsPage = new UploadResultsPage(webDriver);
  }

  public void uploadSingleMapping(ThirdPartyOrderMapping thirdPartyOrderMapping) {
    uploadSingle.click();
    uploadSingleMappingDialog.waitUntilVisible();
    uploadSingleMappingDialog.trackingId.setValue(thirdPartyOrderMapping.getTrackingId());
    uploadSingleMappingDialog.thirdPartyTrackingId
        .setValue(thirdPartyOrderMapping.getThirdPlTrackingId());
    if (StringUtils.isBlank(thirdPartyOrderMapping.getShipperName())) {
      thirdPartyOrderMapping.setShipperName(uploadSingleMappingDialog.idSelect.getValue());
      thirdPartyOrderMapping
          .setShipperId(uploadSingleMappingDialog.idSelect.getSelectedValueAttribute());
    } else {
      uploadSingleMappingDialog.idSelect
          .searchAndSelectValue(thirdPartyOrderMapping.getShipperName());
    }
    uploadSingleMappingDialog.submit.clickAndWaitUntilDone();
  }

  public void adjustAvailableThirdPartyShipperData(ThirdPartyOrderMapping thirdPartyOrderMapping) {
    uploadSingle.click();
    uploadSingleMappingDialog.waitUntilVisible();
    thirdPartyOrderMapping.setShipperName(uploadSingleMappingDialog.idSelect.getValue());
    thirdPartyOrderMapping
        .setShipperId(uploadSingleMappingDialog.idSelect.getSelectedValueAttribute());
    refreshPage();
  }

  public void uploadBulkMapping(List<ThirdPartyOrderMapping> thirdPartyOrderMappings) {
    String csvContents = thirdPartyOrderMappings.stream().map(ThirdPartyOrderMapping::toCsvLine)
        .collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
    File csvFile = createFile(
        String.format("third-party-order-mappings-with-csv_%s.csv", generateDateUniqueString()),
        csvContents);
    uploadBulk.click();
    uploadBulkMappingDialog.waitUntilVisible();
    uploadBulkMappingDialog.chooseButton.setValue(csvFile);
    uploadBulkMappingDialog.submit.clickAndWaitUntilDone();
  }

  public void verifyOrderMappingCreatedSuccessfully(ThirdPartyOrderMapping expectedOrderMapping) {
    uploadResultsPage.verifyUploadResultsData(expectedOrderMapping);
    refreshPage();
    loadOrders();
    verifyOrderMappingRecord(expectedOrderMapping);
  }

  public void verifyMultipleOrderMappingCreatedSuccessfully(
      List<ThirdPartyOrderMapping> expectedOrderMappings) {
    uploadResultsPage.verifyUploadResultsData(expectedOrderMappings);
    refreshPage();
    loadOrders();
    verifyOrderMappingRecords(expectedOrderMappings);
  }

  public void verifyOrderMappingRecord(ThirdPartyOrderMapping expectedOrderMapping) {
    searchTableByTrackingIdUntilFound(expectedOrderMapping.getTrackingId());
    assertEquals("Third Party Order Tracking ID", expectedOrderMapping.getTrackingId(),
        getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID));
    assertEquals("Third Party Order 3PL Tracking ID", expectedOrderMapping.getThirdPlTrackingId(),
        getTextOnTable(1, COLUMN_CLASS_DATA_THIRD_PARTY_TRACKING_ID));
    assertEquals("Third Party Order 3PL Provider", expectedOrderMapping.getShipperName(),
        getTextOnTable(1, COLUMN_CLASS_DATA_SHIPPER_NAME));
  }

  public void verifyOrderMappingRecords(List<ThirdPartyOrderMapping> expectedOrderMappings) {
    expectedOrderMappings.forEach(this::verifyOrderMappingRecord);
  }

  public void editOrderMapping(ThirdPartyOrderMapping thirdPartyOrderMapping) {
    searchTableByTrackingId(thirdPartyOrderMapping.getTrackingId());
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
    editMappingDialog.waitUntilVisible();
    editMappingDialog.thirdPartyTrackingId.setValue(thirdPartyOrderMapping.getThirdPlTrackingId());
    editMappingDialog.idSelect.searchAndSelectValue(thirdPartyOrderMapping.getShipperName());
    editMappingDialog.submitChanges.clickAndWaitUntilDone();
    editMappingDialog.waitUntilInvisible();
    String toastMessage = String
        .format("%s mapped to %s(%s)!", thirdPartyOrderMapping.getTrackingId(),
            thirdPartyOrderMapping.getThirdPlTrackingId(), thirdPartyOrderMapping.getShipperName());
    waitUntilInvisibilityOfToast(toastMessage, true);
  }

  public void deleteThirdPartyOrderMapping(ThirdPartyOrderMapping thirdPartyOrderMapping) {
    searchTableByTrackingId(thirdPartyOrderMapping.getTrackingId());
    clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
    deleteThirdPartyOrderDialog.confirmDelete();
    waitUntilInvisibilityOfToast("Third Party Order Deleted", true);
  }

  public void completeThirdPartyOrder(ThirdPartyOrderMapping thirdPartyOrderMapping) {
    searchTableByTrackingId(thirdPartyOrderMapping.getTrackingId());
    clickActionButtonOnTable(1, ACTION_BUTTON_COMPLETE);
    pause100ms();
    clickButtonOnMdDialogByAriaLabel(CONFIRM_BUTTON_ARIA_LABEL);
    String toastMessage = "Completed Order";
    waitUntilInvisibilityOfToast(toastMessage);
  }

  public void verifyThirdPartyOrderMappingWasRemoved(ThirdPartyOrderMapping thirdPartyOrderMapping,
      String message) {
    searchTableByTrackingId(thirdPartyOrderMapping.getTrackingId());
    boolean isTableEmpty = isTableEmpty();
    message = "Third Party Order Mapping still exist in table. " + message;
    assertTrue(message, isTableEmpty);
  }

  public void searchTableByTrackingId(String trackingId) {
    searchTableCustom1(COLUMN_CLASS_DATA_TRACKING_ID, trackingId);
  }

  public void searchTableByTrackingIdUntilFound(String trackingId) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      searchTableByTrackingId(trackingId);
      boolean isTableEmpty = isTableEmpty();

      if (isTableEmpty) {
        refreshPage();
        throw new NvTestRuntimeException(
            "Table is empty. Tracking ID not found. Refreshing Third Party Order Management page.");
      }
    }, getCurrentMethodName());
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
  }

  public void loadOrders() {
    loadOrders.clickAndWaitUntilDone();
    if (loadingBar.waitUntilVisible(1)) {
      loadingBar.waitUntilInvisible();
    }
  }

  public static class UploadSingleMappingDialog extends MdDialog {

    @FindBy(css = "[id^='commons.model.tracking-id']")
    public TextBox trackingId;

    @FindBy(css = "[id^='commons.model.third-party-tracking-id']")
    public TextBox thirdPartyTrackingId;

    @FindBy(css = "[id^='commons.id']")
    public MdSelect idSelect;

    @FindBy(name = "Submit")
    public NvButtonSave submit;

    public UploadSingleMappingDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class UploadBulkMappingDialog extends MdDialog {

    @FindBy(css = "[label='Choose']")
    NvButtonFilePicker chooseButton;

    @FindBy(name = "Submit")
    public NvButtonSave submit;

    public UploadBulkMappingDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class EditMappingDialog extends MdDialog {

    @FindBy(css = "[id^='commons.model.third-party-tracking-id']")
    public TextBox thirdPartyTrackingId;

    @FindBy(css = "[id^='commons.id']")
    public MdSelect idSelect;

    @FindBy(name = "Submit Changes")
    public NvButtonSave submitChanges;

    public EditMappingDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class UploadResultsPage extends OperatorV2SimplePage {

    private static final String DIALOG_LOCATOR = "//md-dialog[contains(@class,'third-party-order-add-result')]";
    private static final String BUTTON_CLOSE_NAME = "Cancel";

    public UploadResultsPage(WebDriver webDriver) {
      super(webDriver);
    }

    public List<ThirdPartyOrderMapping> readMappingUploadResults() {
      waitUntilVisibilityOfElementLocated(DIALOG_LOCATOR);
      String xpathForCounting = DIALOG_LOCATOR + "//table/tbody/tr[not(@class='ng-hide')]";
      String cellLocatorTemplate = xpathForCounting + "[%d]/td[%d]";
      int recordsCount = getElementsCount(By.xpath(xpathForCounting));
      List<ThirdPartyOrderMapping> orderMappings = new ArrayList<>();

      for (int rowIndex = 1; rowIndex <= recordsCount; rowIndex++) {
        ThirdPartyOrderMapping orderMapping = new ThirdPartyOrderMapping();
        String locator = String.format(cellLocatorTemplate, rowIndex, 1);
        orderMapping.setTrackingId(getText(locator));
        locator = String.format(cellLocatorTemplate, rowIndex, 2);
        orderMapping.setShipperId(Integer.parseInt(getText(locator)));
        locator = String.format(cellLocatorTemplate, rowIndex, 3);
        orderMapping.setThirdPlTrackingId(getText(locator));
        locator = String.format(cellLocatorTemplate, rowIndex, 4);
        orderMapping.setStatus(getText(locator));
        orderMappings.add(orderMapping);
      }

      return orderMappings;
    }

    public void verifyUploadResultsData(ThirdPartyOrderMapping expectedOrderMapping) {
      verifyUploadResultsData(Collections.singletonList(expectedOrderMapping));
    }

    public void verifyUploadResultsData(List<ThirdPartyOrderMapping> expectedOrderMappings) {
      List<ThirdPartyOrderMapping> orderMappings = readMappingUploadResults();
      assertEquals("Unexpected number of created order mappings", expectedOrderMappings.size(),
          orderMappings.size());

      for (int i = 0; i < expectedOrderMappings.size(); i++) {
        ThirdPartyOrderMapping expectedOrderMapping = expectedOrderMappings.get(i);
        ThirdPartyOrderMapping actualOrderMapping = orderMappings.get(i);
        assertEquals("Upload Results dialog: Third Party Order [" + i + 1 + "] Tracking ID",
            expectedOrderMapping.getTrackingId(), actualOrderMapping.getTrackingId());
        assertEquals("Upload Results dialog: Third Party Order [" + i + 1 + "] 3PL Tracking ID",
            expectedOrderMapping.getThirdPlTrackingId(), actualOrderMapping.getThirdPlTrackingId());
        assertEquals("Upload Results dialog: Third Party Order [" + i + 1 + "] 3PL Shipper ID",
            expectedOrderMapping.getShipperId(), actualOrderMapping.getShipperId());
        assertEquals("Upload Results dialog: Third Party Order [" + i + 1 + "] Upload Status",
            expectedOrderMapping.getStatus(), actualOrderMapping.getStatus());
      }
    }

    public void closeDialog() {
      clickNvIconButtonByName(BUTTON_CLOSE_NAME);
    }
  }

  public static class DeleteThirdPartyOrderDialog extends MdDialog {

    public DeleteThirdPartyOrderDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "button[aria-label='Confirm']")
    public Button confirm;

    public void confirmDelete() {
      waitUntilVisible();
      pause1s();
      confirm.click();
      waitUntilInvisible();
    }
  }
}