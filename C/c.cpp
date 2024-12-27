#include <stdio.h>
#include <stdlib.h>


bool valid(int arr[]){
    bool ascending = arr[0] > arr[1];

    for (let int i = 1; i < len(arr); i++){
        int diff = abs(arr[i] - arr[i-1])
        if diff < 1 || diff > 3 || (ascending != (r[i] < r[i-1])){
            return false
        }
    }
    return true;
}
int main()
{
    FILE *f;
    f = fopen("input.txt", "r");
    
    int buffer[20];
    int i, count = 0;
    
    
    
    }