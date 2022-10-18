package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.selenium.page.MAWBmanagementPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.apache.commons.lang3.RandomStringUtils;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Array;
import java.util.*;


public class MAWBmanagementSteps extends AbstractSteps{
    private static final Logger LOGGER = LoggerFactory.getLogger(MAWBmanagementSteps.class);

    private MAWBmanagementPage mawbManagementgPage;

    public MAWBmanagementSteps() {
    }

    @Override
    public void init() {
        mawbManagementgPage = new MAWBmanagementPage(getWebDriver());
    }

    @Then("Operator verifies {string} UI on MAWB Management Page")
    public void operatorVerifiesUIonMAWBManagementPage(String section){
        mawbManagementgPage.waitWhilePageIsLoading();
        mawbManagementgPage.switchTo();
        switch (section){
            case "Search by MAWB Number":
                mawbManagementgPage.verifySearchByMawbUI();
                break;
            case "Search by Vendor":
                mawbManagementgPage.verifySearchByVendorUI();
                break;
        }
    }

    @When("Operator add shipment IDs below to search by MAWB on MAWB Management page:")
    public void operatorAddShipmentIDsToSearchByMAWB(List<String> listMAWBs){
        listMAWBs = resolveValues(listMAWBs);
        List<String> FinallistOfMAWBs = new ArrayList<>();
        listMAWBs.forEach((id) -> {
            List<String> items = new ArrayList<>();
            if (id.contains("GENERATED 100 INVALID MAWB")){
                for (int i = 0;i<100;i++)
                    items.add(f("999-%s", RandomStringUtils.randomAlphabetic(6)));
            } else
                items = Arrays.asList(id.replaceAll("\\[|\\]| ","").split(","));
            FinallistOfMAWBs.addAll(items);
        });
        mawbManagementgPage.addShipmentToSearchBox(FinallistOfMAWBs);
    }

    @When("Operator clicks on {string} button on MAWB Management Page")
    public void operatorClicksOnButton(String button){
        switch (button){
            case "Search MAWB":
                mawbManagementgPage.searchByMAWBbutton.click();
                break;
            case "Search by Vendor":
                mawbManagementgPage.searchByVendorButton.click();
                break;

            case "Reload":
                mawbManagementgPage.mawbtable.reloadButton.click();
                pause1s();
                mawbManagementgPage.mawbtable.reloadSpin.waitUntilInvisible();
                pause1s();
                break;
        }

    }

    @Then("Operator verifies Search MAWB Management Page")
    public void operatorVerifiesSearchMAWBPage(){
        mawbManagementgPage.searchByMAWBbutton.waitUntilInvisible();
        mawbManagementgPage.waitWhilePageIsLoading();
        mawbManagementgPage.mawbtable.VerifySearchResultPage();
    }

    @Then("Operator verifies error message below on MAWB Management Page:")
    public void operatorVerifiesErrorMAWBPage(String expectedMessage){
        mawbManagementgPage.verifyErrorMessage(expectedMessage);
    }

    @When("Operator clicks to go back button on MAWB Management page")
    public void operatorClicksGoBackButtonOnMAWBManagementPage(){
        mawbManagementgPage.closeButton.click();
    }

    @Then("Operator verifies total {int} results shown on MAWB Management Page")
    public void operatorVerifiesTotalResult(int expectedNumber){
        String expectedMessage = f("Showing %1$d of %1$d results",expectedNumber);
        mawbManagementgPage.mawbtable.verifyTotalSearchRecord(expectedMessage);
    }

    @Then("Operator verifies error toast message on MAWB Management Page:")
    public void operatorVerifiesErrorToastMessage(String expectedMessage){
        Assertions.assertThat(mawbManagementgPage.getAntTopTextV2()).as("Error message is the same").isEqualTo(expectedMessage);
    }

    @Given("Operator searchs by vendor following data below on MAWB Management page:")
    public void operatorSearchsByVendor(Map<String,String> data){
        Map<String,String> resolvedData = resolveKeyValues(data);
        pause3s();
        mawbManagementgPage.SearchByVendorInputData(resolvedData);

    }

    @When("Operator removes text of {string} field on MAWB Management page")
    public void operatorRemovesText(String fieldName){
        mawbManagementgPage.clearTextonField(fieldName);
    }

    @Then("Operator verifies Mandatory require error message of {string} field on MAWB Management page")
    public void operatorVerifiesMandatoryErrorMessage(String fieldName){
        mawbManagementgPage.verifyMandatoryFieldErrorMessageMAWBPage(fieldName);

    }

    @Then("Operator verifies button {string} is disalbe on MAWB Management page")
    public void operatorVerifiesButtonIsDisable(String button){
        switch (button){
            case "Search by Vendor":
                Assertions.assertThat(mawbManagementgPage.searchByVendorButton.getAttribute("disabled"))
                        .as("Search by Vendor button is disable").isEqualTo("true");
                break;
        }
    }

}
