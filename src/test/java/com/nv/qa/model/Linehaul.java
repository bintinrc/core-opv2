package com.nv.qa.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by lanangjati
 * on 10/25/16.
 */
public class Linehaul {
    private String name;
    private String comment;
    private String frequency;
    private String id;
    private List<String> hubs = new ArrayList<>();
    private List<String> days = new ArrayList<>();

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public List<String> getHubs() {
        return hubs;
    }

    public void setHubs(String hubs) {
        String[] arrLegs = hubs.split(",");
        Collections.addAll(this.hubs, arrLegs);
    }

    public List<String> getDays() {
        return days;
    }

    public void setDays(String days) {
        String[] arrLegs = days.split(",");
        Collections.addAll(this.days, arrLegs);
    }


}
