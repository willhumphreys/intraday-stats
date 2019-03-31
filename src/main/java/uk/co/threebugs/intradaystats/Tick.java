package uk.co.threebugs.intradaystats;

import java.time.LocalDateTime;

public class Tick {
    private final LocalDateTime dateTime;
    private final int high;
    private final int low;

    public Tick(LocalDateTime dateTime, int high, int low) {

        this.dateTime = dateTime;
        this.high = high;
        this.low = low;
    }

    public LocalDateTime getDateTime() {
        return dateTime;
    }

    public int getHigh() {
        return high;
    }

    public int getLow() {
        return low;
    }

    public int getRange() {
        return Math.abs(high - low);
    }

    @Override
    public String toString() {
        return "Tick{" +
                "dateTime=" + dateTime +
                ", high=" + high +
                ", low=" + low +
                '}';
    }
}
