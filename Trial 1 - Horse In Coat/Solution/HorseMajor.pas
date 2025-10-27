// ВОЛИК АНДРЕЙ ОЛЕГОВИЧ ПС-23

//    23. В текстовом  файле  имеется  некоторое   информационнное
// письмо. Требуется сформировать ответ на письмо. Если  последнее
// предложение письма является  вопросом,  начинающимся  со  слова 
// "кто", то слово "кто"  заменяется  словами  "конь в пальто",  а 
// знак вопроса заменяется на знак восклицания. В противном случае
// нужно дать ответ: "Спасибо за информацию" (8).

PROGRAM HorseMajor;
VAR
  FIn, FOut: TEXT;
  S, T, Last: STRING;
  FInName, FOutName: STRING
  DelimSents, DelimWords: SET OF CHAR;
  I, Len: INTEGER;
FUNCTION CopyStr(const Source: string; StartPos, Length: Integer): string;
BEGIN
  // Проверяем, что начальная позиция не меньше 1 и не больше длины строки
  IF (StartPos < 1) OR (StartPos > Length(Source)) 
  THEN
    CopyStr := ''  // Если начальная позиция неверная, возвращаем пустую строку
  ELSE 
    IF Length < 0 
    THEN
      CopyStr := ''  // Если длина отрицательная, возвращаем пустую строку
  ELSE IF StartPos + Length - 1 > Length(Source) THEN
    CopyStr := Copy(Source, StartPos, Length(Source) - StartPos + 1)  // Корректируем длину
  ELSE
    CopyStr := Copy(Source, StartPos, Length);  // Возвращаем подстроку
END;


BEGIN
  WRITE('Имя входного файла: ');
  READLN(FInName);
  IF FInName = ''
  THEN
    BEGIN
      WRITELN('Ошибка: пустой ввод');
      EXIT
    END;
  WRITE('Имя выходного файла: ');
  READLN(FOutName);
  IF FOutName = ''
  THEN
    BEGIN
      WRITELN('Ошибка: пустой ввод');
      EXIT
    END;
  ASSIGN(FIn, FInName + '.txt');
  RESET(FIn);
  ASSIGN(FOut, FOutName + '.txt');
    
END.