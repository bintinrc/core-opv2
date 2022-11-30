package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.DriverType;
import co.nvqa.operator_v2.model.DriverTypeParams;
import co.nvqa.operator_v2.selenium.page.DriverTypeManagementPage;
import co.nvqa.operator_v2.selenium.page.DriverTypeManagementPage.DriverTypesTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;

/**
 * Modified by Sergey Mishanin
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class DriverTypeManagementSteps extends AbstractSteps {

  private DriverTypeManagementPage dtmPage;

  public DriverTypeManagementSteps() {
  }

  @Override
  public void init() {
    dtmPage = new DriverTypeManagementPage(getWebDriver());
  }

  @When("Operator click on Download CSV File button on Driver Type Management page")
  public void operatorClickOnDownloadCSVFileButtonOfDriverTypeManagementPage() {
    dtmPage.downloadFile();
  }

  @When("Operator get all Driver Type params on Driver Type Management page")
  public void operatorGetAllDriverTypeParamsOnDriverTypeManagementPage() {
    List<DriverTypeParams> params = dtmPage.driverTypesTable.readAllEntities();
    put(KEY_LIST_OF_DRIVER_TYPE_PARAMS, params);
  }

  @Then("Downloaded CSV file contains correct Driver Types data")
  public void downloadedCSVFileContainsCorrectDriverTypesData() {
    List<DriverTypeParams> params = get(KEY_LIST_OF_DRIVER_TYPE_PARAMS);
    dtmPage.verifyDownloadedFileContent(params);
  }

  @When("Operator create new Driver Type with the following attributes:")
  public void operatorCreateNewDriverTypeWithTheFollowingAttributes(Map<String, String> dataMap) {
    DriverTypeParams driverTypeParams = new DriverTypeParams(resolveKeyValues(dataMap));
    dtmPage.createDriverType(driverTypeParams);
    put(KEY_CREATED_DRIVER_TYPE_NAME, driverTypeParams.getDriverTypeName());
    put(KEY_DRIVER_TYPE_PARAMS, driverTypeParams);
    putInList(KEY_LIST_OF_DRIVER_TYPE_PARAMS, driverTypeParams);
  }

  @When("Operator edit new Driver Type with the following attributes:")
  public void operatorEditNewDriverTypeWithTheFollowingAttributes(Map<String, String> dataMap) {
    DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
    String searchString = driverTypeParams.getDriverTypeName();
    driverTypeParams.fromMap(resolveKeyValues(dataMap));
    dtmPage.searchDriverType.setValue(searchString);
    dtmPage.driverTypesTable.clickActionButton(1, DriverTypesTable.ACTION_EDIT);
    dtmPage.editDriverTypeDialog.fillForm(driverTypeParams);
    dtmPage.clickSubmitButton();
  }

  @Then("Operator verify new Driver Type params")
  public void operatorVerifyNewDriverTypeIsCreatedSuccessfully() {
    DriverTypeParams expected = get(KEY_DRIVER_TYPE_PARAMS);
    dtmPage.searchDriverType.setValue(expected.getDriverTypeName());
    DriverTypeParams actual = dtmPage.driverTypesTable.readEntity(1);
    expected.compareWithActual(actual);
    takesScreenshot();
  }

  @Then("Operator search created Driver Type using ID")
  public void operatorSearchDriverTypeById() {
    DriverTypeParams expected = get(KEY_DRIVER_TYPE_PARAMS);
    dtmPage.searchDriverType.setValue(expected.getDriverTypeId());
    DriverTypeParams actual = dtmPage.driverTypesTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @Then("Operator verify all driver types are displayed on Driver Type Management page")
  public void operatorVerifyAllDriverTypesAreDisplayed() {
    List<DriverType> driverTypes = get(KEY_LIST_OF_DRIVER_TYPES);
    String count = dtmPage.rowsCount.getText();
    int actualCount = Integer.parseInt(count.split(" ")[0]);
    Assertions.assertThat(actualCount).as("Driver Types count").isEqualTo(driverTypes.size());
    Assertions.assertThat(dtmPage.driverTypesTable.getRowsCount() > 1).as("Driver Types rows count")
        .isTrue();
    takesScreenshot();
  }

  @And("Operator get new Driver Type params on Driver Type Management page")
  public void operatorGetNewDriverTypeParamsOnDriverTypeManagementPage() {
    DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
    dtmPage.searchDriverType.setValue(driverTypeParams.getDriverTypeName());
    driverTypeParams = dtmPage.driverTypesTable.readEntity(1);
    put(KEY_DRIVER_TYPE_PARAMS, driverTypeParams);
    put(KEY_DRIVER_TYPE_ID, driverTypeParams.getDriverTypeId());
  }

  @When("^Operator delete new Driver Type on on Driver Type Management page$")
  public void operatorDeleteNewDriverTypeOnOnDriverTypeManagementPage() {
    DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
    dtmPage.searchDriverType.setValue(driverTypeParams.getDriverTypeName());
    dtmPage.driverTypesTable.clickActionButton(1, DriverTypesTable.ACTION_DELETE);
    dtmPage.confirmDeleteDialog.waitUntilVisible();
    dtmPage.confirmDeleteDialog.delete.click();
    dtmPage.confirmDeleteDialog.waitUntilInvisible();
    pause2s();
  }

  @Then("Operator verify new Driver Type is deleted successfully")
  public void operatorVerifyNewDriverTypeIsDeletedSuccessfully() {
    dtmPage.refreshPage();
    DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
    dtmPage.searchDriverType.setValue(driverTypeParams.getDriverTypeName());
    Assertions.assertThat(dtmPage.driverTypesTable.isTableEmpty())
        .as("Created Driver Type was not deleted").isFalse();
    remove(KEY_DRIVER_TYPE_ID);
    takesScreenshot();
  }

  @When("Operator configure filter on Driver Type Management page with the following attributes:")
  public void operatorConfigureFilterOnDriverTypeManagementPageWithTheFollowingAttributes(
      Map<String, String> dataMap) {
    DriverTypeParams driverTypeParams = new DriverTypeParams();
    driverTypeParams.fromMap(dataMap);
    dtmPage.searchDriverType.setValue("");
    dtmPage.filtersForm().fillForm(driverTypeParams);
    pause2s();
    put(KEY_DRIVER_TYPE_FILTER_PARAMS, driverTypeParams);
  }

  @When("Operator verify filter results on Driver Type Management page")
  public void operatorVerifyFilterResultsOnDriverTypeManagementPage() {
    DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_FILTER_PARAMS);
    dtmPage.verifyFilterResults(driverTypeParams);
    takesScreenshot();
  }
}
