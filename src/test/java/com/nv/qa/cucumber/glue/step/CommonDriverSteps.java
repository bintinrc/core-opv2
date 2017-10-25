package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.integration.client.DriverClient;
import com.nv.qa.integration.helper.NvLogger;
import com.nv.qa.integration.model.auth.DriverLoginResponse;
import com.nv.qa.integration.model.core.Waypoint;
import com.nv.qa.integration.model.driver.Job;
import com.nv.qa.integration.model.driver.Route;
import com.nv.qa.integration.model.driver.builder.JobBuilder;
import com.nv.qa.integration.model.driver.scan.DeliveryRequest;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.ScenarioStorage;
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

    @Inject ScenarioStorage scenarioStorage;
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
            driverClient = new DriverClient(APIEndpoint.API_BASE_URL, driverLoginResponse.getAccessToken());
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

    @When("^Driver try to find his pickup waypoint for C2C/Return order$")
    public void driverTryToFindHisPickupWaypointForC2cOrReturnOrder()
    {
        List<com.nv.qa.integration.model.driver.Route> routes = scenarioStorage.get(KEY_DRIVER_ROUTES_LIST);
        Order order = scenarioStorage.get("order");
        int deliveryWaypointId = -1;
        int deliveryJobId = -1;
        com.nv.qa.integration.model.driver.Order jobOrder = null;
        int i = 0;
        boolean found = false;

        for(com.nv.qa.integration.model.driver.Route route : routes)
        {
            NvLogger.info(String.format("iterate route: %d id: %d, from %d routes", i, route.getId(), routes.size()));
            List<Waypoint> waypoints = route.getWaypoints();

            for(Waypoint wp : waypoints)
            {
                List<Job> jobs = wp.getJobs();

                if(jobs!=null)
                {
                    for(Job job : jobs)
                    {
                        List<com.nv.qa.integration.model.driver.Order> listOfDriverOrders = job.getOrders();

                        if(listOfDriverOrders!=null)
                        {
                            for(com.nv.qa.integration.model.driver.Order jo : job.getOrders())
                            {
                                if(jo.getTrackingId().equals(order.getTracking_id()))
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

        Assert.assertTrue("Pickup Waypoint not found on Driver Pick Up", found);
        Assert.assertNotEquals("Delivery waypoint is found", -1, deliveryWaypointId);
        Assert.assertNotEquals("Delivery job is found", -1, deliveryJobId);
        Assert.assertNotNull("Job Order not null", jobOrder);

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

        Assert.assertNotEquals("pickup job found", -1L, deliveryJobId);

        Integer failureReasonId = (APIEndpoint.API_BASE_URL.toLowerCase().contains("/id"))
                ? com.nv.qa.integration.model.driver.Order.DEFAULT_FAIL_ID_SG
                : com.nv.qa.integration.model.driver.Order.DEFAULT_FAIL_ID_SG;

        String failureReasonString = (APIEndpoint.API_BASE_URL.toLowerCase().contains("/id"))
                ? com.nv.qa.integration.model.driver.Order.DEFAULT_FAIL_ID_SG_STRING
                : com.nv.qa.integration.model.driver.Order.DEFAULT_FAIL_ID_SG_STRING;

        com.nv.qa.integration.model.driver.Order jobOrder = scenarioStorage.get(KEY_DRIVER_JOB_ORDER);
        jobOrder.setAction(com.nv.qa.integration.model.driver.Order.ACTION_FAIL);
        jobOrder.setFailureReasonId(failureReasonId);
        jobOrder.setFailureReason(failureReasonString);

        Job job = new JobBuilder().setAction(Job.ACTION_FAIL)
                .setId(deliveryJobId)
                .setMode(Job.MODE_PICKUP)
                .setStatus(Job.STATUS_PENDING)
                .setType(Job.TYPE_TRANSACTION)
                .setOrders(new ArrayList<com.nv.qa.integration.model.driver.Order>(){{add(jobOrder);}}).createJob();

        List<Job> jobs = new ArrayList<>();
        jobs.add(job);

        DeliveryRequest request = new DeliveryRequest(deliveryWaypointId, jobs).setAsFailV2();
        driverClient.failedDefaultV2(routeId, deliveryWaypointId, request);
    }
}
