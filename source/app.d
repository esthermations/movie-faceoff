import std.stdio;
import elo.rating;

struct Movie {
    string title = "[No title. This is an error.]";
    int    elo   = 1000;
}

Movie[] all_movies;

void faceoff(ref Movie a, ref Movie b) {
    writefln("Do you like [%s] better than [%s]?", a.title, b.title);
    write("(y/n): ");

    import std.string;
    immutable response = readln().toLower;
    immutable a_defeats_b = response.startsWith('y');

    immutable a_original_elo = a.elo;
    immutable b_original_elo = b.elo;

    alias Win  = RatingSystem.Result.Win;
    alias Loss = RatingSystem.Result.Loss;

    a.elo = RatingSystem.GetNewRating(a_original_elo, b_original_elo, a_defeats_b ? Win : Loss);
    b.elo = RatingSystem.GetNewRating(a_original_elo, b_original_elo, a_defeats_b ? Loss : Win);
}

void main(string[] args)
{
    auto file = File(args[1]);

    foreach (line; file.byLine) {
        Movie movie;
        movie.title = line.idup;
        all_movies ~= movie;
    }

    import std.typecons;
    import std.algorithm;

    alias Fight = Tuple!(string, string);
    Fight[] fights;

    bool has_happened(Fight fight) {
        return fights.canFind(fight) || fights.canFind(reverse(fight));
    }

    foreach (ref movie; all_movies[]) {
        foreach (ref other_movie; all_movies[].filter!(m => m!=movie)) {
            auto fight = Fight(movie.title, other_movie.title);
            if (has_happened(fight)) continue;
            faceoff(movie, other_movie);
            fights ~= fight;
        }         
    }

    all_movies.sort!((a,b) => (a.elo > b.elo));

    foreach (movie; all_movies) {
        writefln("%04d\t%s", movie.elo, movie.title);
    }
}
