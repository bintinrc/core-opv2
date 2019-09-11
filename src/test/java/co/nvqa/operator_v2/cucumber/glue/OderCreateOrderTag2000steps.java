package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.StandardApiShipperSteps;
import co.nvqa.commons.client.ParcelTagClient;
import cucumber.api.java.en.And;
import cucumber.runtime.java.guice.ScenarioScoped;

@ScenarioScoped
public class OderCreateOrderTag2000steps extends AbstractSteps {


    @Override
    public void init() {

    }

    StandardApiShipperSteps standardApiShipperSteps=new StandardApiShipperSteps();
    private ParcelTagClient parcelTagClient= new ParcelTagClient();
    private Long orderId;
    private String trackingId ;

    @And("^API Operator tags parcel to Urgent$")
    public void aPIoperatorTagsParcelToUrgent() {
        orderId= get(KEY_CREATED_ORDER_ID);
        trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        System.out.println(orderId+"******************");
        System.out.println(trackingId+"******************");
        parcelTagClient.orderTag(orderId);
    }
//
//    @Given("^API Shipper create V4 orders using data below and then tags each parcel to urgent:$")
//    public void apiShipperCreateOrderV4UsingDataBelow(Map<String,String> dataTableAsMap)
//
//    {
//        for(int i=0;i<2;i++){
//            standardApiShipperSteps.apiShipperCreateV4Order(dataTableAsMap);
//            orderId= get(KEY_CREATED_ORDER_ID);
//            trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
//            System.out.println(orderId+"******************");
//            System.out.println(trackingId+"******************");
//            parcelTagClient.orderTag(orderId);
        }

//    }


//}
