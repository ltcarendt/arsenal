get_tb_strata_part <- function(tbList, sValue, xList, ...)
{
  Map(get_tb_part, tbList, xList, MoreArgs = list(sValue = sValue, ...))
}


get_tb_part <- function(tbList, xList, yList, sList, sValue, cntrl)
{
  statLabs <- cntrl$stats.labels
  f <- function(x, nm, lab = FALSE)
  {
    if(inherits(x[[1]], "tbstat_multirow")) return(if(lab) names(x[[1]]) else rep(nm, length(x[[1]])))
    if(lab && nm %in% names(statLabs)) statLabs[[nm]] else nm
  }

  out <- data.frame(
    group.term = yList$term,
    group.label = yList$label,
    strata.term = if(!sList$hasStrata) "" else paste0("(", sList$term, ") == ", sValue),
    strata.value = if(!sList$hasStrata) "" else sValue,
    variable = xList$variable,
    term = c(xList$term, unlist(Map(f, tbList$stats, names(tbList$stats)), use.names = FALSE)),
    label = c(xList$label, unlist(Map(f, tbList$stats, names(tbList$stats), lab = TRUE), use.names = FALSE)),
    variable.type = tbList$type,
    stringsAsFactors = FALSE
  )
  if(!sList$hasStrata) out$strata.value <- NULL else names(out)[4] <- sList$label

  f2 <- function(x, lv)
  {
    if(inherits(x[[1]], "tbstat_multirow")) x[[lv]] else x[lv]
  }
  for(lvl in names(yList$stats))
  {
    out[[lvl]] <- c("", unlist(lapply(tbList$stats, f2, lv = lvl), recursive = FALSE, use.names = FALSE))
  }
  if(cntrl$test)
  {
    out$test <- tbList$test$method
    out$p.value <- tbList$test$p.value
  }
  out
}

#' as.data.frame.tableby
#'
#' Coerce a \code{\link{tableby}} object to a \code{data.frame}.
#'
#' @param x A \code{\link{tableby}} object.
#' @param ... Arguments to pass to \code{\link{tableby.control}}.
#' @inheritParams summary.tableby
#' @seealso \code{\link{tableby}}, \code{\link{tableby}}
#' @return A \code{data.frame}.
#' @author Ethan Heinzen, based on code originally by Greg Dougherty
#' @export
as.data.frame.tableby <- function(x, ..., labelTranslations = NULL, list.ok = FALSE)
{
  if(!is.null(labelTranslations)) labels(x) <- labelTranslations

  control <- c(list(...), x$control)
  control <- do.call("tableby.control", control[!duplicated(names(control))])

  out <- lapply(x$tables, as_data_frame_tableby, control = control)

  if(!list.ok)
  {
    if(length(out) == 1) out <- out[[1]] else warning("as.data.frame.tableby is returning a list of data.frames")
  }

  set_attr(out, "control", control)
}


as_data_frame_tableby <- function(byList, control)
{
  stopifnot(length(byList$tables) == length(byList$strata$values))
  tabs <- Map(get_tb_strata_part, tbList = byList$tables, sValue = byList$strata$values,
              MoreArgs = list(yList = byList$y, sList = byList$strata, xList = byList$x, cntrl = control))
  out <- do.call(rbind_chr, unlist(tabs, recursive = FALSE, use.names = FALSE))

  f <- function(elt, whch) if(is.null(elt[[whch]])) control[[whch]] else elt[[whch]]
  simp.num <- vapply(byList$control.list, f, NA, "numeric.simplify")
  simp.cat <- vapply(byList$control.list, f, NA, "cat.simplify")
  simp.ord <- vapply(byList$control.list, f, NA, "ordered.simplify")
  simp.dat <- vapply(byList$control.list, f, NA, "date.simplify")

  if(any(simp.cat) || any(simp.num) || any(simp.ord) || any(simp.dat))
  {
    simplify <- function(x)
    {
      ## make sure there's only two lines of (the same) summary statistic, and that it's categorical
      if((simp.cat[x$variable[1]] && all(x$variable.type == "categorical") ||
          simp.ord[x$variable[1]] && all(x$variable.type == "ordinal")) &&
         (nrow(x) == 2 || nrow(x) == 3 && x$term[2] == x$term[3]))
      {
        y <- x[nrow(x), , drop = FALSE]
        y$term[1] <- x$term[1]
        y$label[1] <- x$label[1]
      } else if((simp.num[x$variable[1]] && all(x$variable.type == "numeric") ||
                 simp.dat[x$variable[1]] && all(x$variable.type == "Date")) && nrow(x) == 2)
      {
        y <- x[2, , drop = FALSE]
        y$term[1] <- x$term[1]
        y$label[1] <- x$label[1]
      } else y <- x
      y
    }
    bylst <- list(factor(out$variable, levels = unique(out$variable)))
    if(byList$strata$hasStrata) bylst[[2]] <- factor(out[[4]], levels = unique(out[[4]]))
    out <- do.call(rbind_chr, by(out, bylst, simplify, simplify = FALSE))
  }
  set_attr(set_attr(out, "control.list", byList$control.list), "ylabel", byList$y$label)
}
