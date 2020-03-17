package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.hub.HubRelationData;
import co.nvqa.operator_v2.selenium.page.MovementVisualizationPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tristania Siagian
 */

public class MovementVisualizationSteps extends AbstractSteps {
    private MovementVisualizationPage movementVisualizationPage;

    public MovementVisualizationSteps() {
    }

    @Override
    public void init() {
        movementVisualizationPage = new MovementVisualizationPage(getWebDriver());
    }

    @When("Operator selects the Hub Type of {string} on Movement Visualization Page")
    public void operatorSelectsTheHubTypeOfOnMovementVisualizationPage(String hubType) {
        movementVisualizationPage.selectHubType(hubType);
    }

    @When("Operator selects the Hub by name {string}")
    public void operatorSelectsTheHubByName(String hubName) {
        movementVisualizationPage.selectHub(hubName);
    }

    @And("Operator clicks the selected Hub")
    public void operatorClicksTheSelectedHub() {
        movementVisualizationPage.clickOnHubName();
    }

    @Then("Operator verifies the list of {string} shown on Movement Visualization Page is the same to the endpoint fired")
    public void operatorVerifiesTheListShownOnMovementVisualizationPageIsTheSameToTheEndpointFired(String hubType) {
        List<String> relationHub = new ArrayList<>();
        HubRelationData hubRelationData = get(KEY_LIST_OF_HUB_RELATIONS);
        int index = hubRelationData.getData().size();

        if ("origin".equalsIgnoreCase(hubType)) {
            for (int i = 0; i < index; i++) {
                relationHub.add(hubRelationData.getData().get(i).getDestinationHubName());
            }
        } else if ("destination".equalsIgnoreCase(hubType)) {
            for (int i = 0; i < index; i++) {
                relationHub.add(hubRelationData.getData().get(i).getOriginHubName());
            }
        }
        movementVisualizationPage.verifiesHubShownIsTheSameToApi(relationHub);
    }

    @When("Operator clicks the first result on the list shown on Movement Visualization Page")
    public void operatorClicksTheFirstResultOnTheListShownOnMovementVisualizationPage() {
        movementVisualizationPage.clickIndexResult();
    }

    @Then("Operator verifies the relation of hub is right")
    public void operatorVerifiesTheRelationOfHubIsRight() {
        movementVisualizationPage.clickViewScheduleButtonAndVerifiesScheduleIsOpened();
    }

    @And("Operator clears the filters in Movement Visualization Page")
    public void operatorClearsTheFiltersInMovementVisualizationPage() {
        movementVisualizationPage.clearFilter();
    }

    @When("Operator clicks Edit Schedule Button on the Movement Schedule Modal")
    public void operatorClicksEditScheduleButtonOnTheMovementScheduleModal() {
        movementVisualizationPage.clickEditButtonOnViewScheduleModal();
    }

    @And("Operator edits the selected Movement Schedule")
    public void operatorEditsTheSelectedMovementSchedule() {
        movementVisualizationPage.editMovement();
    }

    @And("Operator close the View Schedule Modal on Movement Visualization Page")
    public void operatorCloseTheViewScheduleModalOnMovementVisualizationPage() {
        movementVisualizationPage.closeViewScheduleModal();
    }

    @Then("Operator verifies that the newly added relation is existed")
    public void operatorVerifiesThatTheNewlyAddedRelationIsExisted() {
        movementVisualizationPage.verifiesScheduleIsEdited();
    }

    @Then("Operator deletes the newly added relation from Movement Visualization Page")
    public void operatorDeletesTheNewlyAddedRelationFromMovementVisualizationPage() {
        movementVisualizationPage.deleteMovementChanging();
    }
}