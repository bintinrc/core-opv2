package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.SmsCampaignCsv;
import co.nvqa.operator_v2.model.SmsHistoryEntry;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;
import org.apache.commons.io.FileUtils;
import org.hamcrest.Matchers;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Rizaq Pratama
 */
public class MessagingModulePage extends OperatorV2SimplePage {

  private static final String COMMA = ",";
  private static final String SMS_CAMPAIGN_FILE_NAME = "sms_campaign.csv";
  private static final String SMS_CAMPAIGN_HEADER = "tracking_id,name,email,job";
  private static final String FILE_PATH = TestConstants.TEMP_DIR + SMS_CAMPAIGN_FILE_NAME;
  private static final File SMS_CAMPAIGN_FILE = new File(FILE_PATH);
  private static Map<String, Object> cache;
  private final SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-DD hh:ss");

  @FindBy(css = "nv-button-file-picker[label='Upload File']")
  public NvButtonFilePicker uploadFle;

  @FindBy(id = "trackingId")
  public TextBox trackingId;

  @FindBy(css = "nv-icon-text-button[text='commons.load']")
  public NvIconTextButton load;

  @FindBy(css = "md-dialog")
  public CsvValidationErrorsDialog csvValidationErrorsDialog;

  @FindBy(css = "md-card.sms-editor")
  public ComposeMessageCard composeMessageCard;

  @FindBy(css = "md-card.sms-history")
  public SmsHistoryCard smsHistoryCard;

  public MessagingModulePage(WebDriver webDriver) {
    super(webDriver);

    if (cache == null) {
      cache = new ConcurrentHashMap<>();
    }
  }

  public File createSmsCampaignCsv(List<SmsCampaignCsv> data) {
    List<String> smsCampaignData = data.stream()
        .map(row -> row.getTracking_id() + COMMA + row.getName() + COMMA + row.getEmail() + COMMA +
            row.getJob())
        .collect(Collectors.toList());
    smsCampaignData.add(0, SMS_CAMPAIGN_HEADER);

    try {
      FileUtils.writeLines(SMS_CAMPAIGN_FILE, smsCampaignData);
    } catch (IOException ex) {
      throw new NvTestRuntimeException("Could not write to file " + SMS_CAMPAIGN_FILE, ex);
    }
    return SMS_CAMPAIGN_FILE;
  }

  public void composeSms(String name, String trackingId) {
    composeMessageCard.waitUntilVisible();
    String smsDate = sdf.format(new Date());
    cache.put("sms-date", smsDate);
    assertEquals("Uploaded File", SMS_CAMPAIGN_FILE_NAME,
        composeMessageCard.uploadedFileName.getText());
    assertEquals("Number of Messages", "1", composeMessageCard.totalRecords.getText());
    String template =
        "Hallo {{name}}, your parcel with tracking id {{tracking_id}} is ready to be delivered. sms-date: "
            + smsDate;
    composeMessageCard.message.setValue(template);
    composeMessageCard.update.click();
    pause1s();
    String expectedMessage = "Hallo " + name + ", your parcel with tracking id " + trackingId
        + " is ready to be delivered. sms-date: " + smsDate;
    assertEquals("Message preview", expectedMessage, composeMessageCard.preview.getValue());
  }

  public void composeSmsWithUrlShortener() {
    composeMessageCard.waitUntilVisible();
    assertEquals("Uploaded File", SMS_CAMPAIGN_FILE_NAME,
        composeMessageCard.uploadedFileName.getText());
    assertEquals("Number of Messages", "1", composeMessageCard.totalRecords.getText());
    String template = "email : {{email}}";
    composeMessageCard.message.sendKeys(template);
    composeMessageCard.shortenUrl.check();
    composeMessageCard.update.click();
    pause1s();
  }

  public void verifyThatPreviewUsingShortenedUrl() {
    pause10s();
    String actualValue = composeMessageCard.preview.getValue();
    String expectedValue = StandardTestConstants.NV_URL_SHORTENER_PREFIX;
    assertThat("The produced sms using ninja url shortener is failed", actualValue,
        Matchers.containsString(expectedValue));
  }

  public void searchSmsSentHistory(String trackingId) {
    this.trackingId.setValue(trackingId);
    load.click();
  }

  public void verifySmsHistoryTrackingIdValid(String trackingId, String contactNumber) {
    smsHistoryCard.waitUntilVisible();
    String smsDate = (String) cache.get("sms-date");
    assertEquals("Tracking id", trackingId, smsHistoryCard.trackingId.getText());

    SmsHistoryEntry entry = smsHistoryCard.smsHistoryTable.readEntity(1);
    assertEquals("Contact Number", contactNumber, entry.getContact());
    assertThat("It contain sms-date with same date", entry.getContent(),
        Matchers.containsString(smsDate));
  }

  public static class CsvValidationErrorsDialog extends MdDialog {

    @FindBy(css = "nv-icon-text-button[text='commons.continue']")
    public NvIconTextButton continueBtn;

    public CsvValidationErrorsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ComposeMessageCard extends PageElement {

    @FindBy(css = "div.uploaded-info > div:nth-of-type(1) > p > b")
    public PageElement uploadedFileName;

    @FindBy(css = "div.uploaded-info > div:nth-of-type(2) > p > b")
    public PageElement totalRecords;

    @FindBy(id = "message")
    public TextBox message;

    @FindBy(id = "preview")
    public TextBox preview;

    @FindBy(xpath = "//li[@ng-repeat='field in ctrl.fields'][3]/span[2]/input")
    public CheckBox shortenUrl;

    @FindBy(css = "nv-icon-text-button[text='Update']")
    public NvIconTextButton update;

    @FindBy(name = "container.sms.send-messages")
    public NvApiTextButton sendMessages;

    public ComposeMessageCard(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class SmsHistoryCard extends PageElement {

    @FindBy(css = "span[ng-bind-html*='tracking-id'] b")
    public PageElement trackingId;

    public SmsHistoryTable smsHistoryTable;

    public SmsHistoryCard(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      smsHistoryTable = new SmsHistoryTable(webDriver);
    }

    public static class SmsHistoryTable extends MdVirtualRepeatTable<SmsHistoryEntry> {

      public SmsHistoryTable(WebDriver webDriver) {
        super(webDriver);
        setColumnLocators(ImmutableMap.<String, String>builder()
            .put("channel", "route")
            .put("sentDateTime", "sent-time")
            .put("contact", "to-number")
            .put("content", "message")
            .build()
        );
        setEntityClass(SmsHistoryEntry.class);
        setMdVirtualRepeat("sms in getTableData()");
      }
    }

  }
}