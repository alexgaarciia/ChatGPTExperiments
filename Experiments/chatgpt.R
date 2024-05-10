################################################################################
#                                   PROMPT 1
################################################################################
# Function to generate a random network topology
generate_topology <- function(num_routers) {
  routers <- paste0("Router", 1:num_routers)
  links <- expand.grid(routers, routers)
  links <- links[links$Var1 != links$Var2, ]
  links$Distance <- runif(nrow(links), 1, 10)
  links$BeR <- runif(nrow(links), 1e-6, 1e-3)
  links$Load <- runif(nrow(links), 0, 1)
  return(links)
}

# Function to calculate cost based on the specified criteria
calculate_cost <- function(distance, load, BeR) {
  propagation_delay <- 5 * distance
  transmission_queue_delay <- 1 / (1 - load)
  ber_penalty <- ifelse(BeR >= 1e-4 && BeR <= 1, 1000, 
                        ifelse(BeR > 1e-5 && BeR < 1e-4, 50, 0))
  
  cost <- propagation_delay + transmission_queue_delay + ber_penalty
  return(cost)
}

# Function to find the best path using Dijkstra's algorithm
find_best_path <- function(topology, source, target) {
  library(igraph)
  
  graph <- graph_from_data_frame(topology, directed = TRUE)
  paths <- shortest_paths(graph, from = source, to = target, mode = "out", algorithm = "dijkstra")
  
  if (length(paths$vpath[[1]]) == 0) {
    print("No path found.")
    return(NULL)
  }
  
  best_path <- paths$vpath[[1]]
  
  calculate_path_cost <- function(path) {
    distances <- topology$Distance[match(path, rownames(topology))]
    loads <- topology$Load[match(path, rownames(topology))]
    BeRs <- topology$BeR[match(path, rownames(topology))]
    
    costs <- 5 * distances + 1 / (1 - loads) + ifelse(BeRs >= 1e-4 && BeRs <= 1, 1000,
                                                      ifelse(BeRs > 1e-5 && BeRs < 1e-4, 50, 0))
    
    return(sum(costs))
  }
  path_costs <- calculate_path_cost(best_path)
  return(list(path = best_path, cost = path_costs))
}

# Example usage
num_routers <- sample(4:10, 1)
topology <- generate_topology(num_routers)
print("Generated Topology:")
print(topology)

source_router <- paste0("Router", sample(1:num_routers, 1))
target_router <- paste0("Router", sample(1:num_routers, 1))
print(paste("Source Router: ", source_router))
print(paste("Target Router: ", target_router))

best_path_result <- find_best_path(topology, source_router, target_router)
print(paste("Best Path: ", best_path_result$path))
print(paste("Path Cost: ", best_path_result$cost))

