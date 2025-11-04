//                 ВОЛИК АНДРЕЙ ОЛЕГОВИЧ ПС-23
//
// 21.  Трассировка    программы,   не   содержащей   рекурсивных
// вызовов  и  повторяющихся   имен  процедур, распечатана в виде
// списка выполняемых процедур. Процедура попадает в список, если
// к ней произошло обращение из вызывающей процедуры либо возврат
// управления  из  вызванной  ей   процедуры.Структура  программы
// такова, что  каждая вызываемая  процедура вложена в вызывающую
// ее  процедуру. Начало и  окончание  программы  должны  быть  в
// головной процедуре. Известен объем  памяти,  который требуется
// для  загрузки  каждой   процедуры. При  выходе  из   процедуры
// занимаемая ей память  освобождается. Построить и выдать дерево
// вызовов процедур.  Определить размер  памяти, необходимый  для
// работы  программы, и  цепочку вызовов,  требующую максимальной
// памяти (11).

#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

using std::string;

struct Tree 
{
    string FunctionName;
    std::unordered_map<string, Tree*> Children;
};

void printTree(Tree* node, uint32_t Level) 
{
    if (node != nullptr) 
    {
        for (int i = 0; i < Level; i++) 
        {
            std::cout << ".";
        }
        
        std::cout << node->FunctionName << "\n";
        for (auto& entry : node->Children) 
        {
            printTree(entry.second, Level + 1);
        }
    }
};

class MemoryAnalyzer 
{
public:
    const std::unordered_map<string, uint32_t>& functionToMemory;
    uint32_t maxMemory = 0;
    std::vector<string> bufferPath{};
    std::vector<string> maxPath{};

    MemoryAnalyzer(const std::unordered_map<string, uint32_t>& functionToMemory_) : functionToMemory{ functionToMemory_ } {}

    void calculate(Tree* node, uint32_t pathMemory) 
    {
        auto entry = functionToMemory.find(node->FunctionName);
        if (entry == functionToMemory.cend()) 
        {
            std::cout << "Ошибка трассировки\n";
            std::abort();
        }
        uint32_t functionMemory = entry->second;
        
        pathMemory += functionMemory;
        bufferPath.push_back(node->FunctionName);
        if (pathMemory > maxMemory) 
        {
            maxMemory = pathMemory;
            maxPath = bufferPath;
        }

        for (auto& entry : node->Children) 
        {
            calculate(entry.second, pathMemory);
        }
        bufferPath.pop_back();
    }
};

std::unordered_map<string, uint32_t> readWeight(std::ifstream& weights) 
{
    string functionName{};
    uint32_t weight{};
    std::unordered_map<string, uint32_t> memory{};
    while (!weights.eof()) 
    {
        weights >> functionName >> weight;
        memory[functionName] = weight;
    }
    return memory;
}

Tree* createTree(std::ifstream& trace) 
{
    Tree* root = new Tree{};
    trace >> root->FunctionName;

    std::unordered_set<string> knownFunctions{};
    std::vector<Tree*> callStack{};
    callStack.push_back(root);
    knownFunctions.insert(root->FunctionName);

    string functionName{};
    while (!trace.eof()) 
    {
        trace >> functionName;
        if (trace.fail() && trace.eof()) 
        {
            break;
        }

        if (knownFunctions.find(functionName) == knownFunctions.cend()) 
        {
            Tree* node = new Tree{};
            node->FunctionName = functionName;

            Tree* current = callStack.back();
            current->Children[node->FunctionName] = node;

            callStack.push_back(node);
            knownFunctions.insert(node->FunctionName);
            continue;
        }

        Tree* current = callStack.back();
        auto entry = current->Children.find(functionName);
        if (entry != current->Children.cend()) 
        {
            callStack.push_back(entry->second);
            continue;
        }

        callStack.pop_back();
        if (callStack.empty()) 
        {
            break;
        }

        if (functionName != callStack.back()->FunctionName) 
        {
            std::cout << "Ошибка трассировки\n";
            return nullptr;
        }
    }

    if (callStack.size() != 1) 
    {
        std::cout << "Ошибка трассировки\n";
        return nullptr;
    }

    return root;
}

int main() 
{
    setlocale(LC_ALL, "Rus");
    string input1, input2;
    std::cout << "Введите файл трассировки вызовов:" << "\n";
    std::cin >> input1;
    std::cout << "Введите файл требуемой вызовами ОП:" << "\n";
    std::cin >> input2;

    std::ifstream trace{input1};
    Tree* root = createTree(trace);
    printTree(root, 0);
    std::ifstream weights{input2};
    auto memory = readWeight(weights);
    uint32_t counter{};
    MemoryAnalyzer analyzer{memory};
    analyzer.calculate(root, 0);
    std::cout << analyzer.maxMemory << "\n";
    for (auto& node : analyzer.maxPath) 
    {
        std::cout << node << "-" ;
    }
    std::cout << "\n";
    return 0;
}

