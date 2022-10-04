package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.sort.hub.AirTrip;
import co.nvqa.commons.model.sort.hub.Airport;
import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.selenium.page.AirportTripManagementPage;
import co.nvqa.operator_v2.selenium.page.MAWBmanagementPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static co.nvqa.operator_v2.selenium.page.AirportTripManagementPage.AirportTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.AirportTripManagementPage.AirportTable.COLUMN_AIRTRIP_ID;

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
        }
    }


}
