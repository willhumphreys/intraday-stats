import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.IntSummaryStatistics;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static java.nio.file.StandardOpenOption.*;

public class Runner {


    private final TickMapper tickMapper;
    private int previous = 1000;

    private Aggregator aggregator;

    private List<Integer> completedAggregators;

    public Runner(String symbol) throws IOException {


        this.tickMapper = new TickMapper();

        completedAggregators = new ArrayList<>();


        try (Stream<String> stream = Files.lines(Paths.get("data/" +
                symbol))) {

            stream.skip(1).map(this.tickMapper::map).filter(tick -> {
                LocalDateTime currentTime = tick.getDateTime();
                return currentTime.getDayOfWeek().equals(DayOfWeek.TUESDAY) && currentTime.getHour() == 20;

            }).forEach(tick -> {


                int currentValue = tick.getDateTime().getMinute();
                //System.out.println(tick.getDateTime() + " " + currentValue % 15);

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


    }

    public static void main(String[] args) throws IOException {


        new Runner("EURUSD.csv");


    }

}
