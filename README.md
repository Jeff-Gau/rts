
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rts

<!-- badges: start -->

<!-- badges: end -->

The goal of rts is to get data from the [Return to School
Project](http://returntoschoolproject.org/) into R in a variety of
forms. It is designed for internal use for the project and not likely
useful outside of the project.

## Installation

You can install the package from R via

``` r
# install.packages("remotes") # if not previously installed
remotes::install_github("datalorax/rts")
```

## Usage

You first need to have an API key for the specific project.

You first need to make sure you have a key to access the web API housing
the data. The **rts** package includes helper functions for working with
your key. First, store your key in your `.Renviron` using the following
code, swapping the text for your specific key.

``` r
library(rts)
redcap_set_key(key = "mykeyabcdefg")
```

This will write a key to your `.Renviron` that is accessible via
`redcap_key()`. You should only need to do this once, and you will need
to make sure you restart your R session for the change to take effect.
Generally, you won’t need to access your key, but if for any reason you
do, you can always run `redcap_key()` and your key will be printed to
the console.

## Accessing data

Once you’ve set your key, you can access data from the project with the
`get_rts_data()` function.

``` r
d <- get_rts_data()
#> Warning: The following named parsers don't match the column names: field_name
#> Warning: Unknown or uninitialised column: `field_name`.

nrow(d)
#> [1] 162
ncol(d)
#> [1] 5490
```

At this point, the only thing returned is a giant gnarly data frame that
is not particularly useful, but future development will have it spit out
the data for any survey and in a variety of different formats, based on
either specific argument to the function, or piping the data frame to
new functions.
