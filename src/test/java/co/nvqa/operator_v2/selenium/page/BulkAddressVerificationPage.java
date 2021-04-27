package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiIconButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class BulkAddressVerificationPage extends OperatorV2SimplePage {

  @FindBy(name = "Upload CSV")
  public NvIconTextButton uploadCsv;

  @FindBy(name = "Update Successful Matches")
  public NvApiTextButton updateSuccessfulMatches;

  @FindBy(name = "here")
  public NvApiIconButton downloadSampleCsv;

  @FindBy(css = "md-dialog")
  public UploadAddressesCsvDialog uploadAddressesCsvDialog;

  public final SuccessfulMatchesTable successfulMatchesTable;

  public BulkAddressVerificationPage(WebDriver webDriver) {
    super(webDriver);
    successfulMatchesTable = new SuccessfulMatchesTable(webDriver);
  }

  private File generateWaypointsFile(List<JaroScore> jaroScores) {
    List<String> csvLines = new ArrayList<>();
    csvLines.add("\"waypoint\",\"latitude\",\"longitude\"");
    jaroScores.forEach(jaroScore -> csvLines.add(
        jaroScore.getWaypointId() + "," + jaroScore.getLatitude() + "," + jaroScore
            .getLongitude()));
    File file = TestUtils.createFileOnTempFolder(
        String.format("bulk_address_verification_%s.csv", generateDateUniqueString()));
    try {
      FileUtils.writeLines(file, csvLines);
    } catch (IOException ex) {
      NvLogger
          .warnf("File '%s' failed to write. Cause: %s", file.getAbsolutePath(), ex.getMessage());
    }
    return file;
  }

  public void uploadWaypointsData(List<JaroScore> jaroScores) {
    File file = generateWaypointsFile(jaroScores);
    uploadCsv(file);

    int actualSuccessfulMatches = successfulMatchesTable.getRowsCount();
    assertEquals("Number of successful matches", jaroScores.size(), actualSuccessfulMatches);

    Map<Long, JaroScore> jsMapByWaypointId = jaroScores.stream().collect(Collectors.toMap(
        JaroScore::getWaypointId,
        jaroScore -> jaroScore
    ));

    for (int rowIndex = 1; rowIndex <= actualSuccessfulMatches; rowIndex++) {
      JaroScore actual = successfulMatchesTable.readEntity(rowIndex);
      JaroScore expected = jsMapByWaypointId.get(actual.getWaypointId());
      expected.compareWithActual(actual, "verifiedAddressId");
    }

    updateSuccessfulMatches();
    String toastMessage = f("%d Waypoint(s) Updated", jaroScores.size());
    waitUntilInvisibilityOfToast(toastMessage);

  }

  public void uploadCsv(File file) {
    uploadCsv.click();
    uploadAddressesCsvDialog.waitUntilVisible();
    uploadAddressesCsvDialog.chooseButton.setValue(file);
    uploadAddressesCsvDialog.submit.clickAndWaitUntilDone();
    uploadAddressesCsvDialog.waitUntilInvisible();
  }

  public void updateSuccessfulMatches() {
    updateSuccessfulMatches.clickAndWaitUntilDone();
  }

  public static class SuccessfulMatchesTable extends NgRepeatTable<JaroScore> {

    private static final Pattern LATLONG_PATTERN = Pattern
        .compile(".*?([\\d\\.]+).*?([\\d\\.]+).*");
    public static final String NG_REPEAT = "scs in $data";
    public static final String COLUMN_LATITUDE = "latitude";
    public static final String COLUMN_LONGITUDE = "longitude";

    public SuccessfulMatchesTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat(NG_REPEAT);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("waypointId", "id")
          .put("address1", "//td[@data-title-text='Address']")
          .put(COLUMN_LATITUDE, "coordinate")
          .put(COLUMN_LONGITUDE, "coordinate")
          .build());
      setColumnValueProcessors(ImmutableMap.of(
          COLUMN_LATITUDE, value ->
          {
            Matcher m = LATLONG_PATTERN.matcher(value);
            return m.matches() ? m.group(1) : null;
          },
          COLUMN_LONGITUDE, value ->
          {
            Matcher m = LATLONG_PATTERN.matcher(value);
            return m.matches() ? m.group(2) : null;
          }
      ));
      setEntityClass(JaroScore.class);
    }
  }

  public static class UploadAddressesCsvDialog extends MdDialog {

    @FindBy(css = "[label='Choose']")
    NvButtonFilePicker chooseButton;

    @FindBy(name = "Submit")
    public NvButtonSave submit;

    public UploadAddressesCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}