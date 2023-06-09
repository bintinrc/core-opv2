package co.nvqa.operator_v2.cucumber.glue.dp;

import co.nvqa.commons.util.GmailClient;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@ScenarioScoped
public class DpGmailSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(DpGmailSteps.class);

  @Override
  public void init() {

  }

  @Then("Verifies email with details:")
  public void operatorOpensGmailAndVerifiesEmailWithDetails(
      Map<String, String> dataTableAsMap) {
    // Skip this step if GAIA
    final String environment = StandardTestConstants.NV_DATABASE_ENVIRONMENT;
    if ("QA".equalsIgnoreCase(environment)) {
      pause10s();
      Map<String, String> map = resolveKeyValues(dataTableAsMap);
      final String expectedBody = resolveValue(map.get("emailBody"));
      final String expectedTrackingId = map.get("expectedTrackingId");
      final String expectedTrackingIds = map.get("expectedTrackingIds");
      final String expectedSubject = map.get("expectedSubject");
      final String emailClientId = map.get("credentialsUsername");
      final String emailClientSecret = map.get("credentialsPassword");

      final GmailClient gmailClient = new GmailClient(emailClientId, emailClientSecret);
      gmailClient.readUnseenMessage(message ->
      {
        boolean trackingIdFound = false;

        if (message.getSubject().contains(expectedSubject)) {
          String emailBody = gmailClient.getSimpleContentBody(message);
          Assertions.assertThat(emailBody)
              .as("Actual and expected body message is matched")
              .containsIgnoringCase(expectedBody);


          putInList(KEY_LIST_OF_EMAIL_BODY, emailBody);
          put(KEY_EMAIL_BODY, emailBody);
        }
      });
    }
  }
}
