box::use(
  reactable[reactable],
  medicaldata[licorice_gargle]
)

#' @export
fetch_data <- function() {
  tibble::as_tibble(licorice_gargle)
}

