import time

start_time = time.time()
input = open("../input.txt").readlines()
input = [line.strip() for line in input]


def valid(r):
    ascending = r[0] > r[1]
    for i in range(1, len(r)):
        diff = abs(r[i] - r[i - 1])
        if diff < 1 or diff > 3 or (ascending != (r[i] < r[i - 1])):
            return False
    return True


part1Answer = 0
part2Answer = 0

for line in input:
    reportlist = line.split(" ")
    for i in range(0, len(reportlist)):
        reportlist[i] = int(reportlist[i])

    if valid(reportlist):
        part1Answer += 1
        part2Answer += 1
        continue

    for i in range(0, len(reportlist)):
        filteredList = reportlist[:i] + reportlist[i + 1 :]
        if valid(filteredList):
            part2Answer += 1
            break

# print(part1Answer)
# print(part2Answer)
print("Python: ", (time.time() - start_time) * 1000)
