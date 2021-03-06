#' Window Summary Statistics 
#'
#' Calculate statistical summaries of rainfall over a defined period
#' 
#' @param daily_rfe Folder containing the downloaded daily-rfe from tamsat_daily_download
#' @param start_doy Day of Year (DDD-format) for the start of the period 
#' @param end_doy Day of Year (DDD-format) for the end of the period
#' @param stat statistic to calculate, must be compatible with raster::calc()
#' @param years Years as interger(s) for which statistics will be calculated
#' @param id Charecter sting to identify the outputs eg 'long_integer/ jan_march etc'
#' @param outlocation Folder (string) to save summary layers into
# 


window_summary <- function(daily_rfe, years, start_doy, end_doy, stat, id, outlocation) {
    
    listFiles <- list.files(path = daily_rfe, pattern = ".nc", recursive = TRUE, full.names = TRUE)
    for (i in years) {
        print(i)
        start_date <- as.Date(start_doy, origin = paste0(i, "-01-01"))
        start_date <- as.Date(start_date, format = "%Y/%m/%d")
        start_date <- gsub(pattern = "-", "_", start_date)
        start_grep <- paste0("rfe", start_date)
        
        if (end_doy < start_doy) {
            end_date <- as.Date(end_doy, origin = paste0(i + 1, "-01-01"))
        }
        
        end_date <- as.Date(end_date, format = "%Y/%m/%d")
        end_date <- gsub(pattern = "-", "_", end_date)
        end_grep <- paste0("rfe", end_date)
        
        
        startPos <- grep(pattern = start_grep, x = listFiles)
        endPos <- grep(pattern = end_grep, x = listFiles)
        
        year_stack <- raster::stack(sapply(listFiles[startPos:endPos], FUN = raster::raster))
        
        flname <- paste0(outlocation, "/", id, "_", stat, i, ".tif")
        
        raster::calc(x = year_stack, fun = sum, filename = flname)
    }
}
