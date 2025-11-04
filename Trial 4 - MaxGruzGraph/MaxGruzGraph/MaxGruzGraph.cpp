//                 ВОЛИК АНДРЕЙ ОЛЕГОВИЧ ПС-23
//
// 18. Имеется  сеть  автомобильных  дорог. Для  каждой  дороги
// известна максимальная масса груза, которую можно провезти по
// этой   дороге. С   помощью  алгоритма  Дейкстры   определить
// максимальный   груз, который  можно  провезти  между   двумя
// указанными городами. Проиллюстрировать  в  таблице по  шагам 
// этапы поиска (9).

#include <iostream>
#include <fstream>
#include <queue>
#include <sstream>

using std::string; // уаааа что за говно

const int PLUS_INF = 100000000;
const int MINUS_INF = -100000000;

struct City 
{
	int CityNum;
	string CityName;
	std::vector<int> CityPathWeight;
};

void initPaths(std::vector<City>& cityMatrix) 
{
	for (int i = 0; i < cityMatrix.size(); i++) 
	{
		for (int j = 0; j < cityMatrix.size(); j++) 
		{
			cityMatrix[i].CityPathWeight.push_back(0);
		}
	}
}

void readPathWeight(std::ifstream& pathWeights, std::vector<City>& cityMatrix) 
{
	while (!pathWeights.eof()) 
	{
		char temp;
		int baseCity;
		int destinationCity;
		int pathWeight;
		pathWeights >> baseCity;
		pathWeights >> temp;
		pathWeights >> destinationCity;
		pathWeights >> temp;
		pathWeights >> pathWeight;

		cityMatrix[baseCity - 1].CityPathWeight[destinationCity - 1] = pathWeight;
	}
}

std::vector<City> readCityList(std::ifstream& citylist) 
{
	std::vector<City>  cityMatrix;
	while (!citylist.eof()) 
	{
		City temp;
		citylist >> temp.CityNum;
		citylist >> temp.CityName;
		cityMatrix.push_back(temp);
	}
	return cityMatrix;
}

void navigate(const std::vector<City>& cityMatrix, int baseCity, int destinationCity) 
{
	std::vector<int> path(cityMatrix.size(), 0);
	std::vector<int> distance(cityMatrix.size(), 0);
	std::vector<char> visited(cityMatrix.size(), 0);
	int foundVertex, currVertex, minPathWeight, maxWeight;
	minPathWeight = 0;
	string buff, finalOutStr, midStr;

	for (int i = 0; i < cityMatrix.size(); i++) 
	{
		distance[i] = MINUS_INF;
		path[i] = 0;
		visited[i] = false;
	}

	distance[baseCity] = PLUS_INF;
	for (int i = 0; i < cityMatrix.size(); i++) 
	{
		maxWeight = MINUS_INF;
		for (int j = 0; j < cityMatrix.size(); j++) 
		{
			if (!visited[j] && distance[j] >= maxWeight) 
			{
				maxWeight = distance[j];
				currVertex = j;
			}
		}
		visited[currVertex] = true;
		if (distance[currVertex] == MINUS_INF) 
		{
			continue;
		}
		for (int j = 0; j < cityMatrix.size(); j++) 
		{
			if (visited[j]) 
			{
				continue;
			}
			int weight = cityMatrix[currVertex].CityPathWeight[j];
			int maximum = std::min(distance[currVertex], weight);
			if (weight != 0 && maximum > distance[j]) 
			{
				distance[j] = maximum;
				path[j] = currVertex;
			}
		}
	}

	minPathWeight = distance[destinationCity];

	if (minPathWeight != MINUS_INF) 
	{
		foundVertex = path[destinationCity];
		finalOutStr = "Путь до города назначения: ";
		while (foundVertex != 0) 
		{
			buff = std::to_string(foundVertex + 1);
			midStr = cityMatrix[foundVertex].CityName + " (" + buff + ") " + "-> " + midStr;
			foundVertex = path[foundVertex];
		}
		buff = std::to_string(foundVertex + 1);
		midStr = cityMatrix[foundVertex].CityName + " (" + buff + ") " + "-> " + midStr;

		finalOutStr = finalOutStr + midStr + cityMatrix[destinationCity].CityName + " (";
		finalOutStr += std::to_string(destinationCity + 1) + ") ";
		std::cout << finalOutStr << "\n";
	}
	
	if (minPathWeight == MINUS_INF) 
	{
		std::cout << "Максимальный груз из " << cityMatrix[baseCity].CityName;
		std::cout << " в " << cityMatrix[destinationCity].CityName << " невычислим" << "\n";
	} 
	else 
	{
		std::cout << "Максимальный груз из " << cityMatrix[baseCity].CityName;
		std::cout << " в " << cityMatrix[destinationCity].CityName << ": " << minPathWeight << "\n";
	}
}

int main() 
{
	setlocale(LC_ALL, "Rus");
	string cities{};
	string cityRels{};
	std::cout << "Файл справочника городов: ";
	std::cin >> cities;
	std::ifstream cityList{cities};
	std::cout << "Файл связей между городами: ";
	std::cin >> cityRels;
	std::ifstream cityRelations{cityRels};

	std::vector<City> CityMatrix = readCityList(cityList);
	initPaths(CityMatrix);
	readPathWeight(cityRelations, CityMatrix);
	int baseCity{};
	int destinationCity{};
	std::cout << "Номер пункта отправления: ";
	std::cin >> baseCity;
	std::cout << "Номер пункта назначения: ";
	std::cin >> destinationCity;
	
	navigate(CityMatrix, baseCity - 1, destinationCity - 1);
	return 0;
}
