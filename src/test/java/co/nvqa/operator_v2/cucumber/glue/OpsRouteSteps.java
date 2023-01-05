package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.OpsRoutePage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.Random;
import org.assertj.core.api.Assertions;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class OpsRouteSteps extends AbstractSteps {

  private static final int EDITED_ROW_NUMBER = 1;
  private OpsRoutePage opsRoutePage;
  private String newRouteId;

  public OpsRouteSteps() {
  }

  @Override
  public void init() {
    opsRoutePage = new OpsRoutePage(getWebDriver());
  }

  @When("^Operator clicks edit button on table at Ops Route menu$")
  public void editOpsRoute() {
        /*
          Generate random number.
         */
    Random random = new Random();
    int randomNumber = random.nextInt(99999);
    newRouteId = String.valueOf(randomNumber);
    opsRoutePage.editOpsRoute(EDITED_ROW_NUMBER, newRouteId);
  }

  @Then("^Operator verifies the Route ID is changed$")
  public void verifyEditOpsRouteSuccess() {
    String actualRouteId = opsRoutePage.getRouteIdAtRow(EDITED_ROW_NUMBER);
    Assertions.assertThat(actualRouteId).isEqualTo(newRouteId);
  }
}
