import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.IntSummaryStatistics;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static java.nio.file.StandardOpenOption.*;

@Command(description = "Calculates some intraday stats",
        name = "intraday-stats", mixinStandardHelpOptions = true, version = "0.1")
public class Runner implements Callable<Void> {


    private static final Logger logger = LogManager.getLogger(Runner.class);

    @Option(names = {"-s", "--symbol"}, description = "EURUSD, AUDUSD ...")
    private String symbol;

    @Option(names = {"-o", "--hour"}, description = "From 0 to 23")
    private int hour;

    @Option(names = {"-d", "--day"}, description = "From 1 (Monday) to 7 (Sunday)")
    private int day;


    private int previous = 1000;

    private Aggregator aggregator;

    private List<Integer> completedAggregators;

    public static void main(String[] args) {
        CommandLine.call(new Runner(), args);
    }

    @Override
    public Void call() throws Exception {

        TickMapper tickMapper = new TickMapper();

        logger.info(String.format("Executing intraday stats with symbol: %s day: %d hour: %d", symbol, day, hour));

        completedAggregators = new ArrayList<>();


        try (Stream<String> stream = Files.lines(Paths.get("data/" +
                symbol))) {

            stream.skip(1).map(tickMapper::map).filter(tick -> {
                LocalDateTime currentTime = tick.getDateTime();
                return currentTime.getDayOfWeek().equals(DayOfWeek.of(day)) && currentTime.getHour() == hour;

            }).forEach(tick -> {

                int currentValue = tick.getDateTime().getMinute();

                if (currentValue < this.previous) {

                    if (this.aggregator != null) {
                        completedAggregators.add(this.aggregator.close());
                    }

                    this.aggregator = new Aggregator(tick);


                } else {

                    this.aggregator.add(tick);


                }

                previous = currentValue;


            });


        } catch (IOException e) {
            e.printStackTrace();
        }


        IntSummaryStatistics collect = completedAggregators.stream().collect(Collectors.summarizingInt(Integer::intValue));

        System.out.println(collect);

        Map<Integer, Long> frequencies = completedAggregators.stream().
                collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));


        Stream<String> stringStream = frequencies.entrySet().stream().map((s) -> s.getKey() + "," + s.getValue());
        Files.write(Paths.get(symbol),
                (Iterable<String>) Stream.concat(Stream.of("range,frequency"), stringStream)::iterator,
                CREATE, WRITE, TRUNCATE_EXISTING);

        System.out.println(frequencies);

        return null;
    }
}
