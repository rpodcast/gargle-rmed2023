box::use(
  reactable[reactable],
  medicaldata
)

#' @export
fetch_data <- function() {
  tibble::as_tibble(medicaldata$licorice_gargle)
}

#' @export
create_table <- function(data) {
  reactable(data)
}
