% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tableby.internal.R
\name{tableby.stats.internal}
\alias{tableby.stats.internal}
\alias{as.tbstat}
\alias{as.countpct}
\alias{as.tbstat_multirow}
\title{Internal \code{tableby} functions}
\usage{
as.tbstat(
  x,
  oldClass = NULL,
  sep = NULL,
  parens = NULL,
  sep2 = NULL,
  pct = NULL,
  ...
)

as.countpct(
  x,
  ...,
  which.count = setdiff(seq_along(x), which.pct),
  which.pct = 0L
)

as.tbstat_multirow(x)
}
\arguments{
\item{x}{Usually a vector.}

\item{oldClass}{class(es) to add to the resulting object.}

\item{sep}{The separator between \code{x[1]} and the rest of the vector.}

\item{parens}{A length-2 vector denoting parentheses to use around \code{x[2]} and \code{x[3]}.}

\item{sep2}{The separator between \code{x[2]} and \code{x[3]}.}

\item{pct}{For statistics of length 2, the symbol to use after the second one. (It's called
"pct" because usually the first statistic is never a percent, but the second often is.)}

\item{...}{arguments to pass to \code{as.tbstat}.}

\item{which.count}{Which statistics are counts? The default is everything except the things that are percents.}

\item{which.pct}{Which statistics are percents? The default is 0, indicating that none are.}
}
\description{
A collection of functions that may help users create custom functions that are formatted correctly.
}
\details{
The vignette has an example on how to use these.

  \code{as.tbstat} defines a tableby statistic with its appropriate formatting.

  \code{as.countpct} adds another class to \code{as.tbstat} to use different "digits" arguments
  (i.e., \code{digits.count} or \code{digits.pct}). See \code{\link{tableby.control}}.

  \code{as.tbstat_multirow} marks an object (usually a list) for multiple-row printing.
}
