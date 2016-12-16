package com.nv.qa.model;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by lanangjati
 * on 10/25/16.
 */
public class Linehaul {

    private WebElement element;
    private String name;
    private String comment;
    private String frequency;
    private String id;
    private List<String> hubs = new ArrayList<>();
    private List<String> days = new ArrayList<>();

    public Linehaul() {
    }

    public Linehaul(WebElement element) {
        this.element = element;
        List<WebElement> column = element.findElements(By.tagName("td"));
        id = column.get(2).getText().trim();
        name = column.get(3).getText();
        String hubs = (column.get(4).getText() + "," + column.get(5).getText() + "," + column.get(6).getText()).replaceAll("\\s+", "");
        if (hubs.contains(",-")) {
            hubs = hubs.replace(",-", "");
        }
        String[] arrLegs = hubs.split(",");
        Collections.addAll(this.hubs, arrLegs);
        frequency = column.get(7).getText();
        arrLegs = column.get(8).getText().split(",");
        Collections.addAll(this.days, arrLegs);
        comment = column.get(11).getText();
    }

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

    public void clickEditButton() {
        element.findElement(By.tagName("button")).click();
        CommonUtil.pause1s();
    }


}
