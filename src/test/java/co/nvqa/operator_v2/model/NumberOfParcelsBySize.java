package co.nvqa.operator_v2.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class NumberOfParcelsBySize {

    @JsonProperty("Small")
    private int small;

    @JsonProperty("Medium")
    private int medium;

    @JsonProperty("Large")
    private int large;

    @JsonProperty("X-Large")
    private int xLarge;

    @JsonProperty("XX-Large")
    private int xxLarge;

    public int getSmall() {return small;}

    public int getMedium() {
        return medium;
    }

    public int getLarge() {
        return large;
    }

    public int getXLarge() {
        return xLarge;
    }

    public int getXXLarge() {
        return xxLarge;
    }

    public void setSmall(int small) {
        this.small = small;
    }

    public void setMedium(int medium) {
        this.medium = medium;
    }

    public void setLarge(int large) {
        this.large = large;
    }

    public void setXLarge(int xLarge) {
        this.xLarge = xLarge;
    }

    public void setXXLarge(int xxLarge) {
        this.xxLarge = xxLarge;
    }

}
