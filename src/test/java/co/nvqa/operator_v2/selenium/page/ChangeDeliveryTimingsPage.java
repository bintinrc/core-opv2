package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.ChangeDeliveryTiming;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.util.TestUtils;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class ChangeDeliveryTimingsPage extends SimpleReactPage<ChangeDeliveryTimingsPage> {

  @FindBy(css = ".error-box li")
  public PageElement errorMessage;

  @FindBy(css = ".error-box li")
  public List<PageElement> errorMessages;

  @FindBy(css = "[data-testid='upload-csv-button']")
  public Button uploadCsv;

  @FindBy(css = "[data-testid='close-button']")
  public Button close;

  @FindBy(css = "[data-testid='download-sample-excel-file-button']")
  public Button downloadSampleCsv;

  @FindBy(css = ".ant-modal")
  public UploadChangeDeliveryTimingCsvDialog uploadCsvDialog;

  private static final String CSV_FILENAME_PATTERN = "sample_change_delivery_timings";
  private static final String COMMA = ",";
  private static final String CSV_CAMPAIGN_HEADER = "tracking_id,start_date,end_date,timewindow_id";

  public ChangeDeliveryTimingsPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void csvSampleDownloadSuccessful() {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN));
  }

  public File createDeliveryTimingChanging(
      List<ChangeDeliveryTiming> listOfChangeDeliveryTimings) {
    File csvResultFile = TestUtils.createFileOnTempFolder(
        String.format("change-delivery-timings_%s.csv", generateDateUniqueString()));

    try {
      StringBuilder csvData = new StringBuilder();

      listOfChangeDeliveryTimings.forEach((row) ->
      {
        StringBuilder sb = new StringBuilder();
        sb.append(row.getTrackingId()).append(COMMA);
        sb.append(row.getStartDate()).append(COMMA);
        sb.append(row.getEndDate()).append(COMMA);
        if (row.getTimewindow() != null) {
          sb.append(row.getTimewindow()).append(COMMA);
        }

        csvData.append(sb).append(System.lineSeparator());
      });

      PrintWriter pw = new PrintWriter(Files.newOutputStream(csvResultFile.toPath()));
      pw.println(CSV_CAMPAIGN_HEADER);
      pw.print(csvData);
      pw.close();
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }

    return csvResultFile;
  }

  public static class UploadChangeDeliveryTimingCsvDialog extends AntModal {

    @FindBy(css = "[data-testid='upload-dragger']")
    public FileInput selectFile;

    @FindBy(css = "[data-testid='upload-button']")
    public Button upload;

    public UploadChangeDeliveryTimingCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}