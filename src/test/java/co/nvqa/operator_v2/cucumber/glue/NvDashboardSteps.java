package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.NvDashboardPage;
import com.google.inject.Inject;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.collections.CollectionUtils;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class NvDashboardSteps extends AbstractSteps
{
    private NvDashboardPage nvDashboardPage;

    @Inject
    public NvDashboardSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        nvDashboardPage = new NvDashboardPage(getWebDriver());
    }

    @Then("^Operator validate new Shipper is logged in on Dashboard site$")
    public void operatorValidateNewShipperIsLoggedInOnDashboardSite()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        nvDashboardPage.validateUserInfo(shipper.getName(), shipper.getEmail());
    }

    @And("^Operator go to menu \"([^\"]*)\" -> \"([^\"]*)\" on Dashboard site$")
    public void operatorGoToMenuOnDashboardSite(String item1, String item2)
    {
        nvDashboardPage.selectMenuItem(item1, item2);
    }

    @Then("^Operator verify pickup addresses of the new Shipper on Dashboard site$")
    public void operatorVerifyPickupAddressesOfTheNewShipperOnDashboardSite()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        if (shipper.getPickup() != null && CollectionUtils.isNotEmpty(shipper.getPickup().getReservationPickupAddresses()))
        {
            shipper.getPickup().getReservationPickupAddresses().forEach(nvDashboardPage::validatePickupAddressExists);
        }
    }
}
