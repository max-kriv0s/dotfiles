function total(numbers: number[]): number {
  let result = 0;
  for (const number of numbers) {
    result += number;
  }
  return result;
}

console.log(total([1, 2, 3, 4, 5]));
