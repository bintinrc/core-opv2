package co.nvqa.operator_v2.model;

import java.util.ArrayList;
import java.util.List;

public class ListOrderCreationV2Template {

    List<OrderCreationV2Template> orderCreationV2TemplatesList = new ArrayList<>();

    public List<OrderCreationV2Template> getOrderCreationV2TemplatesList() {
        return orderCreationV2TemplatesList;
    }

    public void setOrderCreationV2TemplatesList(List<OrderCreationV2Template> orderCreationV2TemplatesList) {
        this.orderCreationV2TemplatesList = orderCreationV2TemplatesList;
    }

    public int size()
    {
        return orderCreationV2TemplatesList.size();
    }
}
