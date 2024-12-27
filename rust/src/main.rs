extern crate hashbrown;

fn main() {
    let start = std::time::Instant::now();
    solution();
    println!("Finished in {:?}", start.elapsed());
}

pub fn solution() {
    let input_str = include_str!("../../input.txt");

    let report_strs = input_str
        .lines()
        .map(|line| line.split_whitespace().map(|i| i.parse::<i32>().unwrap()));

    let mut part1_answer = 0;
    let mut part2_answer = 0;

    for numbers in report_strs {
        let numbers = numbers.collect::<Vec<_>>();
        let length = numbers.len();
        if valid(&numbers) {
            part1_answer += 1;
            part2_answer += 1;
            continue;
        }
        for i in 0..length {
            if valid(&remove_at_index(&numbers, i)) {
                part2_answer += 1;
                break;
            }
        }
    }

    dbg!(part1_answer);
    dbg!(part2_answer);
}

fn valid(line: &Vec<i32>) -> bool {
    let ascending = line[0] > line[1];
    for i in 1..(line).len() {
        let diff = (line[i] - line[i - 1]).abs();
        if diff < 1 || diff > 3 || ascending != (line[i] < line[i - 1]) {
            return false;
        }
    }
    return true;
}

fn remove_at_index(vec: &Vec<i32>, index: usize) -> Vec<i32> {
    let mut new_vec = Vec::with_capacity(vec.len() - 1);
    vec.into_iter()
        .enumerate()
        .filter(|(i, _)| *i != index)
        .for_each(|(_, v)| new_vec.push(*v));
    return new_vec;
}
