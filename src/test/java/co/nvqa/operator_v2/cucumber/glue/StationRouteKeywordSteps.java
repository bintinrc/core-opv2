package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage;
import co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage.Coverage;
import co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage.TransferKeywordsDialog.AreaBox;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.hibernate.AssertionFailure;

import static co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage.AreasTable.ACTION_ACTION;
import static co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage.AreasTable.COLUMN_AREA;
import static co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage.AreasTable.COLUMN_FALLBACK_DRIVER;
import static co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage.AreasTable.COLUMN_KEYWORDS;
import static co.nvqa.operator_v2.selenium.page.StationRouteKeywordPage.AreasTable.COLUMN_PRIMARY_DRIVER;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class StationRouteKeywordSteps extends AbstractSteps {

  private StationRouteKeywordPage page;

  public StationRouteKeywordSteps() {
  }

  @Override
  public void init() {
    page = new StationRouteKeywordPage(getWebDriver());
  }

  @When("Operator selects {value} hub on Station Route Keyword page")
  public void selectHub(String hubName) {
    retryIfRuntimeExceptionOccurred(() -> page.inFrame(() -> {
      page.waitUntilLoaded(3, 60);
      page.hub.selectValue(hubName);
    }), 2);
  }

  @When("Operator create new coverage on Station Route Keyword page:")
  public void createNewCoverage(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.createNewCoverage.click();
      page.createNewCoverageDialog.waitUntilVisible();
      if (finalData.containsKey("area")) {
        page.createNewCoverageDialog.area.setValue(finalData.get("area"));
        putInList(KEY_LIST_OF_CREATED_AREAS, finalData.get("area"));
      }
      if (finalData.containsKey("areaVariation")) {
        page.createNewCoverageDialog.areaVariation.setValue(finalData.get("areaVariation"));
      }
      if (finalData.containsKey("keyword")) {
        page.createNewCoverageDialog.keyword.setValue(
            StringUtils.join(splitAndNormalize(finalData.get("keyword")), "\n"));
      }
      if (finalData.containsKey("primaryDriver")) {
        page.createNewCoverageDialog.primaryDriver.selectValue(finalData.get("primaryDriver"));
      }
      if (finalData.containsKey("fallbackDriver")) {
        page.createNewCoverageDialog.fallbackDriver.selectValue(finalData.get("fallbackDriver"));
      }
      page.createNewCoverageDialog.add.click();
    });
  }

  @When("Operator bulk create new coverages on Station Route Keyword page:")
  public void createNewCoverage(List<Map<String, String>> data) {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      page.bulkCreateCoverage.click();
      page.bulkCreateCoverageDialog.waitUntilVisible();
      List<String> rows = resolveListOfMaps(data).stream()
          .peek(e -> putInList(KEY_LIST_OF_CREATED_AREAS, e.get("area")))
          .map(e -> "\"" + StringUtils.trimToEmpty(e.get("area")) + "\",\""
              + StringUtils.trimToEmpty(e.get("variations")) + "\",\"" + StringUtils.trimToEmpty(
              e.get("keywords")) + "\",\"" + StringUtils.trimToEmpty(e.get("primaryDriver"))
              + "\",\""
              + StringUtils.trimToEmpty(e.get("fallbackDriver")) + "\"")
          .collect(Collectors.toList());
      rows.add(0,
          "\"Area*\",\"Area Variations\",\"Keywords\",\"Primary Driver*\",\"Fallback Driver*\"");
      File file = TestUtils.createFileOnTempFolder(
          String.format("bulk_create_coverage_%s.csv", page.generateDateUniqueString()));
      try {
        FileUtils.writeLines(file, rows);
      } catch (IOException e) {
        throw new RuntimeException(e);
      }
      page.bulkCreateCoverageDialog.file.setValue(file);
      page.bulkCreateCoverageDialog.uploadAndCreateCoverages.click();
    });
  }

  @When("Operator upload invalid bulk create coverage CSV on Station Route Keyword page")
  public void uploadInvalidCreateNewCoverageCsv() {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      page.bulkCreateCoverage.click();
      page.bulkCreateCoverageDialog.waitUntilVisible();
      File file = TestUtils.createFileOnTempFolder(
          String.format("bulk_create_coverage_%s.csv", page.generateDateUniqueString()));
      try {
        FileUtils.write(file, "Area*\n"
            + "AREA1\n"
            + "AREA2");
      } catch (IOException e) {
        throw new RuntimeException(e);
      }
      page.bulkCreateCoverageDialog.file.setValue(file);
      page.bulkCreateCoverageDialog.uploadAndCreateCoverages.click();
    });
  }

  @When("Operator verify error messages displayed in Bulk create coverage dialog on Station Route Keyword page:")
  public void checkErrorMessages(List<String> expected) {
    page.inFrame(() -> {
      page.bulkCreateCoverageDialog.waitUntilVisible();
      Assertions.assertThat(page.bulkCreateCoverageDialog.errors)
          .withFailMessage("No bulk create coverage errors are displayed")
          .isNotEmpty();
      var actual = page.bulkCreateCoverageDialog.errors.stream()
          .map(PageElement::getNormalizedText)
          .collect(Collectors.toList());
      Assertions.assertThat(actual)
          .as("List of bulk create coverage errors")
          .containsExactlyElementsOf(resolveValues(expected));
    });
  }

  @When("Operator verify error tip is displayed in Bulk create coverage dialog on Station Route Keyword page")
  public void checkErrorTipDisplayed() {
    page.inFrame(() -> {
      page.bulkCreateCoverageDialog.waitUntilVisible();
      Assertions.assertThat(page.bulkCreateCoverageDialog.message.isDisplayed())
          .withFailMessage("No bulk create coverage error tip is displayed")
          .isTrue();
    });
  }

  @When("Operator click Bulk create coverage on Station Route Keyword page")
  public void clickBulkCreateCoverage() {
    page.inFrame(() -> page.bulkCreateCoverage.click());
  }

  @When("Operator click Download template in Bulk create coverage dialog on Station Route Keyword page")
  public void clickDownloadTemplate() {
    page.inFrame(() -> {
      page.bulkCreateCoverageDialog.waitUntilVisible();
      page.bulkCreateCoverageDialog.downloadTemplate.click();
    });
  }

  @When("Operator click Download error report in Bulk create coverage dialog on Station Route Keyword page")
  public void clickDownloadErrorReport() {
    page.inFrame(() -> {
      page.bulkCreateCoverageDialog.waitUntilVisible();
      page.bulkCreateCoverageDialog.downloadErrorReport.click();
    });
  }

  @When("Operator click Ok, got it in Bulk create coverage dialog on Station Route Keyword page")
  public void clickOkGotIt() {
    page.inFrame(() -> {
      page.bulkCreateCoverageDialog.waitUntilVisible();
      page.bulkCreateCoverageDialog.ok.click();
    });
  }

  @When("Operator verify Bulk create coverage dialog is closed on Station Route Keyword page")
  public void bulckCreateCoverageDialogIsClosed() {
    page.inFrame(() -> {
      page.bulkCreateCoverageDialog.waitUntilInvisible();
    });
  }

  @Then("Operator verify Bulk create coverage template file is downloaded on Station Route Keyword page")
  public void operatorVerifySampleCsvFileIsDownloaded() {
    page.verifyFileDownloadedSuccessfully("bulk_create_coverage_template.csv",
        "\"Area*\",\"Area Variations\",\"Keywords\",\"Primary Driver*\",\"Fallback Driver*\"\n"
            + "\"SINGAPORE\",\"SG,SING,SPORE\",\"BUKIT MERAH,BKT MERAH,B MERAH\",\"1282\",\"1375\"");
  }

  @Then("Operator verify Bulk create coverage errors file is downloaded on Station Route Keyword page:")
  public void operatorVerifySampleCsvFileIsDownloaded(List<Map<String, String>> data) {
    page.inFrame(() -> {
      List<String> rows = resolveListOfMaps(data).stream()
          .peek(e -> putInList(KEY_LIST_OF_CREATED_AREAS, e.get("area")))
          .map(e -> "\"" + StringUtils.trimToEmpty(e.get("area")) + "\",\""
              + StringUtils.trimToEmpty(e.get("variations")) + "\",\"" + StringUtils.trimToEmpty(
              e.get("keywords")) + "\",\"" + e.get("primaryDriver")
              + "\",\""
              + e.get("fallbackDriver") + "\",\""
              + StringUtils.trimToEmpty(e.get("error")) + "\"")
          .collect(Collectors.toList());
      rows.add(0,
          "\"Area*\",\"Area Variations\",\"Keywords\",\"Primary Driver*\",\"Fallback Driver*\",\"Error\"");
      String expected = StringUtils.join(rows, "\n");
      page.verifyFileDownloadedSuccessfully("bulk_create_coverage_error_report.csv", expected);
    });
  }

  @When("Operator verify data on New coverage created dialog:")
  public void verifyNewCoverageCreated(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      page.waitUntilLoaded(2);
      page.newCoverageCreatedDialog.waitUntilVisible();
      if (finalData.containsKey("area")) {
        assertions.assertThat(page.newCoverageCreatedDialog.area.getText()).as("Area")
            .isEqualTo(finalData.get("area"));
      }
      if (finalData.containsKey("primaryDriver")) {
        assertions.assertThat(page.newCoverageCreatedDialog.primaryDriver.getText())
            .as("Primary Driver").isEqualTo(finalData.get("primaryDriver"));
      }
      if (finalData.containsKey("fallbackDriver")) {
        assertions.assertThat(page.newCoverageCreatedDialog.fallbackDriver.getText())
            .as("Fallback Driver").isEqualTo(finalData.get("fallbackDriver"));
      }

      if (finalData.containsKey("keywordsAdded")) {
        assertions.assertThat(page.newCoverageCreatedDialog.keywordsAdded.getText())
            .as("Keywords added").contains(finalData.get("keywordsAdded"));
      }
      if (finalData.containsKey("keywords")) {
        assertions.assertThat(
                page.newCoverageCreatedDialog.keywords.stream().map(PageElement::getText)
                    .collect(Collectors.toList())).as("Keywords")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("keywords")));
      }
    });
    assertions.assertAll();
  }

  @When("Operator verify data on Transfer duplicate keywords dialog:")
  public void verifyTransferDuplicateKeywords(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      page.waitUntilLoaded(2);
      page.transferDuplicateKeywordsDialog.waitUntilVisible();
      if (finalData.containsKey("area")) {
        String value = finalData.get("area");
        if (value != null) {
          assertions.assertThat(page.transferDuplicateKeywordsDialog.area.getText()).as("Area")
              .isEqualToIgnoringCase(finalData.get("area"));
        } else {
          assertions.assertThat(page.transferDuplicateKeywordsDialog.area.isDisplayed())
              .withFailMessage("Area is displayed").isFalse();
        }
      }
      if (finalData.containsKey("primaryDriver")) {
        String value = finalData.get("primaryDriver");
        if (value != null) {
          assertions.assertThat(page.transferDuplicateKeywordsDialog.primaryDriver.getText())
              .as("Primary Driver").isEqualTo(finalData.get("primaryDriver"));
        } else {
          assertions.assertThat(page.transferDuplicateKeywordsDialog.primaryDriver.isDisplayed())
              .withFailMessage("Primary Driver is displayed").isFalse();
        }
      }
      if (finalData.containsKey("fallbackDriver")) {
        String value = finalData.get("fallbackDriver");
        if (value != null) {
          assertions.assertThat(page.transferDuplicateKeywordsDialog.fallbackDriver.getText())
              .as("Fallback Driver").isEqualTo(finalData.get("fallbackDriver"));
        } else {
          assertions.assertThat(page.transferDuplicateKeywordsDialog.fallbackDriver.isDisplayed())
              .withFailMessage("Fallback Driver is displayed").isFalse();
        }
      }
      if (finalData.containsKey("keyword")) {
        String value = finalData.get("keyword");
        if (value != null) {
          assertions.assertThat(page.transferDuplicateKeywordsDialog.keyword.getText())
              .as("Keyword")
              .isEqualToIgnoringCase(finalData.get("keyword"));
        } else {
          assertions.assertThat(page.transferDuplicateKeywordsDialog.keyword.isDisplayed())
              .withFailMessage("Keyword is displayed").isFalse();
        }
      }
    });
    assertions.assertAll();
  }

  @When("Operator click 'No, don't transfer' button on Transfer duplicate keywords dialog")
  public void clickNoDontTransfer() {
    page.inFrame(() -> page.transferDuplicateKeywordsDialog.no.click());
  }

  @When("Operator click 'Yes, Transfer' button on Transfer duplicate keywords dialog")
  public void clickYesTransfer() {
    page.inFrame(() -> page.transferDuplicateKeywordsDialog.yes.click());
  }

  @When("Operator close New coverage created dialog")
  public void closeNewCoverageCreated() {
    page.inFrame(() -> page.newCoverageCreatedDialog.close.click());
  }

  @When("Operator verify coverage displayed on Station Route Keyword page:")
  public void verifyCoverageDisplayed(Map<String, String> data) {
    Coverage expected = new Coverage(resolveKeyValues(data));
    page.inFrame(() -> {
      page.areasTable.clearColumnFilters();
      page.areasTable.filterByColumn(COLUMN_AREA, expected.getArea());
      pause2s();
      Assertions.assertThat(page.areasTable.getRowsCount())
          .withFailMessage("Coverage is not displayed: " + expected).isPositive();
      List<Coverage> actual = page.areasTable.readAllEntities();
      DataEntity.assertListContains(actual, expected, "List of coverages");
    });
  }

  @When("Operator verify coverage is not displayed on Station Route Keyword page:")
  public void verifyCoverageIsNotDisplayed(Map<String, String> data) {
    Coverage expected = new Coverage(resolveKeyValues(data));
    page.inFrame(() -> {
      page.areasTable.clearColumnFilters();
      page.areasTable.filterByColumn(COLUMN_AREA, expected.getArea());
      pause2s();
      List<Coverage> actual = page.areasTable.readAllEntities();
      Assertions.assertThat(actual.stream().noneMatch(expected::matchedTo))
          .withFailMessage("Unexpected coverage is displayed:" + expected)
          .isTrue();
    });
  }

  @When("Operator open coverage settings for {value} area on Station Route Keyword page")
  public void openCoverageSettings(String area) {
    page.inFrame(() -> {
      page.areasTable.filterByColumn(COLUMN_AREA, area);
      Assertions.assertThat(page.areasTable.getRowsCount())
          .withFailMessage("Coverage is not displayed for area: " + area).isPositive();
      page.areasTable.clickActionButton(1, ACTION_ACTION);
    });
  }

  @When("Operator open coverage settings on Station Route Keyword page:")
  public void openCoverageSettings(Map<String, String> data) {
    filterCoverages(data);
    page.inFrame(() -> {
      Assertions.assertThat(page.areasTable.getRowsCount())
          .withFailMessage("Coverage is not displayed for area: " + data).isPositive();
      int index = 0;
      if ("empty".equals(data.get("keywords"))) {
        for (int i = 1; i <= page.areasTable.getRowsCount(); i++) {
          if (StringUtils.isBlank(page.areasTable.getColumnText(i, COLUMN_KEYWORDS))) {
            index = i;
            break;
          }
        }
        Assertions.assertThat(index)
            .withFailMessage(
                "Coverage with parameters and empty keywords is not displayed: " + data)
            .isPositive();
      } else {
        index = 1;
      }
      page.areasTable.clickActionButton(index, ACTION_ACTION);
    });
  }

  @When("Operator filter coverages on Station Route Keyword page:")
  public void filterCoverages(Map<String, String> data) {
    Coverage expected = new Coverage(resolveKeyValues(data));
    page.inFrame(() -> {
      page.areasTable.clearColumnFilters();
      if (StringUtils.isNotBlank(expected.getArea())) {
        page.areasTable.filterByColumn(COLUMN_AREA, expected.getArea());
      }
      if (CollectionUtils.isNotEmpty(expected.getKeywords()) && !"empty".equalsIgnoreCase(
          expected.getKeywords().get(0))) {
        page.areasTable.filterByColumn(COLUMN_KEYWORDS, expected.getKeywords().get(0));
      }
      if (StringUtils.isNotBlank(expected.getPrimaryDriver())) {
        page.areasTable.filterByColumn(COLUMN_PRIMARY_DRIVER, expected.getPrimaryDriver());
      }
      if (StringUtils.isNotBlank(expected.getFallbackDriver())) {
        page.areasTable.filterByColumn(COLUMN_FALLBACK_DRIVER, expected.getFallbackDriver());
      }
    });
  }

  @When("Operator add keywords on Station Route Keyword page:")
  public void addKeywords(List<String> keywords) {
    page.inFrame(() -> {
      page.addKeywords.click();
      page.addKeywordsTab.newKeywords.setValue(StringUtils.join(resolveValues(keywords), "\n"));
      page.addKeywordsTab.save.click();
    });
  }

  @When("Operator transfer keywords on Station Route Keyword page:")
  public void transferKeywords(List<String> keywords) {
    List<String> finalKeywords = resolveValues(keywords);
    page.inFrame(() -> {
      page.transferKeywords.click();
      int count = page.transferKeywordsTab.keywords.size();
      for (int i = 0; i < count; i++) {
        if (finalKeywords.contains(page.transferKeywordsTab.keywords.get(i).getText())) {
          page.transferKeywordsTab.checkboxes.get(i).check();
        }
      }
      page.transferKeywordsTab.transfer.click();
    });
  }

  @When("Operator change drivers on Station Route Keyword page:")
  public void changeDrivers(Map<String, String> data) {
    Coverage coverage = new Coverage(resolveKeyValues(data));
    page.inFrame(() -> {
      page.changeDrivers.click();
      if (StringUtils.isNotBlank(coverage.getPrimaryDriver())) {
        page.changeDriversTab.primaryDriver.selectValue(coverage.getPrimaryDriver());
      }
      if (StringUtils.isNotBlank(coverage.getFallbackDriver())) {
        page.changeDriversTab.fallbackDriver.selectValue(coverage.getFallbackDriver());
      }
      page.changeDriversTab.save.click();
    });
  }

  @When("Operator edit area on Station Route Keyword page:")
  public void editArea(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.editArea.click();
      if (StringUtils.isNotBlank(finalData.get("area"))) {
        page.editAreaTab.area.setValue(finalData.get("area"));
        putInList(KEY_LIST_OF_CREATED_AREAS, finalData.get("area"));
      }
      if (StringUtils.isNotBlank(finalData.get("areaVariations"))) {
        page.editAreaTab.areaVariation.setValue(finalData.get("areaVariations").replace(",", "\n"));
      }
      page.editAreaTab.save.click();
    });
  }

  @When("Operator verify there are no keywords to transfer on Station Route Keyword page")
  public void verifyNoKeywordsToTransfer() {
    page.inFrame(() -> {
      page.transferKeywords.click();
      Assertions.assertThat(page.transferKeywordsTab.noResultsFound.isDisplayed())
          .withFailMessage("'No Results Found' message is not displayed")
          .isTrue();
      Assertions.assertThat(page.transferKeywordsTab.keywords)
          .withFailMessage("Unexpected keywords are displayed")
          .isEmpty();
    });
  }

  @When("Operator remove keywords on Station Route Keyword page:")
  public void deleteKeywords(List<String> keywords) {
    List<String> finalKeywords = resolveValues(keywords);
    page.inFrame(() -> {
      page.removeKeywords.click();
      int count = page.removeKeywordsTab.keywords.size();
      for (int i = 0; i < count; i++) {
        if (finalKeywords.contains(page.removeKeywordsTab.keywords.get(i).getText())) {
          page.removeKeywordsTab.checkboxes.get(i).check();
        }
      }
      page.removeKeywordsTab.remove.click();
    });
  }

  @When("Operator verify keywords on Remove keywords tab on Station Route Keyword page:")
  public void verify(List<String> keywords) {
    page.inFrame(() -> {
      page.removeKeywords.click();
      page.removeKeywordsTab.waitUntilVisible();
      Assertions.assertThat(
              page.removeKeywordsTab.keywords.stream().map(PageElement::getText).collect(
                  Collectors.toList()))
          .as("List of keywords")
          .containsExactlyInAnyOrderElementsOf(resolveValues(keywords));
    });
  }

  @When("Operator verify keywords on Remove keywords dialog:")
  public void verifyRemoveKeywordsDialog(List<String> keywords) {
    page.inFrame(() -> {
      page.removeKeywordsDialog.waitUntilVisible();
      Assertions.assertThat(
              page.removeKeywordsDialog.keywords.stream().map(PageElement::getText).collect(
                  Collectors.toList()))
          .as("List of keywords to remove")
          .containsExactlyInAnyOrderElementsOf(resolveValues(keywords));
    });
  }

  @When("Operator verify coverages on Transfer keywords dialog:")
  public void verifyCoveragesOnRemoveKeywordsDialog(List<Map<String, String>> data) {
    List<Map<String, String>> finalData = resolveListOfMaps(data);
    page.inFrame(() -> {
      page.transferKeywordsDialog.waitUntilVisible();
      List<Coverage> actual = page.transferKeywordsDialog.coverages.stream()
          .map(AreaBox::readEntry)
          .collect(Collectors.toList());
      finalData.forEach(row -> {
        Coverage expected = new Coverage(row);
        Assertions.assertThat(actual)
            .withFailMessage(
                "Expected coverage is not displayed: " + expected + "\n" + "Actual: " + actual)
            .anyMatch(expected::matchedTo);
      });
    });
  }

  @When("Operator verify no coverages displayed on Transfer keywords dialog")
  public void verifyNoCoveragesOnRemoveKeywordsDialog() {
    page.inFrame(() -> {
      page.transferKeywordsDialog.waitUntilVisible();
      Assertions.assertThat(page.transferKeywordsDialog.noCoveragesFound.isDisplayed())
          .withFailMessage("'No coverages found' message is not displayed")
          .isTrue();
      Assertions.assertThat(page.transferKeywordsDialog.coverages)
          .withFailMessage("Unexpected coverages are displayed")
          .isEmpty();
    });
  }

  @When("Operator select coverage on Transfer keywords dialog:")
  public void selectCoverageOnRemoveKeywordsDialog(Map<String, String> data) {
    Coverage coverage = new Coverage(resolveKeyValues(data));
    page.inFrame(() -> {
      page.transferKeywordsDialog.waitUntilVisible();
      page.transferKeywordsDialog.coverages.stream()
          .filter(c -> coverage.matchedTo(c.readEntry()))
          .findFirst()
          .orElseThrow(
              () -> new AssertionFailure("Expected coverage is not displayed: " + coverage))
          .radio.jsClick();
    });
  }

  @When("Operator click 'Yes, transfer' button on Transfer keywords dialog")
  public void clickYesOnRemoveKeywordsDialog() {
    page.inFrame(() -> page.transferKeywordsDialog.yes.click());
  }

  @When("Operator verify 'Yes, transfer' button is disabled on Transfer keywords dialog")
  public void verifyYesIsDisabledOnRemoveKeywordsDialog() {
    page.inFrame(() ->
        Assertions.assertThat(page.transferKeywordsDialog.yes.isEnabled())
            .withFailMessage("''Yes, transfer' button' is not disabled")
            .isFalse()
    );
  }

  @When("Operator verify keywords on Transfer keywords dialog:")
  public void verifyTransferKeywordsDialog(List<String> keywords) {
    page.inFrame(() -> {
      page.transferKeywordsDialog.waitUntilVisible();
      Assertions.assertThat(
              page.transferKeywordsDialog.keywords.stream().map(PageElement::getText).collect(
                  Collectors.toList()))
          .as("List of keywords to transfer")
          .containsExactlyInAnyOrderElementsOf(resolveValues(keywords));
    });
  }

  @When("Operator click 'Yes, remove' button on Remove keywords dialog:")
  public void clickYesRemove() {
    page.inFrame(() -> {
      page.removeKeywordsDialog.waitUntilVisible();
      page.removeKeywordsDialog.yes.click();
    });
  }

  @When("Operator remove coverage on Station Route Keyword page")
  public void removeCoverage() {
    page.inFrame(() -> {
      page.removeCoverage.click();
      page.yesRemove.click();
    });
  }

  @When("Operator verify keywords on Add Keywords tab on Station Route Keyword page:")
  public void verifyKeywords(List<String> keywords) {
    page.inFrame(() -> {
      page.addKeywords.click();
      List<String> actual = page.addKeywordsTab.keywords.stream().map(PageElement::getText)
          .collect(Collectors.toList());
      Assertions.assertThat(actual).as("List of keywords")
          .containsExactlyInAnyOrderElementsOf(keywords);
    });
  }

  @When("Operator verify there are no keywords on Add Keywords tab on Station Route Keyword page")
  public void verifyEmptyKeywords() {
    page.inFrame(() -> {
      page.addKeywords.click();
      Assertions.assertThat(page.addKeywordsTab.keywords).as("List of keywords")
          .isEmpty();
    });
  }

  @When("Operator verify filter results on Station Route Keyword page:")
  public void verifyFilterCoverages(Map<String, String> data) {
    Coverage expected = new Coverage(resolveKeyValues(data));
    page.inFrame(() -> {
      List<Coverage> actual = page.areasTable.readAllEntities();
      if (StringUtils.isNotBlank(expected.getArea())) {
        Assertions.assertThat(actual).as("Barangay/City").allSatisfy(
            coverage -> Assertions.assertThat(coverage.getArea()).contains(expected.getArea()));
      }
      if (CollectionUtils.isNotEmpty(expected.getKeywords())) {
        Assertions.assertThat(actual).as("Address keywords").allSatisfy(
            coverage -> Assertions.assertThat(coverage.getKeywords())
                .anyMatch(k -> StringUtils.contains(k, expected.getKeywords().get(0))));
      }
      if (StringUtils.isNotBlank(expected.getPrimaryDriver())) {
        Assertions.assertThat(actual).as("Primary Driver").allSatisfy(
            coverage -> Assertions.assertThat(coverage.getPrimaryDriver())
                .contains(expected.getPrimaryDriver()));
      }
      if (StringUtils.isNotBlank(expected.getFallbackDriver())) {
        Assertions.assertThat(actual).as("Fallback Driver").allSatisfy(
            coverage -> Assertions.assertThat(coverage.getFallbackDriver())
                .contains(expected.getFallbackDriver()));
      }
    });
  }
}
