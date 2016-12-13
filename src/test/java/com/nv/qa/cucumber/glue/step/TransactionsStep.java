package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.page.TransactionsPage;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class TransactionsStep extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private TransactionsPage transactionsPage;

    @Inject
    public TransactionsStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        transactionsPage = new TransactionsPage(getDriver());
    }

    @When("^Operator V2 add 'Transaction' to 'Route Group'$")
    public void addTransactionToRouteGroup()
    {
        String routeGroupTemplateName = scenarioStorage.get("routeGroupTemplateName");
        String routeGroupName = scenarioStorage.get("routeGroupName");

        transactionsPage.selectVariable(routeGroupTemplateName);
        transactionsPage.clickLoadAllEntriesButton();
        transactionsPage.selectAllShown();
        transactionsPage.clickAddToRouteGroupButton();
        transactionsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
        takesScreenshot();
        transactionsPage.clickAddTransactionsOnAddToRouteGroupDialog();
        takesScreenshot();
    }
}
