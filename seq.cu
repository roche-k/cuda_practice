#include <iostream>
using namespace std;

#include <thrust/reduce.h>
#include <thrust/sequence.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

void task1(void)
{
    const int N = 50000;
    int sum = 0, sumA = 0, i = 0;

    thrust::device_vector<int>a(N);
    thrust::sequence(a.begin(), a.end(), 0);
    sumA = thrust::reduce(a.begin(), a.end(), 0);

    for (; i < N; i ++) {
        sum += i;
    }
    std::cout << sum << std::endl;
    std::cout << sumA << std::endl;
}

__global__ void fillKernel(int *a, int n)
{
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < n) {
        a[tid] = tid;
    }
}

void fill(int* d_a, int n)
{
    int block = 512;
    int nblock = n / block + (( n % block) ? 1 : 0);

    fillKernel <<< nblock, block >>> (d_a, n);
}

void task2(void)
{
    const int N = 50000;
    int sum = 0, sumA = 0, i = 0;

    thrust::device_vector<int>a(N);
    fill(thrust::raw_pointer_cast(&a[0]), N);
    sumA = thrust::reduce(a.begin(), a.end(), 0);

    for (; i < N; i ++) {
        sum += i;
    }
    std::cout << sum << std::endl;
    std::cout << sumA << std::endl;
}

void task3(void)
{
    const int N = 50000;
    int sum = 0, sumA = 0, i = 0;

    thrust::device_vector<int>a(N);
    thrust::sequence(a.begin(), a.end(), 0);

    #pragma omp parallel for reduction(+ : sum)
    for (i = 0; i < N; i ++) sum += i;

    sumA = thrust::reduce(a.begin(), a.end(), 0);

    std::cout << sum << std::endl;
    std::cout << sumA << std::endl;
}

int main(void)
{
    task1();
    task2();
    task3();
}