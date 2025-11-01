#' Filter sensor data for a given time range
#' @export
filter_sensor_data <- function(data, time_range) {
  dplyr::filter(data, time_point >= time_range[1], time_point <= time_range[2])
}

#' Aggregate data spatially
#' @export
aggregate_sensor_data <- function(data) {
  data %>%
    dplyr::group_by(latitude, longitude) %>%
    dplyr::summarise(mean_measurement = mean(measurement, na.rm = TRUE), .groups = "drop")
}
