################################################################################
#                                   PROMPT 1
################################################################################
# Function to calculate the cost of a path
calculate_path_cost <- function(path, links) {
  total_cost <- 0
  for (i in 2:length(path)) {
    link_index <- path[i] - 1
    propagation_delay <- 5 * links[link_index, "distance"]
    transmission_queue_delay <- 1 / (1 - links[link_index, "load"])
    ber_penalty <- ifelse(links[link_index, "BeR"] >= 10e-4 && links[link_index, "BeR"] <= 1, 1000,
                          ifelse(links[link_index, "BeR"] > 10e-5 && links[link_index, "BeR"] < 10e-4, 50, 0))
    link_cost <- propagation_delay + transmission_queue_delay + ber_penalty
    total_cost <- total_cost + link_cost
  }
  return(total_cost)
}

# Function to find all possible paths between two routers
find_all_paths <- function(start_router, end_router, links) {
  paths <- list()
  if (start_router == end_router) {
    paths[[1]] <- c(start_router)
    return(paths)
  }
  for (neighbor in links[start_router, "neighbors"]) {
    if (neighbor != end_router) {
      subpaths <- find_all_paths(neighbor, end_router, links)
      for (subpath in subpaths) {
        paths[[length(paths) + 1]] <- c(start_router, subpath)
      }
    }
  }
  return(paths)
}

# Function to select the best path between two routers
select_best_path <- function(start_router, end_router, links) {
  all_paths <- find_all_paths(start_router, end_router, links)
  best_path <- NULL
  min_cost <- Inf
  for (path in all_paths) {
    path_cost <- calculate_path_cost(path, links)
    if (path_cost < min_cost) {
      best_path <- path
      min_cost <- path_cost
    }
  }
  return(best_path)
}

# Generate random number of routers (minimum 4)
num_routers <- sample(4:20, 1)

# Generate random values of BeR, load and distance for the links between routers
links <- data.frame(router1 = 1:num_routers,
                    router2 = rep(NA, num_routers),
                    BeR = rnorm(num_routers * (num_routers - 1), 0, 0.01),
                    load = rnorm(num_routers * (num_routers - 1), 0.5, 0.1),
                    distance = rnorm(num_routers * (num_routers - 1), 100, 50))
for (i in 1:num_routers) {
  links[i, (i + 1):num_routers] <- NA
}

# Complete the links matrix
for (i in 1:num_routers) {
  for (j in (i + 1):num_routers) {
    if (!is.na(links[i, j])) {
      links[j, i] <- links[i, j]
    }
  }
}

# Select the best path from router 1 to router num_routers
best_path <- select_best_path(1, num_routers, links)

# Print the best path
print(best_path)

