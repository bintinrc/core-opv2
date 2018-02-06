package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import co.nvqa.commons.model.order_create.v2.Parcel;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.EditOrderPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.apache.commons.lang3.SerializationUtils;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class EditOrderSteps extends AbstractSteps
{
    private EditOrderPage editOrderPage;

    @Inject
    public EditOrderSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        editOrderPage = new EditOrderPage(getWebDriver());
    }

    @When("^Operator click ([^\"]*) -> ([^\"]*) on Edit Order page$")
    public void operatorClickMenuOnEditOrderPage(String parentMenuName, String childMenuName)
    {
        editOrderPage.clickMenu(parentMenuName, childMenuName);
    }

    @When("^Operator Edit Order Details on Edit Order page$")
    public void operatorEditOrderDetailsOnEditOrderPage()
    {
        OrderRequestV2 orderRequestV2 = get(KEY_ORDER_CREATE_REQUEST);

        OrderRequestV2 orderRequestV2Edited = SerializationUtils.clone(orderRequestV2);
        Parcel parcelEdited = orderRequestV2Edited.getParcels().get(0);

        int newParcelSizeId = (parcelEdited.getParcelSizeId()+1)%4;
        parcelEdited.setParcelSizeId(newParcelSizeId);

        Double newWeight = parcelEdited.getWeight();

        if(newWeight==null)
        {
            newWeight = 1.0;
        }
        else
        {
            newWeight += 1.0;
        }

        parcelEdited.setWeight(newWeight);

        editOrderPage.editOrderDetails(orderRequestV2Edited);
        put("orderRequestV2Edited", orderRequestV2Edited);
    }

    @Then("^Operator Edit Order Details on Edit Order page successfully$")
    public void operatorEditOrderDetailsOnEditOrderPageSuccessfully()
    {
        OrderRequestV2 orderRequestV2Edited = get("orderRequestV2Edited");
        Order order = get(KEY_ORDER_DETAILS);
        editOrderPage.verifyEditOrderDetailsIsSuccess(orderRequestV2Edited, order);
    }

    @When("^Operator Edit Cash Collection Details on Edit Order page$")
    public void operatorEditCashCollectionDetailsOnEditOrderPage()
    {

    }
}
