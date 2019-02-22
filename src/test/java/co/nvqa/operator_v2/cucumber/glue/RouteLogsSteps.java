package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.model.CreateRouteParams;
import co.nvqa.operator_v2.model.DriverTypeParams;
import co.nvqa.operator_v2.selenium.page.RouteLogsPage;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.hamcrest.Matchers;
import org.openqa.selenium.Alert;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Stream;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteLogsSteps extends AbstractSteps
{
    private static final int ALERT_WAIT_TIMEOUT_IN_SECONDS = 15;
    private static final int MAX_RETRY = 10;

    private RouteLogsPage routeLogsPage;

    public RouteLogsSteps()
    {
    }

    @Override
    public void init()
    {
        routeLogsPage = new RouteLogsPage(getWebDriver());
    }

    @When("^Operator create new route using data below:$")
    public void operatorCreateNewRouteUsingDataBelow(Map<String,String> mapOfData)
    {
        try
        {
            String scenarioName = getScenarioManager().getCurrentScenario().getName();
            String createdDate = CREATED_DATE_SDF.format(new Date());

            Date routeDate = YYYY_MM_DD_SDF.parse(mapOfData.get("routeDate"));

            String routeTags = mapOfData.get("routeTags").replaceAll("\\[", "").replaceAll("]", "");
            String[] tags = Stream.of(routeTags.split(",")).map(String::trim).toArray(String[]::new);

            String zoneName = mapOfData.get("zoneName");
            String hubName = mapOfData.get("hubName");
            String ninjaDriverName = mapOfData.get("ninjaDriverName");
            String vehicleName = mapOfData.get("vehicleName");
            String comments = f("This route is created from OpV2 for testing purpose only. Ignore this route. Created at %s by scenario \"%s\".", createdDate, scenarioName);

            CreateRouteParams createRouteParams = new CreateRouteParams();
            createRouteParams.setRouteDate(routeDate);
            createRouteParams.setRouteTags(tags);
            createRouteParams.setZoneName(zoneName);
            createRouteParams.setHubName(hubName);
            createRouteParams.setNinjaDriverName(ninjaDriverName);
            createRouteParams.setVehicleName(vehicleName);
            createRouteParams.setComments(comments);
            routeLogsPage.createNewRoute(createRouteParams);

            Route createdRoute = createRouteParams.getCreatedRoute();
            Long createdRouteId = createdRoute.getId();
            writeToCurrentScenarioLogf("Created Route: %d", createdRouteId);

            put(KEY_CREATE_ROUTE_PARAMS, createRouteParams);
            put(KEY_CREATED_ROUTE, createdRoute);
            putInList(KEY_LIST_OF_CREATED_ROUTES, createdRoute);
            put(KEY_CREATED_ROUTE_ID, createdRouteId);
            putInList(KEY_LIST_OF_ARCHIVED_ROUTE_IDS, createdRouteId);
        }
        catch(ParseException ex)
        {
            throw new NvTestRuntimeException("Failed to parse date.", ex);
        }
    }

    @When("^Operator create multiple routes using data below:$")
    public void operatorCreateMultipleRoutesUsingDataBelow(Map<String,String> mapOfData)
    {
        try
        {
            String scenarioName = getScenarioManager().getCurrentScenario().getName();
            String createdDate = CREATED_DATE_SDF.format(new Date());

            int numberOfRoute = Integer.parseInt(mapOfData.get("numberOfRoute"));
            Date routeDate = YYYY_MM_DD_SDF.parse(mapOfData.get("routeDate"));

            String routeTags = mapOfData.get("routeTags").replaceAll("\\[", "").replaceAll("]", "");
            String[] tags = Stream.of(routeTags.split(",")).map(String::trim).toArray(String[]::new);

            String zoneName = mapOfData.get("zoneName");
            String hubName = mapOfData.get("hubName");
            String ninjaDriverName = mapOfData.get("ninjaDriverName");
            String vehicleName = mapOfData.get("vehicleName");
            List<CreateRouteParams> listOfCreateRouteParams = new ArrayList<>();

            for(int i=0; i<numberOfRoute; i++)
            {
                String comments = f("This route (#%d) is created from OpV2 for testing purpose only. Ignore this route. Created at %s by scenario \"%s\".", (i+1), createdDate, scenarioName);

                CreateRouteParams createRouteParams = new CreateRouteParams();
                createRouteParams.setRouteDate(routeDate);
                createRouteParams.setRouteTags(tags);
                createRouteParams.setZoneName(zoneName);
                createRouteParams.setHubName(hubName);
                createRouteParams.setNinjaDriverName(ninjaDriverName);
                createRouteParams.setVehicleName(vehicleName);
                createRouteParams.setComments(comments);
                listOfCreateRouteParams.add(createRouteParams);
            }

            routeLogsPage.createMultipleRoute(listOfCreateRouteParams);
            int counter = 1;

            for(CreateRouteParams createRouteParams : listOfCreateRouteParams)
            {
                Route createdRoute = createRouteParams.getCreatedRoute();
                Long createdRouteId = createdRoute.getId();

                put(KEY_CREATE_ROUTE_PARAMS, createRouteParams);
                put(KEY_CREATED_ROUTE, createdRoute);
                put(KEY_CREATED_ROUTE_ID, createdRouteId);
                putInList(KEY_LIST_OF_CREATED_ROUTES, createdRoute);
                putInList(KEY_LIST_OF_CREATED_ROUTE_ID, createdRouteId);
                putInList(KEY_LIST_OF_ARCHIVED_ROUTE_IDS, createdRouteId);
                writeToCurrentScenarioLogf("Created Route #%d: %d", counter++, createdRouteId);
            }

            put(KEY_LIST_OF_CREATE_ROUTE_PARAMS, listOfCreateRouteParams);
        }
        catch(ParseException ex)
        {
            throw new NvTestRuntimeException("Failed to parse date.", ex);
        }
    }

    @Then("^Operator verify the new route is created successfully$")
    public void operatorVerifyTheNewRouteIsCreatedSuccessfully()
    {
        CreateRouteParams createRouteParams = get(KEY_CREATE_ROUTE_PARAMS);
        routeLogsPage.verifyNewRouteIsCreatedSuccessfully(createRouteParams);
    }

    @Then("^Operator verify multiple routes is created successfully$")
    public void operatorVerifyMultipleRoutesIsCreatedSuccessfully()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);

        for(CreateRouteParams createRouteParams : listOfCreateRouteParams)
        {
            routeLogsPage.verifyNewRouteIsCreatedSuccessfully(createRouteParams);
        }
    }

    @When("^Operator bulk edit details multiple routes using data below:$")
    public void operatorBulkEditDetailsMultipleRoutesUsingDataBelow(Map<String,String> mapOfData)
    {
        try
        {
            List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);

            Date routeDate = YYYY_MM_DD_SDF.parse(mapOfData.get("routeDate"));

            String routeTags = mapOfData.get("routeTags").replaceAll("\\[", "").replaceAll("]", "");
            String[] tags = Stream.of(routeTags.split(",")).map(String::trim).toArray(String[]::new);

            String zoneName = mapOfData.get("zoneName");
            String hubName = mapOfData.get("hubName");
            String ninjaDriverName = mapOfData.get("ninjaDriverName");
            String vehicleName = mapOfData.get("vehicleName");

            for(CreateRouteParams createRouteParams : listOfCreateRouteParams)
            {
                createRouteParams.setRouteDate(routeDate);
                createRouteParams.setRouteTags(tags);
                createRouteParams.setZoneName(zoneName);
                createRouteParams.setHubName(hubName);
                createRouteParams.setNinjaDriverName(ninjaDriverName);
                createRouteParams.setVehicleName(vehicleName);
            }

            routeLogsPage.bulkEditDetails(listOfCreateRouteParams);
        }
        catch(ParseException ex)
        {
            throw new NvTestRuntimeException("Failed to parse date.", ex);
        }
    }

    @Then("^Operator verify multiple routes is bulk edited successfully$")
    public void operatorVerifyMultipleRoutesIsBulkEditedSuccessfully$()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);

        for(CreateRouteParams createRouteParams : listOfCreateRouteParams)
        {
            routeLogsPage.verifyRouteIsFoundAndInfoIsCorrect(createRouteParams);
        }
    }

    @When("^Operator edit driver type of multiple routes using data below:$")
    public void operatorEditDriverTypeOfMultipleRoutesUsingDataBelow(Map<String,String> mapOfData)
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);

        long driverTypeId = Long.parseLong(mapOfData.get("driverTypeId"));
        String driverTypeName = mapOfData.get("driverTypeName");

        DriverTypeParams driverTypeParams = new DriverTypeParams();
        driverTypeParams.setDriverTypeId(driverTypeId);
        driverTypeParams.setDriverTypeName(driverTypeName);

        routeLogsPage.editDriverTypesOfSelectedRoute(listOfCreateRouteParams, driverTypeParams);
        put(KEY_DRIVER_TYPE_PARAMS, driverTypeParams);
    }

    @When("^Operator merge transactions of multiple routes$")
    public void operatorMergeTransactionsOfMultipleRoutes()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.mergeTransactionsOfMultipleRoutes(listOfCreateRouteParams);
    }

    @Then("^Operator verify transactions of multiple routes is merged successfully$")
    public void operatorVerifyTransactionsOfMultipleRoutesIsMergedSuccessfully()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.verifyTransactionsOfMultipleRoutesIsMergedSuccessfully(listOfCreateRouteParams);
    }

    @When("^Operator optimise multiple routes$")
    public void operatorOptimiseMultipleRoutes()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.optimiseMultipleRoutes(listOfCreateRouteParams);
    }

    @Then("^Operator verify multiple routes is optimised successfully$")
    public void operatorVerifyMultipleRoutesIsOptimisedSuccessfully()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.verifyMultipleRoutesIsOptimisedSuccessfully(listOfCreateRouteParams);
    }

    @When("^Operator print passwords of multiple routes$")
    public void operatorPrintPasswordsOfMultipleRoutes()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.printPasswordsOfSelectedRoutes(listOfCreateRouteParams);
    }

    @Then("^Operator verify printed passwords of selected routes info is correct$")
    public void operatorVerifyPrintedPasswordsOfSelectedRoutesInfoIsCorrect()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.verifyPrintedPasswordsOfSelectedRoutesInfoIsCorrect(listOfCreateRouteParams);
    }

    @When("^Operator print multiple routes$")
    public void operatorPrintMultipleRoutes()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.printMultipleRoutes(listOfCreateRouteParams);
    }

    @When("^Operator verify multiple routes is printed successfully$")
    public void operatorVerifyMultipleRoutesIsPrintedSuccessfully()
    {
        routeLogsPage.verifyMultipleRoutesIsPrintedSuccessfully();
    }

    @When("^Operator archive multiple routes$")
    public void operatorArchiveMultipleRoutes()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.archiveMultipleRoutes(listOfCreateRouteParams);
    }

    @Then("^Operator verify multiple routes is archived successfully$")
    public void operatorVerifyMultipleRoutesIsArchivedSuccessfully()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.verifyMultipleRoutesIsArchivedSuccessfully(listOfCreateRouteParams);
    }

    @When("^Operator unarchive multiple routes$")
    public void operatorUnarchiveMultipleRoutes()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.unarchiveMultipleRoutes(listOfCreateRouteParams);
    }

    @Then("^Operator verify multiple routes is unarchived successfully$")
    public void operatorVerifyMultipleRoutesIsUnarchivedSuccessfully()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.verifyMultipleRoutesIsUnarchivedSuccessfully(listOfCreateRouteParams);
    }

    @When("^Operator delete multiple routes$")
    public void operatorDeleteMultipleRoutes()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.deleteMultipleRoutes(listOfCreateRouteParams);
    }

    @Then("^Operator verify multiple routes is deleted successfully$")
    public void operatorVerifyMultipleRoutesIsDeletedSuccessfully()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        routeLogsPage.verifyMultipleRoutesIsDeletedSuccessfully(listOfCreateRouteParams);
    }

    @When("^Operator set filter using data below and click 'Load Selection'$")
    public void loadSelection(Map<String,String> mapOfData)
    {
        Date routeDateFrom = getDateByMode(mapOfData.get("routeDateFrom"));
        Date routeDateTo = getDateByMode(mapOfData.get("routeDateTo"));
        String hubName = mapOfData.get("hubName");
        routeLogsPage.setFilterAndLoadSelection(routeDateFrom, routeDateTo, hubName);
    }

    @When("^Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route\\(s\\) Only'$")
    public void loadWaypointsOfSelectedRoute()
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.searchAndVerifyRouteExist(routeId);
        routeLogsPage.clickActionButtonOnTable(1, RouteLogsPage.ACTION_BUTTON_EDIT_ROUTE);
        pause100ms();
        routeLogsPage.clickLoadWaypointsOfSelectedRoutesOnly();
        pause1s();
    }

    @Then("^Operator redirect to this page '([^\"]*)'$")
    public void verifyLoadWaypointsOfSelectedRoute(String redirectUrl)
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);

        String primaryWindowHandle = getWebDriver().getWindowHandle();
        Set<String> windowHandles = getWebDriver().getWindowHandles();

        String actualCurrentUrl = null;

        for(String windowName : windowHandles)
        {
            if(!primaryWindowHandle.equals(windowName))
            {
                getWebDriver().switchTo().window(windowName);
                pause3s();

                try
                {
                    WebDriverWait webDriverWait = new WebDriverWait(getWebDriver(), ALERT_WAIT_TIMEOUT_IN_SECONDS);
                    Alert alert = webDriverWait.until(ExpectedConditions.alertIsPresent());
                    pause200ms();
                    alert.accept();
                }
                catch(Exception ex)
                {
                    getScenarioManager().writeToCurrentScenarioLog(f("Alert is not present after %ds.", ALERT_WAIT_TIMEOUT_IN_SECONDS));
                    getScenarioManager().writeToCurrentScenarioLog(TestUtils.convertExceptionStackTraceToString(ex));
                }

                pause100ms();
                actualCurrentUrl = getCurrentUrl();
                getWebDriver().close();
                pause100ms();
                getWebDriver().switchTo().window(primaryWindowHandle);
                pause500ms();
                break;
            }
        }

        Map<String,String> mapOfTokens = new HashMap<>();
        mapOfTokens.put("route_id", String.valueOf(routeId));
        String expectedRedirectUrl = replaceTokens(redirectUrl, mapOfTokens);
        assertEquals(f("Operator does not redirect to page %s.", redirectUrl), expectedRedirectUrl, actualCurrentUrl);
    }

    @Then("^Operator close Edit Routes dialog$")
    public void opCloseEditRoutesDialog()
    {
        routeLogsPage.clickCancelOnEditRoutesDialog();
    }

    @When("^Operator click 'Edit Details'$")
    public void opClickEditDetails()
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.searchAndVerifyRouteExist(routeId);
        routeLogsPage.clickActionButtonOnTable(1, RouteLogsPage.ACTION_BUTTON_EDIT_DETAILS);
        pause100ms();
    }

    @When("^Operator edit 'Assigned Driver' to driver '([^\"]*)' and edit 'Comments'$")
    public void opEditAssignedDriverAndComments(String newDriverName)
    {
        routeLogsPage.editAssignedDriver(newDriverName);
        routeLogsPage.clickSaveButtonOnEditDetailsDialog();
    }

    @Then("^Operator verify route's driver must be changed to '([^\"]*)' in table list$")
    public void verifyRouteDriverIsChanged(String newDriverName)
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);

        boolean loadSelectionButtonIsVisible;
        int counter = 1;

        /*
          Sometimes button "Edit Filter" is not clicked correctly
          and it makes "Load Selection" button does not appear.
          So we need to click that "Edit Filter" button over and over until
          "Load Selection" button is appear.
         */
        do
        {
            String level = "[INFO]";

            if(counter>1)
            {
                level = "[WARNING]";
            }

            takesScreenshot();
            writeToCurrentScenarioLog(f("%s Trying to click 'Edit Filter' button x%d.", level, counter++));

            routeLogsPage.clickEditFilter();
            loadSelectionButtonIsVisible = routeLogsPage.isLoadSelectionVisible();
        }
        while(!loadSelectionButtonIsVisible && counter<=MAX_RETRY);

        routeLogsPage.clickLoadSelection();
        routeLogsPage.searchAndVerifyRouteExist(routeId);
        String actualDriverName = routeLogsPage.getTextOnTable(1, RouteLogsPage.COLUMN_CLASS_DATA_DRIVER_NAME);
        assertEquals("Driver is not change.", newDriverName, actualDriverName);
    }

    @When("^Operator add tag '([^\"]*)'$")
    public void opAddNewTagToRoute(String newTag)
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.selectTag(routeId, newTag);
    }

    @Then("^Operator verify route's tag must contain '([^\"]*)'$")
    public void verifyNewTagAddedToRoute(String newTag)
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        String tags = routeLogsPage.getRouteTag(routeId);
        assertThat(f("Route does not contains tag '%s'.", newTag), tags, Matchers.containsString(newTag));
    }

    @When("^Operator delete route on Operator V2$")
    public void opDeleteDeleteRoute()
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.deleteRoute(routeId);
    }

    @Then("^Operator verify route must be deleted successfully$")
    public void verifyRouteDeletedSuccessfully()
    {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        routeLogsPage.searchTableByRouteId(routeId);
        boolean isTableEmpty = routeLogsPage.isTableEmpty();
        put(KEY_ROUTE_IS_ALREADY_DELETED, true);
        assertTrue("Route still exist in table. Fail to delete route.", isTableEmpty);
    }
}
