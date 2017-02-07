package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.TransactionsV2Page;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class TransactionsV2Step extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private TransactionsV2Page transactionsPage;

    @Inject
    public TransactionsV2Step(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        transactionsPage = new TransactionsV2Page(getDriver());
    }

    @When("^Operator V2 add 'Transaction V2' to 'Route Group'$")
    public void addTransactionToRouteGroup()
    {

        String routeGroupName = scenarioStorage.get("routeGroupName");

        transactionsPage.clickLoadSelectionButton();
        transactionsPage.selectAllShown();
        transactionsPage.clickAddToRouteGroupButton();
        transactionsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
        takesScreenshot();
        transactionsPage.clickAddTransactionsOnAddToRouteGroupDialog();
        takesScreenshot();
        pause5s();
    }
}
