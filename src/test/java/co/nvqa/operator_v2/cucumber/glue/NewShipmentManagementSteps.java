package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.model.MovementEvent;
import co.nvqa.operator_v2.model.ShipmentEvent;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage;
import co.nvqa.operator_v2.util.KeyConstants;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.FileNotFoundException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.util.Strings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.ACTION_CANCEL;
import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.COLUMN_SHIPMENT_ID;

/**
 * Modified by Daniel Joi Partogi Hutapea. Modified by Sergey Mishanin.
 *
 * @author Lanang Jati
 */
@SuppressWarnings("WeakerAccess")
@ScenarioScoped
public class NewShipmentManagementSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(NewShipmentManagementSteps.class);

  private NewShipmentManagementPage page;
  public static final String KEY_SHIPMENT_MANAGEMENT_FILTERS = "KEY_SHIPMENT_MANAGEMENT_FILTERS";
  public static final String KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID = "KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID";
  public static final String KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME = "KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME";

  public NewShipmentManagementSteps() {
  }

  @Override
  public void init() {
    page = new NewShipmentManagementPage(getWebDriver());
  }

  @When("^Operator click \"Load All Selection\" on Shipment Management page$")
  public void listAllShipment() {
    page.inFrame(() -> {
      page.loadSelection.click();
      page.waitUntilLoaded(2, 30);
    });
  }

  @When("^Operator click ([^\"]*) button on Shipment Management page$")
  public void clickActionButton(String actionButton) {
    Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
    page.clickActionButton(shipmentId, actionButton);

    if ("Force".equals(actionButton)) {
      page.waitUntilForceToastDisappear(shipmentId);
    }
  }

  @When("^Operator filter ([^\"]*) = ([^\"]*) on Shipment Management page$")
  public void fillSearchFilter(String filter, String value) {
    String resolvedValue = resolveValue(value);
    putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, filter, resolvedValue);
    page.inFrame(() -> {

    });
  }

  @When("Operator apply filters on Shipment Management Page:")
  public void operatorFilerWithData(Map<String, String> mapOfData) {
    Map<String, String> data = resolveKeyValues(mapOfData);
    page.inFrame(() -> {
      if (data.containsKey("shipmentStatus")) {
        page.shipmentStatusFilter.clearAll();
        page.shipmentStatusFilter.selectFilter(splitAndNormalize(data.get("shipmentStatus")));
        putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, "Shipment Status", data.get("shipmentStatus"));
      }
      if (data.containsKey("shipmentType")) {
        page.shipmentTypeFilter.clearAll();
        page.shipmentTypeFilter.selectFilter(splitAndNormalize(data.get("shipmentType")));
      }
      if (data.containsKey("lastInboundHub")) {
        if (!page.lastInboundHubFilter.isDisplayedFast()) {
          page.addFilter.selectValue("Last Inbound Hub");
        } else {
          page.lastInboundHubFilter.clearAll();
        }
        page.lastInboundHubFilter.selectFilter(splitAndNormalize(data.get("lastInboundHub")));
        putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, "Last Inbound Hub", data.get("lastInboundHub"));
      }
    });
  }

  @When("Operator search shipments by given Ids on Shipment Management page:")
  public void fillSearchShipmentsByIds(List<String> ids) {
    String shipmentIds = Strings.join(resolveValues(ids)).with("\n");
    page.inFrame(() -> {
      page.shipmentIds.setValue(shipmentIds);
      page.searchByShipmentIds.click();
    });
  }

  @When("Operator filter shipment based on MAWB value on Shipment Management page")
  public void fillSearchFilterMawb() {
    final String mawb = get(KeyConstants.KEY_MAWB);

    page.addFilter("MAWB", mawb, true);
    putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, "MAWB", mawb);
  }

  @When("Operator filter shipment based on MAWB data value on Shipment Management page")
  public void fillSearchFilterMawbParameter(Map<String, String> mapData) {
    String mawb = resolveValue(mapData.get("mawb"));
    page.addFilter("MAWB", mawb, true);
    putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, "MAWB", mawb);
  }

  @When("Operator filter shipment based on {string} Date on Shipment Management page")
  public void fillSearchFilterByDate(String dateFieldName) {
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);
    LocalDateTime yesterday = today.minusDays(1);
    String dateOfYesterday = formatter.format(yesterday);
    LocalDateTime tomorrow = today.plusDays(1);
    String dateOfTomorrow = formatter.format(tomorrow);

    if (!dateFieldName.equals("Shipment Date")) {
      page.selectValueFromNvAutocompleteByItemTypesAndDismiss("filters",
          dateFieldName);
    }
    page.changeDate(dateFieldName, dateOfYesterday, true);
    page.changeDate(dateFieldName, dateOfTomorrow, false);
  }

  @Given("Operator click Edit filter on Shipment Management page")
  public void operatorClickEditFilterOnShipmentManagementPage() {
    page.inFrame(() -> page.editFilters.click());
  }

  @Then("^Operator scan Shipment with source ([^\"]*) in hub ([^\"]*) on Shipment Management page$")
  public void operatorScanShipmentWithSourceInHubOnShipmentManagementPage(String source,
      String hub) {
    try {
      page.shipmentScanExist(source, hub);
    } finally {
      page.closeScanModal();
    }
  }

  @Then("Operator verify inbounded Shipment exist on Shipment Management page")
  public void operatorVerifyInboundedShipmentExistOnShipmentManagementPage() {
    Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
    page.verifyInboundedShipmentExist(shipmentId);
  }

  @When("^Operator clear all filters on Shipment Management page$")
  public void operatorClearAllFiltersOnShipmentManagementPage() {
    page.clearAllFilters();
  }

  @When("^Operator create Shipment on Shipment Management page using data below:$")
  public void operatorCreateShipmentOnShipmentManagementPageUsingDataBelow(
      Map<String, String> mapOfData) {
    retryIfRuntimeExceptionOccurred(() -> {
      page.inFrame(page -> {
        page.waitUntilLoaded();
        try {
          final Map<String, String> finalData = resolveKeyValues(mapOfData);
          List<Order> listOfOrders;
          boolean isNextOrder = false;

          if (get("isNextOrder") != null) {
            isNextOrder = get("isNextOrder");
          }

          if (containsKey(KEY_LIST_OF_CREATED_ORDER)) {
            listOfOrders = get(KEY_LIST_OF_CREATED_ORDER);
          } else if (containsKey(KEY_CREATED_ORDER)) {
            listOfOrders = Arrays.asList(get(KEY_CREATED_ORDER));
          } else {
            listOfOrders = new ArrayList<>();
          }

          ShipmentInfo shipmentInfo = new ShipmentInfo();
          shipmentInfo.fromMap(finalData);
          shipmentInfo.setOrdersCount((long) listOfOrders.size());

          page.createShipment(shipmentInfo, isNextOrder);

          if (StringUtils.isBlank(shipmentInfo.getShipmentType())) {
            shipmentInfo.setShipmentType("AIR_HAUL");
          }

          put(KEY_SHIPMENT_INFO, shipmentInfo);
          put(KEY_CREATED_SHIPMENT, shipmentInfo);
          put(KEY_CREATED_SHIPMENT_ID, shipmentInfo.getId());

          if (isNextOrder) {
            Long secondShipmentId = page.createAnotherShipment();
            shipmentInfo.setId(secondShipmentId);
            Long shipmentIdBefore = get(KEY_CREATED_SHIPMENT_ID);
            List<Long> listOfShipmentId = new ArrayList<>();
            listOfShipmentId.add(shipmentIdBefore);
            listOfShipmentId.add(secondShipmentId);
            page.createShipmentDialog.close();
            page.createShipmentDialog.waitUntilInvisible();
            put(KEY_LIST_OF_CREATED_SHIPMENT_ID, listOfShipmentId);
          }
        } catch (Throwable ex) {
          LOGGER.debug("Searched element is not found, retrying after 2 seconds...");
          page.refreshPage();
          throw new NvTestRuntimeException(ex);
        }
      });
    }, 1);
  }

  @When("Operator create new Shipment on Shipment Management page using data below:")
  public void operatorCreateNewShipmentOnShipmentManagementPageUsingDataBelow(
      Map<String, String> mapOfData) {
    retryIfRuntimeExceptionOccurred(() -> {
      page.inFrame(() -> {
        try {
          final Map<String, String> finalData = resolveKeyValues(mapOfData);
          List<Order> listOfOrders;
          boolean isNextOrder = false;

          if (get("isNextOrder") != null) {
            isNextOrder = get("isNextOrder");
          }

          if (containsKey(KEY_LIST_OF_CREATED_ORDER)) {
            listOfOrders = get(KEY_LIST_OF_CREATED_ORDER);
          } else if (containsKey(KEY_CREATED_ORDER)) {
            listOfOrders = Collections.singletonList(get(KEY_CREATED_ORDER));
          } else {
            listOfOrders = new ArrayList<>();
          }

          ShipmentInfo shipmentInfo = new ShipmentInfo();
          shipmentInfo.fromMap(finalData);
          shipmentInfo.setOrdersCount((long) listOfOrders.size());

          page.createNewShipment(shipmentInfo);
          if (!page.checkErrMsgExist()) {
            page.submitNewShipment(isNextOrder);
            page.getNewShipperId();
          }

          if (StringUtils.isBlank(shipmentInfo.getShipmentType())) {
            shipmentInfo.setShipmentType(shipmentInfo.getShipmentType());
          }

          put(KEY_SHIPMENT_INFO, shipmentInfo);
          put(KEY_CREATED_SHIPMENT, shipmentInfo);
          put(KEY_CREATED_SHIPMENT_ID, shipmentInfo.getId());

          if (isNextOrder) {
            Long secondShipmentId = page.createAnotherShipment();
            shipmentInfo.setId(secondShipmentId);
            Long shipmentIdBefore = get(KEY_CREATED_SHIPMENT_ID);
            List<Long> listOfShipmentId = new ArrayList<>();
            listOfShipmentId.add(shipmentIdBefore);
            listOfShipmentId.add(secondShipmentId);

            put(KEY_LIST_OF_CREATED_SHIPMENT_ID, listOfShipmentId);
          }
        } catch (Throwable ex) {
          LOGGER.debug("Searched element is not found, retrying after 2 seconds...");
          page.refreshPage();
          throw new NvTestRuntimeException(ex);
        }
      });
    }, 10);
  }

  @When("Operator edit Shipment on Shipment Management page based on {string} using data below:")
  public void operatorEditShipmentOnShipmentManagementPageBasedOnTypeUsingDataBelow(String editType,
      Map<String, String> mapOfData) {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    switch (editType) {
      case "Start Hub":
        shipmentInfo.setOrigHubName(resolvedMapOfData.get("origHubName"));
        break;
      case "End Hub":
        shipmentInfo.setDestHubName(resolvedMapOfData.get("destHubName"));
        break;
      case "Comments":
        shipmentInfo.setComments(resolvedMapOfData.get("comments"));
        break;
      case "EDA & ETA":
        shipmentInfo.setArrivalDatetime(
            resolvedMapOfData.get("EDA") + " " + resolvedMapOfData.get("ETA"));
        break;
      case "mawb":
        shipmentInfo.setMawb(
            "12" + resolvedMapOfData.get("mawb").substring(0, 1) + "-" + resolvedMapOfData.get(
                "mawb").substring(1));
        break;
      case "non-mawb":
        shipmentInfo.setOrigHubName(resolvedMapOfData.get("origHubName"));
        shipmentInfo.setDestHubName(resolvedMapOfData.get("destHubName"));
        shipmentInfo.setComments(resolvedMapOfData.get("comments"));
        break;
    }
    page.editShipmentBy(editType, shipmentInfo, resolvedMapOfData);
    put(KEY_SHIPMENT_INFO, shipmentInfo);
  }

  @When("Operator force complete shipment from edit shipment")
  public void operatorForceCompleteShipmentFromEditShipment() {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    page.editShipmentBy("completed", shipmentInfo, null);
  }

  @When("^Operator edit Shipment on Shipment Management page using data below:$")
  public void operatorEditShipmentOnShipmentManagementPageUsingDataBelow(
      Map<String, String> mapOfData) {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    shipmentInfo.fromMap(mapOfData);
    page.editShipment(shipmentInfo);
  }

  @When("^Operator edit Shipment on Shipment Management page including MAWB using data below:$")
  public void operatorEditShipmentOnShipmentManagementPageIncludingMawbUsingDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    shipmentInfo.fromMap(mapOfData);
    page.editShipment(shipmentInfo);
    put(KeyConstants.KEY_MAWB, shipmentInfo.getMawb());
  }

  @Then("^Operator verify parameters of the created shipment on Shipment Management page$")
  public void operatorVerifyParametersOfTheCreatedShipmentOnShipmentManagementPage() {
    ShipmentInfo shipmentInfo;

    if (get(KEY_SHIPMENT_INFO) == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    } else {
      shipmentInfo = get(KEY_SHIPMENT_INFO);
    }

    page.inFrame(() -> page.validateShipmentInfo(shipmentInfo.getId(), shipmentInfo));
  }

  @Then("^Operator verify parameters of shipment on Shipment Management page using data below:$")
  public void operatorVerifyParametersShipmentOnShipmentManagementPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    data = StandardTestUtils.replaceDataTableTokens(data);
    ShipmentInfo shipmentInfo = new ShipmentInfo();
    shipmentInfo.fromMap(data);

    page.validateShipmentInfo(shipmentInfo.getId(), shipmentInfo);
  }

  @Then("^Operator open shipment management page and verify parameters of shipment on Shipment Management page using data below:$")
  public void operatorOpenShipmentManagementPageVerifyParametersShipmentOnShipmentManagementPage(
      Map<String, String> data) {
    data = resolveKeyValues(data);
    data = StandardTestUtils.replaceDataTableTokens(data);
    ShipmentInfo shipmentInfo = new ShipmentInfo();
    shipmentInfo.fromMap(data);

    page.validateShipmentInfo(shipmentInfo.getId(), shipmentInfo);
  }

  @Then("^Operator verify parameters of the created shipment via API on Shipment Management page$")
  public void operatorVerifyParametersOfTheCreatedShipmentViaApiOnShipmentManagementPage() {
    Shipments shipment = get(KEY_CREATED_SHIPMENT);
    page.validateShipmentId(shipment.getShipment().getId());
  }

  @Then("Operator verify parameters of the created multiple shipment on Shipment Management page")
  public void operatorVerifyParametersOfTheCreatedMultipleShipmentOnShipmentManagementPage() {
    List<Long> shipmentId = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    page.inFrame(() -> {
      for (Long shipmentIds : shipmentId) {
        page.validateShipmentId(shipmentIds);
      }
    });
  }

  @Then("^Operator verify the following parameters of the created shipment on Shipment Management page:$")
  public void operatorVerifyTheFollowingParametersOfTheCreatedShipmentOnShipmentManagementPage(
      Map<String, String> mapOfData) {
    Long shipmentId;

    if (get(KEY_CREATED_SHIPMENT_ID) != null) {
      shipmentId = get(KEY_CREATED_SHIPMENT_ID);
    } else if (get(KEY_SHIPMENT_INFO) != null) {
      ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
      shipmentId = shipmentInfo.getId();
    } else if (get(KEY_CREATED_SHIPMENT) != null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentId = shipments.getShipment().getId();
    } else {
      throw new IllegalArgumentException("Shipper id was not defined");
    }

    ShipmentInfo expectedShipmentInfo = new ShipmentInfo(resolveKeyValues(mapOfData));
    page.inFrame(() -> page.validateShipmentInfo(shipmentId, expectedShipmentInfo));
  }

  @Then("Operator verify the following parameters of shipment {string} on Shipment Management page:")
  public void operatorVerifyTheFollowingParametersForShipmentOnShipmentManagementPage(
      String shipmentIdAsString, Map<String, String> mapOfData) {
    String resolvedShipment = resolveValue(shipmentIdAsString);
    ShipmentInfo expectedShipmentInfo = new ShipmentInfo();
    Map<String, String> resolvedKeyValues = resolveKeyValues(mapOfData);
    expectedShipmentInfo.fromMap(resolvedKeyValues);
    page.validateShipmentInfo(Long.valueOf(resolvedShipment),
        expectedShipmentInfo);
  }

  @Then("Operator verify the following parameters of all created shipments status is pending")
  public void operatorVerifyTheFollowingParametersOfTheAllCreatedShipmentsStatusIsPending() {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    for (Long shipmentId : shipmentIds) {
      page.validateShipmentStatusPending(shipmentId);
    }
  }

  @When("^Operator click \"([^\"]*)\" action button for the created shipment on Shipment Management page$")
  public void operatorClickActionButtonForTheCreatedShipmentOnShipmentManagementPage(
      String actionId) {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    page.clickActionButton(shipmentInfo.getId(), actionId);
  }

  @And("^Operator open the shipment detail for the created shipment on Shipment Management Page$")
  public void operatorOpenShipmentDetailsPageForCreatedShipmentOnShipmentManagementPage() {
    ShipmentInfo shipmentInfo;

    if (get(KEY_SHIPMENT_INFO) == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    } else {
      shipmentInfo = get(KEY_SHIPMENT_INFO);
    }
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    page.inFrame(() -> page.openShipmentDetailsPage(shipmentInfo.getId()));
  }

  @And("Operator open the shipment detail for the shipment {string} on Shipment Management Page")
  public void operatorOpenShipmentDetailOnShipmentManagementPage(String shipmentIdAsString) {
    Long shipmentId = Long.valueOf(resolveValue(shipmentIdAsString));
    page.openShipmentDetailsPage(shipmentId);
  }


  @And("^Operator force success the created shipment on Shipment Management page$")
  public void operatorForceSuccessTheCreatedShipmentOnShipmentManagementPage() {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    page.forceSuccessShipment(shipmentInfo.getId());
  }

  @And("^Operator cancel the created shipment on Shipment Management page$")
  public void operatorCancelTheCreatedShipmentOnShipmentManagementPage() {
    Long shipmentId;
    if (containsKey(KEY_CREATED_SHIPMENT_ID)) {
      shipmentId = get(KEY_CREATED_SHIPMENT_ID);
    } else {
      ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
      shipmentId = shipmentInfo.getId();
    }
    Long finalShipmentId = shipmentId;
    page.inFrame(() -> page.cancelShipment(finalShipmentId));
  }

  @When("Operator edits and verifies that the cancelled shipment cannot be edited")
  public void operatorEditsAndVerifiesThatTheCancelledShipmentCannotBeEdited() {
    page.inFrame(() -> page.editCancelledShipment());
  }

  @And("Operator edits and verifies that the completed shipment cannot be edited")
  public void operatorEditsAndVerifiesThatTheCompletedShipmentCannotBeEdited() {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    page.editShipmentBy("cancelled", shipmentInfo, null);
    page.verifyUnableToEditCompletedShipmentToastExist();
  }

  @And("^Operator open the Master AWB of the created shipment on Shipment Management Page$")
  public void operatorOpenTheMasterAwbOfTheCreatedShipmentOnShipmentManagementPage() {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    page.openAwb(shipmentInfo.getId());
  }

  @And("^Operator verify the Shipment Details Page opened is for the created shipment$")
  public void operatorVerifyShipmentDetailsPageOpenedIsForTheCreatedShipment() {
    Order order = get(KEY_CREATED_ORDER);
    ShipmentInfo shipmentInfo;

    if (get(KEY_SHIPMENT_INFO) == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    } else {
      shipmentInfo = get(KEY_SHIPMENT_INFO);
    }
    page.verifyOpenedShipmentDetailsPageIsTrue(shipmentInfo.getId(), order.getTrackingId());
    getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
  }

  @Then("^Operator verify shipment event on Shipment Details page using data below:$")
  public void operatorVerifyShipmentEventOnEditOrderPage(Map<String, String> mapOfData) {
    retryIfRuntimeExceptionOccurred(() -> {
      try {
        final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
        ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
        page.switchTo();
        ShipmentEvent actualEvent = new ShipmentEvent(
            page.shipmentEventsTable.readShipmentEventsTable(
                finalMapOfData.get("source")));
        expectedEvent.compareWithActual(actualEvent);
      } catch (Throwable ex) {
        LOGGER.error(ex.getLocalizedMessage(), ex);
        page.refreshPage();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, "retry shipment details", 1000, 3);
  }

  @Then("Operator verifies event is present for updated shipments on Shipment Detail page")
  public void operatorVerifiesEventIsPresentForShipmentsOnShipmentDetailPage(
      Map<String, String> dataTable) {
    List<String> shipmentIds = get(KEY_LIST_SELECTED_SHIPMENT_IDS);
    final Map<String, String> finalMapOfData = resolveKeyValues(dataTable);
    shipmentIds.forEach(sid -> {
      verifyShipmentEventData(Long.valueOf(sid), finalMapOfData);
    });
  }

  @Then("Operator verifies event is present for shipment on Shipment Detail page")
  public void operatorVerifiesEventIsPresentForShipmentOnShipmentDetailPage(
      Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    List<Shipments> lists = get(KEY_LIST_OF_CREATED_SHIPMENT);

    lists.forEach(shipment -> {
      retryIfAssertionErrorOccurred(() -> {
        verifyShipmentEventData(shipment.getShipment().getId(), finalMapOfData);
      }, "retry shipment details event", 5000, 10);
    });
  }

  private void verifyShipmentEventData(Long shipmentId, Map<String, String> finalMapOfData) {
    try {
      ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
      navigateTo(f("%s/%s/shipment-details/%d", TestConstants.OPERATOR_PORTAL_BASE_URL,
          TestConstants.COUNTRY_CODE, shipmentId));
      page.waitUntilPageLoaded();
      List<ShipmentEvent> events = page.shipmentEventsTable.readFirstEntities(1);
      ShipmentEvent actualEvent = events.stream().filter(
              event -> StringUtils.equalsIgnoreCase(event.getSource(), expectedEvent.getSource()))
          .findFirst().orElseThrow(() -> new AssertionError(
              f("There is no [%s] shipment event on Shipment Details page",
                  expectedEvent.getSource())));
      expectedEvent.compareWithActual(actualEvent);
    } catch (Throwable ex) {
      LOGGER.error(ex.getMessage(), ex);
      throw ex;
    }
  }

  @Then("Operator verify cannot parse parameter id as long error toast exist")
  public void operatorVerifyCannotParseParameterIdAsLongErrorToastExist() {
    page.verifyCannotParseParameterIdAsLongToastExist();
  }

  @Then("Operator verifies event is present for shipment id {string} on Shipment Detail page")
  public void operatorVerifiesEventIsPresentForShipmentIdOnShipmentDetailPage(
      String shipmentIdAsString, Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    Long shipmentId = Long.valueOf(resolveValue(shipmentIdAsString));
    retryIfAssertionErrorOccurred(() -> {
      try {
        ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
        navigateTo(f("%s/%s/shipment-details/%d", TestConstants.OPERATOR_PORTAL_BASE_URL,
            TestConstants.COUNTRY_CODE, shipmentId));
        page.waitUntilPageLoaded();
        List<ShipmentEvent> events = page.shipmentEventsTable.readFirstEntities(
            1);
        ShipmentEvent actualEvent = events.stream().filter(
                event -> StringUtils.equalsIgnoreCase(event.getSource(), expectedEvent.getSource()))
            .findFirst().orElseThrow(() -> new AssertionError(
                f("There is no [%s] shipment event on Shipment Details page",
                    expectedEvent.getSource())));
        expectedEvent.compareWithActual(actualEvent);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage(), ex);
        throw ex;
      }
    }, "retry shipment details event", 5000, 10);
  }

  @Then("^Operator open shipment detail and verify shipment event on Shipment Details page using data below:$")
  public void operatorOpenShipmentDetailAndVerifyShipmentEventOnEditOrderPage(
      Map<String, String> mapOfData) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        ShipmentInfo shipmentInfo;

        if (get(KEY_SHIPMENT_INFO) == null) {
          Shipments shipments = get(KEY_CREATED_SHIPMENT);
          shipmentInfo = new ShipmentInfo(shipments);
        } else {
          shipmentInfo = get(KEY_SHIPMENT_INFO);
        }
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
        page.openShipmentDetailsPage(shipmentInfo.getId());

        final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
        ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
        page.switchTo();
        ShipmentEvent actualEvent = new ShipmentEvent(
            page.shipmentEventsTable.readShipmentEventsTable(
                finalMapOfData.get("source")));
        expectedEvent.compareWithActual(actualEvent);
      } catch (Throwable ex) {
        LOGGER.error(ex.getLocalizedMessage(), ex);
        page.refreshPage();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, "retry shipment details", 5000, 10);
  }

  @Then("Operator verify movement event on Shipment Details page using data below:")
  public void operatorVerifyMovementEventOnEditOrderPage(Map<String, String> mapOfData) {
    retryIfRuntimeExceptionOccurred(() -> {
      final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
      MovementEvent expectedEvent = new MovementEvent(finalMapOfData);
      try {
        page.switchTo();
        MovementEvent actualEvent = new MovementEvent(
            page.movementEventsTable.readMovementEventsTable(
                finalMapOfData.get("source")));
        expectedEvent.compareWithActual(actualEvent);
      } catch (Throwable ex) {
        LOGGER.error(ex.getLocalizedMessage(), ex);
        page.refreshPage();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, "retry shipment details", 1000, 3);
  }

  @And("^Operator verify the the master AWB is opened$")
  public void operatorVerifyTheOpenedMasterAwbIsConsistedOfTheRightData() {
    page.verifyMasterAwbIsOpened();
  }

  @And("^Operator save current filters as preset on Shipment Management page$")
  public void operatorSaveCurrentFiltersAsPresetWithNameOnShipmentManagementPage() {
    String presetName = "Test" + TestUtils.generateDateUniqueString();
    long presetId = page.saveFiltersAsPreset(presetName);
    put(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID, presetId);
    put(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME, presetName);
  }

  @And("^Operator select created filters preset on Shipment Management page$")
  public void operatorSelectCreatedFiltersPresetOnShipmentManagementPage() {
    String presetName = get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID) + " - " + get(
        KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME);
    operatorSelectGivenFiltersPresetOnShipmentManagementPage(presetName);
  }

  @And("^Operator select \"(.+)\" filters preset on Shipment Management page$")
  public void operatorSelectGivenFiltersPresetOnShipmentManagementPage(String filterPresetName) {
    filterPresetName = resolveValue(filterPresetName);
    page.filterPresetSelector.searchAndSelectValue(filterPresetName);
  }

  @And("^Operator verify parameters of selected filters preset on Shipment Management page$")
  public void operatorVerifyParametersOfSelectedFiltersPresetOnShipmentManagementPage() {
    Map<String, String> filters = get(KEY_SHIPMENT_MANAGEMENT_FILTERS);
    page.verifySelectedFilters(filters);
  }

  @And("^Operator delete created filters preset on Shipment Management page$")
  public void operatorDeleteCreatedFiltersPresetOnShipmentManagementPage() {
    String presetName = get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID) + " - " + get(
        KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME);
    page.deleteFiltersPreset(presetName);
  }

  @Then("^Operator verify filters preset was deleted$")
  public void operatorVerifyFiltersPresetWasDeleted() {
    String presetName = get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID) + " - " + get(
        KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME);
    page.verifyFiltersPresetWasDeleted(presetName);
    remove(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID);
  }

  @And("^Operator verify that the data consist is correct$")
  public void operatorDownloadAndVerifyThatTheDataConsistsIsCorrect() {
    byte[] shipmentAirwayBill = get(KEY_SHIPMENT_AWB);
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    page.downloadPdfAndVerifyTheDataIsCorrect(shipmentInfo, shipmentAirwayBill);
  }

  @Given("Operator intends to create a new Shipment directly from the Shipment Toast")
  public void operatorIntendsToCreateANewShipmentDirectlyFromTheShipmentToast() {
    boolean isNextOrder = true;
    put("isNextOrder", isNextOrder);
  }

  @When("Operator click Force Success Button")
  public void operatorClickForceSuccessButton() {
    page.forceSuccessShipment();
  }

  @And("^Operator create CSV \"([^\"]*)\" file which has multiple valid Tracking ID in it and upload the CSV$")
  public void createAndUploadCsvMultipleTrackingId(String fileName) throws FileNotFoundException {
    List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    if (shipmentInfo == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    }
    int numberOfOrder = orders.size();
    ShipmentInfo finalShipmentInfo = shipmentInfo;
    page.inFrame(() -> {
      try {
        page.createAndUploadCsv(orders, fileName, numberOfOrder, finalShipmentInfo);
      } catch (FileNotFoundException e) {
        throw new RuntimeException(e);
      }
    });
  }

  @And("^Operator create CSV \"([^\"]*)\" file which has duplicated Tracking ID in it and upload the CSV$")
  public void createAndUploadCsvDuplicatedTrackingId(String fileName) throws FileNotFoundException {
    List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    if (shipmentInfo == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    }
    int numberOfOrder = orders.size();
    ShipmentInfo finalShipmentInfo = shipmentInfo;
    page.inFrame(() -> {
      try {
        page.createAndUploadCsv(orders, fileName, true, true, numberOfOrder,
            finalShipmentInfo);
      } catch (FileNotFoundException e) {
        throw new RuntimeException(e);
      }
    });
  }

  @And("^Operator create CSV \"([^\"]*)\" file which has invalid Tracking ID in it and upload the CSV$")
  public void createAndUploadCsvInvalidTrackingId(String fileName) throws FileNotFoundException {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    if (shipmentInfo == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    }
    ShipmentInfo finalShipmentInfo = shipmentInfo;
    page.inFrame(() -> {
      try {
        page.createAndUploadCsv(fileName, finalShipmentInfo);
      } catch (FileNotFoundException e) {
        throw new RuntimeException(e);
      }
    });
  }

  @When("Operator clicks on reopen shipment button under the Apply Action")
  public void operatorClicksOnReopenShipmentButtonUnderTheApplyAction() {
    page.inFrame(() -> {
      page.shipmentsTable.selectRow(1);
      page.actionsMenu.selectOption("Reopen Shipments");
    });
  }

  @When("Operator clicks on reopen shipment button under the Apply Action for multiple shipments")
  public void operatorClicksOnReopenShipmentButtonUnderTheApplyActionForMultipleShipments() {
    page.inFrame(() -> {
      page.tableActionsMenu.selectOption("Select All Shown");
      page.actionsMenu.selectOption("Reopen Shipments");
    });
  }

  @Then("Operator verifies that the Reopen Shipment Button is disabled")
  public void operatorVerifiesThatTheReopenShipmentButtonIsDisabled() {
    page.inFrame(() ->
        Assertions.assertThat(
                page.actionsMenu.getItemElement("Reopen Shipments").getAttribute("class"))
            .withFailMessage("Reopen Shipments option is enabled")
            .contains("ant-dropdown-menu-item-disabled")
    );
  }

  @When("Operator searches multiple shipment ids in the Shipment Management Page")
  public void operatorSearchesMultipleShipmentIdsInTheShipmentManagementPage() {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    page.bulkSearchShipmentIds(shipmentIds);
  }

  @When("Operator searches multiple shipment ids in the Shipment Management Page with {string}")
  public void operatorSearchesMultipleShipmentIdsInTheShipmentManagementPageWith(String condition) {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    if ("duplicated".equalsIgnoreCase(condition)) {
      page.bulkSearchShipmentIds(shipmentIds, true);
    } else {
      page.bulkSearchShipmentIdsWithCondition(shipmentIds, condition);
    }
  }

  @Then("Operator verifies that more than 30 warning toast shown")
  public void operatorVerifiesThatMoreThanWarningToastShown() {
    page.moreThan30WarningToastShown();
  }

  @Then("Operator verifies that there is a search error modal shown with {string}")
  public void operatorVerifiesThatThereIsASearchErrorModalShownWith(String mode) {
    if ("valid shipment".equalsIgnoreCase(mode)) {
      page.verifiesSearchErrorModalIsShown(true);
    } else if ("none".equalsIgnoreCase(mode)) {
      page.verifiesSearchErrorModalIsShown(false);
    } else {
      LOGGER.warn("Mode {} is not existed!", mode);
    }
  }

  @Then("Operator verifies the searched shipment ids result is right")
  public void operatorVerifiesTheSearchedShipmentIdsResultIsRight() {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    for (int i = 0; i < shipmentIds.size(); i++) {
      page.searchedShipmentVerification(shipmentIds.get(i));
    }
  }

  @Then("Operator verifies the searched shipment ids result is right except last")
  public void operatorVerifiesTheSearchedShipmentIdsResultIsRightExceptLast() {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    for (int i = 0; i < shipmentIds.size() - 1; i++) {
      page.searchedShipmentVerification(shipmentIds.get(i));
    }
  }

  @Then("Operator verify {string} action button is disabled on shipment Management page")
  public void operatorVerifyActionButtonIsDisabled(String actionButton) {
    page.inFrame(() -> {
      if ("Cancel".equals(actionButton)) {
        Assertions.assertThat(page.shipmentsTable.getActionButton(1, ACTION_CANCEL).isEnabled())
            .as("Cancel button is enabled")
            .isFalse();
      }
    });
  }

  @Then("Operator verify empty line parsing error toast exist")
  public void operatorVerifyEmptyLineParsingErrorToastExist() {
    page.verifyEmptyLineParsingErrorToastExist();
  }

  @Then("Operator selects all shipments and click bulk update button under the apply action")
  public void operatorSelectsAllShipmentsAndClickBulkUpdateButtonUnderTheApplyAction() {
    page.inFrame(() -> {
      page.tableActionsMenu.selectOption("Select All Shown");
      page.actionsMenu.selectOption("Bulk Update");
    });
  }

  @Then("Operator selects shipments and click bulk update button:")
  public void selectAndBulkUpdate(List<String> shipmentIds) {
    List<String> ids = resolveValues(shipmentIds);
    page.inFrame(() -> {
      ids.forEach(id -> {
        page.shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, id);
        page.shipmentsTable.selectRow(1);
      });
      page.actionsMenu.selectOption("Bulk Update");
    });
  }

  @When("Operator bulk update shipment with data below:")
  public void operatorBulkUpdateShipmentWithDataBelow(Map<String, String> mapOfData) {
    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);

    page.inFrame(() -> {
      page.bulkUpdateShipment(resolvedMapOfData, shipmentIds);
      page.verifyShipmentToBeUpdatedData(shipmentIds, resolvedMapOfData);
      page.confirmUpdateBulk(resolvedMapOfData);
    });
  }

  @When("Operator bulk MAWB update shipment with data below:")
  public void operatorBulkMawbUpdateShipmentWithDataBelow(Map<String, String> mapOfData) {
    page.bulkMawbUpdateShipment(resolveKeyValues(mapOfData),
        get(KEY_LIST_OF_CREATED_SHIPMENT_ID));
  }

  @Then("Operator verify the following parameters of shipment with id {string} on Shipment Management page:")
  public void operatorVerifyTheFollowingParametersOfTheCreatedShipmentOnShipmentManagementPage(
      String shipmentIdAsString, Map<String, String> mapOfData) {
    String resolvedShipmentId = resolveValue(shipmentIdAsString);
    Long shipmentId = Long.valueOf(resolvedShipmentId);
    Map<String, String> resolvedKeyValues = resolveKeyValues(mapOfData);
    page.inFrame(() -> page.validateShipmentUpdated(shipmentId, resolvedKeyValues));
  }

  @Then("Operator verify the following parameters of all created shipments on Shipment Management page:")
  public void operatorVerifyTheFollowingParametersOfAllTheCreatedShipmentOnShipmentManagementPage(
      Map<String, String> mapOfData) {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    for (Long shipmentId : shipmentIds) {
      page.inFrame(() ->
          operatorVerifyTheFollowingParametersOfTheCreatedShipmentOnShipmentManagementPage(
              String.valueOf(shipmentId), mapOfData)
      );
    }
  }

  @Then("Operator verify it highlight selected shipment and it can select another shipment")
  public void operatorVerifyItHighlightSelectedShipmentAndItCanSelectAnotherShipment() {
    page.inFrame(() -> page.selectAnotherShipmentAndVerifyCount());
  }

  @And("Operator open the shipment detail for the first shipment on Shipment Management Page")
  public void operatorOpenTheShipmentDetailForTheFirstShipmentOnShipmentManagementPage() {
    Map<String, String> data = page.shipmentsTable.readRow(0);
    String shipmentId = data.get("id");

    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    page.openShipmentDetailsPage(Long.valueOf(shipmentId));
  }

  @Then("Operator verify error message exist")
  public void operatorVerifyErrorMessageExist() {
    page.inFrame(() -> page.checkErrorMessageShipmentCreation());

  }

  @And("Operator verify {string} is disable")
  public void operatorVerifyCreateButtonIsDisable(String disabledButton) {
    Button button;
    switch (disabledButton.toLowerCase()) {
      case "create button":
        button = page.createShipmentDialog.create;
        break;
      case "create another button":
        button = page.createShipmentDialog.createAnother;
        break;
      default:
        throw new IllegalStateException("Unknown button name " + disabledButton);
    }
    page.inFrame(() -> Assertions.assertThat(button.isEnabled())
        .withFailMessage(disabledButton + " is enabled")
        .isFalse()
    );
  }
}
