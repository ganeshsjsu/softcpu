#include <stdio.h>

// Recursive function to calculate factorial
long long factorial(int n) {
  // Base case: 0! = 1 and 1! = 1
  if (n <= 1) {
    return 1;
  }
  // Recursive step: n! = n * (n-1)!
  return n * factorial(n - 1);
}

// Driver (main) program
int main() {
  int number = 5;

  printf("Calculating factorial of %d...\n", number);
  printf("Flow:\n");

  // Call the recursive function
  long long result = factorial(number);

  printf("Result: %d! = %lld\n", number, result);

  return 0;
}
