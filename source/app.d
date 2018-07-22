import scriptlike;

struct Movie {
    string title = "[No title. This is an error.]";
    int elo = 1000;
    invariant(num_games_played >= 0);
}

int num_games_played = 0;
Movie[] all_movies;

void faceoff(ref Movie a, ref Movie b) {
    num_games_played += 1;

    void defeats(ref Movie winner, ref Movie loser) {
        writefln("[%s] --> %s + ((%s + 400) / %s)", winner.title, winner.elo, loser.elo, num_games_played);
        writefln("[%s] --> %s + ((%s - 400) / %s)", loser.title, loser.elo, winner.elo, num_games_played);

        immutable int winner_elo = winner.elo;
        immutable int loser_elo  = loser.elo;

        winner.elo += (loser_elo  + 400) / num_games_played;
        loser.elo  += (winner_elo - 400) / num_games_played;
    }

    if (userInput!bool("Do you like [%s] better than [%s]?".format(a.title, b.title))) {
        defeats(a, b);
    } else {
        defeats(b, a);
    }
}

/* 
    Commands 
 */

Movie prompt_for_new_movie() {
    Movie ret;
    ret.title = userInput!string("Enter a movie");
    return ret;
}

void list_all_movies() {
    if (all_movies.length == 0) {
        writeln("No movies.");
        return;
    }

    import std.algorithm : sort;
    foreach (movie; all_movies[]) {
        writefln("%+4s : %s", movie.elo, movie.title);
    }
}

void main() {
    while (true) {
        if (all_movies.length != 0) {
            all_movies.sort!((a, b) => (a.elo > b.elo));
        }

        char input = userInput!char("(a)dd a movie, (l)ist movies, (q)uit");

        switch (input) {
            case 'a': 
                auto a = prompt_for_new_movie;
                foreach (ref b; all_movies[]) {
                    faceoff(a, b);
                }

                all_movies ~= a; 
                break;
            case 'l': list_all_movies; break;
            case 'q': return;
            default : break;
        }
    }
}