package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.NvSoftAssertions;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.ThB2BPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

import static co.nvqa.operator_v2.selenium.page.MaskedPage.LOGGER;

@ScenarioScoped
public class ThB2BSteps extends AbstractSteps {

  private ThB2BPage page;

  @Override
  public void init() {
    page = new ThB2BPage(getWebDriver());
  }

  @When("Operator click {} button in b2b page")
  @When("Operator click {} button in Upload CSV dialog")
  public void clickButtonInB2BPage(String buttonName) {
    page.inFrame(() -> {
      switch (buttonName) {
        case "upload csv":
          page.uploadCsv.click();
          break;
        case "Download Sample File":
          page.uploadCsvDialog.downloadSampleFile.click();
          break;
        case "Upload":
          page.uploadCsvDialog.upload.click();
          break;
      }
    });
  }

  @Then("Operator verify sample CSV file is downloaded successfully on b2b page")
  public void verifyCsvFileDownloadedSuccessfully() {
    page.inFrame(() -> {
      String fileContent = "\n trackingId\",\"routeId\"\n"
          + "\"NVTH123\",\"1\"\n"
          + "\"NVTH124\",\"2\"\n";
      page.verifyFileDownloadedSuccessfully("th-b2b.csv",
          fileContent);
    });
  }

  @When("Operator upload auto_inbound csv file on b2b page")
  public void uploadCsvFile(List<Map<String, String>> data) {
    page.inFrame(() -> {
      List<Map<String, String>> dataMap = resolveListOfMaps(data);
      StringBuilder content = new StringBuilder(
          "trackingId,routeId\n");
      dataMap.forEach(row -> {
        content.append(row.get("trackingId")).append(",").append(row.get("routeId")).append("\n");
      });
      File file = page.createFile("th-b2b.csv", content.toString());
      page.uploadCsvDialog.fileUpload.setValue(file);
    });
  }

  @Then("Operator verifies that notification is displayed in b2b page:")
  public void operatorVerifySuccessReactToast(Map<String, String> data) {
    page.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      boolean waitUntilInvisible = Boolean.parseBoolean(
          finalData.getOrDefault("waitUntilInvisible", "false"));
      long start = new Date().getTime();
      AntNotification toastInfo;
      do {
        try {
          toastInfo = page.noticeNotifications.stream().filter(toast -> {
            String actualTop = toast.message.getNormalizedText();
            toast.message.moveToElement();
            LOGGER.info("Found notification: " + actualTop);
            String value = finalData.get("top");
            if (StringUtils.isNotBlank(value)) {
              if (value.startsWith("^")) {
                if (!actualTop.matches(value)) {
                  return false;
                }
              } else {
                if (!StringUtils.equalsIgnoreCase(value, actualTop)) {
                  return false;
                }
              }
            }
            value = finalData.get("bottom");
            if (StringUtils.isNotBlank(value)) {
              String actual = toast.description.getNormalizedText();
              toast.description.moveToElement();
              LOGGER.info("Found description: " + actual);
              if (value.startsWith("^")) {
                return actual.matches(value);
              } else {
                return StringUtils.equalsIgnoreCase(value, actual);
              }
            }
            return true;
          }).findFirst().orElse(null);
        } catch (Exception ex) {
          toastInfo = null;
          LOGGER.warn("Could not read notification", ex);
        }
      } while (toastInfo == null && new Date().getTime() - start < 30000);
      Assertions.assertThat(toastInfo)
          .withFailMessage("Toast is not displayed: " + finalData)
          .isNotNull();
      if (toastInfo != null && waitUntilInvisible) {
        if (!toastInfo.waitUntilInvisible(20)) {
          toastInfo.close.jsClick();
        }
      }
    });
  }

  @Then("Operator verifies results table contains the following details:")
  public void verifyResultsTableContainsCorrectDetails(List<Map<String, String>> dataMap) {
    page.inFrame(() -> {
      List<Map<String, String>> data = resolveListOfMaps(dataMap);
      NvSoftAssertions softly = new NvSoftAssertions();

      data.forEach(map -> {
        if (map.containsKey("trackingId")) {
          String expectedTrackingId = map.get("trackingId");
          boolean found = page.trackingIds.stream()
              .map(PageElement::getText)
              .anyMatch(expectedTrackingId::equals);
          softly.assertTrue("Tracking ID '" + expectedTrackingId + found, found);
        }
        if (map.containsKey("routeId")) {
          String expectedRouteId = map.get("routeId");
          boolean found = page.routeIds.stream()
              .map(PageElement::getText)
              .anyMatch(expectedRouteId::equals);
          softly.assertTrue("Route ID '" + expectedRouteId + found, found);
        }
        if (map.containsKey("status")) {
          String expectedStatus = map.get("status");
          boolean found = page.status.stream()
              .map(PageElement::getText)
              .anyMatch(expectedStatus::equals);
          softly.assertTrue("status" + expectedStatus + found, found);
        }
        if (map.containsKey("message")) {
          String expectedMessage = map.get("message");
          boolean found = page.messages.stream()
              .map(PageElement::getText)
              .anyMatch(expectedMessage::equals);
          softly.assertTrue("status" + expectedMessage + found, found);
        }
      });
      softly.assertAll();
    });
  }
}
