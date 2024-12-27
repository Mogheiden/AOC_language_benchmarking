#include <fstream>
#include <iostream>
#include <algorithm>
#include <vector>
#include <sstream>
#include <array>
#include <chrono>
using namespace std::chrono;
using namespace std;

bool valid(std::vector<int> l){
    bool ascending = l[0] > l[1];
    for (int i = 1; i < l.size(); i++){
        int diff = l[i] - l[i-1];
        if (diff < 0){
            diff = diff * -1;
        }
        if (diff < 1 || diff > 3 || (ascending != (l[i] <l[i-1]))){
            return false;
        }
    }
    return true;
}

int main()
{
    std::ifstream infile;
 
    infile.open("../input.txt");
    if (!infile.is_open()) {
        std::cout << "Input file opening failed." << std::endl;
    }
    int part1Answer = 0;
    int part2Answer = 0;

    std::vector<std::vector<int> > fileData;
    std::string line;

    auto startparse = high_resolution_clock::now();
    while (getline(infile, line)) {
    
        std::stringstream ss(line);
        std::vector<int> l;
        std::string currentNum;

        while (std::getline(ss, currentNum, ' ')) {
            l.push_back(stoi(currentNum));
        }
        fileData.push_back(l);
    }
    auto stopparse = high_resolution_clock::now();
    
    auto duration1 = duration_cast<microseconds>(stopparse - startparse);
    cout << duration1.count() << endl;

    auto start = high_resolution_clock::now();

    for (int i = 0; i < fileData.size(); i++) {
        vector<int> level = fileData[i];
    if (valid(level)) {
        part1Answer++;
        part2Answer++;
    } else {
        for (int i = 0; i < level.size(); i++){
            std::vector<int> slicedArray;
            slicedArray.reserve(level.size() - 1);
            for (size_t j = 0; j < level.size(); ++j) {
                if (j != i) {
                    slicedArray.push_back(level[j]);
                }
            }
            if (valid(slicedArray)){
                part2Answer++;
                break;
            }
        }
    }
    }
    // std::cout << part1Answer << std::endl;
    // std::cout << part2Answer << std::endl;
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);
    cout << duration.count() << endl;
}