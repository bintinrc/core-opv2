package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.ChangeDeliveryTiming;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Tristania Siagian
 */
public class ChangeDeliveryTimingsPage extends OperatorV2SimplePage {

  @FindBy(css = "div[ng-repeat='error in ctrl.payload.errors track by $index']")
  public PageElement errorMessage;

  @FindBy(name = "Upload CSV")
  public NvApiTextButton uploadCsv;

  @FindBy(name = "commons.download-sample-excel")
  public NvIconTextButton downloadSampleCsv;

  @FindBy(css = "md-dialog")
  public UploadChangeDeliveryTimingCsvDialog uploadCsvDialog;

  private static final String CSV_FILENAME_PATTERN = "sample_change_delivery_timings";
  private static final String COMMA = ",";
  private static final String CSV_CAMPAIGN_HEADER = "tracking_id,start_date,end_date,timewindow";

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
        } else {
          sb.append(COMMA);
        }

        csvData.append(sb).append(System.lineSeparator());
      });

      PrintWriter pw = new PrintWriter(new FileOutputStream(csvResultFile));
      pw.println(CSV_CAMPAIGN_HEADER);
      pw.print(csvData);
      pw.close();
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }

    return csvResultFile;
  }

  public void invalidTrackingIdVerification() {
    errorMessage.waitUntilClickable();
    Assertions.assertThat(errorMessage.getText()).as("Tracking ID is valid.")
        .containsIgnoringCase("Invalid tracking Id");
  }

  public static class UploadChangeDeliveryTimingCsvDialog extends MdDialog {

    @FindBy(css = "[label='Choose']")
    public NvButtonFilePicker selectFile;

    @FindBy(name = "Upload CSV")
    public NvButtonSave upload;

    public UploadChangeDeliveryTimingCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
