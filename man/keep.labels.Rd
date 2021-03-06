% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/keep.labels.R
\name{keep.labels}
\alias{keep.labels}
\alias{keep.labels.data.frame}
\alias{keep.labels.default}
\alias{[.keep_labels}
\alias{[<-.keep_labels}
\alias{loosen.labels}
\alias{loosen.labels.data.frame}
\alias{loosen.labels.default}
\title{Keep Labels}
\usage{
keep.labels(x, ...)

\method{keep.labels}{data.frame}(x, ...)

\method{keep.labels}{default}(x, ...)

\method{[}{keep_labels}(x, ...)

\method{[}{keep_labels}(x, i) <- value

loosen.labels(x, ...)

\method{loosen.labels}{data.frame}(x, ...)

\method{loosen.labels}{default}(x, ...)
}
\arguments{
\item{x}{An R object}

\item{...}{Other arguments (not in use at this time).}

\item{i, value}{See \code{\link{[<-}}.}
}
\value{
A copy of \code{x} with a "keep_labels" class appended on or removed. Note that for the \code{data.frame} method,
  only classes on the columns are changed; the \code{data.frame} won't have an extra class appended. This is different from previous
  versions of \code{arsenal}.
}
\description{
Keep the \code{'label'} attribute on an R object when subsetting. \code{loosen.labels} allows the \code{'label'}
  attribute to be lost again.
}
\seealso{
\code{\link{labels}}
}
\author{
Ethan Heinzen
}
