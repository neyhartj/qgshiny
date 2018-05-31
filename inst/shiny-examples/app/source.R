# Simulate a population
simpop <- function(p, N, t, f = c("0" = 1, "1" = 1, "2" = 1), reps = 1) {

  # Replicate by the number of reps
  results_out <- replicate(n = reps, expr = {

    # Start an empty vector of allele frequencies
    p_vec <- vector("numeric", t)

    # Start the generation counter
    t_i <- 1

    # Record the allele frequency
    p_vec[t_i] <- p

    # Initialize the population
    # Draw from a binomial distribution where the number of trials is the effective
    ## population size and the success probability is p
    pop_i <- rbinom(n = N, size = 2, prob = p)

    # Frequency of the 1 allele is the mean of the 1 allele counts / 2
    p_i <- mean(pop_i) / 2

    ## Selection
    # Vector of probabilities of sampling each genotype
    prob_i <- ifelse(pop_i == 0, f["0"], ifelse(pop_i == 1, f["1"], f["2"]))

    # Sample the population with replacement using the fitness as the probability
    pop_i <- sample(x = pop_i, prob = prob_i, replace = T)


    # Advance the counter
    t_i <- t_i + 1

    # Record the frequency
    p_vec[t_i] <- p_i

    # While loop
    while(t_i < t) {

      # Simulate the population using the previous allele frequency
      pop_i <- rbinom(n = N, size = 2, prob = p_i)

      # Record the allele frequency
      p_i <- mean(pop_i) / 2

      ## Selection
      # Vector of probabilities of sampling each genotype
      prob_i <- ifelse(pop_i == 0, f["0"], ifelse(pop_i == 1, f["1"], f["2"]))

      # Sample the population with replacement using the fitness as the probability
      pop_i <- sample(x = pop_i, prob = prob_i, replace = T)

      # Advance the counter
      t_i <- t_i + 1

      # Record the frequency
      p_vec[t_i] <- p_i

    }

    # Place in df and return
    data.frame(gen = seq(t), p = p_vec) })

  # Rearrange and export the data
  data.frame(
    gen = seq(t),
    apply(X = results_out, MARGIN = 2, FUN = function(r) r[2]$p)
  )

} # Close the function

# Simulate a breeding population
simbreed <- function(p, N, t, h, L, i, a) {

  # Determine the max genetic value
  max_G <- sum(a)

  # Initial generation number
  t_i <- 1

  # Initialize vectors to store information
  # QTL allele freqs
  p_mat <- matrix(0, nrow = t, ncol = L)
  # Population geno value and genetic variance and phenotypes
  G_vec <- varG_vec <- P_vec <- vector("numeric", t)

  # Initialize the population
  # Draw from a binomial distribution where the number of trials is the effective
  ## population size and the success probability is p. Repeat this for each gene
  pop_i <- sapply(X = rep(p, L), FUN = rbinom, n = N, size = 2)

  # Calculate allele frequencies
  p_i <- apply(X = pop_i, MARGIN = 2, FUN = mean) / 2

  # Calculate the genotypic value
  # Scale by the maximum genotype value posible
  G_i <- ((pop_i - 1) %*% a ) / max_G
  varG <- var(G_i)

  # Calculate the non-genetic variance
  varR <- (varG / h) - varG

  # Add non-genetic effects
  epsilon <- rnorm(n = N, mean = 0, sd = sqrt(varR))

  # Calculate phenotypes
  P_i <- G_i + epsilon


  ## Store values
  # Mean genotypic value
  G_vec[t_i] <- mean(G_i)
  # Variance
  varG_vec[t_i] <- var(G_i)
  # Mean phenotype
  P_vec[t_i] <- mean(P_i)
  # Frequency
  p_mat[t_i, ] <- p_i

  # Make selections
  sel_ind <- head(x = order(P_i, decreasing = T), n = ceiling(i * N))
  # Extract the genotypes of those individuals
  sel_geno <- pop_i[sel_ind, , drop = FALSE]
  # Calculate allele frequencies
  sel_p <- apply(X = sel_geno, MARGIN = 2, FUN = mean) / 2


  # Advance t_i
  t_i <- t_i + 1

  # While loop for generations
  while (t_i <= t) {

    # Generate a new population
    pop_i <- sapply(X = sel_p, FUN = rbinom, n = N, size = 2)

    # Calculate allele frequencies
    p_i <- apply(X = pop_i, MARGIN = 2, FUN = mean) / 2
    # Store
    p_mat[t_i, ] <- p_i

    # Calculate the genotypic value and standardize to the number of genes
    G_i <- ((pop_i - 1) %*% a) / max_G
    varG <- var(G_i)


    # Add non-genetic effects
    epsilon <- rnorm(n = N, mean = 0, sd = sqrt(varR))

    # Calculate phenotypes
    P_i <- G_i + epsilon

    # Store
    # Mean genotypic value
    G_vec[t_i] <- mean(G_i)
    # Variance
    varG_vec[t_i] <- var(G_i)
    # Mean phenotype
    P_vec[t_i] <- mean(P_i)


    # Make selections
    sel_ind <- head(x = order(P_i, decreasing = T), n = ceiling(i * N))
    # Extract the genotypes of those individuals
    sel_geno <- pop_i[sel_ind, , drop = FALSE]
    # Calculate allele frequencies
    sel_p <- apply(X = sel_geno, MARGIN = 2, FUN = mean) / 2

    # Advance t_i
    t_i <- t_i + 1

  }

  # Output a data.frame
  data.frame(
    gen = seq(t),
    p = p_mat,
    G = G_vec,
    varG = varG_vec,
    P = P_vec
  )

} # Close the function








