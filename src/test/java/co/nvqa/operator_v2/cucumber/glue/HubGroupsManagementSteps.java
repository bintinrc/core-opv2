package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.HubsGroup;
import co.nvqa.operator_v2.selenium.page.HubsGroupManagementPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

/**
 *
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class HubGroupsManagementSteps extends AbstractSteps
{
    private HubsGroupManagementPage hubsGroupManagementPage;
    public static final String KEY_CREATED_HUBS_GROUP= "KEY_CREATED_HUBS_GROUP";

    @Inject
    public HubGroupsManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        hubsGroupManagementPage = new HubsGroupManagementPage(getWebDriver());
    }

    @When("^Operator create new Hub Group on Hubs Group Management page using data below:$")
    public void operatorCreateNewHubGroupOnHubGroupsManagementPageUsingDataBelow(Map<String, String> mapOfData)
    {
        HubsGroup hubsGroup = new HubsGroup();
        hubsGroup.fromMap(mapOfData);
        hubsGroupManagementPage.createHubsGroup(hubsGroup);
        put(KEY_CREATED_HUBS_GROUP, hubsGroup);
    }

    @Then("^Operator verify created Hubs Group properties on Hubs Group Management page$")
    public void operatorVerifyCreatedHubsGroupPropertiesOnHubsGroupManagementPage()
    {
        HubsGroup hubsGroup = get(KEY_CREATED_HUBS_GROUP);
        hubsGroupManagementPage.verifyHubsGroup(hubsGroup.getName(), hubsGroup);
        put(KEY_CREATED_HUBS_GROUP_ID, hubsGroup.getId());
    }

    @When("^Operator update created Hub Group on Hubs Group Management page using data below:$")
    public void operatorUpdateCreatedHubGroupOnHubsGroupManagementPageUsingDataBelow(Map<String, String> mapOfData)
    {
        HubsGroup hubsGroup = get(KEY_CREATED_HUBS_GROUP);
        String hubsGroupName = hubsGroup.getName();
        hubsGroup.fromMap(mapOfData);
        hubsGroupManagementPage.editHubsGroup(hubsGroupName, hubsGroup);
    }

    @When("^Operator delete created Hub Group on Hubs Group Management page$")
    public void operatorDeleteCreatedHubGroupOnHubsGroupManagementPage()
    {
        HubsGroup hubsGroup = get(KEY_CREATED_HUBS_GROUP);
        hubsGroupManagementPage.deleteHubsGroup(hubsGroup.getId());
    }

    @Then("^Operator verify created Hub Group was deleted successfully on Hubs Group Management page$")
    public void operatorVerifyCreatedHubGroupWasDeletedSuccessfullyOnHubsGroupManagementPage()
    {
        HubsGroup hubsGroup = get(KEY_CREATED_HUBS_GROUP);
        hubsGroupManagementPage.verifyHubsGroupDeleted(hubsGroup.getId());
        remove(KEY_CREATED_HUBS_GROUP);
        remove(KEY_CREATED_HUBS_GROUP_ID);
    }
}
