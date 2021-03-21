package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper_support.AggregatedOrder;
import co.nvqa.commons.model.shipper_support.PricedOrder;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.GmailClient;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.SsbReport;
import co.nvqa.operator_v2.model.SsbShipperReportSg;
import co.nvqa.operator_v2.util.TestConstants;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.WebDriver;

/**
 * @author Kateryna Skakunova
 */
public class OrderBillingPage extends OperatorV2SimplePage {

  private static final String REPORT_ATTACHMENT_FILE_EXTENSION = ".csv";
  private static final String REPORT_ATTACHMENT_NAME_PATTERN = "https://.*ninjavan.*billing.*zip";
  private static final String REPORT_EMAIL_SUBJECT = "Success Billings CSV";

  private static final String FILTER_START_DATE_MDDATEPICKERNGMODEL = "ctrl.data.startDate";
  private static final String FILTER_END_DATE_MDDATEPICKERNGMODEL = "ctrl.data.endDate";
  private static final String FILTER_SHIPPER_SELECTED_SHIPPERS_NVAUTOCOMPLETE_ITEMTYPES = "Shipper";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_NVAUTOCOMPLETE_ITEMTYPES = "Parent Shipper";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_ERROR_MSG = "//md-virtual-repeat-container//li[1]";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_SEARCH_BOX = ".//nv-autocomplete[@item-types='Parent Shipper']//input";
  private static final String FILTER_SHIPPER_SELECTED_SHIPPERS_BUTTON_ARIA_LABEL = "Selected Shippers";
  private static final String FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_BUTTON_ARIA_LABEL = "Select by Parent Shipper";
  private static final String FILTER_GENERATE_FILE_CHECKBOX_PATTERN = "//md-input-container[@label = '%s']/md-checkbox";
  private static final String FILTER_UPLOAD_CSV_ARIA_LABEL = "Upload CSV";
  private static final String FILTER_UPLOAD_CSV_NAME = "commons.upload-csv";
  private static final String FILTER_UPLOAD_CSV_DIALOG_SHIPPER_ID_XPATH = "//md-dialog//h4[text()='Upload Shipper ID CSV']";
  private static final String FILTER_UPLOAD_CSV_DIALOG_DROP_FILES_XPATH = "//md-dialog-content//h4[text()=\"Drop files or click 'Choose' to select files\"]";
  private static final String FILTER_UPLOAD_CSV_DIALOG_CHOSSE_BUTTON_ARIA_LABEL = "Choose";
  private static final String FILTER_UPLOAD_CSV_DIALOG_SAVE_BUTTON_ARIA_LABEL = "Save Button";
  private static final String FILTER_UPLOAD_CSV_DIALOG_FILE_NAME = "//md-dialog//h4//span[contains(text(), '%s')]";

  public static final String SHIPPER_BILLING_REPORT = "Shipper Billing Report";
  public static final String SCRIPT_BILLING_REPORT = "Script Billing Report";
  public static final String AGGREGATED_BILLING_REPORT = "Aggregated Billing Report";

  private final List<AggregatedOrder> csvRowsInAggregatedReport = new ArrayList<>();
  private String csvRowForOrderInShipperReport;
  private String headerLineInShipperReport;
  private final Set<String> shipperIds = new HashSet<>();


  public OrderBillingPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectStartDate(Date startDate) {
    setMdDatepicker(FILTER_START_DATE_MDDATEPICKERNGMODEL, startDate);
  }

  public void selectEndDate(Date endDate) {
    setMdDatepicker(FILTER_END_DATE_MDDATEPICKERNGMODEL, endDate);
  }

  public void setSpecificShipper(String shipper) {
    clickButtonByAriaLabelAndWaitUntilDone(FILTER_SHIPPER_SELECTED_SHIPPERS_BUTTON_ARIA_LABEL);
    selectValueFromNvAutocompleteByItemTypes(
        FILTER_SHIPPER_SELECTED_SHIPPERS_NVAUTOCOMPLETE_ITEMTYPES, shipper);
  }

  public void setParentShipper(String parentShipper) {
    clickButtonByAriaLabelAndWaitUntilDone(
        FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_BUTTON_ARIA_LABEL);
    selectValueFromNvAutocompleteByItemTypesAndDismiss(
        FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_NVAUTOCOMPLETE_ITEMTYPES, parentShipper);
  }

  public void setInvalidParentShipper(String shipper) {
    clickButtonByAriaLabelAndWaitUntilDone(
        FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_BUTTON_ARIA_LABEL);
    sendKeys(FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_SEARCH_BOX, shipper);
  }

  public String getNoParentErrorMsg() {
    return getText(FILTER_SHIPPER_SELECT_BY_PARENT_SHIPPER_ERROR_MSG);
  }

  public void uploadCsvShippers(String shipperIds) {

    int countOfShipperIds = shipperIds.split(",").length;
    File csvFile = createFile("shipper-id-upload.csv", shipperIds);
    NvLogger.info("Path of the created file : " + csvFile.getAbsolutePath());

    clickButtonByAriaLabel(FILTER_UPLOAD_CSV_ARIA_LABEL);
    clickNvIconTextButtonByName(FILTER_UPLOAD_CSV_NAME);

    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_SHIPPER_ID_XPATH);
    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_DROP_FILES_XPATH);
    sendKeysByAriaLabel(FILTER_UPLOAD_CSV_DIALOG_CHOSSE_BUTTON_ARIA_LABEL,
        csvFile.getAbsolutePath());
    waitUntilVisibilityOfElementLocated(f(FILTER_UPLOAD_CSV_DIALOG_FILE_NAME, csvFile.getName()));
    clickButtonByAriaLabel(FILTER_UPLOAD_CSV_DIALOG_SAVE_BUTTON_ARIA_LABEL);

    assertEquals(f("Upload success. Extracted %s Shipper IDs.", countOfShipperIds),
        getToastTopText());
  }

  public void uploadPDFShippersAndVerifyErrorMsg() {
    String pdfFileName = "shipper-id-upload.pdf";
    File pdfFile = createFile(pdfFileName, "TEST");

    clickButtonByAriaLabel(FILTER_UPLOAD_CSV_ARIA_LABEL);
    clickNvIconTextButtonByName(FILTER_UPLOAD_CSV_NAME);

    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_SHIPPER_ID_XPATH);
    waitUntilVisibilityOfElementLocated(FILTER_UPLOAD_CSV_DIALOG_DROP_FILES_XPATH);

    sendKeysByAriaLabel(FILTER_UPLOAD_CSV_DIALOG_CHOSSE_BUTTON_ARIA_LABEL,
        pdfFile.getAbsolutePath());
    String expectedToastText = "\"" + pdfFileName + "\" is not allowed.";
    assertEquals(expectedToastText, getToastTopText());
  }

  public void tickGenerateTheseFilesOption(String option) {
    simpleClick(f(FILTER_GENERATE_FILE_CHECKBOX_PATTERN, option));
  }

  public void setEmailAddress(String emailAddress) {
    sendKeysAndEnterByAriaLabel("Email", emailAddress);
  }


  public void clickGenerateSuccessBillingsButton() {
    clickButtonByAriaLabelAndWaitUntilDone("Generate Success Billings");
  }

  public int getNoOfFilesInZipAttachment(String attachmentUrl, String startDate, String endDate) {
    try (ZipInputStream zipIs = new ZipInputStream(new URL(attachmentUrl).openStream())) {
      int filesNumber = 0;
      ZipEntry zEntry;

      while ((zEntry = zipIs.getNextEntry()) != null) {
        String fileName = zEntry.getName();
        String assertMessage = f(
            "One of the files in Success Billings zip is wrong. Expected to have: startDate = %s, endDate = %s, extension = %s. But was %s",
            startDate, endDate, REPORT_ATTACHMENT_FILE_EXTENSION, fileName);
        assertTrue(assertMessage,
            fileName.contains(startDate) && fileName.contains(endDate) && fileName
                .endsWith(REPORT_ATTACHMENT_FILE_EXTENSION));
        filesNumber++;
      }
      NvLogger.infof("Total number of files in Success Billings - %s", filesNumber);
      return filesNumber;
    } catch (IOException ex) {
      NvLogger.errorf("Could not read file from %s. Cause: %s", attachmentUrl, ex);
      throw new NvTestRuntimeException(ex.getMessage());
    }
  }

  public void markGmailMessageAsRead() {
    GmailClient gmailClient = new GmailClient();
    gmailClient.markUnreadMessagesAsRead();
  }


  public String getOrderBillingAttachmentFromEmail() {
    pause10s();

    GmailClient gmailClient = new GmailClient();
    AtomicBoolean isFound = new AtomicBoolean();

    List<String> attachmentUrlList = new ArrayList<>();
    gmailClient.readUnseenMessage(message ->
    {
      String subject = message.getSubject();
      if (subject.equals(REPORT_EMAIL_SUBJECT) && !isFound.get()) {
        String body = gmailClient.getSimpleContentBody(message);

        Pattern pattern = Pattern.compile(REPORT_ATTACHMENT_NAME_PATTERN);
        Matcher matcher = pattern.matcher(body);

        String attachmentUrl;

        if (matcher.find()) {
          attachmentUrl = matcher.group();
          NvLogger.infof("Success Billings file received in mail - %s", attachmentUrl);
          attachmentUrlList.add(attachmentUrl);
          isFound.set(Boolean.TRUE);
        }
      }
    });

    assertTrue(f("No email with '%s' subject in the mailbox", REPORT_EMAIL_SUBJECT), isFound.get());

    return attachmentUrlList.stream()
        .filter(urlItem -> urlItem.endsWith(".zip"))
        .findFirst()
        .orElseThrow(() -> new IllegalArgumentException("No Zip file in attachment"));
  }

  public String getOrderBillingBodyFromEmail() {
    pause10s();

    GmailClient gmailClient = new GmailClient();
    AtomicBoolean isFound = new AtomicBoolean();

    List<String> bodyMsgList = new ArrayList<>();
    gmailClient.readUnseenMessage(message ->
    {
      if (message.getSubject().equals(REPORT_EMAIL_SUBJECT) && !isFound.get()) {
        String emailBody = gmailClient.getSimpleContentBody(message);
        bodyMsgList.add(emailBody);
        isFound.set(Boolean.TRUE);
      }
    });
    return bodyMsgList.stream()
        .findFirst()
        .orElseThrow(() -> new IllegalArgumentException("No body message in email"));
  }

  public void readOrderBillingCsvAttachment(String attachmentUrl, PricedOrder pricedOrder,
      String reportName) {
    boolean isBodyFound = false;
    String zipName = "order_billing.zip";
    String pathToZip = TestConstants.TEMP_DIR + "order_billing_" + DateUtil.getTimestamp() + "/";
    try {
      FileUtils.copyURLToFile(new URL(attachmentUrl), new File(pathToZip + zipName));
    } catch (IOException ex) {
      throw new NvTestRuntimeException("Could not get file from " + attachmentUrl, ex);
    }

    try (ZipFile zipFile = new ZipFile(pathToZip + zipName)) {
      Enumeration<? extends ZipEntry> entries = zipFile.entries();

      while (entries.hasMoreElements()) {
        ZipEntry entry = entries.nextElement();
        InputStream is = zipFile.getInputStream(entry);
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        boolean isFirstLine = true;
        while (reader.ready()) {
          String line = reader.readLine();
          if (isFirstLine) {
            if (line.startsWith("\ufeff\"Shipper ID")) {
              saveHeaderInCSv(line);
            } else {
              fail(f("Header line is not found in CSV received in email (%s)", attachmentUrl));
            }
            isFirstLine = false;
          } else {
            isBodyFound = true;
            saveBodyInCsv(pricedOrder, reportName, line);
          }
        }
      }
    } catch (IOException ex) {
      throw new NvTestRuntimeException("Could not read from file " + attachmentUrl, ex);
    }
    assertTrue(f("Body is not found in CSV received in email (%s)", attachmentUrl), isBodyFound);
  }

  private void saveBodyInCsv(PricedOrder pricedOrder, String reportName, String line) {
    if (Arrays.asList(SHIPPER_BILLING_REPORT, SCRIPT_BILLING_REPORT).contains(reportName)) {
      shipperIds.add(line.replaceAll("\"", "").split(",")[0]);

      if (Objects.nonNull(pricedOrder) && line.contains(pricedOrder.getTrackingId())) {
        csvRowForOrderInShipperReport = line;
      }
    }
    if (reportName.equals(AGGREGATED_BILLING_REPORT)) {
      List<String> orderDetailList = Arrays.asList(line.replaceAll("\"", "").split(","));
      shipperIds.add(orderDetailList.get(0));

      AggregatedOrder aggregatedOrder = new AggregatedOrder();
      aggregatedOrder.setShipperId(orderDetailList.get(0));
      aggregatedOrder.setShipperName(orderDetailList.get(1));
      aggregatedOrder.setShipperBillingName(orderDetailList.get(2));
      aggregatedOrder.setDeliveryTypeName(orderDetailList.get(3));
      aggregatedOrder.setDeliveryTypeId(orderDetailList.get(4));
      aggregatedOrder.setParcelSize(orderDetailList.get(5));
      aggregatedOrder.setParcelWeight(Double.valueOf(orderDetailList.get(6)));
      aggregatedOrder.setCount(orderDetailList.get(7));
      aggregatedOrder.setCost(orderDetailList.get(8));
      csvRowsInAggregatedReport.add(aggregatedOrder);
    }
  }

  private void saveHeaderInCSv(String headerLine) {
    headerLineInShipperReport = headerLine;
  }

  public PricedOrder pricedOrderCsv(String line) {
    List<String> columnArray = Arrays.stream(line.replaceAll("^\"|\"$", "").split("\",\""))
        .map((value) -> value.equals("") ? null : value)
        .collect(Collectors.toList());

    PricedOrder pricedOrderInCsv = new PricedOrder();
    pricedOrderInCsv
        .setShipperId(integerValue(columnArray.get(SsbReport.SHIPPER_ID.ordinal())));
    pricedOrderInCsv.setShipperName(columnArray.get(SsbReport.SHIPPER_NAME.ordinal()));
    pricedOrderInCsv.setBillingName(columnArray.get(SsbReport.BILLING_NAME.ordinal()));
    pricedOrderInCsv.setTrackingId(columnArray.get(SsbReport.TRACKING_ID.ordinal()));
    pricedOrderInCsv.setShipperOrderRef(columnArray.get(SsbReport.SHIPPER_ORDER_REF.ordinal()));
    pricedOrderInCsv.setGranularStatus(columnArray.get(SsbReport.GRANULAR_STATUS.ordinal()));
    pricedOrderInCsv.setCustomerName(columnArray.get(SsbReport.CUSTOMER_NAME.ordinal()));
    pricedOrderInCsv
        .setDeliveryTypeName(columnArray.get(SsbReport.DELIVERY_TYPE_NAME.ordinal()));
    pricedOrderInCsv
        .setDeliveryTypeId(integerValue(columnArray.get(SsbReport.DELIVERY_TYPE_ID.ordinal())));
    pricedOrderInCsv.setParcelSizeId(columnArray.get(SsbReport.PARCEL_SIZE_ID.ordinal()));
    pricedOrderInCsv
        .setParcelWeight(Double.valueOf(columnArray.get(SsbReport.PARCEL_WEIGHT.ordinal())));
    pricedOrderInCsv.setCreatedTime(columnArray.get(SsbReport.CREATED_TIME.ordinal()));
    pricedOrderInCsv.setDeliveryDate(columnArray.get(SsbReport.DELIVERY_DATE.ordinal()));
    pricedOrderInCsv.setFromCity(columnArray.get(SsbReport.FROM_CITY.ordinal()));
    pricedOrderInCsv.setFromBillingZone(columnArray.get(SsbReport.FROM_BILLING_ZONE.ordinal()));
    pricedOrderInCsv.setOriginHub(columnArray.get(SsbReport.ORIGIN_HUB.ordinal()));
    pricedOrderInCsv.setL1Name(columnArray.get(SsbReport.L1_NAME.ordinal()));
    pricedOrderInCsv.setL2Name(columnArray.get(SsbReport.L2_NAME.ordinal()));
    pricedOrderInCsv.setL3Name(columnArray.get(SsbReport.L3_NAME.ordinal()));
    pricedOrderInCsv.setToAddress(columnArray.get(SsbReport.TO_ADDRESS.ordinal()));
    pricedOrderInCsv.setToPostcode(columnArray.get(SsbReport.TO_POSTCODE.ordinal()));
    pricedOrderInCsv.setToBillingZone(columnArray.get(SsbReport.TO_BILLING_ZONE.ordinal()));
    pricedOrderInCsv.setDestinationHub(columnArray.get(SsbReport.DESTINATION_HUB.ordinal()));
    pricedOrderInCsv
        .setDeliveryFee(bigDecimalValue(columnArray.get(SsbReport.DELIVERY_FEE.ordinal())));
    pricedOrderInCsv
        .setCodCollected(bigDecimalValue(columnArray.get(SsbReport.COD_COLLECTED.ordinal())));
    pricedOrderInCsv.setCodFee(bigDecimalValue(columnArray.get(SsbReport.COD_FEE.ordinal())));
    pricedOrderInCsv
        .setInsuredValue(bigDecimalValue(columnArray.get(SsbReport.INSURED_VALUE.ordinal())));
    pricedOrderInCsv
        .setInsuredFee(bigDecimalValue(columnArray.get(SsbReport.INSURED_FEE.ordinal())));
    pricedOrderInCsv
        .setHandlingFee(bigDecimalValue(columnArray.get(SsbReport.HANDLING_FEE.ordinal())));
    pricedOrderInCsv.setGst(bigDecimalValue(columnArray.get(SsbReport.GST.ordinal())));
    pricedOrderInCsv.setTotal(bigDecimalValue(columnArray.get(SsbReport.TOTAL.ordinal())));
    pricedOrderInCsv.setScriptId(integerValue(columnArray.get(SsbReport.SCRIPT_ID.ordinal())));
    pricedOrderInCsv.setScriptVersion(columnArray.get(SsbReport.SCRIPT_VERSION.ordinal()));
    pricedOrderInCsv
        .setLastCalculatedDate(columnArray.get(SsbReport.LAST_CALCULATED_DATE.ordinal()));
    return pricedOrderInCsv;
  }

  public PricedOrder pricedOrderCsvForSgShipperReport(String line) {
    // size column is removed from "SHIPPER" report for country SG
    List<String> columnArray = Arrays.stream(line.replaceAll("^\"|\"$", "").split("\",\""))
        .map((value) -> value.equals("") ? null : value)
        .collect(Collectors.toList());

    PricedOrder pricedOrderInCsv = new PricedOrder();
    pricedOrderInCsv
        .setShipperId(integerValue(columnArray.get(SsbShipperReportSg.SHIPPER_ID.ordinal())));
    pricedOrderInCsv.setShipperName(columnArray.get(SsbShipperReportSg.SHIPPER_NAME.ordinal()));
    pricedOrderInCsv.setBillingName(columnArray.get(SsbShipperReportSg.BILLING_NAME.ordinal()));
    pricedOrderInCsv.setTrackingId(columnArray.get(SsbShipperReportSg.TRACKING_ID.ordinal()));
    pricedOrderInCsv
        .setShipperOrderRef(columnArray.get(SsbShipperReportSg.SHIPPER_ORDER_REF.ordinal()));
    pricedOrderInCsv
        .setGranularStatus(columnArray.get(SsbShipperReportSg.GRANULAR_STATUS.ordinal()));
    pricedOrderInCsv
        .setCustomerName(columnArray.get(SsbShipperReportSg.CUSTOMER_NAME.ordinal()));
    pricedOrderInCsv
        .setDeliveryTypeName(columnArray.get(SsbShipperReportSg.DELIVERY_TYPE_NAME.ordinal()));
    pricedOrderInCsv.setDeliveryTypeId(
        integerValue(columnArray.get(SsbShipperReportSg.DELIVERY_TYPE_ID.ordinal())));
    pricedOrderInCsv.setParcelWeight(
        Double.valueOf(columnArray.get(SsbShipperReportSg.PARCEL_WEIGHT.ordinal())));
    pricedOrderInCsv.setCreatedTime(columnArray.get(SsbShipperReportSg.CREATED_TIME.ordinal()));
    pricedOrderInCsv
        .setDeliveryDate(columnArray.get(SsbShipperReportSg.DELIVERY_DATE.ordinal()));
    pricedOrderInCsv.setFromCity(columnArray.get(SsbShipperReportSg.FROM_CITY.ordinal()));
    pricedOrderInCsv
        .setFromBillingZone(columnArray.get(SsbShipperReportSg.FROM_BILLING_ZONE.ordinal()));
    pricedOrderInCsv.setOriginHub(columnArray.get(SsbShipperReportSg.ORIGIN_HUB.ordinal()));
    pricedOrderInCsv.setL1Name(columnArray.get(SsbShipperReportSg.L1_NAME.ordinal()));
    pricedOrderInCsv.setL2Name(columnArray.get(SsbShipperReportSg.L2_NAME.ordinal()));
    pricedOrderInCsv.setL3Name(columnArray.get(SsbShipperReportSg.L3_NAME.ordinal()));
    pricedOrderInCsv.setToAddress(columnArray.get(SsbShipperReportSg.TO_ADDRESS.ordinal()));
    pricedOrderInCsv.setToPostcode(columnArray.get(SsbShipperReportSg.TO_POSTCODE.ordinal()));
    pricedOrderInCsv
        .setToBillingZone(columnArray.get(SsbShipperReportSg.TO_BILLING_ZONE.ordinal()));
    pricedOrderInCsv
        .setDestinationHub(columnArray.get(SsbShipperReportSg.DESTINATION_HUB.ordinal()));
    pricedOrderInCsv.setDeliveryFee(
        bigDecimalValue(columnArray.get(SsbShipperReportSg.DELIVERY_FEE.ordinal())));
    pricedOrderInCsv.setCodCollected(
        bigDecimalValue(columnArray.get(SsbShipperReportSg.COD_COLLECTED.ordinal())));
    pricedOrderInCsv
        .setCodFee(bigDecimalValue(columnArray.get(SsbShipperReportSg.COD_FEE.ordinal())));
    pricedOrderInCsv.setInsuredValue(
        bigDecimalValue(columnArray.get(SsbShipperReportSg.INSURED_VALUE.ordinal())));
    pricedOrderInCsv.setInsuredFee(
        bigDecimalValue(columnArray.get(SsbShipperReportSg.INSURED_FEE.ordinal())));
    pricedOrderInCsv.setHandlingFee(
        bigDecimalValue(columnArray.get(SsbShipperReportSg.HANDLING_FEE.ordinal())));
    pricedOrderInCsv.setGst(bigDecimalValue(columnArray.get(SsbShipperReportSg.GST.ordinal())));
    pricedOrderInCsv
        .setTotal(bigDecimalValue(columnArray.get(SsbShipperReportSg.TOTAL.ordinal())));
    pricedOrderInCsv
        .setScriptId(integerValue(columnArray.get(SsbShipperReportSg.SCRIPT_ID.ordinal())));
    pricedOrderInCsv
        .setScriptVersion(columnArray.get(SsbShipperReportSg.SCRIPT_VERSION.ordinal()));
    pricedOrderInCsv.setLastCalculatedDate(
        columnArray.get(SsbShipperReportSg.LAST_CALCULATED_DATE.ordinal()));

    return pricedOrderInCsv;
  }

  public List<AggregatedOrder> getAggregatedOrdersFromCsv() {
    return csvRowsInAggregatedReport;
  }

  public Set<String> getShipperIdsInCsv() {
    return shipperIds;
  }

  public String getOrderFromCsv() {
    return csvRowForOrderInShipperReport;
  }

  public String getHeaderLine() {
    return headerLineInShipperReport;
  }

  private BigDecimal bigDecimalValue(String value) {
    return (value != null && !value.equals("")) ? new BigDecimal(value) : null;
  }

  private Integer integerValue(String value) {
    return (value != null && !value.equals("")) ? Integer.valueOf(value) : null;
  }

  public void verifyNoErrorsAvailable() {
    if (toastErrors.size() > 0) {
      fail(f("Error on attempt to generate email: %s", toastErrors.get(0).toastBottom.getText()));
    }
  }

}
