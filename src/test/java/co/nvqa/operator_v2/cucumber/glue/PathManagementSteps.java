package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.sort.hub.movement_trips.MovementTripSchedule;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.PathManagementPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
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
                if (StringUtils.isNotEmpty(resolvedOriginHub)) {
                    operatorSelectsValueInFilter(resolvedOriginHub, "Origin Hub");
                }
                if (StringUtils.isNotEmpty(resolvedDestinationHub)) {
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

    @When("Operator clicks add manual path button")
    public void operatorClicksAddManualPathButton() {
        pathManagementPage.addManualPathButton.click();
        pathManagementPage.createManualPathModal.waitUntilVisible();
        pause1s();
    }

    @And("Operator verify {string} data appear in path table")
    public void operatorVerifyAppearInPathTable(String pathType) {
        pathManagementPage.verifyDataAppearInPathTable(pathType);
    }

    @And("Operator verify path data from {string} to {string} appear in path table")
    public void operatorVerifyPathDataAppearInPathTable(String originHub, String destinationHub) {
        String resolvedOriginHub = resolveValue(originHub);
        String resolvedDestinationHub = resolveValue(destinationHub);
        List<String> passedHub = Arrays.asList(resolvedOriginHub, resolvedDestinationHub);
        pathManagementPage.verifyPathDataAppearInPathTable(resolvedOriginHub, resolvedDestinationHub, passedHub);
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

    @And("Operator create manual path with following data:")
    public void operatorCreateManualPathWithFollowingData(Map<String, String> mapOfData) {
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        String originHubName = resolvedMapOfData.get("originHubName");
        String destinationHubName = resolvedMapOfData.get("destinationHubName");
        String transitHubName = resolvedMapOfData.get("transitHubName");

        pathManagementPage.createManualPath(originHubName, destinationHubName, transitHubName);
    }

    @Then("Operator verify a notification with message {string} is shown on path management page")
    public void operatorVerifyANotificationWithMessageIsShownOnPathManagementPage(String notificationMessage) {
        String resolvedNotificationMessage = resolveValue(notificationMessage);
        pathManagementPage.verifyNotificationMessageIsShown(resolvedNotificationMessage);
    }

    public MovementTripSchedule getCreatedMovementScheduleWithTripById(Long movementScheduleWithTripId) {
        MovementTripSchedule movementTripSchedule = new MovementTripSchedule();
        List<MovementTripSchedule> movementTripScheduleList = get(KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP);
        for (MovementTripSchedule tripSchedule : movementTripScheduleList) {
            if (tripSchedule.getId().equals(movementScheduleWithTripId)) {
                movementTripSchedule = tripSchedule;
            }
        }
        return movementTripSchedule;
    }

    @And("Operator verify created manual path data in path detail with following data:")
    public void operatorVerifyCreatedManualPathDataInPathDetail(Map<String, String> mapOfData) {
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        String originHubName = resolvedMapOfData.get("originHubName");
        String destinationHubName = resolvedMapOfData.get("destinationHubName");
        String transitHubName = resolvedMapOfData.get("transitHubName");
        Long movementScheduleId = Long.valueOf(resolvedMapOfData.get("movementScheduleId"));
        MovementTripSchedule movementSchedule = getCreatedMovementScheduleWithTripById(movementScheduleId);

        String departureTime = movementSchedule.getSchedules().get(0).getStartTime();
        int hour = Integer.parseInt(departureTime.split(":")[0]);
        int minute = Integer.parseInt(departureTime.split(":")[1]);
        String path = originHubName + " → " + transitHubName + " → " + destinationHubName;
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, hour);
        cal.set(Calendar.MINUTE, minute);
        cal.add(Calendar.HOUR_OF_DAY, 8);
        int hours = cal.get(Calendar.HOUR_OF_DAY);
        int minutes = cal.get(Calendar.MINUTE);
        departureTime = String.format("%02d:%02d", hours, minutes);

        pathManagementPage.verifyCreatedPathDetail(path, departureTime);
    }

    @Then("Operator verifies path data appear in path table with following hubs:")
    public void operatorVerifiesPathDataAppearInPathTableWithFollowingHubs(Map<String, String> mapOfData) {
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        String originHubName = resolvedMapOfData.get("originHubName");
        String destinationHubName = resolvedMapOfData.get("destinationHubName");
        String transitHubName = resolvedMapOfData.get("transitHubName");

        List<String> passedHub = Arrays.asList(originHubName, transitHubName, destinationHubName);
        pathManagementPage.verifyPathDataAppearInPathTable(originHubName, destinationHubName, passedHub);
    }

}
