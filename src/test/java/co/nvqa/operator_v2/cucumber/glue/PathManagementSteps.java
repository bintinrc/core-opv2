package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.sort.hub.movement_trips.MovementTripSchedule;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.PathManagementPage;
import co.nvqa.operator_v2.util.TestConstants;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.JavascriptExecutor;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;


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
        pathManagementPage.addDefaultPathButton.waitUntilClickable(30);
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

    @When("Operator clicks add default path button")
    public void operatorClicksAddDefaultPathButton() {
        pathManagementPage.addDefaultPathButton.click();
        pathManagementPage.createDefaultPathModal.waitUntilVisible();
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
            pathManagementPage.pathRowNvTable.getRow(0).viewAction.click();
        }
        if ("remove".equals(hyperlinkAction)) {
            pathManagementPage.pathRowNvTable.getRow(0).removeAction.click();
        }
        if ("edit".equals(hyperlinkAction)) {
            pathManagementPage.pathRowNvTable.getRow(0).editAction.click();
        }
    }

    @Then("Operator verify shown {string} path details modal data")
    public void operatorVerifyShownPathDetailsModalData(String pathType) {
        pathManagementPage.verifyShownPathDetail(pathType);
    }

    @Then("Operator verify shown {string} remove path modal data")
    public void operatorVerifyShownRemovePathModalData(String pathType) {
        pathManagementPage.verifyShownRemovePathDetail(pathType);
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
        String transitHubNameSecond = resolvedMapOfData.get("transitHubNameSecond");
        String transitHubNameThird = resolvedMapOfData.get("transitHubNameThird");
        String selectSchedule = resolvedMapOfData.get("selectSchedule");

        pathManagementPage.createManualPathModal.waitUntilVisible();
        pathManagementPage.createManualPathFirstStage(originHubName, destinationHubName);
        pathManagementPage.createManualPathModal.nextButton.click();
        pause2s();

        pathManagementPage.createManualPathSecondStage(transitHubName, "first");
        if (transitHubNameSecond != null) {
            pathManagementPage.createManualPathSecondStage(transitHubNameSecond, "second");
        }
        if (transitHubNameThird != null) {
            pathManagementPage.createManualPathSecondStage(transitHubNameThird, "third");
        }
        if (!"false".equals(selectSchedule)) {
            pathManagementPage.createManualPathModal.nextButton.click();
        }
        pause2s();

        if ("single".equals(selectSchedule)) {
            pathManagementPage.createManualPathThirdStage(false);
            String departureTime = pathManagementPage.createManualPathModal.departureScheduleFirstInfo.getText().split(" ")[2];
            putInList(KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES, departureTime);
            pathManagementPage.createManualPathModal.createButton.click();
        }
        if ("multiple".equals(selectSchedule)) {
            pathManagementPage.createManualPathThirdStage(true);
            String departureTime = pathManagementPage.createManualPathModal.departureScheduleFirstInfo.getText().split(" ")[2];
            String secondDepartureTime = pathManagementPage.createManualPathModal.departureScheduleSecondInfo.getText().split(" ")[2];
            putInList(KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES, departureTime);
            putInList(KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES, secondDepartureTime);
            pathManagementPage.createManualPathModal.createButton.click();
        }
        pause2s();
    }

    @And("Operator create default path with following data:")
    public void operatorCreateDefaultPathWithFollowingData(Map<String, String> mapOfData) {
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        String originHubName = resolvedMapOfData.get("originHubName");
        String destinationHubName = resolvedMapOfData.get("destinationHubName");

        pathManagementPage.createDefaultPath(originHubName, destinationHubName);
        if (!"empty".equals(originHubName) && !"empty".equals(destinationHubName)) {
            pathManagementPage.verifyCreatingDefaultPath(originHubName, destinationHubName);
        }
        pause2s();
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
        operatorVerifyCreatedManualPathWithScheduleDataInPathDetail("single", mapOfData);
    }

    @And("Operator verify created default path data in path detail with following data:")
    public void operatorVerifyCreatedDefaultPathDataInPathDetail(Map<String, String> mapOfData) {
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        String originHubName = resolvedMapOfData.get("originHubName");
        String destinationHubName = resolvedMapOfData.get("destinationHubName");
        String path = originHubName + " → " + destinationHubName;
        pathManagementPage.verifyCreatedPathDetail(path, null);
    }

    @And("Operator verify created manual path data in path detail empty schedule with following data:")
    public void operatorVerifyCreatedPathDataInPathDetailWithFollowingData(Map<String, String> mapOfData) {
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        String originHubName = resolvedMapOfData.get("originHubName");
        String destinationHubName = resolvedMapOfData.get("destinationHubName");
        String transitHubName = resolvedMapOfData.get("transitHubName");

        String path = originHubName + " → ";
        if (transitHubName != null) {
            path += transitHubName + " → ";
        }
        path += destinationHubName;

        List<String> departureTimes = new ArrayList<>();

        pathManagementPage.verifyCreatedPathDetail(path, departureTimes);
    }

    @And("Operator verify created manual path data with {string} schedule in path detail with following data:")
    public void operatorVerifyCreatedManualPathWithScheduleDataInPathDetail(String scheduleNumber, Map<String, String> mapOfData) {
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        String originHubName = resolvedMapOfData.get("originHubName");
        String destinationHubName = resolvedMapOfData.get("destinationHubName");
        String transitHubName = resolvedMapOfData.get("transitHubName");
        String departureTime = resolvedMapOfData.get("departureTime");
        String departureTimeSecond = resolvedMapOfData.get("departureTimeSecond");

        String path = originHubName + " → ";
        if (transitHubName != null) {
            path += transitHubName + " → ";
        }
        path += destinationHubName;

        List<String> departureTimes = new ArrayList<>();
        departureTimes.add(departureTime);
        if ("multiple".equals(scheduleNumber)) {
            departureTimes.add(departureTimeSecond);
        }

        pathManagementPage.verifyCreatedPathDetail(path, departureTimes);
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

    @Then("Operator verify it cannot create manual path {string} with data:")
    public void operatorVerifyItCannotCreateManualPathWithoutSelectingSchedule(String reason, Map<String, String> mapOfData) {
        Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
        String resolvedSourceHub = resolvedMapOfData.get("sourceHub");
        String resolvedTargetHub = resolvedMapOfData.get("targetHub");
        String transitHubName = resolvedMapOfData.get("transitHubName");

        if ("multiple same transit hubs".equals(reason)) {
            resolvedSourceHub = transitHubName;
        }
        pathManagementPage.verifyCannotCreateSchedule(reason, resolvedSourceHub, resolvedTargetHub);
    }

    @When("Operator cancel add manual path button after fill {string} and {string} as origin and destination hub")
    public void operatorCancelAddManualPathButtonAfterFillOriginAndDestinationHub(String originHubName, String destinationHubName) {
        String resolvedOriginHubName = resolveValue(originHubName);
        String resolvedDestinationHubName = resolveValue(destinationHubName);

        pathManagementPage.createManualPathModal.waitUntilVisible();
        pathManagementPage.createManualPathFirstStage(resolvedOriginHubName, resolvedDestinationHubName);
        pathManagementPage.createManualPathModal.cancelButton.click();
        pause2s();
    }

    @Then("Operator verify it will direct to path management page")
    public void operatorVerifyItWillDirectToPathManagementPage() {
        pathManagementPage.switchToParentFrame();
        pathManagementPage.verifyCurrentPageIsPathManagementPage();
    }

    @Then("Operator verify transit hub input empty after retract one step with {string} and {string} as origin and destination hub")
    public void operatorVerifyTransitHubInputEmptyAfterRetractOneStep(String originHubName, String destinationHubName) {
        String resolvedOriginHubName = resolveValue(originHubName);
        String resolvedDestinationHubName = resolveValue(destinationHubName);
        pathManagementPage.createManualPathModal.backButton.click();
        pathManagementPage.createManualPathFirstStage(resolvedOriginHubName, resolvedDestinationHubName);
        pathManagementPage.createManualPathModal.nextButton.click();
        pause2s();
        pathManagementPage.verifyTransitHubInputIsEmpty();
    }

    @And("Operator remove {string} transit hub")
    public void operatorRemoveTransitHub(String transitHubInfo) {
        pathManagementPage.removeTransitHubInManualPathCreation(transitHubInfo);
        pause2s();
    }

    @And("Operator clicks next button in create manual path modal")
    public void operatorClicksNextButtonInCreateManualPathModal() {
        pathManagementPage.createManualPathModal.nextButton.click();
    }

    @And("Operator clicks create button in create manual path modal")
    public void operatorClicksCreateButtonInCreateManualPathModel() {
        pathManagementPage.createManualPathModal.createButton.click();
    }

    @And("Operator choose single schedule and clicks create button in create manual path modal")
    public void operatorChooseScheduleClicksCreateButtonInCreateManualPathModel() {
        pathManagementPage.createManualPathThirdStage(false);
        String departureTime = pathManagementPage.createManualPathModal.departureScheduleFirstInfo.getText().split(" ")[2];
        putInList(KEY_LIST_MANUAL_PATH_DEPARTURE_TIMES, departureTime);
        pathManagementPage.createManualPathModal.createButton.click();
        pause2s();
    }

    @And("Operator update {string} transit hub with {string}")
    public void operatorUpdateTransitHub(String transitHubInfo, String newTransitHub) {
        String resolvedNewTransitHub = resolveValue(newTransitHub);
        pathManagementPage.updateTransitHubInManualPathCreation(transitHubInfo, resolvedNewTransitHub);
        pause2s();
    }

    @When("Operator opens new tab and switch to new tab in path management page")
    public void operatorOpensNewTabInPathManagementPage() {
        String mainWindowHandle = pathManagementPage.getWebDriver().getWindowHandle();
        put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
        ((JavascriptExecutor) pathManagementPage.getWebDriver()).executeScript("window.open()");
        operatorSwitchToNewTabInPathManagementPage();
        pathManagementPage.getWebDriver().get(TestConstants.OPERATOR_PORTAL_LOGIN_URL);
        pathManagementPage.waitUntilPageLoaded();
    }

    @And("Operator switch to main tab in path management page")
    public void operatorOpensMainTabInPathManagementPage() {
        String mainWindowHandle = get(KEY_MAIN_WINDOW_HANDLE);
        pathManagementPage.getWebDriver().switchTo().window(mainWindowHandle);
    }

    @And("Operator switch to new tab in path management page")
    public void operatorSwitchToNewTabInPathManagementPage() {
        String mainWindowHandle = get(KEY_MAIN_WINDOW_HANDLE);
        Set<String> windowHandles = pathManagementPage.getWebDriver().getWindowHandles();

        for (String windowHandle : windowHandles) {
            if (!windowHandle.equalsIgnoreCase(mainWindowHandle)) {
                pathManagementPage.getWebDriver().switchTo().window(windowHandle);
            }
        }
    }

    @And("Operator click {string} button in path details")
    public void operatorClickButtonInPathDetails(String buttonName) {
        if ("remove".equals(buttonName)) {
            pathManagementPage.pathDetailsModal.removePathButton.click();
        }
    }

    @And("Operator verify no new path created")
    public void operatorVerifyNoNewPathCreated() {
        Integer actualPathRowsSize = pathManagementPage.pathRowNvTable.rows.size();
        assertThat("Path rows size is one", actualPathRowsSize, equalTo(1));
    }

    @And("Operator verify no path found from {string} to {string} message is shown in create default path modal")
    public void operatorVerifyNoPathFoundMessageIsShownInCreateDefaultPathModal(String originHub, String destinationHub) {
        String resolvedOriginHub = resolveValue(originHub);
        String resolvedDestinationHub = resolveValue(destinationHub);

        String actualCreateDefaultPathInfoText = pathManagementPage.createDefaultPathModal.createDefaultPathInfo.getText();
        String expectedCreateDefaultPathInfoText = f("No path found from %s to %s!\nPlease add movement schedule(s) in Movement Schedule page in order to create a path between facilities.",
                resolvedOriginHub, resolvedDestinationHub);
        assertThat("Create default path message is equal", actualCreateDefaultPathInfoText,
                equalTo(expectedCreateDefaultPathInfoText));
    }

    @Then("Operator verify {string} error info shown on create default path modal")
    public void operatorVerifyErrorInfoShownOnCreateDefaultPathModal(String errorField) {
        String expectedErrorInfo = "This field is required.";
        if ("both".equals(errorField)) {
            String actualOriginHubErrorInfo = pathManagementPage.createDefaultPathModal.originHubErrorInfo.getText();
            String actualDestinationHubErrorInfo = pathManagementPage.createDefaultPathModal.destinationHubErrorInfo.getText();
            assertThat("Error origin hub info is equal", actualOriginHubErrorInfo, equalTo(expectedErrorInfo));
            assertThat("Error destination info is equal", actualDestinationHubErrorInfo, equalTo(expectedErrorInfo));
        }
        if ("origin hub".equals(errorField)) {
            String actualOriginHubErrorInfo = pathManagementPage.createDefaultPathModal.originHubErrorInfo.getText();
            assertThat("Error origin hub info is equal", actualOriginHubErrorInfo, equalTo(expectedErrorInfo));
        }
        if ("destination hub".equals(errorField)) {
            String actualDestinationHubErrorInfo = pathManagementPage.createDefaultPathModal.destinationHubErrorInfo.getText();
            assertThat("Error destination info is equal", actualDestinationHubErrorInfo, equalTo(expectedErrorInfo));
        }
    }

    @When("Operator selects {string} as transit hub in edit path modal")
    public void operatorSelectsHubAsTransitHubInEditPathModal(String transitHub) {
        String resolvedTransitHub = resolveValue(transitHub);

        pathManagementPage.editManualPathModal.waitUntilVisible();

        pathManagementPage.editManualPathFirstStage(resolvedTransitHub);
        pathManagementPage.editManualPathSecondStage();
    }
}
