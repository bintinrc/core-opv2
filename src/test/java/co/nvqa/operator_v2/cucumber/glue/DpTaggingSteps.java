package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.DpTagging;
import co.nvqa.operator_v2.selenium.page.DpTaggingPage;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class DpTaggingSteps extends AbstractSteps
{
    private DpTaggingPage dpTaggingPage;

    public DpTaggingSteps()
    {
    }

    @Override
    public void init()
    {
        dpTaggingPage = new DpTaggingPage(getWebDriver());
    }

    @When("^Operator tags single order to DP with DPMS ID = \"([^\"]*)\"$")
    public void operatorTagsSingleOrderToDpWithId(String dpIdAsString)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        long dpId = Long.parseLong(dpIdAsString);

        DpTagging dpTagging = new DpTagging();
        dpTagging.setTrackingId(trackingId);
        dpTagging.setDpId(dpId);

        List<DpTagging> listOfDpTagging = new ArrayList<>();
        listOfDpTagging.add(dpTagging);

        dpTaggingPage.uploadDpTaggingCsv(listOfDpTagging);
        dpTaggingPage.verifyDpTaggingCsvIsUploadedSuccessfully(listOfDpTagging);
        dpTaggingPage.checkAndAssignAll(false);

        put("listOfDpTagging", listOfDpTagging);
        put(KEY_DISTRIBUTION_POINT_ID, dpId);
    }

    @When("^Operator tags multiple orders to DP with DPMS ID = \"([^\"]*)\"$")
    public void operatorTagsMultipleOrdersToDpWithId(String dpIdAsString)
    {
        List<String> listOfTrackingId = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        long dpId = Long.parseLong(dpIdAsString);

        List<DpTagging> listOfDpTagging = new ArrayList<>();

        for(String trackingId : listOfTrackingId)
        {
            DpTagging dpTagging = new DpTagging();
            dpTagging.setTrackingId(trackingId);
            dpTagging.setDpId(dpId);
            listOfDpTagging.add(dpTagging);
        }

        dpTaggingPage.uploadDpTaggingCsv(listOfDpTagging);
        dpTaggingPage.verifyDpTaggingCsvIsUploadedSuccessfully(listOfDpTagging);
        dpTaggingPage.checkAndAssignAll(true);

        put("listOfDpTagging", listOfDpTagging);
        put(KEY_DISTRIBUTION_POINT_ID, dpId);
    }

    @When("^Operator uploads invalid DP Tagging CSV$")
    public void operatorUploadsInvalidDpTaggingCsv()
    {
        dpTaggingPage.uploadInvalidDpTaggingCsv();
    }

    @When("^Operator verify invalid DP Tagging CSV is not uploaded successfully$")
    public void operatorVerifyInvalidDpTaggingCsvIsNotUploadedSuccessfully()
    {
        dpTaggingPage.verifyInvalidDpTaggingCsvIsNotUploadedSuccessfully();
    }
}
