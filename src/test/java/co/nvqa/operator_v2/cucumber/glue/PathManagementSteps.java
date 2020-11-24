package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.StationMovementSchedule;
import co.nvqa.operator_v2.selenium.page.PathManagementPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

/**
 * Created on 17/11/20.
 *
 * @author refowork
 */
@ScenarioScoped
public class PathManagementSteps extends AbstractSteps {
    private PathManagementPage pathManagementPage;

    public PathManagementSteps() {

    }

    @Override
    public void init() {
        pathManagementPage = new PathManagementPage(getWebDriver());
    }

    @And("Operator verifies path management page is loaded")
    public void operatorMovementTripPageIsLoaded() {
        pathManagementPage.switchTo();
        pathManagementPage.defaultPathButton.waitUntilClickable(30);
    }

    @And("Operator clicks show or hide filters")
    public void operatorClickShowHideFilters() {
        pathManagementPage.showHideFilters.click();
    }

    @And("Operator selects {string} in {string} filter")
    public void operatorSelectsValueInFilter(String value, String filter) {
        String resolvedValue = resolveValue(value);
        if ("Path Type".equals(filter)) {
            pathManagementPage.selectPathType(resolvedValue);
        }
        if ("Origin Hub".equals(filter)) {
            pathManagementPage.selectOriginHub(resolvedValue);
        }
        if ("Destination Hub".equals(filter)) {
            pathManagementPage.selectDestinationHub(resolvedValue);
        }
    }

    @And("Operator selects {string} and {string} as origin and destination hub")
    public void operatorSelectsOriginAndDestinationHub(String originHub, String destinationHub) {
        final String resolvedOriginHub = resolveValue(originHub);
        final String resolvedDestinationHub = resolveValue(destinationHub);
        retryIfRuntimeExceptionOccurred(() -> {
            try {
                if (!("".equals(resolvedOriginHub))) {
                    operatorSelectsValueInFilter(resolvedOriginHub, "Origin Hub");
                }
                if (!("".equals(resolvedDestinationHub))) {
                    operatorSelectsValueInFilter(resolvedDestinationHub, "Destination Hub");
                }
            } catch (Throwable ex) {
                NvLogger.error(ex.getMessage());
                NvLogger.info("Hub not found, retrying...");
                pathManagementPage.refreshPage();
                operatorMovementTripPageIsLoaded();
                operatorClickShowHideFilters();
                throw ex;
            }
        }, 10);
    }

    @And("Operator clicks load selection button")
    public void operatorClicksLoadSelectionButton() {
        pathManagementPage.loadSelectionButton.click();
        pause2s();
    }

    @And("Operator verify {string} data appear in path table")
    public void operatorVerifyAppearInPathTable(String pathType) {
        pathManagementPage.verifyDataAppearInPathTable(pathType);
    }

    @And("Operator verify path data from {string} to {string} appear in path table")
    public void operatorVerifyPathDataAppearInPathTable(String originHub, String destinationHub) {
        String resolvedOriginHub = resolveValue(originHub);
        String resolvedDestinationHub = resolveValue(destinationHub);
        pathManagementPage.verifyPathDataAppearInPathTable(resolvedOriginHub, resolvedDestinationHub);
    }

    @When("Operator click {string} hyperlink button")
    public void operatorClickHyperlinkButton(String hyperlinkAction) {
        if ("view".equals(hyperlinkAction)) {
            pathManagementPage.viewFirstRow.click();
        }
        pathManagementPage.pathDetailsModal.waitUntilVisible();
    }

    @Then("Operator verify shown {string} path details modal data")
    public void operatorVerifyShownPathDetailsModalData(String pathType) {
        pathManagementPage.verifyShownPathDetail(pathType);
    }

    @And("Operator searches {string} in {string} field")
    public void operatorSearchesInField(String value, String field) {
        String resolvedValue = resolveValue(value);
        if ("Origin Hub".equals(field)) {
            pathManagementPage.searchOriginHub(resolvedValue);
        }
        if ("Destination Hub".equals(field)) {
            pathManagementPage.searchDestinationHub(resolvedValue);
        }
        if ("Path".equals(field)) {
            pathManagementPage.searchPath(resolvedValue);
        }
    }

    @Then("Operator verify no results found message shown in path management page")
    public void operatorVerifyNoResultsFoundMessageShownInPathManagementPage() {
        pathManagementPage.verifyNoResultsFound();
    }

}
