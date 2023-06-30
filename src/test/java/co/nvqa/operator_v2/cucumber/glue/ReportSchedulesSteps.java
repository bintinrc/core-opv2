package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.ReportScheduleTemplate;
import co.nvqa.operator_v2.selenium.page.ReportSchedulesPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.JavascriptExecutor;

public class ReportSchedulesSteps extends AbstractSteps {

  private ReportSchedulesPage reportSchedulesPage;

  public ReportSchedulesSteps() {
  }

  @Override
  public void init() {
    reportSchedulesPage = new ReportSchedulesPage(getWebDriver());
  }

  @When("Report schedules page is loaded")
  public void reportSchedulesPageIsLoaded() {
    reportSchedulesPage.waitUntilLoaded();
  }

  @And("Operator clicks create new schedule button")
  public void operatorClicksCreateNewScheduleButton() {
    reportSchedulesPage.inFrame(() ->
        reportSchedulesPage.clickCreateTemplateBtn()
    );
  }

  @And("Create report scheduling page is loaded")
  public void createReportSchedulingPageIsLoaded() {
    reportSchedulesPage.inFrame(page -> {
      reportSchedulesPage.waitUntilLoaded();
      Assertions.assertThat(reportSchedulesPage.createReportSchedulingHeader.isDisplayed())
          .as("Available Headers is visible").isTrue();
    });

  }

  @And("Operator updates report scheduling with below data")
  @And("Operator creates report scheduling with below data")
  public void operatorFillReportSchedulingWithBelowData(Map<String, String> mapOfData) {
    reportSchedulesPage.inFrame(page -> {
      setReportSchedulingData(mapOfData);
      reportSchedulesPage.clickSaveScheduleReportButton();
      takesScreenshot();
    });
  }

  private void setReportSchedulingData(Map<String, String> mapOfData) {
    SoftAssertions softAssertion = new SoftAssertions();
    mapOfData = resolveKeyValues(mapOfData);
    ReportScheduleTemplate template =
        Objects.nonNull(get(KEY_REPORT_SCHEDULE_TEMPLATE)) ? get(KEY_REPORT_SCHEDULE_TEMPLATE)
            : new ReportScheduleTemplate();

    String name = mapOfData.get("name");
    String description = mapOfData.get("description");
    String frequency = mapOfData.get("frequency");
    String day = mapOfData.get("day");
    String reportFor = mapOfData.get("reportFor");
    String shipperLegacyId = mapOfData.get("shipperLegacyId");
    String shipperName = mapOfData.get("shipperName");
    String parentShipper = mapOfData.get("parentShipper");
    String scriptIds = mapOfData.get("scriptIds");
    String fileGroup = mapOfData.get("fileGroup");
    String reportTemplate = mapOfData.get("reportTemplate");
    String emails = mapOfData.get("emails");

    if (Objects.nonNull(name)) {
      reportSchedulesPage.setReportName(name);
      template.setName(name);
    }
    if (Objects.nonNull(description)) {
      reportSchedulesPage.setReportDescription(description);
      template.setDescription(description);
    }
    softAssertion.assertThat(reportSchedulesPage.reportType.selectedValue.getText())
        .as("Report type is correct").isEqualTo("SSB");
    if (Objects.nonNull(frequency)) {
      template.setFrequency(frequency);
      if (frequency.equals("Weekly")) {
        ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
            reportSchedulesPage.weeklyFrequency.getWebElement());
        softAssertion.assertThat(reportSchedulesPage.frequencyDescription.getText())
            .as("Frequency Definition is correct").isEqualTo(
                "You will receive reports weekly, on the day of your choice. It will contains orders of from the last Monday to Sunday.");
        reportSchedulesPage.dateOfTheWeek.selectValue(day);
        template.setDay(day);
      } else {
        ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
            reportSchedulesPage.monthlyFrequency.getWebElement());
        softAssertion.assertThat(reportSchedulesPage.frequencyDescription.getText())
            .as("Frequency Definition is correct").isEqualTo(
                "You will receive reports containing orders of the past 1 calendar month on 1st of each month.");
      }
    }
    if (Objects.nonNull(reportFor)) {
      template.setReportFor(reportFor);
      switch (reportFor) {
        case "All Shippers":
          ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
              reportSchedulesPage.allShippers.getWebElement());
          if (Objects.nonNull(parentShipper)) {
            reportSchedulesPage.forSearch.selectValue(parentShipper);
            template.setParentShipper(parentShipper);
          }
          break;
        case "Select One Shipper":
          ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
              reportSchedulesPage.selectOneShipper.getWebElement());
          if (Objects.nonNull(shipperLegacyId) & Objects.nonNull(shipperName)) {
            reportSchedulesPage.forSearch.selectValue(shipperLegacyId);
            template.setShipper(shipperLegacyId + " - " + shipperName);
          }
          break;
        case "Select By Parent Shipper":
          ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
              reportSchedulesPage.selectParentShipper.getWebElement());
          if (Objects.nonNull(parentShipper)) {
            reportSchedulesPage.forSearch.selectValue(parentShipper);
            template.setParentShipper(parentShipper);
          }
          break;
        case "Select By Script IDs":
          ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
              reportSchedulesPage.selectScriptIds.getWebElement());
          if (Objects.nonNull(scriptIds)) {
            List<String> pricingScriptIds = Arrays.stream(scriptIds.split(","))
                .collect(Collectors.toList());
            for (String id : pricingScriptIds) {
              reportSchedulesPage.forSearch.selectValue(id);
            }
            template.setScriptIds(pricingScriptIds);
          }
          break;
      }
    }
    if (Objects.nonNull(fileGroup)) {
      template.setFileGrouping(fileGroup);
      switch (fileGroup) {
        case "AGGREGATED":
          reportSchedulesPage.orderAggregation.check();
          break;
        case "SHIPPER":
          reportSchedulesPage.fileGroupByShipper.check();
          break;
        case "ALL":
          reportSchedulesPage.fileGroupByAllOrders.check();
          break;
        case "SCRIPT":
          reportSchedulesPage.fileGroupByScriptIds.check();
      }
    }
    if (Objects.nonNull(reportTemplate)) {
      if (Objects.nonNull(fileGroup)) {
        if (!fileGroup.equals("AGGREGATED")) {
          reportSchedulesPage.scrollAndSelectReportTemplate(reportTemplate);
          template.setReportTemplate(reportTemplate);
        } else {
          softAssertion.assertThat(
                  reportSchedulesPage.textBoxForReportTemplateForAggregatedOrders.getText())
              .as("Text is correct for aggregated report")
              .isEqualTo("* Template is not applicable for aggreagted report");
        }
      }

    }
    if (Objects.nonNull(emails)) {
      List<String> reportSendingEmails = Arrays.stream(emails.split(","))
          .collect(Collectors.toList());
      for (String email : reportSendingEmails) {
        reportSchedulesPage.email.selectValue(email);
      }
      template.setEmails(reportSendingEmails);
    }
    softAssertion.assertAll();
    put(KEY_REPORT_SCHEDULE_TEMPLATE, template);
  }

  @And("Operator verify create report schedule success message")
  public void verifySuccessMessageReportScheduleCreation() {
    reportSchedulesPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      String actualMessage = reportSchedulesPage.getReportScheduleToastMessage();
      softAssertions.assertThat(actualMessage).as("Create successful message is correct")
          .isEqualTo("Created Schedule Successfully.");
      softAssertions.assertAll();
    });
  }

  @And("Operator verify update report schedule success message")
  public void verifySuccessMessageReportScheduleUpdate() {
    reportSchedulesPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      String actualMessage = reportSchedulesPage.getReportScheduleToastMessage();
      softAssertions.assertThat(actualMessage).as("Update successful message is correct")
          .isEqualTo("Updated Schedule Successfully.");
      softAssertions.assertAll();
    });
  }

  @And("Operator search report schedule and got to edit page")
  public void verifySearchReportScheduleAndGoToEditPage() {
    ReportScheduleTemplate template = get(KEY_REPORT_SCHEDULE_TEMPLATE);
    reportSchedulesPage.refreshPage();
    reportSchedulesPage.inFrame(page -> {
      reportSchedulesPage.waitUntilLoaded();
      reportSchedulesPage.searchAndEditByReportScheduleName(template.getName());
    });

  }

  @And("Operator verify report schedule is updated successfully")
  @And("Operator verify report schedule is created successfully")
  public void verifyReportScheduleIsCreatedSuccessfully() {
    ReportScheduleTemplate template = get(KEY_REPORT_SCHEDULE_TEMPLATE);
    reportSchedulesPage.refreshPage();
    reportSchedulesPage.inFrame(page -> {
      reportSchedulesPage.waitUntilLoaded();
      reportSchedulesPage.searchAndEditByReportScheduleName(template.getName());
      SoftAssertions softAssertion = new SoftAssertions();
      softAssertion.assertThat(reportSchedulesPage.nameInput.getValue())
          .as("Report name is correct")
          .isEqualTo(template.getName());
      softAssertion.assertThat(reportSchedulesPage.descriptionInput.getValue())
          .as("Description is correct").isEqualTo(template.getDescription());
      switch (template.getFrequency()) {
        case "Weekly":
          softAssertion.assertThat(reportSchedulesPage.weeklyFrequency.isChecked())
              .as("Weekly Frequency is selected").isTrue();
          softAssertion.assertThat(reportSchedulesPage.dateOfTheWeek.getValue())
              .as("Selected day is correct").isEqualTo(template.getDay());
          break;
        case "Monthly":
          softAssertion.assertThat(reportSchedulesPage.monthlyFrequency.isChecked())
              .as("Monthly Frequency is selected").isTrue();
      }
      switch (template.getReportFor()) {
        case "All Shippers":
          softAssertion.assertThat(reportSchedulesPage.allShippers.isChecked())
              .as("All Shippers is selected").isTrue();
          break;
        case "Select One Shipper":
          softAssertion.assertThat(reportSchedulesPage.selectOneShipper.isChecked())
              .as("Select One Shipper is selected").isTrue();
          softAssertion.assertThat(reportSchedulesPage.forSearch.getValue())
              .as("Selected Shipper is Correct").isEqualTo(template.getShipper());
          break;
        case "Select By Parent Shipper":
          softAssertion.assertThat(reportSchedulesPage.selectParentShipper.isChecked())
              .as("Select By Parent Shipper is selected").isTrue();
          softAssertion.assertThat(reportSchedulesPage.forSearch.getValue())
              .as("Selected Parent Shipper is Correct").isEqualTo(template.getParentShipper());
          break;
        case "Select By Script IDs":
          pause(10000);
          softAssertion.assertThat(reportSchedulesPage.selectScriptIds.isChecked())
              .as("Select By Script IDs is selected").isTrue();
          softAssertion.assertThat(reportSchedulesPage.forSearch.getValues())
              .as("Selected Script IDs are Correct").isEqualTo(template.getScriptIds());
          break;
      }
      switch (template.getFileGrouping()) {
        case "AGGREGATED":
          softAssertion.assertThat(reportSchedulesPage.orderAggregation.isChecked())
              .as("order aggregation is selected correctly").isTrue();
          break;
        case "SHIPPER":
          softAssertion.assertThat(reportSchedulesPage.fileGroupByShipper.isChecked())
              .as("File grouping is selected as shipper correctly").isTrue();
          break;
        case "ALL":
          softAssertion.assertThat(reportSchedulesPage.fileGroupByAllOrders.isChecked())
              .as("File grouping is selected as All orders correctly").isTrue();
          break;
        case "SCRIPT":
          softAssertion.assertThat(reportSchedulesPage.fileGroupByScriptIds.isChecked())
              .as("File grouping is selected as Script correctly").isTrue();
      }
      if (!template.getFileGrouping().equals("AGGREGATED")) {
        softAssertion.assertThat(reportSchedulesPage.reportTemplate.getValue())
            .as("Report Template is correct").isEqualTo(template.getReportTemplate());
      }
      softAssertion.assertThat(reportSchedulesPage.email.getValues()).as("Emails are correct")
          .isEqualTo(template.getEmails());
      softAssertion.assertAll();
    });
  }

  @Then("Operator verifies that error toast is displayed on Report Schedules page as below:")
  public void operatorVerifiesThatErrorToastDisplayedOnOrderBillingPage(
      Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    String errorMessage = finalMapOfData.get("errorMessage");
    String top = finalMapOfData.get("top");
    String bottom = finalMapOfData.get("bottom");
    SoftAssertions softAssertions = new SoftAssertions();
    if (finalMapOfData.containsKey("errorMessage")) {
      reportSchedulesPage.inFrame(page -> {
        String actualMessage = reportSchedulesPage.getReportScheduleToastMessage();
        softAssertions.assertThat(actualMessage).as("Error message is correct")
            .isEqualTo(errorMessage);
      });

    }
    if (finalMapOfData.containsKey("top")) {
      Boolean isTitleDisplayed = reportSchedulesPage.toastErrors.stream().anyMatch(toastError ->
          StringUtils.equalsIgnoreCase(toastError.toastTop.getText(), top));
      softAssertions.assertThat(isTitleDisplayed).as("Error Top Title is correct")
          .isTrue();
    }
    if (finalMapOfData.containsKey("bottom")) {
      Boolean isMessageDisplayed = reportSchedulesPage.toastErrors.stream().anyMatch(toastError ->
          StringUtils.containsIgnoreCase(toastError.toastBottom.getText(), bottom));
      softAssertions.assertThat(isMessageDisplayed).as("Error Bottom Message is correct")
          .isTrue();
    }
    softAssertions.assertAll();
  }

}
