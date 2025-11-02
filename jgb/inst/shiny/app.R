library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(leaflet)
library(shinythemes)
library(scales)
library(jgb)

# ---- Load sensor data from package ----
sensor_data <- jgb::sensor_data

if ("Coordinates_by_time.Time.Value" %in% names(sensor_data)) {
  # Case 1: single combined column
  sensor_data_clean <- sensor_data %>%
    tidyr::separate(Coordinates_by_time.Time.Value,
                    into = c("coords", "time", "measurement"),
                    sep = ",") %>%
    tidyr::separate(coords, into = c("latitude", "longitude"), sep = " ") %>%
    dplyr::mutate(
      latitude = as.numeric(latitude),
      longitude = as.numeric(longitude),
      time_point = as.numeric(gsub("T", "", time)),
      measurement = as.numeric(measurement),
      quality = dplyr::case_when(
        measurement <= 400 ~ "Good",
        measurement <= 750 ~ "Moderate",
        TRUE ~ "Poor"
      )
    ) %>%
    dplyr::select(latitude, longitude, time_point, measurement, quality)

} else if (all(c("Coordinates_by_time", "Time", "Value") %in% names(sensor_data))) {
  # Case 2: already separate columns
  sensor_data_clean <- sensor_data %>%
    dplyr::mutate(
      latitude = as.numeric(sub(" .*", "", Coordinates_by_time)),
      longitude = as.numeric(sub(".* ", "", Coordinates_by_time)),
      time_point = as.numeric(gsub("T", "", Time)),
      measurement = as.numeric(Value),
      quality = dplyr::case_when(
        measurement <= 400 ~ "Good",
        measurement <= 750 ~ "Moderate",
        TRUE ~ "Poor"
      )
    ) %>%
    dplyr::select(latitude, longitude, time_point, measurement, quality)

} else {
  stop("sensor_data has unexpected column structure. Check the dataset.")
}




# ---- UI ----
ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("🌿 Air Quality Explorer: SF Bay Area Sensors"),

  sidebarLayout(
    sidebarPanel(
      h4("Explore Air Quality Over Time"),

      sliderInput("time_slider", "Select Time Point:",
                  min = min(sensor_data_clean$time_point, na.rm = TRUE),
                  max = max(sensor_data_clean$time_point, na.rm = TRUE),
                  value = min(sensor_data_clean$time_point, na.rm = TRUE),
                  step = 1,
                  animate = animationOptions(interval = 800, loop = TRUE)),

      checkboxGroupInput(
        "quality_filter",
        "Select Air Quality Levels to Display:",
        choices = c("Good", "Moderate", "Poor"),
        selected = c("Good", "Moderate", "Poor")
      ),

      hr(),
      h5("Field Descriptions:"),
      p("• latitude / longitude – Sensor coordinates."),
      p("• time_point – Sequential time points (each 2 minutes apart)."),
      p("• measurement – Air quality reading (lower = better, higher = worse).")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Map View",
                 leafletOutput("map", height = 500),
                 br(),
                 tags$div(style="font-size:14px; text-align:right; color:#555;",
                          HTML("<b>Legend:</b> Bubble size ∝ Air Quality Value<br>
                                Larger bubbles = Worse Air Quality")),
                 br(),
                 p("Interpretation: The map shows air quality readings across all sensors.
                   Larger and redder circles indicate worse air quality at that time point.
                   Use the checkboxes to filter by air quality category.")
        ),
        tabPanel("Trend View",
                 plotOutput("trend_plot", height = 400),
                 br(),
                 p("Interpretation: The blue line shows average air quality across time.
                   The dashed red line marks the threshold above which air quality becomes unhealthy.")
        )
      )
    )
  )
)

# ---- Server ----
server <- function(input, output, session) {

  # ---- Filtered data for selected time and quality ----
  filtered_data <- reactive({
    req(input$quality_filter)
    df <- sensor_data_clean
    df$radius <- rescale(sqrt(df$measurement), to = c(2, 12))
    df %>%
      filter(time_point == input$time_slider,
             quality %in% input$quality_filter)
  })

  # ---- Map output ----
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = mean(sensor_data_clean$longitude),
              lat = mean(sensor_data_clean$latitude),
              zoom = 9)
  })

  observe({
    df <- filtered_data()

    leafletProxy("map", data = df) %>%
      clearMarkers() %>%
      clearControls() %>%
      addCircleMarkers(
        lng = ~longitude, lat = ~latitude,
        radius = ~radius,
        color = ~case_when(
          quality == "Good" ~ "green",
          quality == "Moderate" ~ "orange",
          quality == "Poor" ~ "red"
        ),
        fillOpacity = 0.6,
        stroke = FALSE,
        popup = ~paste0(
          "<b>Air Quality Value:</b> ", round(measurement, 2),
          "<br><b>Category:</b> ", quality,
          "<br><b>Time:</b> T", time_point
        )
      ) %>%
      addLegend(
        position = "bottomright",
        colors = c("green", "orange", "red"),
        labels = c("Good", "Moderate", "Poor"),
        title = "Air Quality (Color)"
      )
  })

  # ---- Trend plot output ----
  output$trend_plot <- renderPlot({
    df <- sensor_data_clean %>%
      group_by(time_point) %>%
      summarise(mean_val = mean(measurement, na.rm = TRUE))

    threshold <- 500

    ggplot(df, aes(x = time_point, y = mean_val)) +
      geom_line(color = "#0072B2", size = 1.2) +
      geom_point(color = "#0072B2") +
      geom_hline(yintercept = threshold,
                 linetype = "dashed", color = "red", size = 1) +
      annotate("text", x = max(df$time_point) * 0.8,
               y = threshold + 30,
               label = paste("Unhealthy Threshold =", threshold),
               color = "red", fontface = "bold", size = 4) +
      labs(x = "Time (T index)",
           y = "Average Air Quality Value",
           title = "Air Quality Trend Across All Sensors") +
      theme_minimal(base_size = 14) +
      theme(plot.title = element_text(face = "bold", hjust = 0.5))
  })
}

# ---- Run App ----
shinyApp(ui, server)
