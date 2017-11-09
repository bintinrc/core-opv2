package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.integration.model.core.Waypoint;
import co.nvqa.operator_v2.integration.model.driver.Order;
import co.nvqa.operator_v2.integration.model.driver.Route;
import co.nvqa.operator_v2.integration.model.driver.builder.JobBuilder;
import co.nvqa.operator_v2.integration.model.driver.scan.DeliveryRequest;
import co.nvqa.operator_v2.support.ScenarioStorage;
import com.google.inject.Inject;
import co.nvqa.operator_v2.integration.client.DriverClient;
import co.nvqa.operator_v2.integration.model.auth.DriverLoginResponse;
import co.nvqa.operator_v2.integration.model.driver.Job;
import co.nvqa.operator_v2.support.TestConstants;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class CommonDriverSteps extends AbstractSteps
{
    public static final String KEY_DELIVERY_JOB_ID = "key-driver-delivery-job-id";
    public static final String KEY_DELIVERY_WAYPOINT_ID = "key-driver-delivery-waypoint-id";
    public static final String KEY_DRIVER_ROUTES_LIST = "key-driver-routes-list";
    public static final String KEY_DRIVER_JOB_ORDER = "key-driver-job-order";

    @Inject
    ScenarioStorage scenarioStorage;
    private DriverClient driverClient;


    @Inject
    public CommonDriverSteps(ScenarioManager scenarioManager, ScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        try
        {
            DriverLoginResponse driverLoginResponse = getDriverAuthToken();
            driverClient = new DriverClient(TestConstants.API_BASE_URL, driverLoginResponse.getAccessToken());
        }
        catch(Exception ex)
        {
            throw new RuntimeException(ex);
        }
    }

    @When("^Driver collect all his routes$")
    public void driverGetAllRoutes()
    {
        List<Route> routes = driverClient.getRoutesV2().getRoutes();
        scenarioStorage.put(KEY_DRIVER_ROUTES_LIST, routes);
    }

    @When("^Driver try to find his pickup/delivery waypoint$")
    public void driverTryToFindHisPickupWaypointForC2cOrReturnOrder()
    {
        List<Route> routes = scenarioStorage.get(KEY_DRIVER_ROUTES_LIST);
        String expectedTrackingId = scenarioStorage.get("trackingId");
        int deliveryWaypointId = -1;
        int deliveryJobId = -1;
        Order jobOrder = null;
        int i = 0;
        boolean found = false;

        for(Route route : routes)
        {
            System.out.println(String.format("[INFO] Iterate route with ID '%d' from %d routes. %dx...", route.getId(), routes.size(), i));
            List<Waypoint> waypoints = route.getWaypoints();

            for(Waypoint wp : waypoints)
            {
                List<Job> jobs = wp.getJobs();

                if(jobs!=null)
                {
                    for(Job job : jobs)
                    {
                        List<Order> listOfDriverOrders = job.getOrders();

                        if(listOfDriverOrders!=null)
                        {
                            for(Order jo : job.getOrders())
                            {
                                if(jo.getTrackingId().equals(expectedTrackingId))
                                {
                                    found = true;
                                    deliveryWaypointId = wp.getId();
                                    deliveryJobId = job.getId();
                                    jobOrder = jo;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            i++;
        }

        Assert.assertTrue(String.format("Pickup Waypoint not found on Driver Pick Up. [Tracking ID = %s]", expectedTrackingId), found);
        Assert.assertNotEquals(String.format("Delivery waypoint is not found. [Tracking ID = %s]", expectedTrackingId), -1, deliveryWaypointId);
        Assert.assertNotEquals(String.format("Delivery job is not found. [Tracking ID = %s]", expectedTrackingId), -1, deliveryJobId);
        Assert.assertNotNull(String.format("Job Order is null. [Tracking ID = %s]", expectedTrackingId), jobOrder);

        scenarioStorage.put(KEY_DELIVERY_WAYPOINT_ID, deliveryWaypointId);
        scenarioStorage.put(KEY_DELIVERY_JOB_ID, deliveryJobId);
        scenarioStorage.put(KEY_DRIVER_JOB_ORDER, jobOrder);
    }

    @When("^Driver failed the C2C/Return order pickup$")
    public void driverFailedTheC2cOrReturnOrderPickup()
    {
        int deliveryJobId = scenarioStorage.get(KEY_DELIVERY_JOB_ID);
        int deliveryWaypointId = scenarioStorage.get(KEY_DELIVERY_WAYPOINT_ID);
        int routeId = scenarioStorage.get("routeId");

        Assert.assertNotEquals(String.format("Pickup job not found. [Route ID = %d]", routeId), -1L, deliveryJobId);

        Integer failureReasonId = (TestConstants.API_BASE_URL.toLowerCase().contains("/id"))
                ? Order.DEFAULT_FAIL_ID_SG
                : Order.DEFAULT_FAIL_ID_SG;

        String failureReasonString = (TestConstants.API_BASE_URL.toLowerCase().contains("/id"))
                ? Order.DEFAULT_FAIL_ID_SG_STRING
                : Order.DEFAULT_FAIL_ID_SG_STRING;

        Order jobOrder = scenarioStorage.get(KEY_DRIVER_JOB_ORDER);
        jobOrder.setAction(Order.ACTION_FAIL);
        jobOrder.setFailureReasonId(failureReasonId);
        jobOrder.setFailureReason(failureReasonString);

        Job job = new JobBuilder().setAction(Job.ACTION_FAIL)
                .setId(deliveryJobId)
                .setMode(Job.MODE_PICKUP)
                .setStatus(Job.STATUS_PENDING)
                .setType(Job.TYPE_TRANSACTION)
                .setOrders(new ArrayList<Order>(){{add(jobOrder);}}).createJob();

        List<Job> jobs = new ArrayList<>();
        jobs.add(job);

        DeliveryRequest request = new DeliveryRequest(deliveryWaypointId, jobs).setAsFailV2();
        driverClient.failedDefaultV2(routeId, deliveryWaypointId, request);
    }

    @Then("^Driver failed the delivery for created parcel$")
    public void driverFailedTheDeliveryForCreatedParcel()
    {
        int deliveryJobId = scenarioStorage.get(KEY_DELIVERY_JOB_ID);
        int deliveryWaypointId = scenarioStorage.get(KEY_DELIVERY_WAYPOINT_ID);
        int routeId = scenarioStorage.get("routeId");

        Assert.assertNotEquals(String.format("Delivery Job not found. [Route ID = %d]", routeId), -1L, deliveryJobId);

        Integer failureReasonId = (TestConstants.API_BASE_URL.toLowerCase().contains("/id"))
                ? Order.DEFAULT_DELIVERY_FAIL_ID_SG
                : Order.DEFAULT_DELIVERY_FAIL_ID_SG;

        String failureReasonString = (TestConstants.API_BASE_URL.toLowerCase().contains("/id"))
                ? Order.DEFAULT_DELIVERY_FAIL_ID_SG_STRING
                : Order.DEFAULT_DELIVERY_FAIL_ID_SG_STRING;

        Order jobOrder = scenarioStorage.get(KEY_DRIVER_JOB_ORDER);
        jobOrder.setAction(Order.ACTION_FAIL);
        jobOrder.setFailureReasonId(failureReasonId);
        jobOrder.setFailureReason(failureReasonString);

        Job job = new JobBuilder().setAction(Job.ACTION_FAIL)
                .setId(deliveryJobId)
                .setMode(Job.MODE_DELIVERY)
                .setStatus(Job.STATUS_PENDING)
                .setType(Job.TYPE_TRANSACTION)
                .setOrders(new ArrayList<Order>(){{add(jobOrder);}}).createJob();

        List<Job> jobs = new ArrayList<>();
        jobs.add(job);

        DeliveryRequest request = new DeliveryRequest(deliveryWaypointId, jobs).setAsFailV2();
        driverClient.failedDefaultV2(routeId, deliveryWaypointId, request);
    }
}
