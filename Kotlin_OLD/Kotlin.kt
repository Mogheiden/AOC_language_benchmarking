import java.io.File  
import kotlin.math.abs  
val data = File("../input.txt").readText()  

fun main(){
    val day2data = data.split("\n")
    var part1Answer = 0
    for (line in day2data){
        val numbers List<Int> = line.split(" ").map {it.toint()}
        if (valid(numbers)){
            part1Answer += 1
        }
    }
    println(part1Answer)
}

public fun valid(r: List<Int>): Boolean{
    val ascending = r[0] > r[1]
    for (i in 1..r.count()){
        val diff = kotlin.math.abs(r[i] - r[i-1])
        if (diff < 1 || diff > 3 || (ascending != (r[i]< r[i-1]))){
            return false
        }
    }
    return true
}