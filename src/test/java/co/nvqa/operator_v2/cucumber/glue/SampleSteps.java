package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import io.cucumber.java.en.Given;
import io.cucumber.guice.ScenarioScoped;
import java.util.Random;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class SampleSteps extends AbstractSteps {

  private static final Random random = new Random();

  public SampleSteps() {
  }

  @Override
  public void init() {
  }

  @Given("^step \"([^\"]*)\"$")
  public void stepSuccessOrFailed(String status) {
    String scenarioName = getScenarioManager().getCurrentScenario().getName();

    if ("success".equalsIgnoreCase(status)) {
      NvLogger.info("Step SUCCESS on scenario: " + scenarioName);
    } else if ("failed".equalsIgnoreCase(status)) {
      throw new NvTestRuntimeException("Step FAILED on scenario: " + scenarioName);
    } else {
      randomStep();
    }
  }

  @Given("^random step$")
  public void randomStep() {
    String scenarioName = getScenarioManager().getCurrentScenario().getName();
    boolean randomSuccess = random.nextBoolean();

    if (randomSuccess) {
      NvLogger.info("Step SUCCESS on scenario: " + scenarioName);
    } else {
      throw new NvTestRuntimeException("Step FAILED on scenario: " + scenarioName);
    }
  }
}
