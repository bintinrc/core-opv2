package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.PathManagementPage;
import cucumber.runtime.java.guice.ScenarioScoped;

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

}
