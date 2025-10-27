PROGRAM HorseInCoat;
CONST
  FInName = 'MessageIn';
  FOutName = 'MessageOut';
VAR
  Sent, SentCopy, Line {, FInName, FOutName}: STRING;
  DelimSents, DelimWords: SET OF CHAR;
  FIn, FOut: TEXT;
  I: INTEGER;
  QFlag, WhoFlag, LastFlag: BOOLEAN;
  Ch: CHAR;
BEGIN
  {// проверка на ввод входного файла
  WRITE('Введите имя входного файла: ');
  READLN(FInName);
  IF FInName = ''
  THEN
    BEGIN 
      WRITELN('Ошибка: имя входного файла не может быть пустым.');
      EXIT
    END;
    
  // проверка на ввод выходного файла
  WRITE('Введите имя выходного файла: ');
  READLN(FOutName);
  IF FOutName = ''
  THEN
    BEGIN 
      WRITELN('Ошибка: имя выходного файла не может быть пустым.');
      EXIT
    END;}
    
  ASSIGN(FIn, FInName + '.txt');
  
  // тут какая-то дичь на гну паскале надо запускать я хз что это
  //{$I-} // Отключаем проверку на ошибку
  RESET(FIn);
  //{$I+} // Включаем проверку на ошибку
  {IF IoResult <> 0
  THEN 
    BEGIN 
      WRITELN('Ошибка: не удалось открыть входной файл ', FInName);
      EXIT
    END;}

  I := 1;
  Sent := '';
  DelimSents := ['.', '!', '?'];
  DelimWords := [',', ':', ' '];
  ASSIGN(FOut, FOutName + '.txt');
  REWRITE(FOut);
  WHILE NOT EOF(FIn)
  DO
    BEGIN //_________________ WHILE цикл проверки на вопрос, последнее ли
      READLN(FIn, Line);
      FOR I := 1 TO LENGTH(Line)
      DO
        BEGIN //---------------------------------------------цикл FOR итерации на строку
          CASE Line[I] OF
            '?' : BEGIN QFlag := TRUE END;
            '!' : BEGIN QFlag := FALSE END;
            '.' : BEGIN QFlag := FALSE END;
          ELSE
            Sent := Sent + Line[I]
          END;  
        END //-----------------------------------------------конец FOR
    END; //__________________________________________________конец WHILE NOT EOF
    
  IF QFlag AND WhoFlag AND LastFlag // вывод в выходной файл
  THEN
    BEGIN
      WRITE(FOut, 'Конь в пальто');
      FOR I := 4 TO LENGTH(Sent) - 1
      DO
        WRITE(FOut, Sent[I]);
      WRITE('!')
    END
  ELSE
    WRITE(FOut, 'Спасибо за информацию');
  WRITE('Ответ записан в файл');
  CLOSE(FIn); // закрывает файлы
  CLOSE(FOut)
END.