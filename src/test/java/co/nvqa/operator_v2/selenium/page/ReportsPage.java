package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.util.Box;
import co.nvqa.commons.util.GmailClient;
import co.nvqa.commons.util.NvTestRuntimeException;
import java.util.Date;
import java.util.concurrent.atomic.AtomicBoolean;
import javax.mail.internet.MimeMultipart;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import org.apache.commons.io.IOUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * @author Niko Susanto
 */
@SuppressWarnings("WeakerAccess")
public class ReportsPage extends OperatorV2SimplePage {

  private static final String CSV_FILENAME_PATTERN = "cod-report";

  private static final String NG_REPEAT = "cod in $data";
  public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
  public static final String COLUMN_CLASS_DATA_GRANULAR_STATUS = "granular_status";
  public static final String COLUMN_CLASS_DATA_SHIPPER_NAME = "shipper_name";
  public static final String COLUMN_CLASS_DATA_GOODS_AMOUNT = "goods_amount";

  public ReportsPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void filterCodReportsBy(String mode, Date date) {
    clickToggleButton("ctrl.codReport.mode", mode);
    setMdDatepicker("ctrl.codReport.date", date);
  }

  public void generateCodReports() {
    click("//md-card[.//span[text()=\"COD Report\"]]//nv-api-text-button");

    // The Toast is not disappear automatically, so no need to wait for it.
    //waitUntilInvisibilityOfToast("COD report is being prepared", false);

    pause5s();
  }

  public void codReportsAttachment() {
    pause5s();
    GmailClient gmailClient = new GmailClient();

    AtomicBoolean isFound = new AtomicBoolean();
    Box<String> csvUrl = new Box<>();

    gmailClient.readUnseenMessage(message ->
    {
      String subject = message.getSubject();

      if (subject.equals("[Report] COD") && !isFound.get()) {
        isFound.set(Boolean.TRUE);

        DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = builderFactory.newDocumentBuilder();
        String docTypeHtml = "<!DOCTYPE html [\n    <!ENTITY nbsp \"&#160;\"> \n]>";
        String html =
            docTypeHtml + ((MimeMultipart) message.getContent()).getBodyPart(1).getContent()
                .toString();
        Document xmlDocument = builder.parse(IOUtils.toInputStream(html, "UTF-8"));
        xmlDocument.normalizeDocument();

        XPath xPath = XPathFactory.newInstance().newXPath();

        Element el = (Element) xPath.compile("//td[text()='Attachments']/following-sibling::td")
            .evaluate(xmlDocument, XPathConstants.NODE);
        csvUrl.setValue(el.getTextContent());
      }
    });
  }

  public void verifyOrderIsExistWithCorrectInfo(Order order) {
    int indexOfOrderInTable = findOrderRowIndexInTable(order.getTrackingId());
    moveToElementWithXpath(
        String.format("//tr[@ng-repeat='%s'][%d]", NG_REPEAT, indexOfOrderInTable));

    String actualTrackingId = getTextOnTable(indexOfOrderInTable, COLUMN_CLASS_DATA_TRACKING_ID);
    String actualGranularStatus = getTextOnTable(indexOfOrderInTable,
        COLUMN_CLASS_DATA_GRANULAR_STATUS);
    String actualShipperName = getTextOnTable(indexOfOrderInTable, COLUMN_CLASS_DATA_SHIPPER_NAME);
    Double actualGoodsAmount = Double
        .parseDouble(getTextOnTable(indexOfOrderInTable, COLUMN_CLASS_DATA_GOODS_AMOUNT));

    assertEquals("Tracking ID", order.getTrackingId(), actualTrackingId);
    assertThat("Granular Status", actualGranularStatus,
        equalToIgnoringCase(order.getGranularStatus().replace("_", " ")));
    assertEquals("Shipper Name", order.getShipper().getName(), actualShipperName);
    assertEquals("COD Amount", order.getCod().getGoodsAmount(), actualGoodsAmount);
  }

  private int findOrderRowIndexInTable(String trackingId) {
    try {
      WebElement rowIndexWe = findElementByXpath(String.format(
          "//tr[@ng-repeat='%s']/td[contains(@class,'%s')][contains(text(), '%s')]/preceding-sibling::td",
          NG_REPEAT, COLUMN_CLASS_DATA_TRACKING_ID, trackingId));
      return Integer.parseInt(rowIndexWe.getText().trim());
    } catch (RuntimeException ex) {
      throw new NvTestRuntimeException(
          String.format("Tracking ID = '%s' not found on table.", trackingId));
    }
  }

  public void downloadCsvFile() {
    clickNvApiTextButtonByName("Download CSV File");
  }

  public void verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(Order order) {
    String trackingId = order.getTrackingId();
    String granularStatus = order.getGranularStatus().replace("_", " ").toLowerCase();
    String shipperName = order.getShipper().getName();
    String codAmount = NO_TRAILING_ZERO_DF.format(order.getCod().getGoodsAmount());
    String expectedText = String
        .format("\"%s\",\"%s\",\"%s\",%s", trackingId, granularStatus, shipperName, codAmount);
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN),
        expectedText, true);
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
  }
}
