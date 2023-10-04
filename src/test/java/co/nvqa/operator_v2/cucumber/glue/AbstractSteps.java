package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.model.address.Address;
import co.nvqa.common.shipper.model.Shipper;
import co.nvqa.common.ui.cucumber.glue.selenium.CommonSeleniumAbstractSteps;
import co.nvqa.operator_v2.cucumber.ScenarioStorageKeys;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public abstract class AbstractSteps extends CommonSeleniumAbstractSteps<ScenarioManager> implements
    ScenarioStorageKeys {

  public AbstractSteps() {
  }

  public List<Order> getListOfCreatedOrders() {
    List<Order> orders = getList(KEY_LIST_OF_CREATED_ORDERS, Order.class);

    if (orders == null || orders.isEmpty()) {
      orders = new ArrayList<>();
      Object obj = get(KEY_CREATED_ORDER);
      if (obj instanceof Order) {
        orders.add((Order) obj);
      }
    }

    return orders;
  }

  public Shipper getShipperOfCreatedOrder() {
    return this.get(KEY_SHIPPER_OF_CREATED_ORDER);
  }

  public Address getToAddress(Order order) {
    Address address = new Address();
    address.setName(order.getToName());
    address.setEmail(order.getToEmail());
    address.setContact(order.getToContact());
    address.setAddress1(order.getToAddress1());
    address.setAddress2(order.getToAddress2());
    address.setPostcode(order.getToPostcode());
    address.setCity(order.getToCity());
    address.setCountry(order.getToCountry());
    address.setState(order.getToState());
    address.setDistrict(order.getToDistrict());
    address.setLatitude(order.getToLatitude());
    address.setLongitude(order.getToLongitude());
    return address;
  }

}
