# movie-faceoff

Basically this is a really dumb way to rank your favourite movies. Or songs, or
anything else, I guess. It has a simple ELO implementation which I'm like 99%
sure is wrong, and one movie "beats" another when you say you like it more.

## Prerequisites

A D compiler and Dub. The easiest way to get these is to grab the installer from https://dlang.org .

## Compiling

Run `dub build` in the `movie-faceoff` directory. :)

## Usage

1. Compile a list of movies into a text file, with one movie title per line. See `movies.txt` for an example.
2. Run `./movie-faceoff your-text-file.txt`
3. Answer the questions it asks you :)
