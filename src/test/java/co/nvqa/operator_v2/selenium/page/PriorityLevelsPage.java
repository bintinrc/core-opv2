package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class PriorityLevelsPage extends OperatorV2SimplePage {

  private static final String SAMPLE_CSV_RESERVATIONS_FILENAME = "priority_sample_reservations.csv";
  public static final String SAMPLE_CSV_RESERVATIONS_FILENAME_PATTERN = "priority_sample_reservations-%s.csv";
  public static final String SAMPLE_CSV_RESERVATIONS_EXPECTED_TEXT = "Reservation ID,Priority Level";

  @FindBy(css = "nv-icon-text-button[on-click*='selectCsv'][on-click*='csvType.RSVN']")
  public NvIconTextButton uploadCsvReservations;

  @FindBy(css = "nv-icon-text-button[on-click*='download'][on-click*='csvType.RSVN']")
  public NvIconTextButton downloadSimpleCsvReservations;

  @FindBy(css = "md-dialog")
  public UploadFileDialog uploadCsvDialog;

  @FindBy(css = "md-dialog")
  public BulkPriorityEditDialog bulkPriorityEditDialog;

  public PriorityLevelsPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void verifyDownloadedSampleCsvReservations() {
    verifyFileDownloadedSuccessfully(SAMPLE_CSV_RESERVATIONS_FILENAME,
        SAMPLE_CSV_RESERVATIONS_EXPECTED_TEXT);
  }

  public static class BulkPriorityEditDialog extends MdDialog {

    @FindBy(xpath = ".//tr[@ng-repeat='data in ctrl.data.reservations']/td[1]")
    public List<PageElement> reservationIds;

    @FindBy(id = "Priority Level")
    public List<TextBox> priorityLevels;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;

    public BulkPriorityEditDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}