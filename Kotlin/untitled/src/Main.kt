import java.io.File
import kotlin.time.TimeSource

val data = File("../../input.txt").readLines().map {
    it.split(" ").map { n -> n.toInt() }

}
val timeSource = TimeSource.Monotonic

fun main() {
    val start = timeSource.markNow()
    var part1Answer = 0
    var part2Answer = 0

    for (line in data) {
        if (valid(line)) {
            part1Answer += 1
            part2Answer += 1
            continue
        }
        for (i in line.indices) {
            val new = line.filterIndexed { index, _ -> index != i }
            if (valid(new)) {
                part2Answer++
                break
            }
        }
    }
    println(part1Answer)
    println(part2Answer)
    println(start.elapsedNow())
}

fun valid(r: List<Int>): Boolean {
    val ascending = r[0] > r[1]
    for (i in 1..<r.size) {
        val diff = kotlin.math.abs(r[i] - r[i - 1])
        if (diff < 1 || diff > 3 || (ascending != (r[i] < r[i - 1]))) {
            return false
        }
    }
    return true
}
