package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.ui.cucumber.glue.selenium.CommonSeleniumAbstractSteps;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public abstract class AbstractSteps extends CommonSeleniumAbstractSteps<ScenarioManager> implements
    ScenarioStorageKeys {

  public AbstractSteps() {
  }

}
