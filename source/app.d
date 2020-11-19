import std.stdio;

struct Movie {
    string title            = "[No title. This is an error.]";
    int    elo              = 1000;
    int    num_wins         = 0;
    int    num_losses       = 0;
    int    opponent_elo_sum = 0;
}

int num_games_played = 0;
Movie[] all_movies;

void update_elo(ref Movie m) {
    m.elo = (m.opponent_elo_sum + (400 * (m.num_wins - m.num_losses))) / num_games_played;
}

void faceoff(ref Movie a, ref Movie b) {
    num_games_played += 1;

    void defeats(ref Movie winner, ref Movie loser) {
        winner.opponent_elo_sum += loser.elo;
        loser.opponent_elo_sum += winner.elo;

        winner.num_wins += 1;
        loser.num_losses += 1;

        winner.update_elo;
        loser.update_elo;
    }

    writefln("Do you like [%s] better than [%s]?", a.title, b.title);
    write("(y/n): ");

    import std.string;
    immutable response = readln().toLower;
    immutable bool yes = (response.startsWith('y'));

    if (yes) {
        defeats(a, b);
    } else {
        defeats(b, a);
    }
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
