package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.SalesPerson;
import co.nvqa.operator_v2.selenium.page.SalesPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class SalesSteps extends AbstractSteps {

  private SalesPage salesPage;

  public SalesSteps() {
  }

  @Override
  public void init() {
    salesPage = new SalesPage(getWebDriver());
  }

  @When("^Operator download sample CSV file for \"Sales Person Creation\" on Sales page$")
  public void operatorDownloadSampleCsvFileForSalesPersonCreationOnSalesPage() {
    salesPage.downloadSampleCsvFile();
  }

  @Then("^Operator verify sample CSV file for \"Sales Person Creation\" on Sales page is downloaded successfully$")
  public void operatorVerifySampleCsvFileForSalesPersonCreationOnSalesPageIsDownloadedSuccessfully() {
    salesPage.verifySampleCsvFileDownloadedSuccessfully();
  }

  @When("^Operator upload CSV contains multiple Sales Persons on Sales page using data below:$")
  public void operatorUploadCsvContainsMultipleSalesPersonsOnSalesPage(
      Map<String, String> dataTableAsMap) {
    List<SalesPerson> listOfSalesPerson = new ArrayList<>();
    int numberOfSalesPerson = Integer
        .parseInt(dataTableAsMap.getOrDefault("numberOfSalesPerson", "1"));

    for (int i = 0; i < numberOfSalesPerson; i++) {
      pause100ms(); //to avoid same uniqueString
      String uniqueString = generateDateUniqueString();
      SalesPerson salesPerson = new SalesPerson();
      salesPerson.setCode("DSP-" + uniqueString);
      salesPerson.setName("Dummy-" + uniqueString);
      listOfSalesPerson.add(salesPerson);
    }

    salesPage.uploadCsvSales(listOfSalesPerson);
    put(KEY_LIST_OF_SALES_PERSON, listOfSalesPerson);
  }

  @Then("^Operator verifies all Sales Persons created successfully$")
  public void operatorVerifiesAllSalesPersonsCreatedSuccessfully() {
    List<SalesPerson> listOfSalesPerson = get(KEY_LIST_OF_SALES_PERSON);
    salesPage.verifySalesPersonCreatedSuccessfully(listOfSalesPerson);
  }

  @Then("^Operator verifies all filters on Sales page works fine$")
  public void operatorVerifiesAllFiltersOnSalesPageWorksFine() {
    List<SalesPerson> listOfSalesPerson = get(KEY_LIST_OF_SALES_PERSON);
    salesPage.verifiesAllFiltersWorksFine(listOfSalesPerson);
  }
}
