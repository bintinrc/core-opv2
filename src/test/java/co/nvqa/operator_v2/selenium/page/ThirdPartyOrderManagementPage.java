package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestRuntimeException;
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
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
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

  @FindBy(name = "Download CSV File")
  public NvApiTextButton downloadCsvFile;

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

  public ThirdPartyOrderManagementPage(WebDriver webDriver) {
    super(webDriver);
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
    String csvContents =
        "\"NV Tracking ID\",\"Third Party Shipper ID\",\"Third Party Tracking Id\"\n" +
            thirdPartyOrderMappings.stream().map(ThirdPartyOrderMapping::toCsvLine)
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
    uploadSingleMappingDialog.waitUntilVisible();
    pause2s();
    ThirdPartyOrderMapping actualOrderMappings = uploadSingleMappingDialog.uploadResultsTable
        .readEntity(1);
    expectedOrderMapping.compareWithActual(actualOrderMappings, "shipperName");
    refreshPage();
    loadOrders();
    verifyOrderMappingRecord(expectedOrderMapping);
  }

  public void verifyMultipleOrderMappingCreatedSuccessfully(
      List<ThirdPartyOrderMapping> expectedOrderMappings) {
    uploadBulkMappingDialog.waitUntilVisible();
    pause2s();
    List<ThirdPartyOrderMapping> actualOrderMappings = uploadBulkMappingDialog.uploadResultsTable
        .readAllEntities();
    for (int i = 0; i < expectedOrderMappings.size(); i++) {
      expectedOrderMappings.get(i).compareWithActual(actualOrderMappings.get(i), "shipperName");
    }
    refreshPage();
    loadOrders();
    verifyOrderMappingRecords(expectedOrderMappings);
  }

  public void verifyOrderMappingRecord(ThirdPartyOrderMapping expectedOrderMapping) {
    searchTableByTrackingIdUntilFound(expectedOrderMapping.getTrackingId());
    Assertions.assertThat(getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID))
        .as("Third Party Order Tracking ID").isEqualTo(expectedOrderMapping.getTrackingId());
    Assertions.assertThat(getTextOnTable(1, COLUMN_CLASS_DATA_THIRD_PARTY_TRACKING_ID))
        .as("Third Party Order 3PL Tracking ID")
        .isEqualTo(expectedOrderMapping.getThirdPlTrackingId());
    Assertions.assertThat(StringUtils.trim(getTextOnTable(1, COLUMN_CLASS_DATA_SHIPPER_NAME)))
        .as("Third Party Order 3PL Provider")
        .isEqualTo(StringUtils.trim(expectedOrderMapping.getShipperName()));
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
    Assertions.assertThat(isTableEmpty).as(message).isTrue();
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
      loadingBar.waitUntilInvisible(60);
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

    public UploadResultsTable uploadResultsTable;

    public UploadSingleMappingDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      uploadResultsTable = new UploadResultsTable(webDriver);
    }

    public static class UploadResultsTable extends NgRepeatTable<ThirdPartyOrderMapping> {

      public static final String NG_REPEAT = "row in result";

      public UploadResultsTable(WebDriver webDriver) {
        super(webDriver);
        setNgRepeat(NG_REPEAT);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put("trackingId", "//td[1]")
            .put("shipperId", "//td[2]")
            .put("thirdPlTrackingId", "//td[3]")
            .put("status", "/td[4]")
            .build());
        setEntityClass(ThirdPartyOrderMapping.class);
      }
    }
  }

  public static class UploadBulkMappingDialog extends MdDialog {

    @FindBy(css = "[label='Choose']")
    NvButtonFilePicker chooseButton;

    @FindBy(name = "Submit")
    public NvButtonSave submit;

    public UploadSingleMappingDialog.UploadResultsTable uploadResultsTable;

    public UploadBulkMappingDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      uploadResultsTable = new UploadSingleMappingDialog.UploadResultsTable(webDriver);
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