#include <iostream>
#include <vector>
#include <string>

void qsort(std::vector<int>& a, int lo, int hi);

int partition(std::vector<int>& a, int lo, int hi) {
    int pivot = a[hi];
    int i = lo;
    for (int j = lo; j < hi; ++j) {
        if (a[j] < pivot) {
            std::swap(a[i], a[j]);
            ++i;
        }
    }
    std::swap(a[i], a[hi]);
    return i;
}

void qsort(std::vector<int>& a, int lo, int hi) {
    if (lo >= hi) return;
    int p = partition(a, lo, hi);
    qsort(a, lo, p - 1);
    qsort(a, p + 1, hi);
}

int main(int argc, char* argv[]) {
    bool verbose = false;
    bool prePrint = false;
    for (int i = 1; i < argc; ++i) {
        if (std::string(argv[i]) == "-v") {
            verbose = true;
        } else if (std::string(argv[i]) == "-p") {
            prePrint = true;
        }
    }
    std::vector<int> xs(10000);
    for (int i = 0; i < 10000; ++i) {
        xs[i] = (i * 73 + 19) % 10000;
    }
    if (prePrint) {
        std::cout << "Before sorting:\n";
        for (int v : xs) {
            std::cout << v << " ";
        }
        std::cout << "\n";
        return 0;
    }
    if (!xs.empty()) {
        qsort(xs, 0, (int)xs.size() - 1);
    }
    if (verbose) {
        for (int v : xs) {
            std::cout << v << " ";
        }
        std::cout << "\n";
    } else {
        for (int i = 0; i < 10; ++i) {
            std::cout << xs[i] << " ";
        }
        std::cout << "\n";
    }
}
