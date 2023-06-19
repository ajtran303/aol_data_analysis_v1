# AOL Data Analysis v1

I'm trying out some machine learning and natural language processing (ML / NLP) techniques with this dataset of AOL User Search Queries.

<!-- ## Skip this section

I picked this source because the dataset is "frozen in time" and I guess I'm feeling nostalgic. It was the mid-aughts, and half the people using the internet were still connecting with dial-up. I personally didn't get a broadband connection at home until my second year of high school.

But I sure do remember using search engines. It was something I had learned about in elementary school, in the library. Originally, I was writing queries to search the new digital catalog (I could still search the card catalog though), and eventually some databases, and then the web itself. Something I still remember about that time was learning how to use "boolean operators" in my searches to optimize the results returned.

Search engines, yo. -->

## Background

In 2006, America Online (aka "AOL") accidentally leaked 3 months worth of "anonymized" search query logs. It was a big "uh oh." [Read the Wikipedia article](https://en.wikipedia.org/wiki/AOL_search_log_release) and do some searching on your search engine of choice to learn more.

It turned into a cultural phenomenon - tons of articles were written, websites to search and navigate the data, theater, and a tv show... and I guess it's mostly forgotten now.

It's 2023 and there's all sorts of data leaks all the time. Just this week, the entire state of Lousiana had information stolen from every person with a driver's license. This was a cyber crime, for sure, made by people with mal-intent. I'm sure there's still accidents like this AOL leak happening though.

Back to the dataset though. I'll just lift text from the README:

```
# U500k_README.txt

...

This collection consists of ~20M web queries collected from ~650k users over three months.
The data is sorted by anonymous user ID and sequentially arranged. 

The goal of this collection is to provide real query log data that is based on real users. It could be used for personalization, query reformulation or other types of search research. 

The data set includes {AnonID, Query, QueryTime, ItemRank, ClickURL}.
        AnonID - an anonymous user ID number.
        Query  - the query issued by the user, case shifted with
                 most punctuation removed.
        QueryTime - the time at which the query was submitted for search.
        ItemRank  - if the user clicked on a search result, the rank of the
                    item on which they clicked is listed. 
        ClickURL  - if the user clicked on a search result, the domain portion of 
                    the URL in the clicked result is listed.

...

```

## Source

AOL took the archive offline a few days later, but not before other people made copies and uploaded it elsewhere.

I got a copy of the archive from some server at McGill CIM (*Centre* for Intelligent Machines). I make no guarantees that this data will continue to be available from them.

Interestingly, there's a README included and at the end of it, it says `Copyright (2006) AOL`.

**Caveat emptor:*** This dataset contains explicit text references (like search queries for XXX) and personally identifiable information (people have been searching their own name since the beginning of search engines). I make no guarantees or endorsements about its contents.

## Get the Data

I used command line tools to download, decompress, and collect all the data into one text file. I wrote a script so you can benefit from my experience:

```bash
$ bash scripts/download-aol-data.sh
```

This script will create a directory, `data/` and download the raw data into one text file, `aol-data.txt.` That file is around 2.2G in size. Also included is `U500k_README.txt` which has really useful information about the data.

***Note:*** The `data/` directory is in .gitignore, so those GB won't be uploaded to source control.
