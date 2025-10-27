//               ВОЛИК АНДРЕЙ ОЛЕГОВИЧ гр. ПС-23
//
//                    2.2. Линейные списки
//
//18. Организовать  в  основной  памяти с помощью указателей
//стек из очередей.Обеспечить   операции   ведения  очереди из
//вершины   стека, расширения   и  сокращения  стека, выдачи
//содержимого стека(9).

#include <iostream>
#include <locale.h>

// FIXME: лучше классом сделать с методами. но т.к это алгоритмы, поэтому посрать
struct Stack
{
	struct Queue
	{
		int Key = 0;
		Queue* NextQ = 0;
	};
	std::string StackName;

	Stack* NextSt = 0;
	Queue* BegQ = 0;
	Queue* EndQ = 0;
};

void Enqueue(Stack::Queue*& Beg, Stack::Queue*& End, int Elem) //добавление в очередь
{
	if (Beg == NULL) // FIXME: тут nullptr лучше
	{
		Beg = new Stack::Queue;
		Beg->Key = Elem;
		End = Beg;
	}
	else
	{
		Stack::Queue* T = new Stack::Queue;
		End->NextQ = T;
		T->Key = Elem;
		End = T;
	}
}

void PopFromQueue(Stack::Queue*& Beg, Stack::Queue*& End) //Удаление из очереди
{
	Stack::Queue* T = Beg;
	if (Beg == End)
	{
		End = 0;
	}
	Beg = Beg->NextQ;
	delete T;
}

void ViewQueue(Stack::Queue*& Beg) //Просмотр содержимого очереди
{
	Stack::Queue* T = Beg;
	while (T)
	{
		std::cout << " " << T->Key;
		T = T->NextQ;
	}
	std::cout << std::endl;
}

void Dequeue(Stack::Queue*& Beg) //Очистка очереди (уд. элемента стека)
{
	while (Beg)
	{
		Stack::Queue* T = Beg;
		Beg = Beg->NextQ;
		delete T;
	}
}

void PushToStack(Stack*& P, std::string Str) //Добавление в стек
{
	Stack* T = new Stack;
	T->StackName = Str;
	T->NextSt = P;
	P = T;
}

void PopFromStack(Stack*& P) //Удаление из стека
{
	Stack* T = P;
	Dequeue(T->BegQ);
	P = P->NextSt;
	delete T;
}

void ViewStack(Stack* P) //Просмотр содержимого стека
{
	Stack* T = P;
	while (T)
	{
		std::cout << " " << T->StackName << ":";
		ViewQueue(T->BegQ);
		T = T->NextSt;
	}
}

void ClearStack(Stack* P) //Очистка стека
{
	while (P)
	{
		Stack* T = P;
		P = P->NextSt;
		Dequeue(T->BegQ);
		delete T;
	}
}

void WorkWithQueue(Stack* P) //Меню работы с очередью
{
	int EntryQ = 1;
	Stack::Queue* B = P->BegQ;
	Stack::Queue* E = P->EndQ;
	while (EntryQ != 5)
	{
		std::cout << "Меню работы с очередью (" << P->StackName << "):" << std::endl << std::endl;
		std::cout << "1) Добавление в очередь" << std::endl;
		std::cout << "2) Продвижение очереди" << std::endl;
		std::cout << "3) Просмотр содержимого очереди" << std::endl;
		std::cout << "4) Очистка очереди" << std::endl;
		std::cout << "5) Перейти к меню работы со СТЕКОМ" << std::endl;
		std::cin >> EntryQ;
		switch (EntryQ)
		{
		case 1: //Добавление в очередь
			int QKey;
			std::cout << "Введите числовое значение: ";
			std::cin >> QKey;
			Enqueue(B, E, QKey);
			std::cout << std::endl;
			break;
		case 2: //Продвижение очереди
			if (B)
			{
				PopFromQueue(B, E);
			}
			else std::cout << "Очередь пустая" << std::endl << std::endl;
			break;
		case 3: //Просмотр содержимого очереди
			if (B)
			{
				ViewQueue(B);
			}
			else std::cout << "Очередь пустая" << std::endl << std::endl;
			break;
		case 4: //Полная очистка очереди
			if (B)
			{
				Dequeue(B);
			}
			else std::cout << "Очередь пустая" << std::endl << std::endl;
			B = 0;
			E = 0;
			break;
		case 5: //Меню работы со стеком
			P->BegQ = B;
			P->EndQ = E;
			break;
		}
	}
}

int main()
{
	setlocale(LC_ALL, "rus");
	system("cls");
	Stack* Top = 0;
	int EntryS = 1;
	while (EntryS != 6)
	{
		std::cout << "Меню работы со стеком очередей: " << std::endl << std::endl;
		std::cout << "1) Добавление в стек" << std::endl;
		std::cout << "2) Удаление из стека" << std::endl;
		std::cout << "3) Просмотр содержимого стека" << std::endl;
		std::cout << "4) Полная очистка стека" << std::endl;
		std::cout << "5) Перейти в меню работы с очередью" << std::endl;
		std::cout << "6) Завершить работу" << std::endl;
		std::cin >> EntryS;
		switch (EntryS)
		{
		case 1: //Добавление очереди в стек
		{
			std::string Name;
			std::cout << "Введите имя очереди: ";
			std::cin >> Name;
			PushToStack(Top, Name);
			break;
		}
		case 2: //Удалить очередь из стека
			if (Top)
			{
				PopFromStack(Top);
			}
			else std::cout << "Стек пустой" << std::endl << std::endl;
			break;
		case 3: //Просмотр содержимого стека
			if (Top)
			{
				ViewStack(Top);
			}
			else std::cout << "Стек пустой" << std::endl << std::endl;
			break;
		case 4: //Полная очистка стека
			if (Top)
			{
				ClearStack(Top);
			}
			else std::cout << "Стек пустой" << std::endl << std::endl;
			Top = 0;
			break;
		case 5: //Меню работы с очередями
			if (Top)
			{
				WorkWithQueue(Top);
			}
			else std::cout << "Стек пустой" << std::endl << std::endl;
			break;
		case 6: //Выход
			ClearStack(Top);
			Top = 0;
			break;
		}
	}
	return 0;

}
