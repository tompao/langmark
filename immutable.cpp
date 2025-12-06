#include <iostream>
#include <vector>
#include <string>

std::vector<int> qsort(const std::vector<int>& xs) {
    if (xs.size() <= 1) {
        return xs;
    }

    int pivot = xs[0];
    std::vector<int> left;
    std::vector<int> right;
    left.reserve(xs.size());
    right.reserve(xs.size());

    for (size_t i = 1; i < xs.size(); ++i) {
        if (xs[i] < pivot) {
            left.push_back(xs[i]);
        } else {
            right.push_back(xs[i]);
        }
    }

    std::vector<int> sorted_left = qsort(left);
    std::vector<int> sorted_right = qsort(right);

    sorted_left.reserve(sorted_left.size() + 1 + sorted_right.size());
    sorted_left.push_back(pivot);
    sorted_left.insert(sorted_left.end(), sorted_right.begin(), sorted_right.end());
    return sorted_left;
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
    auto ys = qsort(xs);
    if (verbose) {
        for (int v : ys) {
            std::cout << v << " ";
        }
        std::cout << "\n";
    } else {
        for (int i = 0; i < 10; ++i) {
            std::cout << ys[i] << " ";
        }
        std::cout << "\n";
    }
}
