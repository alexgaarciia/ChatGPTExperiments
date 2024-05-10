################################################################################
#                                   PROMPT 1
################################################################################
# Load required libraries
library(igraph)

# Generate random number of routers
num_routers <- sample(4:10, 1)

# Generate random link values
num_links <- sample(num_routers*(num_routers-1)/2, num_routers)
distances <- runif(num_links, min = 1, max = 10)
loads <- runif(num_links, min = 0, max = 1)
ber_values <- runif(num_links, min = 0, max = 1)

# Create graph
g <- graph_from_data_frame(data.frame(from = sample(num_routers, num_links),
                                      to = sample(num_routers, num_links),
                                      weight = distances * loads * ber_values))

# Define cost function
cost_function <- function(path, g) {
  total_cost <- 0
  for (i in seq_along(path)) {
    from <- path[i-1]
    to <- path[i]
    weight <- g$weight[from, to]
    total_cost <- total_cost + weight
  }
  total_cost <- total_cost + 5 * sum(g$weight) * sum(loads) * sum(ber_values)
  return(total_cost)
}

# Select best path from one router to another
start_router <- sample(num_routers, 1)
end_router <- sample(num_routers, 1)
best_path <- shortest_path(g, start_router, end_router, cost = cost_function)

# Print best path and total cost
cat("Best path from router", start_router, "to router", end_router, ":\n")
cat(best_path, "\n")
cat("Total cost:", cost_function(best_path, g), "\n")

