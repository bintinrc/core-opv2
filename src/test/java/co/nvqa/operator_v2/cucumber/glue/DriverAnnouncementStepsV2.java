package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.DriverAnnouncementPageV2;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import lombok.NoArgsConstructor;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;

@ScenarioScoped
@NoArgsConstructor
public class DriverAnnouncementStepsV2 extends AbstractSteps {

  private DriverAnnouncementPageV2 daPage;

  @Override
  public void init() {
    daPage = new DriverAnnouncementPageV2(getWebDriver());
  }

  @When("Operator select the first row on Driver Announcement page")
  public void operatorSelectTheFirstRowOnDriverAnnouncementPage() {
    doWithRetry(() -> daPage.inFrame(() -> daPage.verifyRowOnDriverAnnouncementPage(1)),
        "Select and verify first row data");
  }

  @And("Operator close announcement drawer on Driver Announcement page")
  public void operatorCloseAnnouncementDrawerOnDriverAnnouncementPage() {
    doWithRetry(() -> daPage.inFrame(() -> daPage.closeAnnouncementDrawer()),
        "Close Announcement Drawer");
  }

  @And("Operator search {string} on Driver Announcement page")
  public void operatorSearchKeywordOnDriverAnnouncementPage(String keyword) {
    daPage.inFrame(() -> daPage.searchDriverAnnouncement(keyword));
  }

  @Then("Operator verifies announcement {string} contains {string}")
  public void operatorVerifiesAnnouncementSubjectContains(String category, String keyword) {
    daPage.inFrame(() -> daPage.verifyAnnouncementContains(category, keyword));
  }

  @And("Operator verify csv file attach in Driver Announcement drawer")
  public void operatorVerifyCsvFileAttachInDriverAnnouncementDrawer() {
    daPage.inFrame(() -> daPage.verifyUploadedCsvFileAppear());
  }

  @And("Operator create Announcement on Driver Announcement page")
  public void operatorCreateNormalAnnouncementOnDriverAnnouncementPage(Map<String, Object> data) {
    daPage.inFrame(() -> {
      daPage.createMultipleNormalAnnouncement(data, 1)
          .forEach((String subject) -> putInList(KEY_LIST_DRIVER_ANNOUNCEMENT_SUBJECTS, subject));
    });
  }

  @Then("Operator verify important Driver Announcement successfully sent")
  public void operatorVerifyImportantDriverAnnouncementSuccessfullySent() {
    daPage.inFrame(() -> {
      List<String> subjects = getList(KEY_LIST_DRIVER_ANNOUNCEMENT_SUBJECTS, String.class);
      subjects.forEach((String subject) -> {
        daPage.searchDriverAnnouncement(subject);
        String rowData = f("//td[@class='ant-table-cell']/div[span[text()='%s'] and *]", subject);
        boolean isDataDisplayed = daPage.findElementsBy(By.xpath(rowData)).size() > 0;
        Assertions.assertThat(isDataDisplayed).as("Important data should be displayed").isTrue();
      });
    });
  }

  @Then("Operator verify important Driver Payroll successfully sent")
  public void operatorVerifyImportantDriverPayrollSuccessfullySent() {
    daPage.inFrame(() -> {
      daPage.verifyAnnouncementSent();
      List<String> subjects = getList(KEY_LIST_DRIVER_PAYROLL_SUBJECTS, String.class);
      subjects.forEach((String subject) -> {
        daPage.searchDriverAnnouncement(subject);
        String rowData = f("//td[@class='ant-table-cell']/div[span[text()='%s'] and *]", subject);
        boolean isDataDisplayed = daPage.findElementsBy(By.xpath(rowData)).size() > 0;
        Assertions.assertThat(isDataDisplayed).as("Important data should be displayed").isTrue();
      });
    });
  }

  @And("Operator send payroll report on Driver Announcement page")
  public void operatorSendPayrollReportOnDriverAnnouncementPage(Map<String, String> data) {
    String fileName = data.get("file");
    ClassLoader loader = getClass().getClassLoader();
    File file = new File(
        Objects.requireNonNull(loader.getResource(fileName)).getFile()).getAbsoluteFile();
    daPage.inFrame(() -> {
      String subject = daPage.operatorSendPayrollReport(file, data);
      putInList(KEY_LIST_DRIVER_PAYROLL_SUBJECTS, subject);
    });
  }

  @Then("Operator verify failed to upload payroll report")
  public void operatorVerifyFailedToUploadPayrollReport() {
    daPage.inFrame(() -> daPage.verifyFailedUploadPayrollReport());
  }

  @Then("Operator verify Driver Announcement successfully sent")
  public void operatorVerifyDriverAnnouncementSuccessfullySent() {
    daPage.inFrame(() -> daPage.verifyAnnouncementSent());
  }
}
