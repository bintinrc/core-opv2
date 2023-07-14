package co.nvqa.operator_v2.selenium.page;


import co.nvqa.commons.util.NvLogger;
import co.nvqa.commonsort.model.addressing.JaroScore;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
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
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class BulkAddressVerificationPage extends SimpleReactPage<BulkAddressVerificationPage> {

  private static final Logger LOGGER = LoggerFactory.getLogger(
      BulkAddressVerificationPage.class);

  private static final String SUCCESS_TABLE_XPATH = "//button[@data-testid='download-success-csv-button']/parent::div/following-sibling::div[1]//table";
  private static final String SUCCESS_COLUMN_XPATH = "%s/tbody/tr[%d]/td[@class='%s']";
  private static final String POPUP_MESSAGE = "//div[contains(text(),'Updated %d waypoint(s)')]";

  @FindBy(css = "[data-testid='upload-csv-button']")
  public Button uploadCsv;

  @FindBy(css = "[data-testid='update-successful-matches']")
  public Button updateSuccessfulMatches;

  @FindBy(css = "[data-testid='download-csv-sample-button']")
  public Button downloadSampleCsv;

  @FindBy(xpath = "//div[contains(@class, 'upload-csv-dialog')]")
  public PageElement uploadCsvDialog;

  @FindBy(xpath = "//button[contains(text(),'Browse')]")
  public Button chooseButton;

  @FindBy(xpath = "//input[@data-testid='upload-dragger']")
  public FileInput fileInput;

  @FindBy(xpath = "//span[@data-testid='submit-button']//parent::button")
  public Button submit;

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
        (jaroScore.getWaypointId() != null ? String.valueOf(jaroScore.getWaypointId()) : "") + ","
            + jaroScore.getLatitude() + "," + jaroScore
            .getLongitude()));
    File file = TestUtils.createFileOnTempFolder(
        String.format("bulk_address_verification_%s.csv", generateDateUniqueString()));
    try {
      FileUtils.writeLines(file, csvLines);
      csvLines.forEach(c -> LOGGER.info(c));
    } catch (IOException ex) {
      NvLogger
          .warnf("File '%s' failed to write. Cause: %s", file.getAbsolutePath(), ex.getMessage());
    }
    return file;
  }

  public void uploadWaypointsData(List<JaroScore> jaroScores) {
    File file = generateWaypointsFile(jaroScores);
    uploadCsv(file);

    int actualSuccessfulMatches = getSuccessfulMatches();
    if (actualSuccessfulMatches <= 0) {
      Assertions.assertThat(actualSuccessfulMatches)
          .as("No successful match")
          .isZero();
      return;
    }

    Assertions.assertThat(actualSuccessfulMatches)
        .as(String.format("Number of successful matches: %d",
            jaroScores.stream().filter(js -> js.getWaypointId() != null).count()))
        .isEqualTo(jaroScores.stream().filter(js -> js.getWaypointId() != null).count());

    Map<Long, JaroScore> jsMapByWaypointId = jaroScores.stream()
        .filter(js -> js.getWaypointId() != null).collect(Collectors.toMap(
            JaroScore::getWaypointId,
            jaroScore -> jaroScore
        ));

    for (int rowIndex = 1; rowIndex <= actualSuccessfulMatches; rowIndex++) {
      JaroScore actual = mapJaroScoreBySuccessfulRowIndex(rowIndex);
      JaroScore expected = jsMapByWaypointId.get(actual.getWaypointId());
      expected.compareWithActual(actual, "verifiedAddressId");
    }
  }

  public void uploadCsv(File file) {
    uploadCsv.click();
    uploadCsvDialog.waitUntilVisible();
    fileInput.setValue(file);
    submit.click();
    uploadCsvDialog.waitUntilInvisible();
  }

  public int getSuccessfulMatches() {
    List<WebElement> listOfRow = webDriver.findElements(
        By.xpath(SUCCESS_TABLE_XPATH + "/tbody/tr"));
    return listOfRow.size();
  }

  public JaroScore mapJaroScoreBySuccessfulRowIndex(int index) {
    String waypointId = webDriver.findElement(By.xpath(
        String.format(SUCCESS_COLUMN_XPATH + "/span/span", SUCCESS_TABLE_XPATH, index,
            "waypoint_id"))).getAttribute("innerHTML");
    String address = webDriver.findElement(By.xpath(
        String.format(SUCCESS_COLUMN_XPATH + "/span/span", SUCCESS_TABLE_XPATH, index,
            "address_one"))).getAttribute("innerHTML");
    String coordinate = webDriver.findElement(By.xpath(
            String.format(SUCCESS_COLUMN_XPATH + "/a", SUCCESS_TABLE_XPATH, index, "latitude")))
        .getAttribute("innerHTML");
    String[] listOfCoordinate = coordinate.split(",");
    String latitude = listOfCoordinate[0];
    String longitude = listOfCoordinate[1];

    JaroScore jaroScore = new JaroScore();
    jaroScore.setAddress1(address);
    jaroScore.setWaypointId(Long.valueOf(waypointId));
    jaroScore.setLatitude(Double.valueOf(latitude));
    jaroScore.setLongitude(Double.valueOf(longitude));

    return jaroScore;
  }

  public void updateSuccessfulMatches(int size) {
    updateSuccessfulMatches.click();

    String toastMessage = String.format(POPUP_MESSAGE, size);
    waitUntilVisibilityOfElementLocated(toastMessage);
  }

  public static class SuccessfulMatchesTable extends NgRepeatTable<JaroScore> {

    private static final Pattern LATLONG_PATTERN = Pattern
        .compile(".*?(-?[\\d.]+).*?([\\d.]+).*");
    public static final String NG_REPEAT = "scs in $data";
    public static final String COLUMN_LATITUDE = "latitude";
    public static final String COLUMN_LONGITUDE = "longitude";

    public SuccessfulMatchesTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat(NG_REPEAT);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("waypointId", "waypoint id")
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

    @FindBy(xpath = "//div[contains(@class, 'upload-csv-dialog')]")
    public PageElement title;

    public UploadAddressesCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}