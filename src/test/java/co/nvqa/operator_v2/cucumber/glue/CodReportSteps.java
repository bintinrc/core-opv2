package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.model.CodInfo;
import co.nvqa.operator_v2.selenium.page.CodReportPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.ParseException;
import java.util.Locale;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class CodReportSteps extends AbstractSteps {

  private CodReportPage codReportPage;

  public CodReportSteps() {
  }

  @Override
  public void init() {
    codReportPage = new CodReportPage(getWebDriver());
  }

  @When("^Operator filter COD Report by Mode = \"([^\"]*)\" and Date = \"([^\"]*)\"$")
  public void operatorFilterCodReportByGivenModeAndDate(String mode, String dateAsString)
      throws ParseException {
    switch (StringUtils.normalizeSpace(mode.toLowerCase(Locale.ROOT))) {
      case "get cods for a day":
        codReportPage.getCodsForADay.click();
        break;
      case "get driver cods for a route day":
        codReportPage.getDriverCodsForARouteDay.click();
    }
    codReportPage.date.setDate(YYYY_MM_DD_SDF.parse(dateAsString));
    codReportPage.waitWhilePageIsLoading();
  }

  @Then("^Operator verify COR record on COD Report page:$")
  public void operatorVerifyOrderIsExistWithCorrectInfo(Map<String, String> data) {
    CodInfo expected = new CodInfo(resolveKeyValues(data));
    int index = codReportPage.codTable.findRow(expected.getTrackingId());
    Assertions.assertThat(index)
        .as("Index of row with Tracking ID " + expected.getTrackingId())
        .isPositive();
    CodInfo actual = codReportPage.codTable.readEntity(index);
    expected.compareWithActual(actual);
  }

  @When("^Operator download COD Report$")
  public void operatorDownloadCodReport() {
    codReportPage.downloadCsv.click();
  }

  @Then("^Operator verify the downloaded COD Report data is correct$")
  public void operatorVerifyTheDownloadedCodReportDataIsCorrect() {
    Order order = get(KEY_ORDER_DETAILS);
    codReportPage.verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(order);
  }
}