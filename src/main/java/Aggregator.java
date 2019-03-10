public class Aggregator {

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

        int abs = Math.abs(highestHigh - lowestLow);

        System.out.println(abs);
        return abs;
    }
}
