package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.dp.Dp;
import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.Hours;
import co.nvqa.commons.model.dp.dp_user.User;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
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
  private static final String UPDATE_SUCCESS = "Success";
  private static final String UPDATE_FAILED = "Failed";
  private static final String INVALID_DELETE_DP = "Invalid Delete DP";
  private static final String OPERATING_HOURS_EVERYDAY_DOUBLE = "OPERATING_HOURS_EVERYDAY_DOUBLE";

  private static final String ALTERNATE_DP_ID_1 = "ALTERNATE_DP_ID_1";
  private static final String ALTERNATE_DP_ID_2 = "ALTERNATE_DP_ID_2";
  private static final String ALTERNATE_DP_ID_3 = "ALTERNATE_DP_ID_3";

  @Then("Operator need to check that the update is {string}")
  public void OperatorCheckUpdateDp(String occasion) {
    switch (occasion) {
      case UPDATE_SUCCESS:
        successUpdate();
        break;

      case UPDATE_FAILED:
        failedUpdate();
        break;

    }
  }

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

  @When("Operator fill Detail for create DP Management User:")
  public void ninjaPointVUserFillDetailForCreateDpManagementUser(DataTable dt) {
    List<User> dpUsers = convertDataTableToList(dt, User.class);
    User dpUser = dpUsers.get(0);
    if (dpUser.getUsername().equals("GENERATED")) {
      dpUser.setUsername(TestUtils.generateAlphaNumericString(6));
    }
    put(KEY_CREATE_DP_MANAGEMENT_USER_REQUEST, dpUser);
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

  @Then("Operator Update Dp To Redirect for DP")
  public void operatorUpdateDpsToRedirectForDp(Map<String, String> dpToRedirectValues) {
    dpToRedirectValues = resolveKeyValues(dpToRedirectValues);
    String dpToRedirect = dpToRedirectValues.get("dpsToRedirect");
    DpDetailsResponse dpDetail = get(KEY_CREATE_DP_REQUEST);

    String[] dpRedirectList = dpToRedirect.split(",");
    List<Long> dpsToRedirect = new ArrayList<>();
    for (int i = 0; i < dpRedirectList.length; i++) {
      dpsToRedirect.add(Long.parseLong(dpRedirectList[i]));
    }
    dpDetail.setDpsToRedirect(dpsToRedirect);
    put(KEY_CREATE_DP_REQUEST, dpDetail);
  }

  @Then("Operator Update Dp To Redirect for DP Management")
  public void operatorUpdateDpsToRedirectForDpManagement(Map<String, String> dpToRedirectValues) {
    dpToRedirectValues = resolveKeyValues(dpToRedirectValues);
    String dpToRedirect = dpToRedirectValues.get("dpsToRedirect");
    DpDetailsResponse dpDetail = get(KEY_CREATE_DP_MANAGEMENT_REQUEST);

    String[] dpRedirectList = dpToRedirect.split(",");
    List<Long> dpsToRedirect = new ArrayList<>();
    for (int i = 0; i < dpRedirectList.length; i++) {
      dpsToRedirect.add(Long.parseLong(dpRedirectList[i]));
    }
    dpDetail.setDpsToRedirect(dpsToRedirect);
    put(KEY_CREATE_DP_MANAGEMENT_REQUEST, dpDetail);
  }

  @When("Operator fill Detail for create DP Management:")
  public void ninjaPointVUserFillDetailForCreateDpManagement(DataTable dt) {
    List<DpDetailsResponse> dpDetails = convertDataTableToList(dt, DpDetailsResponse.class);
    DpDetailsResponse dpDetail = dpDetails.get(0);

    if (dpDetail.getShortName().equals("GENERATED")) {
      dpDetail.setShortName(TestUtils.generateAlphaNumericString(6));
    }
    if (dpDetail.getExternalStoreId().equals("GENERATED")) {
      dpDetail.setExternalStoreId(TestUtils.generateAlphaNumericString(6));
    }
    if (dpDetail.getHubName() != null) {
      put(KEY_CREATE_DP_MANAGEMENT_HUB_NAME, dpDetail.getHubName());
    }

    Map<String, List<Hours>> defaultTime = new HashMap<>();

    if (dpDetail.getOperatingHoursDay() == null || !dpDetail.getIsOperatingHours()) {
      defaultTime = selectDayDateAvailable(null, true, true);
    } else if (dpDetail.getIsOperatingHours() && dpDetail.getOperatingHoursDay() != null) {
      if (dpDetail.getOperatingHoursDay().equals(OPERATING_HOURS_EVERYDAY_DOUBLE)) {
        String days = "monday,tuesday,wednesday,thursday,friday,saturday,sunday";
        defaultTime = selectDayDateAvailableDouble(days, 2);
        dpDetail.setOperatingHoursDay(days);
      } else if (!dpDetail.getIsTimestampSame()) {
        defaultTime = selectDayDateAvailable(dpDetail.getOperatingHoursDay(), false, false);
      } else {
        defaultTime = selectDayDateAvailable(dpDetail.getOperatingHoursDay(), false, true);
      }
    }

    dpDetail.setOpeningHours(defaultTime);
    dpDetail.setOperatingHours(defaultTime);

    put(KEY_CREATE_DP_MANAGEMENT_REQUEST, null);
    put(KEY_CREATE_DP_MANAGEMENT_REQUEST, dpDetail);
  }

  public Map<String, List<Hours>> selectDayDateAvailable(String days, boolean isEveryday,
      boolean isTimeStampSame) {
    Map<String, List<Hours>> daysAvailable = new HashMap<>();
    if (isEveryday) {
      daysAvailable.put("monday", selectTimeStamp(isTimeStampSame, null));
      daysAvailable.put("tuesday", selectTimeStamp(isTimeStampSame, null));
      daysAvailable.put("wednesday", selectTimeStamp(isTimeStampSame, null));
      daysAvailable.put("thursday", selectTimeStamp(isTimeStampSame, null));
      daysAvailable.put("friday", selectTimeStamp(isTimeStampSame, null));
      daysAvailable.put("saturday", selectTimeStamp(isTimeStampSame, null));
      daysAvailable.put("sunday", selectTimeStamp(isTimeStampSame, null));
    } else if (!isTimeStampSame) {
      String[] dayList = days.split(",");
      for (int i = 0; i < dayList.length; i++) {
        daysAvailable.put(dayList[i], selectTimeStamp(false, i));
      }
    } else {
      String[] dayList = days.split(",");
      for (int i = 0; i < dayList.length; i++) {
        daysAvailable.put(dayList[i], selectTimeStamp(true, null));
      }
    }

    return daysAvailable;
  }

  public Map<String, List<Hours>> selectDayDateAvailableDouble(String days, int increment) {
    Map<String, List<Hours>> daysAvailable = new HashMap<>();

    String[] dayList = days.split(",");
    for (int i = 0; i < dayList.length; i++) {
      List<Hours> fetchTimeStamp = new ArrayList<>();
      for (int j = 0; j < increment; j++) {
        fetchTimeStamp.add(selectTimeStamp(false, i + j + 1).get(0));
      }
      daysAvailable.put(dayList[i], fetchTimeStamp);
    }

    return daysAvailable;
  }

  public List<Hours> selectTimeStamp(boolean isTimeStampSame, Integer index) {
    List<Hours> timeStamp = new ArrayList<>();
    if (!isTimeStampSame && index != null) {

      int defaultStartHour = 10;
      int defaultEndHour = 15;

      Hours hours = new Hours();
      int startHourIncrement = (defaultStartHour + index);
      int endHourIncrement = (defaultEndHour + index);

      if (startHourIncrement > 23) {
        defaultStartHour = 2;
      }
      if (endHourIncrement > 23) {
        defaultEndHour = 2;
      }

      if ((defaultStartHour + index) < 10) {
        hours.setStartTime("0" + (defaultStartHour + index) + ":00:00");
      } else {
        hours.setStartTime((defaultStartHour + index) + ":00:00");
      }

      if ((defaultEndHour + index) < 10) {
        hours.setEndTime("0" + (defaultEndHour + index) + ":00:00");
      } else {
        hours.setEndTime((defaultEndHour + index) + ":00:00");
      }
      timeStamp.add(hours);

    } else if (isTimeStampSame) {
      Hours hours = new Hours();
      hours.setStartTime("08:00:00");
      hours.setEndTime("21:00:00");

      timeStamp.add(hours);
    }
    return timeStamp;
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

  public void failedUpdate() {
    DpDetailsResponse dp = get(KEY_CREATE_DP_RESPONSE);
    DpDetailsResponse dpManagement = get(KEY_CREATE_DP_MANAGEMENT_RESPONSE);

    Assertions.assertThat(dp)
        .as("DP is not Updated")
        .isNull();

    Assertions.assertThat(dpManagement)
        .as("DP Management is not Updated")
        .isNull();
  }

  public void successUpdate() {
    DpDetailsResponse dp = get(KEY_CREATE_DP_RESPONSE);
    DpDetailsResponse dpManagement = get(KEY_CREATE_DP_MANAGEMENT_RESPONSE);

    Assertions.assertThat(dp)
        .as("DP is Updated")
        .isNotNull();

    Assertions.assertThat(dpManagement)
        .as("DP Management is Updated")
        .isNotNull();
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
