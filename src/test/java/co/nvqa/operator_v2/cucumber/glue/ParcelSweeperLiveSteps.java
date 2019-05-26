package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.ParcelSweeperLivePage;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;

@ScenarioScoped
public class ParcelSweeperLiveSteps extends AbstractSteps {

    private ParcelSweeperLivePage parcelSweeperLivePage;

    public ParcelSweeperLiveSteps()
    {
    }

    @Override
    public void init()
    {
        parcelSweeperLivePage = new ParcelSweeperLivePage(getWebDriver());
    }


    @Then("^Operator verifies on providing invalid trackingId errors displayed on Parcel Sweeper Live page$")
    public void operatorVerifiesWithInvalidTrackingIdProvidedErrorsDisplayed() {
        parcelSweeperLivePage.selectHubToBegin("OPV2-SG-HUB");
        parcelSweeperLivePage.scanTrackingId("invalid");
        parcelSweeperLivePage.verifyRouteIsIdNotFoundAndNil();
        parcelSweeperLivePage.verifyZoneNameIsNil();
        parcelSweeperLivePage.verifyDestinationHubIsNotFound();
    }


}
