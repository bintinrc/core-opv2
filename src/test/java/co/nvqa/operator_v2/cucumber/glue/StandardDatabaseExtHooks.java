package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.StandardScenarioManager;
import co.nvqa.commons.cucumber.glue.AbstractDatabaseSteps;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.UserManagement;
import io.cucumber.java.After;
import io.cucumber.guice.ScenarioScoped;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class StandardDatabaseExtHooks extends
    AbstractDatabaseSteps<StandardScenarioManager> implements ScenarioStorageKeys {

  private static final Logger LOGGER = LoggerFactory.getLogger(StandardDatabaseExtHooks.class);

  public StandardDatabaseExtHooks() {
  }

  @Override
  public void init() {
  }

  @After("@DeleteDpPartner")
  public void deleteDpPartner() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);

    if (dpPartner != null) {
      getDpJdbc().deleteDpPartner(dpPartner.getName());
    }
  }

  @After("@DeleteDpAndPartner")
  public void deleteDp() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);

    if (dpPartner != null) {
      getDpJdbc().deleteDp(dpPartner.getName());
      getDpJdbc().deleteDpPartner(dpPartner.getName());
    }
  }

  @After("@DeleteDpUserDpAndPartner")
  public void deleteDpUser() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);

    if (dpPartner != null) {
      getDpJdbc().deleteDpUser(dpPartner.getName());
      getDpJdbc().deleteDp(dpPartner.getName());
      getDpJdbc().deleteDpPartner(dpPartner.getName());
    }
  }

  @After("@SoftDeleteOauthClientByEmailAddress")
  public void dbOperatorSoftDeleteOauthClientByEmailAddress() {
    List<UserManagement> listOfUserManagement = new ArrayList<>();
    listOfUserManagement.add(get(KEY_CREATED_USER_MANAGEMENT));
    listOfUserManagement.add(get(KEY_UPDATED_USER_MANAGEMENT));

    Set<String> setOfEmailAddress = new HashSet<>();

    for (UserManagement userManagement : listOfUserManagement) {
      if (userManagement != null && userManagement.getEmail() != null) {
        setOfEmailAddress.add(userManagement.getEmail());
      }
    }

    for (String emailAddress : setOfEmailAddress) {
      if (emailAddress != null) {
        LOGGER.warn("Soft Deleting OAuth Client with Email Address: {}", emailAddress);
        getAuthJdbc().softDeleteOauthClientByEmailAddress(emailAddress);
      }
    }
  }
}
