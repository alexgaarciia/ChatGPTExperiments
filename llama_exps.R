################################################################################
#                                   PROMPT 1
################################################################################
# Define the number of routers
n_routers <- 4

# Generate random values for BeR, load, and distance for the links between routers
ber_values <- runif(n_routers, 10^-5, 10^-4)
load_values <- runif(n_routers, 0, 1)
distance_values <- runif(n_routers, 1, 10)

# Create a matrix to store the links between routers
links <- matrix(NA, nrow = n_routers, ncol = n_routers)

# Fill in the matrix with the generated values
for (i in 1:n_routers) {
  for (j in 1:n_routers) {
    if (i != j) {
      links[i, j] <- ber_values[i] * distance_values[i] + load_values[j]
    }
  }
}

# Define the cost function
cost_function <- function(link) {
  propagation_delay <- 5 * distance_values[link]
  transmission_queue_delay <- 1 / (1 - load_values[link])
  ber_penalty <- ifelse(ber_values[link] >= 10^-4 & ber_values[link] <= 1, 1000,
                        ifelse(ber_values[link] > 10^-5 & ber_values[link] < 10^-4, 50, 0))
  return(propagation_delay + transmission_queue_delay + ber_penalty)
}

# Find the shortest path between two routers
shortest_path <- matrix(NA, nrow = n_routers, ncol = n_routers)
for (i in 1:n_routers) {
  for (j in 1:n_routers) {
    if (i != j) {
      shortest_path[i, j] <- min(cost_function(links[i, j]), cost_function(links[j, i]))
    }
  }
}

# Print the shortest path
print(shortest_path)

