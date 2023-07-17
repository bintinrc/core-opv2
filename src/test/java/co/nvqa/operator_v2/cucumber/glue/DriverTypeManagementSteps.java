package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.DriverType;
import co.nvqa.operator_v2.model.DriverTypeParams;
import co.nvqa.operator_v2.selenium.page.DriverTypeManagementPage;
import co.nvqa.operator_v2.selenium.page.DriverTypeManagementPage.DriverTypesTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;

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
    dtmPage.inFrame(() -> {
      dtmPage.btnDownloadSCV.click();
    });
  }

  @When("Operator get all Driver Type params on Driver Type Management page")
  public void operatorGetAllDriverTypeParamsOnDriverTypeManagementPage() {
    List<DriverTypeParams> params = new ArrayList<DriverTypeParams>();
    dtmPage.inFrame(() -> {
      Integer pageRow = dtmPage.findElementsBy(
          By.xpath("//tr[@class=\"ant-table-row ant-table-row-level-0\"]")).size();
      for (int i = 1; i <= pageRow; i++) {
        DriverTypeParams driverType = dtmPage.driverTypesTable.readEntity(i);
        params.add(driverType);
      }
      put(KEY_LIST_OF_DRIVER_TYPE_PARAMS, params);
    });
  }

  @Then("Downloaded CSV file contains correct Driver Types data")
  public void downloadedCSVFileContainsCorrectDriverTypesData() {
    List<DriverTypeParams> params = get(KEY_LIST_OF_DRIVER_TYPE_PARAMS);
    dtmPage.verifyDownloadedFileContent(params);
  }

  @When("Operator create new Driver Type with the following attributes:")
  public void operatorCreateNewDriverTypeWithTheFollowingAttributes(Map<String, String> dataMap) {
    DriverTypeParams driverTypeParams = new DriverTypeParams(resolveKeyValues(dataMap));
    dtmPage.inFrame(() -> {
      dtmPage.createDriverType(driverTypeParams);
      put(KEY_CREATED_DRIVER_TYPE_NAME, driverTypeParams.getDriverTypeName());
      put(KEY_DRIVER_TYPE_PARAMS, driverTypeParams);
      putInList(KEY_LIST_OF_DRIVER_TYPE_PARAMS, driverTypeParams);
    });
  }

  @When("Operator edit new Driver Type with the following attributes:")
  public void operatorEditNewDriverTypeWithTheFollowingAttributes(Map<String, String> dataMap) {
    dtmPage.refreshPage();
    dtmPage.waitUntilLoaded();
    DriverTypeParams oldDriverType = get(KEY_DRIVER_TYPE_PARAMS);
    DriverTypeParams newDriverType = new DriverTypeParams();
    newDriverType.setDriverTypeName(resolveKeyValues(dataMap).get("driverTypeName"));
    newDriverType.setDriverTypeId(oldDriverType.getDriverTypeId());
    dtmPage.inFrame(() -> {
      dtmPage.searchDriverType.setValue("");
      dtmPage.searchDriverType.setValue(oldDriverType.getDriverTypeName());
      dtmPage.clickActionButtonOnTable(1, DriverTypesTable.ACTION_UPDATE);
      dtmPage.editDriverTypeDialog.waitUntilVisible();
      dtmPage.btnClear.click();
      dtmPage.editDriverTypeDialog.fillForm(newDriverType);
      dtmPage.clickUpdateButton();
    });

    put(KEY_DRIVER_TYPE_PARAMS, newDriverType);
  }

  @Then("Operator verify new Driver Type params")
  public void operatorVerifyNewDriverTypeIsCreatedSuccessfully() {
    DriverTypeParams driverTypeName = get(KEY_DRIVER_TYPE_PARAMS);
    dtmPage.refreshPage();
    dtmPage.waitUntilLoaded();
    dtmPage.inFrame(() -> {
      dtmPage.searchDriverType.setValue(driverTypeName.getDriverTypeName());
      DriverTypeParams actual = dtmPage.driverTypesTable.readEntity(1);

      Assertions.assertThat(
              actual.getDriverTypeName().equalsIgnoreCase(driverTypeName.getDriverTypeName()))
          .as(f("Driver type: %s not found!", driverTypeName.getDriverTypeName())).isTrue();

      Assertions.assertThat(
              actual.getDriverTypeId().equals(driverTypeName.getDriverTypeId()))
          .as(f("Driver id: %s not found!", driverTypeName.getDriverTypeId())).isTrue();
    });

    takesScreenshot();
  }

  @Then("Operator search created Driver Type using ID")
  public void operatorSearchDriverTypeById() {
    DriverTypeParams driverTypeName = get(KEY_DRIVER_TYPE_PARAMS);
    dtmPage.refreshPage();
    doWithRetry(() -> dtmPage.inFrame(() -> {
      dtmPage.waitUntilLoaded();
      dtmPage.searchDriverType.sendKeys(driverTypeName.getDriverTypeId());
      DriverTypeParams actual = dtmPage.driverTypesTable.readEntity(1);

      Assertions.assertThat(
                      actual.getDriverTypeName().equalsIgnoreCase(driverTypeName.getDriverTypeName()))
              .as(f("Driver type: %s not found!", driverTypeName.getDriverTypeName())).isTrue();

      Assertions.assertThat(
                      actual.getDriverTypeId().equals(driverTypeName.getDriverTypeId()))
              .as(f("Driver id: %s not found!", driverTypeName.getDriverTypeId())).isTrue();
    }), "Search created Driver Type using ID");
  }

  @Then("Operator verify all driver types are displayed on Driver Type Management page")
  public void operatorVerifyAllDriverTypesAreDisplayed() {
    List<DriverType> driverTypes = get(KEY_LIST_OF_DRIVER_TYPES);
    Integer expectedCount = driverTypes.size();
    dtmPage.inFrame(() -> {
      Integer actualCount = Integer.parseInt(dtmPage.rowsCount.getText());
      Assertions.assertThat(actualCount > 1)
          .as("Driver Types rows count")
          .isTrue();
      Assertions.assertThat(actualCount).as("Driver Types count").isEqualTo(expectedCount);
      takesScreenshot();
    });
  }

  @And("Operator get new Driver Type params on Driver Type Management page")
  public void operatorGetNewDriverTypeParamsOnDriverTypeManagementPage() {
    final DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
    dtmPage.inFrame(() -> {
      dtmPage.searchDriverType.setValue(driverTypeParams.getDriverTypeName());
      Map<String, String> driverTypeParamsData = dtmPage.driverTypesTable.readRow(1);
      DriverTypeParams driverTypeParamsObj = new DriverTypeParams();
      driverTypeParamsObj.setDriverTypeId(Long.parseLong(driverTypeParamsData.get("driverTypeId")));
      driverTypeParamsObj.setDriverTypeName(driverTypeParamsData.get("driverTypeName"));
      put(KEY_DRIVER_TYPE_PARAMS, driverTypeParamsObj);
      put(KEY_DRIVER_TYPE_ID, driverTypeParamsObj.getDriverTypeId());
      put(KEY_CREATED_DRIVER_TYPE_NAME, driverTypeParamsObj.getDriverTypeName());
    });
  }

  @When("^Operator delete new Driver Type on on Driver Type Management page$")
  public void operatorDeleteNewDriverTypeOnOnDriverTypeManagementPage() {
    dtmPage.inFrame(() -> {
      dtmPage.clickActionButtonOnTable(1, DriverTypesTable.ACTION_DELETE);
      dtmPage.confirmDeleteDialog.getActionButton("Delete").click();
    });
  }

  @Then("Operator verify new Driver Type is deleted successfully")
  public void operatorVerifyNewDriverTypeIsDeletedSuccessfully() {
    DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);
    dtmPage.refreshPage();
    dtmPage.waitUntilLoaded();
    dtmPage.inFrame(() -> {
      dtmPage.searchDriverType.setValue(driverTypeParams.getDriverTypeName());
      Assertions.assertThat(dtmPage.driverTypesTable.isTableEmpty())
          .as("Created Driver Type was not deleted").isFalse();
      remove(KEY_DRIVER_TYPE_ID);
    });
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

  @Then("Operator verify toast error message {string} displayed")
  public void operatorVerifyToastErrorMessageDisplayed(String message) {
    dtmPage.verifyToastErrorMessage(message);
  }
}
