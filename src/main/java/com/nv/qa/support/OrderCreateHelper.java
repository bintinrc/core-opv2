package com.nv.qa.support;

import com.nv.qa.api.client.order_create.OrderCreateAuthenticationClient;
import com.nv.qa.api.client.order_create.OrderCreateV1Client;
import com.nv.qa.api.client.order_create.OrderCreateV2Client;
import com.nv.qa.api.client.order_create.OrderCreateV3Client;
import com.nv.qa.model.order_creation.authentication.AuthRequest;
import com.nv.qa.model.order_creation.authentication.AuthResponse;
import org.apache.commons.lang3.RandomStringUtils;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;

/**
 * utility to
 * Created by ferdinand on 4/5/16.
 */
public class OrderCreateHelper {
    static final SimpleDateFormat SDF_UNIQUE = new SimpleDateFormat("HHmmssSSS");
    static final SimpleDateFormat SDF_ORDER_REQUEST = new SimpleDateFormat("yyyy-MM-dd");

    private static String CREATE_ORDER_ACCESS_TOKEN = null; //-- refer to qa-shaun@ninjavan.sg (235)

    //-- these two will be replaced by newer Tracking ID on run
    public static String EXISTING_V2_TRACKING_ID = "SHAUN123456789"; //-- e.g.: SHAUN 123456789 A (post pended with A)
    public static String EXISTING_V3_TRACKING_ID = "NVSGSHAUN123456788"; //-- e.g.: NV SG SHAUN 123456789


    /**
     * Get next valid working days (Mon-Sat).
     *
     * @param dateString
     * @return
     */
    public static String getDateString(String dateString) {
        if (dateString == null) {
            return dateString;
        }
        Calendar cal = Calendar.getInstance();
        switch (dateString) {
            case "TOMORROW":
            case "NEXT_1_DAYS":
                cal.add(Calendar.DATE, 1);
                break;
            case "NEXT_2_DAYS":
                cal.add(Calendar.DATE, 2);
                break;
            case "NEXT_3_DAYS":
                cal.add(Calendar.DATE, 3);
                break;
            case "TODAY":
                //-- no need to add zero days.
                break;
            default:
                return dateString;

        }

        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
        if (dayOfWeek == Calendar.SUNDAY) {
            cal.add(Calendar.DATE, 1); //-- move to next available day
        }

        return SDF_ORDER_REQUEST.format(cal.getTime());
    }

    public static String getShipperRef(String word) {
        if (word == null) {
            return word;
        }
        switch (word) {
            case "NEW_UNIQUE":
                try {
                    Thread.sleep(2); //-- prevent same ref being generated.
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                return SDF_UNIQUE.format(new Date());
            default:
                return word;

        }
    }

    public static String getRequestedTrackingId(String word) {
        if (word == null) {
            return word;
        }
        String ts = String.valueOf((new Date()).getTime());
        switch (word) {
            case "NEW_6":
                return ts.substring(ts.length() - 6);
            case "NEW_10":
                return ts.substring(ts.length() - 10);
            default:
                return word;
        }
    }

    public static String getStringRequestedTrackingId(String word) {
        if (word == null) {
            return word;
        }
        if (word.startsWith("RANDOM")) {
            int dashPosition = word.indexOf('_');
            int length = 0;
            if (dashPosition > -1) {
                length = Integer.valueOf(word.substring(dashPosition + 1));
            } else {
                length = new Random().nextInt();
            }
            return RandomStringUtils.randomAlphanumeric(length);
        } else if (word.startsWith("EXISTING_V2_TRACKING_ID")) {
            return EXISTING_V2_TRACKING_ID;
        } else if (word.startsWith("EXISTING_V3_TRACKING_ID")) {
            //-- requested tracking id for V3 is only the last 9 digit.
            return EXISTING_V3_TRACKING_ID.substring(9);
        } else {
            return word;
        }
    }

    public static void populateRequest(com.nv.qa.model.order_creation.v1.CreateOrderRequest req) {
        req.setPickup_date(getDateString(req.getPickup_date()));
        req.setDelivery_date(getDateString(req.getDelivery_date()));
        req.setShipper_order_ref_no(getShipperRef(req.getShipper_order_ref_no()));
    }

    public static void populateRequest(com.nv.qa.model.order_creation.v2.CreateOrderRequest req) {
        req.setPickup_date(getDateString(req.getPickup_date()));
        req.setDelivery_date(getDateString(req.getDelivery_date()));
        req.setShipper_order_ref_no(getShipperRef(req.getShipper_order_ref_no()));
        req.setTracking_ref_no(getStringRequestedTrackingId(req.getTracking_ref_no()));
    }

    public static void populateRequest(com.nv.qa.model.order_creation.v3.CreateOrderRequest req) {
        req.setPickupDate(getDateString(req.getPickupDate()));
        req.setDeliveryDate(getDateString(req.getDeliveryDate()));
        req.setOrderRefNo(getShipperRef(req.getOrderRefNo()));
        req.setRequestedTrackingId(getRequestedTrackingId(req.getRequestedTrackingId()));
    }

    //-- Client stuff

    public static OrderCreateAuthenticationClient getAuthenticationClient() {
        return new OrderCreateAuthenticationClient(
                APIEndpoint.API_BASE_URL,
                APIEndpoint.ORDER_CREATE_BASE_URL
        );
    }

    public static OrderCreateV1Client getVersion1Client(String accessToken) {
        return new OrderCreateV1Client(
                APIEndpoint.API_BASE_URL,
                APIEndpoint.ORDER_CREATE_BASE_URL,
                accessToken
        );
    }

    public static OrderCreateV1Client getVersion1Client() throws IOException {
        return getVersion1Client(getOrderCreateAccessToken());
    }

    public static OrderCreateV2Client getVersion2Client(String accessToken) {
        return new OrderCreateV2Client(
                APIEndpoint.API_BASE_URL,
                APIEndpoint.ORDER_CREATE_BASE_URL,
                accessToken
        );
    }

    public static OrderCreateV2Client getVersion2Client() throws IOException {
        return getVersion2Client(getOrderCreateAccessToken());
    }

    public static OrderCreateV3Client getVersion3Client(String accessToken) {
        return new OrderCreateV3Client(
                APIEndpoint.API_BASE_URL,
                APIEndpoint.ORDER_CREATE_BASE_URL,
                accessToken
        );
    }

    public static OrderCreateV3Client getVersion3Client() throws IOException {
        return getVersion3Client(getOrderCreateAccessToken());
    }


    /**
     * Shipper's authentication token. Used to access orders, etc.
     *
     * @return
     */
    public static String getOrderCreateAccessToken() throws IOException {
        if (CREATE_ORDER_ACCESS_TOKEN == null) {
            AuthRequest loginRequest = new AuthRequest(
                    APIEndpoint.SHIPPER_CLIENT_ID,
                    APIEndpoint.SHIPPER_CLIENT_SECRET
            );
            OrderCreateAuthenticationClient client = getAuthenticationClient();
            AuthResponse resp = client.login(loginRequest);
            CREATE_ORDER_ACCESS_TOKEN = resp.getAccess_token();

            /**
             * I deleted this line below because it called deprecated method
             * that does not have any implementation (all code in this method is commented).
             */
            //client.refreshShipperAccountCache(APIEndpoint.SHIPPER_ID);
        }
        return CREATE_ORDER_ACCESS_TOKEN;
    }
}
