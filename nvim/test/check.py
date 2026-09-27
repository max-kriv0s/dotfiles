def total(numbers: list[int]) -> int:
    result = 0
    for number in numbers:
        result += number
    return result


if __name__ == "__main__":
    print(total([1, 2, 3, 4, 5]))
