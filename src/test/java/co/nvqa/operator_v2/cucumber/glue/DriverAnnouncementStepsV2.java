package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.DriverAnnouncementPageV2;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.Map;
import lombok.NoArgsConstructor;

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
    daPage.inFrame(() -> daPage.verifyRowOnDriverAnnouncementPage(1));
  }

  @And("Operator close announcement drawer on Driver Announcement page")
  public void operatorCloseAnnouncementDrawerOnDriverAnnouncementPage() {
    daPage.inFrame(() -> daPage.closeAnnouncementDrawer());
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
    daPage.inFrame(() -> daPage.createMultipleNormalAnnouncement(data, 1));
  }

  @Then("Operator verify Driver Announcement successfully sent")
  public void operatorVerifyDriverAnnouncementSuccessfullySent() {
    daPage.inFrame(() -> daPage.verifyAnnouncementSent());
  }

  @And("Operator send payroll report on Driver Announcement page")
  public void operatorSendPayrollReportOnDriverAnnouncementPage(Map<String, String> data) {
    String fileName = data.get("file");
    ClassLoader loader = getClass().getClassLoader();
    File file = new File(loader.getResource(fileName).getFile()).getAbsoluteFile();
    daPage.inFrame(() -> daPage.operatorSendPayrollReport(file ,data));
  }

  @Then("Operator verify failed to upload payroll report")
  public void operatorVerifyFailedToUploadPayrollReport() {
    daPage.inFrame(() -> {
      daPage.verifyFailedUploadPayrollReport();
    });
  }
}
