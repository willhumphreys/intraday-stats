package uk.co.threebugs.intradaystats;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Aggregator {

    private static final Logger logger = LogManager.getLogger(Aggregator.class);

    private int lowestLow = 1000000;

    private int highestHigh;

    public Aggregator(Tick line) {
        processLine(line);
    }

    private void processLine(Tick tick) {

        if (tick.getHigh() > highestHigh) {
            highestHigh = tick.getHigh();
        }

        if (tick.getLow() < lowestLow) {
            lowestLow = tick.getLow();
        }
    }

    public void add(Tick line) {
        processLine(line);
    }

    public int close() {

        int absoluteRange = Math.abs(highestHigh - lowestLow);

        logger.info(absoluteRange);
        return absoluteRange;
    }
}
