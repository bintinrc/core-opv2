package co.nvqa.operator_v2.model;

/**
 * @author Tristania Siagian
 */
public class ChangeDeliveryTimings {

    private String tracking_id;
    private String start_date;
    private String end_date;
    private Integer timewindow;

    public ChangeDeliveryTimings(String tracking_id, String start_date, String end_date, Integer timewindow) {
        this.tracking_id = tracking_id;
        this.start_date = start_date;
        this.end_date = end_date;
        this.timewindow = timewindow;
    }

    public String getTracking_id() {
        return tracking_id;
    }

    public void setTracking_id(String tracking_id) {
        this.tracking_id = tracking_id;
    }

    public String getStart_date() {
        return start_date;
    }

    public void setStart_date(String start_date) {
        this.start_date = start_date;
    }

    public String getEnd_date() {
        return end_date;
    }

    public void setEnd_date(String end_date) {
        this.end_date = end_date;
    }

    public Integer getTimewindow() {
        return timewindow;
    }

    public void setTimewindow(Integer timewindow) {
        this.timewindow = timewindow;
    }
}
