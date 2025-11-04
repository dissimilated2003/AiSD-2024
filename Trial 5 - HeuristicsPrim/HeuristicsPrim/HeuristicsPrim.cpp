//                ВОЛИК АНДРЕЙ ОЛЕГОВИЧ ПС-23
//
// 15. Реализовать  эвристический   алгоритм   решения  задачи
// коммивояжера на неориентированном полном графе на основании
// метода Прима нахождения остовного дерева. Проиллюстрировать
// по шагам этапы поиска (10).

#include <iostream>
#include <fstream>
#include <vector>
#include <limits>
#include <string>

using namespace std;

int computeLoopCost(const vector<int>& tour, const vector<vector<int>>& adj) {
    if (tour.size() < 2) return 0;
    int cost = 0;
    for (int i = 0; i < (int)tour.size() - 1; i++) {
        cost += adj[tour[i]][tour[i + 1]];
    }
    cost += adj[tour.back()][tour.front()];
    return cost;
}

int main() {
    setlocale(LC_ALL, "Rus");
    cout << "Имя входного файла: ";
    string filename{};
    cin >> filename;
    ifstream infile(filename);

    int n{};
    infile >> n;
    if (n < 2) {
        cerr << "Вершин меньше чем 2\n";
        return 1;
    }

    vector<vector<int>> adj(n + 1, vector<int>(n + 1, 0));
    for (int i = 0; i < n * (n - 1) / 2; i++) {
        int u{}, v{}, w{};
        infile >> u >> v >> w;
        adj[u][v] = w;
        adj[v][u] = w;
    }
    int minU = 1, minV = 2;
    int minW = adj[1][2];
    for (int i = 1; i <= n; i++) {
        for (int j = i + 1; j <= n; j++) {
            if (adj[i][j] < minW) {
                minW = adj[i][j];
                minU = i;
                minV = j;
            }
        }
    }

    vector<int> tour{};
    tour.push_back(minU);
    tour.push_back(minV);

    cout << "Найден начальный цикл: (" << minU << ", " << minV
        << ") вес дуги = " << minW << endl;

    vector<bool> visited(n + 1, false);
    visited[minU] = true;
    visited[minV] = true;
    int visitedCount = 2;
    while (visitedCount < n) {
        int bestVertex = -1;
        int bestEdgeWeight = numeric_limits<int>::max();

        for (int v = 1; v <= n; v++) {
            if (!visited[v]) {
                for (int loopVert : tour) {
                    if (adj[v][loopVert] < bestEdgeWeight) {
                        bestEdgeWeight = adj[v][loopVert];
                        bestVertex = v;
                    }
                }
            }
        }

        int insertPos = 0;
        int bestIncrease = numeric_limits<int>::max();
        for (int i = 0; i < (int)tour.size(); i++) {
            int j = (i + 1) % tour.size(); 
            int v_i = tour[i];
            int v_j = tour[j];

            int increase = adj[v_i][bestVertex] + adj[bestVertex][v_j] - adj[v_i][v_j];
            if (increase < bestIncrease) {
                bestIncrease = increase;
                insertPos = j;
            }
        }

        tour.insert(tour.begin() + insertPos, bestVertex);
        visited[bestVertex] = true;
        visitedCount++;

        int currentCost = computeLoopCost(tour, adj);
        cout << "Вставленная вершина: " << bestVertex << ". Текущий цикл: ";
        for (int v : tour) {
            cout << v << "-";
        }
        cout << tour[0] << ". Стоимость цикла: " << currentCost << "\n";
    }

    int finalCost = computeLoopCost(tour, adj);
    cout << "Путь коммивояжера: ";
    for (int v : tour) {
        cout << v << "-";
    }
    cout << tour[0] << ". Стоимость цикла: " << finalCost << "\n";

    return 0;
}
