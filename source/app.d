import scriptlike;

struct Movie {
    string title = "[No title. This is an error.]";
    int elo = 1000;
    int num_wins = 0, num_losses = 0;
    int opponent_elo_sum = 0;
}

int num_games_played = 0;
Movie[] all_movies;

void update_elo(ref Movie m) {
    m.elo = (m.opponent_elo_sum + (400 * (m.num_wins - m.num_losses))) 
                / num_games_played;
}

void faceoff(ref Movie a, ref Movie b) {
    num_games_played += 1;

    void defeats(ref Movie winner, ref Movie loser) {
        winner.opponent_elo_sum += loser.elo;
        loser.opponent_elo_sum  += winner.elo;

        winner.num_wins  += 1;
        loser.num_losses += 1;

        winner.update_elo;
        loser.update_elo;
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

    float max = all_movies[0].elo;

    if (all_movies.length >= 2) {
        foreach (m; all_movies) {
            if (m.elo > max) {
                max = m.elo;
            }
        }
    }

    foreach (movie; all_movies[]) {
        float rating = (10.0 * movie.elo) / max;
        writefln("%+04d : %02.03f : %s", movie.elo, rating, movie.title);
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