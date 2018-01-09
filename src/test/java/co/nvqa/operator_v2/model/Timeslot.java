package co.nvqa.operator_v2.model;

/**
 * @author Tristania Siagian
 */
public class Timeslot {

    private Integer timewindowId;

    public Timeslot(Integer timewindowId) {
        this.timewindowId = timewindowId;
    }

    public String getStartTime() {
        switch (this.timewindowId) {
            case -3:
                return "18:00:00";
            case -2:
                return "09:00:00";
            case -1:
                return "09:00:00";
            case 0:
                return "09:00:00";
            case 1:
                return "12:00:00";
            case 2:
                return "15:00:00";
            case 3:
                return "18:00:00";
            default:
                return "09:00:00";
        }
    }

    public String getEndTime() {
        switch (this.timewindowId) {
            case -3:
                return "22:00:00";
            case -2:
                return "18:00:00";
            case -1:
                return "22:00:00";
            case 0:
                return "12:00:00";
            case 1:
                return "15:00:00";
            case 2:
                return "18:00:00";
            case 3:
                return "22:00:00";
            default:
                return "09:00:00";
        }
    }

}
