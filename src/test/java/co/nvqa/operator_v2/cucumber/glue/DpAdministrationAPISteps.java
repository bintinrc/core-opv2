package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.dp.Dp;
import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.Hours;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;

/**
 * @author Diaz Ilyasa
 */
@ScenarioScoped
public class DpAdministrationAPISteps extends AbstractSteps {

  public DpAdministrationAPISteps() {
  }

  @Override
  public void init() {
  }

  private static final String DELETE_DP = "Delete DP";
  private static final String INVALID_DELETE_DP = "Invalid Delete DP";

  @Then("Operator need to compare both of delete result after {string} and make sure both of the data is valid")
  public void APIDPgetDpDeleteAndValidate(String occasion) {
    switch (occasion) {
      case DELETE_DP:
        apiDeleteCheckForDeleteDp();
        break;

      case INVALID_DELETE_DP:
        apiDeleteCheckForInvalidDeleteDp();
        break;

    }
  }

  @When("Operator fill Detail for create DP:")
  public void ninjaPointVUserFillDetailForCreateDp(DataTable dt) {
    List<DpDetailsResponse> dpDetails = convertDataTableToList(dt, DpDetailsResponse.class);
    DpDetailsResponse dpDetail = dpDetails.get(0);

    Hours hours = new Hours();
    hours.setStartTime("08:00:00");
    hours.setEndTime("21:00:00");

    List<Hours> hourList = new ArrayList<>();
    hourList.add(hours);

    Map<String, List<Hours>> workingHours = new HashMap<>();
    workingHours.put("monday", hourList);
    workingHours.put("tuesday", hourList);
    workingHours.put("wednesday", hourList);
    workingHours.put("thursday", hourList);
    workingHours.put("friday", hourList);
    workingHours.put("saturday", hourList);
    workingHours.put("sunday", hourList);

    dpDetail.setOpeningHours(workingHours);
    dpDetail.setOperatingHours(workingHours);

    put(KEY_CREATE_DP_REQUEST, dpDetail);
  }

  @When("Operator fill Detail for update DP:")
  public void ninjaPointVUserFillDetailForUpdateDp(DataTable dt) {
    List<DpDetailsResponse> dpDetails = convertDataTableToList(dt, DpDetailsResponse.class);
    DpDetailsResponse dpDetail = dpDetails.get(0);
    DpDetailsResponse dpNewlyCreated = get(KEY_CREATE_DP_RESPONSE);

    dpDetail.setDpmsId(dpNewlyCreated.getDpmsId());
    dpDetail.setId(dpNewlyCreated.getId());
    dpDetail.setPartnerId(dpNewlyCreated.getPartnerId());

    Hours hours = new Hours();
    hours.setStartTime("08:00:00");
    hours.setEndTime("21:00:00");

    List<Hours> hourList = new ArrayList<>();
    hourList.add(hours);

    Map<String, List<Hours>> workingHours = new HashMap<>();
    workingHours.put("monday", hourList);
    workingHours.put("tuesday", hourList);
    workingHours.put("wednesday", hourList);
    workingHours.put("thursday", hourList);
    workingHours.put("friday", hourList);
    workingHours.put("saturday", hourList);
    workingHours.put("sunday", hourList);

    dpDetail.setOpeningHours(workingHours);
    dpDetail.setOperatingHours(workingHours);

    put(KEY_CREATE_DP_REQUEST, null);
    put(KEY_CREATE_DP_REQUEST, dpDetail);
  }


  @When("Operator fill Detail for create DP Management:")
  public void ninjaPointVUserFillDetailForCreateDpManagement(DataTable dt) {
    List<DpDetailsResponse> dpDetails = convertDataTableToList(dt, DpDetailsResponse.class);
    DpDetailsResponse dpDetail = dpDetails.get(0);

    Hours hours = new Hours();
    hours.setStartTime("08:00:00");
    hours.setEndTime("21:00:00");

    List<Hours> hourList = new ArrayList<>();
    hourList.add(hours);

    Map<String, List<Hours>> workingHours = new HashMap<>();
    workingHours.put("monday", hourList);
    workingHours.put("tuesday", hourList);
    workingHours.put("wednesday", hourList);
    workingHours.put("thursday", hourList);
    workingHours.put("friday", hourList);
    workingHours.put("saturday", hourList);
    workingHours.put("sunday", hourList);

    dpDetail.setOpeningHours(workingHours);
    dpDetail.setOperatingHours(workingHours);

    put(KEY_CREATE_DP_MANAGEMENT_REQUEST, dpDetail);
  }

  @When("Operator fill Detail for update DP Management:")
  public void ninjaPointVUserFillDetailForUpdateDpManagement(DataTable dt) {
    List<DpDetailsResponse> dpDetails = convertDataTableToList(dt, DpDetailsResponse.class);
    DpDetailsResponse dpDetail = dpDetails.get(0);
    DpDetailsResponse dpNewlyCreated = get(KEY_CREATE_DP_MANAGEMENT_RESPONSE);

    dpDetail.setDpmsId(dpNewlyCreated.getDpmsId());
    dpDetail.setId(dpNewlyCreated.getId());
    dpDetail.setPartnerId(dpNewlyCreated.getPartnerId());

    Hours hours = new Hours();
    hours.setStartTime("08:00:00");
    hours.setEndTime("21:00:00");

    List<Hours> hourList = new ArrayList<>();
    hourList.add(hours);

    Map<String, List<Hours>> workingHours = new HashMap<>();
    workingHours.put("monday", hourList);
    workingHours.put("tuesday", hourList);
    workingHours.put("wednesday", hourList);
    workingHours.put("thursday", hourList);
    workingHours.put("friday", hourList);
    workingHours.put("saturday", hourList);
    workingHours.put("sunday", hourList);

    dpDetail.setOpeningHours(workingHours);
    dpDetail.setOperatingHours(workingHours);

    put(KEY_CREATE_DP_MANAGEMENT_REQUEST, null);
    put(KEY_CREATE_DP_MANAGEMENT_REQUEST, dpDetail);
  }

  public void apiDeleteCheckForDeleteDp() {
    Dp dp = get(KEY_CREATE_DP_DB_DATA);
    Dp dpManagement = get(KEY_CREATE_DP_MANAGEMENT_DB_DATA);

    Assertions.assertThat(dpManagement.getName())
        .as("DP Name Is Same")
        .isEqualTo(dp.getName());

    Assertions.assertThat(dpManagement.getAddress1())
        .as("DP Address 1 Is Same")
        .isEqualTo(dp.getAddress1());

    Assertions.assertThat(dpManagement.getAddress2())
        .as("DP Address 2 Is Same")
        .isEqualTo(dp.getAddress2());

    Assertions.assertThat(dpManagement.getCity())
        .as("DP city Is Same")
        .isEqualTo(dp.getCity());

    Assertions.assertThat(dpManagement.getCountry())
        .as("DP Country Is Same")
        .isEqualTo(dp.getCountry());

    Assertions.assertThat(dpManagement.getPostalCode())
        .as("DP Postal Code Is Same")
        .isEqualTo(dp.getPostalCode());

    Assertions.assertThat(dp.getDeletedAt())
        .as("DP Delete At is not null after delete")
        .isNotNull();

    Assertions.assertThat(dpManagement.getDeletedAt())
        .as("DP Management Delete At is not null after delete")
        .isNotNull();

  }

  public void apiDeleteCheckForInvalidDeleteDp() {
    Dp dp = get(KEY_CREATE_DP_DB_DATA);
    Dp dpManagement = get(KEY_CREATE_DP_MANAGEMENT_DB_DATA);

    Assertions.assertThat(dpManagement.getName())
        .as("DP Name Is Same")
        .isEqualTo(dp.getName());

    Assertions.assertThat(dpManagement.getAddress1())
        .as("DP Address 1 Is Same")
        .isEqualTo(dp.getAddress1());

    Assertions.assertThat(dpManagement.getAddress2())
        .as("DP Address 2 Is Same")
        .isEqualTo(dp.getAddress2());

    Assertions.assertThat(dpManagement.getCity())
        .as("DP city Is Same")
        .isEqualTo(dp.getCity());

    Assertions.assertThat(dpManagement.getCountry())
        .as("DP Country Is Same")
        .isEqualTo(dp.getCountry());

    Assertions.assertThat(dpManagement.getPostalCode())
        .as("DP Postal Code Is Same")
        .isEqualTo(dp.getPostalCode());

    Assertions.assertThat(dp.getDeletedAt())
        .as("DP Delete At is null after delete")
        .isNull();

    Assertions.assertThat(dpManagement.getDeletedAt())
        .as("DP Management Delete At is null after delete")
        .isNull();

  }

}
