package co.nvqa.operator_v2.model;

import java.util.ArrayList;
import java.util.List;

public class MovementSchedule extends DataEntity<MovementSchedule>
{
    private String originHub;
    private String destinationHub;
    private boolean applyToAllDays;
    private List<Schedule> schedules;

    public String getOriginHub()
    {
        return originHub;
    }

    public void setOriginHub(String originHub)
    {
        this.originHub = originHub;
    }

    public String getDestinationHub()
    {
        return destinationHub;
    }

    public void setDestinationHub(String destinationHub)
    {
        this.destinationHub = destinationHub;
    }

    public boolean isApplyToAllDays()
    {
        return applyToAllDays;
    }

    public void setApplyToAllDays(boolean applyToAllDays)
    {
        this.applyToAllDays = applyToAllDays;
    }

    public void setApplyToAllDays(String applyToAllDays)
    {
        setApplyToAllDays(Boolean.parseBoolean(applyToAllDays));
    }

    public List<Schedule> getSchedules()
    {
        return schedules;
    }

    public void setSchedules(List<Schedule> schedules)
    {
        this.schedules = schedules;
    }

    public void addSchedule(Schedule schedule)
    {
        if (schedules == null)
        {
            schedules = new ArrayList<>();
        }
        schedules.add(schedule);
    }

    public Schedule getSchedule(int index)
    {
        if (schedules == null || index >= schedules.size())
        {
            return null;
        } else
        {
            return getSchedules().get(index);
        }
    }

    public static class Schedule extends DataEntity<Schedule>
    {
        private String day;

        private List<Movement> movements;

        public String getDay()
        {
            return day;
        }

        public void setDay(String day)
        {
            this.day = day;
        }

        public List<Movement> getMovements()
        {
            return movements;
        }

        public void setMovements(List<Movement> movements)
        {
            this.movements = movements;
        }

        public void addMovement(Movement movement)
        {
            if (movements == null)
            {
                movements = new ArrayList<>();
            }
            movements.add(movement);
        }

        public Movement getMovement(int index)
        {
            if (movements == null || index >= movements.size())
            {
                return null;
            } else
            {
                return getMovements().get(index);
            }
        }

        public static class Movement extends DataEntity<Movement>
        {
            private String startTime;
            private Integer duration;
            private String endTime;

            public String getStartTime()
            {
                return startTime;
            }

            public void setStartTime(String startTime)
            {
                this.startTime = startTime;
            }

            public Integer getDuration()
            {
                return duration;
            }

            public void setDuration(Integer duration)
            {
                this.duration = duration;
            }

            public void setDuration(String duration)
            {
                setDuration(Integer.valueOf(duration));
            }

            public String getEndTime()
            {
                return endTime;
            }

            public void setEndTime(String endTime)
            {
                this.endTime = endTime;
            }
        }
    }
}
