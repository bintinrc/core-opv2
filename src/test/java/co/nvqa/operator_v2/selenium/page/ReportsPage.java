package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.Box;
import co.nvqa.commons.util.GmailClient;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import java.time.ZonedDateTime;
import java.util.concurrent.atomic.AtomicBoolean;
import javax.mail.internet.MimeMultipart;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import org.apache.commons.io.IOUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * @author Niko Susanto
 */
public class ReportsPage extends OperatorV2SimplePage {

  @FindBy(css = "nv-button-file-picker[ng-if='ctrl.orderStatusesReport.fileSelected.length <= 0']")
  public NvButtonFilePicker orderStatusesUploadCsv;

  @FindBy(css = "[ng-click='ctrl.orderStatusesReport.generate()']")
  public NvApiTextButton orderStatusesGenerateReport;

  @FindBy(css = "md-card:nth-child(1) [name='container.reports.generate']")
  public NvApiTextButton codReportGenerateReport;

  @FindBy(css = "md-datepicker[ng-model='ctrl.codReport.date']")
  public MdDatepicker codReportDate;

  public ReportsPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void filterCodReportsBy(String mode, ZonedDateTime date) {
    clickToggleButton("ctrl.codReport.mode", mode);
    codReportDate.setDate(date);
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

}