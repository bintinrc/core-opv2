package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.NinjaHubProvisioningPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.io.File;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class NinjaHubProvisioningSteps extends AbstractSteps
{
    private NinjaHubProvisioningPage ninjaHubProvisioningPage;

    public NinjaHubProvisioningSteps()
    {
    }

    @Override
    public void init()
    {
        ninjaHubProvisioningPage = new NinjaHubProvisioningPage(getWebDriver());
    }

    @When("^Operator download QR Code of Mobile Applications on Ninja Hub Provisioning page$")
    public void operatorDownloadQrCode()
    {
        File qrCodeFile = ninjaHubProvisioningPage.saveQrCodeAsPngFile();
        put("qrCodeFile", qrCodeFile);
    }

    @Then("^Operator verify the QR Code on Ninja Hub Provisioning page contains the same text as the link text printed below the QR Code$")
    public void operatorVerifyQrCodeIsContainsTheSameTextAsTheLinkText()
    {
        File qrCodeFile = get("qrCodeFile");
        ninjaHubProvisioningPage.verifyTheQrCodeTextIsEqualWithTheLinkText(qrCodeFile);
    }
}
