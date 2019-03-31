package uk.co.threebugs.intradaystats;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import static java.lang.Integer.parseInt;

public class TickMapper {

    //2001-01-02T23:01
    public static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    public Tick map(String line) {
        String[] lineParts = line.split(",");


        LocalDateTime dateTime = LocalDateTime.parse(lineParts[0], FORMATTER);


        return new Tick(dateTime, parseInt(lineParts[3]), parseInt(lineParts[4]));


    }
}
